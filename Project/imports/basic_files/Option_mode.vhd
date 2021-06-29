library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use WORK.godi_util.ALL;

entity Option_mode is
	--자유롭게 in, out을 더 추가하셔도 됩니다.
    Port ( m_reset_b 		: in STD_LOGIC;
           m_clk 			: in STD_LOGIC;
		   m_en				: in STD_LOGIC;
		   m_write_end		: in std_logic;
		   m_freq_skip		: in std_logic_vector (4 downto 0);
           m_xin 			: in std_logic_vector (7 downto 0); --signed
		   
		   m_pulse			: out std_logic;
           m_yout 			: out std_logic_vector (7 downto 0); --signed
		   m_yout_valid		: out std_logic--필요할 경우 사용
		   );
end Option_mode;

architecture Behavioral of Option_mode is

component Cos_LUT is
	PORT (
		clka : IN STD_LOGIC;
		ena : IN STD_LOGIC;
		addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
end component;

component Cos_mult is
	PORT (
		CLK : IN STD_LOGIC;
		A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CE : IN STD_LOGIC;
		P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
end component;

component cos_sqr is
	PORT (
		CLK : IN STD_LOGIC;
		A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CE : IN STD_LOGIC;
		P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
end component;

component neg_Sin_LUT is
	PORT (
		clka : IN STD_LOGIC;
		ena : IN STD_LOGIC;
		addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
end component;

component sin_mult is
	PORT (
		CLK : IN STD_LOGIC;
		A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CE : IN STD_LOGIC;
		P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
end component;

component sin_sqr is
	PORT (
		CLK : IN STD_LOGIC;
		A : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		CE : IN STD_LOGIC;
		P : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
end component;

component filter is
	Port (
		m_clk	: in std_logic;
		m_en	: in std_logic;
		m_pulse	: in std_logic;
		m_din	: in std_logic_vector(15 downto 0);
		m_dout	: out std_logic_vector(7 downto 0);
		m_filter_coe : in std_8bit_array(15 downto 0)
		);
end component;

component sqrt_16to9_lat5 is -- 17to9임
	PORT (
		aclk : IN STD_LOGIC;
		s_axis_cartesian_tvalid : IN STD_LOGIC;
		s_axis_cartesian_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		m_axis_dout_tvalid : OUT STD_LOGIC;
		m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
end component;

component ROM_counter is
    Port (
		m_clk : in std_logic;
		m_enable : in std_logic;
		m_reset : in std_logic;
		m_skip	: in std_logic_vector(4 downto 0);
		
		m_cnt_out : out std_logic_vector(4 downto 0)
		);
end component;

--==============================================================================================================\
--signal 정의
--==============================================================================================================
type option_state is (Idle, freq_save, wait_option);
signal state : option_state := Idle;

signal s_filter_coef : std_8bit_array(15 downto 0):=(others => (others => '0')); -- array 선언 : 8bit가 총 16개

signal s_reset		: std_logic := '0';
signal s_yout_valid	: std_logic := '0';
signal s_pulse		: std_logic := '0';
signal s_save_freq	: std_logic := '0';
signal s_reset_count : std_logic := '0';
signal s_pulse_count : std_logic_vector(3 downto 0) := "0000";
signal s_freq_skip	: std_logic_vector(4 downto 0) := "00000";
signal s_count31	: std_logic_vector(6 downto 0) := "0000000";
signal s_yout		: std_logic_vector(7 downto 0) := "00000000";

--signal m_xin -- Latch in
signal s_LUT_mult_in		: std_logic_vector(7 downto 0); -- Latch out
signal s_cos_LUT_data		: std_logic_vector(7 downto 0);
signal s_sin_LUT_data		: std_logic_vector(7 downto 0);

signal s_LUT_mult_out_sin	: std_logic_vector(15 downto 0); --Latch in
signal s_LUT_mult_out_cos	: std_logic_vector(15 downto 0); --Latch in


signal s_filter_in_sin		: std_logic_vector(15 downto 0); --Latch out
signal s_filter_in_cos		: std_logic_vector(15 downto 0); --Latch out

signal s_filter_out_sin		: std_logic_vector(7 downto 0); --Latcn in
signal s_filter_out_cos		: std_logic_vector(7 downto 0); --Latch in

signal s_sqr_in_sin			: std_logic_vector(7 downto 0); --Latch out
signal s_sqr_in_cos			: std_logic_vector(7 downto 0); --Latch_out

signal s_sin_sqr			: std_logic_vector(15 downto 0);
signal s_cos_sqr			: std_logic_vector(15 downto 0);

signal s_sqr_added			: std_logic_vector(16 downto 0); --Latch in
signal s_sqrt_data_in		: std_logic_vector(16 downto 0); --Latch out
signal s_axis_cartesian_tdata	: std_logic_vector(23 downto 0); -- Cordic in

signal s_sqrt_data_out		: std_logic_vector(15 downto 0); --Latch in

signal s_LUT_address	: std_logic_vector(4 downto 0);

begin

lut_cos : Cos_LUT port map(
		clka	=> m_clk,
		ena		=> m_en,
		addra	=> s_LUT_address,
		douta	=> s_cos_LUT_data
		);
		
mult_cos : Cos_mult port map(
		CLK	=> m_clk,
		A	=> s_cos_LUT_data,
		B	=> s_LUT_mult_in,
		CE	=> m_en,
		P	=> s_LUT_mult_out_cos
		);
		
sqr_cos : cos_sqr port map(
		CLK	=> m_clk,
		A	=> s_sqr_in_cos,
		B	=> s_sqr_in_cos,
		CE	=> m_en,
		P	=> s_cos_sqr
		);
		
lut_sin : neg_Sin_LUT port map(
		clka	=> m_clk,
		ena		=> m_en,
		addra	=> s_LUT_address,
		douta	=> s_sin_LUT_data
		);

mult_sin : sin_mult port map(
		CLK	=> m_clk,
		A	=> s_sin_LUT_data,
		B	=> s_LUT_mult_in,
		CE	=> m_en,
		P	=> s_LUT_mult_out_sin
		);
		
sqr_sin : sin_sqr port map(
		CLK	=> m_clk,
		A	=> s_sqr_in_sin,
		B	=> s_sqr_in_sin,
		CE	=> m_en,
		P	=> s_sin_sqr
		);		

cos_filter : filter port map(
		m_clk	=> m_clk,
		m_en	=> m_en,
		m_pulse	=> s_pulse,
		m_din	=> s_filter_in_cos,
		m_dout	=> s_filter_out_cos,
		m_filter_coe => s_filter_coef
		);
		
sin_filter : filter port map(
		m_clk	=> m_clk,
		m_en	=> m_en,
		m_pulse	=> s_pulse,
		m_din	=> s_filter_in_sin,
		m_dout	=> s_filter_out_sin,
		m_filter_coe => s_filter_coef
		);

sqrt_17to9 : sqrt_16to9_lat5 port map(
		aclk => m_clk,
		s_axis_cartesian_tvalid => '1',
		s_axis_cartesian_tdata => s_axis_cartesian_tdata,
		m_axis_dout_tvalid => open,
		m_axis_dout_tdata => s_sqrt_data_out
		);
		
rom_cnt_map : ROM_Counter port map(
		m_clk		=> m_clk,
		m_enable	=> s_pulse,
		m_reset		=> s_reset,
		m_skip		=> s_freq_skip,
		
		m_cnt_out	=> s_LUT_address
		);
		
m_freq_skip_save : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_save_freq = '1' then
			s_freq_skip <= m_freq_skip;
		else
			s_freq_skip <= s_freq_skip;
		end if;
	end if;
end process;

--latching
latch : process(m_clk)
begin
	if rising_edge(m_clk) then
		if s_pulse = '1' then
			s_LUT_mult_in <= m_xin;
			
			--s_filter_in_sin <= s_LUT_mult_out_sin;
			--s_filter_in_cos <= s_LUT_mult_out_cos;
			
			--s_sqr_in_sin	<= s_filter_out_sin;
			--s_sqr_in_cos	<= s_filter_out_cos;
			
			--s_sqrt_data_in 	<= s_sqr_added;
			
			s_yout			<= s_sqrt_data_out(7 downto 0);
		else
			s_LUT_mult_in 	<= s_LUT_mult_in;
			
			--s_filter_in_sin <= s_filter_in_sin;
			--s_filter_in_cos <= s_filter_in_cos;
			
			--s_sqr_in_sin	<= s_sqr_in_sin;
			--s_sqr_in_cos	<= s_sqr_in_cos;
			
			--s_sqrt_data_in	<= s_sqrt_data_in;
			
			s_yout			<= s_yout;
		end if;
	end if;
end process;


init : process (m_clk)
begin
	if rising_edge(m_clk) then
		if m_reset_b = '0' then
			state <= Idle;
		else
			case state is
				when Idle =>
					if m_en = '1' then
						state <= freq_save;
					else
						state <= Idle;
					end if;
					
				when freq_save =>
					state <= wait_option;
					
				when wait_option =>
					state <= wait_option;
					
			end case;
		end if;
	end if;
end process;

-- count 10 : Clock 10개 세기.
count10 : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_reset_count = '1' then
			s_pulse_count <= "0000";
		elsif m_en = '1' then
			s_pulse_count <= s_pulse_count + 1;
		else
			s_pulse_count <= s_pulse_count;
		end if;
	else
		s_pulse_count <= s_pulse_count;
	end if;
end process;

-- 31 개 값 버려 계산된 값 31개 버림
count31 : process(m_clk)
begin
	if rising_edge(m_clk) then
		if m_reset_b = '0' then
			s_count31 <= "0000000";
		elsif s_pulse = '1' and (s_count31 < "0100011")then --s_yout_valid 아래도 같이 수정
			s_count31 <= s_count31 + 1;
		else
			s_count31 <= s_count31;
		end if;
	end if;
end process;
	
	
-- coefficient(signed 8 bit) : s_filter_coef(15) 기준으로 대칭
-- 범위 : -128 ≤ coefficient ≤ 127 
s_filter_coef(0) <= conv_std_logic_vector(5,8);
s_filter_coef(1) <= conv_std_logic_vector(5,8);
s_filter_coef(2) <= conv_std_logic_vector(7,8);
s_filter_coef(3) <= conv_std_logic_vector(10,8);
s_filter_coef(4) <= conv_std_logic_vector(14,8);
s_filter_coef(5) <= conv_std_logic_vector(19,8);
s_filter_coef(6) <= conv_std_logic_vector(25,8);
s_filter_coef(7) <= conv_std_logic_vector(31,8);
s_filter_coef(8) <= conv_std_logic_vector(37,8);
s_filter_coef(9) <= conv_std_logic_vector(43,8);
s_filter_coef(10) <= conv_std_logic_vector(48,8);
s_filter_coef(11) <= conv_std_logic_vector(53,8);
s_filter_coef(12) <= conv_std_logic_vector(57,8);
s_filter_coef(13) <= conv_std_logic_vector(60,8);
s_filter_coef(14) <= conv_std_logic_vector(62,8);
s_filter_coef(15) <= conv_std_logic_vector(63,8);

s_pulse <= '1' when s_pulse_count = "1001" else '0';
s_reset_count <= '1' when s_pulse_count = "1001" else '0';


--s_LUT_mult_in <= m_xin;		
s_filter_in_sin <= s_LUT_mult_out_sin;
s_filter_in_cos <= s_LUT_mult_out_cos;	
s_sqr_in_sin	<= s_filter_out_sin;
s_sqr_in_cos	<= s_filter_out_cos;	
s_sqrt_data_in 	<= s_sqr_added;
--s_yout			<= s_sqrt_data_out(7 downto 0);

s_axis_cartesian_tdata <= ("0000000" & s_sqrt_data_in);
s_sqr_added		<= ('0'&s_sin_sqr) + ('0'&s_cos_sqr);
s_reset			<= (not m_reset_b) or m_write_end;
s_save_freq		<= '1' when state = freq_save else '0';

m_pulse 		<= s_pulse;
m_yout 			<= s_yout;
s_yout_valid <= '1' when s_count31 = "0100011" else '0';
m_yout_valid <= s_yout_valid;

end Behavioral;