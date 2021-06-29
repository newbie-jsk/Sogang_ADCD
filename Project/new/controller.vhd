----------------------------------------------------------------------------------
-- Company: Sogang Univ. EE
-- Engineer: Jungsub Kim / Seunghyun Ahn
-- 
-- Create Date: 2021/05/12 01:37:15
-- Design Name: PCFG Controller
-- Module Name: controller - behav
-- Project Name: PCFG Project
--				
-- Target Devices: Xilinx Spartan 7
-- Tool Versions: Vivado
-- Description: 
-- Processor Song.'s Advacned Digital Circuit Design project.
--
-- Dependencies: 
-- 
-- Revision: v1.0
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
	Port (
		m_clk			: in std_logic;
		m_sys_clk		: in std_logic;
		m_wen			: in std_logic;
		m_ren			: in std_logic;
		m_cmd_data 		: in std_logic;
		m_oe_b			: in std_logic;
		m_option_data_valid	: in std_logic;
		m_cont_addr 	: in std_logic_vector (3 downto 0);
		m_data			: in std_logic_vector(7 downto 0);
		
		m_8254reset		: out std_logic;
		m_reset1_b		: out std_logic;
		m_out_latch_en	: out std_logic;
		m_in_latch_en	: out std_logic;
		m_pc_mux	: out std_logic;
		m_da_latch_en : out std_logic;
		m_out_mux_sel	: out std_logic_vector (1 downto 0);
		
		m_PC_ram_ren		: out std_logic;
		m_PC_ram_wen	: out std_logic;
		m_PC_ram_wr_addr	: out std_logic_vector(10 downto 0);
		m_PC_ram_rd_addr	: out std_logic_vector(10 downto 0);
		
		m_AD_latch_en	: out std_logic;
		m_AD_ram_wen	: out std_logic;
		m_AD_ram_ren	: out std_logic;
		m_AD_ram_wr_addr	: out std_logic_vector(10 downto 0);
		m_AD_ram_rd_addr	: out std_logic_vector(10 downto 0);
		
		m_option_en			: out std_logic;
		m_option_write_end	: out std_logic;
		m_option_ram_wen	: out std_logic;
		m_option_ram_ren	: out std_logic;
		m_option_ram_wr_addr	: out std_logic_vector(10 downto 0);
		m_option_ram_rd_addr	: out std_logic_vector(10 downto 0)
		);
end controller;

architecture behav of controller is

type control_PC is (	
				Idle,
				PC_start, PC_write_wait, PC_write, PC_write_last, PC_write_end,
				PC_read_wait, PC_read, PC_read_last, PC_read_end);
				
type control_DA is (	
				Idle,
				DA_start, DA_mode, DA_stop);
				
type control_AD is (	
				Idle,
				AD_start, AD_write, AD_write_wait,
				AD_transfer_wait1, AD_transfer_wait2, AD_transfer_wait3,
				AD_transfer, AD_transfer_end);
				
type control_ADR is (	
				Idle,
				ADR_start, ADR_read, ADR_read_wait0, ADR_read_wait1, ADR_end);

type control_option1 is (	
				Idle,
				option_start, option_wait1, option_wait2, option_wait3,
				option_running,
				option_ram_write, option_close);

type control_option2 is (	
				Idle,
				option2_start, option2_read, option2_read_wait0, option2_read_wait1, option2_end);				

--====== Resetting signals ======--
signal s_reset_b1 : std_logic := '1';
signal s_reset_b2 : std_logic := '1';
signal s_reset_b3 : std_logic := '1';

--====== Address Decoding signals ======--
signal s_8254_reset	: std_logic := '0';
signal s_PC_mode	: std_logic := '0';
signal s_DA_start	: std_logic := '0';
signal s_DA_stop	: std_logic := '0';
signal s_AD_mode	: std_logic := '0';
signal s_ADR_mode	: std_logic := '0';
signal s_Option1	: std_logic := '0';
signal s_Option2	: std_logic := '0';

