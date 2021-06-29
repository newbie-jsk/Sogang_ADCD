library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_mux is
	Port (
		m_sel : in std_logic;
		m_din0 : in std_logic_vector (7 downto 0);
		m_din1 : in std_logic_vector (7 downto 0);
		m_dout : out std_logic_vector (7 downto 0)
		);
end PC_mux;

architecture Behavioral of PC_mux is

begin
	m_dout <= 	m_din0 when m_sel = '0' else
				m_din1 when m_sel = '1' else
				"ZZZZZZZZ";

end Behavioral;
