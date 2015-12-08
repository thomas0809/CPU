library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegisterCluster is
    PORT ( clk :  in STD_LOGIC;
			  rst : in STD_LOGIC;
           SRCREG1 :  in STD_LOGIC_VECTOR (3 downto 0);
           SRCREG2 :  in STD_LOGIC_VECTOR (3 downto 0);
           TARGETREG : in  STD_LOGIC_VECTOR (3 downto 0);
           REGWRITE :  in STD_LOGIC;
           WRITEDATA : in STD_LOGIC_VECTOR(15 downto 0);
           REGDATA1 : out STD_LOGIC_VECTOR (15 downto 0);
           REGDATA2 : out STD_LOGIC_VECTOR (15 downto 0);
			  
			  debug : out STD_LOGIC_VECTOR (15 downto 0)
         );

end RegisterCluster;

architecture Behavioral of RegisterCluster is
	type registers is array (integer range 0 to 15) of std_logic_vector(15 downto 0);
 	signal regs : registers;
begin
	REGDATA1 <= regs(CONV_INTEGER(SRCREG1));
	REGDATA2 <= regs(CONV_INTEGER(SRCREG2));
	
	debug <= regs(6);

	process(clk, rst)
	begin
		if rst = '0' then
			for i in 0 to 15 loop
				regs(i) <= (others => '0');
			end loop;
			regs(9) <= "1011111100010000";

		elsif clk'event and clk = '0' then
			if REGWRITE = '1' then
				regs(CONV_INTEGER(TARGETREG)) <= WRITEDATA;
			end if;
		end if;
	end process;
end Behavioral;


	