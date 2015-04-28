------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Tue Apr 14 17:57:17 2015 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_NUM_REG                    -- Number of software accessible registers
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Resetn                -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_NUM_REG                      : integer              := 15;
    C_SLV_DWIDTH                   : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here	
		CLK_48							: in std_logic;
		RST								: in std_logic;
		HP_BTN							: in std_logic;
		BP_BTN							: in std_logic;
		LP_BTN							: in std_logic; 
		AUDIO_IN_L 						: in std_logic_vector(23 downto 0);
		AUDIO_IN_R 						: in std_logic_vector(23 downto 0);
		AUDIO_OUT_L						: out std_logic_vector(23 downto 0);
		AUDIO_OUT_R 					: out std_logic_vector(23 downto 0);
		FILTER_DONE						: out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Resetn                  : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    Bus2IP_BE                      : in  std_logic_vector(C_SLV_DWIDTH/8-1 downto 0);
    Bus2IP_RdCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    Bus2IP_WrCE                    : in  std_logic_vector(C_NUM_REG-1 downto 0);
    IP2Bus_Data                    : out std_logic_vector(C_SLV_DWIDTH-1 downto 0);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic
  
 signal reset, IIR_LP_Done_R, IIR_LP_Done_L, IIR_BP_Done_R, IIR_BP_Done_L, IIR_HP_Done_R, IIR_HP_Done_L: std_logic;
 signal AUDIO_OUT_TRUNC_L, AUDIO_OUT_TRUNC_R, IIR_LP_Y_Out_R, IIR_LP_Y_Out_L, IIR_BP_Y_Out_R, IIR_BP_Y_Out_L, IIR_HP_Y_Out_R, IIR_HP_Y_Out_L: std_logic_vector(15 downto 0);
  
  
  component IIR_Biquad_II is
	 Generic(
					Coef_b0	:	std_logic_vector(31 downto 0) := B"00_00_0000_0001_0000_1100_0011_1001_1100";				-- b0		~ +0.0010232
					Coef_b1	:	std_logic_vector(31 downto 0) := B"00_00_0000_0010_0001_1000_0111_0011_1001";				-- b1		~ +0.0020464
					Coef_b2	:	std_logic_vector(31 downto 0) := B"00_00_0000_0001_0000_1100_0011_1001_1100";				-- b2		~ +0.0010232
					Coef_a1	:	std_logic_vector(31 downto 0) := B"10_00_0101_1110_1011_0111_1110_0110_1000";				-- a1		~ -1.9075016 	
					Coef_a2	:	std_logic_vector(31 downto 0) := B"00_11_1010_0101_0111_1001_0000_0111_0101"
				);		
		Port ( 
				clk : in  STD_LOGIC;
				rst : in  STD_LOGIC;
				sample_trig : in  STD_LOGIC;
				X_in : in  STD_LOGIC_VECTOR (15 downto 0);
				filter_done : out STD_LOGIC;
				Y_out : out  STD_LOGIC_VECTOR (15 downto 0)
				);
end component;

function Three_ASR ( val: signed (15 downto 0) ) return signed is begin
  return  val(15) & val(15) & val(15) & val(15 downto 3) ;
  end Three_ASR;
  
 function Two_ASR ( val: signed (15 downto 0) ) return signed is begin
  return  val(15) & val(15) & val(15 downto 2) ;
  end Two_ASR; 


  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg1                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg2                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg3                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg4                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg5                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg6                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg7                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg8                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg9                       : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg10                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg11                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg12                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg13                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_reg14                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg15                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg16                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg17                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg18                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg19                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg20                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg21                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg22                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg23                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg24                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg25                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg26                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg27                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg28                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg29                      : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
--  signal slv_reg_write_sel              : std_logic_vector(29 downto 0);
--  signal slv_reg_read_sel               : std_logic_vector(29 downto 0);
  signal slv_reg_write_sel              : std_logic_vector(14 downto 0);
  signal slv_reg_read_sel               : std_logic_vector(14 downto 0);
  signal slv_ip2bus_data                : std_logic_vector(C_SLV_DWIDTH-1 downto 0);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

