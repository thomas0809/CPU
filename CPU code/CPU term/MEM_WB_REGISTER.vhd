library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_WB_REGISTER is
	PORT ( clk :  in STD_LOGIC;
		   rst :  in STD_LOGIC;
		   
		   IN_REGWRITE :  in STD_LOGIC;
		   IN_MEMTOREG :  in STD_LOGIC;
		   ALURES :  in STD_LOGIC_VECTOR(15 downto 0);
		   IN_TARGETREG :  in STD_LOGIC_VECTOR(3 downto 0);
		   READDATA :  in STD_LOGIC_VECTOR(15 downto 0);

		   OUT_REGWRITE :  out STD_LOGIC;
		   OUT_TARGETREG :  out STD_LOGIC_VECTOR(3 downto 0);
		   WRITEDATA :  out STD_LOGIC_VECTOR(15 downto 0)
	       );
end MEM_WB_REGISTER;

architecture Behavioral of MEM_WB_REGISTER is
	signal Select_data : STD_LOGIC_VECTOR(15 downto 0);
begin
	process(READDATA, ALURES, IN_MEMTOREG)
	begin
		if IN_MEMTOREG = '1' then
			Select_data <= READDATA;
		else
			Select_data <= ALURES;
		end if;
	end process;

	process(clk, rst)
	begin
		if rst = '0' then
			OUT_REGWRITE <= '0';
		elsif clk'event and clk = '1' then
			OUT_REGWRITE <= IN_REGWRITE;
			OUT_TARGETREG <= IN_TARGETREG;
			WRITEDATA <= Select_data;
		end if;
	end process;

end Behavioral;
