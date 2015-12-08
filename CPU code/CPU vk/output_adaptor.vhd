----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:49:20 11/24/2015 
-- Design Name: 
-- Module Name:    output_controller - Behavioral 
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

entity output_adaptor is
    Port ( clk50 : in  STD_LOGIC;
           CPUData : in  STD_LOGIC_VECTOR (15 downto 0);
           KBData : in  STD_LOGIC_VECTOR (15 downto 0);
           CPUwrn : in  STD_LOGIC;
           CPUtsre : out  STD_LOGIC;
           KBdata_ready : in  STD_LOGIC;
           KBrdn : out  STD_LOGIC;
           DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           data_ready : out  STD_LOGIC;
           rdn : in  STD_LOGIC);
end output_adaptor;

architecture Behavioral of output_adaptor is
	
	type status_type is (start, CPU, KB);
	signal status : status_type := start;
	signal data : std_logic_vector(15 downto 0);
	
begin

	DataOut <= data;

	process (clk50, CPUwrn, KBdata_ready, rdn)
	begin
		if status = start and CPUwrn = '0' then
			status <= CPU;
			data <= CPUData;
			CPUtsre <= '0';
		elsif status = start and KBdata_ready = '1' then
			status <= KB;
			data <= KBData;
			KBrdn <= '0';
		elsif rdn = '0' then
			data_ready <= '0';
			status <= start;
		elsif clk50'event and clk50 = '1' then
			case status is
				when start =>
					CPUtsre <= '1';
					KBrdn <= '1';
					data_ready <= '0';
				when CPU =>
					data_ready <= '1';
				when KB =>
					data_ready <= '1';
			end case;
		end if;
	end process;

end Behavioral;

