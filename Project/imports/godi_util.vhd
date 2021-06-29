library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;

package godi_util is
	type std_1bit_array is array (natural range <>) of std_logic;
	type std_2bit_array is array (natural range <>) of std_logic_vector(1 downto 0);
	type std_3bit_array is array (natural range <>) of std_logic_vector(2 downto 0);
	type std_4bit_array is array (natural range <>) of std_logic_vector(3 downto 0);
	type std_5bit_array is array (natural range <>) of std_logic_vector(4 downto 0);
	type std_6bit_array is array (natural range <>) of std_logic_vector(5 downto 0);
	type std_7bit_array is array (natural range <>) of std_logic_vector(6 downto 0);
	type std_8bit_array is array (natural range <>) of std_logic_vector(7 downto 0);
	type std_9bit_array is array (natural range <>) of std_logic_vector(8 downto 0);
	type std_10bit_array is array (natural range <>) of std_logic_vector(9 downto 0);
	type std_11bit_array is array (natural range <>) of std_logic_vector(10 downto 0);
	type std_12bit_array is array (natural range <>) of std_logic_vector(11 downto 0);
	type std_13bit_array is array (natural range <>) of std_logic_vector(12 downto 0);
	type std_14bit_array is array (natural range <>) of std_logic_vector(13 downto 0);
	type std_15bit_array is array (natural range <>) of std_logic_vector(14 downto 0);
	type std_16bit_array is array (natural range <>) of std_logic_vector(15 downto 0);
	type std_17bit_array is array (natural range <>) of std_logic_vector(16 downto 0);
	type std_18bit_array is array (natural range <>) of std_logic_vector(17 downto 0);
	type std_19bit_array is array (natural range <>) of std_logic_vector(18 downto 0);
	type std_20bit_array is array (natural range <>) of std_logic_vector(19 downto 0);
	type std_21bit_array is array (natural range <>) of std_logic_vector(20 downto 0);
	type std_22bit_array is array (natural range <>) of std_logic_vector(21 downto 0);
	type std_23bit_array is array (natural range <>) of std_logic_vector(22 downto 0);
	type std_24bit_array is array (natural range <>) of std_logic_vector(23 downto 0);
	type std_25bit_array is array (natural range <>) of std_logic_vector(24 downto 0);
	type std_26bit_array is array (natural range <>) of std_logic_vector(25 downto 0);
	type std_27bit_array is array (natural range <>) of std_logic_vector(26 downto 0);
	type std_28bit_array is array (natural range <>) of std_logic_vector(27 downto 0);
	type std_29bit_array is array (natural range <>) of std_logic_vector(28 downto 0);
	type std_30bit_array is array (natural range <>) of std_logic_vector(29 downto 0);
	type std_31bit_array is array (natural range <>) of std_logic_vector(30 downto 0);
	type std_32bit_array is array (natural range <>) of std_logic_vector(31 downto 0);
	type std_33bit_array is array (natural range <>) of std_logic_vector(32 downto 0);
	type std_34bit_array is array (natural range <>) of std_logic_vector(33 downto 0);
	type std_35bit_array is array (natural range <>) of std_logic_vector(34 downto 0);
	type std_36bit_array is array (natural range <>) of std_logic_vector(35 downto 0);
	type std_37bit_array is array (natural range <>) of std_logic_vector(36 downto 0);
	type std_38bit_array is array (natural range <>) of std_logic_vector(37 downto 0);
	type std_39bit_array is array (natural range <>) of std_logic_vector(38 downto 0);
	type std_40bit_array is array (natural range <>) of std_logic_vector(39 downto 0);
	type std_64bit_array is array (natural range <>) of std_logic_vector(63 downto 0);
	
end godi_util;