--====== 11bit PC Read signals ======--
signal s_PC_RD_first		: std_logic := '0';
signal s_PC_RD_addr_up 		: std_logic := '0';
signal s_PC_RD_addr_reset	: std_logic := '0';
signal s_PC_RD_addr 		: std_logic_vector (10 downto 0) := "00000000000";

--====== 11bit PC Write signals ======--
signal s_PC_WR_addr_up 		: std_logic := '0';
signal s_PC_WR_addr_reset	: std_logic := '0';
signal s_PC_WR_addr 		: std_logic_vector (10 downto 0) := "00000000000";

--====== 11bit AD Write signals ======--
signal s_AD_WR_addr_up 		: std_logic := '0';
signal s_AD_WR_addr_reset	: std_logic := '0';
signal s_AD_WR_addr 		: std_logic_vector (10 downto 0) := "00000000000";

--====== 11bit AD Read signals ======--
signal s_AD_RD_addr_up 		: std_logic := '0';
signal s_AD_RD_addr_reset	: std_logic := '0';
signal s_AD_RD_addr 		: std_logic_vector (10 downto 0) := "00000000000";

--====== 11bit Option Write signals ======--
signal s_option_WR_addr_up 		: std_logic := '0';
signal s_option_WR_addr_reset	: std_logic := '0';
signal s_option_WR_addr 		: std_logic_vector (10 downto 0) := "00000000000";

--====== 11bit option Read signals ======--
signal s_option_RD_addr_up 		: std_logic := '0';
signal s_option_RD_addr_reset	: std_logic := '0';
signal s_option_RD_addr 		: std_logic_vector (10 downto 0) := "00000000000";

-- Option control signal
signal s_pulse_count : std_logic_vector (3 downto 0) := "0000";
signal s_option_en	: std_logic;
signal s_10count	: std_logic;
signal s_reset_count	: std_logic;
signal s_7count		: std_logic;
	
--====== Internal contorl signals ======--
signal s_AD_stop			: std_logic := '0';
signal s_AD_finish			: std_logic := '0';
signal s_option_close		: std_logic := '0';
signal s_sampling_en		: std_logic := '0';
signal s_samp_data			: std_logic_vector(7 downto 0) := "00000000";
signal state_PC : control_PC := Idle;
signal state_AD : control_AD := Idle;
signal state_DA : control_DA := Idle;
signal state_ADR : control_ADR := Idle;
signal state_option1 : control_option1 := Idle;
signal state_option2 : control_option2 := Idle;

begin

