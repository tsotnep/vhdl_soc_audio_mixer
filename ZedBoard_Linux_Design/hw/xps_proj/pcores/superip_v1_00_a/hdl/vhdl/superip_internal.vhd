library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity superip_internal is
	port(
		-- Outputs
		Mux2_FilterORMux1_Left_out  : out std_logic_vector(23 downto 0);
		Mux2_FilterORMux1_Right_out : out std_logic_vector(23 downto 0);
		slv_reg28                   : out STD_LOGIC_VECTOR(31 downto 0);
		slv_reg29                   : out STD_LOGIC_VECTOR(31 downto 0);
		slv_reg30                   : out STD_LOGIC_VECTOR(31 downto 0);
		slv_reg31                   : out STD_LOGIC_VECTOR(31 downto 0);

		-- Inputs
		CLK_48_in                   : in  std_logic;
		CLK_100M_in                 : in  std_logic;
		Audio_Left_in               : in  std_logic_vector(23 downto 0);
		Audio_Right_in              : in  std_logic_vector(23 downto 0);
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
		slv_reg26                   : in  STD_LOGIC_VECTOR(31 downto 0);
		slv_reg27                   : in  STD_LOGIC_VECTOR(31 downto 0)
	);
end entity superip_internal;

architecture RTL of superip_internal is
	-- Outputs Register31
	ALIAS OUT_RDY_L        : STD_LOGIC is slv_reg31(0);
	ALIAS VolCtrl_RDY_R    : STD_LOGIC is slv_reg31(1);
	ALIAS Filter_ready_out : STD_LOGIC is slv_reg31(2);

	-- Inputs Register27
	ALIAS Reset_in            : STD_LOGIC is slv_reg27(0);
	ALIAS SAMPLE_TRIG         : STD_LOGIC is slv_reg27(1);
	ALIAS HP_SW               : STD_LOGIC is slv_reg27(2);
	ALIAS BP_SW               : STD_LOGIC is slv_reg27(3);
	ALIAS LP_SW               : STD_LOGIC is slv_reg27(4);
	ALIAS Mux1_Mux2_Select_in : std_logic_vector is slv_reg27(6 downto 5); 
					--5th -> Mux1:= Volctrl or rawAudio; 	0 for Volctrl pass
					--6th -> Mux2:= Filter or Mux1; 	0 for Filter pass

	ALIAS sample_trigger_en   : STD_LOGIC is slv_reg27(7); 
					--if this signal is '1' filter waits for sample triggers
					--otherwise, its constantly calculating

	-- Internals
	signal Mux1_VolCtrlORAudio_Left_out  : std_logic_vector(23 downto 0);
	signal Mux1_VolCtrlORAudio_Right_out : std_logic_vector(23 downto 0);
	signal Filter_Left_out               : std_logic_vector(23 downto 0);
	signal Filter_Right_out              : std_logic_vector(23 downto 0);
	signal OUT_VOLCTRL_L                 : signed(23 downto 0);
	signal OUT_VOLCTRL_R                 : signed(23 downto 0);
--	signal Volctrl_Left_out              : std_logic_vector(23 downto 0);
--	signal Volctrl_Right_out             : std_logic_vector(23 downto 0);
--	signal slv_reg15_s                   : signed(31 downto 0);
--	signal slv_reg16_s                   : signed(31 downto 0);
--	signal Audio_Left_in_s               : signed(23 downto 0);
--	signal Audio_Right_in_s              : signed(23 downto 0);

begin
	--------------------------START VolCtrl--------------
	--input
	--	slv_reg15_s       <= signed(slv_reg15);
	--	slv_reg16_s       <= signed(slv_reg16);
	--	Audio_Left_in_s   <= signed(Audio_Left_in);
	--	Audio_Right_in_s  <= signed(Audio_Right_in);
	--------------------------END VolCtrl----------------

	--	Mux2_FilterORMux1_Left_out  <= Filter_Left_out;
	--	Mux2_FilterORMux1_Right_out <= Filter_Right_out;

	--	Mux1_VolCtrlORAudio_Left_out  <= std_logic_vector(OUT_VOLCTRL_L);
	--	Mux1_VolCtrlORAudio_Right_out <= std_logic_vector(OUT_VOLCTRL_R);

	Tester_Comp : entity work.Tester
		port map(
			Audio_Left_in                 => Audio_Left_in,
			Audio_Right_in                => Audio_Right_in,
			VolCtrl_Left_out_in           => std_logic_vector(OUT_VOLCTRL_L),
			VolCtrl_Right_out_in          => std_logic_vector(OUT_VOLCTRL_R),
			Mux1_VolCtrlORAudio_Left_out  => Mux1_VolCtrlORAudio_Left_out,
			Mux1_VolCtrlORAudio_Right_out => Mux1_VolCtrlORAudio_Right_out,
			Filter_Left_out_in            => Filter_Left_out,
			Filter_Right_out_in           => Filter_Right_out,
			Mux2_FilterORMux1_Left_out    => Mux2_FilterORMux1_Left_out,
			Mux2_FilterORMux1_Right_out   => Mux2_FilterORMux1_Right_out,
			Mux1_Mux2_Select_in           => Mux1_Mux2_Select_in
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
			RST               => Reset_in,
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

end architecture RTL;
