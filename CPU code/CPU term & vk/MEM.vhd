----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:50:02 11/14/2015 
-- Design Name: 
-- Module Name:    MEM - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port ( Ram1Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           Ram1Addr : out  STD_LOGIC_VECTOR (15 downto 0);
           Ram1OE : out  STD_LOGIC;
           Ram1WE : out  STD_LOGIC;
           Ram1EN : out  STD_LOGIC;
           data_ready : in  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
			  uart_data_ready : in STD_LOGIC;
			  uart_tbre : in STD_LOGIC;
			  uart_tsre : in STD_LOGIC;
			  uart_rdn : out STD_LOGIC;
			  uart_wrn : out STD_LOGIC;
           MemData : in  STD_LOGIC_VECTOR (15 downto 0);
           MemAddr : in  STD_LOGIC_VECTOR (15 downto 0);
           OutputData : out  STD_LOGIC_VECTOR (15 downto 0);
           MemWE, MemRE : in  STD_LOGIC;
           IFWE : out  STD_LOGIC;
           IFData : out  STD_LOGIC_VECTOR (15 downto 0);
           IFAddr : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           clk50 : in  STD_LOGIC;
			  debug : out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is
	type status_type is (RamRead, RamWrite, UartRead, UartWrite, UartCheck, KBVGACheck, KBVGARead, KBVGAWrite, Empty);
	signal status, status_debug : status_type := RamRead;
	constant UART_STATUS : std_logic_vector(15 downto 0) := "1011111100000011";  -- BF03
   constant UART_DATA : std_logic_vector(15 downto 0)   := "1011111100000010";  -- BF02
	constant KBVGA_STATUS : std_logic_vector(15 downto 0) := "1011111100000001";  -- BF01
   constant KBVGA_DATA : std_logic_vector(15 downto 0)   := "1011111100000000";  -- BF00
	constant PROG_BEGIN : std_logic_vector(15 downto 0)  := "0100000000000000";  -- 4000
	constant PROG_END : std_logic_vector(15 downto 0)    := "1000000000000000";  -- 8000
	signal debug_tmp : std_logic_vector(15 downto 0) := "0000000000000000";
	
begin

	IFData <= MemData;
	IFAddr <= MemAddr;
	
	debug <= debug_tmp;
	
	process (MemAddr, MemWE, MemRE)
	begin
		if MemWE = '0' and MemRE = '0' then
			IFWE <= '0';
			status <= Empty;
		else
			case MemAddr is 
				when UART_STATUS =>
					status <= UartCheck;
					IFWE <= '0';
				when UART_DATA   =>
					if MemWE = '0' then
						status <= UartRead;
					else
						status <= UartWrite;
					end if;
					IFWE <= '0';
				when KBVGA_STATUS =>
					status <= KBVGACheck;
					IFWE <= '0';
				when KBVGA_DATA =>
					if MemWE = '0' then
						status <= KBVGARead;
					else
						status <= KBVGAWrite;
					end if;
					IFWE <= '0';
				when others =>
					if MemWE = '0' then
						status <= RamRead;
						IFWE <= '0';
					else
						status <= RamWrite;
						if MemAddr(15 downto 14) = "01" then
							IFWE <= '1';
						end if;
					end if;
			end case;
		end if;
	end process;
	
	process (status, MemData, MemAddr)
	begin
		case status is
			when RamRead =>
				Ram1Data <= (others => 'Z');
				Ram1Addr <= MemAddr;
			when RamWrite =>
				Ram1Data <= MemData;
				Ram1Addr <= MemAddr;
			when UartRead =>
				Ram1Data <= (others => 'Z');
				Ram1Addr <= MemAddr;
			when UartWrite =>
				Ram1Data <= MemData;
				Ram1Addr <= MemAddr;
			when UartCheck =>
				Ram1Data(15 downto 2) <= (others => '0');
				Ram1Data(1) <= uart_data_ready;
				Ram1Data(0) <= (uart_tbre and uart_tsre);
			when KBVGARead =>
				Ram1Data <= (others => 'Z');
				Ram1Addr <= MemAddr;
			when KBVGAWrite =>
				Ram1Data <= MemData;
				Ram1Addr <= MemAddr;
			when KBVGACheck =>
				Ram1Data(15 downto 2) <= (others => '0');
				Ram1Data(1) <= data_ready;
				Ram1Data(0) <= (tbre and tsre);
			when others =>
		end case;
	end process;
	
	process (clk)
	begin
		--if clk50'event and clk50 = '0' then
			if clk = '0' then
				case status is
					when RamRead =>
						Ram1EN <= '0';
						Ram1OE <= '0';
						Ram1WE <= '1';
						rdn <= '1';
						wrn <= '1';
						uart_rdn <= '1';
						uart_wrn <= '1';
					when RamWrite =>
						Ram1EN <= '0';
						Ram1OE <= '1';
						Ram1WE <= '0';
						rdn <= '1';
						wrn <= '1';
						uart_rdn <= '1';
						uart_wrn <= '1';
					when KBVGARead =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						Ram1WE <= '1';
						rdn <= '0';
						wrn <= '1';
						uart_rdn <= '1';
						uart_wrn <= '1';
					when KBVGAWrite =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						Ram1WE <= '1';
						rdn <= '1';
						wrn <= '0';
						uart_rdn <= '1';
						uart_wrn <= '1';
					when UartRead =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						Ram1WE <= '1';
						rdn <= '1';
						wrn <= '1';
						uart_rdn <= '0';
						uart_wrn <= '1';
					when UartWrite =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						Ram1WE <= '1';
						rdn <= '1';
						wrn <= '1';
						uart_rdn <= '1';
						uart_wrn <= '0';
					when others =>
						Ram1EN <= '1';
						Ram1OE <= '1';
						Ram1WE <= '1';
						rdn <= '1';
						wrn <= '1';
						uart_rdn <= '1';
						uart_wrn <= '1';
				end case;
			else
				Ram1EN <= '1';
				Ram1OE <= '1';
				Ram1WE <= '1';
				rdn <= '1';
				wrn <= '1';
				uart_rdn <= '1';
				uart_wrn <= '1';
--				if MemAddr = UART_STATUS then
--					OutputData(15 downto 2) <= (others => '0');
--					OutputData(1) <= data_ready;
--					OutputData(0) <= (tbre and tsre);
--				else
--					OutputData <= Ram1Data;
--				end if;
			end if;
--		end if;
	end process;
	
end Behavioral;