-- Timing improvements!!!!
state_process : process (m_clk, s_reset_b1)
begin
	if rising_edge(m_clk) then 
		if s_reset_b1 = '0' then
			state_PC <= Idle;
		else
			case state_PC is
				when Idle =>
					if s_PC_mode = '1' then
						state_PC <= PC_start;
					else
						state_PC <= Idle;
					end if;
					
				when PC_start => 
					if m_oe_b = '1' then
						state_PC <= PC_write_wait;
					elsif m_oe_b = '0' then
						state_PC <= PC_read_wait;
					else
						state_PC <= PC_start;
					end if;
					
				when PC_write_wait =>
					if m_wen = '1' then
						state_PC <= PC_write;
					else
						state_PC <= PC_write_wait;
					end if;
					
				when PC_write =>
					state_PC <= PC_write_last;
				
				when PC_write_last =>
					if m_wen = '1' then
						state_PC <= PC_write_last;
					else
						state_PC <= PC_write_end;
					end if;

				when PC_write_end =>
					state_PC <= Idle;
				--------------------------------------
				when PC_read_wait =>
					if m_ren = '1' then
						state_PC <= PC_read;
					else
						state_PC <= PC_read_wait;
					end if;
					
				when PC_read =>
					if m_ren = '0' then
						state_PC <= PC_read_last;
					else
						state_PC <= PC_read;
					end if;

				when PC_read_last =>
					state_PC <= PC_read_end;
					
				when PC_read_end =>
					state_PC <= Idle;
			end case;
		end if;
	end if;
	
	if rising_edge(m_clk) then 
		if s_reset_b1 = '0' then
			state_DA <= Idle;
		else
			case state_DA is
				when Idle =>
					if s_DA_start = '1' then
						state_DA <= DA_start;
					else
						state_DA <= Idle;
					end if;
					
				when DA_start =>
					state_DA <= DA_mode;
				
				when DA_mode =>
					if s_DA_stop = '1' then
						state_DA <= DA_stop;
					else
						state_DA <= DA_mode;
					end if;
					
				when DA_stop => 
					state_DA <= Idle;
				
			end case;
		end if;
	end if;
	
	if rising_edge(m_clk) then 
		if s_reset_b1 = '0' then
			state_AD <= Idle;
		else
			case state_AD is
				when Idle =>
					if s_AD_mode = '1' then
						state_AD <= AD_start;
					else
						state_AD <= Idle;
					end if;
					
				-- AD write address counter reset
				when AD_start =>
					state_AD <= AD_write_wait;
					
				-- AD ram write state_AD
				when AD_write_wait =>
					if s_AD_mode = '0' then
						state_AD <= AD_write;
					else
						state_AD <= AD_write_wait;
					end if;
				
				when AD_write =>
					if s_AD_stop = '1' then
						state_AD <= AD_transfer_wait1;
					else
						state_AD <= AD_write;
					end if;
				
				when AD_transfer_wait1 =>
					state_AD <= AD_transfer_wait2;
					
				when AD_transfer_wait2 =>
					state_AD <= AD_transfer_wait3;
				
				when AD_transfer_wait3 =>
					state_AD <= AD_transfer;
				
				when AD_transfer =>
					if s_AD_finish = '1' then
						state_AD <= AD_transfer_end;
					else
						state_AD <= AD_transfer;
					end if;
				
				when AD_transfer_end =>
					state_AD <= Idle;
					
			end case;
		end if;
	end if;
	
	if rising_edge(m_clk) then
		if s_reset_b1 = '0' then
			state_ADR <= Idle;
		else
			case state_ADR is
				when Idle =>
					if s_ADR_mode = '1' then
						state_ADR <= ADR_start;
					else
						state_ADR <= Idle;
					end if;
					
				when ADR_start =>
					if m_ren = '1' then
						state_ADR <= ADR_read;
					else
						state_ADR <= ADR_start;
					end if;
				
				when ADR_read =>
					if m_ren = '0' then
						state_ADR <= ADR_read_wait0;
					else
						state_ADR <= ADR_read;
					end if;
					
				when ADR_read_wait0 =>
					state_ADR <= ADR_read_wait1;
				
				when ADR_read_wait1 =>
					state_ADR <= ADR_end;
					
				when ADR_end =>
					state_ADR <= Idle;
				
			end case;
		end if;
	end if;
	
	if rising_edge(m_clk) then
		if s_reset_b1 = '0' then
			state_option1 <= Idle;
		else
			case state_option1 is
				when Idle =>
					if s_option1 = '1' then
						state_option1 <= option_start;
					else
						state_option1 <= Idle;
					end if;
					
				when option_start =>
					state_option1 <= option_wait1;
				
				when option_wait1 =>
					state_option1 <= option_wait2;
				
				when option_wait2 =>
					state_option1 <= option_wait3;
				
				when option_wait3 =>
					state_option1 <= option_running;
					
				when option_running =>
					if m_option_data_valid = '1' then
						state_option1 <= option_ram_write;
					else
						state_option1 <= option_running;
					end if;
				
				when option_ram_write =>
					if s_option_close = '1' then
						state_option1 <= option_close;
					else
						state_option1 <= option_ram_write;
					end if;
				
				when option_close =>
					state_option1 <= Idle;
				
			end case;
		end if;
	end if;
	
	if rising_edge(m_clk) then 
		if s_reset_b1 = '0' then
			state_option2 <= Idle;
		else 
			case state_option2 is
				when Idle =>
					if s_option2 = '1' then
						state_option2 <= option2_start;
					else
						state_option2 <= Idle;
					end if;
					
				when option2_start =>
					if m_ren = '1' then
						state_option2 <= option2_read;
					else
						state_option2 <= option2_start;
					end if;
				
				when option2_read =>
					if m_ren = '0' then
						state_option2 <= option2_read_wait0;
					else
						state_option2 <= option2_read;
					end if;
					
				when option2_read_wait0 =>
					state_option2 <= option2_read_wait1;
				
				when option2_read_wait1 =>
					state_option2 <= option2_end;
					
				when option2_end =>
					state_option2 <= Idle;
				
			end case;
		end if;
	end if;