begin

  --USER logic implementation added here
  
  ---- connect all the "filter done" with an AND gate to the user_logic top level entity.
  FILTER_DONE <= IIR_LP_Done_R and IIR_LP_Done_L and IIR_BP_Done_R and IIR_BP_Done_L and IIR_HP_Done_R and IIR_HP_Done_L;
	
  -----Pad the Audio output with 8 zeros to make it up to 24 bit,
	AUDIO_OUT_L <= AUDIO_OUT_TRUNC_L & X"00";
	AUDIO_OUT_R <=  AUDIO_OUT_TRUNC_R & X"00";
	
	
	
	---this process controls each individual filter and the final output of the filter. 
  process (HP_BTN,BP_BTN, LP_BTN) 
	variable val: std_logic_vector(2 downto 0):= HP_BTN & BP_BTN & LP_BTN;
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
  
  
  IIR_LP_R: IIR_Biquad_II
		Generic Map
		(
			Coef_b0	=> B"00_00_0000_0001_0000_1100_0011_1001_1100",				-- b0		~ +0.0010232
			Coef_b1	=>	B"00_00_0000_0010_0001_1000_0111_0011_1001",				-- b1		~ +0.0020464
			Coef_b2	=>	B"00_00_0000_0001_0000_1100_0011_1001_1100",				-- b2		~ +0.0010232
			Coef_a1	=>	B"10_00_0101_1110_1011_0111_1110_0110_1000",				-- a1		~ -1.9075016 	
			Coef_a2	=>	B"00_11_1010_0101_0111_1001_0000_0111_0101"				-- a2		~ +0.9115945
		)	
		Port map ( 
				clk => CLK_48,
				rst => reset,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_R(23 downto 8),
				filter_done => IIR_LP_Done_R,
				Y_out => IIR_LP_Y_Out_R
		 );
				
	IIR_LP_L: IIR_Biquad_II
		Generic Map
		(
			Coef_b0	=> B"00_00_0000_0001_0000_1100_0011_1001_1100",				-- b0		~ +0.0010232							  
			Coef_b1	=>	B"00_00_0000_0010_0001_1000_0111_0011_1001",				-- b1		~ +0.0020464
			Coef_b2	=>	B"00_00_0000_0001_0000_1100_0011_1001_1100",				-- b2		~ +0.0010232
			Coef_a1	=>	B"10_00_0101_1110_1011_0111_1110_0110_1000",				-- a1		~ -1.9075016	
			Coef_a2	=>	B"00_11_1010_0101_0111_1001_0000_0111_0101"				-- a2		~ +0.9115945
			)			
		Port map ( 
				clk => CLK_48,
				rst => reset,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_L(23 downto 8),--X_in_truncated_L,
				filter_done => IIR_LP_Done_L,
				Y_out => IIR_LP_Y_Out_L
				);
		
	IIR_BP_R: IIR_Biquad_II --(20 - 20000)
		Generic Map
		(
			Coef_b0	=> 	B"00_00_1101_1001_0100_1010_0010_0011_0000",-- b0	~ +0.212196872
			Coef_b1	=>	B"11_10_0101_0001_1010_0101_0110_1110_1000",-- b1		~ -0.420267366
			Coef_b2	=>	B"00_00_1101_1001_0100_1010_0010_0011_0000",-- b2		~ +0.212196872
			Coef_a1	=>	B"11_10_0101_0001_1010_0101_0110_1110_1000",-- a1		~ -0.575606257	
			Coef_a2	=>	B"11_01_1011_0010_1001_0100_0100_0110_0000" -- a2		~ +0.986994963	
		)	
		Port map ( 
			clk => CLK_48,
			rst => reset,
			sample_trig => '1',--Sample_IIR,
			X_in => AUDIO_IN_R(23 downto 8),--X_in_truncated_R,
			filter_done => IIR_BP_Done_R,
			Y_out => IIR_BP_Y_Out_R
		 );
				
	IIR_BP_L: IIR_Biquad_II--(20 - 20000)
		Generic Map
		(
			Coef_b0	=> B"00_00_1101_1001_0100_1010_0010_0011_0000",-- b0		~ +0.212196872
			Coef_b1	=>	B"11_10_0101_0001_1010_0101_0110_1110_1000",-- b1		~ -0.420267366
			Coef_b2	=>	B"00_00_1101_1001_0100_1010_0010_0011_0000",-- b2		~ +0.212196872
			Coef_a1	=>	B"11_10_0101_0001_1010_0101_0110_1110_1000",-- a1		~ -0.575606257	
			Coef_a2	=>	B"11_01_1011_0010_1001_0100_0100_0110_0000" -- a2		~ +0.986994963
			)	
			Port map ( 
				clk => CLK_48,
				rst => reset,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_L(23 downto 8),--X_in_truncated_L,
				filter_done => IIR_BP_Done_L,
				Y_out => IIR_BP_Y_Out_L
				);

