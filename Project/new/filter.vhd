----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/05/23 14:13:28
-- Design Name: 
-- Module Name: filter - Behavioral
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
use IEEE.STD_LOGIC_SIGNED.ALL;
use WORK.godi_util.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter is
	Port (
		m_clk	: in std_logic;
		m_en	: in std_logic;
		m_pulse	: in std_logic;
		m_din	: in std_logic_vector(15 downto 0);
		m_dout	: out std_logic_vector(7 downto 0);
		m_filter_coe : in std_8bit_array(15 downto 0)
		);
end filter;

architecture Behavioral of filter is
signal s_zero	: std_16bit_array(30 downto 0) := (others => x"0000");
signal s_stage0 : std_16bit_array(30 downto 0) := (others => x"0000");
													 -- Original signal
signal s_stage1 : std_24bit_array(30 downto 0); -- Filter coe * orignal
signal s_stage2 : std_25bit_array(14 downto 0);
signal s_stage3 : std_26bit_array(7 downto 0);
signal s_stage4 : std_27bit_array(3 downto 0);
signal s_stage5 : std_28bit_array(1 downto 0);
signal s_stage6 : std_logic_vector(28 downto 0);
signal s_output : std_logic_vector(15 downto 0);

component multiplier is
	PORT (
    CLK : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    CE : IN STD_LOGIC;
    P : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
end component;

begin

s_stage1(0) <= s_stage0(0) * m_filter_coe(0);
-- mult0 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(0),
	-- B	=> m_filter_coe(0),
	-- CE	=> m_en,
	-- P	=> s_stage1(0)
	-- );
	s_stage1(1) <= s_stage0(1) * m_filter_coe(1);
-- mult1 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(1),
	-- B	=> m_filter_coe(1),
	-- CE	=> m_en,
	-- P	=> s_stage1(1)
	-- );
	s_stage1(2) <= s_stage0(2) * m_filter_coe(2);
-- mult2 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(2),
	-- B	=> m_filter_coe(2),
	-- CE	=> m_en,
	-- P	=> s_stage1(2)
	-- );
	s_stage1(3) <= s_stage0(3) * m_filter_coe(3);
-- mult3 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(3),
	-- B	=> m_filter_coe(3),
	-- CE	=> m_en,
	-- P	=> s_stage1(3)
	-- );
	s_stage1(4) <= s_stage0(4) * m_filter_coe(4);
-- mult4 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(4),
	-- B	=> m_filter_coe(4),
	-- CE	=> m_en,
	-- P	=> s_stage1(4)
	-- );
	s_stage1(5) <= s_stage0(5) * m_filter_coe(5);
-- mult5 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(5),
	-- B	=> m_filter_coe(5),
	-- CE	=> m_en,
	-- P	=> s_stage1(5)
	-- );
	s_stage1(6) <= s_stage0(6) * m_filter_coe(6);
-- mult6 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(6),
	-- B	=> m_filter_coe(6),
	-- CE	=> m_en,
	-- P	=> s_stage1(6)
	-- );
	s_stage1(7) <= s_stage0(7) * m_filter_coe(7);
-- mult7 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(7),
	-- B	=> m_filter_coe(7),
	-- CE	=> m_en,
	-- P	=> s_stage1(7)
	-- );
	s_stage1(8) <= s_stage0(8) * m_filter_coe(8);
-- mult8 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(8),
	-- B	=> m_filter_coe(8),
	-- CE	=> m_en,
	-- P	=> s_stage1(8)
	-- );
	s_stage1(9) <= s_stage0(9) * m_filter_coe(9);
-- mult9 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(9),
	-- B	=> m_filter_coe(9),
	-- CE	=> m_en,
	-- P	=> s_stage1(9)
	-- );
	s_stage1(10) <= s_stage0(10) * m_filter_coe(10);
-- mult10 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(10),
	-- B	=> m_filter_coe(10),
	-- CE	=> m_en,
	-- P	=> s_stage1(10)
	-- );
	s_stage1(11) <= s_stage0(11) * m_filter_coe(11);
-- mult11 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(11),
	-- B	=> m_filter_coe(11),
	-- CE	=> m_en,
	-- P	=> s_stage1(11)
	-- );
	s_stage1(12) <= s_stage0(12) * m_filter_coe(12);
-- mult12 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(12),
	-- B	=> m_filter_coe(12),
	-- CE	=> m_en,
	-- P	=> s_stage1(12)
	-- );
	s_stage1(13) <= s_stage0(13) * m_filter_coe(13);
-- mult13 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(13),
	-- B	=> m_filter_coe(13),
	-- CE	=> m_en,
	-- P	=> s_stage1(13)
	-- );
	s_stage1(14) <= s_stage0(14) * m_filter_coe(14);
-- mult14 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(14),
	-- B	=> m_filter_coe(14),
	-- CE	=> m_en,
	-- P	=> s_stage1(14)
	-- );
	s_stage1(15) <= s_stage0(15) * m_filter_coe(15);
