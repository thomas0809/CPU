----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:36:00 11/14/2015 
-- Design Name: 
-- Module Name:    IFetch - Behavioral 
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
use work.constdef.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
    Port ( Ram2Addr : out  STD_LOGIC_VECTOR (15 downto 0);
           Ram2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           PC : in  STD_LOGIC_VECTOR (15 downto 0);
           PCInc : out  STD_LOGIC_VECTOR (15 downto 0);
           IR : out  STD_LOGIC_VECTOR (15 downto 0);
           PCStop : in  STD_LOGIC;
           IFWE : in  STD_LOGIC;
           IFData : in  STD_LOGIC_VECTOR (15 downto 0);
           IFAddr : in  STD_LOGIC_VECTOR (15 downto 0);
           Ram2EN : out  STD_LOGIC;
           Ram2WE : out  STD_LOGIC;
           Ram2OE : out  STD_LOGIC;
			  IF_WRITE_RAM2 : out STD_LOGIC;
           clk : in  STD_LOGIC;
           clk50 : in  STD_LOGIC;
			  debug : out std_logic_vector(15 downto 0));
end IFetch;

architecture Behavioral of IFetch is
	type status_type is (RamRead, RamWrite, Stop);
	signal status : status_type := RamRead;
	signal curPC, lastPC, lastPCInc : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal offset_cnt : integer range 0 to 31 := 0;
	signal debug_tmp : std_logic_vector(15 downto 0) := "0000000000000000";
	signal debug_cnt : integer range 0 to 31;--std_logic := '0';
	
begin

	debug <= debug_tmp;
	IR <= (others => '0');

	process (clk)
	begin
		if clk'event and clk = '1' then
			if offset_cnt < 20 then
				offset_cnt <= offset_cnt + 1;
			end if;
			lastPC <= curPC;
			curPC <= PC;
		end if;
	end process;

	process (PCStop, IFWE, curPC, IFData, IFAddr)
	begin
		if IFWE = '1' then
			status <= RamWrite;
		   Ram2Data <= IFData;
			Ram2Addr <= IFAddr;
		elsif PCStop = '1' then
			status <= Stop;
			Ram2Addr <= lastPC;
			Ram2Data <= (others => 'Z');
		else
			status <= RamRead;
			Ram2Data <= (others => 'Z');
			Ram2Addr <= curPC;
		end if;
	end process;
	
--	process (clk)
--	begin
--		if clk'event and clk='1' then
--			if debug_cnt < 2 then
--				Ram2Addr <= "0000000000000010";
--				curPC <= "0000000000000010";
--				debug_cnt <= debug_cnt + 1;
--			elsif debug_cnt = 2 then
--				Ram2Addr <= "0000000000000011";
--				curPC <= "0000000000000011";
--				debug_cnt <= debug_cnt + 1;
--			else
--				Ram2Addr <= "0000000000000100";
--				curPC <= "0000000000000100";
--				debug_cnt <= 30;
--			end if;
--		end if;
--	end process;

	process (clk)
	begin
		Ram2OE <= '0';
		--if clk50'event and clk50 = '0' then
			if clk = '0' then
				case status is
					when RamRead =>
						Ram2OE <= '0';
						IF_WRITE_RAM2 <= '0';
					when RamWrite =>
					-- Ram2OE <= '1';
						Ram2WE <= '0';
						IF_WRITE_RAM2 <= '1';
						debug_tmp <= IFData;
					when others =>
						IF_WRITE_RAM2 <= '1';
				end case;
--				if status = RamWrite then
--					IF_WRITE_RAM2 <= '1';
--				else
--					IF_WRITE_RAM2 <= '0';
--				end if;
				if offset_cnt >= 20 then
					case status is 
						when RamWrite =>
							PCInc <= curPC;
							lastPCInc <= curPC;
						when Stop =>
							PCInc <= lastPCInc;
							lastPCInc <= lastPCInc;
						when RamRead =>
							PCInc <= curPC + 1;
							lastPCInc <= curPC + 1;
					end case;
				else
					PCInc <= curPC;
				end if;
			else
				Ram2OE <= '1';
				Ram2WE <= '1';
--				if status = RamRead then
--					if curPC = "0000000000000011" then
--						debug_tmp <= Ram2Data;
--					end if;
--					--IR <= Ram2Data;
--				--else
--					--IR <= NOP;
--				end if;
			end if;
		--end if;
	end process;
	
end Behavioral;


	
--	process (IFWE, IFData, IFAddr)
--	begin
--		if IFWE = '0' then
--			Ram2Data <= (others => 'Z');
--			Ram2Addr <= IFAddr;
--		else
--			Ram2Data <= IFData;
--			Ram2Addr <= IFAddr;
--		end if;
--	end process;
--	
--	process (clk, IFWE)
--	begin
--		if clk = '0' then
--			if IFWE = '0' then
--				Ram2EN <= '0';
--				Ram2OE <= '0';
--				Ram2WE <= '1';
--			else
--				Ram2EN <= '0';
--				Ram2OE <= '1';
--				Ram2WE <= '0';
--			end if;
--		else
--			Ram2EN <= '1';
--			Ram2OE <= '1';
--			Ram2WE <= '1';
--		end if;
--	end process;
----	Ram2EN <= '0';
----	debug <= debug_tmp;
----	

--	
--	process (clk)
--	begin
--		if clk'event and clk = '0' then
--			PCInc <= curPC;
--			if PCStop = '0' and IFWE = '0' then
--				if curPC < 10 then
--					PCInc <= curPC + 1;
--				end if;
--			end if;
--		end if;
--	end process;