IIR_HP_R: IIR_Biquad_II
		Generic Map
		(
			Coef_b0	=> 	B"00_00_0000_0000_1010_1011_0111_0101_1110",-- b0		~ +0.00065407
Coef_b1	=>	B"00_00_0000_0000_0000_0000_0000_0000_0000",-- b1		~ 0.0
Coef_b2	=>	B"11_11_1111_1111_0101_0100_1000_1010_0010",-- b2		~ -0.00065407
Coef_a1	=>	B"10_00_0000_0001_0110_0100_0110_0011_0100",-- a1		~ -1.998640489	
Coef_a2	=>	B"00_11_1111_1110_1010_1001_0001_0100_0010" -- a2		~ +0.998691859	

		)	
		Port map ( 
				clk => CLK_48,
				rst => reset,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_R(23 downto 8),--X_in_truncated_R,
				filter_done => IIR_HP_Done_R,
				Y_out => IIR_HP_Y_Out_R
		 );
				
	IIR_HP_L: IIR_Biquad_II
		Generic Map
		(
			Coef_b0	=> 	B"00_00_0000_0000_1010_1011_0111_0101_1110",-- b0		~ +0.00065407
Coef_b1	=>	B"00_00_0000_0000_0000_0000_0000_0000_0000",-- b1		~ 0.0
Coef_b2	=>	B"11_11_1111_1111_0101_0100_1000_1010_0010",-- b2		~ -0.00065407
Coef_a1	=>	B"10_00_0000_0001_0110_0100_0110_0011_0100",-- a1		~ -1.998640489	
Coef_a2	=>	B"00_11_1111_1110_1010_1001_0001_0100_0010" -- a2		~ +0.998691859	

		)			
		Port map ( 
				clk => CLK_48,
				rst => reset,
				sample_trig => '1',--Sample_IIR,
				X_in => AUDIO_IN_L(23 downto 8),--X_in_truncated_L,
				filter_done => IIR_HP_Done_L,
				Y_out => IIR_HP_Y_Out_L
				);
  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
--  slv_reg_write_sel <= Bus2IP_WrCE(29 downto 0);
--  slv_reg_read_sel  <= Bus2IP_RdCE(29 downto 0);
  slv_reg_write_sel <= Bus2IP_WrCE(14 downto 0);
  slv_reg_read_sel  <= Bus2IP_RdCE(14 downto 0);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or Bus2IP_WrCE(12) or Bus2IP_WrCE(13) or Bus2IP_WrCE(14) or Bus2IP_WrCE(15) or Bus2IP_WrCE(16) or Bus2IP_WrCE(17) or Bus2IP_WrCE(18) or Bus2IP_WrCE(19) or Bus2IP_WrCE(20) or Bus2IP_WrCE(21) or Bus2IP_WrCE(22) or Bus2IP_WrCE(23) or Bus2IP_WrCE(24) or Bus2IP_WrCE(25) or Bus2IP_WrCE(26) or Bus2IP_WrCE(27) or Bus2IP_WrCE(28) or Bus2IP_WrCE(29);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or Bus2IP_RdCE(12) or Bus2IP_RdCE(13) or Bus2IP_RdCE(14) or Bus2IP_RdCE(15) or Bus2IP_RdCE(16) or Bus2IP_RdCE(17) or Bus2IP_RdCE(18) or Bus2IP_RdCE(19) or Bus2IP_RdCE(20) or Bus2IP_RdCE(21) or Bus2IP_RdCE(22) or Bus2IP_RdCE(23) or Bus2IP_RdCE(24) or Bus2IP_RdCE(25) or Bus2IP_RdCE(26) or Bus2IP_RdCE(27) or Bus2IP_RdCE(28) or Bus2IP_RdCE(29);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Resetn = '0' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
        slv_reg6 <= (others => '0');
        slv_reg7 <= (others => '0');
        slv_reg8 <= (others => '0');
        slv_reg9 <= (others => '0');
        slv_reg10 <= (others => '0');
        slv_reg11 <= (others => '0');
        slv_reg12 <= (others => '0');
        slv_reg13 <= (others => '0');
        slv_reg14 <= (others => '0');
