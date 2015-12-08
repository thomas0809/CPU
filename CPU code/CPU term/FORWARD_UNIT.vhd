----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:46:10 11/14/2015 
-- Design Name: 
-- Module Name:    FORWARD_UNIT - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FORWARD_UNIT is
    Port ( SRCREG1 : in  STD_LOGIC_VECTOR (3 downto 0);
           SRCREG2 : in  STD_LOGIC_VECTOR (3 downto 0);
           TARGETREGALU : in  STD_LOGIC_VECTOR (3 downto 0);
           TARGETREGMEM : in  STD_LOGIC_VECTOR (3 downto 0);
           REGWRITEALU : in  STD_LOGIC;
           MEMTOREGALU : in  STD_LOGIC;
           REGWRITEMEM : in  STD_LOGIC;
           MEMTOREGMEM : in  STD_LOGIC;
           FORWARDA : out  STD_LOGIC_VECTOR (1 downto 0);
           FORWARDB : out  STD_LOGIC_VECTOR (1 downto 0);
           FORWARD : out  STD_LOGIC_VECTOR (1 downto 0);
           PCSTOP : out  STD_LOGIC;
           IFIDSTOP : out  STD_LOGIC;
           CONTROLSTOP : out  STD_LOGIC);
end FORWARD_UNIT;

architecture Behavioral of FORWARD_UNIT is
	signal REGALU1 : STD_LOGIC := '0';
	signal REGMEM1 : STD_LOGIC := '0';
	signal REGALU2 : STD_LOGIC := '0';
	signal REGMEM2 : STD_LOGIC := '0';

begin
	process(SRCREG1, SRCREG2, TARGETREGALU, TARGETREGMEM)
	begin
		if SRCREG1 = TARGETREGALU then
			REGALU1 <= '1';
		else
			REGALU1 <= '0';
		end if;
		
		if SRCREG1 = TARGETREGMEM then
			REGMEM1 <= '1';
		else
			REGMEM1 <= '0';
		end if;
		
		if SRCREG2 = TARGETREGALU then
			REGALU2 <= '1';
		else
			REGALU2 <= '0';
		end if;
		
		if SRCREG2 = TARGETREGMEM then
			REGMEM2 <= '1';
		else
			REGMEM2 <= '0';
		end if;
	end process;
	
	process(REGALU1, REGALU2, REGMEM1, REGMEM2, REGWRITEALU, MEMTOREGALU, REGWRITEMEM, MEMTOREGMEM)
		variable PCSTOP1, PCSTOP2 : STD_LOGIC := '0';
		variable IFIDSTOP1, IFIDSTOP2 : STD_LOGIC := '0';
		variable CONTROLSTOP1, CONTROLSTOP2 : STD_LOGIC := '0';
	begin
		if REGALU1 = '1' and MEMTOREGALU = '1' then
			PCSTOP1 := '1';
			IFIDSTOP1 := '1';
			CONTROLSTOP1 := '1';
		elsif REGALU1 = '1' and REGWRITEALU = '1' then
			FORWARDA <= "01";
			FORWARD <= "01";
			PCSTOP1 := '0';
			IFIDSTOP1 := '0';
			CONTROLSTOP1 := '0';
		else
			if REGMEM1 = '1' and REGWRITEMEM = '1' then
				FORWARDA <= "10";
				if MEMTOREGMEM = '1' then
					FORWARD <= "11";
				else
					FORWARD <= "10";
				end if;
				PCSTOP1 := '0';
				IFIDSTOP1 := '0';
				CONTROLSTOP1 := '0';
			else
				FORWARDA <= "00";
				FORWARD <= "00";
				PCSTOP1 := '0';
				IFIDSTOP1 := '0';
				CONTROLSTOP1 := '0';
			end if;
		end if;
		
		if REGALU2 = '1' and MEMTOREGALU = '1' then
			PCSTOP2 := '1';
			IFIDSTOP2 := '1';
			CONTROLSTOP2 := '1';
		elsif REGALU2 = '1' and REGWRITEALU = '1' then
			FORWARDB <= "01";
			PCSTOP2 := '0';
			IFIDSTOP2 := '0';
			CONTROLSTOP2 := '0';
		else 
			if REGMEM2 = '1' and REGWRITEMEM = '1' then
				FORWARDB <= "10";
				PCSTOP2 := '0';
				IFIDSTOP2 := '0';
				CONTROLSTOP2 := '0';
			else
				FORWARDB <= "00";
				PCSTOP2 := '0';
				IFIDSTOP2 := '0';
				CONTROLSTOP2 := '0';
			end if;
		end if;
		
		PCSTOP <= PCSTOP1 or PCSTOP2;
		IFIDSTOP <= IFIDSTOP1 or IFIDSTOP2;
		CONTROLSTOP <= CONTROLSTOP1 or CONTROLSTOP2;
	end process;
	
end Behavioral;