-- mult15 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(15),
	-- B	=> m_filter_coe(15),
	-- CE	=> m_en,
	-- P	=> s_stage1(15)
	-- );
	s_stage1(16) <= s_stage0(15) * m_filter_coe(14);
-- mult16 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(16),
	-- B	=> m_filter_coe(14),
	-- CE	=> m_en,
	-- P	=> s_stage1(16)
	-- );
	s_stage1(17) <= s_stage0(17) * m_filter_coe(13);
-- mult17 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(17),
	-- B	=> m_filter_coe(13),
	-- CE	=> m_en,
	-- P	=> s_stage1(17)
	-- );
	s_stage1(18) <= s_stage0(18) * m_filter_coe(12);
-- mult18 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(18),
	-- B	=> m_filter_coe(12),
	-- CE	=> m_en,
	-- P	=> s_stage1(18)
	-- );
	s_stage1(19) <= s_stage0(19) * m_filter_coe(11);
-- mult19 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(19),
	-- B	=> m_filter_coe(11),
	-- CE	=> m_en,
	-- P	=> s_stage1(19)
	-- );
	s_stage1(20) <= s_stage0(20) * m_filter_coe(10);
-- mult20 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(20),
	-- B	=> m_filter_coe(10),
	-- CE	=> m_en,
	-- P	=> s_stage1(20)
	-- );
	s_stage1(21) <= s_stage0(21) * m_filter_coe(9);
-- mult21 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(21),
	-- B	=> m_filter_coe(9),
	-- CE	=> m_en,
	-- P	=> s_stage1(21)
	-- );
	s_stage1(22) <= s_stage0(22) * m_filter_coe(8);
-- mult22 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(22),
	-- B	=> m_filter_coe(8),
	-- CE	=> m_en,
	-- P	=> s_stage1(22)
	-- );
	s_stage1(23) <= s_stage0(23) * m_filter_coe(7);
-- mult23 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(23),
	-- B	=> m_filter_coe(7),
	-- CE	=> m_en,
	-- P	=> s_stage1(23)
	-- );
	s_stage1(24) <= s_stage0(24) * m_filter_coe(6);
-- mult24 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(24),
	-- B	=> m_filter_coe(6),
	-- CE	=> m_en,
	-- P	=> s_stage1(24)
	-- );
	s_stage1(25) <= s_stage0(25) * m_filter_coe(5);
-- mult25 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(25),
	-- B	=> m_filter_coe(5),
	-- CE	=> m_en,
	-- P	=> s_stage1(25)
	-- );
	s_stage1(26) <= s_stage0(26) * m_filter_coe(4);
-- mult26 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(26),
	-- B	=> m_filter_coe(4),
	-- CE	=> m_en,
	-- P	=> s_stage1(26)
	-- );
	s_stage1(27) <= s_stage0(27) * m_filter_coe(3);
-- mult27 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(27),
	-- B	=> m_filter_coe(3),
	-- CE	=> m_en,
	-- P	=> s_stage1(27)
	-- );
	s_stage1(28) <= s_stage0(28) * m_filter_coe(2);
-- mult28 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(28),
	-- B	=> m_filter_coe(2),
	-- CE	=> m_en,
	-- P	=> s_stage1(28)
	-- );
	s_stage1(29) <= s_stage0(29) * m_filter_coe(1);
-- mult29 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(29),
	-- B	=> m_filter_coe(1),
	-- CE	=> m_en,
	-- P	=> s_stage1(29)
	-- );
	s_stage1(30) <= s_stage0(30) * m_filter_coe(0);
-- mult30 : multiplier port map (
	-- CLK => m_clk,
	-- A	=> s_stage0(30),
	-- B	=> m_filter_coe(0),
	-- CE	=> m_en,
	-- P	=> s_stage1(30)
	-- );

	conv_stage : process (m_clk)
	begin
		if rising_edge(m_clk) then
			if m_pulse = '1' then
			-- Input signal latching
				s_stage0(0) <= m_din;
				s_stage0(1) <= s_stage0(0);
				s_stage0(2) <= s_stage0(1);
				s_stage0(3) <= s_stage0(2);
				s_stage0(4) <= s_stage0(3);
				s_stage0(5) <= s_stage0(4);
				s_stage0(6) <= s_stage0(5);
				s_stage0(7) <= s_stage0(6);
				s_stage0(8) <= s_stage0(7);
				s_stage0(9) <= s_stage0(8);
				s_stage0(10) <= s_stage0(9);
				s_stage0(11) <= s_stage0(10);
				s_stage0(12) <= s_stage0(11);
				s_stage0(13) <= s_stage0(12);
				s_stage0(14) <= s_stage0(13);
				s_stage0(15) <= s_stage0(14);
				s_stage0(16) <= s_stage0(15);
				s_stage0(17) <= s_stage0(16);
				s_stage0(18) <= s_stage0(17);
				s_stage0(19) <= s_stage0(18);
				s_stage0(20) <= s_stage0(19);
				s_stage0(21) <= s_stage0(20);
				s_stage0(22) <= s_stage0(21);
				s_stage0(23) <= s_stage0(22);
				s_stage0(24) <= s_stage0(23);
				s_stage0(25) <= s_stage0(24);
				s_stage0(26) <= s_stage0(25);
				s_stage0(27) <= s_stage0(26);
				s_stage0(28) <= s_stage0(27);
				s_stage0(29) <= s_stage0(28);
				s_stage0(30) <= s_stage0(29);
			else
				s_stage0 <= s_stage0;
			end if;
		end if;
	end process;
	