end process;

AD_sampling_data : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_reset_b3 ='0' then
			s_samp_data <= "00000000";
		elsif s_sampling_en = '1' then
			s_samp_data <= m_data;
		else
			s_samp_data <= s_samp_data;
		end if;
	end if;
end process;


PC_read_counter : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_PC_RD_addr_reset = '1' then
			s_PC_RD_addr <= "00000000000";
		elsif s_PC_RD_addr_up = '1' then
			s_PC_RD_addr <= s_PC_RD_addr + 1;
		else
			s_PC_RD_addr <= s_PC_RD_addr;
		end if;
	end if;
end process;

PC_write_counter : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_PC_WR_addr_reset = '1' then
			s_PC_WR_addr <= "00000000000"; 
		elsif s_PC_WR_addr_up = '1' then
			s_PC_WR_addr <= s_PC_WR_addr + 1;
		else
			s_PC_WR_addr <= s_PC_WR_addr;
		end if;
	end if;
end process;

AD_read_counter : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_AD_RD_addr_reset = '1' then
			s_AD_RD_addr <= "00000000000";
		elsif s_AD_RD_addr_up = '1' then
			s_AD_RD_addr <= s_AD_RD_addr + 1;
		else
			s_AD_RD_addr <= s_AD_RD_addr;
		end if;
	end if;
end process;

AD_write_counter : process (m_sys_clk)
begin
	if rising_edge(m_sys_clk) then
		if s_AD_WR_addr_reset = '1' then
			s_AD_WR_addr <= "00000000000";
		elsif s_AD_WR_addr_up = '1' then
			s_AD_WR_addr <= s_AD_WR_addr + 1;
		else
			s_AD_WR_addr <= s_AD_WR_addr;
		end if;
	end if;
end process;

Option_read_counter : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_Option_RD_addr_reset = '1' then
			s_Option_RD_addr <= "00000000000"; 
		elsif s_Option_RD_addr_up = '1' then
			s_Option_RD_addr <= s_Option_RD_addr + 1;
		else
			s_Option_RD_addr <= s_Option_RD_addr;
		end if;
	end if;
end process;

Option_write_counter : process (m_sys_clk)
begin
	if rising_edge(m_sys_clk) then
		if s_Option_WR_addr_reset = '1' then
			s_Option_WR_addr <= "00000000000";
		elsif s_Option_WR_addr_up = '1' then
			s_Option_WR_addr <= s_Option_WR_addr + 1;
		else
			s_Option_WR_addr <= s_Option_WR_addr;
		end if;
	end if;
end process;

option_count10 : process (m_clk)
begin
	if rising_edge(m_clk) then
		if s_reset_count = '1' then
			s_pulse_count <= "0000";
		elsif s_option_en = '1' then
			s_pulse_count <= s_pulse_count + 1;
		else
			s_pulse_count <= s_pulse_count;
		end if;
	else
		s_pulse_count <= s_pulse_count;
	end if;
end process;

--option signals
	s_reset_count	<= '1' when s_pulse_count = "1001" else '0';
	s_10count		<= '1' when s_pulse_count = "1001" else '0';
	s_7count		<= '1' when s_pulse_count = "0111" else '0';

