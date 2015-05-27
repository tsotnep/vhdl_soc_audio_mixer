----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:51:05 05/05/2015 
-- Design Name: 
-- Module Name:    Filter_Top_Level - RTL 
-- Project Name: 
-- Target Devices: 
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
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Filter_Top_Level is
    Port ( slv_reg0 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg1 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg2 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg3 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg4 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg5 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg6 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg7 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg8 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg9 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg10 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg11 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg12 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg13 : in  STD_LOGIC_VECTOR (31 downto 0);
           slv_reg14 : in  STD_LOGIC_VECTOR (31 downto 0);
           CLK							: in std_logic;
			  --CLK_100M						: in std_logic;
           RST								: in std_logic;
           SAMPLE_TRIG						: in std_logic;
           HP_SW							: in std_logic;
           BP_SW							: in std_logic;
           LP_SW							: in std_logic;
           AUDIO_IN_L 						: in std_logic_vector(23 downto 0);
           AUDIO_IN_R 						: in std_logic_vector(23 downto 0);
           AUDIO_OUT_L						: out std_logic_vector(23 downto 0);
           AUDIO_OUT_R 					: out std_logic_vector(23 downto 0);
           FILTER_DONE						: out std_logic
--           clk : in  STD_LOGIC;
--           rst : in  STD_LOGIC;
--           sample_trig : in  STD_LOGIC;
--           Audio_in : in  STD_LOGIC_VECTOR (23 downto 0);
--           filter_done : in  STD_LOGIC;
--           Audio_out : in  STD_LOGIC_VECTOR (23 downto 0)
				);
end Filter_Top_Level;

architecture RTL of Filter_Top_Level is

Component IIR_Biquad_II_v3 is
		Port ( 
				Coef_b0 : std_logic_vector(31 downto 0);
				Coef_b1 : std_logic_vector(31 downto 0);
				Coef_b2 : std_logic_vector(31 downto 0);
				Coef_a1 : std_logic_vector(31 downto 0);
				Coef_a2 : std_logic_vector(31 downto 0);
				clk : in  STD_LOGIC;
				rst : in  STD_LOGIC;
				sample_trig : in  STD_LOGIC;
				X_in : in  STD_LOGIC_VECTOR (23 downto 0);
				filter_done : out STD_LOGIC;
				Y_out : out  STD_LOGIC_VECTOR (23 downto 0)
				);
end Component;

signal IIR_LP_Done_R, IIR_LP_Done_L, IIR_BP_Done_R, IIR_BP_Done_L, IIR_HP_Done_R, IIR_HP_Done_L: std_logic;
signal AUDIO_OUT_TRUNC_L, AUDIO_OUT_TRUNC_R, IIR_LP_Y_Out_R, IIR_LP_Y_Out_L, IIR_BP_Y_Out_R, IIR_BP_Y_Out_L, IIR_HP_Y_Out_R, IIR_HP_Y_Out_L: std_logic_vector(23 downto 0);

begin

--USER logic implementation added here
  
  ---- connect all the "filter done" with an AND gate to the user_logic top level entity.
  FILTER_DONE <= IIR_LP_Done_R and IIR_LP_Done_L and IIR_BP_Done_R and IIR_BP_Done_L and IIR_HP_Done_R and IIR_HP_Done_L;
	
  -----Pad the Audio output with 8 zeros to make it up to 24 bit,
	AUDIO_OUT_L <= AUDIO_OUT_TRUNC_L;-- & X"00";
	AUDIO_OUT_R <=  AUDIO_OUT_TRUNC_R;-- & X"00";
	
	
	
	---this process controls each individual filter and the final output of the filter. 
  process (HP_SW,BP_SW, LP_SW) 
	variable val: std_logic_vector(2 downto 0):= HP_SW & BP_SW & LP_SW;
  begin
	
		case VAL is
			when "000" =>
				AUDIO_OUT_TRUNC_L <= (others => '0');--IIR_LP_Y_Out_L + IIR_BP_Y_Out_L + IIR_HP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= (others => '0');--IIR_LP_Y_Out_R + IIR_BP_Y_Out_R + IIR_HP_Y_Out_R;
			when "001" =>
				AUDIO_OUT_TRUNC_L <= IIR_LP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_LP_Y_Out_R;			
			when "010" =>
				AUDIO_OUT_TRUNC_L <= IIR_BP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_BP_Y_Out_R;			
			when "011" =>
				AUDIO_OUT_TRUNC_L <= IIR_LP_Y_Out_L + IIR_BP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_LP_Y_Out_R + IIR_BP_Y_Out_R;			
			when "100" =>
				AUDIO_OUT_TRUNC_L <= IIR_HP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_HP_Y_Out_R;
			when "101" =>
				AUDIO_OUT_TRUNC_L <= IIR_LP_Y_Out_L + IIR_HP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_LP_Y_Out_R + IIR_HP_Y_Out_R;
			when "110" =>
				AUDIO_OUT_TRUNC_L <= IIR_HP_Y_Out_L + IIR_BP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_HP_Y_Out_R + IIR_BP_Y_Out_R;
			when "111" =>
				AUDIO_OUT_TRUNC_L <= IIR_LP_Y_Out_L + IIR_BP_Y_Out_L + IIR_HP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= IIR_LP_Y_Out_R + IIR_BP_Y_Out_R + IIR_HP_Y_Out_R;
			when others =>
				AUDIO_OUT_TRUNC_L <= (others => '0');--IIR_LP_Y_Out_L + IIR_BP_Y_Out_L + IIR_HP_Y_Out_L;
				AUDIO_OUT_TRUNC_R <= (others => '0');--IIR_LP_Y_Out_R + IIR_BP_Y_Out_R + IIR_HP_Y_Out_R;
				
			end case;
  end process;
  