--	latching_stage : process(m_clk)
--	begin
--		if rising_edge(m_clk) then
--			if m_pulse = '1' then
--				s_stage2_2 <= s_stage2_1;
--			else
--				s_stage2_2 <= s_stage2_2;
--			end if;
--		end if;
--	end process;
	
	
	s_stage2(0) <= (s_stage1(0)(23)&s_stage1(0)) + (s_stage1(1)(23)&s_stage1(1));
	s_stage2(1) <= (s_stage1(2)(23)&s_stage1(2)) + (s_stage1(3)(23)&s_stage1(3));
	s_stage2(2) <= (s_stage1(4)(23)&s_stage1(4)) + (s_stage1(5)(23)&s_stage1(5));
	s_stage2(3) <= (s_stage1(6)(23)&s_stage1(6)) + (s_stage1(7)(23)&s_stage1(7));
	s_stage2(4) <= (s_stage1(8)(23)&s_stage1(8)) + (s_stage1(9)(23)&s_stage1(9));
	s_stage2(5) <= (s_stage1(10)(23)&s_stage1(10)) + (s_stage1(11)(23)&s_stage1(11));
	s_stage2(6) <= (s_stage1(12)(23)&s_stage1(12)) + (s_stage1(13)(23)&s_stage1(13));
	s_stage2(7) <= (s_stage1(14)(23)&s_stage1(14)) + (s_stage1(15)(23)&s_stage1(15));
	s_stage2(8) <= (s_stage1(16)(23)&s_stage1(16)) + (s_stage1(17)(23)&s_stage1(17));
	s_stage2(9) <= (s_stage1(18)(23)&s_stage1(18)) + (s_stage1(19)(23)&s_stage1(19));
	s_stage2(10) <= (s_stage1(20)(23)&s_stage1(20)) + (s_stage1(21)(23)&s_stage1(21));
	s_stage2(11) <= (s_stage1(22)(23)&s_stage1(22)) + (s_stage1(23)(23)&s_stage1(23));
	s_stage2(12) <= (s_stage1(24)(23)&s_stage1(24)) + (s_stage1(25)(23)&s_stage1(25));
	s_stage2(13) <= (s_stage1(26)(23)&s_stage1(26)) + (s_stage1(27)(23)&s_stage1(27));
	s_stage2(14) <= (s_stage1(28)(23)&s_stage1(28)) + (s_stage1(29)(23)&s_stage1(29));

	s_stage3(0) <= (s_stage2(0)(24)&s_stage2(0)) + (s_stage2(1)(24)&s_stage2(1));
	s_stage3(1) <= (s_stage2(2)(24)&s_stage2(2)) + (s_stage2(3)(24)&s_stage2(3));
	s_stage3(2) <= (s_stage2(4)(24)&s_stage2(4)) + (s_stage2(5)(24)&s_stage2(5));
	s_stage3(3) <= (s_stage2(6)(24)&s_stage2(6)) + (s_stage2(7)(24)&s_stage2(7));
	s_stage3(4) <= (s_stage2(8)(24)&s_stage2(8)) + (s_stage2(9)(24)&s_stage2(9));
	s_stage3(5) <= (s_stage2(10)(24)&s_stage2(10)) + (s_stage2(11)(24)&s_stage2(11));
	s_stage3(6) <= (s_stage2(12)(24)&s_stage2(12)) + (s_stage2(13)(24)&s_stage2(13));
	s_stage3(7) <= (s_stage2(14)(24)&s_stage2(14)) + (s_stage1(30)(23)&s_stage1(30)(23)&s_stage1(30));
	
	s_stage4(0) <= (s_stage3(0)(25)&s_stage3(0)) + (s_stage3(1)(25)&s_stage3(1));
	s_stage4(1) <= (s_stage3(2)(25)&s_stage3(2)) + (s_stage3(3)(25)&s_stage3(3));
	s_stage4(2) <= (s_stage3(4)(25)&s_stage3(4)) + (s_stage3(5)(25)&s_stage3(5));
	s_stage4(3) <= (s_stage3(6)(25)&s_stage3(6)) + (s_stage3(7)(25)&s_stage3(7));
	
	s_stage5(0) <= (s_stage4(0)(26)&s_stage4(0)) + (s_stage4(1)(26)&s_stage4(1));
	s_stage5(1) <= (s_stage4(2)(26)&s_stage4(2)) + (s_stage4(3)(26)&s_stage4(3));
	
	s_stage6 <= (s_stage5(0)(27)&s_stage5(0)) + (s_stage5(1)(27)&s_stage5(1));
	
	s_output <= s_stage6(28) & s_stage6(22 downto 8);
	
	m_dout	<= s_output(15 downto 8);

end Behavioral;
