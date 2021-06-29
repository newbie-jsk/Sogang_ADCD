library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OUT_latch is
	Port (
		m_clk	: in std_logic;
		m_din	: in std_logic_vector(7 downto 0);
		m_dout	: out std_logic_vector(7 downto 0);
		
		m_tri_en : in std_logic
		);
end OUT_latch;

architecture Behavioral of OUT_latch is

signal s_dout : std_logic_vector (7 downto 0);

begin

latch_process : process(m_clk)
	begin
		if rising_edge(m_clk) then
			s_dout <= m_din;
		else
			s_dout <= s_dout;
		end if;
	end process;
	
m_dout <= 	s_dout when m_tri_en = '1' else
			"ZZZZZZZZ";

end Behavioral;
