library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Tester is
	port(
		Audio_Left_in                 : in  std_logic_vector(23 downto 0);
		Audio_Right_in                : in  std_logic_vector(23 downto 0);
		
		VolCtrl_Left_out_in           : in  std_logic_vector(23 downto 0);
		VolCtrl_Right_out_in          : in  std_logic_vector(23 downto 0);
		Mux1_VolCtrlORAudio_Left_out  : out std_logic_vector(23 downto 0);
		Mux1_VolCtrlORAudio_Right_out : out std_logic_vector(23 downto 0);

		Filter_Left_out_in            : in  std_logic_vector(23 downto 0);
		Filter_Right_out_in           : in  std_logic_vector(23 downto 0);
		Mux2_FilterORMux1_Left_out    : out std_logic_vector(23 downto 0);
		Mux2_FilterORMux1_Right_out   : out std_logic_vector(23 downto 0);

		Balance_Left_out_in           : in  std_logic_vector(23 downto 0);
		Balance_Right_out_in          : in  std_logic_vector(23 downto 0);
		Mux3_BalanceORMux2_Left_out   : out std_logic_vector(23 downto 0);
		Mux3_BalanceORMux2_Right_out  : out std_logic_vector(23 downto 0);

		Mux_Select_in           : in  std_logic_vector(2 downto 0));

end Tester;

architecture Behavioral of Tester is
	signal Mux1_VolCtrlORAudio_Left_out_T  : std_logic_vector(23 downto 0);
	signal Mux1_VolCtrlORAudio_Right_out_T : std_logic_vector(23 downto 0);

	signal Mux2_FilterORMux1_Left_out_T  : std_logic_vector(23 downto 0);
	signal Mux2_FilterORMux1_Right_out_T : std_logic_vector(23 downto 0);

begin
	Mux1_VolCtrlORAudio_Left_out  <= Mux1_VolCtrlORAudio_Left_out_T;
	Mux1_VolCtrlORAudio_Right_out <= Mux1_VolCtrlORAudio_Right_out_T;
	Mux2_FilterORMux1_Left_out    <= Mux2_FilterORMux1_Left_out_T;
	Mux2_FilterORMux1_Right_out   <= Mux2_FilterORMux1_Right_out_T;

	MUX1 : process(Audio_Left_in, Audio_Right_in, Mux_Select_in(0), VolCtrl_Left_out_in, VolCtrl_Right_out_in)
	begin
		if Mux_Select_in(0) = '0' then
			Mux1_VolCtrlORAudio_Left_out_T  <= VolCtrl_Left_out_in;
			Mux1_VolCtrlORAudio_Right_out_T <= VolCtrl_Right_out_in;
		else
			Mux1_VolCtrlORAudio_Left_out_T  <= Audio_Left_in;
			Mux1_VolCtrlORAudio_Right_out_T <= Audio_Right_in;
		end if;
	end process;

	MUX2 : process(Filter_Left_out_in, Filter_Right_out_in, Mux_Select_in(1), Mux1_VolCtrlORAudio_Left_out_T, Mux1_VolCtrlORAudio_Right_out_T)
	begin
		if Mux_Select_in(1) = '0' then
			Mux2_FilterORMux1_Left_out_T  <= Filter_Left_out_in;
			Mux2_FilterORMux1_Right_out_T <= Filter_Right_out_in;
		else
			Mux2_FilterORMux1_Left_out_T  <= Mux1_VolCtrlORAudio_Left_out_T;
			Mux2_FilterORMux1_Right_out_T <= Mux1_VolCtrlORAudio_Right_out_T;
		end if;
	end process;

	MUX3 : process (Balance_Left_out_in, Balance_Right_out_in, Mux2_FilterORMux1_Left_out_T, Mux2_FilterORMux1_Right_out_T, Mux_Select_in(2))
	begin
		if Mux_Select_in(2) = '0' then
			Mux3_BalanceORMux2_Left_out  <= Balance_Left_out_in;
			Mux3_BalanceORMux2_Right_out <= Balance_Right_out_in;
		else
			Mux3_BalanceORMux2_Left_out  <= Mux2_FilterORMux1_Left_out_T;
			Mux3_BalanceORMux2_Right_out <= Mux2_FilterORMux1_Right_out_T;
		end if;
	end process;
end Behavioral;
