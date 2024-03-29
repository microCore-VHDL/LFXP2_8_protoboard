-- ---------------------------------------------------------------------
-- @file : uDatacache_32.vhd
-- ---------------------------------------------------------------------
--
-- Last change: KS 01.11.2022 19:01:28
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
-- @brief: Definition of the internal data memory.
-- Here fpga specific dual port memory IP for 32 bits has been included.
-- Parameters for 32 bits are:
-- CONSTANT data_width         : NATURAL := 32; -- data bus width
-- CONSTANT cache_size         : NATURAL := 16#C00#; -- data cache memory size
-- CONSTANT addr_rstack        : NATURAL := 16#800#; -- beginning of the return stack, must be a multiple of 2**rsp_width
--
-- Version Author   Date       Changes
--   210     ks    8-Jun-2020  initial version
--  2300     ks    8-Mar-2021  Conversion to NUMERIC_STD
--  2400     ks   17-Jun-2022  byte addressing using byte_addr_width
-- ---------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.functions_pkg.ALL;
USE work.architecture_pkg.ALL;

ENTITY uDatacache IS PORT (
   uBus        : IN  uBus_port;
   rdata       : OUT data_bus;
   dma_mem     : IN  datamem_port;
   dma_rdata   : OUT data_bus
); END uDatacache;

ARCHITECTURE rtl OF uDatacache IS

ALIAS clk            : STD_LOGIC IS uBus.clk;
ALIAS clk_en         : STD_LOGIC IS uBus.clk_en;
ALIAS mem_en         : STD_LOGIC IS uBus.mem_en;
ALIAS bytes          : byte_type IS uBus.bytes;
ALIAS write          : STD_LOGIC IS uBus.write;
ALIAS addr           : data_addr IS uBus.addr;
ALIAS wdata          : data_bus  IS uBus.wdata;
ALIAS dma_enable     : STD_LOGIC IS dma_mem.enable;
ALIAS dma_bytes      : byte_type IS dma_mem.bytes;
ALIAS dma_write      : STD_LOGIC IS dma_mem.write;
ALIAS dma_addr       : data_addr IS dma_mem.addr;
ALIAS dma_wdata      : data_bus  IS dma_mem.wdata;

SIGNAL enable        : STD_LOGIC;

SIGNAL bytes_en      : byte_addr;
SIGNAL mem_wdata     : data_bus;
SIGNAL mem_rdata     : data_bus;

SIGNAL dma_bytes_en  : byte_addr;
SIGNAL dma_mem_wdata : data_bus;
SIGNAL dma_mem_rdata : data_bus;

-- internal_datamem has been generated by IP-Express, Memory, EBR with the following parameters:
-- RAM_DQ, Depth 3072, WidthA 32, Normal, Big-Endian
COMPONENT internal_datamem_32 PORT (
   Clock    : IN  STD_LOGIC;
   ClockEn  : IN  STD_LOGIC;
   Reset    : IN  STD_LOGIC;
   WE       : IN  STD_LOGIC;
   Address  : IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
   Data     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
   Q        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
); END COMPONENT internal_datamem_32;

