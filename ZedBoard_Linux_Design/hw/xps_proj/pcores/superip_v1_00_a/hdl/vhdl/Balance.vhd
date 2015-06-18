----------------------------------------------------------------------------------
-- Company: TTU_SoCDesign
-- Engineer: Mohamed Behery
-- 
-- Create Date:    16:51:21 04/29/2015
-- Design Name:    Panning unit
-- Module Name:    Balance - Behavioral
-- Project Name:   Audio mixer
-- Target Devices: ZedBoard (Zynq7000)
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Balance is
	generic(INTBIT_WIDTH      : positive ;
		    FRACBIT_WIDTH     : positive ;
		    N                 : positive ;
		    Attenuation_Const : positive ); -- This constant is for attenuating the input signals so that the signal is not chopped if amplified

	Port(CLK_BAL          : in  std_logic;
		 RESET_BAL        : in  std_logic;
		 POINTER          : in  integer;
		 CH_L_IN, CH_R_IN : in  signed(INTBIT_WIDTH - 1 downto 0);
		 
		 CH_L_OUT         : out signed(INTBIT_WIDTH - 1 downto 0) := x"000000";
		 CH_R_OUT         : out signed(INTBIT_WIDTH - 1 downto 0) := x"000000";
		 READY_BAL        : out std_logic                         := '0'
	);
end Balance;

Architecture Behavioral of Balance is
	type Coeff_Array is array (0 to N / 2) of signed((INTBIT_WIDTH + FRACBIT_WIDTH) - 1 downto 0);

	--      Coeffecients calculated via the Matlab m-file (check the Matlab code in the last code section)

	--  constant Amp_Coeff      :   Coeff_Array := (500,667,767,867,909,923,937,951,962,967,972,977,982,986,991,995,1000); --The second half of the balance graph has it's amplification values placed in Amp_Coeff array
	--  constant Att_Coeff      :   Coeff_Array := (500,333,233,133,91,77,63,49,38,33,28,23,18,14,9,5,0);                  --The second half of the balance graph has it's attenuation values placed in Att_Coeff array                                                               

	constant Amp_Coeff : Coeff_Array := (x"0001F400", x"00029B00", x"0002FF00", x"00036300", x"00038D00", x"00039B00", x"0003A900", x"0003B700", x"0003C200", x"0003C700", x"0003CC00", x"0003D100", x"0003D600", x"0003DA00", x"0003DF00", x"0003E300", x"0003E800");
	constant Att_Coeff : Coeff_Array := (x"0001F400", x"00014D00", x"0000E900", x"00008500", x"00005B00", x"00004D00", x"00003F00", x"00003100", x"00002600", x"00002100", x"00001C00", x"00001700", x"00001200", x"00000E00", x"00000900", x"00000500", x"00000000");

	signal Coeff_Left         : signed((INTBIT_WIDTH + FRACBIT_WIDTH) - 1 downto 0);
	signal Coeff_Right        : signed((INTBIT_WIDTH + FRACBIT_WIDTH) - 1 downto 0);
	signal ready_signal_right : STD_LOGIC;
	signal ready_signal_left  : STD_LOGIC;
	signal CH_R_IN_signal     : signed(INTBIT_WIDTH - 1 downto 0);
	signal CH_L_IN_signal     : signed(INTBIT_WIDTH - 1 downto 0);
	signal CH_L_OUT_signal    : signed(INTBIT_WIDTH - 1 downto 0);
	signal CH_R_OUT_signal    : signed(INTBIT_WIDTH - 1 downto 0);

	component AmplifierFP
		Port(
			CLK     : in  std_logic;
			RESET   : in  std_logic;
			IN_SIG  : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal
			IN_COEF : in  signed((INTBIT_WIDTH + FRACBIT_WIDTH - 1) downto 0) := (others => '0'); --amplifying coefficient
			OUT_AMP : out signed((INTBIT_WIDTH - 1) downto 0)                 := (others => '0'); --amplifier output
			OUT_RDY : out std_logic
		);
	end component;

begin
	Mult_Left : AmplifierFP port map(
			CLK     => CLK_BAL,
			RESET   => RESET_BAL,
			IN_SIG  => CH_L_IN_signal,
			IN_COEF => Coeff_Left,
			OUT_AMP => CH_L_OUT_signal,
			OUT_RDY => ready_signal_left
		);
	Mult_Right : AmplifierFP port map(
			CLK     => CLK_BAL,
			RESET   => RESET_BAL,
			IN_SIG  => CH_R_IN_signal,
			IN_COEF => Coeff_right,
			OUT_AMP => CH_R_OUT_signal,
			OUT_RDY => ready_signal_right
		);

	READY_BAL      <= (ready_signal_right and ready_signal_left);
	CH_L_IN_signal <= shift_right(CH_L_IN, Attenuation_Const); -- Attenuating the incoming data from the outside by 6dB 
	CH_R_IN_signal <= shift_right(CH_R_IN, Attenuation_Const); -- Attenuating the incoming data from the outside by 6dB

	Combinational : process(POINTER)    -- Here according to the value of the POINTER the coefficient graph "half" is either kept as it is or it's inverted
	begin
		if (POINTER > N / 2) then       -- Case 1: Amplify Right and Attenuate Left    
			Coeff_Right <= Amp_Coeff(POINTER - N / 2); -- If the POINTER is above 50% the graph is kept as it is
			Coeff_Left  <= Att_Coeff(POINTER - N / 2);
		elsif (POINTER < N / 2) then    -- Case 2: Amplify Left and Attenuate Right        
			Coeff_Right <= Att_Coeff(N / 2 - POINTER); -- If the POINTER is below 50% the graph is inverted
			Coeff_Left  <= Amp_Coeff(N / 2 - POINTER);
		else
			Coeff_Right <= Att_Coeff(0); -- else: the POINTER = 50%, give the coefficients the 0th value in the array   
			Coeff_Left  <= Amp_Coeff(0);
		end if;
	end process Combinational;

	Sequential : process(CLK_BAL)
	begin
		if (CLK_BAL'event and CLK_BAL = '1') then
			CH_L_OUT <= CH_L_OUT_signal;
			CH_R_OUT <= CH_R_OUT_signal;
		end if;
	end process Sequential;
end Behavioral;