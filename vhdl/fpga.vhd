-- ---------------------------------------------------------------------
-- @file : fpga.vhd for the Lattice XP2 Demoboard
-- ---------------------------------------------------------------------
--
-- Last change: KS 24.01.2021 19:51:19
-- Project : microCore
-- Language : VHDL-2008
-- Last check in : $Rev: 612 $ $Date:: 2020-12-16 #$
-- @copyright (c): Klaus Schleisiek, All Rights Reserved.
--
-- Do not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- https://github.com/microCore-VHDL/microCore/tree/master/documents
-- Software distributed under the License is distributed on an "AS IS"
-- basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
-- See the License for the specific language governing rights and
-- limitations under the License.
--
-- @brief: Top level microCore entity with umbilical debug interface.
--         This file should be edited for technology specific additions
--         like e.g. pad assignments and it is the source of the uBus.
--
-- Version Author   Date       Changes
--           ks    8-Jun-2020  initial version
-- ---------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.functions_pkg.ALL;
USE work.architecture_pkg.ALL;

ENTITY fpga IS PORT (
   reset_n     : IN    STD_LOGIC;
   clock       : IN    STD_LOGIC; -- external clock input
-- Demoboard specific pins
   int_n       : IN    STD_LOGIC; -- external interrupt input
   io          : OUT   STD_LOGIC_VECTOR(17 DOWNTO 0);
   leds_n      : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
   switch_n    : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
-- external SRAM
   ce_n        : OUT   STD_LOGIC;
   oe_n        : OUT   STD_LOGIC;
   we_n        : OUT   STD_LOGIC;
   addr        : OUT   STD_LOGIC_VECTOR(mem_addr_width-1 DOWNTO 0);
   data        : INOUT STD_LOGIC_VECTOR(mem_data_width-1 DOWNTO 0);
-- umbilical uart for debugging
   dsu_rxd     : IN    STD_LOGIC;  -- incoming asynchronous data stream
   dsu_txd     : OUT   STD_LOGIC   -- outgoing data stream
);

ATTRIBUTE LOC       : STRING;
ATTRIBUTE PULLMODE  : STRING;
ATTRIBUTE IO_TYPE   : STRING;
ATTRIBUTE DRIVE     : STRING;
ATTRIBUTE SLEWRATE  : STRING;

ATTRIBUTE LOC      OF reset_n     : SIGNAL IS "156";
   ATTRIBUTE PULLMODE OF reset_n  : SIGNAL IS "UP";
   ATTRIBUTE IO_TYPE  OF reset_n  : SIGNAL IS "LVCMOS33";

ATTRIBUTE LOC      OF clock       : SIGNAL IS "76";
   ATTRIBUTE PULLMODE OF clock    : SIGNAL IS "NONE";
   ATTRIBUTE IO_TYPE  OF clock    : SIGNAL IS "LVCMOS33";

ATTRIBUTE LOC      OF int_n       : SIGNAL IS "104";
   ATTRIBUTE PULLMODE OF int_n    : SIGNAL IS "UP";
   ATTRIBUTE IO_TYPE  OF int_n    : SIGNAL IS "LVCMOS33";

ATTRIBUTE LOC      OF io          : SIGNAL IS "51, 46, 44, 42, 40, 36, 34, 32, 30, 52, 47, 45, 43, 41, 39, 35, 33, 31";
   ATTRIBUTE PULLMODE OF io       : SIGNAL IS "NONE";
   ATTRIBUTE IO_TYPE  OF io       : SIGNAL IS "LVCMOS33";
   ATTRIBUTE DRIVE    OF io       : SIGNAL IS "8";
   ATTRIBUTE SLEWRATE OF io       : SIGNAL IS "SLOW";

ATTRIBUTE LOC      OF leds_n      : SIGNAL IS "74, 73, 72, 69, 68, 67, 66, 65";
   ATTRIBUTE PULLMODE OF leds_n   : SIGNAL IS "NONE";
   ATTRIBUTE IO_TYPE  OF leds_n   : SIGNAL IS "LVCMOS33";
   ATTRIBUTE DRIVE    OF leds_n   : SIGNAL IS "12";
   ATTRIBUTE SLEWRATE OF leds_n   : SIGNAL IS "SLOW";

