----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/12 01:47:46
-- Design Name: 
-- Module Name: PC_latch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_latch is
	Port (
		m_clk	: in std_logic;
		m_reset	: in std_logic;
		
		m_cmd_data	:	in std_logic;
		m_wen		:	in std_logic;
		m_ren		:	in std_logic;
		m_oe_b		:	in std_logic;
		m_address	:	in std_logic_vector(8 downto 0);
		
		s_cmd_data	:	out std_logic;
		s_wen		:	out std_logic;
		s_ren		:	out std_logic;
		s_oe_b		:	out std_logic;
		s_address	:	out std_logic_vector(8 downto 0)
		);
end PC_latch;

architecture Behavioral of PC_latch is

signal cmd_data	: std_logic := '0';
signal wen		: std_logic := '0';
signal ren		: std_logic	:= '0';
signal oe_b		: std_logic := '1';
signal address	: std_logic_vector(8 downto 0) := "000000000";

begin

latch_process : process(m_clk, m_reset)
	begin
	if m_reset = '0' then
		cmd_data <= '0';
		wen <= '0';
		ren <= '0';
		oe_b <= '1';
		address <= "100100000"; --H120
	else
		if rising_edge(m_clk) then
			if m_cmd_data = '1' then
				cmd_data	<=	m_cmd_data;
				wen			<=	m_wen;
				ren			<=	m_ren;
				oe_b		<=	m_oe_b;
				address		<=	m_address;
			else
				cmd_data	<=	'0';
				wen			<=	'0';
				ren			<=	'0';
				oe_b		<=	'1';
				address		<=	"000000000";
			end if;
		else
			cmd_data	<=	cmd_data;
			wen			<=	wen;
			ren			<=	ren;
			oe_b		<=	oe_b;
			address		<=	address;
		end if;
	end if;
	end process;

s_cmd_data	<= cmd_data;
s_wen		<= wen;
s_ren		<= ren;
s_oe_b		<= oe_b;
s_address	<= address;

end Behavioral;