IIR_LP_R: IIR_Biquad_II_v3
		Port map (
				Coef_b0 => slv_reg0, 
				Coef_b1 => slv_reg1,
				Coef_b2 => slv_reg2,
				Coef_a1 => slv_reg3,
				Coef_a2 => slv_reg4,
				
				clk => CLK,
				rst => rst,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_R(23 downto 0),
				filter_done => IIR_LP_Done_R,
				Y_out => IIR_LP_Y_Out_R
		 );
				
IIR_LP_L: IIR_Biquad_II_v3				
		Port map (
				Coef_b0 => slv_reg0, 
				Coef_b1 => slv_reg1,
				Coef_b2 => slv_reg2,
				Coef_a1 => slv_reg3,
				Coef_a2 => slv_reg4,
				
				clk => CLK,
				rst => rst,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_L(23 downto 0),--X_in_truncated_L,
				filter_done => IIR_LP_Done_L,
				Y_out => IIR_LP_Y_Out_L
				);
		
IIR_BP_R: IIR_Biquad_II_v3 --(20 - 20000)
		Port map (
			Coef_b0 => slv_reg5, 
			Coef_b1 => slv_reg6,
			Coef_b2 => slv_reg7,
			Coef_a1 => slv_reg8,
			Coef_a2 => slv_reg9,
			
			clk => CLK,
			rst => rst,
			sample_trig => '1',--Sample_IIR,
			X_in => AUDIO_IN_R(23 downto 0),--X_in_truncated_R,
			filter_done => IIR_BP_Done_R,
			Y_out => IIR_BP_Y_Out_R
		 );
				
IIR_BP_L: IIR_Biquad_II_v3--(20 - 20000)
			Port map ( 
				Coef_b0 => slv_reg5, 
				Coef_b1 => slv_reg6,
				Coef_b2 => slv_reg7,
				Coef_a1 => slv_reg8,
				Coef_a2 => slv_reg9,
				
				clk => CLK,
				rst => rst,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_L(23 downto 0),--X_in_truncated_L,
				filter_done => IIR_BP_Done_L,
				Y_out => IIR_BP_Y_Out_L
				);

IIR_HP_R: IIR_Biquad_II_v3
		Port map (
				Coef_b0 => slv_reg10, 
				Coef_b1 => slv_reg11,
				Coef_b2 => slv_reg12,
				Coef_a1 => slv_reg13,
				Coef_a2 => slv_reg14,
				
				clk => CLK,
				rst => rst,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_R(23 downto 0),--X_in_truncated_R,
				filter_done => IIR_HP_Done_R,
				Y_out => IIR_HP_Y_Out_R
		 );
				
IIR_HP_L: IIR_Biquad_II_v3
		Port map (
				Coef_b0 => slv_reg10, 
				Coef_b1 => slv_reg11,
				Coef_b2 => slv_reg12,
				Coef_a1 => slv_reg13,
				Coef_a2 => slv_reg14,
				
				clk => CLK,
				rst => rst,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_L(23 downto 0),--X_in_truncated_L,
				filter_done => IIR_HP_Done_L,
				Y_out => IIR_HP_Y_Out_L
				);
end RTL;

