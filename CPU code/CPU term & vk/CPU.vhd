----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:32:37 11/11/2015 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
    Port ( clk50_true : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  clk0 : in STD_LOGIC;
			  datain : in STD_LOGIC;
			  clkin  : in STD_LOGIC; 
			  debug : out STD_LOGIC_VECTOR (15 downto 0);
			  debug2 : out STD_LOGIC_VECTOR (6 downto 0);
			  debug3 : out STD_LOGIC_VECTOR (6 downto 0);
           RAM2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM2Addr_out : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM2EN : out  STD_LOGIC;
           RAM2WE : out  STD_LOGIC;
           RAM2OE : out  STD_LOGIC;
           RAM1Data : inout  STD_LOGIC_VECTOR (15 downto 0);
           RAM1Addr_out : out  STD_LOGIC_VECTOR (17 downto 0);
           RAM1EN : out  STD_LOGIC;
           RAM1WE : out  STD_LOGIC;
           RAM1OE : out  STD_LOGIC;
           uart_tsre : in  STD_LOGIC;
           uart_tbre : in  STD_LOGIC;
           uart_data_ready : in  STD_LOGIC;
           uart_wrn : out  STD_LOGIC;
           uart_rdn : out  STD_LOGIC;
			  hs, vs : out std_logic;
		     r, g, b : out std_logic_vector(2 downto 0);
			  FlashByte : out  STD_LOGIC;
           FlashVpen : out  STD_LOGIC;
           FlashCE : out  STD_LOGIC;
			  FlashOE : out  STD_LOGIC;
           FlashWE : out  STD_LOGIC;
           FlashRP : out  STD_LOGIC;
           FlashAddr : out  STD_LOGIC_VECTOR (22 downto 0);
           FlashData : inout  STD_LOGIC_VECTOR (15 downto 0)
			 );
end CPU;

