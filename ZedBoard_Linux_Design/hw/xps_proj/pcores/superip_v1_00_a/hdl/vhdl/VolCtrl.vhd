library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VolCtrl is
	generic(INTBIT_WIDTH  : positive;   -- := 24;
		    FRACBIT_WIDTH : positive    --:= 8
	);
	port(
		OUT_VOLCTRL_L : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
		OUT_VOLCTRL_R : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
		OUT_RDY_L     : out STD_LOGIC;
		OUT_RDY_R     : out STD_LOGIC;
		IN_SIG_L      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		IN_SIG_R      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		IN_COEF_L     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		IN_COEF_R     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		RESET         : in  STD_LOGIC;
		CLK_48        : in  STD_LOGIC;
		CLK_100M      : in  STD_LOGIC
	);

end VolCtrl;

architecture Behavioral of VolCtrl is
	COMPONENT AmplifierFP
		PORT(
			CLK     : in  std_logic;
			RESET   : in  std_logic;
			IN_SIG  : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
			IN_COEF : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
			OUT_AMP : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); --amplifier output
			OUT_RDY : out std_logic
		);
	END COMPONENT;

	signal SIG_VOLCTRL_L, SIG_VOLCTRL_R : signed((INTBIT_WIDTH - 1) downto 0) := (others => '0');
	signal AMP_OUT_L, AMP_OUT_R         : signed((INTBIT_WIDTH - 1) downto 0) := (others => '0');
	signal VOLCTRL_L, VOLCTRL_R         : signed((INTBIT_WIDTH - 1) downto 0) := (others => '0');
	signal volctrl_ready_l              : std_logic                           := '0';
	signal volctrl_ready_r              : std_logic                           := '0';

begin
	AmplifierFP_L : AmplifierFP PORT MAP(
			CLK     => CLK_48,
			RESET   => RESET,
			IN_SIG  => IN_SIG_L,
			IN_COEF => IN_COEF_L,
			OUT_AMP => AMP_OUT_L,
			OUT_RDY => volctrl_ready_l
		);

	AmplifierFP_R : AmplifierFP PORT MAP(
			CLK     => CLK_48,
			RESET   => RESET,
			IN_SIG  => IN_SIG_R,
			IN_COEF => IN_COEF_R,
			OUT_AMP => AMP_OUT_R,
			OUT_RDY => volctrl_ready_r
		);

	seq_proc : process(CLK_48)
	begin
		if (CLK_48'event and CLK_48 = '1') then
			--  update the ready signal when new values gets written to the buffer
			if (volctrl_ready_l = '1') then
				VOLCTRL_L <= AMP_OUT_L;
			end if;
			if (volctrl_ready_r = '1') then
				VOLCTRL_R <= AMP_OUT_R;
			end if;
		end if;
	end process;

	OUT_RDY_L <= volctrl_ready_l;
	OUT_RDY_R <= volctrl_ready_r;

	OUT_VOLCTRL_L <= VOLCTRL_L;
	OUT_VOLCTRL_R <= VOLCTRL_R;

end Behavioral;