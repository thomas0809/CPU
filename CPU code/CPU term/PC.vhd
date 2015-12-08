library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
	PORT ( CURRENTPC :  in STD_LOGIC_VECTOR(15 downto 0);
	       LASTPC :  in STD_LOGIC_VECTOR(15 downto 0);
	       EXTENDIMM :  in STD_LOGIC_VECTOR(15 downto 0);
	       BRANCH :  in STD_LOGIC_VECTOR(1 downto 0);
	       JUMP :  in STD_LOGIC;
	       REGDATA1 :  in STD_LOGIC_VECTOR(15 downto 0);
	       ALURES1 :  in STD_LOGIC_VECTOR(15 downto 0);  --ALU result in EXE; e.g. ADD 1 2 3; BNEZ 1 00
	       ALURES2 :  in STD_LOGIC_VECTOR(15 downto 0);  --ALU result in MEM; e.g. ADD 1 2 3; NOP; BNEZ 1 00
	       MEMDATA :  in STD_LOGIC_VECTOR(15 downto 0);  --MEM result in MEM; e.g. LW 1; NOP; BNEZ 1 00
	       FORWARD :  in STD_LOGIC_VECTOR(1 downto 0);

	       NEXTPC :  out STD_LOGIC_VECTOR(15 downto 0);
	       IF_FLUSH :  out STD_LOGIC
	       );
end PC;

architecture Behavioral of PC is
	signal BranchPC :  STD_LOGIC_VECTOR(15 downto 0);
	signal JumpPC :  STD_LOGIC_VECTOR(15 downto 0);
	signal IsEqual :  STD_LOGIC := '0';
begin
	process(LASTPC, EXTENDIMM)
	begin
		BranchPC(15 downto 0) <= LASTPC + EXTENDIMM;
	end process;
	
	process(JumpPC)
	begin
		if JumpPC = "0000000000000000" then
			IsEqual <= '1';
		else
			IsEqual <= '0';
		end if;
	end process;

	process(REGDATA1, ALURES1, ALURES2, MEMDATA, FORWARD)
	begin
		case FORWARD is
			when "00" =>  --select REGDATA1
				JumpPC <= REGDATA1;
			when "01" =>  --select ALURES1
				JumpPC <= ALURES1;
			when "10" =>  --select ALURES2
				JumpPC <= ALURES2;
			when "11" =>  --select MEMDATA
				JumpPC <= MEMDATA;
			when others =>
		end case;
	end process;

	process(BRANCH, JUMP, IsEqual, BranchPC, JumpPC, CURRENTPC)
	begin
		if JUMP = '1' then
			NEXTPC <= JumpPC;
			IF_FLUSH <= '1';
		else
			case BRANCH is
				when "00" =>
					NEXTPC <= CURRENTPC;
					IF_FLUSH <= '0';
				when "10" =>
					NEXTPC <= BranchPC;
					IF_FLUSH <= '1';
				when "01" =>
					if IsEqual = '0' then
						NEXTPC <= BranchPC;
						IF_FLUSH <= '1';
					else
						NEXTPC <= CURRENTPC;
						IF_FLUSH <= '0';
					end if;
				when "11" =>
					if IsEqual = '1' then
						NEXTPC <= BranchPC;
						IF_FLUSH <= '1';
					else
						NEXTPC <= CURRENTPC;
						IF_FLUSH <= '0';
					end if;
				when others =>
			end case;
		end if;
	end process;
end Behavioral;

