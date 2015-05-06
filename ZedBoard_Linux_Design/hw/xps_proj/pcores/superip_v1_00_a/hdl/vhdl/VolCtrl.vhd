library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VolCtrl is
	port(
		OUT_MULT_L : out std_logic_vector(23 downto 0);
		OUT_MULT_R : out std_logic_vector(23 downto 0);
		OUT_RDY_L  : out STD_LOGIC;
		OUT_RDY_R  : out STD_LOGIC;
		IN_SIG_L   : in  std_logic_vector(23 downto 0);
		IN_SIG_R   : in  std_logic_vector(23 downto 0);
		IN_COEF_L  : in  std_logic_vector(23 downto 0);
		IN_COEF_R  : in  std_logic_vector(23 downto 0);
		RESET      : in  STD_LOGIC;
		CLK        : in  STD_LOGIC
	);

end VolCtrl;

architecture Behavioral of VolCtrl is
begin
	OUT_MULT_L <= IN_SIG_L;
	OUT_MULT_R <= IN_SIG_R;
end Behavioral;

