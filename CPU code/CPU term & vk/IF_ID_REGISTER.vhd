library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constdef.ALL;

entity IF_ID_REGISTER is
	PORT ( clk :  in STD_LOGIC;
		    INPC :  in STD_LOGIC_VECTOR(15 downto 0);
			 INTERRUPT :  in STD_LOGIC_VECTOR(3 downto 0);
			 SOFTINTNUM :  in STD_LOGIC_VECTOR(3 downto 0);
	       INIR :  inout STD_LOGIC_VECTOR(15 downto 0);
	       IFIDSTOP :  in STD_LOGIC;
	       IF_FLUSH :  in STD_LOGIC;
			 IF_WRITE_RAM2 : in STD_LOGIC;
	       OUTPC :  out STD_LOGIC_VECTOR(15 downto 0);
	       OUTIR :  out STD_LOGIC_VECTOR(15 downto 0);
			 debug :  out STD_LOGIC_VECTOR(15 downto 0)
	       );
end IF_ID_REGISTER;

architecture Behavioral of IF_ID_REGISTER is
	signal INT_PC : STD_LOGIC_VECTOR(15 downto 0);
	type state_type is (normal, --d0, d1, d2, d3, d4, d5, d6, d7, finishd, e0, e1, e2, e3, e4, finishe, 
							  ct0, ct1, ct2, ct3, ct4, ct5, ct6, ct7, ct8, finishct, cv0, cv1, cv2, cv3, cv4, cv5, cv6, finishcv);
	signal status : state_type := normal;
	signal caninter : STD_LOGIC := '1';
	type INTERRUPT_TYPE is (none, inter);
	--signal inttype : INTERRUPT_TYPE := none;
	signal intnum : STD_LOGIC_VECTOR(7 downto 0);
	signal jumppc : STD_LOGIC_VECTOR(7 downto 0);
begin
	INIR <= (others => 'Z');
--	process(INTERRUPT)
--	begin
----		if (INTERRUPT(3) = '1' and INPC(15 downto 13) = "011" and caninter = '1') then
----			inttype <= hard;
----		elsif (INTERRUPT(2) = '1' and INPC(15 downto 13) = "011") then
----			inttype <= Ctrl_c;
----		elsif INTERRUPT(1) = '1' then
----			inttype <= soft;
--		if INTERRUPT(0) = '1' then
--			if inttype = none then
--				inttype <= inter;
--			end if;
----			if INPC(15 downto 13) = "001" or INPC(15 downto 13) = "010" then
----				inttype <= clockterm;
----			else --if INPC(15 downto 13) = "000" or INPC(15 downto 13) = "011" then
----				inttype <= clockvga;
----			end if;
--		elsif INTERRUPT(0) = '0' then
--			inttype <= none;
--		end if;
----		if status = d0 then
----			caninter <= '0';
----		end if;
----		if INTERRUPT = "0000" then
----			caninter <= '1';
----		end if;
--	end process;
	
	process(clk)
	begin
--		if INTERRUPT(0) = '1' then
--			if inttype = none then
--				inttype <= inter;
--			end if;
--		end if;
		if clk'event and clk = '1' then
			case status is
				when normal =>
					if INTERRUPT(0) = '1' and INPC(15) = '0' then
						--inttype <= none;
						if INPC(14 downto 13) = "01" or INPC(14 downto 13) = "10" then
							status <= ct0;
							OUTPC <= INPC;
							if IF_FLUSH = '1' then
								INT_PC <= INPC - 2;
							else
								INT_PC <= INPC - 1;
							end if;
							OUTIR <= NOP;
						else
							status <= cv0;
							OUTPC <= INPC;
							if IF_FLUSH = '1' then
								INT_PC <= INPC - 2;
							else
								INT_PC <= INPC - 1;
							end if;
							OUTIR <= NOP;
						end if;
					else
						if IFIDSTOP = '0' then
							if IF_WRITE_RAM2 = '1' then
								OUTIR <= NOP;
							else
								OUTPC <= INPC;
								OUTIR <= INIR;
							end if;
						end if;
					end if;
