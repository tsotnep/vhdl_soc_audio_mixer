----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Create Date:    19:23:40 01/06/2014 
-- Module Name:    adau1761 - Behavioral 
-- Description:  Implement a Line in => I2S => FPGA => I2S => Headphones 
--               using the ADAU1761 codec
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library unisim;
use unisim.vcomponents.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

entity adau1761 is
    Port ( clk_100  : in    STD_LOGIC;
			  clk_48_o :out 	 STD_LOGIC;
           AC_ADR0  : out   STD_LOGIC;
           AC_ADR1  : out   STD_LOGIC;
           AC_GPIO0 : out   STD_LOGIC;  -- I2S MISO
           AC_GPIO1 : in    STD_LOGIC;  -- I2S MOSI
           AC_GPIO2 : in    STD_LOGIC;  -- I2S_bclk
           AC_GPIO3 : in    STD_LOGIC;  -- I2S_LR
           AC_MCLK  : out   STD_LOGIC;
           AC_SCK   : out   STD_LOGIC;
			  
			  AUDIO_OUT_L : out STD_LOGIC_VECTOR(23 downto 0);
			  AUDIO_OUT_R : out STD_LOGIC_VECTOR(23 downto 0);
			  
			  AUDIO_IN_L : in STD_LOGIC_VECTOR(23 downto 0);
			  AUDIO_IN_R : in STD_LOGIC_VECTOR(23 downto 0);
			  
			  AC_SDA_I : IN std_logic;      
			  AC_SDA_O : OUT std_logic;      
			  AC_SDA_T : OUT std_logic;   
           --AC_SDA   : inout STD_LOGIC;
           sw       : in    STD_LOGIC_VECTOR(7 downto 0)
           );
end adau1761;

architecture Behavioral of adau1761 is

	COMPONENT adau1761_izedboard
	PORT(
		clk_48 : IN std_logic;
		AC_GPIO1 : IN std_logic;
		AC_GPIO2 : IN std_logic;
		AC_GPIO3 : IN std_logic;
		hphone_l : IN std_logic_vector(23 downto 0);
		hphone_r : IN std_logic_vector(23 downto 0); 
		
	 AC_SDA_I : IN std_logic;      
	 AC_SDA_O : OUT std_logic;      
	 AC_SDA_T : OUT std_logic; 
	 
		--AC_SDA : INOUT std_logic;      
		AC_ADR0 : OUT std_logic;
		AC_ADR1 : OUT std_logic;
		AC_GPIO0 : OUT std_logic;
		AC_MCLK : OUT std_logic;
		AC_SCK : OUT std_logic;
		line_in_l : OUT std_logic_vector(23 downto 0);
		line_in_r : OUT std_logic_vector(23 downto 0);
      new_sample: out   std_logic;
      sw : in std_logic_vector(1 downto 0);
      active : out std_logic_vector(1 downto 0)
		);
	END COMPONENT;

   component clocking
   port(
      CLK_100           : in     std_logic;
      CLK_48            : out    std_logic;
      RESET             : in     std_logic;
      LOCKED            : out    std_logic
      );
   end component;
   
   signal clk_48     : std_logic;
   signal new_sample : std_logic;

   signal sw_synced : std_logic_vector(7 downto 0);
   signal active : std_logic_vector(1 downto 0);
   constant hi : natural := 23;
begin
process(clk_48)
   begin
      if rising_edge(clk_48) then
         sw_synced <= sw;
      end if;
   end process;
                                 
i_clocking : clocking port map (
      CLK_100 => CLK_100,
      CLK_48  => CLK_48,
      RESET   => '0',
      LOCKED  => open
   );
	
	clk_48_o <= clk_48;

Inst_adau1761_izedboard: adau1761_izedboard PORT MAP(
		clk_48     => clk_48,
		AC_ADR0    => AC_ADR0,
		AC_ADR1    => AC_ADR1,
		AC_GPIO0   => AC_GPIO0,
		AC_GPIO1   => AC_GPIO1,
		AC_GPIO2   => AC_GPIO2,
		AC_GPIO3   => AC_GPIO3,
		AC_MCLK    => AC_MCLK,
		AC_SCK     => AC_SCK,
		
	 AC_SDA_I => AC_SDA_I,      
	 AC_SDA_O => AC_SDA_O,      
	 AC_SDA_T => AC_SDA_T,
	 
		--AC_SDA     => AC_SDA,
		hphone_l   => AUDIO_IN_L,
		hphone_r   => AUDIO_IN_R,
		line_in_l  => AUDIO_OUT_L,
		line_in_r  => AUDIO_OUT_R,
      new_sample => new_sample,
      sw         => sw(1 downto 0),
      active     => active
	);
   
end Behavioral;
