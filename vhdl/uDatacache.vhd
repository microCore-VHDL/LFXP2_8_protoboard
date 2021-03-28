-- ---------------------------------------------------------------------
-- @file : uDatacache.vhd
-- ---------------------------------------------------------------------
--
-- Last change: KS 24.03.2021 17:42:37
-- Last check in: $Rev: 674 $ $Date:: 2021-03-24 #$
-- @project: microCore
-- @language : VHDL-2008
-- @copyright (c): Klaus Schleisiek, All Rights Reserved.
-- @contributors :
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
--         Here fpga specific dual port memory IP can be included.
--
-- Version Author   Date       Changes
--   210     ks    8-Jun-2020  initial version
--  2300     ks    8-Mar-2021  Conversion to NUMERIC_STD
-- ---------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.functions_pkg.ALL;
USE work.architecture_pkg.ALL;

ENTITY uDatacache IS PORT (
   clk          : IN  STD_LOGIC;
   enable       : IN  STD_LOGIC;
   write        : IN  STD_LOGIC;
   addr         : IN  dcache_addr;
   wdata        : IN  data_bus;
   rdata        : OUT data_bus;
   dma_enable   : IN  STD_LOGIC;
   dma_write    : IN  STD_LOGIC;
   dma_addr     : IN  dcache_addr;
   dma_wdata    : IN  data_bus;
   dma_rdata    : OUT data_bus
); END uDatacache;

ARCHITECTURE rtl OF uDatacache IS

COMPONENT internal_datamem_16 PORT (
   ResetA   : IN  STD_LOGIC;
   ClockA   : IN  STD_LOGIC;
   ClockEnA : IN  STD_LOGIC;
   WrA      : IN  STD_LOGIC;
   AddressA : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
   DataInA  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
   QA       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

   ResetB   : IN  STD_LOGIC;
   ClockB   : IN  STD_LOGIC;
   ClockEnB : IN  STD_LOGIC;
   WrB      : IN  STD_LOGIC;
   AddressB : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
   DataInB  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
   QB       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
); END COMPONENT;

COMPONENT internal_datamem_18 PORT (
   ResetA   : IN  STD_LOGIC;
   ClockA   : IN  STD_LOGIC;
   ClockEnA : IN  STD_LOGIC;
   WrA      : IN  STD_LOGIC;
   AddressA : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
   DataInA  : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
   QA       : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);

   ResetB   : IN  STD_LOGIC;
   ClockB   : IN  STD_LOGIC;
   ClockEnB : IN  STD_LOGIC;
   WrB      : IN  STD_LOGIC;
   AddressB : IN  STD_LOGIC_VECTOR(12 DOWNTO 0);
   DataInB  : IN  STD_LOGIC_VECTOR(17 DOWNTO 0);
   QB       : OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
); END COMPONENT;

COMPONENT internal_Datamem_27 IS PORT (
   ResetA    : IN   STD_LOGIC;
   ClockA    : IN   STD_LOGIC;
   ClockEnA  : IN   STD_LOGIC;
   WrA       : IN   STD_LOGIC;
   AddressA  : IN   STD_LOGIC_VECTOR(11 DOWNTO 0);
   DataInA   : IN   STD_LOGIC_VECTOR(26 DOWNTO 0);
   QA        : OUT  STD_LOGIC_VECTOR(26 DOWNTO 0);

   ResetB    : IN   STD_LOGIC;
   ClockB    : IN   STD_LOGIC;
   ClockEnB  : IN   STD_LOGIC;
   WrB       : IN   STD_LOGIC;
   AddressB  : IN   STD_LOGIC_VECTOR(11 DOWNTO 0);
   DataInB   : IN   STD_LOGIC_VECTOR(26 DOWNTO 0);
   QB        : OUT  STD_LOGIC_VECTOR(26 DOWNTO 0)
); END COMPONENT internal_Datamem_27;

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
); END COMPONENT;

