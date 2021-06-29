----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/23 00:36:30
-- Design Name: 
-- Module Name: Option_controller - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Option_controller is
	Port (
		m_reset 	: in std_logic;
		m_clk		: in std_logic;
		m_en		: in std_logic;
		m_freq_skip	: in std_logic_vector(4 downto 0);
		m_write_end	: in std_logic;
	
		m_LUT_en 	: out std_logic;
		m_mult_ce 	: out std_logic;
		m_sqr_ce 	: out std_logic;
		m_filter_en	: out std_logic;
		m_sqrt_valid	: out std_logic;
		m_yout_valid 	: out std_logic;
		
		m_LUT_address : out std_logic_vector(4 downto 0)
		);
end Option_controller;

architecture Behavioral of Option_controller is

type state_option is (	Idle, 
						ROM_en_st, wait_ROM0, wait_ROM1,
						multi_en_st,
						Filter_en_st,
						sqr_en_st,
						sqrt_en_st,
						wait_sqr0, wait_sqr1, wait_sqr2, wait_sqr3, wait_sqr4,
						transient0, transient1, transient2, transient3, transient4,
						write_mode
						);

signal s_cnt_enable : std_logic;
signal state : state_option := Idle;
signal s_reset : std_logic;
signal s_filter_wait : std_logic_vector(3 downto 0) := "0000";
signal s_freq_skip	: std_logic_vector(4 downto 0) := "00000";
signal s_save_freq	: std_logic;



begin
	



 
 main : process (m_clk)
begin
	if rising_edge(m_clk) then
		if m_reset = '1' then
			state <= Idle;
		else
			case state is
				when Idle =>
					if m_en = '1' then
						state <= ROM_en_st;
					else
						state <= Idle;
					end if;
					
				when ROM_en_st =>
					state <= wait_ROM0;
					
				when wait_ROM0 =>
					state <= wait_ROM1;
				
				when wait_ROM1 =>
					state <= multi_en_st;
				
				when multi_en_st =>
					state <= Filter_en_st;
				
				when Filter_en_st =>		-- 15 clock wait
					s_filter_wait <= s_filter_wait + 1;
					
					if s_filter_wait = "1110" then
						state <= sqr_en_st;
					else
						state <= Filter_en_st;
					end if;

				when sqr_en_st =>
					state <= sqrt_en_st;
					
				when sqrt_en_st =>
					state <= wait_sqr0;
					
				when wait_sqr0 =>
					state <= wait_sqr1;
					
				when wait_sqr1 =>
					state <= wait_sqr2;
					
				when wait_sqr2 =>
					state <= wait_sqr3;
					
				when wait_sqr3 =>
					state <= wait_sqr4;
					
				when wait_sqr4 =>
					state <= transient0;
					
				when transient0 =>
					state <= transient1;
					
				when transient1 =>
					state <= transient2;
				
				when transient2 =>
					state <= transient3;
					
				when transient3 =>
					state <= transient4;
					
				when transient4 =>
					state <= write_mode;
					
				when write_mode =>
					if m_write_end = '1' then
						state <= Idle;
					else
						state <= write_mode;
					end if;
				
			end case;
		end if;
	end if;	
end process;
	s_save_freq	<= '1' when state = ROM_en_st else '0';
	s_cnt_enable <= '0' when state = Idle else '1';
	m_LUT_en 	<= '0' when state = Idle else '1';
	
	m_mult_ce 	<= '0' when state = Idle else
				   '0' when state = ROM_en_st else
				   '0' when state = wait_ROM0 else
				   '0' when state = wait_ROM1 else
				   '1';
				   
	m_filter_en	<= '0' when state = Idle else
				   '0' when state = ROM_en_st else
				   '0' when state = wait_ROM0 else
				   '0' when state = wait_ROM1 else
				   '0' when state = multi_en_st else
				   '1';
				   
	m_sqr_ce 	<= '0' when state = Idle else
				   '0' when state = ROM_en_st else
				   '0' when state = wait_ROM0 else
				   '0' when state = wait_ROM1 else
				   '0' when state = multi_en_st else
				   '0' when state = Filter_en_st else
				   '1';
	
	m_sqrt_valid	<= '0' when state = Idle else
					   '0' when state = ROM_en_st else
					   '0' when state = wait_ROM0 else
					   '0' when state = wait_ROM1 else
					   '0' when state = multi_en_st else
					   '0' when state = Filter_en_st else
					   '0' when state = sqr_en_st else
					   '1';
				   
	m_yout_valid	<= '1' when state = transient4 else
					   '1' when state = write_mode else
					   '0';
					   
	s_reset <= m_reset;
 
end Behavioral;
