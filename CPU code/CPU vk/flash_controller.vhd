----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:05:35 11/26/2015 
-- Design Name: 
-- Module Name:    flash_controller - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flash_controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
		   booting : out  std_logic;
           FlashByte : out  STD_LOGIC;
           FlashVpen : out  STD_LOGIC;
           FlashCE : out  STD_LOGIC;
			  FlashOE : out  STD_LOGIC;
           FlashWE : out  STD_LOGIC;
           FlashRP : out  STD_LOGIC;
           FlashAddr : out  STD_LOGIC_VECTOR (22 downto 0);
           FlashData : inout  STD_LOGIC_VECTOR (15 downto 0));
end flash_controller;

architecture Behavioral of flash_controller is
	signal cnt : std_logic_vector(15 downto 0) := "0000000000000000";
	type status_type is (read1, read2, read3, read4);
	signal status : status_type := read1;
	signal offset : std_logic_vector(5 downto 0) := "000000";
	
begin

	FlashCE <= '0';
	FlashByte <= '1';
	FlashVpen <= '1';
	FlashRP <= '1';
	
	process (rst, clk)
	begin
		if rst = '0' then
			status <= read1;
			booting <= '0';
		elsif clk'event and clk = '1' then
			case status is
				when read1 =>
					status <= read2;
					booting <= '0';
					FlashWE <= '0';
					FlashData <= x"00FF";
					cnt <= (others =>'0');
					offset <= (others => '0');
				when read2 =>
					if offset < 20 then
						offset <= offset + 1;
					else
						status <= read3;
					end if;
					FlashWE <= '1';
				when read3 =>
					FlashOE <= '0';
					booting <= '1';
					FlashData <= (others => 'Z');
					FlashAddr <= "0000000" & cnt(15 downto 0);
					if cnt < 4000 then
						cnt <= cnt + 1;
					else
						status <= read4;
					end if;
				when read4 =>
					FlashOE <= '1';
					booting <= '0';
			end case;
		end if;
	end process;

end Behavioral;

