----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:47:41 11/22/2015 
-- Design Name: 
-- Module Name:    keyboardmachine - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keyboardCpuRam is
    Port ( clk50		  : in std_logic;								--50M时钟
			  rst			  : in std_logic;								--初始化
			  KeyBoardData: in std_logic_vector(7 downto 0);	--键盘输入到状态机的数据
			  DataReady   : in std_logic;								--键盘输入至状态机的通知
			  CpuDataReady: out std_logic;							--状态机输入到主机
			  DataPath : inout std_logic_vector(7 downto 0);--主机和状态机之间的数据线
			  CpuRdn		  : in std_logic;								--主机给状态机的通知
			  CpuWrn      : in std_logic;	  --主机给状态机的通知
			  CpuEnable	  :  in std_logic;							--主机给状态机是否能写
			  RamData     : out std_logic_vector(7 downto 0);  --acsii给ram
			  RamDataReady: out std_logic;						--dataready给ram
			  RamRdn		  : in std_logic;								--ram给状态机的通知
			  KeyboardInterrupt   : in std_logic;					--键盘中断输入
			  IFIDInterrupt		 : out std_logic;					--状态机给主机中断
			  checkbufferState    : out std_logic_vector(6 downto 0);				--缓存区状态
			  checkState			 : out std_logic_vector(6 downto 0);					--输出状态机状态
			  testData				 : out std_logic_vector(7 downto 0);
			  shiftstate : in std_logic;
			  ctrlstate : in std_logic
			  );
end keyboardCpuRam;



architecture Behavioral of keyboardCpuRam is
	--键盘编码
	component compiler
	Port (  sendbuffer : in  STD_LOGIC_VECTOR(159 downto 0);						--keyboarddata
           instruc : out STD_LOGIC_VECTOR(15 downto 0)
	  );
	end component;
	
	constant ACODE : std_logic_vector(7 downto 0) := "00011100";
	constant BCODE : std_logic_vector(7 downto 0) := "00110010";
	constant CCODE : std_logic_vector(7 downto 0) := "00100001";
	constant DCODE : std_logic_vector(7 downto 0) := "00100011";
	constant ECODE : std_logic_vector(7 downto 0) := "00100100";
	constant FCODE : std_logic_vector(7 downto 0) := "00101011";
	constant GCODE : std_logic_vector(7 downto 0) := "00110100";
	constant HCODE : std_logic_vector(7 downto 0) := "00110011";
	constant ICODE : std_logic_vector(7 downto 0) := "01000011";
	constant JCODE : std_logic_vector(7 downto 0) := "00111011";
	constant KCODE : std_logic_vector(7 downto 0) := "01000010";
	constant LCODE : std_logic_vector(7 downto 0) := "01001011";
	constant MCODE : std_logic_vector(7 downto 0) := "00111010";
	constant NCODE : std_logic_vector(7 downto 0) := "00110001";
	constant OCODE : std_logic_vector(7 downto 0) := "01000100";
	constant PCODE : std_logic_vector(7 downto 0) := "01001101";
	constant QCODE : std_logic_vector(7 downto 0) := "00010101";
	constant RCODE : std_logic_vector(7 downto 0) := "00101101";
	constant SCODE : std_logic_vector(7 downto 0) := "00011011";
	constant TCODE : std_logic_vector(7 downto 0) := "00101100";
	constant UCODE : std_logic_vector(7 downto 0) := "00111100";
	constant VCODE : std_logic_vector(7 downto 0) := "00101010";
	constant WCODE : std_logic_vector(7 downto 0) := "00011101";
	constant XCODE : std_logic_vector(7 downto 0) := "00100010";
	constant YCODE : std_logic_vector(7 downto 0) := "00110101";
	constant ZCODE : std_logic_vector(7 downto 0) := "00011010";
	constant ZEROCODE : std_logic_vector(7 downto 0) := "01000101";
	constant ONECODE : std_logic_vector(7 downto 0) := "00010110";
	constant TWOCODE : std_logic_vector(7 downto 0) := "00011110";
	constant THREECODE : std_logic_vector(7 downto 0) := "00100110";
	constant FOURCODE : std_logic_vector(7 downto 0) := "00100101";
	constant FIVECODE : std_logic_vector(7 downto 0) := "00101110";
	constant SIXCODE : std_logic_vector(7 downto 0) := "00110110";
	constant SEVENCODE : std_logic_vector(7 downto 0) := "00111101";
	constant EIGHTCODE : std_logic_vector(7 downto 0) := "00111110";
	constant NINECODE : std_logic_vector(7 downto 0) := "01000110";
	constant LINECODE : std_logic_vector(7 downto 0) := "01001110";
	constant BKSPCODE : std_logic_vector(7 downto 0) := "01100110";
	constant ENTERCODE : std_logic_vector(7 downto 0) := "01011010";
	constant SPACECODE : std_logic_vector(7 downto 0) := "00101001";
	constant LEFTBIGCODE: std_logic_vector(7 downto 0) := "01010100";	--[
	constant RIGHTBIGCODE: std_logic_vector(7 downto 0) := "01011011";	--]
	constant COLONCODE: std_logic_vector(7 downto 0) := "01001100";	--:
	constant MARKCODE: std_logic_vector(7 downto 0) := "01010010";	--"
	constant DOUHAOCODE: std_logic_vector(7 downto 0) := "01000001";		--,
	constant DIANCODE: std_logic_vector(7 downto 0) := "01001001";	--.
	constant WENHAOCODE : std_logic_vector(7 downto 0) := "01001010";	--/
	constant JIAHAOCODE : std_logic_vector(7 downto 0) := "01010101";	--+
	constant SHUXIANCODE : std_logic_vector(7 downto 0) := "01011101";	--\
	
	
	type state_type is (main, A, U, D, R, G, a0, a1, a2, a3, a4, a5, g0, g1, g2, g3, r0, u0 ,u1, 
								u2, u3, u4, u5, d0, d1, d2, d3, d4, d5, aerror1, aerror2, error1);
	type buffer_state_type is (b0, b1);	
	signal CpuDataPath : std_logic_vector(7 downto 0);
	signal RamDataPath : std_logic_vector(7 downto 0);
	signal RamDataOut : std_logic_vector(7 downto 0);
	signal buffer_status : buffer_state_type := b0;
	signal term_status : state_type := main;						--起始状态为main
	signal SendBuffer : std_logic_vector(159 downto 0) := (others=> '0');		--发送数据缓存区
	signal BufferWriteNumber : integer range 0 to 160 := 0;	--当前缓存区写入位置
	signal getData		: std_logic_vector(7 downto 0);			--接受处理数据
	signal Buffer_init : std_logic := '0';
	signal tempRdn		: std_logic := '0';
	signal writeAddress : std_logic_vector(15 downto 0) := "0100000000000000";
	signal writeData : std_logic_vector(15 downto 0) := "0000000000000000";
	signal GAddress : std_logic_vector(15 downto 0) := "0100000000000000";	--U
	signal tempDataRdn : std_logic := '0';