--				when normal =>
--					case inttype is
--					when clockterm =>
--						status <= ct0;
--						OUTPC <= INPC;
--						if IF_FLUSH = '1' then
--							INT_PC <= INPC - 2;
--						else
--							INT_PC <= INPC - 1;
--						end if;
--						OUTIR <= NOP;
--					when clockvga =>
--						status <= cv0;
--						OUTPC <= INPC;
--						if IF_FLUSH = '1' then
--							INT_PC <= INPC - 2;
--						else
--							INT_PC <= INPC - 1;
--						end if;
--						OUTIR <= NOP;
--					when none =>
--						if IFIDSTOP = '0' then
--							if IF_WRITE_RAM2 = '1' then
--								OUTIR <= NOP;
--							else
--								OUTPC <= INPC;
--								OUTIR <= INIR;
--							end if;
--						end if;
--					when others =>
--						OUTIR <= "1111111111111111";
--						
--					end case;
				
				----term中时钟中断
				when ct0 =>
					status <= ct1;
					OUTPC <= INT_PC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when ct1 =>
					status <= ct2;
					OUTPC <= INT_PC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when ct2 =>
					status <= ct3;
					OUTPC <= INT_PC;
					OUTIR <= "1110111001000000";--MFPC R6
				when ct3 =>
					status <= ct4;
					OUTPC <= INT_PC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when ct4 =>
					status <= ct5;
					OUTPC <= INT_PC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when ct5 =>
					status <= ct6;
					OUTPC <= INT_PC;
					OUTIR <= "0110111000100000";--LI R6 0020
				when ct6 =>
					status <= ct7;
					OUTPC <= INT_PC;
					OUTIR <= "0011011011000000"; --SLL R6 0
				when ct7 =>
					status <= ct8;
					OUTPC <= INT_PC;
					OUTIR <= "0100111000000101"; --ADDIU R6 5
				when ct8 =>
					status <= finishct;
					OUTPC <= INT_PC;
					OUTIR <= "1110111000000000";--JR R6
				when finishct =>
					status <= normal;
					OUTPC <= INT_PC;
					OUTIR <= NOP;
				
				----vga中时钟中断
				when cv0 =>
					status <= cv1;
					OUTPC <= INT_PC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when cv1 =>
					status <= cv2;
					OUTPC <= INT_PC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when cv2 =>
					status <= cv3;
					OUTPC <= INT_PC;
					OUTIR <= "1110111001000000";--MFPC R6
				when cv3 =>
					status <= cv4;
					OUTPC <= INT_PC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when cv4 =>
					status <= cv5;
					OUTPC <= INT_PC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when cv5 =>
					status <= cv6;
					OUTPC <= INT_PC;
					OUTIR <= "0110111000001111";--LI R6 11
				when cv6 =>
					status <= finishcv;
					OUTPC <= INT_PC;
					OUTIR <= "1110111000000000";--JR R6
				when finishcv =>
					status <= normal;
					OUTPC <= INT_PC;
					OUTIR <= NOP;
				----普通硬件中断&软件中断-----
--				when d0 =>
--					status <= d1;
--					OUTPC <= INT_PC;
--					OUTIR <= "1110111001000000";--MFPC R6
--				when d1 =>
--					status <= d2;
--					OUTPC <= INT_PC;
--					OUTIR <= "0110001111111111";--ADDSP FF
--				when d2 =>
--					status <= d3;
--					OUTPC <= INT_PC;
--					OUTIR <= "1101011000000000";--SW_SP R6 0
--				when d3 =>
--					status <= d4;
--					OUTPC <= INT_PC;
--					OUTIR <= "01101110" & intnum;--LI R6 intnum
--				when d4 =>
--					status <= d5;
--					OUTPC <= INT_PC;
--					OUTIR <= "0110001111111111";--ADDSP FF
--				when d5 =>
--					status <= d6;
--					OUTPC <= INT_PC;
--					OUTIR <= "1101011000000000";--SW_SP R6 0
--				when d6 =>
--					status <= d7;
--					OUTPC <= INT_PC;
--					OUTIR <= "0110111000000111";--LI R6 7
--				when d7 =>
--					status <= finishd;
--					OUTPC <= INT_PC;
--					OUTIR <= "1110111000000000";--JR R6
--				when finishd =>
--					status <= normal;
--					OUTPC <= INT_PC;
--					OUTIR <= NOP;
--					
--				---跳出中断----
--				when e0 =>
--					status <= e1;
--					OUTPC <= INPC;
--					OUTIR <= "01101110" & intnum;--LI R6 numint
--				when e1 =>
--					status <= e2;
--					OUTPC <= INPC;
--					OUTIR <= "0110001111111111";--ADDSP FF
--				when e2 =>
--					status <= e3;
--					OUTPC <= INPC;
--					OUTIR <= "1101011000000000";--SW_SP R6 0
--				when e3 =>
--					status <= e4;
--					OUTPC <= INPC;
--					OUTIR <= "0110111000001001";--LI R6 9
--				when e4 =>
--					status <=finishe;
--					OUTPC <= INPC;
--					OUTIR <= "1110111000000000";--JR R6
--				when finishe =>
--					status <=normal;
--					OUTPC <= INPC;
--					OUTIR <= NOP;
				--when others =>
			end case;
		end if;
	end process;
end Behavioral;
