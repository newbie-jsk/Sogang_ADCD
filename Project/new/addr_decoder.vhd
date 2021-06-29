library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity addr_decoder is
    Port (
		m_addr_in 	: in std_logic_vector(8 downto 0);
		m_reset		: in std_logic;
		m_pcs_sel_b : out std_logic;
		m_cont_addr : out std_logic_vector(3 downto 0)
		);
end addr_decoder;

architecture Behavioral of addr_decoder is

begin
	m_pcs_sel_b <=	'0' when m_addr_in(8 downto 2) = "1000100" else	--Sys clock set
					'1';											--8254 inactive
					
	m_cont_addr <=	"0000" when m_reset = '0' else
					"0000" when m_addr_in = '1' & x"20" else	--SW reset
					"0001" when m_addr_in = '1' & x"21" else	--8254 reset
					"0010" when m_addr_in = '1' & x"30" else	--PC mode
					"0011" when m_addr_in = '1' & x"40" else	--DA start mode
					"0100" when m_addr_in = '1' & x"41" else	--DA stop mode
					"0101" when m_addr_in = '1' & x"50" else	--AD mode
					"0110" when m_addr_in = '1' & x"51" else	--ADR mode
					"0111" when m_addr_in = '1' & x"60" else	--Option step1
					"1000" when m_addr_in = '1' & x"61" else	--Option step2
					"1111";										--Idle mode

end Behavioral;
