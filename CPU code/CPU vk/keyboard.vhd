----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:58 11/21/2015 
-- Design Name: 
-- Module Name:    keyboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboard is
    Port ( datain : in  STD_LOGIC;
           clkin : in  STD_LOGIC;
           fclk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           scan_code : out  STD_LOGIC_VECTOR (7 downto 0);
			  check : out STD_LOGIC_VECTOR(6 downto 0);
			  interrupt : out std_logic;
			  interruptC: out std_logic;
			  keyboard_out : out std_logic;						--下降沿取键盘
			  check_2 : out std_logic;
			  shiftstate : out std_logic;
			  ctrlstate : out std_logic;
           word : out  STD_LOGIC_VECTOR (7 downto 0));
end keyboard;

architecture Behavioral of keyboard is

type state_type is (delay, start, d0, d1, d2, d3, d4, d5, d6, d7, parity, stop, finish) ;
type stat_type is (wait_state, move_state);
signal direction: std_logic_vector(2 downto 0) := "000";
signal read_code: std_logic_vector(7 downto 0) := "00000000";
signal stat: stat_type := move_state;
signal data, clk, clk1, clk2, odd, fok : std_logic ; -- 毛刺处理内部信号, odd为奇偶校验
signal code : std_logic_vector(7 downto 0); 
signal state_t: std_logic_vector(1 downto 0) := "00";
signal state : state_type ;
signal data_clk : std_logic := '0';
signal check_data : std_logic := '0';
signal CtrlC_clk : std_logic := '0';
signal count : integer := 0;
signal out_clk : std_logic := '0';
signal press_ctrl : std_logic := '0';
signal press_shift : std_logic := '0';


begin
	clk1 <= clkin when rising_edge(fclk);
	clk2 <= clk1 when rising_edge(fclk) ;
	clk <= (not clk1) and clk2 ;
	
	data <= datain when rising_edge(fclk) ;
	
	odd <= code(0) xor code(1) xor code(2) xor code(3) 
		xor code(4) xor code(5) xor code(6) xor code(7) ;
	
	scan_code <= code when fok = '1' ;
	
	word <= read_code;
	check_2 <= check_data;
	interrupt <= data_clk;
	interruptC <= CtrlC_clk;
	keyboard_out <= out_clk;
	shiftstate <= press_shift;
	ctrlstate <= press_ctrl;
	process (out_clk)
	begin
		if rising_edge(out_clk) then
			if count < 10 then
				count <= count + 1;
			else
				check_data <= '1';
			end if;
		end if;
	end process;
	
	process(rst, fclk)
	begin
		if rst = '0' then
			state <= delay ;
			code <= (others => '0') ;
			fok <= '0' ;
			check <= "1111111";
			read_code <= "00000000";
		elsif rising_edge(fclk) then
			fok <= '0' ;
			case state is 
				when delay =>
					state <= start ;
					check <= "0000001";
				when start =>
					check <= "0000011";
					out_clk <= '0';
					if clk = '1' then
						if data = '0' then
							state <= d0 ;
						else
							state <= delay ;
						end if ;
					end if ;
				when d0 =>
					check <= "0000111";
					if clk = '1' then
						code(0) <= data ;
						state <= d1 ;
					end if;
				when d1 =>
					check <= "0001111";
					if clk = '1' then
						code(1) <= data ;
						state <= d2;
					end if ;
				when d2 =>
					if clk = '1' then
						code(2) <= data ;
						state <= d3 ;
					end if ;
				when d3 =>
					if clk = '1' then
						code(3) <= data ;
						state <= d4 ;
					end if ;
				when d4 =>
					if clk = '1' then
						code(4) <= data ;
						state <= d5 ;
					end if ;
				when d5 =>
					if clk = '1' then
						code(5) <= data ;
						state <= d6 ;
					end if ;
				when d6 =>
					if clk = '1' then
						code(6) <= data ;
						state <= d7 ;
					end if ;
				when d7 =>
					check <= "0011111";
					if clk = '1' then
						code(7) <= data ;
						state <= parity ;
					end if ;
				WHEN parity =>
					IF clk = '1' then
						if (data xor odd) = '1' then
							state <= stop ;
						else
							state <= delay ;
						end if;
					END IF;
				WHEN stop =>
					IF clk = '1' then
						if data = '1' then
							state <= finish;
							case stat is
								when move_state =>
									if code = "11110000" then
										stat <= wait_state;
									elsif code = "00010100" then
										press_ctrl <= '1';
									elsif code = "00010010" then
										press_shift <= '1';
									elsif press_ctrl = '1' and code = "00100001" then
										CtrlC_clk <= '1';
										read_code <= code;
									--elsif read_code = code or read_code = "00000000" then
									else
										stat <= move_state;
										if code = "01110110" then
											data_clk <= '1';
										elsif code /= "11110000" then
											out_clk <= '1';
										end if;
										read_code <= code;
									end if;
								when wait_state =>
									if code = "00010100" then
										press_ctrl <= '0';
										CtrlC_clk <= '0';
										stat <= move_state;
									elsif code = "00010010" then
										press_shift <= '0';
										stat <= move_state;
									elsif read_code = code then
										read_code <= "00000000";
										if code = "01110110" and data_clk = '1' then
											data_clk <= '0';
										elsif code = "00100001" and CtrlC_clk = '1' then
											CtrlC_clk <= '0';
										--elsif out_clk = '1' and code /= "01110110" then
										--	out_clk <= '0';
										end if;
										stat <= move_state;
									else
										stat <= move_state;
									end if;
								when others =>
								--	read_code <= "00000000";
									stat <= move_state;
							end case;
						end if;
					END IF;
				WHEN finish =>
					state <= delay ;
					fok <= '1' ;
				when others =>
					state <= delay ;
			end case ; 
		end if ;
	end process ;

end Behavioral;

