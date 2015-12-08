----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:16:43 11/23/2015 
-- Design Name: 
-- Module Name:    vga_controller - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller is
    Port ( clk50 : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
		   hs, vs : out std_logic;
		   r, g, b : out std_logic_vector(2 downto 0);
		   debugrow, debugcolumn : out integer range 0 to 63);
end vga_controller;

architecture Behavioral of vga_controller is

	COMPONENT ram
		PORT (
			clka : IN STD_LOGIC;
			wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			clkb : IN STD_LOGIC;
			web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
			dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT vga
		Port (
			clk50 : in  STD_LOGIC;
			rst : in  STD_LOGIC;
			hs : out  STD_LOGIC;
			vs : out  STD_LOGIC;
			r : out  STD_LOGIC_VECTOR (2 downto 0);
			g : out  STD_LOGIC_VECTOR (2 downto 0);
			b : out  STD_LOGIC_VECTOR (2 downto 0);
			row : out  STD_LOGIC_VECTOR (4 downto 0);
			column : out  STD_LOGIC_VECTOR (6 downto 0);
			data : in  STD_LOGIC_VECTOR (7 downto 0);
			data_ready : in std_logic
		);
	end COMPONENT;

	signal ramwe : std_logic_vector(0 downto 0) := "0";
	signal writeaddr, readaddr : std_logic_vector(11 downto 0);
	signal writedata, readdata : std_logic_vector(15 downto 0);
	signal readrow : std_logic_vector(4 downto 0);
	signal readcolumn : std_logic_vector(6 downto 0);
	signal vgadata : std_logic_vector(7 downto 0);

	type status_type is (step0, step1, step2);
	signal status : status_type;
	
	type int_array_32 is array(0 to 31) of integer range 0 to 63;
	signal rowlen : int_array_32 := (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
	signal row, column : integer range 0 to 63 := 0;
	signal offset : integer range 0 to 63 := 0;
	signal has_offset : std_logic := '0';
	
	signal clkcnt : std_logic_vector(25 downto 0);

begin

	process (clk50)
	begin
		if clk50'event and clk50 = '1' then
			clkcnt <= clkcnt + 1;
		end if;
	end process;

	myram : ram
	PORT MAP (
		clka => clk50,
		wea => ramwe,
		addra => writeaddr,
		dina => writedata,
		--douta => douta,
		clkb => clk50,
		web => "0",
		addrb => readaddr,
		dinb => (others => '0'),
		doutb => readdata
	);
	
	myvga : vga
	PORT MAP (
		clk50 => clk50,
		rst => rst,
		hs => hs,
		vs => vs,
		r => r,
		g => g,
		b => b,
		row => readrow,
		column => readcolumn,
		data => vgadata,
		data_ready => data_ready
	);
	
	process (readrow, readcolumn, readdata)
		variable x, y : integer range 0 to 127 := 0;
	begin
		x := conv_integer(readrow) + offset;
		if x >= 30 then
			x := x - 30;
		end if;
		y := conv_integer(readcolumn);
		if x = row and y = rowlen(x) then
			readaddr <= (others => '0');
			if clkcnt(25) = '0' then
				vgadata <= "00000000";
			else
				vgadata <= "01111111";
			end if;
		elsif y >= rowlen(x) then
			readaddr <= (others => '0');
			vgadata <= "00000000";
		else
			readaddr <= conv_std_logic_vector(x, 5) & conv_std_logic_vector(y, 7);
			vgadata <= readdata(7 downto 0);
		end if;
	end process;
	
	process (rst, clk50)
	begin
		if rst = '0' then
			row <= 0;
			column <= 0;
			offset <= 0;
			has_offset <= '0';
		elsif clk50'event and clk50 = '1' then
			case status is
				when step0 =>
					ramwe <= "0";
					rdn <= '1';
					if data_ready = '1' then
						status <= step1;
						rdn <= '0';
					end if;
				when step1 =>
					status <= step2;
					ramwe <= "0";
					rdn <= '0';
					writeaddr <= conv_std_logic_vector(row, 5) 
								& conv_std_logic_vector(column, 7);
					writedata <= DataIn;
					if DataIn(7 downto 0) = "00001000" then
						if column /= 0 then
							column <= column - 1;
							rowlen(row) <= rowlen(row) - 1;
						end if;
					else
						if DataIn (7 downto 0) /= "00000000" then
							column <= column + 1;
							rowlen(row) <= rowlen(row) + 1;
							if column = 88 or DataIn(7 downto 0) = "00001010" then
								column <= 0;
								if row = 29 then
									row <= 0;
									has_offset <= '1';
									offset <= 1;
									rowlen(0) <= 0;
								else
									row <= row + 1;
									rowlen(row + 1) <= 0;
								end if;
								if has_offset = '1' then
									if offset = 29 then 
										offset <= 0;
									else
										offset <= offset + 1;
									end if;
								end if;
							end if;
						end if;
					end if;	
				when step2 =>
					status <= step0;
					ramwe <= "1";
					rdn <= '1';
			end case;
		end if;
	end process;
	
	debugrow <= row;
	debugcolumn <= column;

end Behavioral;