--        slv_reg15 <= (others => '0');
--        slv_reg16 <= (others => '0');
--        slv_reg17 <= (others => '0');
--        slv_reg18 <= (others => '0');
--        slv_reg19 <= (others => '0');
--        slv_reg20 <= (others => '0');
--        slv_reg21 <= (others => '0');
--        slv_reg22 <= (others => '0');
--        slv_reg23 <= (others => '0');
--        slv_reg24 <= (others => '0');
--        slv_reg25 <= (others => '0');
--        slv_reg26 <= (others => '0');
--        slv_reg27 <= (others => '0');
--        slv_reg28 <= (others => '0');
--        slv_reg29 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "100000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "010000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "001000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000100000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000010000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000001000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000100000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg6(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000010000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg7(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000001000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg8(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000000100000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg9(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000000010000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg10(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000000001000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg11(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000000000100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg12(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000000000010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg13(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
          when "000000000000001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg14(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
              end if;
            end loop;
--          when "000000000000000100000000000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg15(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000010000000000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg16(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000001000000000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg17(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000100000000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg18(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop; 
--          when "000000000000000000010000000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg19(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000001000000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg20(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000100000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg21(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000010000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg22(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000001000000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg23(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000000100000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg24(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000000010000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg25(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000000001000" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg26(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000000000100" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg27(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000000000010" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg28(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
--          when "000000000000000000000000000001" =>
--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg29(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
--              end if;
--            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14) is --, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29 ) is
  begin

    case slv_reg_read_sel is
      when "100000000000000" => slv_ip2bus_data <= slv_reg0;
      when "010000000000000" => slv_ip2bus_data <= slv_reg1;
      when "001000000000000" => slv_ip2bus_data <= slv_reg2;
      when "000100000000000" => slv_ip2bus_data <= slv_reg3;
      when "000010000000000" => slv_ip2bus_data <= slv_reg4;
      when "000001000000000" => slv_ip2bus_data <= slv_reg5;
      when "000000100000000" => slv_ip2bus_data <= slv_reg6;
      when "000000010000000" => slv_ip2bus_data <= slv_reg7;
      when "000000001000000" => slv_ip2bus_data <= slv_reg8;
      when "000000000100000" => slv_ip2bus_data <= slv_reg9;
      when "000000000010000" => slv_ip2bus_data <= slv_reg10;
      when "000000000001000" => slv_ip2bus_data <= slv_reg11;
      when "000000000000100" => slv_ip2bus_data <= slv_reg12;
      when "000000000000010" => slv_ip2bus_data <= slv_reg13;
      when "000000000000001" => slv_ip2bus_data <= slv_reg14;
--      when "000000000000000100000000000000" => slv_ip2bus_data <= slv_reg15;
--      when "000000000000000010000000000000" => slv_ip2bus_data <= slv_reg16;
--      when "000000000000000001000000000000" => slv_ip2bus_data <= slv_reg17;
--      when "000000000000000000100000000000" => slv_ip2bus_data <= slv_reg18;
--      when "000000000000000000010000000000" => slv_ip2bus_data <= slv_reg19;
--      when "000000000000000000001000000000" => slv_ip2bus_data <= slv_reg20;
--      when "000000000000000000000100000000" => slv_ip2bus_data <= slv_reg21;
--      when "000000000000000000000010000000" => slv_ip2bus_data <= slv_reg22;
--      when "000000000000000000000001000000" => slv_ip2bus_data <= slv_reg23;
--      when "000000000000000000000000100000" => slv_ip2bus_data <= slv_reg24;
--      when "000000000000000000000000010000" => slv_ip2bus_data <= slv_reg25;
--      when "000000000000000000000000001000" => slv_ip2bus_data <= slv_reg26;
--      when "000000000000000000000000000100" => slv_ip2bus_data <= slv_reg27;
--      when "000000000000000000000000000010" => slv_ip2bus_data <= slv_reg28;
--      when "000000000000000000000000000001" => slv_ip2bus_data <= slv_reg29;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

end IMP;