architecture Behavioral of CPU is

	component vga_controller
    Port ( clk50 : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
		     hs, vs : out std_logic;
		     r, g, b : out std_logic_vector(2 downto 0);
			  debugrow, debugcolumn : out integer range 0 to 63 );
	end component;
	
	component flash_controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  booting : out  std_logic;
           FlashByte : out  STD_LOGIC;
           FlashVpen : out  STD_LOGIC;
           FlashCE : out  STD_LOGIC;
			  FlashOE : out  STD_LOGIC;
           FlashWE : out  STD_LOGIC;
           FlashRP : out  STD_LOGIC;
           FlashAddr : out  STD_LOGIC_VECTOR (22 downto 0);
           FlashData : inout  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	component keyboardstatemachine
    Port ( datain : in  STD_LOGIC;						--keyboarddata
           clkin : in  STD_LOGIC;						--keyboardclock
           fclk : in  STD_LOGIC;							--50M
           rst : in  STD_LOGIC;							--rst
			  rdn : in STD_LOGIC;							--rdn
			  testclk : in std_logic;						--≤‚ ‘”√50M ±÷”
			  CpuDataReady : out std_logic;
	   	  showState : out std_logic_vector(6 downto 0);		--≤‚ ‘cpu◊¥Ã¨ª˙
	   	  showBufferState : out std_logic_vector(6 downto 0);	--≤‚ ‘ª∫¥Ê«¯◊¥Ã¨
			  showData : inout STD_LOGIC_VECTOR(7 downto 0); 	--cpudata
			  KBData : out std_logic_vector(15 downto 0);
			  KBdata_ready : out std_logic;
			  KBrdn : in std_logic;
			  interrupt : out std_logic;
			  interruptC : out std_logic
	  );
	end component;
	
	component IFetch
		 Port ( Ram2Addr : out  STD_LOGIC_VECTOR (15 downto 0);
				  Ram2Data : inout  STD_LOGIC_VECTOR (15 downto 0);
				  PC : in  STD_LOGIC_VECTOR (15 downto 0);
				  PCInc : out  STD_LOGIC_VECTOR (15 downto 0);
				  IR : out  STD_LOGIC_VECTOR (15 downto 0);
				  PCStop : in  STD_LOGIC;
				  IFWE : in  STD_LOGIC;
				  IFData : in  STD_LOGIC_VECTOR (15 downto 0);
				  IFAddr : in  STD_LOGIC_VECTOR (15 downto 0);
				  Ram2EN : out  STD_LOGIC;
				  Ram2WE : out  STD_LOGIC;
				  Ram2OE : out  STD_LOGIC;
				  IF_WRITE_RAM2 : out STD_LOGIC;
				  clk : in  STD_LOGIC;
				  clk50 : in  STD_LOGIC;
				  booting : in std_logic;
				  FlashAddr : in std_logic_vector(15 downto 0);
				  FlashData : in std_logic_vector(15 downto 0);
				  debug : out STD_LOGIC_VECTOR(15 downto 0));
	end component;

	component PC
		PORT ( rst :  in STD_LOGIC;
				 CURRENTPC :  in STD_LOGIC_VECTOR(15 downto 0);
				 LASTPC :  in STD_LOGIC_VECTOR(15 downto 0);
				 EXTENDIMM :  in STD_LOGIC_VECTOR(15 downto 0);
				 BRANCH :  in STD_LOGIC_VECTOR(1 downto 0);
				 JUMP :  in STD_LOGIC;
				 REGDATA1 :  in STD_LOGIC_VECTOR(15 downto 0);
				 ALURES1 :  in STD_LOGIC_VECTOR(15 downto 0);  --ALU result in EXE; e.g. ADD 1 2 3; BNEZ 1 00
				 ALURES2 :  in STD_LOGIC_VECTOR(15 downto 0);  --ALU result in MEM; e.g. ADD 1 2 3; NOP; BNEZ 1 00
				 MEMDATA :  in STD_LOGIC_VECTOR(15 downto 0);  --MEM result in MEM; e.g. LW 1; NOP; BNEZ 1 00
				 FORWARD :  in STD_LOGIC_VECTOR(1 downto 0);

				 NEXTPC :  out STD_LOGIC_VECTOR(15 downto 0);
				 IF_FLUSH :  out STD_LOGIC
				 );
	end component;
	
	component IF_ID_REGISTER
		PORT ( clk :  in STD_LOGIC;
				 INPC :  in STD_LOGIC_VECTOR(15 downto 0);
				 INIR :  inout STD_LOGIC_VECTOR(15 downto 0);
				 INTERRUPT :  in STD_LOGIC_VECTOR(3 downto 0);
				 SOFTINTNUM :  in STD_LOGIC_VECTOR(3 downto 0);
				 IFIDSTOP :  in STD_LOGIC;
				 IF_WRITE_RAM2 : in STD_LOGIC;
				 IF_FLUSH :  in STD_LOGIC;
				 OUTPC :  out STD_LOGIC_VECTOR(15 downto 0);
				 OUTIR :  out STD_LOGIC_VECTOR(15 downto 0);
				 debug :  out STD_LOGIC_VECTOR(15 downto 0)
				 );
	end component;
	
	component controller
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
	end component;
	
	component RegisterCluster
		 PORT ( clk :  in STD_LOGIC;
				  rst :  in STD_LOGIC;
				  SRCREG1 :  in STD_LOGIC_VECTOR (3 downto 0);
				  SRCREG2 :  in STD_LOGIC_VECTOR (3 downto 0);
				  TARGETREG : in  STD_LOGIC_VECTOR (3 downto 0);
				  REGWRITE :  in STD_LOGIC;
				  WRITEDATA : in STD_LOGIC_VECTOR(15 downto 0);
				  REGDATA1 : out STD_LOGIC_VECTOR (15 downto 0);
				  REGDATA2 : out STD_LOGIC_VECTOR (15 downto 0);
				  
				  debug : out STD_LOGIC_VECTOR (15 downto 0)
				);
	end component;
	
	component ID_EX_REGISTER
		PORT ( clk :  in STD_LOGIC;
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
				
				debug_target : out STD_LOGIC_VECTOR(3 downto 0);
				IN_IR : in std_logic_vector(15 downto 0);
				debug_IR : out std_logic_vector(15 downto 0);
				debug_PC : out std_logic_vector(15 downto 0);
				debug_WB : out std_logic
				 );
	end component;
	
	component alu
	  port (	REGDATA1: in std_logic_vector(15 downto 0);
				REGDATA2: in std_logic_vector(15 downto 0);
				EXTENDIMM: in std_logic_vector(15 downto 0); 
				LASTALU: in std_logic_vector(15 downto 0); 
				LASTMEM: in std_logic_vector(15 downto 0); 
				forwardA: in std_logic_vector(1 downto 0);
				forwardB: in std_logic_vector(1 downto 0);
				ALUSRCA: in std_logic_vector(1 downto 0); 
				ALUSRCB: in std_logic;
				ALUOP: in std_logic_vector(3 downto 0);
				PC: in std_logic_vector(15 downto 0);
				ALURES: out std_logic_vector(15 downto 0);
				REGDATA : out std_logic_vector(15 downto 0);
				
				debug1: out std_logic_vector(15 downto 0);
				debug2: out std_logic_vector(15 downto 0)
			  );
	end component;
	
	component EX_MEM_REGISTER
		PORT ( clk :  in STD_LOGIC;
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
				
				debug :  out STD_LOGIC_VECTOR(15 downto 0)
				 );
	end component;
	
	component MEM
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
	end component;

	component MEM_WB_REGISTER
		PORT ( clk :  in STD_LOGIC;
				IN_REGWRITE :  in STD_LOGIC;
				IN_MEMTOREG :  in STD_LOGIC;
				ALURES :  in STD_LOGIC_VECTOR(15 downto 0);
				IN_TARGETREG :  in STD_LOGIC_VECTOR(3 downto 0);
				READDATA :  in STD_LOGIC_VECTOR(15 downto 0);

				OUT_REGWRITE :  out STD_LOGIC;
				OUT_TARGETREG :  out STD_LOGIC_VECTOR(3 downto 0);
				WRITEDATA :  out STD_LOGIC_VECTOR(15 downto 0)
				 );
	end component;
	
	component FORWARD_UNIT
		 Port ( SRCREG1 : in  STD_LOGIC_VECTOR (3 downto 0);
				  SRCREG2 : in  STD_LOGIC_VECTOR (3 downto 0);
				  TARGETREGALU : in  STD_LOGIC_VECTOR (3 downto 0);
				  TARGETREGMEM : in  STD_LOGIC_VECTOR (3 downto 0);
				  REGWRITEALU : in  STD_LOGIC;
				  MEMTOREGALU : in  STD_LOGIC;
				  REGWRITEMEM : in  STD_LOGIC;
				  MEMTOREGMEM : in  STD_LOGIC;
				  FORWARDA : out  STD_LOGIC_VECTOR (1 downto 0);
				  FORWARDB : out  STD_LOGIC_VECTOR (1 downto 0);
				  FORWARD : out  STD_LOGIC_VECTOR (1 downto 0);
				  PCSTOP : out  STD_LOGIC;
				  IFIDSTOP : out  STD_LOGIC;
				  CONTROLSTOP : out  STD_LOGIC);
	end component;
	
	component output_adaptor 
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
	end component;
	
	signal clk50, clk25: STD_LOGIC;
	signal clkcnt : std_logic_vector(7 downto 0);
	
	signal scan_code : STD_LOGIC_VECTOR (7 downto 0);
	signal check : STD_LOGIC_VECTOR(6 downto 0);
   signal keyboard_out : std_logic;			
   signal check_2 : std_logic;
   signal word : STD_LOGIC_VECTOR (7 downto 0);
	signal IF_INPC : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal IF_PC : STD_LOGIC_VECTOR (15 downto 0);
	signal IF_IR : STD_LOGIC_VECTOR (15 downto 0);
	signal IF_WE : STD_LOGIC;
	signal IF_DATA : STD_LOGIC_VECTOR (15 downto 0);
	signal IF_ADDR : STD_LOGIC_VECTOR (15 downto 0);
	
	signal ID_PC : STD_LOGIC_VECTOR (15 downto 0);
	signal ID_IR : STD_LOGIC_VECTOR (15 downto 0);
	signal ID_EXTENDIMM : STD_LOGIC_VECTOR (15 downto 0);
	signal ID_SRCREG1 : STD_LOGIC_VECTOR (3 downto 0);
	signal ID_SRCREG2 : STD_LOGIC_VECTOR (3 downto 0);
	signal ID_TARGETREG : STD_LOGIC_VECTOR (3 downto 0);
	signal ID_REGDATA1 : STD_LOGIC_VECTOR (15 downto 0);
	signal ID_REGDATA2 : STD_LOGIC_VECTOR (15 downto 0);
	signal ID_MEMWRITE : STD_LOGIC;
	signal ID_MEMTOREG : STD_LOGIC;
	signal ID_REGWRITE : STD_LOGIC;
	signal ID_ALUSRCA : STD_LOGIC_VECTOR (1 downto 0);
	signal ID_ALUSRCB : STD_LOGIC;
	signal ID_ALUOP : STD_LOGIC_VECTOR (3 downto 0);
	signal ID_BRANCH : STD_LOGIC_VECTOR (1 downto 0);
	signal ID_JUMP : STD_LOGIC;
	signal ID_FORWARDA : STD_LOGIC_VECTOR (1 downto 0);
	signal ID_FORWARDB : STD_LOGIC_VECTOR (1 downto 0);
	
	signal EX_PC : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_EXTENDIMM : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_TARGETREG : STD_LOGIC_VECTOR (3 downto 0);
	signal EX_REGDATA1 : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_REGDATA2 : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_REGDATA : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_MEMWRITE : STD_LOGIC;
	signal EX_MEMTOREG : STD_LOGIC;
	signal EX_REGWRITE : STD_LOGIC;
	signal EX_ALUSRCA : STD_LOGIC_VECTOR (1 downto 0);
	signal EX_ALUSRCB : STD_LOGIC;
	signal EX_ALUOP : STD_LOGIC_VECTOR (3 downto 0);
	signal EX_ALURES : STD_LOGIC_VECTOR (15 downto 0);
	signal EX_FORWARDA : STD_LOGIC_VECTOR (1 downto 0);
	signal EX_FORWARDB : STD_LOGIC_VECTOR (1 downto 0);
	
	signal MEM_TARGETREG : STD_LOGIC_VECTOR (3 downto 0);
	signal MEM_REGDATA : STD_LOGIC_VECTOR (15 downto 0);
	signal MEM_ALURES : STD_LOGIC_VECTOR (15 downto 0);
	signal MEM_MEMWRITE : STD_LOGIC;
	signal MEM_MEMTOREG : STD_LOGIC;
	signal MEM_REGWRITE : STD_LOGIC;
	signal MEM_READDATA : STD_LOGIC_VECTOR (15 downto 0);
	
	signal WB_TARGETREG : STD_LOGIC_VECTOR (3 downto 0);
	signal WB_WRITEDATA : STD_LOGIC_VECTOR (15 downto 0);
	signal WB_REGWRITE : STD_LOGIC;
	
	signal FORWARD : STD_LOGIC_VECTOR (1 downto 0);
	signal PCSTOP : STD_LOGIC;
	signal IFIDSTOP : STD_LOGIC;
	signal CONTROLSTOP : STD_LOGIC;
	signal IF_FLUSH : STD_LOGIC;
	signal IF_WRITE_RAM2 : STD_LOGIC;
	
	signal Ram1Addr : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	signal Ram2Addr : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	
	signal reg1data : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	signal aluresdebug1 : STD_LOGIC_VECTOR(15 downto 0);
	signal aluresdebug2 : STD_LOGIC_VECTOR(15 downto 0);
	signal debug_target : STD_LOGIC_VECTOR(3 downto 0);
	signal debug_pc : STD_LOGIC_VECTOR(15 downto 0);
	signal debug_wb : STD_LOGIC;
	signal shabi : STD_LOGIC_VECTOR(1 downto 0);
	signal IF_DEBUG : STD_LOGIC_VECTOR(15 downto 0);
	signal ID_IRDEBUG : STD_LOGIC_VECTOR(15 downto 0);
	signal EXMEMDEBUG : STD_LOGIC_VECTOR(15 downto 0);
	signal MEMDEBUG : STD_LOGIC_VECTOR(15 downto 0);
	signal rdn : STD_LOGIC;
	signal data_ready : STD_LOGIC;
	signal checkcpustate : std_logic_vector(6 downto 0);
	signal checkbufferstate : std_logic_vector(6 downto 0);
	
	signal KBData, OutputData : std_logic_vector(15 downto 0);
	signal KBDataReady, OutputDataReady : std_logic;
	signal KBRdn, OutputRdn : std_logic;
	signal interrupt, interruptC : std_logic;
	signal softint, clockint : std_logic;
	signal clocknum : integer := 0;
	signal INTERRUPT_TYPE : STD_LOGIC_VECTOR(3 downto 0);
	signal SOFTINTNUM : std_logic_vector(3 downto 0);
	signal tsre, tbre, wrn: std_logic := '1';
	
	signal row, column : integer range 0 to 63;
	
	signal myr, myg, myb : std_logic_vector(2 downto 0);
	
	signal FlashAddrTmp : std_logic_vector(22 downto 0);
	signal booting : std_logic;
	
	--signal canint : std_logic := '1';
	signal IDIFDEBUG : std_logic_vector(15 downto 0);
