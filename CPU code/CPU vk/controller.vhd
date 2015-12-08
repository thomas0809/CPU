----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:36:53 11/11/2015 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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
use work.constdef.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
    Port ( INSTRUCTION : in  STD_LOGIC_VECTOR (15 downto 0);
           SRCREG1 : out  STD_LOGIC_VECTOR (3 downto 0);
           SRCREG2 : out  STD_LOGIC_VECTOR (3 downto 0);
           TARGETREG : out  STD_LOGIC_VECTOR (3 downto 0);
           EXTENDIMM : out  STD_LOGIC_VECTOR (15 downto 0);
           ALUOP : out  STD_LOGIC_VECTOR (3 downto 0);
           ALUSRCA : out  STD_LOGIC_VECTOR (1 downto 0);
           ALUSRCB : out  STD_LOGIC;
           MEMTOREG : out  STD_LOGIC;
           REGWRITE : out  STD_LOGIC;
           MEMWRITE : out  STD_LOGIC;
           BRANCH : out  STD_LOGIC_VECTOR (1 downto 0);
           JUMP : out  STD_LOGIC;
			  SOFTINT : out  STD_LOGIC;
			  SOFTINTNUM : out  STD_LOGIC_VECTOR(3 downto 0)
			  );
end controller;

architecture Behavioral of controller is

