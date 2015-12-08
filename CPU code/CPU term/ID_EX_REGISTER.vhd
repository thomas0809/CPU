library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constdef.ALL;

entity ID_EX_REGISTER is
	PORT ( clk :  in STD_LOGIC;
		   rst :  in STD_LOGIC;
		   
		   CONTROLSTOP :  in STD_LOGIC;
		   IN_MEMTOREG :  in STD_LOGIC;
		   IN_REGWRITE :  in STD_LOGIC;
		   IN_MEMWRITE :  in STD_LOGIC;
		   IN_ALUSRCA :  in STD_LOGIC_VECTOR(1 downto 0);
		   IN_ALUSRCB :  in STD_LOGIC;
		   IN_ALUOP :  in STD_LOGIC_VECTOR(3 downto 0);
		   IN_FORWARDA :  in STD_LOGIC_VECTOR(1 downto 0);
		   IN_FORWARDB :  in STD_LOGIC_VECTOR(1 downto 0);
		   IN_EXTENDIMM :  in STD_LOGIC_VECTOR(15 downto 0);
		   IN_TARGETREG :  in STD_LOGIC_VECTOR(3 downto 0);
		   IN_REGDATA1 :  in STD_LOGIC_VECTOR(15 downto 0);
		   IN_REGDATA2 :  in STD_LOGIC_VECTOR(15 downto 0);
		   IN_PC :  in STD_LOGIC_VECTOR(15 downto 0);

		   OUT_MEMTOREG :  out STD_LOGIC;
		   OUT_REGWRITE :  out STD_LOGIC;
		   OUT_MEMWRITE :  out STD_LOGIC;
		   OUT_ALUSRCA :  out STD_LOGIC_VECTOR(1 downto 0);
		   OUT_ALUSRCB :  out STD_LOGIC;
		   OUT_ALUOP :  out STD_LOGIC_VECTOR(3 downto 0);
		   OUT_FORWARDA :  out STD_LOGIC_VECTOR(1 downto 0);
		   OUT_FORWARDB :  out STD_LOGIC_VECTOR(1 downto 0);
		   OUT_EXTENDIMM :  out STD_LOGIC_VECTOR(15 downto 0);
		   OUT_TARGETREG :  out STD_LOGIC_VECTOR(3 downto 0);
		   OUT_REGDATA1 :  out STD_LOGIC_VECTOR(15 downto 0);
		   OUT_REGDATA2 :  out STD_LOGIC_VECTOR(15 downto 0);
		   OUT_PC :  out STD_LOGIC_VECTOR(15 downto 0);
			
			debug_target : out std_logic_vector(3 downto 0);
			IN_IR : in std_logic_vector(15 downto 0);
			debug_IR : out std_logic_vector(15 downto 0);
			debug_PC : out std_logic_vector(15 downto 0);
			debug_WB : out std_logic
	       );
end ID_EX_REGISTER;

architecture Behavioral of ID_EX_REGISTER is
	signal debug_cnt : integer := 0;
begin
	process(clk, rst)
	begin
		if rst = '0' then
			OUT_MEMWRITE <= '0';
			OUT_REGWRITE <= '0';
			OUT_MEMTOREG <= '0';
			OUT_ALUOP <= ALUOP_EMPTY;
		elsif clk'event and clk = '1' then
			if CONTROLSTOP = '1' then
				OUT_MEMWRITE <= '0';
				OUT_REGWRITE <= '0';
				OUT_MEMTOREG <= '0';
				OUT_ALUOP <= ALUOP_EMPTY;
			else
				OUT_MEMTOREG <= IN_MEMTOREG;
				OUT_REGWRITE <= IN_REGWRITE;
				OUT_MEMWRITE <= IN_MEMWRITE;
				OUT_ALUOP <= IN_ALUOP;
			end if;
			OUT_ALUSRCA <= IN_ALUSRCA;
			OUT_ALUSRCB <= IN_ALUSRCB;
			OUT_FORWARDA <= IN_FORWARDA;
			OUT_FORWARDB <= IN_FORWARDB;
			OUT_EXTENDIMM <= IN_EXTENDIMM;
			OUT_TARGETREG <= IN_TARGETREG;
			OUT_REGDATA1 <= IN_REGDATA1;
			OUT_REGDATA2 <= IN_REGDATA2;
			OUT_PC <= IN_PC;
			
--			if IN_REGWRITE = '1' then
--				if debug_cnt = 0 then
--					debug_target <= IN_TARGETREG;
--					debug_IR <= IN_IR;
--					debug_PC <= IN_PC;
--				end if;
--				debug_cnt <= debug_cnt + 1;
--			end if;
			if IN_PC = "0000000000000100" then
				debug_target <= IN_TARGETREG;
				debug_IR <= IN_IR;
				debug_PC <= IN_PC;
				debug_WB <= IN_REGWRITE;
			end if;
		end if;
	end process;
	
end Behavioral;
