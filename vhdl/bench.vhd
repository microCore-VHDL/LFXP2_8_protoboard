-- ---------------------------------------------------------------------
-- @file : bench.vhd testbench for the XP2-8E Demoboard
-- ---------------------------------------------------------------------
--
-- Last change: KS 24.03.2021 17:41:32
-- @project: microCore
-- @language: VHDL-93
-- @copyright (c): Klaus Schleisiek, All Rights Reserved.
-- @contributors:
--
-- @license: Do not use this file except in compliance with the License.
-- You may obtain a copy of the Public License at
-- https://github.com/microCore-VHDL/microCore/tree/master/documents
-- Software distributed under the License is distributed on an "AS IS"
-- basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
-- See the License for the specific language governing rights and
-- limitations under the License.
--
-- @brief: General simulation test bench for microCore with RS232 umbilical
-- interface. Following ARCHITECTURE, one out of a set of constants can be
-- set to '1' in order to test specific aspects of debugger.vhd.
-- When all of the constants are set to '0', bootload_sim.vhd will be
-- executed that has been cross-compiled from bootload_sim.fs.
-- The program memory will be initialized at the start of simulation when
-- MEM_FILE := "../software/program.mem". Program.mem will be generated by
-- the cross compiler.
--
-- Version Author   Date       Changes
--   210     ks    8-Jun-2020  initial version
--  2300     ks   11-Mar-2021  update of umbilical tests
--                             STD_LOGIC_(UN)SIGNED replaced by NUMERIC_STD
-- ---------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;
USE work.functions_pkg.ALL;
USE work.architecture_pkg.ALL;

ENTITY bench IS
END bench;

ARCHITECTURE testbench OF bench IS

CONSTANT prog_len   : NATURAL := 10;    -- length of sim_boot.fs
CONSTANT progload   : STD_LOGIC := '0'; -- use sim_progload.fs   progload.do   MEM_file := ""                         90 usec
CONSTANT debug      : STD_LOGIC := '0'; -- use sim_debug.fs      debug.do      MEM_FILE := "../software/program.mem"  90 usec
CONSTANT handshake  : STD_LOGIC := '0'; -- use sim_handshake.fs  handshake.do  MEM_FILE := "../software/program.mem" 160 usec
CONSTANT upload     : STD_LOGIC := '0'; -- use sim_upload.fs     upload.do     MEM_FILE := "../software/program.mem" 135 usec
CONSTANT download   : STD_LOGIC := '0'; -- use sim_updown.fs     download.do   MEM_FILE := "../software/program.mem"  80 usec
CONSTANT break      : STD_LOGIC := '0'; -- use sim_break.fs      break.do      MEM_FILE := "../software/program.mem" 220 usec

COMPONENT fpga PORT (
   reset_n     : IN    STD_LOGIC;
   clock       : IN    STD_LOGIC; -- external clock input
-- Demoboard specific pins
   int_n       : IN    STD_LOGIC; -- external interrupt input
   io          : OUT   UNSIGNED(17 DOWNTO 0);
   leds_n      : OUT   byte;
   switch_n    : IN    UNSIGNED(3 DOWNTO 0);
-- external SRAM
   ce_n        : OUT   STD_LOGIC;
   oe_n        : OUT   STD_LOGIC;
   we_n        : OUT   STD_LOGIC;
   addr        : OUT   UNSIGNED(ram_addr_width-1 DOWNTO 0);
   data        : INOUT UNSIGNED(ram_data_width-1 DOWNTO 0);
-- umbilical port for debugging
   dsu_rxd     : IN    STD_LOGIC;  -- incoming asynchronous data stream
   dsu_txd     : OUT   STD_LOGIC   -- outgoing data stream
); END COMPONENT fpga;

SIGNAL reset_n    : STD_LOGIC;
SIGNAL xtal       : STD_LOGIC;
SIGNAL int_n      : STD_LOGIC;
SIGNAL bitout     : STD_LOGIC;

