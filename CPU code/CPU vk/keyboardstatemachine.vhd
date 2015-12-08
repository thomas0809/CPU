----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:38:20 11/22/2015 
-- Design Name: 
-- Module Name:    keyboardstatemachine - Behavioral 
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

entity keyboardstatemachine is
    Port ( datain : in  STD_LOGIC;						--keyboarddata
           clkin : in  STD_LOGIC;						--keyboardclock
           fclk : in  STD_LOGIC;							--50M
           rst : in  STD_LOGIC;							--rst
			  rdn : in STD_LOGIC;							--rdn
			  testclk : in std_logic;						--������50Mʱ��
			  CpuDataReady : out std_logic;
			  showState : out std_logic_vector(6 downto 0);		--����cpu״̬��
		     showBufferState : out std_logic_vector(6 downto 0);	--���Ի�����״̬
			  showData : inout STD_LOGIC_VECTOR(7 downto 0); 	--cpudata
			  KBData : out std_logic_vector(15 downto 0);
			  KBdata_ready : out std_logic;
			  KBrdn : in std_logic;
     --      scan_code : out  STD_LOGIC_VECTOR (7 downto 0);
	  --	  check : out STD_LOGIC_VECTOR(6 downto 0);
	  		  interrupt : out std_logic;
    		  interruptC : out std_logic
	  -- 		  keyboard_out : out std_logic;
	  --	  check_2 : out std_logic;
     --     word : out  STD_LOGIC_VECTOR (7 downto 0)
	  );
end keyboardstatemachine;

architecture Behavioral of keyboardstatemachine is

component keyboard
    Port ( datain : in  STD_LOGIC;
           clkin : in  STD_LOGIC;
           fclk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           scan_code : out  STD_LOGIC_VECTOR (7 downto 0);
			  check : out STD_LOGIC_VECTOR(6 downto 0);
			  interrupt : out std_logic;
			  interruptC : out std_logic;
			  keyboard_out : out std_logic;								  
			  check_2 : out std_logic;
			  shiftstate : out std_logic;
			  ctrlstate : out std_logic;
           word : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

component keyboardCpuRam
    Port ( clk50		  : in std_logic;								--50Mʱ��
			  rst			  : in std_logic;								--��ʼ��
			  KeyBoardData: in std_logic_vector(7 downto 0);	--�������뵽״̬��������
			  DataReady   : in std_logic;								--����������״̬����֪ͨ
			  CpuDataReady: out std_logic;							--״̬�����뵽����
			  DataPath		: inout std_logic_vector(7 downto 0);--������״̬��֮���������
			  CpuRdn		  : in std_logic;								--������״̬����֪ͨ
			  CpuWrn      : in std_logic;								--������״̬����֪ͨ
			  CpuEnable	  :  in std_logic;							--������״̬���Ƿ���д
			  RamData	  : out std_logic_vector(7 downto 0);  --acsii��ram
			  RamDataReady: out std_logic;						--dataready��ram
			  RamRdn		  : in std_logic;								--ram��״̬����֪ͨ
			  KeyboardInterrupt   : in std_logic;					--�����ж�����
			  IFIDInterrupt		 : out std_logic;					--״̬���������ж�
			  checkbufferState    : out std_logic_vector(6 downto 0);
			  checkState			 : out std_logic_vector(6 downto 0);
			  testData				 : out std_logic_vector(7 downto 0);
			  shiftstate : in std_logic;
			  ctrlstate : in std_logic
			  );
end component;	

	signal keyBoardData : std_logic_vector(7 downto 0) := "00000000";
	signal dataReady : std_logic;
	signal scan_code : STD_LOGIC_VECTOR (7 downto 0)  := "00000000";
   signal check : STD_LOGIC_VECTOR(6 downto 0)  := "0000000";
	signal keyboard_out : std_logic;						
	signal check_2 : std_logic;
	signal CpuWrn      : std_logic;								--������״̬����֪ͨ
   signal  CpuEnable	  : std_logic;							--������״̬���Ƿ���д
	signal RamDataOut  : std_logic_vector(7 downto 0)  := "00000000";  --acsii��ram
   signal RamDataReadyOut: std_logic;						--dataready��ram
	signal RamRdn		  : std_logic;								--ram��״̬����֪ͨ
	signal KeyboardInterrupt   : std_logic;					--�����ж�����
   signal IFIDInterrupt		 : std_logic;					--״̬���������ж�
	signal Empty : STD_LOGIC_VECTOR(7 downto 0);
	signal RamDataOut_16 : std_logic_vector(15 downto 0);
	signal shiftstate : std_logic;
	signal ctrlstate : std_logic;
begin
	RamDataOut_16 <= "00000000" & RamDataOut;
	my_keyboard : 
		keyboard port map(
			datain => datain,
			clkin => clkin,
			fclk => testclk,
			rst => rdn,
			scan_code => scan_code,		--not use
			check => check,				--not use
			interrupt => interrupt, 	--not use
			interruptC => interruptC,	--not use
			keyboard_out => dataReady,
			check_2 => check_2,			--not use
			shiftstate => shiftstate,
			ctrlstate => ctrlstate,
			word => keyBoardData
			);
	
	myKeyBoardStateMachine :
		keyboardCpuRam port map (
			  clk50 => testclk,
			  rst	=> rst,
			  KeyBoardData => keyBoardData,						--�������뵽״̬��������
			  DataReady => dataReady,								--����������״̬����֪ͨ
			  CpuDataReady => CpuDataReady,						--״̬�����뵽���� not use
			  DataPath => ShowData,									--������״̬��֮���������
			  CpuRdn => rdn,											--������״̬����֪ͨ
			  CpuWrn => CpuWrn,										--������״̬����֪ͨ not use
			  CpuEnable => CpuEnable,								--������״̬���Ƿ���д not use
			  RamData	 => RamDataOut, 							--acsii��ram not use
			  RamDataReady	 => RamDataReadyOut,					--dataready��ram not use
			  RamRdn => RamRdn,										--ram��״̬����֪ͨ not use
			  KeyboardInterrupt => KeyboardInterrupt,			--�����ж����� not use
			  IFIDInterrupt => 	IFIDInterrupt,					--״̬���������ж� not use
			  checkState => showState,
			  checkbufferState => showBufferState,
			  testData => Empty,
			  shiftstate => shiftstate,
			  ctrlstate => ctrlstate
		);
	
	KBData <= RamDataOut_16;
	KBdata_ready <= RamDataReadyOut;
	RamRdn <= KBrdn;
	
end Behavioral;

