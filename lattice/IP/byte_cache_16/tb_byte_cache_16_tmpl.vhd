-- VHDL testbench template generated by SCUBA Diamond (64-bit) 3.11.3.469
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

use IEEE.math_real.all;

use IEEE.numeric_std.all;

entity tb is
end entity tb;


architecture test of tb is 

    component byte_cache_16
        port (DataInA : in std_logic_vector(15 downto 0); 
        DataInB : in std_logic_vector(15 downto 0); 
        ByteEnA : in std_logic_vector(1 downto 0); 
        ByteEnB : in std_logic_vector(1 downto 0); 
        AddressA : in std_logic_vector(12 downto 0); 
        AddressB : in std_logic_vector(12 downto 0); 
        ClockA: in std_logic; ClockB: in std_logic; 
        ClockEnA: in std_logic; ClockEnB: in std_logic; 
        WrA: in std_logic; WrB: in std_logic; ResetA: in std_logic; 
        ResetB: in std_logic; QA : out std_logic_vector(15 downto 0); 
        QB : out std_logic_vector(15 downto 0)
    );
    end component;

    signal DataInA : std_logic_vector(15 downto 0) := (others => '0');
    signal DataInB : std_logic_vector(15 downto 0) := (others => '0');
    signal ByteEnA : std_logic_vector(1 downto 0) := (others => '0');
    signal ByteEnB : std_logic_vector(1 downto 0) := (others => '0');
    signal AddressA : std_logic_vector(12 downto 0) := (others => '0');
    signal AddressB : std_logic_vector(12 downto 0) := (others => '0');
    signal ClockA: std_logic := '0';
    signal ClockB: std_logic := '0';
    signal ClockEnA: std_logic := '0';
    signal ClockEnB: std_logic := '0';
    signal WrA: std_logic := '0';
    signal WrB: std_logic := '0';
    signal ResetA: std_logic := '0';
    signal ResetB: std_logic := '0';
    signal QA : std_logic_vector(15 downto 0);
    signal QB : std_logic_vector(15 downto 0);
begin
    u1 : byte_cache_16
        port map (DataInA => DataInA, DataInB => DataInB, ByteEnA => ByteEnA, 
            ByteEnB => ByteEnB, AddressA => AddressA, AddressB => AddressB, 
            ClockA => ClockA, ClockB => ClockB, ClockEnA => ClockEnA, 
            ClockEnB => ClockEnB, WrA => WrA, WrB => WrB, ResetA => ResetA, 
            ResetB => ResetB, QA => QA, QB => QB
        );

    process

    begin
      DataInA <= (others => '0') ;
      wait for 100 ns;
      wait until ResetA = '0';
      for i in 0 to 6147 loop
        wait until ClockA'event and ClockA = '1';
        DataInA <= DataInA + '1' after 1 ns;
      end loop;
      wait;
    end process;

    process

    begin
      DataInB <= (others => '0') ;
      wait for 100 ns;
      wait until ResetB = '0';
      wait until WrB = '1';
      for i in 0 to 6147 loop
        wait until ClockB'event and ClockB = '1';
        DataInB <= DataInB + '1' after 1 ns;
      end loop;
      wait;
    end process;

    process

    begin
      AddressA <= (others => '0') ;
      wait for 100 ns;
      wait until ResetA = '0';
      for i in 0 to 12294 loop
        wait until ClockA'event and ClockA = '1';
        AddressA <= AddressA + '1' after 1 ns;
      end loop;
      wait;
    end process;

    process

    begin
      AddressB <= (others => '0') ;
      wait for 100 ns;
      wait until ResetB = '0';
      wait until WrB = '1';
      for i in 0 to 12294 loop
        wait until ClockB'event and ClockB = '1';
        AddressB <= AddressB + '1' after 1 ns;
      end loop;
      wait;
    end process;

    ClockA <= not ClockA after 5.00 ns;

    ClockB <= not ClockB after 5.00 ns;

    process

    begin
      ClockEnA <= '0' ;
      wait for 100 ns;
      wait until ResetA = '0';
      ClockEnA <= '1' ;
      wait;
    end process;

    process

    begin
      ClockEnB <= '0' ;
      wait for 100 ns;
      wait until ResetB = '0';
      ClockEnB <= '1' ;
      wait;
    end process;

    process

    begin
      WrA <= '0' ;
      wait until ResetA = '0';
      for i in 0 to 6147 loop
        wait until ClockA'event and ClockA = '1';
        WrA <= '1' after 1 ns;
      end loop;
      WrA <= '0' ;
      wait;
    end process;

    process

    begin
      WrB <= '0' ;
      wait until ResetB = '0';
      wait until WrA = '1';
      wait until WrA = '0';
      for i in 0 to 6147 loop
        wait until ClockA'event and ClockA = '1';
      end loop;
      for i in 0 to 6147 loop
        wait until ClockB'event and ClockB = '1';
        WrB <= '1' after 1 ns;
      end loop;
      WrB <= '0' ;
      wait;
    end process;

    process

    begin
      ResetA <= '1' ;
      wait for 100 ns;
      ResetA <= '0' ;
      wait;
    end process;

    process

    begin
      ResetB <= '1' ;
      wait for 100 ns;
      ResetB <= '0' ;
      wait;
    end process;

end architecture test;
