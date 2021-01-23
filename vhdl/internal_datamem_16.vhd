-- VHDL netlist generated by SCUBA Diamond (64-bit) 3.10.3.144
-- Module  Version: 7.5
--C:\lscc\diamond\3.10_x64\ispfpga\bin\nt64\scuba.exe -w -n internal_datamem_16 -lang vhdl -synth synplify -bus_exp 7 -bb -arch mg5a00 -type bram -wp 11 -rp 1010 -data_width 16 -rdata_width 16 -num_rows 6144 -writemodeA NORMAL -writemodeB NORMAL -resetmode ASYNC -cascade -1 

-- Sat Nov 16 23:20:53 2019

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library xp2;
use xp2.components.all;
-- synopsys translate_on

entity internal_datamem_16 is
    port (
        DataInA: in  std_logic_vector(15 downto 0); 
        DataInB: in  std_logic_vector(15 downto 0); 
        AddressA: in  std_logic_vector(12 downto 0); 
        AddressB: in  std_logic_vector(12 downto 0); 
        ClockA: in  std_logic; 
        ClockB: in  std_logic; 
        ClockEnA: in  std_logic; 
        ClockEnB: in  std_logic; 
        WrA: in  std_logic; 
        WrB: in  std_logic; 
        ResetA: in  std_logic; 
        ResetB: in  std_logic; 
        QA: out  std_logic_vector(15 downto 0); 
        QB: out  std_logic_vector(15 downto 0));
end internal_datamem_16;

