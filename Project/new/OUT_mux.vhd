library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OUT_mux is
	Port (
		m_sel : in std_logic_vector (1 downto 0);
		m_din0 : in std_logic_vector (7 downto 0);
		m_din1 : in std_logic_vector (7 downto 0);
		m_din2 : in std_logic_vector (7 downto 0);
		m_dout : out std_logic_vector (7 downto 0)
		);
end OUT_mux;

architecture Behavioral of OUT_mux is

begin
	m_dout <= 	m_din0 when m_sel = "00" else
				m_din1 when m_sel = "01" else
				m_din2 when m_sel = "10" else
				"00001111";

end Behavioral;