begin

	mycompiler :
		compiler port map (
			sendbuffer => SendBuffer,
			instruc => writeData
		);
			
--中断传给上层--
IFIDInterrupt <= KeyboardInterrupt;

--对键盘输入进行处理--每有一个输入将数据存入缓存区，getData存刚刚传入的值
process (DataReady, Buffer_init)
begin
	if (Buffer_init = '1' and buffer_status = b1)then
		buffer_status <= b0;
		BufferWriteNumber <= 0;
		SendBuffer <= (others => '0');
	elsif (DataReady'event and DataReady = '0') then
		---getData <= KeyBoardData;					--存入刚刚传入的值
		--testData <= SendBuffer(7 downto 0);
		case buffer_status is
			when b0 =>
					if (KeyBoardData = BKSPCODE) then
							if (BufferWriteNumber > 0) then
								SendBuffer(BufferWriteNumber downto BufferWriteNumber - 7) <= "00000000";
								BufferWriteNumber <= BufferWriteNumber - 8;
								buffer_status <= b0;
							end if;
					elsif (KeyBoardData /= ENTERCODE) then
							SendBuffer(BufferWriteNumber + 7 downto BufferWriteNumber) <= KeyBoardData(7 downto 0);--缓存区
							BufferWriteNumber <= BufferWriteNumber + 8;
							buffer_status <= b0;
					else
							buffer_status <= b1;
					end if;	
			when others =>
		end case;
	end if;
end process;
--将键盘数据转化为ascii码发给ram---
process (clk50)
begin
	if (clk50'event and clk50 = '0') then
		 case KeyBoardData(7 downto 0) is
			  when ACODE 			=> RamDataOut <= "01000001";
			  when BCODE 			=> RamDataOut <= "01000010";
			  when CCODE 			=> RamDataOut <= "01000011";
			  when DCODE 			=> RamDataOut <= "01000100";
			  when ECODE 			=> RamDataOut <= "01000101";
			  when FCODE 			=> RamDataOut <= "01000110";
			  when GCODE 			=> RamDataOut <= "01000111";
			  when HCODE 			=> RamDataOut <= "01001000";
			  when ICODE 			=> RamDataOut <= "01001001";
			  when JCODE 			=> RamDataOut <= "01001010";
			  when KCODE 			=> RamDataOut <= "01001011";
			  when LCODE 			=> RamDataOut <= "01001100";
			  when MCODE 			=> RamDataOut <= "01001101";
			  when NCODE 			=> RamDataOut <= "01001110";
			  when OCODE 			=> RamDataOut <= "01001111";
			  when PCODE 			=> RamDataOut <= "01010000";
			  when QCODE 			=> RamDataOut <= "01010001";
			  when RCODE 			=> RamDataOut <= "01010010";
			  when SCODE 			=> RamDataOut <= "01010011";
			  when TCODE 			=> RamDataOut <= "01010100";
			  when UCODE 			=> RamDataOut <= "01010101";
			  when VCODE 			=> RamDataOut <= "01010110";
			  when WCODE 			=> RamDataOut <= "01010111";
			  when XCODE 			=> RamDataOut <= "01011000";
			  when YCODE 			=> RamDataOut <= "01011001";
			  when ZCODE 			=> RamDataOut <= "01011010";
			  when ZEROCODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110000";
											else
												RamDataOut <= "00101001";
											end if;
			  when ONECODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110001";
											else
												RamDataOut <= "00100001";
											end if;
			  when TWOCODE			=> if shiftstate = '0' then 
												RamDataOut <= "00110010";
											else
												RamDataOut <= "01000000";
											end if;
			  when THREECODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110011";
											else
												RamDataOut <= "00100011";
											end if;
			  when FOURCODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110100";
											else
												RamDataOut <= "00100100";
											end if;
			  when FIVECODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110101";
											else
												RamDataOut <= "00100101";
											end if;
			  when SIXCODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110110";
											else
												RamDataOut <= "01011110";
											end if;
			  when SEVENCODE 		=> if shiftstate = '0' then
												RamDataOut <= "00110111";
											else
												RamDataOut <= "00100110";
											end if;
			  when EIGHTCODE 		=> if shiftstate = '0' then
												RamDataOut <= "00111000";
											else
												RamDataOut <= "00101010";
											end if;
			  when NINECODE 		=> if shiftstate = '0' then
												RamDataOut <= "00111001";
											else
												RamDataOut <= "00101000";
											end if;
			  when LINECODE 		=> if shiftstate = '1' then
												RamDataOut <= "01011111";				--下划线
											else
												RamDataOut <= "00101101";
											end if;
			  when BKSPCODE 		=> if BufferWriteNumber /= 0 then
												RamDataOut <= "00001000";			   --回退 特殊
											else
												RamDataOut <= "00000000";
											end if;
			  when ENTERCODE 		=> RamDataOut <= "00001010";
			  when SPACECODE 		=> RamDataOut <= "00100000";				--空格
			  when LEFTBIGCODE   => if shiftstate = '0' then		
												RamDataOut <= "01011011";						--[
											else
												RamDataOut <= "01111011";
											end if;
			  when RIGHTBIGCODE  => if shiftstate = '0' then		
												RamDataOut <= "01011101";						--]
											else
												RamDataOut <= "01111101";
											end if;
			  when COLONCODE 		=> if shiftstate = '0' then		
												RamDataOut <= "00111011";						--;
											else
												RamDataOut <= "00111010";						--:
											end if;
			  when MARKCODE		=> if shiftstate = '0' then		
												RamDataOut <= "00100111";						--'
											else
												RamDataOut <= "00100010";						--"
											end if;
			  when DOUHAOCODE		=> if shiftstate = '0' then		
												RamDataOut <= "00101100";						--,
											else
												RamDataOut <= "00111100";						--<
											end if;
			  when DIANCODE		=> if shiftstate = '0' then		
												RamDataOut <= "00101110";						--.
											else
												RamDataOut <= "00111110";						-->
											end if;
			  when WENHAOCODE 	=> if shiftstate = '0' then		
												RamDataOut <= "00101111";						--/
											else
												RamDataOut <= "00111111";						--?
											end if;
			  when JIAHAOCODE		 => if shiftstate = '0' then		
												RamDataOut <= "00111101";						--=
											else
												RamDataOut <= "00101011";						--+
											end if;
			  when SHUXIANCODE    => if shiftstate = '0' then
												RamDataOut <= "01011100";						--\
											else
												RamDataOut <= "01111100";						--|
											end if;
			  when others =>
		 end case;
	end if;
end process;

--testData <= SendBuffer(7 downto 0);
process (clk50)
begin
	if (clk50'event and clk50 = '1') then
		 case buffer_status is
				when b0 =>
						checkbufferState <= "0000001";
				when b1 =>
						checkbufferState <= "1111111";
				when others =>
		 end case;
	end if;
end process;
--模拟监控程序变化--
process (clk50, CpuRdn)
begin
	if (CpuRdn = '0') then
		tempRdn <= '0';
		CpuDataReady <= '0';
	elsif clk50'event and clk50 = '1' then
		case term_status is
			when main =>
				checkState <= "1111111";
				buffer_init <= '0';
				if (buffer_status = b1 and BufferWriteNumber = 8 and (SendBuffer(7 downto 0) = ACODE)) then
					term_status <= a0;
					CpuDataPath <= "01000001";					--传65
					writeAddress <= "0100000000000000";		--4000
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber = 8 and (SendBuffer(7 downto 0) = GCODE)) then
					term_status <= g0;
					CpuDataPath <= "01000111";
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber = 8 and (SendBuffer(7 downto 0) = UCODE)) then
					term_status <= u0;
					CpuDataPath <= "01010101";
					GAddress <= "0100000000000000";	--4000
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber = 8 and (SendBuffer(7 downto 0) = DCODE)) then
					term_status <= d0;
					CpuDataPath <= "01000100";
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber = 8 and (SendBuffer(7 downto 0) = RCODE)) then
					term_status <= r0;
					CpuDataPath <= "01010010";
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber = 48 and (SendBuffer(7 downto 0) = ACODE)
					and SendBuffer(15 downto 8) = SPACECODE 
					and (SendBuffer(23 downto 16) = ZEROCODE or SendBuffer(23 downto 16) = ONECODE or SendBuffer(23 downto 16) = TWOCODE or SendBuffer(23 downto 16) = THREECODE
						or SendBuffer(23 downto 16) = FOURCODE or SendBuffer(23 downto 16) = FIVECODE or SendBuffer(23 downto 16) = SIXCODE or SendBuffer(23 downto 16) = SEVENCODE
						or SendBuffer(23 downto 16) = EIGHTCODE or SendBuffer(23 downto 16) = NINECODE or SendBuffer(23 downto 16) = ACODE or SendBuffer(23 downto 16) = BCODE
						or SendBuffer(23 downto 16) = CCODE or SendBuffer(23 downto 16) = DCODE or SendBuffer(23 downto 16) = ECODE or SendBuffer(23 downto 16) = FCODE)
					and (SendBuffer(31 downto 24) = ZEROCODE or SendBuffer(31 downto 24) = ONECODE or SendBuffer(31 downto 24) = TWOCODE or SendBuffer(31 downto 24) = THREECODE
						or SendBuffer(31 downto 24) = FOURCODE or SendBuffer(31 downto 24) = FIVECODE or SendBuffer(31 downto 24) = SIXCODE or SendBuffer(31 downto 24) = SEVENCODE
						or SendBuffer(31 downto 24) = EIGHTCODE or SendBuffer(31 downto 24) = NINECODE or SendBuffer(31 downto 24) = ACODE or SendBuffer(31 downto 24) = BCODE
						or SendBuffer(31 downto 24) = CCODE or SendBuffer(31 downto 24) = DCODE or SendBuffer(31 downto 24) = ECODE or SendBuffer(31 downto 24) = FCODE)
					and (SendBuffer(39 downto 32) = ZEROCODE or SendBuffer(39 downto 32) = ONECODE or SendBuffer(39 downto 32) = TWOCODE or SendBuffer(39 downto 32) = THREECODE
						or SendBuffer(39 downto 32) = FOURCODE or SendBuffer(39 downto 32) = FIVECODE or SendBuffer(39 downto 32) = SIXCODE or SendBuffer(39 downto 32) = SEVENCODE
						or SendBuffer(39 downto 32) = EIGHTCODE or SendBuffer(39 downto 32) = NINECODE or SendBuffer(39 downto 32) = ACODE or SendBuffer(39 downto 32) = BCODE
						or SendBuffer(39 downto 32) = CCODE or SendBuffer(39 downto 32) = DCODE or SendBuffer(39 downto 32) = ECODE or SendBuffer(39 downto 32) = FCODE)
					and (SendBuffer(47 downto 40) = ZEROCODE or SendBuffer(47 downto 40) = ONECODE or SendBuffer(47 downto 40) = TWOCODE or SendBuffer(47 downto 40) = THREECODE
						or SendBuffer(47 downto 40) = FOURCODE or SendBuffer(47 downto 40) = FIVECODE or SendBuffer(47 downto 40) = SIXCODE or SendBuffer(47 downto 40) = SEVENCODE
						or SendBuffer(47 downto 40) = EIGHTCODE or SendBuffer(47 downto 40) = NINECODE or SendBuffer(47 downto 40) = ACODE or SendBuffer(47 downto 40) = BCODE
						or SendBuffer(47 downto 40) = CCODE or SendBuffer(47 downto 40) = DCODE or SendBuffer(47 downto 40) = ECODE or SendBuffer(47 downto 40) = FCODE) 
					) then
					case SendBuffer(23 downto 16) is
						when ZEROCODE		 	=> writeAddress(15 downto 12)	 		<= "0000";
						when ONECODE 		 	=> writeAddress(15 downto 12) 		<= "0001";
						when TWOCODE  			=> writeAddress(15 downto 12) 		<= "0010";
						when THREECODE  		=> writeAddress(15 downto 12)			<= "0011";
						when FOURCODE  		=> writeAddress(15 downto 12) 		<= "0100";
						when FIVECODE  		=> writeAddress(15 downto 12) 		<= "0101";
						when SIXCODE  			=> writeAddress(15 downto 12) 		<= "0110";
						when SEVENCODE  		=> writeAddress(15 downto 12) 		<= "0111";
						when EIGHTCODE  		=> writeAddress(15 downto 12) 		<= "1000";
						when NINECODE  		=> writeAddress(15 downto 12) 		<= "1001";
						when ACODE  			=> writeAddress(15 downto 12) 		<= "1010";
						when BCODE  			=> writeAddress(15 downto 12) 		<= "1011";
						when CCODE  			=> writeAddress(15 downto 12) 		<= "1100";
						when DCODE  			=> writeAddress(15 downto 12) 		<= "1101";
						when ECODE  			=> writeAddress(15 downto 12)			<= "1110";
						when FCODE  			=> writeAddress(15 downto 12) 		<= "1111";
						when others =>
					end case;
					case SendBuffer(31 downto 24) is
						when ZEROCODE		 	=> writeAddress(11 downto 8)	 		<= "0000";
						when ONECODE 		 	=> writeAddress(11 downto 8) 			<= "0001";
						when TWOCODE  			=> writeAddress(11 downto 8) 			<= "0010";
						when THREECODE  		=> writeAddress(11 downto 8)			<= "0011";
						when FOURCODE  		=> writeAddress(11 downto 8) 			<= "0100";
						when FIVECODE  		=> writeAddress(11 downto 8) 			<= "0101";
						when SIXCODE  			=> writeAddress(11 downto 8) 			<= "0110";
						when SEVENCODE  		=> writeAddress(11 downto 8) 			<= "0111";
						when EIGHTCODE  		=> writeAddress(11 downto 8) 			<= "1000";
						when NINECODE  		=> writeAddress(11 downto 8) 			<= "1001";
						when ACODE  			=> writeAddress(11 downto 8) 			<= "1010";
						when BCODE  			=> writeAddress(11 downto 8) 			<= "1011";
						when CCODE  			=> writeAddress(11 downto 8) 			<= "1100";
						when DCODE  			=> writeAddress(11 downto 8) 			<= "1101";
						when ECODE  			=> writeAddress(11 downto 8)			<= "1110";
						when FCODE  			=> writeAddress(11 downto 8) 			<= "1111";
						when others =>
					end case;
					case SendBuffer(39 downto 32) is
						when ZEROCODE		 	=> writeAddress(7 downto 4)	 		<= "0000";
						when ONECODE 		 	=> writeAddress(7 downto 4) 			<= "0001";
						when TWOCODE  			=> writeAddress(7 downto 4) 			<= "0010";
						when THREECODE  		=> writeAddress(7 downto 4)			<= "0011";
						when FOURCODE  		=> writeAddress(7 downto 4) 			<= "0100";
						when FIVECODE  		=> writeAddress(7 downto 4) 			<= "0101";
						when SIXCODE  			=> writeAddress(7 downto 4) 			<= "0110";
						when SEVENCODE  		=> writeAddress(7 downto 4) 			<= "0111";
						when EIGHTCODE  		=> writeAddress(7 downto 4) 			<= "1000";
						when NINECODE  		=> writeAddress(7 downto 4) 			<= "1001";
						when ACODE  			=> writeAddress(7 downto 4) 			<= "1010";
						when BCODE  			=> writeAddress(7 downto 4) 			<= "1011";
						when CCODE  			=> writeAddress(7 downto 4) 			<= "1100";
						when DCODE  			=> writeAddress(7 downto 4) 			<= "1101";
						when ECODE  			=> writeAddress(7 downto 4)			<= "1110";
						when FCODE  			=> writeAddress(7 downto 4) 			<= "1111";
						when others =>
					end case;
					case SendBuffer(47 downto 40) is
						when ZEROCODE		 	=> writeAddress(3 downto 0)	 		<= "0000";
						when ONECODE 		 	=> writeAddress(3 downto 0) 			<= "0001";
						when TWOCODE  			=> writeAddress(3 downto 0) 			<= "0010";
						when THREECODE  		=> writeAddress(3 downto 0)			<= "0011";
						when FOURCODE  		=> writeAddress(3 downto 0) 			<= "0100";
						when FIVECODE  		=> writeAddress(3 downto 0) 			<= "0101";
						when SIXCODE  			=> writeAddress(3 downto 0) 			<= "0110";
						when SEVENCODE  		=> writeAddress(3 downto 0) 			<= "0111";
						when EIGHTCODE  		=> writeAddress(3 downto 0) 			<= "1000";
						when NINECODE  		=> writeAddress(3 downto 0) 			<= "1001";
						when ACODE  			=> writeAddress(3 downto 0) 			<= "1010";
						when BCODE  			=> writeAddress(3 downto 0) 			<= "1011";
						when CCODE  			=> writeAddress(3 downto 0) 			<= "1100";
						when DCODE  			=> writeAddress(3 downto 0) 			<= "1101";
						when ECODE  			=> writeAddress(3 downto 0)			<= "1110";
						when FCODE  			=> writeAddress(3 downto 0) 			<= "1111";
						when others =>
					end case;
					term_status <= a0;
					CpuDataPath <= "01000001";					--传65
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber = 48 and (SendBuffer(7 downto 0) = UCODE)
					and SendBuffer(15 downto 8) = SPACECODE 
					and (SendBuffer(23 downto 16) = ZEROCODE or SendBuffer(23 downto 16) = ONECODE or SendBuffer(23 downto 16) = TWOCODE or SendBuffer(23 downto 16) = THREECODE
						or SendBuffer(23 downto 16) = FOURCODE or SendBuffer(23 downto 16) = FIVECODE or SendBuffer(23 downto 16) = SIXCODE or SendBuffer(23 downto 16) = SEVENCODE
						or SendBuffer(23 downto 16) = EIGHTCODE or SendBuffer(23 downto 16) = NINECODE or SendBuffer(23 downto 16) = ACODE or SendBuffer(23 downto 16) = BCODE
						or SendBuffer(23 downto 16) = CCODE or SendBuffer(23 downto 16) = DCODE or SendBuffer(23 downto 16) = ECODE or SendBuffer(23 downto 16) = FCODE)
					and (SendBuffer(31 downto 24) = ZEROCODE or SendBuffer(31 downto 24) = ONECODE or SendBuffer(31 downto 24) = TWOCODE or SendBuffer(31 downto 24) = THREECODE
						or SendBuffer(31 downto 24) = FOURCODE or SendBuffer(31 downto 24) = FIVECODE or SendBuffer(31 downto 24) = SIXCODE or SendBuffer(31 downto 24) = SEVENCODE
						or SendBuffer(31 downto 24) = EIGHTCODE or SendBuffer(31 downto 24) = NINECODE or SendBuffer(31 downto 24) = ACODE or SendBuffer(31 downto 24) = BCODE
						or SendBuffer(31 downto 24) = CCODE or SendBuffer(31 downto 24) = DCODE or SendBuffer(31 downto 24) = ECODE or SendBuffer(31 downto 24) = FCODE)
					and (SendBuffer(39 downto 32) = ZEROCODE or SendBuffer(39 downto 32) = ONECODE or SendBuffer(39 downto 32) = TWOCODE or SendBuffer(39 downto 32) = THREECODE
						or SendBuffer(39 downto 32) = FOURCODE or SendBuffer(39 downto 32) = FIVECODE or SendBuffer(39 downto 32) = SIXCODE or SendBuffer(39 downto 32) = SEVENCODE
						or SendBuffer(39 downto 32) = EIGHTCODE or SendBuffer(39 downto 32) = NINECODE or SendBuffer(39 downto 32) = ACODE or SendBuffer(39 downto 32) = BCODE
						or SendBuffer(39 downto 32) = CCODE or SendBuffer(39 downto 32) = DCODE or SendBuffer(39 downto 32) = ECODE or SendBuffer(39 downto 32) = FCODE)
					and (SendBuffer(47 downto 40) = ZEROCODE or SendBuffer(47 downto 40) = ONECODE or SendBuffer(47 downto 40) = TWOCODE or SendBuffer(47 downto 40) = THREECODE
						or SendBuffer(47 downto 40) = FOURCODE or SendBuffer(47 downto 40) = FIVECODE or SendBuffer(47 downto 40) = SIXCODE or SendBuffer(47 downto 40) = SEVENCODE
						or SendBuffer(47 downto 40) = EIGHTCODE or SendBuffer(47 downto 40) = NINECODE or SendBuffer(47 downto 40) = ACODE or SendBuffer(47 downto 40) = BCODE
						or SendBuffer(47 downto 40) = CCODE or SendBuffer(47 downto 40) = DCODE or SendBuffer(47 downto 40) = ECODE or SendBuffer(47 downto 40) = FCODE) 
					) then
					case SendBuffer(23 downto 16) is
						when ZEROCODE		 	=> GAddress(15 downto 12)	 		<= "0000";
						when ONECODE 		 	=> GAddress(15 downto 12) 			<= "0001";
						when TWOCODE  			=> GAddress(15 downto 12) 			<= "0010";
						when THREECODE  		=> GAddress(15 downto 12)			<= "0011";
						when FOURCODE  		=> GAddress(15 downto 12) 			<= "0100";
						when FIVECODE  		=> GAddress(15 downto 12) 			<= "0101";
						when SIXCODE  			=> GAddress(15 downto 12) 			<= "0110";
						when SEVENCODE  		=> GAddress(15 downto 12) 			<= "0111";
						when EIGHTCODE  		=> GAddress(15 downto 12) 			<= "1000";
						when NINECODE  		=> GAddress(15 downto 12) 			<= "1001";
						when ACODE  			=> GAddress(15 downto 12) 			<= "1010";
						when BCODE  			=> GAddress(15 downto 12) 			<= "1011";
						when CCODE  			=> GAddress(15 downto 12) 			<= "1100";
						when DCODE  			=> GAddress(15 downto 12) 			<= "1101";
						when ECODE  			=> GAddress(15 downto 12)			<= "1110";
						when FCODE  			=> GAddress(15 downto 12) 			<= "1111";
						when others =>
					end case;
					case SendBuffer(31 downto 24) is
						when ZEROCODE		 	=> GAddress(11 downto 8)	 		<= "0000";
						when ONECODE 		 	=> GAddress(11 downto 8) 			<= "0001";
						when TWOCODE  			=> GAddress(11 downto 8) 			<= "0010";
						when THREECODE  		=> GAddress(11 downto 8)			<= "0011";
						when FOURCODE  		=> GAddress(11 downto 8) 			<= "0100";
						when FIVECODE  		=> GAddress(11 downto 8) 			<= "0101";
						when SIXCODE  			=> GAddress(11 downto 8) 			<= "0110";
						when SEVENCODE  		=> GAddress(11 downto 8) 			<= "0111";
						when EIGHTCODE  		=> GAddress(11 downto 8) 			<= "1000";
						when NINECODE  		=> GAddress(11 downto 8) 			<= "1001";
						when ACODE  			=> GAddress(11 downto 8) 			<= "1010";
						when BCODE  			=> GAddress(11 downto 8) 			<= "1011";
						when CCODE  			=> GAddress(11 downto 8) 			<= "1100";
						when DCODE  			=> GAddress(11 downto 8) 			<= "1101";
						when ECODE  			=> GAddress(11 downto 8)			<= "1110";
						when FCODE  			=> GAddress(11 downto 8) 			<= "1111";
						when others =>
					end case;
					case SendBuffer(39 downto 32) is
						when ZEROCODE		 	=> GAddress(7 downto 4)	 			<= "0000";
						when ONECODE 		 	=> GAddress(7 downto 4) 			<= "0001";
						when TWOCODE  			=> GAddress(7 downto 4) 			<= "0010";
						when THREECODE  		=> GAddress(7 downto 4)				<= "0011";
						when FOURCODE  		=> GAddress(7 downto 4) 			<= "0100";
						when FIVECODE  		=> GAddress(7 downto 4) 			<= "0101";
						when SIXCODE  			=> GAddress(7 downto 4) 			<= "0110";
						when SEVENCODE  		=> GAddress(7 downto 4) 			<= "0111";
						when EIGHTCODE  		=> GAddress(7 downto 4) 			<= "1000";
						when NINECODE  		=> GAddress(7 downto 4) 			<= "1001";
						when ACODE  			=> GAddress(7 downto 4) 			<= "1010";
						when BCODE  			=> GAddress(7 downto 4) 			<= "1011";
						when CCODE  			=> GAddress(7 downto 4) 			<= "1100";
						when DCODE  			=> GAddress(7 downto 4) 			<= "1101";
						when ECODE  			=> GAddress(7 downto 4)				<= "1110";
						when FCODE  			=> GAddress(7 downto 4) 			<= "1111";
						when others =>
					end case;
					case SendBuffer(47 downto 40) is
						when ZEROCODE		 	=> GAddress(3 downto 0)	 			<= "0000";
						when ONECODE 		 	=> GAddress(3 downto 0) 			<= "0001";
						when TWOCODE  			=> GAddress(3 downto 0) 			<= "0010";
						when THREECODE  		=> GAddress(3 downto 0)				<= "0011";
						when FOURCODE  		=> GAddress(3 downto 0) 			<= "0100";
						when FIVECODE  		=> GAddress(3 downto 0) 			<= "0101";
						when SIXCODE  			=> GAddress(3 downto 0) 			<= "0110";
						when SEVENCODE  		=> GAddress(3 downto 0) 			<= "0111";
						when EIGHTCODE  		=> GAddress(3 downto 0) 			<= "1000";
						when NINECODE  		=> GAddress(3 downto 0) 			<= "1001";
						when ACODE  			=> GAddress(3 downto 0) 			<= "1010";
						when BCODE  			=> GAddress(3 downto 0) 			<= "1011";
						when CCODE  			=> GAddress(3 downto 0) 			<= "1100";
						when DCODE  			=> GAddress(3 downto 0) 			<= "1101";
						when ECODE  			=> GAddress(3 downto 0)				<= "1110";
						when FCODE  			=> GAddress(3 downto 0) 			<= "1111";
						when others =>
					end case;
					term_status <= u0;
					CpuDataPath <= "01010101";
					tempRdn <= '1';
					CpuDataReady <= '1';
				elsif (buffer_status = b1) then
					term_status <= error1;
					CpuDataPath <= "00000000";
					tempRdn <= '1';
					CpuDataReady <= '1';
				end if;
			--------A--------
			when a0 =>
				checkState <= "0000001";
				if (tempRdn = '0') then
					Buffer_init <= '1';
					term_status <= a1;
					tempRdn <= '1';
				end if;
			when a1 =>
				term_status <= a2;
				Buffer_init <= '0';
				CpuDataPath <= writeAddress(7 downto 0);
				CpuDataReady <= '1';
			when a2 =>
				if (tempRdn = '0') then
					term_status <= a3;
					CpuDataPath <= writeAddress(15 downto 8);
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when a3 =>
				checkState <= "0000011";
				if (tempRdn /= '0') then
					term_status <= a3;
				elsif (buffer_status = b1 and BufferWriteNumber = 0) then
					term_status <= aerror1;
					CpuDataPath <= "00000000";
					CpuDataReady <= '1';
					tempRdn <= '1';
				elsif (buffer_status = b1 and BufferWriteNumber /= 0) then
					term_status <= a4;
					CpuDataPath <= writeData(7 downto 0);
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when a4 =>
				checkState <= "0011111";
				if (tempRdn = '0') then
					term_status <= a5;
					CpuDataPath <= writeData(15 downto 8);
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when a5 =>
				checkState <= "0111111";
				if (tempRdn = '0') then
					term_status <= a1;
					Buffer_init <= '1';
					if (writeData(15 downto 0) /= "1111111111111111") then
						writeAddress <= writeAddress + 1;
					end if;
					tempRdn <= '1';
				end if;
			------G-------
			when g0 =>
				if (tempRdn = '0') then
					Buffer_init <= '1';
					term_status <= g1;
					tempRdn <= '1';
				end if;
			when g1 =>
				CpuDataPath <= "00000000";
				CpuDataReady <= '1';
				term_status <= g2;
			when g2 =>
				if (tempRdn <= '0') then
					term_status <= g3;
					CpuDataPath <= "01000000";
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when g3 =>
				if (tempRdn <= '0') then
					term_status <= main;
				end if;
			------R---------
			when r0 =>
				if (tempRdn = '0') then
					Buffer_init <= '1';
					term_status <= main;
				end if;		
			------U---------
			when u0 =>
				if (tempRdn = '0') then
					Buffer_init <= '1';
					term_status <= u1;
					tempRdn <= '1';
				end if;
			when u1 =>
				CpuDataPath <= GAddress(7 downto 0);
				CpuDataReady <= '1';
				term_status <= u2;
			when u2 =>
				if (tempRdn <= '0') then
					term_status <= u3;
					CpuDataPath <= GAddress(15 downto 8);
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when u3 =>
				if (tempRdn <= '0') then
					term_status <= u4;
					CpuDataPath <= "00010000";
					CpuDataReady <= '1';
					tempRdn <= '1';					
				end if;
			when u4 =>
				if (tempRdn <= '0') then
					term_status <= u5;
					CpuDataPath <= "00000000";
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when u5 =>
				if (tempRdn <= '0') then
					term_status <= main;
				end if;
			----D----
			when d0 =>
				if (tempRdn = '0') then
					Buffer_init <= '1';
					term_status <= d1;
					tempRdn <= '1';
				end if;
			when d1 =>
				CpuDataPath <= "00000000";
				CpuDataReady <= '1';
				term_status <= d2;
			when d2 =>
				if (tempRdn <= '0') then
					term_status <= d3;
					CpuDataPath <= "10000000";
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when d3 =>
				if (tempRdn <= '0') then
					term_status <= d4;
					CpuDataPath <= "00010000";
					CpuDataReady <= '1';
					tempRdn <= '1';					
				end if;
			when d4 =>
				if (tempRdn <= '0') then
					term_status <= d5;
					CpuDataPath <= "00000000";
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when d5 =>
				if (tempRdn <= '0') then
					term_status <= main;
				end if;
			---aerror1-----
			when aerror1 =>
				if (tempRdn <= '0') then
					term_status <= aerror2;
					CpuDataPath <= "00000000";
					CpuDataReady <= '1';
					tempRdn <= '1';
				end if;
			when aerror2 =>
				if (tempRdn <= '0') then
					term_status <= main;
					Buffer_init <= '1';
				end if;
			---error1------
			when error1 =>
				if (tempRdn = '0') then
					Buffer_init <= '1';
					term_status <= main;
					tempRdn <= '1';
				end if;
			when others =>
		end case;
	end if;
end process;
----ram读取键盘
process (DataReady, RamRdn)
begin
	if (RamRdn = '0') then
		tempDataRdn <= '0';
		RamDataReady <= '0';
	elsif DataReady'event and DataReady = '0' then
		if (tempDataRdn <= '0') then
			RamDataPath <= RamDataOut;
			RamDataReady <= '1';
			tempDataRdn <= '1';
		end if;
	end if;
end process;
RamData <= RamDataPath; -- when RamRdn = '0' else (others => 'Z');
DataPath <= CpuDataPath when CpuRdn = '0' else (others => 'Z');
end Behavioral;