SIGNAL slv_rdata      : STD_LOGIC_VECTOR(rdata'range);
SIGNAL slv_dma_rdata  : STD_LOGIC_VECTOR(rdata'range);

BEGIN

make_sim_mem: IF  simulation OR NOT (data_width = 16 OR data_width = 18 OR data_width = 27 OR data_width = 32)  GENERATE

   internal_data_mem: internal_dpram
   GENERIC MAP (data_width, cache_addr_width, "rw_check", DMEM_file)
   PORT MAP (
      clk     => clk,
      ena     => enable,
      wea     => write,
      addra   => addr,
      dia     => wdata,
      doa     => rdata,
      enb     => dma_enable,
      web     => dma_write,
      addrb   => dma_addr,
      dib     => dma_wdata,
      dob     => dma_rdata
   );

END GENERATE make_sim_mem; make_16_mem: IF  NOT simulation AND data_width = 16  GENERATE

   instantiated_data_mem: internal_Datamem_16
   PORT MAP (
      ResetA    => '0',
      ClockA    => clk,
      ClockEnA  => enable,
      WrA       => write,
      AddressA  => std_logic_vector(addr),
      DataInA   => std_logic_vector(wdata),
      QA        => slv_rdata,
      ResetB    => '0',
      ClockB    => clk,
      ClockEnB  => dma_enable,
      WrB       => dma_write,
      AddressB  => std_logic_vector(dma_addr),
      DataInB   => std_logic_vector(dma_wdata),
      QB        => slv_dma_rdata
   );
   rdata     <= unsigned(slv_rdata);
   dma_rdata <= unsigned(slv_dma_rdata);

END GENERATE make_16_mem; make_18_mem: IF  NOT simulation AND data_width = 18  GENERATE

   instantiated_data_mem: internal_Datamem_18
   PORT MAP (
      ResetA    => '0',
      ClockA    => clk,
      ClockEnA  => enable,
      WrA       => write,
      AddressA  => std_logic_vector(addr),
      DataInA   => std_logic_vector(wdata),
      QA        => slv_rdata,
      ResetB    => '0',
      ClockB    => clk,
      ClockEnB  => dma_enable,
      WrB       => dma_write,
      AddressB  => std_logic_vector(dma_addr),
      DataInB   => std_logic_vector(dma_wdata),
      QB        => slv_dma_rdata
   );
   rdata     <= unsigned(slv_rdata);
   dma_rdata <= unsigned(slv_dma_rdata);

END GENERATE make_18_mem; make_27_mem: IF  NOT simulation AND data_width = 27  GENERATE

   instantiated_data_mem: internal_Datamem_27
   PORT MAP (
      ResetA    => '0',
      ClockA    => clk,
      ClockEnA  => enable,
      WrA       => write,
      AddressA  => std_logic_vector(addr),
      DataInA   => std_logic_vector(wdata),
      QA        => slv_rdata,
      ResetB    => '0',
      ClockB    => clk,
      ClockEnB  => dma_enable,
      WrB       => dma_write,
      AddressB  => std_logic_vector(dma_addr),
      DataInB   => std_logic_vector(dma_wdata),
      QB        => slv_dma_rdata
   );
   rdata     <= unsigned(slv_rdata);
   dma_rdata <= unsigned(slv_dma_rdata);

END GENERATE make_27_mem; make_32_mem: IF  NOT simulation AND data_width = 32  GENERATE

   instantiated_data_mem: internal_datamem_32
   PORT MAP (
      Clock     => clk,
      ClockEn   => enable,
      Reset     => '0',
      WE        => write,
      Address   => std_logic_vector(addr),
      Data      => std_logic_vector(wdata),
      Q         => slv_rdata
	);

   rdata     <= unsigned(slv_rdata);
   dma_rdata <= (OTHERS => '0');

END GENERATE make_32_mem;

END rtl;