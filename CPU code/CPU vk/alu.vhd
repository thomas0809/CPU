library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constdef.ALL;

entity alu is
  port (
	REGDATA1: in std_logic_vector(15 downto 0);  --第一个寄存器数据
	REGDATA2: in std_logic_vector(15 downto 0); --第二个寄存器数据
	EXTENDIMM: in std_logic_vector(15 downto 0);  --扩展后的立即�
	LASTALU: in std_logic_vector(15 downto 0); --上一条指令ALU计算结果
	LASTMEM: in std_logic_vector(15 downto 0); --上两条指令MEM后的结果
	forwardA: in std_logic_vector(1 downto 0); --ALU第一个操作数冲突信号
	forwardB: in std_logic_vector(1 downto 0); --ALU第二个操作数冲突信号
	ALUSRCA: in std_logic_vector(1 downto 0); --ALU第一个操作数选择
	ALUSRCB: in std_logic; --ALU第二个操作数选择
	ALUOP: in std_logic_vector(3 downto 0); --ALU操作�
	PC: in std_logic_vector(15 downto 0); --PC�
	ALURES: out std_logic_vector(15 downto 0); --计算结果
	REGDATA : out std_logic_vector(15 downto 0);
	
	debug1: out std_logic_vector(15 downto 0);
	debug2: out std_logic_vector(15 downto 0)
  );
end alu;

architecture behavioral of alu is					--这里输出结果可能会在一开始不太稳定，但是最后应该是稳定�
	signal C, D: std_logic_vector(15 downto 0);
begin
	debug1 <= C;
	debug2 <= D;
	process(REGDATA1, LASTALU, LASTMEM, REGDATA2, PC, EXTENDIMM)
		variable A, B: std_logic_vector(15 downto 0);
	begin
		---选择第一个参数A
		case forwardA is
			when "00" => --REGDATA1
				A(15 downto 0) := REGDATA1;
			when "01" => --LASTALU
				A(15 downto 0) := LASTALU;
			when "10" => --LASTMEM
				A(15 downto 0) := LASTMEM;
			when others =>    
		end case;
	
		case forwardB is
			when "00" => --REGDATA2
				B(15 downto 0) := REGDATA2;
			when "01" => --LASTALU
				B(15 downto 0) := LASTALU;
			when "10" => --LASTMEM
				B(15 downto 0) := LASTMEM;
			when others =>  
		end case;
		---选择第二个参数B
		case ALUSRCA is
			when "00" => --REGDATA1
				C(15 downto 0) <= A;
			when "01" => --REGDATA2
				C(15 downto 0) <= B;
			when "10" => --PC
				C(15 downto 0) <= PC;
			when others => 
		end case;
		
		case ALUSRCB is
			when '1' => --REGDATA2
				D(15 downto 0) <= B;
			when '0' => --EXTENDIMM
				D(15 downto 0) <= EXTENDIMM;
			when others =>
		end case;
		REGDATA <= B;
	end process;
	---
	process (C, D, ALUOP)
		variable result : STD_LOGIC_VECTOR (15 downto 0);
		variable oflag : std_logic;
	begin
		oflag := '0';
		case ALUOP is
			when ALUOP_ADD =>
				ALURES(15 downto 0) <= C + D;
			when ALUOP_EMPTY =>
				
			when ALUOP_EQUAL =>
				if C = D then
					ALURES(15 downto 0) <= "0000000000000000";
				else 
					ALURES(15 downto 0) <= "0000000000000001";
				end if;
			when ALUOP_LESS =>
				result := C - D;
				if C(15) = '0' and D(15) = '1' and result(15) = '1' then
					oflag := '1';
				elsif C(15) = '1' and D(15) = '0' and result(15) = '0' then
					oflag := '1';
				end if;
				if C < D then
					if oflag = '1' then
						ALURES(15 downto 0) <= "0000000000000000";
					else
						ALURES(15 downto 0) <= "0000000000000001";
					end if;
				else
					if oflag = '1' then
						ALURES(15 downto 0) <= "0000000000000001";
					else
						ALURES(15 downto 0) <= "0000000000000000";
					end if;
				end if;	
			when ALUOP_ASSIGNA =>	-- ALUOP_ASSIGNA  输出为第一个操作数
				ALURES(15 downto 0) <= C;
			when ALUOP_ASSIGNB =>	-- ALUOP_ASSIGNB  输出为第二个操作�
				ALURES(15 downto 0) <= D;
			when ALUOP_AND =>		-- ALUOP_AND  
				ALURES(15 downto 0) <= C and D;
			when ALUOP_OR =>		-- ALUOP_OR
				ALURES(15 downto 0) <= C or D;
			when ALUOP_SLL =>		-- ALUOPSLL 第一个操作数左移第二个操作数位，注：第二个数�时左��
				if D = "0000000000000000" then
					ALURES(15 downto 0) <= to_stdlogicvector(to_bitvector(C) sll 8);
				else
					ALURES(15 downto 0) <= to_stdlogicvector(to_bitvector(C) sll conv_integer(D));
			end if;
			when ALUOP_SRA =>		-- ALUOPSRA
				if D = "0000000000000000" then
					ALURES(15 downto 0) <= to_stdlogicvector(to_bitvector(C) sra 8);
				else
					ALURES(15 downto 0) <= to_stdlogicvector(to_bitvector(C) sra conv_integer(D));
				end if;
			when ALUOP_SUB =>		-- SLUOPSUB
				ALURES(15 downto 0) <= C - D;
			when others =>
		end case;
	end process;
end behavioral;