ATTRIBUTE LOC      OF switch_n    : SIGNAL IS "148, 147, 146, 145";
   ATTRIBUTE PULLMODE OF switch_n : SIGNAL IS "UP";
   ATTRIBUTE IO_TYPE  OF switch_n : SIGNAL IS "LVCMOS33";

ATTRIBUTE LOC      OF dsu_rxd     : SIGNAL IS "55";
   ATTRIBUTE PULLMODE OF dsu_rxd  : SIGNAL IS "NONE";
   ATTRIBUTE IO_TYPE  OF dsu_rxd  : SIGNAL IS "LVCMOS33";

ATTRIBUTE LOC      OF dsu_txd     : SIGNAL IS "56";
   ATTRIBUTE PULLMODE OF dsu_txd  : SIGNAL IS "NONE";
   ATTRIBUTE IO_TYPE  OF dsu_txd  : SIGNAL IS "LVCMOS33";
   ATTRIBUTE DRIVE    OF dsu_txd  : SIGNAL IS "8";
   ATTRIBUTE SLEWRATE OF dsu_txd  : SIGNAL IS "SLOW";

END fpga;

ARCHITECTURE technology OF fpga IS

SIGNAL uBus       : uBus_port;
ALIAS  reset      : STD_LOGIC IS uBus.reset;
ALIAS  clk        : STD_LOGIC IS uBus.clk;
ALIAS  clk_en     : STD_LOGIC IS uBus.clk_en;

SIGNAL dsu_rxd_s  : STD_LOGIC;
SIGNAL dsu_break  : STD_LOGIC;

COMPONENT microcore PORT (
   uBus        : IN    uBus_port;
   core        : OUT   core_signals;
   ext_memory  : OUT   datamem_port;
   ext_rdata   : IN    data_bus;
   dma         : IN    datamem_port;
   dma_rdata   : OUT   data_bus;
-- umbilical uart interface
   rxd         : IN    STD_LOGIC;
   break       : OUT   STD_LOGIC;
   txd         : OUT   STD_LOGIC
); END COMPONENT microcore;

SIGNAL core         : core_signals;
SIGNAL flags        : flag_bus;
SIGNAL flags_pause  : STD_LOGIC;
SIGNAL ctrl         : STD_LOGIC_VECTOR(ctrl_width-1 DOWNTO 0);
SIGNAL ext_memory   : datamem_port;
SIGNAL ext_rdata    : data_bus;
SIGNAL dma          : datamem_port;
SIGNAL dma_rdata    : data_bus;

COMPONENT external_SRAM GENERIC (
   mem_addr_width : NATURAL;
   mem_data_width : NATURAL;
   delay_cnt      : NATURAL    -- delay_cnt+1 extra clock cycles for each memory access
); PORT (
   uBus        : IN    uBus_port;
   enable      : IN    STD_LOGIC;    -- enable signal for specific address range
   ext_memory  : IN    datamem_port;
   ext_rdata   : OUT   data_bus;
   delay       : OUT   STD_LOGIC;
-- external SRAM
   ce_n        : OUT   STD_LOGIC;
   oe_n        : OUT   STD_LOGIC;
   we_n        : OUT   STD_LOGIC;
   addr        : OUT   STD_LOGIC_VECTOR(mem_addr_width-1 DOWNTO 0);
   data        : INOUT STD_LOGIC_VECTOR(mem_data_width-1 DOWNTO 0)
); END COMPONENT external_SRAM;

SIGNAL SRAM_delay   : STD_LOGIC;
SIGNAL leds         : byte;
SIGNAL time_int     : STD_LOGIC;
SIGNAL ioreg        : STD_LOGIC_VECTOR(14 DOWNTO 0);

BEGIN

flags(7 DOWNTO 5) <= (OTHERS => '0');

-- ---------------------------------------------------------------------
-- input signal synchronization
-- ---------------------------------------------------------------------