begin
	debug <= ID_IR;
	debug2 <= FlashAddrTmp(6 downto 0);
	debug3 <= uart_tbre & uart_tsre & uart_data_ready & tbre & tsre & data_ready & INTERRUPT_TYPE(0);
	--debug2 <= checkcpustate(6 downto 0);
--	debug3 <= checkbufferstate(6 downto 0);
--	process(row)
--	begin
--		case row is
--			when 0 =>             debug2 <="1111110"; --0
--			when 1 =>             debug2 <="0110000"; --1
--			when 2 =>             debug2 <="1101101"; --2
--			when 3 =>             debug2 <="1111001"; --3
--			when 4 =>             debug2 <="0110011"; --4
--			when 5 =>             debug2 <="1011011"; --5
--			when 6 =>             debug2 <="1011111"; --6
--			when 7 =>             debug2 <="1110000"; --7
--			when 8 =>             debug2 <="1111111"; --8
--			when 9 =>             debug2 <="1110011"; --9
--			when 10 =>            debug2 <="1110111"; --a
--			when 11 =>            debug2 <="0011111"; --b
--			when 12 =>            debug2 <="1001110"; --c
--			when 13 =>            debug2 <="0111101"; --d
--			when 14 =>            debug2 <="1001111"; --e
--			when 15 =>            debug2 <="1000111"; --f
--			when others=>         debug2 <="0000000"; --others
--		end case;
--	end process;
--	process(column)
--	begin
--		case column is
--			when 0 =>             debug3 <="1111110"; --0
--			when 1 =>             debug3 <="0110000"; --1
--			when 2 =>             debug3 <="1101101"; --2
--			when 3 =>             debug3 <="1111001"; --3
--			when 4 =>             debug3 <="0110011"; --4
--			when 5 =>             debug3 <="1011011"; --5
--			when 6 =>             debug3 <="1011111"; --6
--			when 7 =>             debug3 <="1110000"; --7
--			when 8 =>             debug3 <="1111111"; --8
--			when 9 =>             debug3 <="1110011"; --9
--			when 10 =>            debug3 <="1110111"; --a
--			when 11 =>            debug3 <="0011111"; --b
--			when 12 =>            debug3 <="1001110"; --c
--			when 13 =>            debug3 <="0111101"; --d
--			when 14 =>            debug3 <="1001111"; --e
--			when 15 =>            debug3 <="1000111"; --f
--			when others=>         debug3 <="0000000"; --others
--		end case;
--	end process;
	process(clk25)
	begin
		if clk25'event and clk25 = '0' then
			if clocknum < 1000 then
				clocknum <= clocknum + 1;
				clockint <= '0';
			else
				clocknum <= 0;
				clockint <= '1';
			end if;
		end if;
	end process;
	INTERRUPT_TYPE <= interrupt & interruptC & softint & clockint;
	Ram1Addr_out <= "00" & Ram1Addr;
	Ram2Addr_out <= "00" & Ram2Addr;

	process(clk50_true)
	begin
		if clk50_true'event and clk50_true = '1' then
			if clkcnt < 1 then
				clkcnt <= clkcnt + 1;
			else
				clk50 <= not clk50;
				clkcnt <= (others => '0');
			end if;
		end if;
	end process;
   --clk50 <= clk0;
	process(clk50)
	begin
		if clk50'event and clk50 = '1' then
			clk25 <= not clk25;
		end if;
	end process;

	
	my_IFetch :
		IFetch port map( 
			Ram2Addr => Ram2Addr,
			Ram2Data => Ram2Data,
			PC => IF_INPC,
			PCInc => IF_PC,
			IR => IF_IR,
			PCStop => PCSTOP,
			IFWE => IF_WE,
			IFData => IF_DATA,
			IFAddr => IF_ADDR,
			Ram2EN => Ram2EN,
			Ram2WE => Ram2WE,
			Ram2OE => Ram2OE,
			IF_WRITE_RAM2 => IF_WRITE_RAM2,
			clk => clk25,
			clk50 => clk50,
			booting => booting,
			FlashAddr => FlashAddrTmp(16 downto 1),
			FlashData => FlashData,
			debug => IF_DEBUG
			);
	
	my_PC : 
		PC port map(
			rst => rst,
			CURRENTPC => IF_PC,
			LASTPC => ID_PC,
			EXTENDIMM => ID_EXTENDIMM,
			BRANCH => ID_BRANCH,
			JUMP => ID_JUMP,
			REGDATA1 => ID_REGDATA1,
			ALURES1 => EX_ALURES,
			ALURES2 => MEM_ALURES,
			MEMDATA => Ram1Data,
			FORWARD => FORWARD,
			
			NEXTPC => IF_INPC,
			IF_FLUSH => IF_FLUSH
			);
	
	my_IF_ID_REGISTER :
		IF_ID_REGISTER port map(
			clk => clk25,
			INPC => IF_PC,
			INTERRUPT => INTERRUPT_TYPE,
			SOFTINTNUM => SOFTINTNUM,
			INIR => Ram2Data,
			IFIDSTOP => IFIDSTOP,
			IF_WRITE_RAM2 => IF_WRITE_RAM2,
			IF_FLUSH => IF_FLUSH,
			OUTPC => ID_PC,
			OUTIR => ID_IR,
			debug => IDIFDEBUG
			);
			
	my_controller :
		controller port map(
			INSTRUCTION => ID_IR,
			SRCREG1 => ID_SRCREG1,
			SRCREG2 => ID_SRCREG2,
			TARGETREG => ID_TARGETREG,
			EXTENDIMM => ID_EXTENDIMM,
			ALUOP => ID_ALUOP,
			ALUSRCA => ID_ALUSRCA,
			ALUSRCB => ID_ALUSRCB,
			MEMTOREG => ID_MEMTOREG,
			REGWRITE => ID_REGWRITE,
			MEMWRITE => ID_MEMWRITE,
			BRANCH => ID_BRANCH,
			JUMP => ID_JUMP,
			SOFTINT => softint,
			SOFTINTNUM => SOFTINTNUM
			);
	
	my_RegisterCluster :
		RegisterCluster port map(
			clk => clk25,
			rst => rst,
			SRCREG1 => ID_SRCREG1,
			SRCREG2 => ID_SRCREG2,
			TARGETREG => WB_TARGETREG,
			REGWRITE => WB_REGWRITE,
			WRITEDATA => WB_WRITEDATA,
			REGDATA1 => ID_REGDATA1,
			REGDATA2 => ID_REGDATA2,
			debug => reg1data
			);
			
	my_ID_EX_REGISTER :
		ID_EX_REGISTER port map(
			clk => clk25,
			CONTROLSTOP => CONTROLSTOP,
			IN_MEMTOREG => ID_MEMTOREG,
			IN_REGWRITE => ID_REGWRITE,
			IN_MEMWRITE => ID_MEMWRITE,
			IN_ALUSRCA => ID_ALUSRCA,
			IN_ALUSRCB => ID_ALUSRCB,
			IN_ALUOP => ID_ALUOP,
			IN_FORWARDA => ID_FORWARDA,
			IN_FORWARDB => ID_FORWARDB,
			IN_EXTENDIMM => ID_EXTENDIMM,
			IN_TARGETREG => ID_TARGETREG,
			IN_REGDATA1 => ID_REGDATA1,
			IN_REGDATA2 => ID_REGDATA2,
			IN_PC => ID_PC,

			OUT_MEMTOREG => EX_MEMTOREG,
			OUT_REGWRITE => EX_REGWRITE,
			OUT_MEMWRITE => EX_MEMWRITE,
			OUT_ALUSRCA => EX_ALUSRCA,
			OUT_ALUSRCB => EX_ALUSRCB,
			OUT_ALUOP => EX_ALUOP,
			OUT_FORWARDA => EX_FORWARDA,
			OUT_FORWARDB => EX_FORWARDB,
			OUT_EXTENDIMM => EX_EXTENDIMM,
			OUT_TARGETREG => EX_TARGETREG,
			OUT_REGDATA1 => EX_REGDATA1,
			OUT_REGDATA2 => EX_REGDATA2,
			OUT_PC => EX_PC,
			
			debug_target => debug_target,
			IN_IR => ID_IR,
			debug_IR => ID_IRDEBUG,
			debug_PC => debug_pc,
			debug_WB => debug_wb
			);
			
	my_alu :
		alu port map(	
			REGDATA1 => EX_REGDATA1,
			REGDATA2 => EX_REGDATA2,
			EXTENDIMM => EX_EXTENDIMM,
			LASTALU => MEM_ALURES,
			LASTMEM => WB_WRITEDATA,
			forwardA => EX_FORWARDA,
			forwardB => EX_FORWARDB,
			ALUSRCA => EX_ALUSRCA,
			ALUSRCB => EX_ALUSRCB,
			ALUOP => EX_ALUOP,
			PC => EX_PC,
			ALURES => EX_ALURES,
			REGDATA => EX_REGDATA,
			
			debug1 => aluresdebug1,
			debug2 => aluresdebug2
			);
	
	my_EX_MEM_REGISTER : 
		EX_MEM_REGISTER port map( 
			clk => clk25,
			IN_MEMTOREG => EX_MEMTOREG,
			IN_REGWRITE => EX_REGWRITE,
			IN_MEMWRITE => EX_MEMWRITE,
			IN_ALURES => EX_ALURES,
			IN_REGDATA => EX_REGDATA,
			IN_TARGETREG => EX_TARGETREG,

			OUT_MEMTOREG => MEM_MEMTOREG,
			OUT_REGWRITE => MEM_REGWRITE,
			OUT_MEMWRITE => MEM_MEMWRITE,
			OUT_ALURES => MEM_ALURES,
			OUT_REGDATA => MEM_REGDATA,
			OUT_TARGETREG => MEM_TARGETREG,
			debug => EXMEMDEBUG
			);
	
	my_MEM :
		MEM port map( 
			Ram1Data => Ram1Data,
			Ram1Addr => Ram1Addr,
			Ram1OE => Ram1OE,
			Ram1WE => Ram1WE,
			Ram1EN => Ram1EN,
			data_ready => data_ready,
			tbre => tbre,
			tsre => tsre,
			rdn => rdn,
			wrn => wrn,
			uart_data_ready => uart_data_ready,
			uart_tbre => uart_tbre,
			uart_tsre => uart_tsre,
			uart_rdn => uart_rdn,
			uart_wrn => uart_wrn,
			MemData => MEM_REGDATA,
			MemAddr => MEM_ALURES,
			OutputData => MEM_READDATA,
			MemWE => MEM_MEMWRITE,
			MemRE => MEM_MEMTOREG,
			IFWE => IF_WE,
			IFData => IF_DATA,
			IFAddr => IF_ADDR,
			clk => clk25,
			clk50 => clk50,
			debug => MEMDEBUG
			);
	
	my_MEM_WB_REGISTER : 
		MEM_WB_REGISTER port map( 
			clk => clk25,
			IN_REGWRITE => MEM_REGWRITE,
			IN_MEMTOREG => MEM_MEMTOREG,
			ALURES => MEM_ALURES,
			IN_TARGETREG => MEM_TARGETREG,
			READDATA => Ram1Data,

			OUT_REGWRITE => WB_REGWRITE,
			OUT_TARGETREG => WB_TARGETREG,
			WRITEDATA => WB_WRITEDATA
			);
			
	my_FORWARD_UNIT : 
		FORWARD_UNIT port map( 
			SRCREG1 => ID_SRCREG1,
			SRCREG2 => ID_SRCREG2,
			TARGETREGALU => EX_TARGETREG,
			TARGETREGMEM => MEM_TARGETREG,
			REGWRITEALU => EX_REGWRITE,
			MEMTOREGALU => EX_MEMTOREG,
			REGWRITEMEM => MEM_REGWRITE,
			MEMTOREGMEM => MEM_MEMTOREG,
			FORWARDA => ID_FORWARDA,
			FORWARDB => ID_FORWARDB,
			FORWARD => FORWARD,
			PCSTOP => PCSTOP,
			IFIDSTOP => IFIDSTOP,
			CONTROLSTOP => CONTROLSTOP
			);
	
	my_KEYBOARDSTATEMACHINE :
		keyboardstatemachine Port map(
			  datain => datain, 						--keyboarddata
           clkin => clkin,						--keyboardclock
           fclk => clk50,							--50M
           rst => rst,							--rst
			  rdn => rdn,							--rdn
			  testclk => clk50_true,					--≤‚ ‘”√50M ±÷”
			  CpuDataReady => data_ready,
			  showState=> checkcpustate,		--≤‚ ‘cpu◊¥Ã¨ª˙
				showBufferState => checkbufferstate,	--≤‚ ‘ª∫¥Ê«¯◊¥Ã¨
			  showData =>RAM1Data(7 downto 0), 	--cpudata
			  KBData => KBData,
			  KBdata_ready => KBDataReady,
			  KBrdn => KBRdn,
			  interrupt => interrupt,
			  interruptC => interruptC
	  );
	
    myVgaController :
	 vga_controller Port map(
        clk50 => clk50_true,
        rst => rst,
        DataIn => OutputData,
        data_ready => OutputDataReady,
        rdn => OutputRdn,
		  hs => hs,
		  vs => vs,
		  r => myr,
		  g => myg,
		  b => myb,
		  debugrow => row,
		  debugcolumn => column);
		  
	 tbre <= '1';
	 r <= myr;
	 g <= myg;
	 b <= myb;
	 
	 myOutputAdaptor :
	 output_adaptor Port map ( 
			  clk50 => clk50_true, 
           CPUData => Ram1Data,
           KBData => KBData,
           CPUwrn => wrn,
           CPUtsre => tsre,
           KBdata_ready => KBDataReady,
           KBrdn => KBRdn,
           DataOut => OutputData,
           data_ready => OutputDataReady,
           rdn => OutputRdn);
		
	 myFlashController : 
	 flash_controller Port map (
			clk => clk25,
         rst => rst,
		   booting => booting,
         FlashByte => FlashByte,
         FlashVpen => FlashVpen,
         FlashCE => FlashCE,
			FlashOE => FlashOE,
         FlashWE => FlashWE,
         FlashRP => FlashRP,
         FlashAddr => FlashAddrTmp,
         FlashData => FlashData);
		
   FlashAddr <= FlashAddrTmp;
	
end Behavioral;

