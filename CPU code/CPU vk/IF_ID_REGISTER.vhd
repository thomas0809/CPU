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
	       OUTIR :  out STD_LOGIC_VECTOR(15 downto 0)
	       );
end IF_ID_REGISTER;

architecture Behavioral of IF_ID_REGISTER is
	signal INT_PC : STD_LOGIC_VECTOR(15 downto 0);
	type state_type is (normal, d0, d1, d2, d3, d4, d5, d6, d7, finishd, e0, e1, e2, e3, e4, finishe);
	signal status : state_type := normal;
	signal caninter : STD_LOGIC := '1';
	type INTERRUPT_TYPE is (none, hard, Ctrl_c, soft);
	signal inttype : INTERRUPT_TYPE := none;
	signal intnum : STD_LOGIC_VECTOR(7 downto 0);
begin
	INIR <= (others => 'Z');
	process(INTERRUPT, INPC)
	begin
		if (INTERRUPT = "1000" and INPC(15 downto 14) = "01" and caninter = '1') then
			inttype <= hard;
		elsif (INTERRUPT = "0100" and INPC(15 downto 14) = "01") then
			inttype <= Ctrl_c;
		elsif INTERRUPT = "0010" then
			inttype <= soft;
		else
			inttype <= none;
		end if;
		if status = d0 then
			caninter <= '0';
		end if;
		if INTERRUPT = "0000" then
			caninter <= '1';
		end if;
	end process;
	
	process(clk)
	begin
		if clk'event and clk = '1' then
			case status is
				when normal =>
					case inttype is
					when hard =>		--如果有中断,并且在用户程序中
						status <= d0;
						OUTPC <= INPC;
						if IF_FLUSH = '1' then
							INT_PC <= INPC - 2;
						else
							INT_PC <= INPC - 1;
						end if;
						intnum <= "00010000";
						OUTIR <= NOP;
					when Ctrl_c =>
						status <= e0;
						OUTPC <= INPC;
						OUTIR <= NOP;
						intnum <= "00010001";
					when soft =>
						status <= d0;
						OUTPC <= INPC;
						if IF_FLUSH = '1' then
							INT_PC <= INPC - 2;
						else
							INT_PC <= INPC - 1;
						end if;
						intnum <= "0000" & SOFTINTNUM;
						OUTIR <= NOP;
						
					when none =>
						if IFIDSTOP = '0' then
							if IF_FLUSH = '1' or IF_WRITE_RAM2 = '1' then
								OUTIR <= NOP;
							else
								OUTPC <= INPC;
								OUTIR <= INIR;
							end if;
						end if;
					when others =>
					end case;
					
				----普通硬件中断&软件中断-----
				when d0 =>
					status <= d1;
					OUTPC <= INT_PC;
					OUTIR <= "1110111001000000";--MFPC R6
				when d1 =>
					status <= d2;
					OUTPC <= INT_PC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when d2 =>
					status <= d3;
					OUTPC <= INT_PC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when d3 =>
					status <= d4;
					OUTPC <= INT_PC;
					OUTIR <= "01101110" & intnum;--LI R6 intnum
				when d4 =>
					status <= d5;
					OUTPC <= INT_PC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when d5 =>
					status <= d6;
					OUTPC <= INT_PC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when d6 =>
					status <= d7;
					OUTPC <= INT_PC;
					OUTIR <= "0110111000000111";--LI R6 7
				when d7 =>
					status <= finishd;
					OUTPC <= INT_PC;
					OUTIR <= "1110111000000000";--JR R6
				when finishd =>
					status <= normal;
					OUTPC <= INT_PC;
					OUTIR <= NOP;
					
				---跳出中断----
				when e0 =>
					status <= e1;
					OUTPC <= INPC;
					OUTIR <= "01101110" & intnum;--LI R6 numint
				when e1 =>
					status <= e2;
					OUTPC <= INPC;
					OUTIR <= "0110001111111111";--ADDSP FF
				when e2 =>
					status <= e3;
					OUTPC <= INPC;
					OUTIR <= "1101011000000000";--SW_SP R6 0
				when e3 =>
					status <= e4;
					OUTPC <= INPC;
					OUTIR <= "0110111000001001";--LI R6 9
				when e4 =>
					status <=finishe;
					OUTPC <= INPC;
					OUTIR <= "1110111000000000";--JR R6
				when finishe =>
					status <=normal;
					OUTPC <= INPC;
					OUTIR <= NOP;
				when others =>
			end case;
		end if;
	end process;
end Behavioral;
