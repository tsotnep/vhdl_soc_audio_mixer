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
-- Date:              Tue May  5 20:44:19 2015 (by Create and Import Peripheral Wizard)
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
use ieee.numeric_std.all;

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
	generic(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		--USER generics added here
		-- ADD USER GENERICS ABOVE THIS LINE ---------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete
		C_NUM_REG    : integer := 32;
		C_SLV_DWIDTH : integer := 32
	-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);
	port(
		-- ADD USER PORTS BELOW THIS LINE ------------------
		CLK_48_in                   : in  std_logic;
		CLK_100M_in                 : in  std_logic;
		Audio_Left_in               : in  std_logic_vector(23 downto 0);
		Audio_Right_in              : in  std_logic_vector(23 downto 0);
		SAMPLE_TRIG                 : in  std_logic;
		Mux3_BalanceORMux2_Left_out  : out std_logic_vector(23 downto 0);
		Mux3_BalanceORMux2_Right_out : out std_logic_vector(23 downto 0);
		-- ADD USER PORTS ABOVE THIS LINE ------------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add to or delete
		Bus2IP_Clk                  : in  std_logic;
		Bus2IP_Resetn               : in  std_logic;
		Bus2IP_Data                 : in  std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		Bus2IP_BE                   : in  std_logic_vector(C_SLV_DWIDTH / 8 - 1 downto 0);
		Bus2IP_RdCE                 : in  std_logic_vector(C_NUM_REG - 1 downto 0);
		Bus2IP_WrCE                 : in  std_logic_vector(C_NUM_REG - 1 downto 0);
		IP2Bus_Data                 : out std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
		IP2Bus_RdAck                : out std_logic;
		IP2Bus_WrAck                : out std_logic;
		IP2Bus_Error                : out std_logic
	-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);

	attribute MAX_FANOUT : string;
	attribute SIGIS : string;

	attribute SIGIS of Bus2IP_Clk : signal is "CLK";
	attribute SIGIS of Bus2IP_Resetn : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

	--USER signal declarations added here, as needed for user logic

	------------------------------------------
	-- Signals for user logic slave model s/w accessible register example
	------------------------------------------
	signal slv_reg0          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg1          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg2          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg3          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg4          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg5          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg6          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg7          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg8          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg9          : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg10         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg11         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg12         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg13         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg14         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg15         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg16         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg17         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg18         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg19         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg20         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg21         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg22         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg23         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg24         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg25         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg26         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg27         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg28         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg29         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg30         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg31         : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg_write_sel : std_logic_vector(31 downto 0);
	signal slv_reg_read_sel  : std_logic_vector(31 downto 0);
	signal slv_ip2bus_data   : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_read_ack      : std_logic;
	signal slv_write_ack     : std_logic;

	signal slv_reg26_internal : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg28_internal : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	signal slv_reg29_internal : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	--signal slv_reg30_internal : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);
	--signal slv_reg31_internal : std_logic_vector(C_SLV_DWIDTH - 1 downto 0);

	component superip_internal is
		port(
			-- Outputs
			Mux3_BalanceORMux2_Left_out  : out std_logic_vector(23 downto 0);
			Mux3_BalanceORMux2_Right_out : out std_logic_vector(23 downto 0);
			slv_reg26                   : out STD_LOGIC_VECTOR(31 downto 0);
			slv_reg28                   : out STD_LOGIC_VECTOR(31 downto 0);
			slv_reg29                   : out STD_LOGIC_VECTOR(31 downto 0);
			slv_reg30                   : out STD_LOGIC_VECTOR(31 downto 0);
			slv_reg31                   : out STD_LOGIC_VECTOR(31 downto 0);

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
			slv_reg27                   : in  STD_LOGIC_VECTOR(31 downto 0)
		);
	end component;