--================== Mode select signals =================--
	s_reset_b1 <=	'0' when m_cont_addr = "0000" else '1';
	s_reset_b2 <=	'0' when m_cont_addr = "0000" else '1';
	s_reset_b3 <=	'0' when m_cont_addr = "0000" else '1';
	m_reset1_b <=	s_reset_b3;
	
	s_8254_reset<= '1' when m_cont_addr = "0001" else '0';
	s_PC_mode 	<= '1' when m_cont_addr = "0010" else '0';
	s_DA_start	<= '1' when m_cont_addr = "0011" else '0';
	s_DA_stop	<= '1' when m_cont_addr = "0100" else '0';
	s_AD_mode	<= '1' when m_cont_addr = "0101" else '0';
	s_ADR_mode	<= '1' when m_cont_addr = "0110" else '0';
	s_Option1	<= '1' when m_cont_addr = "0111" else '0';
	s_Option2	<= '1' when m_cont_addr = "1000" else '0';
	
	s_AD_stop	<= '1' when s_AD_WR_addr(7 downto 0) >= s_samp_data else '0';
	s_AD_finish	<= '1' when s_PC_WR_addr(7 downto 0) >= (s_samp_data - 1) else '0';
	s_sampling_en	<= '1' when state_AD = AD_start else '0';
	
--================== Output signals =================--
	m_8254reset		<= '1' when s_8254_reset = '1' else '0';
	m_out_latch_en	<= '1' when(state_PC = PC_read or 
								state_PC = PC_read_last or
								state_ADR = ADR_read or
								state_ADR = ADR_read_wait0 or
								state_ADR = ADR_read_wait1 or
								state_option2 = option2_read or
								state_option2 = option2_read_wait0 or
								state_option2 = option2_read_wait1) else
					   '0';
	m_out_mux_sel	<= "00" when (state_PC = PC_read_wait or
								  state_PC = PC_read or
								  state_PC = PC_read_last) else
					   "10" when (state_ADR = ADR_start or
								  state_ADR = ADR_read or
								  state_ADR = ADR_read_wait0 or
								  state_ADR = ADR_read_wait1) else
					   "01" when (state_option2 = option2_start or
								  state_option2 = option2_read or
								  state_option2 = option2_read_wait0 or
								  state_option2 = option2_read_wait1) else
					   "11";
	m_in_latch_en	<= '1' when (state_PC = PC_write_wait or
								 state_PC = PC_write or
								 state_PC = PC_write_last or
								 state_option1 = option_wait1 or
								 state_option1 = option_wait2 or
								 state_option1 = option_wait3 or
								 state_AD = AD_start) else
					   '0';
	m_pc_mux		<= '1' when (
								state_AD = AD_transfer_wait1 or
								state_AD = AD_transfer_wait2 or
								state_AD = AD_transfer_wait3 or
								state_AD = AD_transfer) else
				       '0';
	m_da_latch_en 	<= '1' when (state_DA = DA_mode or	
								 state_DA = DA_start) else
					   '0';
	m_AD_latch_en	<= '1' when (state_AD = AD_start or
								 state_AD = AD_write_wait or
								 state_AD = AD_write) else
					   '0';
	m_option_en		<= s_option_en;
	s_option_en		<= '1' when (state_option1 = option_wait1 or
								 state_option1 = option_wait2 or
								 state_option1 = option_wait3 or
								 state_option1 = option_running or
								 state_option1 = option_ram_write) else '0';
	
	m_option_write_end	<= '1' when state_option1 = option_close else
						   '0';					   
	
	s_option_close	<= '1' when (s_Option_WR_addr - 1) = s_PC_WR_addr else
					   '0';