synch_reset:     synchronize_n PORT MAP(clk, reset_n, reset);
synch_dsu_rxd:   synchronize   PORT MAP(clk, dsu_rxd, dsu_rxd_s);
synch_interrupt: synchronize_n PORT MAP(clk, int_n,   flags(i_ext));

-- ---------------------------------------------------------------------
-- clk generation (perhaps a PLL will be used)
-- ---------------------------------------------------------------------

clk <= clock;

-- ---------------------------------------------------------------------
-- ctrl-register (bitwise)
-- ---------------------------------------------------------------------

with_ctrl: IF  ctrl_width /= 0 GENERATE

ctrl_proc: PROCESS (reset, clk)
BEGIN
   IF  reset = '1' AND async_reset  THEN
      ctrl <= (OTHERS => '0');
   ELSIF  rising_edge(clk)  THEN
      IF  uReg_write(uBus, CTRL_REG)  THEN
         IF  uBus.wdata(signbit) = '0'  THEN
               ctrl <= ctrl OR  uBus.wdata(ctrl'high DOWNTO 0);
         ELSE  ctrl <= ctrl AND uBus.wdata(ctrl'high DOWNTO 0);
         END IF;
      END IF;
      IF  reset = '1' AND NOT async_reset  THEN
         ctrl <= (OTHERS => '0');
      END IF;
   END IF;
END PROCESS ctrl_proc;

flags(f_bitout) <= ctrl(c_bitout);

END GENERATE with_ctrl; no_ctrl: IF  ctrl_width = 0  GENERATE

   ctrl <= (OTHERS => '0');

END GENERATE no_ctrl;

uBus.sources(CTRL_REG) <= slice('0', data_width - ctrl_width) & ctrl;

-- ---------------------------------------------------------------------
-- software semaphor f_sema using flag register
-- ---------------------------------------------------------------------

sema_proc : PROCESS (clk, reset)
BEGIN
   IF  reset = '1' AND async_reset  THEN
      flags(f_sema) <= '0';
   ELSIF  rising_edge(clk)  THEN
      IF  uReg_write(uBus, FLAG_REG)  THEN
         IF  (uBus.wdata(signbit) XOR uBus.wdata(f_sema)) = '1'  THEN
            flags(f_sema) <= uBus.wdata(f_sema);
         END IF;
      END IF;
      IF  reset = '1' AND NOT async_reset  THEN
         flags(f_sema) <= '0';
      END IF;
   END IF;
END PROCESS sema_proc;

flags_pause <= '1' WHEN  uReg_write(uBus, FLAG_REG) AND uBus.wdata(signbit) = '0' AND
                         (uBus.wdata(flag_width-1 DOWNTO 0) AND flags) /= slice('0', flag_width)
               ELSE  '0';

-- ---------------------------------------------------------------------
-- microcore interface
-- ---------------------------------------------------------------------

dma.enable <= '0';
dma.write  <= '0';
dma.addr   <= (OTHERS => '0');
dma.wdata  <= (OTHERS => '0');

flags(f_dsu) <= NOT dsu_break; -- '1' if debug terminal present

uCore: microcore PORT MAP (
   uBus       => uBus,
   core       => core,
   ext_memory => ext_memory,
   ext_rdata  => ext_rdata,
   dma        => dma,
   dma_rdata  => dma_rdata,
-- umbilical uart interface
   rxd        => dsu_rxd_s,
   break      => dsu_break,
   txd        => dsu_txd
);

-- control signals
--ALIAS  reset        : STD_LOGIC IS uBus.reset;
--ALIAS  clk          : STD_LOGIC IS uBus.clk;
uBus.clk_en               <= core.clk_en;
uBus.chain                <= core.chain;
uBus.pause                <= flags_pause;
uBus.delay                <= SRAM_delay;
uBus.tick                 <= core.tick;
-- registers
uBus.sources(STATUS_REG)  <= slice('0', data_width - status_width) & core.status;
uBus.sources(DSP_REG)     <= slice('0', data_width - dsp_width) & core.dsp;
uBus.sources(RSP_REG)     <= addr_rstack_v(data_width-1 DOWNTO rsp_width) & core.rsp;
uBus.sources(INT_REG)     <= slice('0', data_width - interrupts) & core.int;
uBus.sources(FLAG_REG)    <= slice('0', data_width - flag_width) & flags;
uBus.sources(VERSION_REG) <= to_vec(version, data_width);
uBus.sources(DEBUG_REG)   <= core.debug;
uBus.sources(TIME_REG)    <= core.time;
uBus.sources(LED_REG)     <= slice('0', data_width - 8) & leds;
uBus.sources(IO_REG)      <= slice('0', data_width - 15) & ioreg;
-- data memory and return stack
uBus.reg_en               <= core.reg_en;
uBus.reg_addr             <= core.reg_addr;
uBus.enable               <= ext_memory.enable;
uBus.write                <= ext_memory.write;
uBus.addr                 <= ext_memory.addr;
uBus.wdata                <= ext_memory.wdata;
uBus.dma_rdata            <= dma_rdata;

-- ---------------------------------------------------------------------
-- board specific IO
-- ---------------------------------------------------------------------

io <= "000" & ioreg;

ioreg_proc : PROCESS (clk)
BEGIN
   IF  rising_edge(clk)  THEN
      IF  uReg_write(uBus, IO_REG)  THEN
         IF  uBus.wdata(signbit) = '1'  THEN
            ioreg <= ioreg AND uBus.wdata(14 DOWNTO 0);
         ELSE
            ioreg <= ioreg OR  uBus.wdata(14 DOWNTO 0);
         END IF;
      END IF;
      IF  reset = '1'  THEN
         ioreg <= (OTHERS => '0');
      END IF;
   END IF;
END PROCESS ioreg_proc;

leds_n <= NOT leds;

led_proc: PROCESS (reset, clk)
BEGIN
   IF  reset = '1' AND async_reset  THEN
      leds <= (OTHERS => '0');
   ELSIF  rising_edge(clk)  THEN
      IF  uReg_write(uBus, LED_REG)  THEN
         leds <= uBus.wdata(7 DOWNTO 0);
      END IF;
      IF  reset = '1' AND NOT async_reset  THEN
         leds <= (OTHERS => '0');
      END IF;
   END IF;
END PROCESS led_proc;

flags(f_sw1) <= NOT switch_n(0);
flags(f_sw2) <= NOT switch_n(1);
flags(f_sw3) <= NOT switch_n(2);
flags(f_sw4) <= NOT switch_n(3);

time_int_proc : PROCESS (clk)
BEGIN
   IF  rising_edge(clk)  THEN
      IF  uBus.tick = '1'  THEN
         time_int <= '1';
      END IF;
      IF  uReg_write(uBus, FLAG_REG) AND uBus.wdata(signbit) = '1' AND uBus.wdata(i_time) = '0'  THEN
         time_int <= '0';
      END IF;
   END IF;
END PROCESS time_int_proc;

flags(i_time) <= time_int;

-- ---------------------------------------------------------------------
-- external SRAM data memory
-- ---------------------------------------------------------------------

with_ext_mem: IF  data_addr_width > cache_addr_width  GENERATE

   SRAM: external_SRAM
   GENERIC MAP (mem_addr_width, mem_data_width, 2)
   PORT MAP (
      uBus        => uBus,
      enable      => ext_memory.enable,
      ext_memory  => ext_memory,
      ext_rdata   => ext_rdata,
      delay       => SRAM_delay,
   -- external SRAM
      ce_n        => ce_n,
      oe_n        => oe_n,
      we_n        => we_n,
      addr        => addr,
      data        => data
);

END GENERATE with_ext_mem; no_ext_mem: IF  data_addr_width <= cache_addr_width  GENERATE

   ext_rdata  <= (OTHERS => '0');
   SRAM_delay <= '0';

   ce_n <= 'Z';
   we_n <= 'Z';
   oe_n <= 'Z';
   addr <= (OTHERS => 'Z');
   data <= (OTHERS => 'Z');

END GENERATE no_ext_mem;

END technology;