COMPONENT program_rom PORT (
   addr  : IN    program_addr;
   data  : OUT   inst_bus
); END COMPONENT;

SIGNAL debug_data   : inst_bus;
SIGNAL debug_addr   : program_addr;

SIGNAL dsu_rxd      : STD_LOGIC;
SIGNAL dsu_txd      : STD_LOGIC;
SIGNAL tx_buf       : byte;
SIGNAL send_ack     : STD_LOGIC;
SIGNAL send_debug   : STD_LOGIC;
SIGNAL sending      : STD_LOGIC;
SIGNAL downloading  : STD_LOGIC;
SIGNAL uploading    : STD_LOGIC;
SIGNAL host_reg     : UNSIGNED((octetts*8)-1 DOWNTO 0);
SIGNAL out_buf      : UNSIGNED((octetts*8)-1 DOWNTO 0);
SIGNAL host_buf     : byte;
SIGNAL host_ready   : STD_LOGIC; -- umbilical received a byte
SIGNAL host_full    : STD_LOGIC; -- umbilical received a data word
SIGNAL host_ack     : STD_LOGIC; -- umbilical received an ack
SIGNAL responding   : STD_LOGIC;

CONSTANT xtal_cycle : TIME := (1000000000 / xtal_frequency) * 1 ns;
CONSTANT cycle      : TIME := (1000000000 / clk_frequency) * 1 ns;
CONSTANT baud       : TIME := (cycle*clk_frequency)/umbilical_rate;
--CONSTANT int_time   : TIME := 114260 ns + 8 * 40 ns; -- sim_handshake test
CONSTANT int_time   : TIME := 26500 ns + 0 * 40 ns;

-- Demoboard specific signals
SIGNAL switch_n     : UNSIGNED(3 DOWNTO 0);
SIGNAL leds_n       : byte;

SIGNAL ext_ce_n     : STD_LOGIC;
SIGNAL ext_oe_n     : STD_LOGIC;
SIGNAL ext_we_n     : STD_LOGIC;
SIGNAL ext_addr     : UNSIGNED(ram_addr_width-1 DOWNTO 0);
SIGNAL ext_data     : UNSIGNED(ram_data_width-1 DOWNTO 0);

BEGIN

-- ---------------------------------------------------------------------
-- Test vector generation
-- ---------------------------------------------------------------------

int_n <= '1', '0' AFTER int_time, '1' AFTER int_time + 600 ns;

bitout <= NOT leds_n(0);

-- ---------------------------------------------------------------------
-- Communicating with the uCore debugger via umbilical
-- ---------------------------------------------------------------------

make_initROM: IF  prog_len /= 0  GENERATE
   debug_mem: program_rom PORT MAP(debug_addr, debug_data);
END GENERATE make_initROM;

umbilical_proc: PROCESS

	VARIABLE text  : line;

   PROCEDURE send_byte (number : IN byte) IS
   BEGIN
     WHILE  sending = '1' LOOP WAIT FOR cycle; END LOOP;
     send_debug <= '1';
     tx_buf <= number;
     WAIT UNTIL sending = '1';
     send_debug <= '0';
     tx_buf <= (OTHERS => 'Z');
   END send_byte;

   PROCEDURE send2core (number : IN data_bus) IS
   BEGIN
     out_buf <= (OTHERS => '0');
     out_buf(data_width-1 DOWNTO 0) <= number;
     FOR  i IN octetts DOWNTO 1  LOOP
        send_byte(out_buf(i*8-1 DOWNTO (i-1)*8));
     END LOOP;
   END send2core;

   PROCEDURE wait_ack IS
   BEGIN
      WHILE NOT (host_full = '1' AND host_buf = mark_ack) LOOP  WAIT FOR cycle;  END LOOP;
      host_ack <= '1';
      WAIT UNTIL host_full = '0';
      WAIT FOR cycle;
      host_ack <= '0';
   END wait_ack;

   PROCEDURE rx_debug (number : IN data_bus) IS
   BEGIN
      responding <= '1';
      WHILE NOT (host_full = '1' AND host_reg(data_width-1 DOWNTO 0) = number)  LOOP  WAIT FOR cycle;  END LOOP;
      host_ack <= '1';
      WAIT UNTIL host_full = '0';
      WAIT FOR cycle;
      host_ack <= '0';
      responding <= '0';
   END rx_debug;

   PROCEDURE tx_debug ( number : IN data_bus) IS
   BEGIN
      send_byte(mark_debug);
      send2core(number);
      wait_ack;
   END tx_debug;

