library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity superip_internal is
	port(
		-- Outputs
		Mux2_FilterORMux1_Left_out  : out std_logic_vector(23 downto 0);
		Mux2_FilterORMux1_Right_out : out std_logic_vector(23 downto 0);
		slv_reg26                   : out STD_LOGIC_VECTOR(31 downto 0);
		slv_reg28                   : out STD_LOGIC_VECTOR(31 downto 0);
		slv_reg29                   : out STD_LOGIC_VECTOR(31 downto 0);
		slv_reg30                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg31                   : in  STD_LOGIC_VECTOR(31 downto 0);

		-- Inputs
		CLK_48_in                   : in  std_logic;
		CLK_100M_in                 : in  std_logic;
		Audio_Left_in               : in  std_logic_vector(23 downto 0);
		Audio_Right_in              : in  std_logic_vector(23 downto 0);
		SAMPLE_TRIG                 : in  std_logic;

		-- REGISTERS
		slv_reg0                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg1                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg2                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg3                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg4                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg5                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg6                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg7                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg8                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg9                    : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg10                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg11                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg12                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg13                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg14                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg15                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg16                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg17                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg18                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg19                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg20                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg21                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg22                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg23                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg24                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg25                   : in  STD_LOGIC_VECTOR(31 downto 0);
		--register 26 is output, flags go there
		slv_reg27                   : in  STD_LOGIC_VECTOR(31 downto 0)
	);
end entity superip_internal;

architecture RTL of superip_internal is
	-- Outputs Register 26
	ALIAS OUT_RDY_L        : STD_LOGIC is slv_reg26(0);
	ALIAS VolCtrl_RDY_R    : STD_LOGIC is slv_reg26(1);
	ALIAS Filter_ready_out : STD_LOGIC is slv_reg26(2);
	ALIAS READY_BAL        : STD_LOGIC is slv_reg26(3);

	-- Inputs Register 27
	ALIAS HP_SW             : STD_LOGIC is slv_reg27(0);
	ALIAS BP_SW             : STD_LOGIC is slv_reg27(4);
	ALIAS LP_SW             : STD_LOGIC is slv_reg27(8);
	ALIAS Reset_Filter      : STD_LOGIC is slv_reg27(12);
	ALIAS Reset_in          : STD_LOGIC is slv_reg27(16);
	ALIAS sample_trigger_en : STD_LOGIC is slv_reg27(20);
	ALIAS Mux_Select_in     : std_logic_vector is slv_reg27(26 downto 24);
	ALIAS bus_frames_en     : std_logic is slv_reg27(31);

	--24th -> Mux1:= Volctrl or rawAudio; 	0 for Volctrl pass
	--25th -> Mux2:= Filter or Mux1; 		0 for Filter pass
	--26th -> mux3:= Balance or Mux2    	0 for Balance pass


	--if this signal is '1' filter waits for sample triggers
	--otherwise, its constantly calculating

	-- Internals
	signal Mux3_BalanceORMux2_Left       : std_logic_vector(23 downto 0);
	signal Mux3_BalanceORMux2_Right      : std_logic_vector(23 downto 0);
	signal Mux1_VolCtrlORAudio_Left_out  : std_logic_vector(23 downto 0);
	signal Mux1_VolCtrlORAudio_Right_out : std_logic_vector(23 downto 0);
	signal Mux2_FilterORMux1_Left        : std_logic_vector(23 downto 0);
	signal Mux2_FilterORMux1_Right       : std_logic_vector(23 downto 0);
	signal Filter_Left_out               : std_logic_vector(23 downto 0);
	signal Filter_Right_out              : std_logic_vector(23 downto 0);
	signal OUT_VOLCTRL_L                 : signed(23 downto 0);
	signal OUT_VOLCTRL_R                 : signed(23 downto 0);
	signal CH_L_OUT                      : signed(23 downto 0);
	signal CH_R_OUT                      : signed(23 downto 0);

