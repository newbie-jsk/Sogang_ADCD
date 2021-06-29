library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_counter is
    Port (
		m_clk : in std_logic;
		m_enable : in std_logic;
		m_reset : in std_logic;
		m_skip	: in std_logic_vector(4 downto 0);
		
		m_cnt_out : out std_logic_vector(4 downto 0)
		);
end ROM_counter;

architecture Behavioral of ROM_counter is

signal s_cnt_out : std_logic_vector(4 downto 0) := "00000";
signal s_forward_look : std_logic_vector(4 downto 0) := "00000";
signal s_relocate	: std_logic;

begin
process (m_clk, m_reset)
begin
	if rising_edge(m_clk) then
		if m_reset = '1' then
			s_cnt_out <= "00000";
		elsif m_enable = '1' then
			if s_relocate = '1' then
				s_cnt_out <= s_forward_look - "10100";
			else
				s_cnt_out <= s_cnt_out + m_skip;
			end if;
		else
			s_cnt_out <= s_cnt_out;
		end if;
	end if;
end process;

s_forward_look <= s_cnt_out + m_skip;

m_cnt_out <= s_cnt_out;

s_relocate <= '1' when s_forward_look > "10011" else
			  '0';

end Behavioral;
