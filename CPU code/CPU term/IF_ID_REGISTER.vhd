library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constdef.ALL;

entity IF_ID_REGISTER is
	PORT ( clk :  in STD_LOGIC;
	       rst :  in STD_LOGIC;
		    INPC :  in STD_LOGIC_VECTOR(15 downto 0);
			 INTERRUPT :  in STD_LOGIC;
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
	signal debug_tmp : std_logic_vector(15 downto 0) := "0000000000000000";
	type state_type is (normal, d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, finish);
	signal status : state_type := normal;
	signal caninter : STD_LOGIC := '1';
begin
	debug <= debug_tmp;
	INIR <= (others => 'Z');

	process(clk, rst)
	begin
		if rst = '0' then
			OUTPC <= (others => '0');
			OUTIR <= NOP;
		elsif clk'event and clk = '1' then
			case status is
				when normal =>
					if (INTERRUPT = '0' and INPC(15 downto 14) = "01" and caninter = '1') then		--如果有中断,并且在用户程序中
						status <= d0;
						OUTPC <= INPC;
						if IF_FLUSH = '1' then
							INT_PC <= INPC - 2;
						else
							INT_PC <= INPC - 1;
						end if;
						OUTIR <= NOP;
						caninter <= '0';		
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
					if INTERRUPT = '1' then
						caninter <= '1';
					end if;
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
					OUTIR <= "0110111000010000";--LI R6 4F
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
					OUTIR <= "0110111000000101";--LI R6 5
				when d7 =>
					status <= d8;
					OUTPC <= INT_PC;
					OUTIR <= NOP;
				when d8 =>
					status <= d9;
					OUTPC <= INT_PC;
					OUTIR <= NOP;
				when d9 =>
					status <= finish;
					OUTPC <= INT_PC;
					OUTIR <= "1110111000000000";--JR R6
				when finish =>
					status <= normal;
					OUTPC <= INT_PC;
					OUTIR <= NOP;
				when others =>
			end case;
		end if;
	end process;
end Behavioral;