begin
	slv_reg28 <= x"00" & Mux3_BalanceORMux2_Left;
	slv_reg29 <= x"00" & Mux3_BalanceORMux2_Right;

	Mux_Frames_or_internal : process(Mux3_BalanceORMux2_Left, Mux3_BalanceORMux2_Right, slv_reg27(31), slv_reg30(23 downto 0), slv_reg31(23 downto 0))
	begin
		if bus_frames_en = '0' then     --i changed this, it was 0 before
			Mux2_FilterORMux1_Left_out  <= Mux3_BalanceORMux2_Left; --Mux2_FilterORMux1_Left_out" should be "Mux3_BalanceORMux2_Left_out" instead
			Mux2_FilterORMux1_Right_out <= Mux3_BalanceORMux2_Right;
		else
			Mux2_FilterORMux1_Left_out  <= slv_reg30(23 downto 0);
			Mux2_FilterORMux1_Right_out <= slv_reg31(23 downto 0);
		end if;
	end process;

	Tester_inst : entity work.Tester
		port map(
			Audio_Left_in                 => Audio_Left_in,
			Audio_Right_in                => Audio_Right_in,
			VolCtrl_Left_out_in           => std_logic_vector(OUT_VOLCTRL_L),
			VolCtrl_Right_out_in          => std_logic_vector(OUT_VOLCTRL_R),
			Mux1_VolCtrlORAudio_Left_out  => Mux1_VolCtrlORAudio_Left_out,
			Mux1_VolCtrlORAudio_Right_out => Mux1_VolCtrlORAudio_Right_out,
			Filter_Left_out_in            => Filter_Left_out,
			Filter_Right_out_in           => Filter_Right_out,
			Mux2_FilterORMux1_Left_out    => Mux2_FilterORMux1_Left, --Mux2_FilterORMux1_Left_out
			Mux2_FilterORMux1_Right_out   => Mux2_FilterORMux1_Right, --Mux2_FilterORMux1_Right_out
			Balance_Left_out_in           => std_logic_vector(CH_L_OUT),
			Balance_Right_out_in          => std_logic_vector(CH_R_OUT),
			Mux3_BalanceORMux2_Left_out   => Mux3_BalanceORMux2_Left, --Mux3_BalanceORMux2_Left_out
			Mux3_BalanceORMux2_Right_out  => Mux3_BalanceORMux2_Right, --Mux3_BalanceORMux2_Right_out
			Mux_Select_in                 => Mux_Select_in
		);

	VolCtrl_inst : entity work.VolCtrl
		generic map(
			INTBIT_WIDTH  => 24,
			FRACBIT_WIDTH => 8
		)
		port map(
			OUT_VOLCTRL_L => OUT_VOLCTRL_L,
			OUT_VOLCTRL_R => OUT_VOLCTRL_R,
			OUT_RDY_L     => OUT_RDY_L,
			OUT_RDY_R     => VolCtrl_RDY_R,
			IN_SIG_L      => signed(Audio_Left_in),
			IN_SIG_R      => signed(Audio_Right_in),
			IN_COEF_L     => signed(slv_reg15),
			IN_COEF_R     => signed(slv_reg16),
			RESET         => Reset_in,
			CLK_48        => CLK_48_in,
			CLK_100M      => CLK_100M_in
		);

	filter_Comp : entity work.Filter_Top_Level
		port map(
			slv_reg0          => slv_reg0,
			slv_reg1          => slv_reg1,
			slv_reg2          => slv_reg2,
			slv_reg3          => slv_reg3,
			slv_reg4          => slv_reg4,
			slv_reg5          => slv_reg5,
			slv_reg6          => slv_reg6,
			slv_reg7          => slv_reg7,
			slv_reg8          => slv_reg8,
			slv_reg9          => slv_reg9,
			slv_reg10         => slv_reg10,
			slv_reg11         => slv_reg11,
			slv_reg12         => slv_reg12,
			slv_reg13         => slv_reg13,
			slv_reg14         => slv_reg14,
			CLK_48            => CLK_48_in,
			RST               => Reset_Filter,
			SAMPLE_TRIG       => SAMPLE_TRIG,
			sample_trigger_en => sample_trigger_en,
			HP_SW             => HP_SW,
			BP_SW             => BP_SW,
			LP_SW             => LP_SW,
			AUDIO_IN_L        => Mux1_VolCtrlORAudio_Left_out,
			AUDIO_IN_R        => Mux1_VolCtrlORAudio_Right_out,
			AUDIO_OUT_L       => Filter_Left_out,
			AUDIO_OUT_R       => Filter_Right_out,
			FILTER_DONE       => Filter_ready_out
		);

	Balance_inst : entity work.Balance
		generic map(
			INTBIT_WIDTH      => 24,
			FRACBIT_WIDTH     => 8,
			N                 => 32,
			Attenuation_Const => 11
		)
		port map(
			CLK_BAL   => CLK_48_in,
			RESET_BAL => Reset_in,
			POINTER   => to_integer(signed(slv_reg17)),
			CH_L_IN   => signed(Mux2_FilterORMux1_Left),
			CH_R_IN   => signed(Mux2_FilterORMux1_Right),
			CH_L_OUT  => CH_L_OUT,
			CH_R_OUT  => CH_R_OUT,
			READY_BAL => READY_BAL
		);

end architecture RTL;
