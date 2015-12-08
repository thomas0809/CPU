--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package constdef is

	--ALUOP
	constant ALUOP_EMPTY : std_logic_vector(3 downto 0) := "0000";
	constant ALUOP_ADD : std_logic_vector(3 downto 0) := "0001";
	constant ALUOP_SUB : std_logic_vector(3 downto 0) := "0010";
	constant ALUOP_EQUAL : std_logic_vector(3 downto 0) := "0011";
	constant ALUOP_LESS : std_logic_vector(3 downto 0) := "0100";
	constant ALUOP_ASSIGNA : std_logic_vector(3 downto 0) := "0101";
	constant ALUOP_ASSIGNB : std_logic_vector(3 downto 0) := "0110";
	constant ALUOP_AND : std_logic_vector(3 downto 0) := "0111";
	constant ALUOP_OR : std_logic_vector(3 downto 0) := "1000";
	constant ALUOP_SLL : std_logic_vector(3 downto 0) := "1001";
	constant ALUOP_SRA : std_logic_vector(3 downto 0) := "1010";
	
	--INSTRUCTION OP
	constant ADDIU : std_logic_vector(4 downto 0) := "01001";  --ADDIU
	constant ADDIU3 : std_logic_vector(4 downto 0) := "01000";  --ADDIU3
	constant ADDSP_BTEQZ_MTSP : std_logic_vector(4 downto 0) := "01100";  --ADDSP MTSP BTEQZ
	constant ADD_SUB : std_logic_vector(4 downto 0) := "11100";  --ADDU SUBU
	constant AND_OR_MFPC_CMP_J : std_logic_vector(4 downto 0) := "11101";  --AND CMP JALR JR JRRA MFPC OR
	constant B : std_logic_vector(4 downto 0) := "00010";  --B
	constant BEQZ : std_logic_vector(4 downto 0) := "00100";  --BEQZ
	constant BNEZ : std_logic_vector(4 downto 0) := "00101";  --BNEZ
	constant CMPI : std_logic_vector(4 downto 0) := "01110";  --CMPI
	constant LI : std_logic_vector(4 downto 0) := "01101";  --LI
	constant LW : std_logic_vector(4 downto 0) := "10011";  --LW
	constant LW_SP : std_logic_vector(4 downto 0) := "10010";  --LW_SP
	constant MFTIH : std_logic_vector(4 downto 0) := "11110";  --MFIH MTIH
	constant MOVE : std_logic_vector(4 downto 0) := "01111";  --MOVE
	constant NOP_HEAD : std_logic_vector(4 downto 0) := "00001";  --NOP
	constant SLL_SRA : std_logic_vector(4 downto 0) := "00110";  --SLL SRA
	constant SLTI : std_logic_vector(4 downto 0) := "01010";  --SLTI
	constant SW : std_logic_vector(4 downto 0) := "11011";  --SW
	constant SW_SP : std_logic_vector(4 downto 0) := "11010";  --SW_SP
	constant INT : std_logic_vector(4 downto 0) := "11111";  --INT
	constant MFSP : std_logic_vector(4 downto 0):= "01011";  --MFSP

	constant NOP : std_logic_vector(15 downto 0) := "0000100000000000";
end constdef;

package body constdef is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end constdef;
