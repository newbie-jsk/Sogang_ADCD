----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/19 12:50:44
-- Design Name: 
-- Module Name: cnt_11bit - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AD_RD_cnt_11bit is
    Port (
		m_clk : in std_logic;
		m_count_up : in std_logic;
		m_reset : in std_logic;
		m_cnt_in : in std_logic_vector(10 downto 0);
		
		m_cnt_out : out std_logic_vector(10 downto 0)
		);
end AD_RD_cnt_11bit;

architecture Behavioral of AD_RD_cnt_11bit is

signal s_cnt_out : std_logic_vector(10 downto 0) := "00000000000";

begin
process (m_clk, m_reset)
begin
	if m_reset = '1' then
		s_cnt_out <= "00000000000";
	elsif rising_edge(m_clk) then
		if m_count_up = '1' then
			if m_cnt_in = "00000000000" then
				s_cnt_out <= "00000000000";
			elsif m_cnt_in = s_cnt_out then
				s_cnt_out <= "00000000000";
			else
				s_cnt_out <= s_cnt_out + 1;
			end if;
		else
			s_cnt_out <= s_cnt_out;
		end if;
	end if;
end process;

m_cnt_out <= s_cnt_out;

end Behavioral;