--================== Internal Ram addresses Signal =================--
	
	--========== PC Ram Write address signals ==========--
	m_PC_ram_wen	<= 	'1' when (state_PC = PC_write or
								  state_AD = AD_transfer) else
						'0';
	m_PC_ram_wr_addr	<= 	s_PC_WR_addr;	
	s_PC_WR_addr_up 	<=	'1' when (state_PC = PC_write_end or
									  state_AD = AD_transfer) else
							'0';
	s_PC_WR_addr_reset	<= 	'1' when (s_reset_b2 = '0' or
									  state_AD = AD_transfer_wait1) else
							'0';
	
	--========== PC Ram Read address signals ==========--
	m_PC_ram_ren	<= 	'1' when (state_PC = PC_read_wait or
								  state_PC = PC_read or
								  state_PC = PC_read_last or
								  state_DA = DA_mode or
								  state_option1 = option_wait1 or
								  state_option1 = option_wait2 or
								  state_option1 = option_wait3 or
								  state_option1 = option_running or
								  state_option1 = option_ram_write) 
							else
						'0';
	m_PC_ram_rd_addr	<= 	s_PC_RD_addr;
	s_PC_RD_addr_up		<=  '1' when (state_PC = PC_read_end or 
									  state_DA = DA_mode or 
									  (state_option1 = option_running and s_10count = '1') or
									  (state_option1 = option_ram_write and s_10count = '1')) else
							'0';
	s_PC_RD_addr_reset	<=	'1' when s_reset_b2 = '0' or 
									 state_DA = DA_start or 
									 state_DA = DA_stop or
									 state_option1 = option_start or
									 s_PC_RD_addr >= (s_PC_WR_addr) or
									 (state_DA = DA_mode and s_PC_RD_addr = (s_PC_WR_addr - 1))else
							'0';
	
	--========== AD Ram Write address signals ==========--
	m_AD_ram_wen		<= '1' when ((state_AD = AD_write and s_AD_stop = '0') or
									  state_AD = AD_write_wait) else '0';	
	m_AD_ram_wr_addr	<= 	s_AD_WR_addr;
	s_AD_WR_addr_up		<= 	'1' when (state_AD = AD_write and s_AD_stop = '0') else
							'0';
	s_AD_WR_addr_reset	<= 	'1' when (s_reset_b2 = '0' or 
									  state_AD = AD_start) else
							'0';
	
	--========== AD Ram Read address signals ==========--
	m_AD_ram_ren		<= '1' when (state_AD = AD_transfer_wait2 or 
									 state_AD = AD_transfer_wait3 or 
									 state_AD = AD_transfer or
									 state_ADR = ADR_start or 
									 state_ADR = ADR_read or
									 state_ADR = ADR_read_wait0 or
									 state_ADR = ADR_read_wait1) else
						   '0';
	m_AD_ram_rd_addr	<= 	s_AD_RD_addr;						
	s_AD_RD_addr_up		<=  '1' when (state_AD = AD_transfer_wait2 or
									  state_AD = AD_transfer_wait3 or
									  state_AD = AD_transfer or
									  state_ADR = ADR_end) else
							'0';
	s_AD_RD_addr_reset	<= 	'1' when (state_AD = AD_start or 
									  state_AD = AD_transfer_wait1 or 
									  state_AD = AD_transfer_end or 
									  s_AD_RD_addr = s_AD_WR_addr or
									  s_reset_b2 = '0' )
									  else 
							'0'; 
	
	--========== Option Ram Write address signals ==========--
	m_option_ram_wen		<= '1' when (state_option1 = option_ram_write and s_7count = '1')else '0';
	m_option_ram_wr_addr	<= s_option_WR_addr;
	s_option_WR_addr_up		<= '1' when (state_option1 = option_ram_write and s_10count = '1') else '0';
	s_option_WR_addr_reset	<= '1' when (s_reset_b2 = '0' or
										 state_option1 = option_start) else
							   '0';
	
	--========== Option Ram Read address signals ==========--
	m_option_ram_ren	<= '1' when state_option2 = option2_start else 
						   '1' when state_option2 = option2_read else
						   '0';	
	m_option_ram_rd_addr	<= s_option_RD_addr;
	s_option_RD_addr_up		<= '1' when state_option2 = option2_end else '0';
	s_option_RD_addr_reset	<= '1' when (state_option1 = option_close or
										 s_reset_b3 = '0' or
										 s_Option_RD_addr = s_Option_WR_addr
										 ) else
							   '0'; 					   

end behav;