-- ---------------------------------------------------------------------
-- @file : uDatacache.vhd
-- ---------------------------------------------------------------------
--
-- Last change: KS 15.12.2020 16:15:38
-- Project : microCore
-- Language : VHDL-2008
-- Last check in : $Rev: 612 $ $Date:: 2020-12-16 #$
-- @copyright (c): Klaus Schleisiek, All Rights Reserved.
--
-- Do not use this file except in compliance with the License. You may
-- obtain a copy of the License at http://www.microcore.org/License/.
-- Software distributed under the License is distributed on an "AS IS"
-- basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
-- See the License for the specific language governing rights and
-- limitations under the License.
--
-- @brief: Definition of the internal data memory.
--         Here fpga specific dual port memory IP can be included.
--
-- Version Author   Date       Changes
--           ks    8-Jun-2020  initial version
-- ---------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
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
   Address  : IN  dcache_addr; -- data_addr_width := 12
   Data     : IN  data_bus;
   Q        : OUT data_bus
); END COMPONENT;

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
      AddressA  => addr,
      DataInA   => wdata,
      QA        => rdata,
      ResetB    => '0',
      ClockB    => clk,
      ClockEnB  => dma_enable,
      WrB       => dma_write,
      AddressB  => dma_addr,
      DataInB   => dma_wdata,
      QB        => dma_rdata
   );

END GENERATE make_16_mem; make_18_mem: IF  NOT simulation AND data_width = 18  GENERATE

   instantiated_data_mem: internal_Datamem_18
   PORT MAP (
      ResetA    => '0',
      ClockA    => clk,
      ClockEnA  => enable,
      WrA       => write,
      AddressA  => addr,
      DataInA   => wdata,
      QA        => rdata,
      ResetB    => '0',
      ClockB    => clk,
      ClockEnB  => dma_enable,
      WrB       => dma_write,
      AddressB  => dma_addr,
      DataInB   => dma_wdata,
      QB        => dma_rdata
   );

END GENERATE make_18_mem; make_27_mem: IF  NOT simulation AND data_width = 27  GENERATE

   instantiated_data_mem: internal_Datamem_27
   PORT MAP (
      ResetA    => '0',
      ClockA    => clk,
      ClockEnA  => enable,
      WrA       => write,
      AddressA  => addr,
      DataInA   => wdata,
      QA        => rdata,
      ResetB    => '0',
      ClockB    => clk,
      ClockEnB  => dma_enable,
      WrB       => dma_write,
      AddressB  => dma_addr,
      DataInB   => dma_wdata,
      QB        => dma_rdata
   );

END GENERATE make_27_mem; make_32_mem: IF  NOT simulation AND data_width = 32  GENERATE

   instantiated_data_mem: internal_datamem_32
   PORT MAP (
      Clock     => clk,
      ClockEn   => enable,
      Reset     => '0',
      WE        => write,
      Address   => addr,
      Data      => wdata,
      Q         => rdata
	);

   dma_rdata <= (OTHERS => '0');

END GENERATE make_32_mem;

END rtl;