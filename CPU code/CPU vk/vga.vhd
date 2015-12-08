----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:23:21 11/23/2015 
-- Design Name: 
-- Module Name:    vga - Behavioral 
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
use work.data_type.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga is
    Port ( clk50 : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (2 downto 0);
           g : out  STD_LOGIC_VECTOR (2 downto 0);
           b : out  STD_LOGIC_VECTOR (2 downto 0);
           row : out  STD_LOGIC_VECTOR (4 downto 0);
           column : out  STD_LOGIC_VECTOR (6 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0);
		   data_ready : in std_logic);
end vga;

architecture Behavioral of vga is

	COMPONENT rom
		PORT (
			clka : IN STD_LOGIC;
			addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT;
	
	component vga_core_ball is
		port(
			reset       :         in  STD_LOGIC;
			clk         :		  in std_logic;  --25M时钟输入
			vector_x    :         in std_logic_vector(9 downto 0);
			vector_y    :         in std_logic_vector(9 downto 0);
			r,g,b       :         out STD_LOGIC_vector(2 downto 0);
			num_c       :         in integer range 0 to 100;
			theta_c     :         in int_array;
			mtime       :         in integer range 0 to 1000
		);
	end component;

	signal clk25 : std_logic;
	signal vector_x : std_logic_vector(9 downto 0);		--X坐标
	signal vector_y : std_logic_vector(9 downto 0);		--Y坐标
	signal r1,g1,b1 : std_logic_vector(2 downto 0);					
	signal hs1,vs1  : std_logic;
	signal romdata  : std_logic_vector(3 downto 0);
	signal romaddr  : std_logic_vector(13 downto 0);
	signal r2,g2,b2 : std_logic_vector(2 downto 0);					
	signal rest_tag : std_logic := '0';
	signal rest_cnt : std_logic_vector(30 downto 0);
	signal theta : int_array := (0, 90, 180, 270, 360, 450, 540, 630);
	signal mtime : integer range 0 to 1000 := 0;
	signal mtime_cnt : std_logic_vector(19 downto 0);
	
begin

	myrom : rom
	PORT MAP (
		clka => clk50,
		addra => romaddr,
		douta => romdata
	);
	
	myvga_core_ball : vga_core_ball
	port map (
		reset    => rst,
		clk      => clk25,
		vector_x => vector_x,
		vector_y => vector_y,
		r        => r2,
		g	      => g2,
		b	      => b2,
		num_c    => 8,
		theta_c  => theta,
		mtime    => mtime
	);
	
	process(rst, clk50, data_ready)
	begin
		if rst = '0' or data_ready = '1' then
			rest_tag <= '0';
			rest_cnt <= (others => '0');
		elsif clk50'event and clk50 = '1' then
			if rest_tag = '0' then
				rest_cnt <= rest_cnt + 1;
				if rest_cnt(28) = '1' then
					rest_tag <= '1';
				end if;
			end if;
			mtime_cnt <= mtime_cnt + 1;
			if mtime_cnt = "11111111111111111111" then
				if mtime < 720 then
					mtime <= mtime + 1;
				else
					mtime <= 0;
				end if;
			end if;
		end if;
	end process;
	
	romaddr <= data(6 downto 0) & vector_y(3 downto 0) & vector_x(2 downto 0);
	row <= vector_y(8 downto 4);
	column <= vector_x(9 downto 3);

	process(clk50)
	begin
		if clk50'event and clk50 = '1' then
			clk25 <= not clk25;
		end if;
	end process;
	
	process(clk25, rst)	--行区间像素数（含消隐区）
	begin
	  	if rst='0' then
	   		vector_x <= (others=>'0');
	  	elsif clk25'event and clk25='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	end process;
	
	process(clk25, rst)	--场区间行数（含消隐区）
	begin
	  	if rst='0' then
	   		vector_y <= (others=>'0');
	  	elsif clk25'event and clk25='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	end process;
	
	process(clk25, rst) --行同步信号产生（同步宽度96，前沿16）
	begin
		if rst='0' then
			hs1 <= '1';
		elsif clk25'event and clk25='1' then
		   	if vector_x>=656 and vector_x<752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	end process;
	
	process(clk25, rst) --场同步信号产生（同步宽度2，前沿10）
	begin
	  	if rst='0' then
	   		vs1 <= '1';
	  	elsif clk25'event and clk25='1' then
	   		if vector_y>=490 and vector_y<492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	end process;
	
	process(clk25, rst) --行同步信号输出
	begin
	  	if rst='0' then
	   		hs <= '0';
	  	elsif clk25'event and clk25='1' then
			hs <= hs1;
	  	end if;
	end process;
	
	process(clk25, rst) --场同步信号输出
	begin
	 	if rst='0' then
	  		vs <= '0';
	 	elsif clk25'event and clk25='1' then
			vs <= vs1;
	  	end if;
	end process;
	
	process (hs1, vs1, r1, g1, b1, r2, g2, b2, vector_x, vector_y)	--色彩输出
	begin
		if hs1 = '1' and vs1 = '1' and vector_x >= 2 and vector_x <= 638
		and vector_y >= 2 and vector_y <= 478 then
			if rest_tag = '0' then
				if vector_x(2 downto 0) /= "000" then
					r <= r1;
					g <= g1;
					b <= b1;
				else
					r <= "000";
					g <= "000";
					b <= "000";
				end if;
			else
				r <= r2;
				g <= g2;
				b <= b2;
			end if;
		else
			r <= (others => '0');
			g <= (others => '0');
			b <= (others => '0');
		end if;
	end process;
	
	process (rst, clk25) -- XY坐标定位控制
	begin
		if rst = '0' then
			r1 <= "000";
			g1 <= "000";
			b1 <= "000";	
		elsif clk25'event and clk25 = '1' then
			r1 <= romdata(2 downto 0);
			g1 <= romdata(2 downto 0);
			b1 <= romdata(2 downto 0);
		end if;
	end process;
	
end Behavioral;

