library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_MEM_REGISTER is
	PORT (clk :  in STD_LOGIC;
			IN_MEMTOREG :  in STD_LOGIC;
		   IN_REGWRITE :  in STD_LOGIC;
		   IN_MEMWRITE :  in STD_LOGIC;
		   IN_ALURES :  in STD_LOGIC_VECTOR(15 downto 0);
		   IN_REGDATA :  in STD_LOGIC_VECTOR(15 downto 0);
		   IN_TARGETREG :  in STD_LOGIC_VECTOR(3 downto 0);

		   OUT_MEMTOREG :  out STD_LOGIC;
		   OUT_REGWRITE :  out STD_LOGIC;
		   OUT_MEMWRITE :  out STD_LOGIC;
		   OUT_ALURES :  out STD_LOGIC_VECTOR(15 downto 0);
		   OUT_REGDATA :  out STD_LOGIC_VECTOR(15 downto 0);
		   OUT_TARGETREG :  out STD_LOGIC_VECTOR(3 downto 0);
			debug : out STD_LOGIC_VECTOR(15 downto 0)
	       );

end EX_MEM_REGISTER;

architecture Behavioral of EX_MEM_REGISTER is

begin
	process(clk)
	begin
		if clk'event and clk = '1' then
			OUT_MEMTOREG <= IN_MEMTOREG;
			OUT_REGWRITE <= IN_REGWRITE;
			OUT_MEMWRITE <= IN_MEMWRITE;
			OUT_ALURES <= IN_ALURES;
			OUT_REGDATA <= IN_REGDATA;
			OUT_TARGETREG <= IN_TARGETREG;
			
			if IN_MEMWRITE = '1' then
				debug <= IN_REGDATA;
			end if;
		end if;
	end process;

end Behavioral;