begin

	--USER logic implementation added here

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
	slv_reg_write_sel <= Bus2IP_WrCE(31 downto 0);
	slv_reg_read_sel  <= Bus2IP_RdCE(31 downto 0);
	slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or Bus2IP_WrCE(12) or Bus2IP_WrCE(13)
		or Bus2IP_WrCE(14) or Bus2IP_WrCE(15) or Bus2IP_WrCE(16) or Bus2IP_WrCE(17) or Bus2IP_WrCE(18) or Bus2IP_WrCE(19) or Bus2IP_WrCE(20) or Bus2IP_WrCE(21) or Bus2IP_WrCE(22) or Bus2IP_WrCE(23) or Bus2IP_WrCE(24) or Bus2IP_WrCE(25) or Bus2IP_WrCE(26) or Bus2IP_WrCE(27) or
		Bus2IP_WrCE(28) or Bus2IP_WrCE(29) or Bus2IP_WrCE(30) or Bus2IP_WrCE(31);
	slv_read_ack <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or Bus2IP_RdCE(12) or Bus2IP_RdCE(13)
		or Bus2IP_RdCE(14) or Bus2IP_RdCE(15) or Bus2IP_RdCE(16) or Bus2IP_RdCE(17) or Bus2IP_RdCE(18) or Bus2IP_RdCE(19) or Bus2IP_RdCE(20) or Bus2IP_RdCE(21) or Bus2IP_RdCE(22) or Bus2IP_RdCE(23) or Bus2IP_RdCE(24) or Bus2IP_RdCE(25) or Bus2IP_RdCE(26) or Bus2IP_RdCE(27) or
		Bus2IP_RdCE(28) or Bus2IP_RdCE(29) or Bus2IP_RdCE(30) or Bus2IP_RdCE(31);

	-- implement slave model software accessible register(s)
	SLAVE_REG_WRITE_PROC : process(Bus2IP_Clk) is
	begin
		if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
			if Bus2IP_Resetn = '0' then
				slv_reg0  <= (others => '0');
				slv_reg1  <= (others => '0');
				slv_reg2  <= (others => '0');
				slv_reg3  <= (others => '0');
				slv_reg4  <= (others => '0');
				slv_reg5  <= (others => '0');
				slv_reg6  <= (others => '0');
				slv_reg7  <= (others => '0');
				slv_reg8  <= (others => '0');
				slv_reg9  <= (others => '0');
				slv_reg10 <= (others => '0');
				slv_reg11 <= (others => '0');
				slv_reg12 <= (others => '0');
				slv_reg13 <= (others => '0');
				slv_reg14 <= (others => '0');
				slv_reg15 <= (others => '0');
				slv_reg16 <= (others => '0');
				slv_reg17 <= (others => '0');
				slv_reg18 <= (others => '0');
				slv_reg19 <= (others => '0');
				slv_reg20 <= (others => '0');
				slv_reg21 <= (others => '0');
				slv_reg22 <= (others => '0');
				slv_reg23 <= (others => '0');
				slv_reg24 <= (others => '0');
				slv_reg25 <= (others => '0');
				slv_reg26 <= (others => '0');
				slv_reg27 <= (others => '0');
				slv_reg28 <= (others => '0');
				slv_reg29 <= (others => '0');
				slv_reg30 <= (others => '0');
				slv_reg31 <= (others => '0');
			else
				case slv_reg_write_sel is
					when "10000000000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg0(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "01000000000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg1(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00100000000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg2(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00010000000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg3(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00001000000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg4(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000100000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg5(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000010000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg6(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000001000000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg7(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000100000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg8(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000010000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg9(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000001000000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg10(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000100000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg11(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000010000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg12(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000001000000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg13(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000100000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg14(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000010000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg15(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000001000000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg16(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000100000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg17(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000010000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg18(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000001000000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg19(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000000100000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg20(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000000010000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg21(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000000001000000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg22(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000000000100000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg23(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000000000010000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg24(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					when "00000000000000000000000001000000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg25(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;
					--					when "00000000000000000000000000100000" =>
					--						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
					--							if (Bus2IP_BE(byte_index) = '1') then
					--								slv_reg26(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
					--							end if;
					--						end loop;
					when "00000000000000000000000000010000" =>
						for byte_index in 0 to (C_SLV_DWIDTH / 8) - 1 loop
							if (Bus2IP_BE(byte_index) = '1') then
								slv_reg27(byte_index * 8 + 7 downto byte_index * 8) <= Bus2IP_Data(byte_index * 8 + 7 downto byte_index * 8);
							end if;
						end loop;

					--          when "00000000000000000000000000001000" =>
					--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
					--              if ( Bus2IP_BE(byte_index) = '1' ) then
					--                slv_reg28(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
					--              end if;
					--            end loop;
					--          when "00000000000000000000000000000100" =>
					--            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
					--              if ( Bus2IP_BE(byte_index) = '1' ) then
					--                slv_reg29(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
					--              end if;
					--            end loop;
					          when "00000000000000000000000000000010" =>
					            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
					              if ( Bus2IP_BE(byte_index) = '1' ) then
					                slv_reg30(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
					              end if;
					            end loop;
					          when "00000000000000000000000000000001" =>
					            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
					              if ( Bus2IP_BE(byte_index) = '1' ) then
					                slv_reg31(byte_index*8+7 downto byte_index*8) <= Bus2IP_Data(byte_index*8+7 downto byte_index*8);
					              end if;
					            end loop;


					when others => null;
				end case;
				slv_reg26 <= slv_reg26_internal;
				slv_reg28 <= slv_reg28_internal;
				slv_reg29 <= slv_reg29_internal;
				--slv_reg30 <= slv_reg30_internal;
				--slv_reg31 <= slv_reg31_internal;

			end if;
		end if;

	end process SLAVE_REG_WRITE_PROC;

	-- implement slave model software accessible register(s) read mux
	SLAVE_REG_READ_PROC : process(slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31)
	is
	begin
		case slv_reg_read_sel is
			when "10000000000000000000000000000000" => slv_ip2bus_data <= slv_reg0;
			when "01000000000000000000000000000000" => slv_ip2bus_data <= slv_reg1;
			when "00100000000000000000000000000000" => slv_ip2bus_data <= slv_reg2;
			when "00010000000000000000000000000000" => slv_ip2bus_data <= slv_reg3;
			when "00001000000000000000000000000000" => slv_ip2bus_data <= slv_reg4;
			when "00000100000000000000000000000000" => slv_ip2bus_data <= slv_reg5;
			when "00000010000000000000000000000000" => slv_ip2bus_data <= slv_reg6;
			when "00000001000000000000000000000000" => slv_ip2bus_data <= slv_reg7;
			when "00000000100000000000000000000000" => slv_ip2bus_data <= slv_reg8;
			when "00000000010000000000000000000000" => slv_ip2bus_data <= slv_reg9;
			when "00000000001000000000000000000000" => slv_ip2bus_data <= slv_reg10;
			when "00000000000100000000000000000000" => slv_ip2bus_data <= slv_reg11;
			when "00000000000010000000000000000000" => slv_ip2bus_data <= slv_reg12;
			when "00000000000001000000000000000000" => slv_ip2bus_data <= slv_reg13;
			when "00000000000000100000000000000000" => slv_ip2bus_data <= slv_reg14;
			when "00000000000000010000000000000000" => slv_ip2bus_data <= slv_reg15;
			when "00000000000000001000000000000000" => slv_ip2bus_data <= slv_reg16;
			when "00000000000000000100000000000000" => slv_ip2bus_data <= slv_reg17;
			when "00000000000000000010000000000000" => slv_ip2bus_data <= slv_reg18;
			when "00000000000000000001000000000000" => slv_ip2bus_data <= slv_reg19;
			when "00000000000000000000100000000000" => slv_ip2bus_data <= slv_reg20;
			when "00000000000000000000010000000000" => slv_ip2bus_data <= slv_reg21;
			when "00000000000000000000001000000000" => slv_ip2bus_data <= slv_reg22;
			when "00000000000000000000000100000000" => slv_ip2bus_data <= slv_reg23;
			when "00000000000000000000000010000000" => slv_ip2bus_data <= slv_reg24;
			when "00000000000000000000000001000000" => slv_ip2bus_data <= slv_reg25;
			when "00000000000000000000000000100000" => slv_ip2bus_data <= slv_reg26;
			when "00000000000000000000000000010000" => slv_ip2bus_data <= slv_reg27;
			when "00000000000000000000000000001000" => slv_ip2bus_data <= slv_reg28;
			when "00000000000000000000000000000100" => slv_ip2bus_data <= slv_reg29;
			when "00000000000000000000000000000010" => slv_ip2bus_data <= slv_reg30;
			when "00000000000000000000000000000001" => slv_ip2bus_data <= slv_reg31;
			when others                             => slv_ip2bus_data <= (others => '0');
		end case;

	end process SLAVE_REG_READ_PROC;

	SIP : superip_internal port map(
			Mux3_BalanceORMux2_Left_out  => Mux3_BalanceORMux2_Left_out,
			Mux3_BalanceORMux2_Right_out => Mux3_BalanceORMux2_Right_out,
			slv_reg26                   => slv_reg26_internal,
			slv_reg28                   => slv_reg28_internal,
			slv_reg29                   => slv_reg29_internal,
			slv_reg30                   => slv_reg30,
			slv_reg31                   => slv_reg31,
			CLK_48_in                   => CLK_48_in,
			CLK_100M_in                 => CLK_100M_in,
			Audio_Left_in               => Audio_Left_in,
			Audio_Right_in              => Audio_Right_in,
			SAMPLE_TRIG                 => SAMPLE_TRIG,
			slv_reg0                    => slv_reg0,
			slv_reg1                    => slv_reg1,
			slv_reg2                    => slv_reg2,
			slv_reg3                    => slv_reg3,
			slv_reg4                    => slv_reg4,
			slv_reg5                    => slv_reg5,
			slv_reg6                    => slv_reg6,
			slv_reg7                    => slv_reg7,
			slv_reg8                    => slv_reg8,
			slv_reg9                    => slv_reg9,
			slv_reg10                   => slv_reg10,
			slv_reg11                   => slv_reg11,
			slv_reg12                   => slv_reg12,
			slv_reg13                   => slv_reg13,
			slv_reg14                   => slv_reg14,
			slv_reg15                   => slv_reg15,
			slv_reg16                   => slv_reg16,
			slv_reg17                   => slv_reg17,
			slv_reg18                   => slv_reg18,
			slv_reg19                   => slv_reg19,
			slv_reg20                   => slv_reg20,
			slv_reg21                   => slv_reg21,
			slv_reg22                   => slv_reg22,
			slv_reg23                   => slv_reg23,
			slv_reg24                   => slv_reg24,
			slv_reg25                   => slv_reg25,
			slv_reg27                   => slv_reg27
		);

	------------------------------------------
	-- Example code to drive IP to Bus signals
	------------------------------------------
	IP2Bus_Data <= slv_ip2bus_data when slv_read_ack = '1' else (others => '0');

	IP2Bus_WrAck <= slv_write_ack;
	IP2Bus_RdAck <= slv_read_ack;
	IP2Bus_Error <= '0';

end IMP;