BEGIN
   switch_n     <= (OTHERS => '0');
   reset_n      <= '0';
   send_debug   <= '0';
   tx_buf       <= "ZZZZZZZZ";
   host_ack     <= '0';
   responding   <= '0';
   downloading  <= '0';
   uploading    <= '0';
   debug_addr   <= (OTHERS => '0');
   WAIT FOR 1000 ns;
   reset_n      <= '1';

   WAIT FOR 45 us;

   IF  prog_len /= 0 AND progload = '1'  THEN
		text := NEW string'("starting progload test ...");
      writeline(output, text);

-- send a string of NAK's, just in case
      FOR  i IN octetts DOWNTO 1  LOOP
         send_byte(mark_nack);
      END LOOP;
-- load memory with reset
      send_byte(mark_reset);  -- $CC
      send2core(to_unsigned(0, data_width));        -- start address
      send2core(to_unsigned(prog_len, data_width)); -- length
      FOR  i IN 0 TO  prog_len-1  LOOP         -- transfer memory image
         debug_addr <= to_unsigned(i, prog_addr_width);
         send_byte(debug_data);
      END LOOP;
      wait_ack;
		text := NEW string'("progload test ok ");
      writeline(output, text);
      WAIT;
   END IF;

   IF  handshake = '1'  THEN -- debugger handshake see: monitor.fs
		text := NEW string'("starting handshake test ...");
      writeline(output, text);
      tx_debug(to_unsigned(0, data_width));
      rx_debug(slice('1', data_width));
      tx_debug(to_unsigned(16#5F5#, data_width));
      rx_debug(to_unsigned(16#505#, data_width));
      tx_debug(to_unsigned(0, data_width));
-- entering monitor loop
      rx_debug (to_unsigned(0, data_width)); -- now monitor waits for executable address

-- transfer "#c-bitout Ctrl-reg ! EXIT" to addr $200 and execute it
      send_byte(mark_start);
      send2core(to_unsigned(16#200#, data_width)); -- addr
      send2core(to_unsigned( 6, data_width));      -- length
      send_byte(to_unsigned(exp2(c_bitout) + 128, 8));
      send_byte(op_NOOP);
      send_byte(unsigned(to_signed(CTRL_REG, 8)));
      send_byte(op_STORE);
      send_byte(op_DROP);
      send_byte(op_EXIT);
      wait_ack; -- now uCore waits for an execution address
      tx_debug(to_unsigned(16#200#, data_width)); -- execute it
      rx_debug (to_unsigned(0, data_width));
		text := NEW string'("handshake test ok ");
      writeline(output, text);
      WAIT;
   END IF;

   IF  debug = '1'  THEN
		text := NEW string'("starting debug register test ...");
      writeline(output, text);
      tx_debug(to_unsigned(16#8001#, data_width));
      rx_debug(to_unsigned(16#8001#, data_width));
      tx_debug(to_unsigned(16#4002#, data_width));
      rx_debug(to_unsigned(16#4002#, data_width));
		text := NEW string'("debug register test ok ");
      writeline(output, text);
      WAIT;
   END IF;

   IF  upload = '1'  THEN  -- upload to data memory
		text := NEW string'("starting upload test ...");
      writeline(output, text);
      WAIT FOR 0 * 40 ns;
      uploading <= '1';
      send_byte(mark_upload);
      send2core(to_unsigned(10, data_width)); -- start address internal memory
      send2core(to_unsigned( 4, data_width)); -- length
      FOR i IN 1 TO 4 LOOP
         send2core(to_unsigned((256+i), data_width));
      END LOOP;
      wait_ack;
      uploading <= '0';
      WAIT FOR cycle;
      IF  data_addr_width > cache_addr_width  THEN
         uploading <= '1';
         send_byte(mark_upload);
         send2core(to_unsigned(exp2(cache_addr_width), data_width)); -- start address external memory
         send2core(to_unsigned( 4, data_width));                     -- length
         FOR i IN 5 TO 8 LOOP
            send2core(to_unsigned((256+i), data_width));
         END LOOP;
         wait_ack;
         uploading <= '0';
      END IF;
      WHILE  bitout = '0'  LOOP WAIT FOR cycle;  END LOOP;
		text := NEW string'("upload test ok ");
      writeline(output, text);
      WAIT;
   END IF;

   IF  download = '1'  THEN  -- download from data memory
		text := NEW string'("starting download test ...");
      writeline(output, text);
      WAIT FOR 1200 ns + 3 * 40 ns;
      downloading <= '1';
      send_byte(mark_download);
      send2core(to_unsigned(1, data_width)); -- start address internal memory
      send2core(to_unsigned(2, data_width)); -- length
      rx_debug(to_unsigned(16#1122#, data_width));
      rx_debug(to_unsigned(16#3344#, data_width));
      send_byte(mark_ack);
      downloading <= '0';
      WAIT FOR cycle;
      IF  data_addr_width > cache_addr_width  THEN
         downloading <= '1';
         send_byte(mark_download);
         send2core(to_unsigned(exp2(cache_addr_width), data_width)); -- start address external memory
         send2core(to_unsigned(2, data_width)); -- length
         rx_debug(to_unsigned(16#5566#, data_width));
         rx_debug(to_unsigned(16#7788#, data_width));
         send_byte(mark_ack);
         downloading <= '0';
      END IF;
		text := NEW string'("download test ok ");
      writeline(output, text);
      WAIT;
   END IF;

   IF  break = '1'  THEN -- multitasking: put terminal to sleep
		text := NEW string'("starting break test ...");
      writeline(output, text);
      WAIT FOR 80 us;
      send_byte(mark_break);  -- put terminal to sleep
      WAIT FOR 80 us;
      send_byte(mark_nbreak); -- wake terminal again
      WHILE  bitout = '0'  LOOP WAIT FOR cycle;  END LOOP;
		text := NEW string'("break test ok ");
      writeline(output, text);
      WAIT;
   END IF;

-- coretest
   text := NEW string'("starting core test ...");
   writeline(output, text);
   WAIT UNTIL bitout = '1';
   WAIT UNTIL bitout = '0';
   WAIT UNTIL bitout = '1';
   ASSERT false REPORT "core test ok" SEVERITY note;
   WAIT;

END PROCESS umbilical_proc;

to_target_proc : PROCESS

   VARIABLE number : byte := (OTHERS => 'Z');

   PROCEDURE tx_uart IS
   BEGIN
      sending <= '1';
      dsu_txd <= '0';
      WAIT FOR baud;
      FOR  i IN 0 TO 7  LOOP
        dsu_txd <= number(i);
        WAIT FOR baud;
      END LOOP;
      dsu_txd <= '1';
      WAIT FOR baud/2;
      sending <= '0';
      WAIT FOR baud/2; -- wait for full stop bit
   END tx_uart;

BEGIN

  dsu_txd <= '1';
  sending <= '0';
  WAIT FOR 980 ns;
  LOOP
     WHILE  send_ack = '0' AND send_debug = '0'  LOOP  WAIT FOR cycle; END LOOP;
     IF  send_ack = '1'  THEN
        number := mark_ack;
     ELSE
        number := tx_buf;
     END IF;
     WAIT FOR 1 ns;
     tx_uart;
  END LOOP;

END PROCESS to_target_proc ;

from_target_proc : PROCESS

   PROCEDURE rx_uart IS
   BEGIN
     WHILE  dsu_rxd /= '0'  LOOP WAIT FOR cycle/2; END LOOP;
     WAIT FOR baud/2;
     host_buf <= (OTHERS => '0');
     FOR  i IN 0 TO 7  LOOP
        WAIT FOR baud;
        host_buf(i) <= dsu_rxd;
     END LOOP;
     host_ready <= '1';
     WAIT FOR baud/2;
     host_ready <= '0';
   END rx_uart;

BEGIN
   send_ack <= '0';
   host_full <= '0';
   host_buf <= (OTHERS => '0');
   host_reg <= (OTHERS => '1');
   WAIT FOR 1 us;
   LOOP
      host_full <= '0';
      WHILE  dsu_rxd = '1'  LOOP WAIT FOR cycle;  END LOOP;
      IF  downloading = '1'  THEN
         FOR i IN octetts-1 DOWNTO 0 LOOP
            rx_uart;
            EXIT WHEN i = 0 AND host_buf = mark_ack;
            host_reg <= host_reg(host_reg'high-8 DOWNTO 0) & host_buf;
         END LOOP;
         host_full <= '1';
         WAIT FOR baud/2;
      ELSE
         rx_uart;
         IF  host_buf = mark_ack  THEN
            host_full <= '1';
            WAIT UNTIL host_ack = '1';
            host_full <= '0';
            WAIT UNTIL host_ack = '0';
         ELSIF  host_buf = mark_debug  THEN
            FOR i IN octetts-1 DOWNTO 0 LOOP
               rx_uart;
               host_reg <= host_reg(host_reg'high-8 DOWNTO 0) & host_buf;
            END LOOP;
            host_full <= '1';
            WAIT FOR 1 us;
            WHILE  sending = '1' LOOP WAIT FOR cycle/2; END LOOP;
            send_ack <= '1';
            WAIT UNTIL sending = '1';
            send_ack <= '0';
            host_full <= '0';
         END IF;
      END IF;
   END LOOP;

END PROCESS from_target_proc ;

-- ---------------------------------------------------------------------
-- The clock oscillator
-- ---------------------------------------------------------------------

xtal_clock: PROCESS
BEGIN
  xtal <= '0';
  WAIT FOR 500 ns;
  LOOP
    xtal <= '1';
    WAIT FOR xtal_cycle/2;
    xtal <= '0';
    WAIT FOR xtal_cycle/2;
  END LOOP;
END PROCESS xtal_clock;

-- ---------------------------------------------------------------------
-- external SRAM
-- ---------------------------------------------------------------------

ext_SRAM: external_ram
GENERIC MAP (ram_data_width, ram_addr_width)
PORT MAP (
   ce_n   => ext_ce_n,
   oe_n   => ext_oe_n,
   we_n   => ext_we_n,
   addr   => ext_addr,
   data   => ext_data
);

-- ---------------------------------------------------------------------
-- uCore FPGA
-- ---------------------------------------------------------------------

myFPGA: fpga PORT MAP (
   reset_n    => reset_n,
   clock      => xtal,
-- Demoboard specific pins
   int_n      => int_n,
--   io          : OUT   UNSIGNED(17 DOWNTO 0);
   leds_n     => leds_n,
   switch_n   => switch_n,
-- external SRAM
   ce_n       => ext_ce_n,
   oe_n       => ext_oe_n,
   we_n       => ext_we_n,
   addr       => ext_addr,
   data       => ext_data,
-- umbilical port for debugging
   dsu_rxd    => dsu_txd, -- incoming data stream
   dsu_txd    => dsu_rxd  -- outgoing data stream
);

END testbench;
