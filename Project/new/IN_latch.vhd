library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IN_latch is
	Port (
		m_clk	: in std_logic;
		m_en	: in std_logic;
		m_din	: in std_logic_vector(7 downto 0);
		m_dout	: out std_logic_vector(7 downto 0)
		);
end IN_latch;

architecture Behavioral of IN_latch is

signal dout : std_logic_vector (7 downto 0);

begin

latch_process : process(m_clk)
	begin
		if rising_edge(m_clk) then
			dout <= m_din;
		else
			dout <= dout;
		end if;
	end process;
	
	m_dout <= dout when m_en = '1' else x"00";
	
end Behavioral;