SIGNAL slv_mem_rdata  : STD_LOGIC_VECTOR(rdata'range);
SIGNAL slv_dma_rdata  : STD_LOGIC_VECTOR(rdata'range);

BEGIN

enable <= clk_en AND mem_en;

make_sim_mem: IF  SIMULATION  GENERATE

   internal_data_mem: internal_dpram
   GENERIC MAP (data_width, cache_size, "rw_check", DMEM_file)
   PORT MAP (
      clk     => clk,
      ena     => enable,
      wea     => write,
      addra   => addr(cache_addr_width-1 DOWNTO 0),
      dia     => wdata,
      doa     => rdata,
   -- dma port
      enb     => dma_enable,
      web     => dma_write,
      addrb   => dma_addr(cache_addr_width-1 DOWNTO 0),
      dib     => dma_wdata,
      dob     => dma_rdata
   );

END GENERATE make_sim_mem; make_syn_mem: IF  NOT SIMULATION  GENERATE
-- instantiate FPGA specific IP for cell addressed memory here:

   instantiated_data_mem: internal_datamem_32
   PORT MAP (
      Clock     => clk,
      ClockEn   => enable,
      Reset     => '0',
      WE        => write,
      Address   => std_logic_vector(addr(cache_addr_width-1 DOWNTO 0)),
      Data      => std_logic_vector(wdata),
      Q         => slv_mem_rdata
   );

   rdata     <= unsigned(slv_mem_rdata);
   dma_rdata <= (OTHERS => '0');

END GENERATE make_syn_mem;

END rtl;

-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.10.3.144
-- Module  Version: 7.5
--C:\lscc\diamond\3.10_x64\ispfpga\bin\nt64\scuba.exe -w -n internal_datamem_32 -lang vhdl -synth synplify -bus_exp 7 -bb -arch mg5a00 -type bram -wp 10 -rp 1000 -addr_width 12 -data_width 32 -num_rows 3072 -writemode NORMAL -resetmode SYNC -cascade -1

-- Sat Nov 16 18:21:30 2019

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library xp2;
use xp2.components.all;
-- synopsys translate_on

entity internal_datamem_32 is
    port (
        Clock: in  std_logic;
        ClockEn: in  std_logic;
        Reset: in  std_logic;
        WE: in  std_logic;
        Address: in  std_logic_vector(11 downto 0);
        Data: in  std_logic_vector(31 downto 0);
        Q: out  std_logic_vector(31 downto 0));
end internal_datamem_32;

architecture Structure of internal_datamem_32 is

    -- internal signal declarations
    signal wren_inv: std_logic;
    signal scuba_vhi: std_logic;
    signal scuba_vlo: std_logic;
    signal wren_inv_g: std_logic;
    signal mdout0_1_0: std_logic;
    signal mdout0_0_0: std_logic;
    signal mdout0_1_1: std_logic;
    signal mdout0_0_1: std_logic;
    signal mdout0_1_2: std_logic;
    signal mdout0_0_2: std_logic;
    signal mdout0_1_3: std_logic;
    signal mdout0_0_3: std_logic;
    signal mdout0_1_4: std_logic;
    signal mdout0_0_4: std_logic;
    signal mdout0_1_5: std_logic;
    signal mdout0_0_5: std_logic;
    signal mdout0_1_6: std_logic;
    signal mdout0_0_6: std_logic;
    signal mdout0_1_7: std_logic;
    signal mdout0_0_7: std_logic;
    signal mdout0_1_8: std_logic;
    signal mdout0_0_8: std_logic;
    signal mdout0_1_9: std_logic;
    signal mdout0_0_9: std_logic;
    signal mdout0_1_10: std_logic;
    signal mdout0_0_10: std_logic;
    signal mdout0_1_11: std_logic;
    signal mdout0_0_11: std_logic;
    signal mdout0_1_12: std_logic;
    signal mdout0_0_12: std_logic;
    signal mdout0_1_13: std_logic;
    signal mdout0_0_13: std_logic;
    signal mdout0_1_14: std_logic;
    signal mdout0_0_14: std_logic;
    signal mdout0_1_15: std_logic;
    signal mdout0_0_15: std_logic;
    signal mdout0_1_16: std_logic;
    signal mdout0_0_16: std_logic;
    signal mdout0_1_17: std_logic;
    signal mdout0_0_17: std_logic;
    signal mdout0_1_18: std_logic;
    signal mdout0_0_18: std_logic;
    signal mdout0_1_19: std_logic;
    signal mdout0_0_19: std_logic;
    signal mdout0_1_20: std_logic;
    signal mdout0_0_20: std_logic;
    signal mdout0_1_21: std_logic;
    signal mdout0_0_21: std_logic;
    signal mdout0_1_22: std_logic;
    signal mdout0_0_22: std_logic;
    signal mdout0_1_23: std_logic;
    signal mdout0_0_23: std_logic;
    signal mdout0_1_24: std_logic;
    signal mdout0_0_24: std_logic;
    signal mdout0_1_25: std_logic;
    signal mdout0_0_25: std_logic;
    signal mdout0_1_26: std_logic;
    signal mdout0_0_26: std_logic;
    signal mdout0_1_27: std_logic;
    signal mdout0_0_27: std_logic;
    signal mdout0_1_28: std_logic;
    signal mdout0_0_28: std_logic;
    signal mdout0_1_29: std_logic;
    signal mdout0_0_29: std_logic;
    signal mdout0_1_30: std_logic;
    signal mdout0_0_30: std_logic;
    signal addr11_ff: std_logic;
    signal mdout0_1_31: std_logic;
    signal mdout0_0_31: std_logic;

    -- local component declarations
    component AND2
        port (A: in  std_logic; B: in  std_logic; Z: out  std_logic);
    end component;
    component FD1P3DX
    -- synopsys translate_off
        generic (GSR : in String);
    -- synopsys translate_on
        port (D: in  std_logic; SP: in  std_logic; CK: in  std_logic;
            CD: in  std_logic; Q: out  std_logic);
    end component;
    component INV
        port (A: in  std_logic; Z: out  std_logic);
    end component;
    component MUX21
        port (D0: in  std_logic; D1: in  std_logic; SD: in  std_logic;
            Z: out  std_logic);
    end component;
    component VHI
        port (Z: out  std_logic);
    end component;
    component VLO
        port (Z: out  std_logic);
    end component;
    component DP16KB
    -- synopsys translate_off
        generic (GSR : in String; WRITEMODE_B : in String;
                CSDECODE_B : in std_logic_vector(2 downto 0);
                CSDECODE_A : in std_logic_vector(2 downto 0);
                WRITEMODE_A : in String; RESETMODE : in String;
                REGMODE_B : in String; REGMODE_A : in String;
                DATA_WIDTH_B : in Integer; DATA_WIDTH_A : in Integer);
    -- synopsys translate_on
        port (DIA0: in  std_logic; DIA1: in  std_logic;
            DIA2: in  std_logic; DIA3: in  std_logic;
            DIA4: in  std_logic; DIA5: in  std_logic;
            DIA6: in  std_logic; DIA7: in  std_logic;
            DIA8: in  std_logic; DIA9: in  std_logic;
            DIA10: in  std_logic; DIA11: in  std_logic;
            DIA12: in  std_logic; DIA13: in  std_logic;
            DIA14: in  std_logic; DIA15: in  std_logic;
            DIA16: in  std_logic; DIA17: in  std_logic;
            ADA0: in  std_logic; ADA1: in  std_logic;
            ADA2: in  std_logic; ADA3: in  std_logic;
            ADA4: in  std_logic; ADA5: in  std_logic;
            ADA6: in  std_logic; ADA7: in  std_logic;
            ADA8: in  std_logic; ADA9: in  std_logic;
            ADA10: in  std_logic; ADA11: in  std_logic;
            ADA12: in  std_logic; ADA13: in  std_logic;
            CEA: in  std_logic; CLKA: in  std_logic; WEA: in  std_logic;
            CSA0: in  std_logic; CSA1: in  std_logic;
            CSA2: in  std_logic; RSTA: in  std_logic;
            DIB0: in  std_logic; DIB1: in  std_logic;
            DIB2: in  std_logic; DIB3: in  std_logic;
            DIB4: in  std_logic; DIB5: in  std_logic;
            DIB6: in  std_logic; DIB7: in  std_logic;
            DIB8: in  std_logic; DIB9: in  std_logic;
            DIB10: in  std_logic; DIB11: in  std_logic;
            DIB12: in  std_logic; DIB13: in  std_logic;
            DIB14: in  std_logic; DIB15: in  std_logic;
            DIB16: in  std_logic; DIB17: in  std_logic;
            ADB0: in  std_logic; ADB1: in  std_logic;
            ADB2: in  std_logic; ADB3: in  std_logic;
            ADB4: in  std_logic; ADB5: in  std_logic;
            ADB6: in  std_logic; ADB7: in  std_logic;
            ADB8: in  std_logic; ADB9: in  std_logic;
            ADB10: in  std_logic; ADB11: in  std_logic;
            ADB12: in  std_logic; ADB13: in  std_logic;
            CEB: in  std_logic; CLKB: in  std_logic; WEB: in  std_logic;
            CSB0: in  std_logic; CSB1: in  std_logic;
            CSB2: in  std_logic; RSTB: in  std_logic;
            DOA0: out  std_logic; DOA1: out  std_logic;
            DOA2: out  std_logic; DOA3: out  std_logic;
            DOA4: out  std_logic; DOA5: out  std_logic;
            DOA6: out  std_logic; DOA7: out  std_logic;
            DOA8: out  std_logic; DOA9: out  std_logic;
            DOA10: out  std_logic; DOA11: out  std_logic;
            DOA12: out  std_logic; DOA13: out  std_logic;
            DOA14: out  std_logic; DOA15: out  std_logic;
            DOA16: out  std_logic; DOA17: out  std_logic;
            DOB0: out  std_logic; DOB1: out  std_logic;
            DOB2: out  std_logic; DOB3: out  std_logic;
            DOB4: out  std_logic; DOB5: out  std_logic;
            DOB6: out  std_logic; DOB7: out  std_logic;
            DOB8: out  std_logic; DOB9: out  std_logic;
            DOB10: out  std_logic; DOB11: out  std_logic;
            DOB12: out  std_logic; DOB13: out  std_logic;
            DOB14: out  std_logic; DOB15: out  std_logic;
            DOB16: out  std_logic; DOB17: out  std_logic);
    end component;
    attribute MEM_LPC_FILE : string;
    attribute MEM_INIT_FILE : string;
    attribute CSDECODE_B : string;
    attribute CSDECODE_A : string;
    attribute WRITEMODE_B : string;
    attribute WRITEMODE_A : string;
    attribute RESETMODE : string;
    attribute REGMODE_B : string;
    attribute REGMODE_A : string;
    attribute DATA_WIDTH_B : string;
    attribute DATA_WIDTH_A : string;
    attribute GSR : string;
    attribute MEM_LPC_FILE of internal_datamem_32_0_0_5 : label is "internal_datamem_32.lpc";
    attribute MEM_INIT_FILE of internal_datamem_32_0_0_5 : label is "";
    attribute CSDECODE_B of internal_datamem_32_0_0_5 : label is "0b111";
    attribute CSDECODE_A of internal_datamem_32_0_0_5 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_32_0_0_5 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_32_0_0_5 : label is "NORMAL";
    attribute GSR of internal_datamem_32_0_0_5 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_32_0_0_5 : label is "SYNC";
    attribute REGMODE_B of internal_datamem_32_0_0_5 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_32_0_0_5 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_32_0_0_5 : label is "9";
    attribute DATA_WIDTH_A of internal_datamem_32_0_0_5 : label is "9";
    attribute MEM_LPC_FILE of internal_datamem_32_0_1_4 : label is "internal_datamem_32.lpc";
    attribute MEM_INIT_FILE of internal_datamem_32_0_1_4 : label is "";
    attribute CSDECODE_B of internal_datamem_32_0_1_4 : label is "0b111";
    attribute CSDECODE_A of internal_datamem_32_0_1_4 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_32_0_1_4 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_32_0_1_4 : label is "NORMAL";
    attribute GSR of internal_datamem_32_0_1_4 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_32_0_1_4 : label is "SYNC";
    attribute REGMODE_B of internal_datamem_32_0_1_4 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_32_0_1_4 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_32_0_1_4 : label is "9";
    attribute DATA_WIDTH_A of internal_datamem_32_0_1_4 : label is "9";
    attribute MEM_LPC_FILE of internal_datamem_32_0_2_3 : label is "internal_datamem_32.lpc";
    attribute MEM_INIT_FILE of internal_datamem_32_0_2_3 : label is "";
    attribute CSDECODE_B of internal_datamem_32_0_2_3 : label is "0b111";
    attribute CSDECODE_A of internal_datamem_32_0_2_3 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_32_0_2_3 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_32_0_2_3 : label is "NORMAL";
    attribute GSR of internal_datamem_32_0_2_3 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_32_0_2_3 : label is "SYNC";
    attribute REGMODE_B of internal_datamem_32_0_2_3 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_32_0_2_3 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_32_0_2_3 : label is "9";
    attribute DATA_WIDTH_A of internal_datamem_32_0_2_3 : label is "9";
    attribute MEM_LPC_FILE of internal_datamem_32_0_3_2 : label is "internal_datamem_32.lpc";
    attribute MEM_INIT_FILE of internal_datamem_32_0_3_2 : label is "";
    attribute CSDECODE_B of internal_datamem_32_0_3_2 : label is "0b111";
    attribute CSDECODE_A of internal_datamem_32_0_3_2 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_32_0_3_2 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_32_0_3_2 : label is "NORMAL";
    attribute GSR of internal_datamem_32_0_3_2 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_32_0_3_2 : label is "SYNC";
    attribute REGMODE_B of internal_datamem_32_0_3_2 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_32_0_3_2 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_32_0_3_2 : label is "9";
    attribute DATA_WIDTH_A of internal_datamem_32_0_3_2 : label is "9";
    attribute MEM_LPC_FILE of internal_datamem_32_1_0_1 : label is "internal_datamem_32.lpc";
    attribute MEM_INIT_FILE of internal_datamem_32_1_0_1 : label is "";
    attribute CSDECODE_B of internal_datamem_32_1_0_1 : label is "0b111";
    attribute CSDECODE_A of internal_datamem_32_1_0_1 : label is "0b010";
    attribute WRITEMODE_B of internal_datamem_32_1_0_1 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_32_1_0_1 : label is "NORMAL";
    attribute GSR of internal_datamem_32_1_0_1 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_32_1_0_1 : label is "SYNC";
    attribute REGMODE_B of internal_datamem_32_1_0_1 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_32_1_0_1 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_32_1_0_1 : label is "18";
    attribute DATA_WIDTH_A of internal_datamem_32_1_0_1 : label is "18";
    attribute MEM_LPC_FILE of internal_datamem_32_1_1_0 : label is "internal_datamem_32.lpc";
    attribute MEM_INIT_FILE of internal_datamem_32_1_1_0 : label is "";
    attribute CSDECODE_B of internal_datamem_32_1_1_0 : label is "0b111";
    attribute CSDECODE_A of internal_datamem_32_1_1_0 : label is "0b010";
    attribute WRITEMODE_B of internal_datamem_32_1_1_0 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_32_1_1_0 : label is "NORMAL";
    attribute GSR of internal_datamem_32_1_1_0 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_32_1_1_0 : label is "SYNC";
    attribute REGMODE_B of internal_datamem_32_1_1_0 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_32_1_1_0 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_32_1_1_0 : label is "18";
    attribute DATA_WIDTH_A of internal_datamem_32_1_1_0 : label is "18";
    attribute GSR of FF_0 : label is "ENABLED";
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    INV_0: INV
        port map (A=>WE, Z=>wren_inv);

    AND2_t0: AND2
        port map (A=>wren_inv, B=>ClockEn, Z=>wren_inv_g);

    internal_datamem_32_0_0_5: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "111", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL",
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "SYNC",
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9,
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>Data(0), DIA1=>Data(1), DIA2=>Data(2),
            DIA3=>Data(3), DIA4=>Data(4), DIA5=>Data(5), DIA6=>Data(6),
            DIA7=>Data(7), DIA8=>Data(8), DIA9=>scuba_vlo,
            DIA10=>scuba_vlo, DIA11=>scuba_vlo, DIA12=>scuba_vlo,
            DIA13=>scuba_vlo, DIA14=>scuba_vlo, DIA15=>scuba_vlo,
            DIA16=>scuba_vlo, DIA17=>scuba_vlo, ADA0=>scuba_vlo,
            ADA1=>scuba_vlo, ADA2=>scuba_vlo, ADA3=>Address(0),
            ADA4=>Address(1), ADA5=>Address(2), ADA6=>Address(3),
            ADA7=>Address(4), ADA8=>Address(5), ADA9=>Address(6),
            ADA10=>Address(7), ADA11=>Address(8), ADA12=>Address(9),
            ADA13=>Address(10), CEA=>ClockEn, CLKA=>Clock, WEA=>WE,
            CSA0=>Address(11), CSA1=>scuba_vlo, CSA2=>scuba_vlo,
            RSTA=>Reset, DIB0=>scuba_vlo, DIB1=>scuba_vlo,
            DIB2=>scuba_vlo, DIB3=>scuba_vlo, DIB4=>scuba_vlo,
            DIB5=>scuba_vlo, DIB6=>scuba_vlo, DIB7=>scuba_vlo,
            DIB8=>scuba_vlo, DIB9=>scuba_vlo, DIB10=>scuba_vlo,
            DIB11=>scuba_vlo, DIB12=>scuba_vlo, DIB13=>scuba_vlo,
            DIB14=>scuba_vlo, DIB15=>scuba_vlo, DIB16=>scuba_vlo,
            DIB17=>scuba_vlo, ADB0=>scuba_vlo, ADB1=>scuba_vlo,
            ADB2=>scuba_vlo, ADB3=>scuba_vlo, ADB4=>scuba_vlo,
            ADB5=>scuba_vlo, ADB6=>scuba_vlo, ADB7=>scuba_vlo,
            ADB8=>scuba_vlo, ADB9=>scuba_vlo, ADB10=>scuba_vlo,
            ADB11=>scuba_vlo, ADB12=>scuba_vlo, ADB13=>scuba_vlo,
            CEB=>scuba_vhi, CLKB=>scuba_vlo, WEB=>scuba_vlo,
            CSB0=>scuba_vlo, CSB1=>scuba_vlo, CSB2=>scuba_vlo,
            RSTB=>scuba_vlo, DOA0=>mdout0_0_0, DOA1=>mdout0_0_1,
            DOA2=>mdout0_0_2, DOA3=>mdout0_0_3, DOA4=>mdout0_0_4,
            DOA5=>mdout0_0_5, DOA6=>mdout0_0_6, DOA7=>mdout0_0_7,
            DOA8=>mdout0_0_8, DOA9=>open, DOA10=>open, DOA11=>open,
            DOA12=>open, DOA13=>open, DOA14=>open, DOA15=>open,
            DOA16=>open, DOA17=>open, DOB0=>open, DOB1=>open, DOB2=>open,
            DOB3=>open, DOB4=>open, DOB5=>open, DOB6=>open, DOB7=>open,
            DOB8=>open, DOB9=>open, DOB10=>open, DOB11=>open,
            DOB12=>open, DOB13=>open, DOB14=>open, DOB15=>open,
            DOB16=>open, DOB17=>open);

    internal_datamem_32_0_1_4: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "111", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL",
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "SYNC",
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9,
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>Data(9), DIA1=>Data(10), DIA2=>Data(11),
            DIA3=>Data(12), DIA4=>Data(13), DIA5=>Data(14),
            DIA6=>Data(15), DIA7=>Data(16), DIA8=>Data(17),
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo,
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo,
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo,
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>scuba_vlo,
            ADA3=>Address(0), ADA4=>Address(1), ADA5=>Address(2),
            ADA6=>Address(3), ADA7=>Address(4), ADA8=>Address(5),
            ADA9=>Address(6), ADA10=>Address(7), ADA11=>Address(8),
            ADA12=>Address(9), ADA13=>Address(10), CEA=>ClockEn,
            CLKA=>Clock, WEA=>WE, CSA0=>Address(11), CSA1=>scuba_vlo,
            CSA2=>scuba_vlo, RSTA=>Reset, DIB0=>scuba_vlo,
            DIB1=>scuba_vlo, DIB2=>scuba_vlo, DIB3=>scuba_vlo,
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo,
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo,
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo,
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo,
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo,
            ADB1=>scuba_vlo, ADB2=>scuba_vlo, ADB3=>scuba_vlo,
            ADB4=>scuba_vlo, ADB5=>scuba_vlo, ADB6=>scuba_vlo,
            ADB7=>scuba_vlo, ADB8=>scuba_vlo, ADB9=>scuba_vlo,
            ADB10=>scuba_vlo, ADB11=>scuba_vlo, ADB12=>scuba_vlo,
            ADB13=>scuba_vlo, CEB=>scuba_vhi, CLKB=>scuba_vlo,
            WEB=>scuba_vlo, CSB0=>scuba_vlo, CSB1=>scuba_vlo,
            CSB2=>scuba_vlo, RSTB=>scuba_vlo, DOA0=>mdout0_0_9,
            DOA1=>mdout0_0_10, DOA2=>mdout0_0_11, DOA3=>mdout0_0_12,
            DOA4=>mdout0_0_13, DOA5=>mdout0_0_14, DOA6=>mdout0_0_15,
            DOA7=>mdout0_0_16, DOA8=>mdout0_0_17, DOA9=>open,
            DOA10=>open, DOA11=>open, DOA12=>open, DOA13=>open,
            DOA14=>open, DOA15=>open, DOA16=>open, DOA17=>open,
            DOB0=>open, DOB1=>open, DOB2=>open, DOB3=>open, DOB4=>open,
            DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open, DOB9=>open,
            DOB10=>open, DOB11=>open, DOB12=>open, DOB13=>open,
            DOB14=>open, DOB15=>open, DOB16=>open, DOB17=>open);

    internal_datamem_32_0_2_3: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "111", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL",
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "SYNC",
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9,
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>Data(18), DIA1=>Data(19), DIA2=>Data(20),
            DIA3=>Data(21), DIA4=>Data(22), DIA5=>Data(23),
            DIA6=>Data(24), DIA7=>Data(25), DIA8=>Data(26),
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo,
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo,
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo,
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>scuba_vlo,
            ADA3=>Address(0), ADA4=>Address(1), ADA5=>Address(2),
            ADA6=>Address(3), ADA7=>Address(4), ADA8=>Address(5),
            ADA9=>Address(6), ADA10=>Address(7), ADA11=>Address(8),
            ADA12=>Address(9), ADA13=>Address(10), CEA=>ClockEn,
            CLKA=>Clock, WEA=>WE, CSA0=>Address(11), CSA1=>scuba_vlo,
            CSA2=>scuba_vlo, RSTA=>Reset, DIB0=>scuba_vlo,
            DIB1=>scuba_vlo, DIB2=>scuba_vlo, DIB3=>scuba_vlo,
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo,
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo,
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo,
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo,
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo,
            ADB1=>scuba_vlo, ADB2=>scuba_vlo, ADB3=>scuba_vlo,
            ADB4=>scuba_vlo, ADB5=>scuba_vlo, ADB6=>scuba_vlo,
            ADB7=>scuba_vlo, ADB8=>scuba_vlo, ADB9=>scuba_vlo,
            ADB10=>scuba_vlo, ADB11=>scuba_vlo, ADB12=>scuba_vlo,
            ADB13=>scuba_vlo, CEB=>scuba_vhi, CLKB=>scuba_vlo,
            WEB=>scuba_vlo, CSB0=>scuba_vlo, CSB1=>scuba_vlo,
            CSB2=>scuba_vlo, RSTB=>scuba_vlo, DOA0=>mdout0_0_18,
            DOA1=>mdout0_0_19, DOA2=>mdout0_0_20, DOA3=>mdout0_0_21,
            DOA4=>mdout0_0_22, DOA5=>mdout0_0_23, DOA6=>mdout0_0_24,
            DOA7=>mdout0_0_25, DOA8=>mdout0_0_26, DOA9=>open,
            DOA10=>open, DOA11=>open, DOA12=>open, DOA13=>open,
            DOA14=>open, DOA15=>open, DOA16=>open, DOA17=>open,
            DOB0=>open, DOB1=>open, DOB2=>open, DOB3=>open, DOB4=>open,
            DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open, DOB9=>open,
            DOB10=>open, DOB11=>open, DOB12=>open, DOB13=>open,
            DOB14=>open, DOB15=>open, DOB16=>open, DOB17=>open);

    internal_datamem_32_0_3_2: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "111", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL",
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "SYNC",
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9,
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>Data(27), DIA1=>Data(28), DIA2=>Data(29),
            DIA3=>Data(30), DIA4=>Data(31), DIA5=>scuba_vlo,
            DIA6=>scuba_vlo, DIA7=>scuba_vlo, DIA8=>scuba_vlo,
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo,
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo,
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo,
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>scuba_vlo,
            ADA3=>Address(0), ADA4=>Address(1), ADA5=>Address(2),
            ADA6=>Address(3), ADA7=>Address(4), ADA8=>Address(5),
            ADA9=>Address(6), ADA10=>Address(7), ADA11=>Address(8),
            ADA12=>Address(9), ADA13=>Address(10), CEA=>ClockEn,
            CLKA=>Clock, WEA=>WE, CSA0=>Address(11), CSA1=>scuba_vlo,
            CSA2=>scuba_vlo, RSTA=>Reset, DIB0=>scuba_vlo,
            DIB1=>scuba_vlo, DIB2=>scuba_vlo, DIB3=>scuba_vlo,
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo,
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo,
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo,
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo,
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo,
            ADB1=>scuba_vlo, ADB2=>scuba_vlo, ADB3=>scuba_vlo,
            ADB4=>scuba_vlo, ADB5=>scuba_vlo, ADB6=>scuba_vlo,
            ADB7=>scuba_vlo, ADB8=>scuba_vlo, ADB9=>scuba_vlo,
            ADB10=>scuba_vlo, ADB11=>scuba_vlo, ADB12=>scuba_vlo,
            ADB13=>scuba_vlo, CEB=>scuba_vhi, CLKB=>scuba_vlo,
            WEB=>scuba_vlo, CSB0=>scuba_vlo, CSB1=>scuba_vlo,
            CSB2=>scuba_vlo, RSTB=>scuba_vlo, DOA0=>mdout0_0_27,
            DOA1=>mdout0_0_28, DOA2=>mdout0_0_29, DOA3=>mdout0_0_30,
            DOA4=>mdout0_0_31, DOA5=>open, DOA6=>open, DOA7=>open,
            DOA8=>open, DOA9=>open, DOA10=>open, DOA11=>open,
            DOA12=>open, DOA13=>open, DOA14=>open, DOA15=>open,
            DOA16=>open, DOA17=>open, DOB0=>open, DOB1=>open, DOB2=>open,
            DOB3=>open, DOB4=>open, DOB5=>open, DOB6=>open, DOB7=>open,
            DOB8=>open, DOB9=>open, DOB10=>open, DOB11=>open,
            DOB12=>open, DOB13=>open, DOB14=>open, DOB15=>open,
            DOB16=>open, DOB17=>open);

    internal_datamem_32_1_0_1: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "111", CSDECODE_A=> "010", WRITEMODE_B=> "NORMAL",
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "SYNC",
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  18,
        DATA_WIDTH_A=>  18)
        -- synopsys translate_on
        port map (DIA0=>Data(0), DIA1=>Data(1), DIA2=>Data(2),
            DIA3=>Data(3), DIA4=>Data(4), DIA5=>Data(5), DIA6=>Data(6),
            DIA7=>Data(7), DIA8=>Data(8), DIA9=>Data(9), DIA10=>Data(10),
            DIA11=>Data(11), DIA12=>Data(12), DIA13=>Data(13),
            DIA14=>Data(14), DIA15=>Data(15), DIA16=>Data(16),
            DIA17=>Data(17), ADA0=>scuba_vhi, ADA1=>scuba_vhi,
            ADA2=>scuba_vlo, ADA3=>scuba_vlo, ADA4=>Address(0),
            ADA5=>Address(1), ADA6=>Address(2), ADA7=>Address(3),
            ADA8=>Address(4), ADA9=>Address(5), ADA10=>Address(6),
            ADA11=>Address(7), ADA12=>Address(8), ADA13=>Address(9),
            CEA=>ClockEn, CLKA=>Clock, WEA=>WE, CSA0=>Address(10),
            CSA1=>Address(11), CSA2=>scuba_vlo, RSTA=>Reset,
            DIB0=>scuba_vlo, DIB1=>scuba_vlo, DIB2=>scuba_vlo,
            DIB3=>scuba_vlo, DIB4=>scuba_vlo, DIB5=>scuba_vlo,
            DIB6=>scuba_vlo, DIB7=>scuba_vlo, DIB8=>scuba_vlo,
            DIB9=>scuba_vlo, DIB10=>scuba_vlo, DIB11=>scuba_vlo,
            DIB12=>scuba_vlo, DIB13=>scuba_vlo, DIB14=>scuba_vlo,
            DIB15=>scuba_vlo, DIB16=>scuba_vlo, DIB17=>scuba_vlo,
            ADB0=>scuba_vlo, ADB1=>scuba_vlo, ADB2=>scuba_vlo,
            ADB3=>scuba_vlo, ADB4=>scuba_vlo, ADB5=>scuba_vlo,
            ADB6=>scuba_vlo, ADB7=>scuba_vlo, ADB8=>scuba_vlo,
            ADB9=>scuba_vlo, ADB10=>scuba_vlo, ADB11=>scuba_vlo,
            ADB12=>scuba_vlo, ADB13=>scuba_vlo, CEB=>scuba_vhi,
            CLKB=>scuba_vlo, WEB=>scuba_vlo, CSB0=>scuba_vlo,
            CSB1=>scuba_vlo, CSB2=>scuba_vlo, RSTB=>scuba_vlo,
            DOA0=>mdout0_1_0, DOA1=>mdout0_1_1, DOA2=>mdout0_1_2,
            DOA3=>mdout0_1_3, DOA4=>mdout0_1_4, DOA5=>mdout0_1_5,
            DOA6=>mdout0_1_6, DOA7=>mdout0_1_7, DOA8=>mdout0_1_8,
            DOA9=>mdout0_1_9, DOA10=>mdout0_1_10, DOA11=>mdout0_1_11,
            DOA12=>mdout0_1_12, DOA13=>mdout0_1_13, DOA14=>mdout0_1_14,
            DOA15=>mdout0_1_15, DOA16=>mdout0_1_16, DOA17=>mdout0_1_17,
            DOB0=>open, DOB1=>open, DOB2=>open, DOB3=>open, DOB4=>open,
            DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open, DOB9=>open,
            DOB10=>open, DOB11=>open, DOB12=>open, DOB13=>open,
            DOB14=>open, DOB15=>open, DOB16=>open, DOB17=>open);

    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    internal_datamem_32_1_1_0: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "111", CSDECODE_A=> "010", WRITEMODE_B=> "NORMAL",
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "SYNC",
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  18,
        DATA_WIDTH_A=>  18)
        -- synopsys translate_on
        port map (DIA0=>Data(18), DIA1=>Data(19), DIA2=>Data(20),
            DIA3=>Data(21), DIA4=>Data(22), DIA5=>Data(23),
            DIA6=>Data(24), DIA7=>Data(25), DIA8=>Data(26),
            DIA9=>Data(27), DIA10=>Data(28), DIA11=>Data(29),
            DIA12=>Data(30), DIA13=>Data(31), DIA14=>scuba_vlo,
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo,
            ADA0=>scuba_vhi, ADA1=>scuba_vhi, ADA2=>scuba_vlo,
            ADA3=>scuba_vlo, ADA4=>Address(0), ADA5=>Address(1),
            ADA6=>Address(2), ADA7=>Address(3), ADA8=>Address(4),
            ADA9=>Address(5), ADA10=>Address(6), ADA11=>Address(7),
            ADA12=>Address(8), ADA13=>Address(9), CEA=>ClockEn,
            CLKA=>Clock, WEA=>WE, CSA0=>Address(10), CSA1=>Address(11),
            CSA2=>scuba_vlo, RSTA=>Reset, DIB0=>scuba_vlo,
            DIB1=>scuba_vlo, DIB2=>scuba_vlo, DIB3=>scuba_vlo,
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo,
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo,
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo,
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo,
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo,
            ADB1=>scuba_vlo, ADB2=>scuba_vlo, ADB3=>scuba_vlo,
            ADB4=>scuba_vlo, ADB5=>scuba_vlo, ADB6=>scuba_vlo,
            ADB7=>scuba_vlo, ADB8=>scuba_vlo, ADB9=>scuba_vlo,
            ADB10=>scuba_vlo, ADB11=>scuba_vlo, ADB12=>scuba_vlo,
            ADB13=>scuba_vlo, CEB=>scuba_vhi, CLKB=>scuba_vlo,
            WEB=>scuba_vlo, CSB0=>scuba_vlo, CSB1=>scuba_vlo,
            CSB2=>scuba_vlo, RSTB=>scuba_vlo, DOA0=>mdout0_1_18,
            DOA1=>mdout0_1_19, DOA2=>mdout0_1_20, DOA3=>mdout0_1_21,
            DOA4=>mdout0_1_22, DOA5=>mdout0_1_23, DOA6=>mdout0_1_24,
            DOA7=>mdout0_1_25, DOA8=>mdout0_1_26, DOA9=>mdout0_1_27,
            DOA10=>mdout0_1_28, DOA11=>mdout0_1_29, DOA12=>mdout0_1_30,
            DOA13=>mdout0_1_31, DOA14=>open, DOA15=>open, DOA16=>open,
            DOA17=>open, DOB0=>open, DOB1=>open, DOB2=>open, DOB3=>open,
            DOB4=>open, DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open,
            DOB9=>open, DOB10=>open, DOB11=>open, DOB12=>open,
            DOB13=>open, DOB14=>open, DOB15=>open, DOB16=>open,
            DOB17=>open);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    FF_0: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>Address(11), SP=>wren_inv_g, CK=>Clock,
            CD=>scuba_vlo, Q=>addr11_ff);

    mux_31: MUX21
        port map (D0=>mdout0_0_0, D1=>mdout0_1_0, SD=>addr11_ff, Z=>Q(0));

    mux_30: MUX21
        port map (D0=>mdout0_0_1, D1=>mdout0_1_1, SD=>addr11_ff, Z=>Q(1));

    mux_29: MUX21
        port map (D0=>mdout0_0_2, D1=>mdout0_1_2, SD=>addr11_ff, Z=>Q(2));

    mux_28: MUX21
        port map (D0=>mdout0_0_3, D1=>mdout0_1_3, SD=>addr11_ff, Z=>Q(3));

    mux_27: MUX21
        port map (D0=>mdout0_0_4, D1=>mdout0_1_4, SD=>addr11_ff, Z=>Q(4));

    mux_26: MUX21
        port map (D0=>mdout0_0_5, D1=>mdout0_1_5, SD=>addr11_ff, Z=>Q(5));

    mux_25: MUX21
        port map (D0=>mdout0_0_6, D1=>mdout0_1_6, SD=>addr11_ff, Z=>Q(6));

    mux_24: MUX21
        port map (D0=>mdout0_0_7, D1=>mdout0_1_7, SD=>addr11_ff, Z=>Q(7));

    mux_23: MUX21
        port map (D0=>mdout0_0_8, D1=>mdout0_1_8, SD=>addr11_ff, Z=>Q(8));

    mux_22: MUX21
        port map (D0=>mdout0_0_9, D1=>mdout0_1_9, SD=>addr11_ff, Z=>Q(9));

    mux_21: MUX21
        port map (D0=>mdout0_0_10, D1=>mdout0_1_10, SD=>addr11_ff,
            Z=>Q(10));

    mux_20: MUX21
        port map (D0=>mdout0_0_11, D1=>mdout0_1_11, SD=>addr11_ff,
            Z=>Q(11));

    mux_19: MUX21
        port map (D0=>mdout0_0_12, D1=>mdout0_1_12, SD=>addr11_ff,
            Z=>Q(12));

    mux_18: MUX21
        port map (D0=>mdout0_0_13, D1=>mdout0_1_13, SD=>addr11_ff,
            Z=>Q(13));

    mux_17: MUX21
        port map (D0=>mdout0_0_14, D1=>mdout0_1_14, SD=>addr11_ff,
            Z=>Q(14));

    mux_16: MUX21
        port map (D0=>mdout0_0_15, D1=>mdout0_1_15, SD=>addr11_ff,
            Z=>Q(15));

    mux_15: MUX21
        port map (D0=>mdout0_0_16, D1=>mdout0_1_16, SD=>addr11_ff,
            Z=>Q(16));

    mux_14: MUX21
        port map (D0=>mdout0_0_17, D1=>mdout0_1_17, SD=>addr11_ff,
            Z=>Q(17));

    mux_13: MUX21
        port map (D0=>mdout0_0_18, D1=>mdout0_1_18, SD=>addr11_ff,
            Z=>Q(18));

    mux_12: MUX21
        port map (D0=>mdout0_0_19, D1=>mdout0_1_19, SD=>addr11_ff,
            Z=>Q(19));

    mux_11: MUX21
        port map (D0=>mdout0_0_20, D1=>mdout0_1_20, SD=>addr11_ff,
            Z=>Q(20));

    mux_10: MUX21
        port map (D0=>mdout0_0_21, D1=>mdout0_1_21, SD=>addr11_ff,
            Z=>Q(21));

    mux_9: MUX21
        port map (D0=>mdout0_0_22, D1=>mdout0_1_22, SD=>addr11_ff,
            Z=>Q(22));

    mux_8: MUX21
        port map (D0=>mdout0_0_23, D1=>mdout0_1_23, SD=>addr11_ff,
            Z=>Q(23));

    mux_7: MUX21
        port map (D0=>mdout0_0_24, D1=>mdout0_1_24, SD=>addr11_ff,
            Z=>Q(24));

    mux_6: MUX21
        port map (D0=>mdout0_0_25, D1=>mdout0_1_25, SD=>addr11_ff,
            Z=>Q(25));

    mux_5: MUX21
        port map (D0=>mdout0_0_26, D1=>mdout0_1_26, SD=>addr11_ff,
            Z=>Q(26));

    mux_4: MUX21
        port map (D0=>mdout0_0_27, D1=>mdout0_1_27, SD=>addr11_ff,
            Z=>Q(27));

    mux_3: MUX21
        port map (D0=>mdout0_0_28, D1=>mdout0_1_28, SD=>addr11_ff,
            Z=>Q(28));

    mux_2: MUX21
        port map (D0=>mdout0_0_29, D1=>mdout0_1_29, SD=>addr11_ff,
            Z=>Q(29));

    mux_1: MUX21
        port map (D0=>mdout0_0_30, D1=>mdout0_1_30, SD=>addr11_ff,
            Z=>Q(30));

    mux_0: MUX21
        port map (D0=>mdout0_0_31, D1=>mdout0_1_31, SD=>addr11_ff,
            Z=>Q(31));

end Structure;

-- synopsys translate_off
library xp2;
configuration Structure_CON of internal_datamem_32 is
    for Structure
        for all:AND2 use entity xp2.AND2(V); end for;
        for all:FD1P3DX use entity xp2.FD1P3DX(V); end for;
        for all:INV use entity xp2.INV(V); end for;
        for all:MUX21 use entity xp2.MUX21(V); end for;
        for all:VHI use entity xp2.VHI(V); end for;
        for all:VLO use entity xp2.VLO(V); end for;
        for all:DP16KB use entity xp2.DP16KB(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on