architecture Structure of internal_datamem_16 is

    -- internal signal declarations
    signal scuba_vhi: std_logic;
    signal wren0_inv: std_logic;
    signal wren1_inv: std_logic;
    signal wren0_inv_g: std_logic;
    signal scuba_vlo: std_logic;
    signal wren1_inv_g: std_logic;
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
    signal addr012_ff: std_logic;
    signal mdout0_1_15: std_logic;
    signal mdout0_0_15: std_logic;
    signal mdout1_1_0: std_logic;
    signal mdout1_0_0: std_logic;
    signal mdout1_1_1: std_logic;
    signal mdout1_0_1: std_logic;
    signal mdout1_1_2: std_logic;
    signal mdout1_0_2: std_logic;
    signal mdout1_1_3: std_logic;
    signal mdout1_0_3: std_logic;
    signal mdout1_1_4: std_logic;
    signal mdout1_0_4: std_logic;
    signal mdout1_1_5: std_logic;
    signal mdout1_0_5: std_logic;
    signal mdout1_1_6: std_logic;
    signal mdout1_0_6: std_logic;
    signal mdout1_1_7: std_logic;
    signal mdout1_0_7: std_logic;
    signal mdout1_1_8: std_logic;
    signal mdout1_0_8: std_logic;
    signal mdout1_1_9: std_logic;
    signal mdout1_0_9: std_logic;
    signal mdout1_1_10: std_logic;
    signal mdout1_0_10: std_logic;
    signal mdout1_1_11: std_logic;
    signal mdout1_0_11: std_logic;
    signal mdout1_1_12: std_logic;
    signal mdout1_0_12: std_logic;
    signal mdout1_1_13: std_logic;
    signal mdout1_0_13: std_logic;
    signal mdout1_1_14: std_logic;
    signal mdout1_0_14: std_logic;
    signal addr112_ff: std_logic;
    signal mdout1_1_15: std_logic;
    signal mdout1_0_15: std_logic;

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
    attribute MEM_LPC_FILE of internal_datamem_16_0_0_5 : label is "internal_datamem_16.lpc";
    attribute MEM_INIT_FILE of internal_datamem_16_0_0_5 : label is "";
    attribute CSDECODE_B of internal_datamem_16_0_0_5 : label is "0b000";
    attribute CSDECODE_A of internal_datamem_16_0_0_5 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_16_0_0_5 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_16_0_0_5 : label is "NORMAL";
    attribute GSR of internal_datamem_16_0_0_5 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_16_0_0_5 : label is "ASYNC";
    attribute REGMODE_B of internal_datamem_16_0_0_5 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_16_0_0_5 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_16_0_0_5 : label is "4";
    attribute DATA_WIDTH_A of internal_datamem_16_0_0_5 : label is "4";
    attribute MEM_LPC_FILE of internal_datamem_16_0_1_4 : label is "internal_datamem_16.lpc";
    attribute MEM_INIT_FILE of internal_datamem_16_0_1_4 : label is "";
    attribute CSDECODE_B of internal_datamem_16_0_1_4 : label is "0b000";
    attribute CSDECODE_A of internal_datamem_16_0_1_4 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_16_0_1_4 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_16_0_1_4 : label is "NORMAL";
    attribute GSR of internal_datamem_16_0_1_4 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_16_0_1_4 : label is "ASYNC";
    attribute REGMODE_B of internal_datamem_16_0_1_4 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_16_0_1_4 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_16_0_1_4 : label is "4";
    attribute DATA_WIDTH_A of internal_datamem_16_0_1_4 : label is "4";
    attribute MEM_LPC_FILE of internal_datamem_16_0_2_3 : label is "internal_datamem_16.lpc";
    attribute MEM_INIT_FILE of internal_datamem_16_0_2_3 : label is "";
    attribute CSDECODE_B of internal_datamem_16_0_2_3 : label is "0b000";
    attribute CSDECODE_A of internal_datamem_16_0_2_3 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_16_0_2_3 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_16_0_2_3 : label is "NORMAL";
    attribute GSR of internal_datamem_16_0_2_3 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_16_0_2_3 : label is "ASYNC";
    attribute REGMODE_B of internal_datamem_16_0_2_3 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_16_0_2_3 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_16_0_2_3 : label is "4";
    attribute DATA_WIDTH_A of internal_datamem_16_0_2_3 : label is "4";
    attribute MEM_LPC_FILE of internal_datamem_16_0_3_2 : label is "internal_datamem_16.lpc";
    attribute MEM_INIT_FILE of internal_datamem_16_0_3_2 : label is "";
    attribute CSDECODE_B of internal_datamem_16_0_3_2 : label is "0b000";
    attribute CSDECODE_A of internal_datamem_16_0_3_2 : label is "0b000";
    attribute WRITEMODE_B of internal_datamem_16_0_3_2 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_16_0_3_2 : label is "NORMAL";
    attribute GSR of internal_datamem_16_0_3_2 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_16_0_3_2 : label is "ASYNC";
    attribute REGMODE_B of internal_datamem_16_0_3_2 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_16_0_3_2 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_16_0_3_2 : label is "4";
    attribute DATA_WIDTH_A of internal_datamem_16_0_3_2 : label is "4";
    attribute MEM_LPC_FILE of internal_datamem_16_1_0_1 : label is "internal_datamem_16.lpc";
    attribute MEM_INIT_FILE of internal_datamem_16_1_0_1 : label is "";
    attribute CSDECODE_B of internal_datamem_16_1_0_1 : label is "0b010";
    attribute CSDECODE_A of internal_datamem_16_1_0_1 : label is "0b010";
    attribute WRITEMODE_B of internal_datamem_16_1_0_1 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_16_1_0_1 : label is "NORMAL";
    attribute GSR of internal_datamem_16_1_0_1 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_16_1_0_1 : label is "ASYNC";
    attribute REGMODE_B of internal_datamem_16_1_0_1 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_16_1_0_1 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_16_1_0_1 : label is "9";
    attribute DATA_WIDTH_A of internal_datamem_16_1_0_1 : label is "9";
    attribute MEM_LPC_FILE of internal_datamem_16_1_1_0 : label is "internal_datamem_16.lpc";
    attribute MEM_INIT_FILE of internal_datamem_16_1_1_0 : label is "";
    attribute CSDECODE_B of internal_datamem_16_1_1_0 : label is "0b010";
    attribute CSDECODE_A of internal_datamem_16_1_1_0 : label is "0b010";
    attribute WRITEMODE_B of internal_datamem_16_1_1_0 : label is "NORMAL";
    attribute WRITEMODE_A of internal_datamem_16_1_1_0 : label is "NORMAL";
    attribute GSR of internal_datamem_16_1_1_0 : label is "DISABLED";
    attribute RESETMODE of internal_datamem_16_1_1_0 : label is "ASYNC";
    attribute REGMODE_B of internal_datamem_16_1_1_0 : label is "NOREG";
    attribute REGMODE_A of internal_datamem_16_1_1_0 : label is "NOREG";
    attribute DATA_WIDTH_B of internal_datamem_16_1_1_0 : label is "9";
    attribute DATA_WIDTH_A of internal_datamem_16_1_1_0 : label is "9";
    attribute GSR of FF_1 : label is "ENABLED";
    attribute GSR of FF_0 : label is "ENABLED";
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    INV_1: INV
        port map (A=>WrA, Z=>wren0_inv);

    AND2_t1: AND2
        port map (A=>wren0_inv, B=>ClockEnA, Z=>wren0_inv_g);

    INV_0: INV
        port map (A=>WrB, Z=>wren1_inv);

    AND2_t0: AND2
        port map (A=>wren1_inv, B=>ClockEnB, Z=>wren1_inv_g);

    internal_datamem_16_0_0_5: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "000", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  4, 
        DATA_WIDTH_A=>  4)
        -- synopsys translate_on
        port map (DIA0=>DataInA(0), DIA1=>DataInA(1), DIA2=>DataInA(2), 
            DIA3=>DataInA(3), DIA4=>scuba_vlo, DIA5=>scuba_vlo, 
            DIA6=>scuba_vlo, DIA7=>scuba_vlo, DIA8=>scuba_vlo, 
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo, 
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo, 
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo, 
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>AddressA(0), 
            ADA3=>AddressA(1), ADA4=>AddressA(2), ADA5=>AddressA(3), 
            ADA6=>AddressA(4), ADA7=>AddressA(5), ADA8=>AddressA(6), 
            ADA9=>AddressA(7), ADA10=>AddressA(8), ADA11=>AddressA(9), 
            ADA12=>AddressA(10), ADA13=>AddressA(11), CEA=>ClockEnA, 
            CLKA=>ClockA, WEA=>WrA, CSA0=>AddressA(12), CSA1=>scuba_vlo, 
            CSA2=>scuba_vlo, RSTA=>ResetA, DIB0=>DataInB(0), 
            DIB1=>DataInB(1), DIB2=>DataInB(2), DIB3=>DataInB(3), 
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo, 
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo, 
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo, 
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo, 
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo, 
            ADB1=>scuba_vlo, ADB2=>AddressB(0), ADB3=>AddressB(1), 
            ADB4=>AddressB(2), ADB5=>AddressB(3), ADB6=>AddressB(4), 
            ADB7=>AddressB(5), ADB8=>AddressB(6), ADB9=>AddressB(7), 
            ADB10=>AddressB(8), ADB11=>AddressB(9), ADB12=>AddressB(10), 
            ADB13=>AddressB(11), CEB=>ClockEnB, CLKB=>ClockB, WEB=>WrB, 
            CSB0=>AddressB(12), CSB1=>scuba_vlo, CSB2=>scuba_vlo, 
            RSTB=>ResetB, DOA0=>mdout0_0_0, DOA1=>mdout0_0_1, 
            DOA2=>mdout0_0_2, DOA3=>mdout0_0_3, DOA4=>open, DOA5=>open, 
            DOA6=>open, DOA7=>open, DOA8=>open, DOA9=>open, DOA10=>open, 
            DOA11=>open, DOA12=>open, DOA13=>open, DOA14=>open, 
            DOA15=>open, DOA16=>open, DOA17=>open, DOB0=>mdout1_0_0, 
            DOB1=>mdout1_0_1, DOB2=>mdout1_0_2, DOB3=>mdout1_0_3, 
            DOB4=>open, DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open, 
            DOB9=>open, DOB10=>open, DOB11=>open, DOB12=>open, 
            DOB13=>open, DOB14=>open, DOB15=>open, DOB16=>open, 
            DOB17=>open);

    internal_datamem_16_0_1_4: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "000", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  4, 
        DATA_WIDTH_A=>  4)
        -- synopsys translate_on
        port map (DIA0=>DataInA(4), DIA1=>DataInA(5), DIA2=>DataInA(6), 
            DIA3=>DataInA(7), DIA4=>scuba_vlo, DIA5=>scuba_vlo, 
            DIA6=>scuba_vlo, DIA7=>scuba_vlo, DIA8=>scuba_vlo, 
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo, 
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo, 
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo, 
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>AddressA(0), 
            ADA3=>AddressA(1), ADA4=>AddressA(2), ADA5=>AddressA(3), 
            ADA6=>AddressA(4), ADA7=>AddressA(5), ADA8=>AddressA(6), 
            ADA9=>AddressA(7), ADA10=>AddressA(8), ADA11=>AddressA(9), 
            ADA12=>AddressA(10), ADA13=>AddressA(11), CEA=>ClockEnA, 
            CLKA=>ClockA, WEA=>WrA, CSA0=>AddressA(12), CSA1=>scuba_vlo, 
            CSA2=>scuba_vlo, RSTA=>ResetA, DIB0=>DataInB(4), 
            DIB1=>DataInB(5), DIB2=>DataInB(6), DIB3=>DataInB(7), 
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo, 
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo, 
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo, 
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo, 
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo, 
            ADB1=>scuba_vlo, ADB2=>AddressB(0), ADB3=>AddressB(1), 
            ADB4=>AddressB(2), ADB5=>AddressB(3), ADB6=>AddressB(4), 
            ADB7=>AddressB(5), ADB8=>AddressB(6), ADB9=>AddressB(7), 
            ADB10=>AddressB(8), ADB11=>AddressB(9), ADB12=>AddressB(10), 
            ADB13=>AddressB(11), CEB=>ClockEnB, CLKB=>ClockB, WEB=>WrB, 
            CSB0=>AddressB(12), CSB1=>scuba_vlo, CSB2=>scuba_vlo, 
            RSTB=>ResetB, DOA0=>mdout0_0_4, DOA1=>mdout0_0_5, 
            DOA2=>mdout0_0_6, DOA3=>mdout0_0_7, DOA4=>open, DOA5=>open, 
            DOA6=>open, DOA7=>open, DOA8=>open, DOA9=>open, DOA10=>open, 
            DOA11=>open, DOA12=>open, DOA13=>open, DOA14=>open, 
            DOA15=>open, DOA16=>open, DOA17=>open, DOB0=>mdout1_0_4, 
            DOB1=>mdout1_0_5, DOB2=>mdout1_0_6, DOB3=>mdout1_0_7, 
            DOB4=>open, DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open, 
            DOB9=>open, DOB10=>open, DOB11=>open, DOB12=>open, 
            DOB13=>open, DOB14=>open, DOB15=>open, DOB16=>open, 
            DOB17=>open);

    internal_datamem_16_0_2_3: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "000", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  4, 
        DATA_WIDTH_A=>  4)
        -- synopsys translate_on
        port map (DIA0=>DataInA(8), DIA1=>DataInA(9), DIA2=>DataInA(10), 
            DIA3=>DataInA(11), DIA4=>scuba_vlo, DIA5=>scuba_vlo, 
            DIA6=>scuba_vlo, DIA7=>scuba_vlo, DIA8=>scuba_vlo, 
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo, 
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo, 
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo, 
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>AddressA(0), 
            ADA3=>AddressA(1), ADA4=>AddressA(2), ADA5=>AddressA(3), 
            ADA6=>AddressA(4), ADA7=>AddressA(5), ADA8=>AddressA(6), 
            ADA9=>AddressA(7), ADA10=>AddressA(8), ADA11=>AddressA(9), 
            ADA12=>AddressA(10), ADA13=>AddressA(11), CEA=>ClockEnA, 
            CLKA=>ClockA, WEA=>WrA, CSA0=>AddressA(12), CSA1=>scuba_vlo, 
            CSA2=>scuba_vlo, RSTA=>ResetA, DIB0=>DataInB(8), 
            DIB1=>DataInB(9), DIB2=>DataInB(10), DIB3=>DataInB(11), 
            DIB4=>scuba_vlo, DIB5=>scuba_vlo, DIB6=>scuba_vlo, 
            DIB7=>scuba_vlo, DIB8=>scuba_vlo, DIB9=>scuba_vlo, 
            DIB10=>scuba_vlo, DIB11=>scuba_vlo, DIB12=>scuba_vlo, 
            DIB13=>scuba_vlo, DIB14=>scuba_vlo, DIB15=>scuba_vlo, 
            DIB16=>scuba_vlo, DIB17=>scuba_vlo, ADB0=>scuba_vlo, 
            ADB1=>scuba_vlo, ADB2=>AddressB(0), ADB3=>AddressB(1), 
            ADB4=>AddressB(2), ADB5=>AddressB(3), ADB6=>AddressB(4), 
            ADB7=>AddressB(5), ADB8=>AddressB(6), ADB9=>AddressB(7), 
            ADB10=>AddressB(8), ADB11=>AddressB(9), ADB12=>AddressB(10), 
            ADB13=>AddressB(11), CEB=>ClockEnB, CLKB=>ClockB, WEB=>WrB, 
            CSB0=>AddressB(12), CSB1=>scuba_vlo, CSB2=>scuba_vlo, 
            RSTB=>ResetB, DOA0=>mdout0_0_8, DOA1=>mdout0_0_9, 
            DOA2=>mdout0_0_10, DOA3=>mdout0_0_11, DOA4=>open, DOA5=>open, 
            DOA6=>open, DOA7=>open, DOA8=>open, DOA9=>open, DOA10=>open, 
            DOA11=>open, DOA12=>open, DOA13=>open, DOA14=>open, 
            DOA15=>open, DOA16=>open, DOA17=>open, DOB0=>mdout1_0_8, 
            DOB1=>mdout1_0_9, DOB2=>mdout1_0_10, DOB3=>mdout1_0_11, 
            DOB4=>open, DOB5=>open, DOB6=>open, DOB7=>open, DOB8=>open, 
            DOB9=>open, DOB10=>open, DOB11=>open, DOB12=>open, 
            DOB13=>open, DOB14=>open, DOB15=>open, DOB16=>open, 
            DOB17=>open);

    internal_datamem_16_0_3_2: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "000", CSDECODE_A=> "000", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  4, 
        DATA_WIDTH_A=>  4)
        -- synopsys translate_on
        port map (DIA0=>DataInA(12), DIA1=>DataInA(13), 
            DIA2=>DataInA(14), DIA3=>DataInA(15), DIA4=>scuba_vlo, 
            DIA5=>scuba_vlo, DIA6=>scuba_vlo, DIA7=>scuba_vlo, 
            DIA8=>scuba_vlo, DIA9=>scuba_vlo, DIA10=>scuba_vlo, 
            DIA11=>scuba_vlo, DIA12=>scuba_vlo, DIA13=>scuba_vlo, 
            DIA14=>scuba_vlo, DIA15=>scuba_vlo, DIA16=>scuba_vlo, 
            DIA17=>scuba_vlo, ADA0=>scuba_vlo, ADA1=>scuba_vlo, 
            ADA2=>AddressA(0), ADA3=>AddressA(1), ADA4=>AddressA(2), 
            ADA5=>AddressA(3), ADA6=>AddressA(4), ADA7=>AddressA(5), 
            ADA8=>AddressA(6), ADA9=>AddressA(7), ADA10=>AddressA(8), 
            ADA11=>AddressA(9), ADA12=>AddressA(10), ADA13=>AddressA(11), 
            CEA=>ClockEnA, CLKA=>ClockA, WEA=>WrA, CSA0=>AddressA(12), 
            CSA1=>scuba_vlo, CSA2=>scuba_vlo, RSTA=>ResetA, 
            DIB0=>DataInB(12), DIB1=>DataInB(13), DIB2=>DataInB(14), 
            DIB3=>DataInB(15), DIB4=>scuba_vlo, DIB5=>scuba_vlo, 
            DIB6=>scuba_vlo, DIB7=>scuba_vlo, DIB8=>scuba_vlo, 
            DIB9=>scuba_vlo, DIB10=>scuba_vlo, DIB11=>scuba_vlo, 
            DIB12=>scuba_vlo, DIB13=>scuba_vlo, DIB14=>scuba_vlo, 
            DIB15=>scuba_vlo, DIB16=>scuba_vlo, DIB17=>scuba_vlo, 
            ADB0=>scuba_vlo, ADB1=>scuba_vlo, ADB2=>AddressB(0), 
            ADB3=>AddressB(1), ADB4=>AddressB(2), ADB5=>AddressB(3), 
            ADB6=>AddressB(4), ADB7=>AddressB(5), ADB8=>AddressB(6), 
            ADB9=>AddressB(7), ADB10=>AddressB(8), ADB11=>AddressB(9), 
            ADB12=>AddressB(10), ADB13=>AddressB(11), CEB=>ClockEnB, 
            CLKB=>ClockB, WEB=>WrB, CSB0=>AddressB(12), CSB1=>scuba_vlo, 
            CSB2=>scuba_vlo, RSTB=>ResetB, DOA0=>mdout0_0_12, 
            DOA1=>mdout0_0_13, DOA2=>mdout0_0_14, DOA3=>mdout0_0_15, 
            DOA4=>open, DOA5=>open, DOA6=>open, DOA7=>open, DOA8=>open, 
            DOA9=>open, DOA10=>open, DOA11=>open, DOA12=>open, 
            DOA13=>open, DOA14=>open, DOA15=>open, DOA16=>open, 
            DOA17=>open, DOB0=>mdout1_0_12, DOB1=>mdout1_0_13, 
            DOB2=>mdout1_0_14, DOB3=>mdout1_0_15, DOB4=>open, DOB5=>open, 
            DOB6=>open, DOB7=>open, DOB8=>open, DOB9=>open, DOB10=>open, 
            DOB11=>open, DOB12=>open, DOB13=>open, DOB14=>open, 
            DOB15=>open, DOB16=>open, DOB17=>open);

    internal_datamem_16_1_0_1: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "010", CSDECODE_A=> "010", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9, 
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>DataInA(0), DIA1=>DataInA(1), DIA2=>DataInA(2), 
            DIA3=>DataInA(3), DIA4=>DataInA(4), DIA5=>DataInA(5), 
            DIA6=>DataInA(6), DIA7=>DataInA(7), DIA8=>DataInA(8), 
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo, 
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo, 
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo, 
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>scuba_vlo, 
            ADA3=>AddressA(0), ADA4=>AddressA(1), ADA5=>AddressA(2), 
            ADA6=>AddressA(3), ADA7=>AddressA(4), ADA8=>AddressA(5), 
            ADA9=>AddressA(6), ADA10=>AddressA(7), ADA11=>AddressA(8), 
            ADA12=>AddressA(9), ADA13=>AddressA(10), CEA=>ClockEnA, 
            CLKA=>ClockA, WEA=>WrA, CSA0=>AddressA(11), 
            CSA1=>AddressA(12), CSA2=>scuba_vlo, RSTA=>ResetA, 
            DIB0=>DataInB(0), DIB1=>DataInB(1), DIB2=>DataInB(2), 
            DIB3=>DataInB(3), DIB4=>DataInB(4), DIB5=>DataInB(5), 
            DIB6=>DataInB(6), DIB7=>DataInB(7), DIB8=>DataInB(8), 
            DIB9=>scuba_vlo, DIB10=>scuba_vlo, DIB11=>scuba_vlo, 
            DIB12=>scuba_vlo, DIB13=>scuba_vlo, DIB14=>scuba_vlo, 
            DIB15=>scuba_vlo, DIB16=>scuba_vlo, DIB17=>scuba_vlo, 
            ADB0=>scuba_vlo, ADB1=>scuba_vlo, ADB2=>scuba_vlo, 
            ADB3=>AddressB(0), ADB4=>AddressB(1), ADB5=>AddressB(2), 
            ADB6=>AddressB(3), ADB7=>AddressB(4), ADB8=>AddressB(5), 
            ADB9=>AddressB(6), ADB10=>AddressB(7), ADB11=>AddressB(8), 
            ADB12=>AddressB(9), ADB13=>AddressB(10), CEB=>ClockEnB, 
            CLKB=>ClockB, WEB=>WrB, CSB0=>AddressB(11), 
            CSB1=>AddressB(12), CSB2=>scuba_vlo, RSTB=>ResetB, 
            DOA0=>mdout0_1_0, DOA1=>mdout0_1_1, DOA2=>mdout0_1_2, 
            DOA3=>mdout0_1_3, DOA4=>mdout0_1_4, DOA5=>mdout0_1_5, 
            DOA6=>mdout0_1_6, DOA7=>mdout0_1_7, DOA8=>mdout0_1_8, 
            DOA9=>open, DOA10=>open, DOA11=>open, DOA12=>open, 
            DOA13=>open, DOA14=>open, DOA15=>open, DOA16=>open, 
            DOA17=>open, DOB0=>mdout1_1_0, DOB1=>mdout1_1_1, 
            DOB2=>mdout1_1_2, DOB3=>mdout1_1_3, DOB4=>mdout1_1_4, 
            DOB5=>mdout1_1_5, DOB6=>mdout1_1_6, DOB7=>mdout1_1_7, 
            DOB8=>mdout1_1_8, DOB9=>open, DOB10=>open, DOB11=>open, 
            DOB12=>open, DOB13=>open, DOB14=>open, DOB15=>open, 
            DOB16=>open, DOB17=>open);

    internal_datamem_16_1_1_0: DP16KB
        -- synopsys translate_off
        generic map (CSDECODE_B=> "010", CSDECODE_A=> "010", WRITEMODE_B=> "NORMAL", 
        WRITEMODE_A=> "NORMAL", GSR=> "DISABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9, 
        DATA_WIDTH_A=>  9)
        -- synopsys translate_on
        port map (DIA0=>DataInA(9), DIA1=>DataInA(10), DIA2=>DataInA(11), 
            DIA3=>DataInA(12), DIA4=>DataInA(13), DIA5=>DataInA(14), 
            DIA6=>DataInA(15), DIA7=>scuba_vlo, DIA8=>scuba_vlo, 
            DIA9=>scuba_vlo, DIA10=>scuba_vlo, DIA11=>scuba_vlo, 
            DIA12=>scuba_vlo, DIA13=>scuba_vlo, DIA14=>scuba_vlo, 
            DIA15=>scuba_vlo, DIA16=>scuba_vlo, DIA17=>scuba_vlo, 
            ADA0=>scuba_vlo, ADA1=>scuba_vlo, ADA2=>scuba_vlo, 
            ADA3=>AddressA(0), ADA4=>AddressA(1), ADA5=>AddressA(2), 
            ADA6=>AddressA(3), ADA7=>AddressA(4), ADA8=>AddressA(5), 
            ADA9=>AddressA(6), ADA10=>AddressA(7), ADA11=>AddressA(8), 
            ADA12=>AddressA(9), ADA13=>AddressA(10), CEA=>ClockEnA, 
            CLKA=>ClockA, WEA=>WrA, CSA0=>AddressA(11), 
            CSA1=>AddressA(12), CSA2=>scuba_vlo, RSTA=>ResetA, 
            DIB0=>DataInB(9), DIB1=>DataInB(10), DIB2=>DataInB(11), 
            DIB3=>DataInB(12), DIB4=>DataInB(13), DIB5=>DataInB(14), 
            DIB6=>DataInB(15), DIB7=>scuba_vlo, DIB8=>scuba_vlo, 
            DIB9=>scuba_vlo, DIB10=>scuba_vlo, DIB11=>scuba_vlo, 
            DIB12=>scuba_vlo, DIB13=>scuba_vlo, DIB14=>scuba_vlo, 
            DIB15=>scuba_vlo, DIB16=>scuba_vlo, DIB17=>scuba_vlo, 
            ADB0=>scuba_vlo, ADB1=>scuba_vlo, ADB2=>scuba_vlo, 
            ADB3=>AddressB(0), ADB4=>AddressB(1), ADB5=>AddressB(2), 
            ADB6=>AddressB(3), ADB7=>AddressB(4), ADB8=>AddressB(5), 
            ADB9=>AddressB(6), ADB10=>AddressB(7), ADB11=>AddressB(8), 
            ADB12=>AddressB(9), ADB13=>AddressB(10), CEB=>ClockEnB, 
            CLKB=>ClockB, WEB=>WrB, CSB0=>AddressB(11), 
            CSB1=>AddressB(12), CSB2=>scuba_vlo, RSTB=>ResetB, 
            DOA0=>mdout0_1_9, DOA1=>mdout0_1_10, DOA2=>mdout0_1_11, 
            DOA3=>mdout0_1_12, DOA4=>mdout0_1_13, DOA5=>mdout0_1_14, 
            DOA6=>mdout0_1_15, DOA7=>open, DOA8=>open, DOA9=>open, 
            DOA10=>open, DOA11=>open, DOA12=>open, DOA13=>open, 
            DOA14=>open, DOA15=>open, DOA16=>open, DOA17=>open, 
            DOB0=>mdout1_1_9, DOB1=>mdout1_1_10, DOB2=>mdout1_1_11, 
            DOB3=>mdout1_1_12, DOB4=>mdout1_1_13, DOB5=>mdout1_1_14, 
            DOB6=>mdout1_1_15, DOB7=>open, DOB8=>open, DOB9=>open, 
            DOB10=>open, DOB11=>open, DOB12=>open, DOB13=>open, 
            DOB14=>open, DOB15=>open, DOB16=>open, DOB17=>open);

    FF_1: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>AddressA(12), SP=>wren0_inv_g, CK=>ClockA, 
            CD=>scuba_vlo, Q=>addr012_ff);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    FF_0: FD1P3DX
        -- synopsys translate_off
        generic map (GSR=> "ENABLED")
        -- synopsys translate_on
        port map (D=>AddressB(12), SP=>wren1_inv_g, CK=>ClockB, 
            CD=>scuba_vlo, Q=>addr112_ff);

    mux_31: MUX21
        port map (D0=>mdout0_0_0, D1=>mdout0_1_0, SD=>addr012_ff, 
            Z=>QA(0));

    mux_30: MUX21
        port map (D0=>mdout0_0_1, D1=>mdout0_1_1, SD=>addr012_ff, 
            Z=>QA(1));

    mux_29: MUX21
        port map (D0=>mdout0_0_2, D1=>mdout0_1_2, SD=>addr012_ff, 
            Z=>QA(2));

    mux_28: MUX21
        port map (D0=>mdout0_0_3, D1=>mdout0_1_3, SD=>addr012_ff, 
            Z=>QA(3));

    mux_27: MUX21
        port map (D0=>mdout0_0_4, D1=>mdout0_1_4, SD=>addr012_ff, 
            Z=>QA(4));

    mux_26: MUX21
        port map (D0=>mdout0_0_5, D1=>mdout0_1_5, SD=>addr012_ff, 
            Z=>QA(5));

    mux_25: MUX21
        port map (D0=>mdout0_0_6, D1=>mdout0_1_6, SD=>addr012_ff, 
            Z=>QA(6));

    mux_24: MUX21
        port map (D0=>mdout0_0_7, D1=>mdout0_1_7, SD=>addr012_ff, 
            Z=>QA(7));

    mux_23: MUX21
        port map (D0=>mdout0_0_8, D1=>mdout0_1_8, SD=>addr012_ff, 
            Z=>QA(8));

    mux_22: MUX21
        port map (D0=>mdout0_0_9, D1=>mdout0_1_9, SD=>addr012_ff, 
            Z=>QA(9));

    mux_21: MUX21
        port map (D0=>mdout0_0_10, D1=>mdout0_1_10, SD=>addr012_ff, 
            Z=>QA(10));

    mux_20: MUX21
        port map (D0=>mdout0_0_11, D1=>mdout0_1_11, SD=>addr012_ff, 
            Z=>QA(11));

    mux_19: MUX21
        port map (D0=>mdout0_0_12, D1=>mdout0_1_12, SD=>addr012_ff, 
            Z=>QA(12));

    mux_18: MUX21
        port map (D0=>mdout0_0_13, D1=>mdout0_1_13, SD=>addr012_ff, 
            Z=>QA(13));

    mux_17: MUX21
        port map (D0=>mdout0_0_14, D1=>mdout0_1_14, SD=>addr012_ff, 
            Z=>QA(14));

    mux_16: MUX21
        port map (D0=>mdout0_0_15, D1=>mdout0_1_15, SD=>addr012_ff, 
            Z=>QA(15));

    mux_15: MUX21
        port map (D0=>mdout1_0_0, D1=>mdout1_1_0, SD=>addr112_ff, 
            Z=>QB(0));

    mux_14: MUX21
        port map (D0=>mdout1_0_1, D1=>mdout1_1_1, SD=>addr112_ff, 
            Z=>QB(1));

    mux_13: MUX21
        port map (D0=>mdout1_0_2, D1=>mdout1_1_2, SD=>addr112_ff, 
            Z=>QB(2));

    mux_12: MUX21
        port map (D0=>mdout1_0_3, D1=>mdout1_1_3, SD=>addr112_ff, 
            Z=>QB(3));

    mux_11: MUX21
        port map (D0=>mdout1_0_4, D1=>mdout1_1_4, SD=>addr112_ff, 
            Z=>QB(4));

    mux_10: MUX21
        port map (D0=>mdout1_0_5, D1=>mdout1_1_5, SD=>addr112_ff, 
            Z=>QB(5));

    mux_9: MUX21
        port map (D0=>mdout1_0_6, D1=>mdout1_1_6, SD=>addr112_ff, 
            Z=>QB(6));

    mux_8: MUX21
        port map (D0=>mdout1_0_7, D1=>mdout1_1_7, SD=>addr112_ff, 
            Z=>QB(7));

    mux_7: MUX21
        port map (D0=>mdout1_0_8, D1=>mdout1_1_8, SD=>addr112_ff, 
            Z=>QB(8));

    mux_6: MUX21
        port map (D0=>mdout1_0_9, D1=>mdout1_1_9, SD=>addr112_ff, 
            Z=>QB(9));

    mux_5: MUX21
        port map (D0=>mdout1_0_10, D1=>mdout1_1_10, SD=>addr112_ff, 
            Z=>QB(10));

    mux_4: MUX21
        port map (D0=>mdout1_0_11, D1=>mdout1_1_11, SD=>addr112_ff, 
            Z=>QB(11));

    mux_3: MUX21
        port map (D0=>mdout1_0_12, D1=>mdout1_1_12, SD=>addr112_ff, 
            Z=>QB(12));

    mux_2: MUX21
        port map (D0=>mdout1_0_13, D1=>mdout1_1_13, SD=>addr112_ff, 
            Z=>QB(13));

    mux_1: MUX21
        port map (D0=>mdout1_0_14, D1=>mdout1_1_14, SD=>addr112_ff, 
            Z=>QB(14));

    mux_0: MUX21
        port map (D0=>mdout1_0_15, D1=>mdout1_1_15, SD=>addr112_ff, 
            Z=>QB(15));

end Structure;

-- synopsys translate_off
library xp2;
configuration Structure_CON of internal_datamem_16 is
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