begin
	process(INSTRUCTION)
	begin
		case INSTRUCTION(15 downto 11) is

			when ADDIU => --ADDIU
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "0"&INSTRUCTION(10 downto 8);
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_ADD;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";
			
			when ADDIU3 => --ADDIU3
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "0"&INSTRUCTION(7 downto 5);
				EXTENDIMM(15 downto 4) <= (others => INSTRUCTION(3));
				EXTENDIMM(3 downto 0) <= INSTRUCTION(3 downto 0);
				ALUOP <= ALUOP_ADD;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";
			
			when ADDSP_BTEQZ_MTSP =>
				case INSTRUCTION(10 downto 8) is
					when "011" => --ADDSP
						SRCREG1 <= "1001";
						SRCREG2 <= "1000";
						TARGETREG <= "1001";
						EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
						EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
						ALUOP <= ALUOP_ADD;
						ALUSRCA <= "00";
						ALUSRCB <= '0';
						MEMTOREG <= '0';
						REGWRITE <= '1';
						MEMWRITE <= '0';
						BRANCH <= "00";
						JUMP <= '0';
						SOFTINT <= '0';
						SOFTINTNUM <= "0000";
					
					when "000" => --BTEQZ
						SRCREG1 <= "1010";
						SRCREG2 <= "1000";
						TARGETREG <= "1111";
						EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
						EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
						ALUOP <= ALUOP_EMPTY;
						ALUSRCA <= "00";
						ALUSRCB <= '0';
						MEMTOREG <= '0';
						REGWRITE <= '0';
						MEMWRITE <= '0';
						BRANCH <= "11";
						JUMP <= '0';
						SOFTINT <= '0';
						SOFTINTNUM <= "0000";
						
					when "100" => --MTSP
						SRCREG1 <= "1000";
						SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
						TARGETREG <= "1001";
						EXTENDIMM <= (others => '0');
						ALUOP <= ALUOP_ASSIGNA;
						ALUSRCA <= "01";
						ALUSRCB <= '0';
						MEMTOREG <= '0';
						REGWRITE <= '1';
						MEMWRITE <= '0';
						BRANCH <= "00";
						JUMP <= '0';
						SOFTINT <= '0';
						SOFTINTNUM <= "0000";
					
					when others =>
				end case;
			
			when ADD_SUB =>
				if INSTRUCTION(1 downto 0) = "01" then --ADDU
					SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
					SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
					TARGETREG <= "0"&INSTRUCTION(4 downto 2);
					EXTENDIMM <= (others => '0');
					ALUOP <= ALUOP_ADD;
					ALUSRCA <= "00";
					ALUSRCB <= '1';
					MEMTOREG <= '0';
					REGWRITE <= '1';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";

				elsif INSTRUCTION(1 downto 0) = "11" then --SUBU
					SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
					SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
					TARGETREG <= "0"&INSTRUCTION(4 downto 2);
					EXTENDIMM <= (others => '0');
					ALUOP <= ALUOP_SUB;
					ALUSRCA <= "00";
					ALUSRCB <= '1';
					MEMTOREG <= '0';
					REGWRITE <= '1';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";
				end if;
			
			when AND_OR_MFPC_CMP_J =>
				case INSTRUCTION(2 downto 0) is
					when "100" => --AND
						SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
						SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
						TARGETREG <= "0"&INSTRUCTION(10 downto 8);
						EXTENDIMM <= (others => '0');
						ALUOP <= ALUOP_AND;
						ALUSRCA <= "00";
						ALUSRCB <= '1';
						MEMTOREG <= '0';
						REGWRITE <= '1';
						MEMWRITE <= '0';
						BRANCH <= "00";
						JUMP <= '0';
						SOFTINT <= '0';
						SOFTINTNUM <= "0000";
						
					when "101" => --OR
						SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
						SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
						TARGETREG <= "0"&INSTRUCTION(10 downto 8);
						EXTENDIMM <= (others => '0');
						ALUOP <= ALUOP_OR;
						ALUSRCA <= "00";
						ALUSRCB <= '1';
						MEMTOREG <= '0';
						REGWRITE <= '1';
						MEMWRITE <= '0';
						BRANCH <= "00";
						JUMP <= '0';
						SOFTINT <= '0';
						SOFTINTNUM <= "0000";

					when "010" => --CMP
						SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
						SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
						TARGETREG <= "1010";
						EXTENDIMM <= (others => '0');
						ALUOP <= ALUOP_EQUAL;
						ALUSRCA <= "00";
						ALUSRCB <= '1';
						MEMTOREG <= '0';
						REGWRITE <= '1';
						MEMWRITE <= '0';
						BRANCH <= "00";
						JUMP <= '0';
						SOFTINT <= '0';
						SOFTINTNUM <= "0000";

					when "000" =>
						case INSTRUCTION(7 downto 5) is
							when "110" => --JALR
								SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
								SRCREG2 <= "1000";
								TARGETREG <= "1100";
								EXTENDIMM <= (others => '0');
								ALUOP <= ALUOP_ASSIGNA;
								ALUSRCA <= "10";
								ALUSRCB <= '0';
								MEMTOREG <= '0';
								REGWRITE <= '1';
								MEMWRITE <= '0';
								BRANCH <= "00";
								JUMP <= '1';
								SOFTINT <= '0';
								SOFTINTNUM <= "0000";

							when "000" => --JR
								SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
								SRCREG2 <= "1000";
								TARGETREG <= "1111";
								EXTENDIMM <= (others => '0');
								ALUOP <= ALUOP_EMPTY;
								ALUSRCA <= "00";
								ALUSRCB <= '0';
								MEMTOREG <= '0';
								REGWRITE <= '0';
								MEMWRITE <= '0';
								BRANCH <= "00";
								JUMP <= '1';
								SOFTINT <= '0';
								SOFTINTNUM <= "0000";

							when "001" => --JRRA
								SRCREG1 <= "1100";
								SRCREG2 <= "1000";
								TARGETREG <= "1111";
								EXTENDIMM <= (others => '0');
								ALUOP <= ALUOP_ASSIGNA;
								ALUSRCA <= "10";
								ALUSRCB <= '0';
								MEMTOREG <= '0';
								REGWRITE <= '0';
								MEMWRITE <= '0';
								BRANCH <= "00";
								JUMP <= '1';
								SOFTINT <= '0';
								SOFTINTNUM <= "0000";

							when "010" => --MFPC
								SRCREG1 <= "1000";
								SRCREG2 <= "1000";
								TARGETREG <= "0"&INSTRUCTION(10 downto 8);
								EXTENDIMM <= (others => '0');
								ALUOP <= ALUOP_ASSIGNA;
								ALUSRCA <= "10";
								ALUSRCB <= '0';
								MEMTOREG <= '0';
								REGWRITE <= '1';
								MEMWRITE <= '0';
								BRANCH <= "00";
								JUMP <= '0';
								SOFTINT <= '0';
								SOFTINTNUM <= "0000";

							when others =>
						end case;
					when others =>
				end case;

			when B => --B
				SRCREG1 <= "1000";
				SRCREG2 <= "1000";
				TARGETREG <= "1111";
				EXTENDIMM(15 downto 11) <= (others => INSTRUCTION(10));
				EXTENDIMM(10 downto 0) <= INSTRUCTION(10 downto 0);
				ALUOP <= ALUOP_EMPTY;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				BRANCH <= "10";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when BEQZ => --BEQZ
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "1111";
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_EMPTY;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				BRANCH <= "11";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when BNEZ => --BNEZ
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "1111";
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_EMPTY;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				BRANCH <= "01";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when CMPI => --CMPI
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "1010";
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_EQUAL;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";
			
			when INT =>
				if INSTRUCTION(10 downto 4) = "0000000" then
					SRCREG1 <= "1000";
					SRCREG2 <= "1000";
					TARGETREG <= "1111";
					EXTENDIMM <= (others => '0');
					ALUOP <= ALUOP_EMPTY;
					ALUSRCA <= "00";
					ALUSRCB <= '0';
					MEMTOREG <= '0';
					REGWRITE <= '0';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '1';
					SOFTINTNUM <= INSTRUCTION(3 downto 0);
				else
					SRCREG1 <= "1000";
					SRCREG2 <= "1000";
					TARGETREG <= "1111";
					EXTENDIMM <= (others => '0');
					ALUOP <= ALUOP_EMPTY;
					ALUSRCA <= "00";
					ALUSRCB <= '0';
					MEMTOREG <= '0';
					REGWRITE <= '0';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";
				end if;
				
			when LI => --LI
				SRCREG1 <= "1000";
				SRCREG2 <= "1000";
				TARGETREG <= "0"&INSTRUCTION(10 downto 8);
				EXTENDIMM(15 downto 8) <= (others => '0');
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_ASSIGNB;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when LW => --LW
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "0"&INSTRUCTION(7 downto 5);
				EXTENDIMM(15 downto 5) <= (others => INSTRUCTION(4));
				EXTENDIMM(4 downto 0) <= INSTRUCTION(4 downto 0);
				ALUOP <= ALUOP_ADD;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '1';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when LW_SP => --LW_SP
				SRCREG1 <= "1001";
				SRCREG2 <= "1000";
				TARGETREG <= "0"&INSTRUCTION(10 downto 8);
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_ADD;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '1';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when MFTIH => 
				if INSTRUCTION(0) = '0' then --MFIH
					SRCREG1 <= "1011";
					SRCREG2 <= "1000";
					TARGETREG <= "0"&INSTRUCTION(10 downto 8);
					EXTENDIMM <= (others => '0');
					ALUOP <= ALUOP_ASSIGNA;
					ALUSRCA <= "00";
					ALUSRCB <= '0';
					MEMTOREG <= '0';
					REGWRITE <= '1';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";
				else --MTIH
					SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
					SRCREG2 <= "1000";
					TARGETREG <= "1011";
					EXTENDIMM <= (others => '0');
					ALUOP <= ALUOP_ASSIGNA;
					ALUSRCA <= "00";
					ALUSRCB <= '0';
					MEMTOREG <= '0';
					REGWRITE <= '1';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";
				end if;

			when MOVE => --MOVE
				SRCREG1 <= "1000";
				SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
				TARGETREG <= "0"&INSTRUCTION(10 downto 8);
				EXTENDIMM <= (others => '0');
				ALUOP <= ALUOP_ASSIGNA;
				ALUSRCA <= "01";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when NOP_HEAD => --NOP
				SRCREG1 <= "1000";
				SRCREG2 <= "1000";
				TARGETREG <= "1111";
				EXTENDIMM <= (others => '0');
				ALUOP <= ALUOP_EMPTY;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when SLL_SRA =>
				if INSTRUCTION(0) = '0' then --SLL
					SRCREG1 <= "1000";
					SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
					TARGETREG <= "0"&INSTRUCTION(10 downto 8);
					EXTENDIMM(15 downto 3) <= (others => '0');
					EXTENDIMM(2 downto 0) <= INSTRUCTION(4 downto 2);
					ALUOP <= ALUOP_SLL;
					ALUSRCA <= "01";
					ALUSRCB <= '0';
					MEMTOREG <= '0';
					REGWRITE <= '1';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";
				else --SRA
					SRCREG1 <= "1000";
					SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
					TARGETREG <= "0"&INSTRUCTION(10 downto 8);
					EXTENDIMM(15 downto 3) <= (others => '0');
					EXTENDIMM(2 downto 0) <= INSTRUCTION(4 downto 2);
					ALUOP <= ALUOP_SRA;
					ALUSRCA <= "01";
					ALUSRCB <= '0';
					MEMTOREG <= '0';
					REGWRITE <= '1';
					MEMWRITE <= '0';
					BRANCH <= "00";
					JUMP <= '0';
					SOFTINT <= '0';
					SOFTINTNUM <= "0000";
				end if;

			when SLTI => --SLTI
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "1000";
				TARGETREG <= "1010";
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_LESS;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '1';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when SW => --SW
				SRCREG1 <= "0"&INSTRUCTION(10 downto 8);
				SRCREG2 <= "0"&INSTRUCTION(7 downto 5);
				TARGETREG <= "1111";
				EXTENDIMM(15 downto 5) <= (others => INSTRUCTION(4));
				EXTENDIMM(4 downto 0) <= INSTRUCTION(4 downto 0);
				ALUOP <= ALUOP_ADD;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '1';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when SW_SP => --SW_SP
				SRCREG1 <= "1001";
				SRCREG2 <= "0"&INSTRUCTION(10 downto 8);
				TARGETREG <= "1111";
				EXTENDIMM(15 downto 8) <= (others => INSTRUCTION(7));
				EXTENDIMM(7 downto 0) <= INSTRUCTION(7 downto 0);
				ALUOP <= ALUOP_ADD;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '1';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

			when others =>
				SRCREG1 <= "1000";
				SRCREG2 <= "1000";
				TARGETREG <= "1111";
				EXTENDIMM <= (others => '0');
				ALUOP <= ALUOP_EMPTY;
				ALUSRCA <= "00";
				ALUSRCB <= '0';
				MEMTOREG <= '0';
				REGWRITE <= '0';
				MEMWRITE <= '0';
				BRANCH <= "00";
				JUMP <= '0';
				SOFTINT <= '0';
				SOFTINTNUM <= "0000";

		end case;
	end process;
	
end Behavioral;

