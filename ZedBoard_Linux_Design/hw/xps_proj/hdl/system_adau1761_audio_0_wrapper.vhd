-------------------------------------------------------------------------------
-- system_adau1761_audio_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library adau1761_audio_v1_00_a;
use adau1761_audio_v1_00_a.all;

entity system_adau1761_audio_0_wrapper is
  port (
    clk_100 : in std_logic;
    clk_48_o : out std_logic;
    AC_GPIO1 : in std_logic;
    AC_GPIO2 : in std_logic;
    AC_GPIO3 : in std_logic;
    AC_SDA_I : in std_logic;
    AC_SDA_O : out std_logic;
    AC_SDA_T : out std_logic;
    AC_ADR0 : out std_logic;
    AC_ADR1 : out std_logic;
    AC_GPIO0 : out std_logic;
    AC_MCLK : out std_logic;
    AC_SCK : out std_logic;
    AUDIO_OUT_L : out std_logic_vector(23 downto 0);
    AUDIO_OUT_R : out std_logic_vector(23 downto 0);
    AUDIO_IN_L : in std_logic_vector(23 downto 0);
    AUDIO_IN_R : in std_logic_vector(23 downto 0);
    S_AXI_ACLK : in std_logic;
    S_AXI_ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_RREADY : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_AWREADY : out std_logic
  );
end system_adau1761_audio_0_wrapper;

architecture STRUCTURE of system_adau1761_audio_0_wrapper is

  component adau1761_audio is
    generic (
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_MIN_SIZE : std_logic_vector;
      C_USE_WSTRB : INTEGER;
      C_DPHASE_TIMEOUT : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_FAMILY : STRING;
      C_NUM_REG : INTEGER;
      C_NUM_MEM : INTEGER;
      C_SLV_AWIDTH : INTEGER;
      C_SLV_DWIDTH : INTEGER
    );
    port (
      clk_100 : in std_logic;
      clk_48_o : out std_logic;
      AC_GPIO1 : in std_logic;
      AC_GPIO2 : in std_logic;
      AC_GPIO3 : in std_logic;
      AC_SDA_I : in std_logic;
      AC_SDA_O : out std_logic;
      AC_SDA_T : out std_logic;
      AC_ADR0 : out std_logic;
      AC_ADR1 : out std_logic;
      AC_GPIO0 : out std_logic;
      AC_MCLK : out std_logic;
      AC_SCK : out std_logic;
      AUDIO_OUT_L : out std_logic_vector(23 downto 0);
      AUDIO_OUT_R : out std_logic_vector(23 downto 0);
      AUDIO_IN_L : in std_logic_vector(23 downto 0);
      AUDIO_IN_R : in std_logic_vector(23 downto 0);
      S_AXI_ACLK : in std_logic;
      S_AXI_ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_RREADY : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_AWREADY : out std_logic
    );
  end component;

begin

  adau1761_audio_0 : adau1761_audio
    generic map (
      C_S_AXI_DATA_WIDTH => 32,
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_MIN_SIZE => X"000001ff",
      C_USE_WSTRB => 0,
      C_DPHASE_TIMEOUT => 8,
      C_BASEADDR => X"72800000",
      C_HIGHADDR => X"7280ffff",
      C_FAMILY => "zynq",
      C_NUM_REG => 1,
      C_NUM_MEM => 1,
      C_SLV_AWIDTH => 32,
      C_SLV_DWIDTH => 32
    )
    port map (
      clk_100 => clk_100,
      clk_48_o => clk_48_o,
      AC_GPIO1 => AC_GPIO1,
      AC_GPIO2 => AC_GPIO2,
      AC_GPIO3 => AC_GPIO3,
      AC_SDA_I => AC_SDA_I,
      AC_SDA_O => AC_SDA_O,
      AC_SDA_T => AC_SDA_T,
      AC_ADR0 => AC_ADR0,
      AC_ADR1 => AC_ADR1,
      AC_GPIO0 => AC_GPIO0,
      AC_MCLK => AC_MCLK,
      AC_SCK => AC_SCK,
      AUDIO_OUT_L => AUDIO_OUT_L,
      AUDIO_OUT_R => AUDIO_OUT_R,
      AUDIO_IN_L => AUDIO_IN_L,
      AUDIO_IN_R => AUDIO_IN_R,
      S_AXI_ACLK => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_WDATA => S_AXI_WDATA,
      S_AXI_WSTRB => S_AXI_WSTRB,
      S_AXI_WVALID => S_AXI_WVALID,
      S_AXI_BREADY => S_AXI_BREADY,
      S_AXI_ARADDR => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_RREADY => S_AXI_RREADY,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA => S_AXI_RDATA,
      S_AXI_RRESP => S_AXI_RRESP,
      S_AXI_RVALID => S_AXI_RVALID,
      S_AXI_WREADY => S_AXI_WREADY,
      S_AXI_BRESP => S_AXI_BRESP,
      S_AXI_BVALID => S_AXI_BVALID,
      S_AXI_AWREADY => S_AXI_AWREADY
    );

end architecture STRUCTURE;

