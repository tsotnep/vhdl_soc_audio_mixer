library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Tester is
	port(
		Audio_Left_in                 : in  std_logic_vector(23 downto 0);
		Audio_Right_in                : in  std_logic_vector(23 downto 0);
		Pregain_Left_out_in           : in  std_logic_vector(23 downto 0);
		Pregain_Right_out_in          : in  std_logic_vector(23 downto 0);

		Mux1_PregainORAudio_Left_out  : out std_logic_vector(23 downto 0);
		Mux1_PregainORAudio_Right_out : out std_logic_vector(23 downto 0);

		Filter_Left_out               : in  std_logic_vector(23 downto 0);
		Filter_Right_out              : in  std_logic_vector(23 downto 0);

		Mux2_FilterORMux1_Left_out    : out std_logic_vector(23 downto 0);
		Mux2_FilterORMux1_Right_out   : out std_logic_vector(23 downto 0);

		Mux1_Mux2_Select_in           : in  std_logic_vector(1 downto 0));

end Tester;

architecture Behavioral of Tester is
	signal Mux1_PregainORAudio_Left_out_T  : std_logic_vector(23 downto 0);
	signal Mux1_PregainORAudio_Right_out_T : std_logic_vector(23 downto 0);

begin
	Mux1_PregainORAudio_Left_out  <= Mux1_PregainORAudio_Left_out_T;
	Mux1_PregainORAudio_Right_out <= Mux1_PregainORAudio_Right_out_T;

	MUX1 : process(Audio_Left_in, Audio_Right_in, Mux1_Mux2_Select_in(0), Pregain_Left_out_in, Pregain_Right_out_in)
	begin
		if Mux1_Mux2_Select_in(0) = '0' then
			Mux1_PregainORAudio_Left_out_T  <= Audio_Left_in;
			Mux1_PregainORAudio_Right_out_T <= Audio_Right_in;
		else
			Mux1_PregainORAudio_Left_out_T  <= Pregain_Left_out_in;
			Mux1_PregainORAudio_Right_out_T <= Pregain_Right_out_in;
		end if;
	end process;

	MUX2 : process(Filter_Left_out, Filter_Right_out, Mux1_Mux2_Select_in(1), Mux1_PregainORAudio_Left_out_T, Mux1_PregainORAudio_Right_out_T)
	begin
		if Mux1_Mux2_Select_in(1) = '0' then
			Mux2_FilterORMux1_Left_out  <= Mux1_PregainORAudio_Left_out_T;
			Mux2_FilterORMux1_Right_out <= Mux1_PregainORAudio_Right_out_T;
		else
			Mux2_FilterORMux1_Left_out  <= Filter_Left_out;
			Mux2_FilterORMux1_Right_out <= Filter_Right_out;
		end if;
	end process;

end Behavioral;


