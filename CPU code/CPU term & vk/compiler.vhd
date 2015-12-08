library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compiler is
    Port ( sendbuffer : in  STD_LOGIC_VECTOR(159 downto 0);						--keyboarddata
           instruc : out STD_LOGIC_VECTOR(15 downto 0)
	  );
end compiler;

architecture Behavioral of compiler is
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
	constant DOWNCODE : std_logic_vector(7 downto 0) := "00010010";
	constant BKSPCODE : std_logic_vector(7 downto 0) := "01100110";
	constant ENTERCODE : std_logic_vector(7 downto 0) := "01011010";
	constant SPACECODE : std_logic_vector(7 downto 0) := "00101001";
	constant NOP : STD_LOGIC_VECTOR(15 downto 0) := "0000100000000000";
	signal instruction : std_logic_vector(15 downto 0);
begin
	instruc <= instruction;
process(sendbuffer)
begin
	case sendbuffer(7 downto 0) is
	when ACODE =>
		if sendbuffer(15 downto 8) = DCODE and sendbuffer(23 downto 16) = DCODE then
			case sendbuffer(31 downto 24) is
			when ICODE =>
				if sendbuffer(39 downto 32) = UCODE then
					if sendbuffer(47 downto 40) = SPACECODE then  --ADDIU
						instruction(15 downto 11) <= "01001";
						if sendbuffer(55 downto 48) = RCODE then
							case sendbuffer(63 downto 56) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
							end case;
								
							case sendbuffer(95 downto 88) is
								when ZEROCODE => instruction(7 downto 4) <= "0000";
								when ONECODE => instruction(7 downto 4) <= "0001";
								when TWOCODE => instruction(7 downto 4) <= "0010";
								when THREECODE => instruction(7 downto 4) <= "0011";
								when FOURCODE => instruction(7 downto 4) <= "0100";
								when FIVECODE => instruction(7 downto 4) <= "0101";
								when SIXCODE => instruction(7 downto 4) <= "0110";
								when SEVENCODE => instruction(7 downto 4) <= "0111";
								when EIGHTCODE => instruction(7 downto 4) <= "1000";
								when NINECODE => instruction(7 downto 4) <= "1001";
								when ACODE => instruction(7 downto 4) <= "1010";
								when BCODE => instruction(7 downto 4) <= "1011";
								when CCODE => instruction(7 downto 4) <= "1100";
								when DCODE => instruction(7 downto 4) <= "1101";
								when ECODE => instruction(7 downto 4) <= "1110";
								when FCODE => instruction(7 downto 4) <= "1111";
								when others => instruction <= (others => '1');
							end case;
							case sendbuffer(103 downto 96) is
								when ZEROCODE => instruction(3 downto 0) <= "0000";
								when ONECODE => instruction(3 downto 0) <= "0001";
								when TWOCODE => instruction(3 downto 0) <= "0010";
								when THREECODE => instruction(3 downto 0) <= "0011";
								when FOURCODE => instruction(3 downto 0) <= "0100";
								when FIVECODE => instruction(3 downto 0) <= "0101";
								when SIXCODE => instruction(3 downto 0) <= "0110";
								when SEVENCODE => instruction(3 downto 0) <= "0111";
								when EIGHTCODE => instruction(3 downto 0) <= "1000";
								when NINECODE => instruction(3 downto 0) <= "1001";
								when ACODE => instruction(3 downto 0) <= "1010";
								when BCODE => instruction(3 downto 0) <= "1011";
								when CCODE => instruction(3 downto 0) <= "1100";
								when DCODE => instruction(3 downto 0) <= "1101";
								when ECODE => instruction(3 downto 0) <= "1110";
								when FCODE => instruction(3 downto 0) <= "1111";
								when others => instruction <= (others => '1');
							end case;
						else
							instruction <= (others => '1');
						end if;
					elsif sendbuffer(47 downto 40) = THREECODE and sendbuffer(55 downto 48) = SPACECODE then --ADDIU3
						instruction(15 downto 11) <= "01000";
						instruction(4) <= '0';
						if sendbuffer(63 downto 56) = RCODE then
							case sendbuffer(71 downto 64) is
								when ZEROCODE => instruction(10 downto 8) <= "000";
								when ONECODE => instruction(10 downto 8) <= "001";
								when TWOCODE => instruction(10 downto 8) <= "010";
								when THREECODE => instruction(10 downto 8) <= "011";
								when FOURCODE => instruction(10 downto 8) <= "100";
								when FIVECODE => instruction(10 downto 8) <= "101";
								when SIXCODE => instruction(10 downto 8) <= "110";
								when SEVENCODE => instruction(10 downto 8) <= "111";
								when others => instruction <= (others => '1');
							end case;
							
							if sendbuffer(79 downto 72) = SPACECODE and sendbuffer(87 downto 80) = RCODE then
								case sendbuffer(95 downto 88) is
									when ZEROCODE => instruction(7 downto 5) <= "000";
									when ONECODE => instruction(7 downto 5) <= "001";
									when TWOCODE => instruction(7 downto 5) <= "010";
									when THREECODE => instruction(7 downto 5) <= "011";
									when FOURCODE => instruction(7 downto 5) <= "100";
									when FIVECODE => instruction(7 downto 5) <= "101";
									when SIXCODE => instruction(7 downto 5) <= "110";
									when SEVENCODE => instruction(7 downto 5) <= "111";
									when others => instruction <= (others => '1');
								end case;

								case sendbuffer(135 downto 128) is
									when ZEROCODE => instruction(3 downto 0) <= "0000";
									when ONECODE => instruction(3 downto 0) <= "0001";
									when TWOCODE => instruction(3 downto 0) <= "0010";
									when THREECODE => instruction(3 downto 0) <= "0011";
									when FOURCODE => instruction(3 downto 0) <= "0100";
									when FIVECODE => instruction(3 downto 0) <= "0101";
									when SIXCODE => instruction(3 downto 0) <= "0110";
									when SEVENCODE => instruction(3 downto 0) <= "0111";
									when EIGHTCODE => instruction(3 downto 0) <= "1000";
									when NINECODE => instruction(3 downto 0) <= "1001";
									when ACODE => instruction(3 downto 0) <= "1010";
									when BCODE => instruction(3 downto 0) <= "1011";
									when CCODE => instruction(3 downto 0) <= "1100";
									when DCODE => instruction(3 downto 0) <= "1101";
									when ECODE => instruction(3 downto 0) <= "1110";
									when FCODE => instruction(3 downto 0) <= "1111";
									when others => instruction <= (others => '1');
								end case;
							else
								instruction <= (others => '1');
							end if;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;
				end if;
			when SCODE =>
				if sendbuffer(39 downto 32) = PCODE and sendbuffer(47 downto 40) = SPACECODE then --ADDSP
					instruction(15 downto 8) <= "01100011";
					case sendbuffer(71 downto 64) is
						when ZEROCODE => instruction(7 downto 4) <= "0000";
						when ONECODE => instruction(7 downto 4) <= "0001";
						when TWOCODE => instruction(7 downto 4) <= "0010";
						when THREECODE => instruction(7 downto 4) <= "0011";
						when FOURCODE => instruction(7 downto 4) <= "0100";
						when FIVECODE => instruction(7 downto 4) <= "0101";
						when SIXCODE => instruction(7 downto 4) <= "0110";
						when SEVENCODE => instruction(7 downto 4) <= "0111";
						when EIGHTCODE => instruction(7 downto 4) <= "1000";
						when NINECODE => instruction(7 downto 4) <= "1001";
						when ACODE => instruction(7 downto 4) <= "1010";
						when BCODE => instruction(7 downto 4) <= "1011";
						when CCODE => instruction(7 downto 4) <= "1100";
						when DCODE => instruction(7 downto 4) <= "1101";
						when ECODE => instruction(7 downto 4) <= "1110";
						when FCODE => instruction(7 downto 4) <= "1111";
						when others => instruction <= (others => '1');
					end case;
					case sendbuffer(79 downto 72) is
						when ZEROCODE => instruction(3 downto 0) <= "0000";
						when ONECODE => instruction(3 downto 0) <= "0001";
						when TWOCODE => instruction(3 downto 0) <= "0010";
						when THREECODE => instruction(3 downto 0) <= "0011";
						when FOURCODE => instruction(3 downto 0) <= "0100";
						when FIVECODE => instruction(3 downto 0) <= "0101";
						when SIXCODE => instruction(3 downto 0) <= "0110";
						when SEVENCODE => instruction(3 downto 0) <= "0111";
						when EIGHTCODE => instruction(3 downto 0) <= "1000";
						when NINECODE => instruction(3 downto 0) <= "1001";
						when ACODE => instruction(3 downto 0) <= "1010";
						when BCODE => instruction(3 downto 0) <= "1011";
						when CCODE => instruction(3 downto 0) <= "1100";
						when DCODE => instruction(3 downto 0) <= "1101";
						when ECODE => instruction(3 downto 0) <= "1110";
						when FCODE => instruction(3 downto 0) <= "1111";
						when others => instruction <= (others => '1');
					end case;
				else
					instruction <= (others => '1');
				end if;
			when UCODE =>
				if sendbuffer(39 downto 32) = SPACECODE then --ADDU
					instruction(15 downto 11) <= "11100";
					instruction(1 downto 0 ) <= "01";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						if sendbuffer(71 downto 64) = RCODE then
							case sendbuffer(79 downto 72) is
								when ZEROCODE => instruction(7 downto 5) <= "000";
								when ONECODE => instruction(7 downto 5) <= "001";
								when TWOCODE => instruction(7 downto 5) <= "010";
								when THREECODE => instruction(7 downto 5) <= "011";
								when FOURCODE => instruction(7 downto 5) <= "100";
								when FIVECODE => instruction(7 downto 5) <= "101";
								when SIXCODE => instruction(7 downto 5) <= "110";
								when SEVENCODE => instruction(7 downto 5) <= "111";
								when others => instruction <= (others => '1');
							end case;
							if sendbuffer(95 downto 88) = RCODE then
								case sendbuffer(103 downto 96) is
									when ZEROCODE => instruction(4 downto 2) <= "000";
									when ONECODE => instruction(4 downto 2) <= "001";
									when TWOCODE => instruction(4 downto 2) <= "010";
									when THREECODE => instruction(4 downto 2) <= "011";
									when FOURCODE => instruction(4 downto 2) <= "100";
									when FIVECODE => instruction(4 downto 2) <= "101";
									when SIXCODE => instruction(4 downto 2) <= "110";
									when SEVENCODE => instruction(4 downto 2) <= "111";
									when others => instruction <= (others => '1');
								end case;
							else
								instruction <= (others => '1');
							end if;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when others =>
				instruction <= (others => '1');
		end case;
		elsif sendbuffer(15 downto 8) = NCODE and sendbuffer(23 downto 16) = DCODE and sendbuffer(31 downto 24) = SPACECODE then --AND
			instruction(15 downto 11) <= "11101";
			instruction(4 downto 0) <= "01100";
			if sendbuffer(39 downto 32) = RCODE then
				case sendbuffer(47 downto 40) is
					when ZEROCODE => instruction(10 downto 8) <= "000";
					when ONECODE => instruction(10 downto 8) <= "001";
					when TWOCODE => instruction(10 downto 8) <= "010";
					when THREECODE => instruction(10 downto 8) <= "011";
					when FOURCODE => instruction(10 downto 8) <= "100";
					when FIVECODE => instruction(10 downto 8) <= "101";
					when SIXCODE => instruction(10 downto 8) <= "110";
					when SEVENCODE => instruction(10 downto 8) <= "111";
					when others => instruction <= (others => '1');
				end case;
				if sendbuffer(55 downto 48) = SPACECODE and sendbuffer(63 downto 56) = RCODE then
					case sendbuffer(71 downto 64) is
						when ZEROCODE => instruction(7 downto 5) <= "000";
						when ONECODE => instruction(7 downto 5) <= "001";
						when TWOCODE => instruction(7 downto 5) <= "010";
						when THREECODE => instruction(7 downto 5) <= "011";
						when FOURCODE => instruction(7 downto 5) <= "100";
						when FIVECODE => instruction(7 downto 5) <= "101";
						when SIXCODE => instruction(7 downto 5) <= "110";
						when SEVENCODE => instruction(7 downto 5) <= "111";
						when others => instruction <= (others => '1');
					end case;
				else
					instruction <= (others => '1');
				end if;
			else
				instruction <= (others => '1');
			end if;
		else
			instruction <= (others => '1');
		end if;

	when BCODE =>
		case sendbuffer(15 downto 8) is
			when SPACECODE => --B
				instruction(15 downto 11) <= "00010";
				case sendbuffer(31 downto 24) is
					when ZEROCODE => instruction(10 downto 8) <= "000";
					when ONECODE => instruction(10 downto 8) <= "001";
					when TWOCODE => instruction(10 downto 8) <= "010";
					when THREECODE => instruction(10 downto 8) <= "011";
					when FOURCODE => instruction(10 downto 8) <= "100";
					when FIVECODE => instruction(10 downto 8) <= "101";
					when SIXCODE => instruction(10 downto 8) <= "110";
					when SEVENCODE => instruction(10 downto 8) <= "111";
					when others => instruction <= (others => '1');
				end case;
				case sendbuffer(39 downto 32) is
					when ZEROCODE => instruction(7 downto 4) <= "0000";
					when ONECODE => instruction(7 downto 4) <= "0001";
					when TWOCODE => instruction(7 downto 4) <= "0010";
					when THREECODE => instruction(7 downto 4) <= "0011";
					when FOURCODE => instruction(7 downto 4) <= "0100";
					when FIVECODE => instruction(7 downto 4) <= "0101";
					when SIXCODE => instruction(7 downto 4) <= "0110";
					when SEVENCODE => instruction(7 downto 4) <= "0111";
					when EIGHTCODE => instruction(7 downto 4) <= "1000";
					when NINECODE => instruction(7 downto 4) <= "1001";
					when ACODE => instruction(7 downto 4) <= "1010";
					when BCODE => instruction(7 downto 4) <= "1011";
					when CCODE => instruction(7 downto 4) <= "1100";
					when DCODE => instruction(7 downto 4) <= "1101";
					when ECODE => instruction(7 downto 4) <= "1110";
					when FCODE => instruction(7 downto 4) <= "1111";
					when others => instruction <= (others => '1');
				end case;
				case sendbuffer(47 downto 40) is
					when ZEROCODE => instruction(3 downto 0) <= "0000";
					when ONECODE => instruction(3 downto 0) <= "0001";
					when TWOCODE => instruction(3 downto 0) <= "0010";
					when THREECODE => instruction(3 downto 0) <= "0011";
					when FOURCODE => instruction(3 downto 0) <= "0100";
					when FIVECODE => instruction(3 downto 0) <= "0101";
					when SIXCODE => instruction(3 downto 0) <= "0110";
					when SEVENCODE => instruction(3 downto 0) <= "0111";
					when EIGHTCODE => instruction(3 downto 0) <= "1000";
					when NINECODE => instruction(3 downto 0) <= "1001";
					when ACODE => instruction(3 downto 0) <= "1010";
					when BCODE => instruction(3 downto 0) <= "1011";
					when CCODE => instruction(3 downto 0) <= "1100";
					when DCODE => instruction(3 downto 0) <= "1101";
					when ECODE => instruction(3 downto 0) <= "1110";
					when FCODE => instruction(3 downto 0) <= "1111";
					when others => instruction <= (others => '1');
				end case;
			when ECODE =>
				if sendbuffer(23 downto 16) = QCODE and sendbuffer(31 downto 24) = ZCODE and sendbuffer(39 downto 32) = SPACECODE then --BEQZ
					instruction(15 downto 11) <= "00100";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(87 downto 80) is
							when ZEROCODE => instruction(7 downto 4) <= "0000";
							when ONECODE => instruction(7 downto 4) <= "0001";
							when TWOCODE => instruction(7 downto 4) <= "0010";
							when THREECODE => instruction(7 downto 4) <= "0011";
							when FOURCODE => instruction(7 downto 4) <= "0100";
							when FIVECODE => instruction(7 downto 4) <= "0101";
							when SIXCODE => instruction(7 downto 4) <= "0110";
							when SEVENCODE => instruction(7 downto 4) <= "0111";
							when EIGHTCODE => instruction(7 downto 4) <= "1000";
							when NINECODE => instruction(7 downto 4) <= "1001";
							when ACODE => instruction(7 downto 4) <= "1010";
							when BCODE => instruction(7 downto 4) <= "1011";
							when CCODE => instruction(7 downto 4) <= "1100";
							when DCODE => instruction(7 downto 4) <= "1101";
							when ECODE => instruction(7 downto 4) <= "1110";
							when FCODE => instruction(7 downto 4) <= "1111";
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(95 downto 88) is
							when ZEROCODE => instruction(3 downto 0) <= "0000";
							when ONECODE => instruction(3 downto 0) <= "0001";
							when TWOCODE => instruction(3 downto 0) <= "0010";
							when THREECODE => instruction(3 downto 0) <= "0011";
							when FOURCODE => instruction(3 downto 0) <= "0100";
							when FIVECODE => instruction(3 downto 0) <= "0101";
							when SIXCODE => instruction(3 downto 0) <= "0110";
							when SEVENCODE => instruction(3 downto 0) <= "0111";
							when EIGHTCODE => instruction(3 downto 0) <= "1000";
							when NINECODE => instruction(3 downto 0) <= "1001";
							when ACODE => instruction(3 downto 0) <= "1010";
							when BCODE => instruction(3 downto 0) <= "1011";
							when CCODE => instruction(3 downto 0) <= "1100";
							when DCODE => instruction(3 downto 0) <= "1101";
							when ECODE => instruction(3 downto 0) <= "1110";
							when FCODE => instruction(3 downto 0) <= "1111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when NCODE =>
				if sendbuffer(23 downto 16) = ECODE and sendbuffer(31 downto 24) = ZCODE and sendbuffer(39 downto 32) = SPACECODE then --BNEZ
					instruction(15 downto 11) <= "00101";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(87 downto 80) is
							when ZEROCODE => instruction(7 downto 4) <= "0000";
							when ONECODE => instruction(7 downto 4) <= "0001";
							when TWOCODE => instruction(7 downto 4) <= "0010";
							when THREECODE => instruction(7 downto 4) <= "0011";
							when FOURCODE => instruction(7 downto 4) <= "0100";
							when FIVECODE => instruction(7 downto 4) <= "0101";
							when SIXCODE => instruction(7 downto 4) <= "0110";
							when SEVENCODE => instruction(7 downto 4) <= "0111";
							when EIGHTCODE => instruction(7 downto 4) <= "1000";
							when NINECODE => instruction(7 downto 4) <= "1001";
							when ACODE => instruction(7 downto 4) <= "1010";
							when BCODE => instruction(7 downto 4) <= "1011";
							when CCODE => instruction(7 downto 4) <= "1100";
							when DCODE => instruction(7 downto 4) <= "1101";
							when ECODE => instruction(7 downto 4) <= "1110";
							when FCODE => instruction(7 downto 4) <= "1111";
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(95 downto 88) is
							when ZEROCODE => instruction(3 downto 0) <= "0000";
							when ONECODE => instruction(3 downto 0) <= "0001";
							when TWOCODE => instruction(3 downto 0) <= "0010";
							when THREECODE => instruction(3 downto 0) <= "0011";
							when FOURCODE => instruction(3 downto 0) <= "0100";
							when FIVECODE => instruction(3 downto 0) <= "0101";
							when SIXCODE => instruction(3 downto 0) <= "0110";
							when SEVENCODE => instruction(3 downto 0) <= "0111";
							when EIGHTCODE => instruction(3 downto 0) <= "1000";
							when NINECODE => instruction(3 downto 0) <= "1001";
							when ACODE => instruction(3 downto 0) <= "1010";
							when BCODE => instruction(3 downto 0) <= "1011";
							when CCODE => instruction(3 downto 0) <= "1100";
							when DCODE => instruction(3 downto 0) <= "1101";
							when ECODE => instruction(3 downto 0) <= "1110";
							when FCODE => instruction(3 downto 0) <= "1111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when TCODE =>
				if sendbuffer(23 downto 16) = ECODE and sendbuffer(31 downto 24) = QCODE and sendbuffer(39 downto 32) = ZCODE and sendbuffer(47 downto 40) = SPACECODE then --BNEZ
					instruction(15 downto 8) <= "01100000";
					case sendbuffer(71 downto 64) is
						when ZEROCODE => instruction(7 downto 4) <= "0000";
						when ONECODE => instruction(7 downto 4) <= "0001";
						when TWOCODE => instruction(7 downto 4) <= "0010";
						when THREECODE => instruction(7 downto 4) <= "0011";
						when FOURCODE => instruction(7 downto 4) <= "0100";
						when FIVECODE => instruction(7 downto 4) <= "0101";
						when SIXCODE => instruction(7 downto 4) <= "0110";
						when SEVENCODE => instruction(7 downto 4) <= "0111";
						when EIGHTCODE => instruction(7 downto 4) <= "1000";
						when NINECODE => instruction(7 downto 4) <= "1001";
						when ACODE => instruction(7 downto 4) <= "1010";
						when BCODE => instruction(7 downto 4) <= "1011";
						when CCODE => instruction(7 downto 4) <= "1100";
						when DCODE => instruction(7 downto 4) <= "1101";
						when ECODE => instruction(7 downto 4) <= "1110";
						when FCODE => instruction(7 downto 4) <= "1111";
						when others => instruction <= (others => '1');
					end case;
					case sendbuffer(79 downto 72) is
						when ZEROCODE => instruction(3 downto 0) <= "0000";
						when ONECODE => instruction(3 downto 0) <= "0001";
						when TWOCODE => instruction(3 downto 0) <= "0010";
						when THREECODE => instruction(3 downto 0) <= "0011";
						when FOURCODE => instruction(3 downto 0) <= "0100";
						when FIVECODE => instruction(3 downto 0) <= "0101";
						when SIXCODE => instruction(3 downto 0) <= "0110";
						when SEVENCODE => instruction(3 downto 0) <= "0111";
						when EIGHTCODE => instruction(3 downto 0) <= "1000";
						when NINECODE => instruction(3 downto 0) <= "1001";
						when ACODE => instruction(3 downto 0) <= "1010";
						when BCODE => instruction(3 downto 0) <= "1011";
						when CCODE => instruction(3 downto 0) <= "1100";
						when DCODE => instruction(3 downto 0) <= "1101";
						when ECODE => instruction(3 downto 0) <= "1110";
						when FCODE => instruction(3 downto 0) <= "1111";
						when others => instruction <= (others => '1');
					end case;
				else
					instruction <= (others => '1');
				end if;
			when others =>
				instruction <= (others => '1');
		end case;

	when CCODE =>
		if sendbuffer(15 downto 8) = MCODE and sendbuffer(23 downto 16) = PCODE then
			if sendbuffer(31 downto 24) = SPACECODE then --CMP
				instruction(15 downto 11) <= "11101";
				instruction(4 downto 0) <= "01010";
				if sendbuffer(39 downto 32) = RCODE then
					case sendbuffer(47 downto 40) is
						when ZEROCODE => instruction(10 downto 8) <= "000";
						when ONECODE => instruction(10 downto 8) <= "001";
						when TWOCODE => instruction(10 downto 8) <= "010";
						when THREECODE => instruction(10 downto 8) <= "011";
						when FOURCODE => instruction(10 downto 8) <= "100";
						when FIVECODE => instruction(10 downto 8) <= "101";
						when SIXCODE => instruction(10 downto 8) <= "110";
						when SEVENCODE => instruction(10 downto 8) <= "111";
						when others => instruction <= (others => '1');
					end case;
					if sendbuffer(55 downto 48) = SPACECODE and sendbuffer(63 downto 56) = RCODE then
						case sendbuffer(71 downto 64) is
							when ZEROCODE => instruction(7 downto 5) <= "000";
							when ONECODE => instruction(7 downto 5) <= "001";
							when TWOCODE => instruction(7 downto 5) <= "010";
							when THREECODE => instruction(7 downto 5) <= "011";
							when FOURCODE => instruction(7 downto 5) <= "100";
							when FIVECODE => instruction(7 downto 5) <= "101";
							when SIXCODE => instruction(7 downto 5) <= "110";
							when SEVENCODE => instruction(7 downto 5) <= "111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			elsif sendbuffer(31 downto 24) = ICODE and sendbuffer(39 downto 32) = SPACECODE then --CMPI
				instruction(15 downto 11) <= "01110";
				if sendbuffer(47 downto 40) = RCODE then
					case sendbuffer(55 downto 48) is
						when ZEROCODE => instruction(10 downto 8) <= "000";
						when ONECODE => instruction(10 downto 8) <= "001";
						when TWOCODE => instruction(10 downto 8) <= "010";
						when THREECODE => instruction(10 downto 8) <= "011";
						when FOURCODE => instruction(10 downto 8) <= "100";
						when FIVECODE => instruction(10 downto 8) <= "101";
						when SIXCODE => instruction(10 downto 8) <= "110";
						when SEVENCODE => instruction(10 downto 8) <= "111";
						when others => instruction <= (others => '1');
					end case;
					case sendbuffer(87 downto 80) is
						when ZEROCODE => instruction(7 downto 4) <= "0000";
						when ONECODE => instruction(7 downto 4) <= "0001";
						when TWOCODE => instruction(7 downto 4) <= "0010";
						when THREECODE => instruction(7 downto 4) <= "0011";
						when FOURCODE => instruction(7 downto 4) <= "0100";
						when FIVECODE => instruction(7 downto 4) <= "0101";
						when SIXCODE => instruction(7 downto 4) <= "0110";
						when SEVENCODE => instruction(7 downto 4) <= "0111";
						when EIGHTCODE => instruction(7 downto 4) <= "1000";
						when NINECODE => instruction(7 downto 4) <= "1001";
						when ACODE => instruction(7 downto 4) <= "1010";
						when BCODE => instruction(7 downto 4) <= "1011";
						when CCODE => instruction(7 downto 4) <= "1100";
						when DCODE => instruction(7 downto 4) <= "1101";
						when ECODE => instruction(7 downto 4) <= "1110";
						when FCODE => instruction(7 downto 4) <= "1111";
						when others => instruction <= (others => '1');
					end case;
					case sendbuffer(95 downto 88) is
						when ZEROCODE => instruction(3 downto 0) <= "0000";
						when ONECODE => instruction(3 downto 0) <= "0001";
						when TWOCODE => instruction(3 downto 0) <= "0010";
						when THREECODE => instruction(3 downto 0) <= "0011";
						when FOURCODE => instruction(3 downto 0) <= "0100";
						when FIVECODE => instruction(3 downto 0) <= "0101";
						when SIXCODE => instruction(3 downto 0) <= "0110";
						when SEVENCODE => instruction(3 downto 0) <= "0111";
						when EIGHTCODE => instruction(3 downto 0) <= "1000";
						when NINECODE => instruction(3 downto 0) <= "1001";
						when ACODE => instruction(3 downto 0) <= "1010";
						when BCODE => instruction(3 downto 0) <= "1011";
						when CCODE => instruction(3 downto 0) <= "1100";
						when DCODE => instruction(3 downto 0) <= "1101";
						when ECODE => instruction(3 downto 0) <= "1110";
						when FCODE => instruction(3 downto 0) <= "1111";
						when others => instruction <= (others => '1');
					end case;
				else
					instruction <= (others => '1');
				end if;
			else
				instruction <= (others => '1');
			end if;
		else
			instruction <= (others => '1');
		end if;
	
	when ICODE =>
		if sendbuffer(15 downto 8) = NCODE and sendbuffer(23 downto 16) = TCODE and sendbuffer(31 downto 24) = SPACECODE then --INT
			instruction(15 downto 4) <= "111110000000";
			case sendbuffer(63 downto 56) is
				when ZEROCODE => instruction(3 downto 0) <= "0000";
				when ONECODE => instruction(3 downto 0) <= "0001";
				when TWOCODE => instruction(3 downto 0) <= "0010";
				when THREECODE => instruction(3 downto 0) <= "0011";
				when FOURCODE => instruction(3 downto 0) <= "0100";
				when FIVECODE => instruction(3 downto 0) <= "0101";
				when SIXCODE => instruction(3 downto 0) <= "0110";
				when SEVENCODE => instruction(3 downto 0) <= "0111";
				when EIGHTCODE => instruction(3 downto 0) <= "1000";
				when NINECODE => instruction(3 downto 0) <= "1001";
				when ACODE => instruction(3 downto 0) <= "1010";
				when BCODE => instruction(3 downto 0) <= "1011";
				when CCODE => instruction(3 downto 0) <= "1100";
				when DCODE => instruction(3 downto 0) <= "1101";
				when ECODE => instruction(3 downto 0) <= "1110";
				when FCODE => instruction(3 downto 0) <= "1111";
				when others => instruction <= (others => '1');
			end case;
		else
			instruction <= (others => '1');
		end if;
	when JCODE =>
		if sendbuffer(15 downto 8) = ACODE and sendbuffer(23 downto 16) = LCODE and sendbuffer(31 downto 24) = RCODE and sendbuffer(39 downto 32) = SPACECODE then --JALR
			instruction(15 downto 11) <= "11101";
			instruction(7 downto 0) <= "11000000";
			if sendbuffer(47 downto 40) = RCODE then
				case sendbuffer(55 downto 48) is
					when ZEROCODE => instruction(10 downto 8) <= "000";
					when ONECODE => instruction(10 downto 8) <= "001";
					when TWOCODE => instruction(10 downto 8) <= "010";
					when THREECODE => instruction(10 downto 8) <= "011";
					when FOURCODE => instruction(10 downto 8) <= "100";
					when FIVECODE => instruction(10 downto 8) <= "101";
					when SIXCODE => instruction(10 downto 8) <= "110";
					when SEVENCODE => instruction(10 downto 8) <= "111";
					when others => instruction <= (others => '1');
				end case;
			else
				instruction <= (others => '1');
			end if;
		elsif sendbuffer(15 downto 8) = RCODE then
			if sendbuffer(23 downto 16) = SPACECODE then --JR
				instruction(15 downto 11) <= "11101";
				instruction(7 downto 0) <= "00000000";
				if sendbuffer(31 downto 24) = RCODE then
					case sendbuffer(39 downto 32) is
						when ZEROCODE => instruction(10 downto 8) <= "000";
						when ONECODE => instruction(10 downto 8) <= "001";
						when TWOCODE => instruction(10 downto 8) <= "010";
						when THREECODE => instruction(10 downto 8) <= "011";
						when FOURCODE => instruction(10 downto 8) <= "100";
						when FIVECODE => instruction(10 downto 8) <= "101";
						when SIXCODE => instruction(10 downto 8) <= "110";
						when SEVENCODE => instruction(10 downto 8) <= "111";
						when others => instruction <= (others => '1');
					end case;
				else
					instruction <= (others => '1');
				end if;
			elsif sendbuffer(23 downto 16) = RCODE and sendbuffer(31 downto 24) = ACODE then --JRRA
				instruction <= "1110100000100000";
			else
				instruction <= (others => '1');
			end if;
		else
			instruction <= (others => '1');
		end if;

	when LCODE =>
		if sendbuffer(15 downto 8) = ICODE and sendbuffer(23 downto 16) = SPACECODE then --LI
			instruction(15 downto 11) <= "01101";
			if sendbuffer(31 downto 24) = RCODE then
				case sendbuffer(39 downto 32) is
					when ZEROCODE => instruction(10 downto 8) <= "000";
					when ONECODE => instruction(10 downto 8) <= "001";
					when TWOCODE => instruction(10 downto 8) <= "010";
					when THREECODE => instruction(10 downto 8) <= "011";
					when FOURCODE => instruction(10 downto 8) <= "100";
					when FIVECODE => instruction(10 downto 8) <= "101";
					when SIXCODE => instruction(10 downto 8) <= "110";
					when SEVENCODE => instruction(10 downto 8) <= "111";
					when others => instruction <= (others => '1');
				end case;
				
				case sendbuffer(71 downto 64) is
					when ZEROCODE => instruction(7 downto 4) <= "0000";
					when ONECODE => instruction(7 downto 4) <= "0001";
					when TWOCODE => instruction(7 downto 4) <= "0010";
					when THREECODE => instruction(7 downto 4) <= "0011";
					when FOURCODE => instruction(7 downto 4) <= "0100";
					when FIVECODE => instruction(7 downto 4) <= "0101";
					when SIXCODE => instruction(7 downto 4) <= "0110";
					when SEVENCODE => instruction(7 downto 4) <= "0111";
					when EIGHTCODE => instruction(7 downto 4) <= "1000";
					when NINECODE => instruction(7 downto 4) <= "1001";
					when ACODE => instruction(7 downto 4) <= "1010";
					when BCODE => instruction(7 downto 4) <= "1011";
					when CCODE => instruction(7 downto 4) <= "1100";
					when DCODE => instruction(7 downto 4) <= "1101";
					when ECODE => instruction(7 downto 4) <= "1110";
					when FCODE => instruction(7 downto 4) <= "1111";
					when others => instruction <= (others => '1');
				end case;
				case sendbuffer(79 downto 72) is
					when ZEROCODE => instruction(3 downto 0) <= "0000";
					when ONECODE => instruction(3 downto 0) <= "0001";
					when TWOCODE => instruction(3 downto 0) <= "0010";
					when THREECODE => instruction(3 downto 0) <= "0011";
					when FOURCODE => instruction(3 downto 0) <= "0100";
					when FIVECODE => instruction(3 downto 0) <= "0101";
					when SIXCODE => instruction(3 downto 0) <= "0110";
					when SEVENCODE => instruction(3 downto 0) <= "0111";
					when EIGHTCODE => instruction(3 downto 0) <= "1000";
					when NINECODE => instruction(3 downto 0) <= "1001";
					when ACODE => instruction(3 downto 0) <= "1010";
					when BCODE => instruction(3 downto 0) <= "1011";
					when CCODE => instruction(3 downto 0) <= "1100";
					when DCODE => instruction(3 downto 0) <= "1101";
					when ECODE => instruction(3 downto 0) <= "1110";
					when FCODE => instruction(3 downto 0) <= "1111";
					when others => instruction <= (others => '1');
				end case;
				
			else
				instruction <= (others => '1');
			end if;
		elsif sendbuffer(15 downto 8) = WCODE then
			if sendbuffer(23 downto 16) = SPACECODE then --LW
				instruction(15 downto 11) <= "10011";
				if sendbuffer(31 downto 24) = RCODE then
					case sendbuffer(39 downto 32) is
						when ZEROCODE => instruction(10 downto 8) <= "000";
						when ONECODE => instruction(10 downto 8) <= "001";
						when TWOCODE => instruction(10 downto 8) <= "010";
						when THREECODE => instruction(10 downto 8) <= "011";
						when FOURCODE => instruction(10 downto 8) <= "100";
						when FIVECODE => instruction(10 downto 8) <= "101";
						when SIXCODE => instruction(10 downto 8) <= "110";
						when SEVENCODE => instruction(10 downto 8) <= "111";
						when others => instruction <= (others => '1');
					end case;
					if sendbuffer(47 downto 40) = SPACECODE and sendbuffer(55 downto 48) = RCODE then
						case sendbuffer(63 downto 56) is
							when ZEROCODE => instruction(7 downto 5) <= "000";
							when ONECODE => instruction(7 downto 5) <= "001";
							when TWOCODE => instruction(7 downto 5) <= "010";
							when THREECODE => instruction(7 downto 5) <= "011";
							when FOURCODE => instruction(7 downto 5) <= "100";
							when FIVECODE => instruction(7 downto 5) <= "101";
							when SIXCODE => instruction(7 downto 5) <= "110";
							when SEVENCODE => instruction(7 downto 5) <= "111";
							when others => instruction <= (others => '1');
						end case;

						case sendbuffer(95 downto 88) is
							when ZEROCODE => instruction(4) <= '0';
							when ONECODE => instruction(4) <= '1';
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(103 downto 96) is
							when ZEROCODE => instruction(3 downto 0) <= "0000";
							when ONECODE => instruction(3 downto 0) <= "0001";
							when TWOCODE => instruction(3 downto 0) <= "0010";
							when THREECODE => instruction(3 downto 0) <= "0011";
							when FOURCODE => instruction(3 downto 0) <= "0100";
							when FIVECODE => instruction(3 downto 0) <= "0101";
							when SIXCODE => instruction(3 downto 0) <= "0110";
							when SEVENCODE => instruction(3 downto 0) <= "0111";
							when EIGHTCODE => instruction(3 downto 0) <= "1000";
							when NINECODE => instruction(3 downto 0) <= "1001";
							when ACODE => instruction(3 downto 0) <= "1010";
							when BCODE => instruction(3 downto 0) <= "1011";
							when CCODE => instruction(3 downto 0) <= "1100";
							when DCODE => instruction(3 downto 0) <= "1101";
							when ECODE => instruction(3 downto 0) <= "1110";
							when FCODE => instruction(3 downto 0) <= "1111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			elsif sendbuffer(23 downto 16) = DOWNCODE and sendbuffer(31 downto 24) = SCODE and sendbuffer(39 downto 32) = PCODE and sendbuffer(47 downto 40) = SPACECODE then --LW_SP
				instruction(15 downto 11) <= "10010";
				if sendbuffer(55 downto 48) = RCODE then
					case sendbuffer(63 downto 56) is
						when ZEROCODE => instruction(10 downto 8) <= "000";
						when ONECODE => instruction(10 downto 8) <= "001";
						when TWOCODE => instruction(10 downto 8) <= "010";
						when THREECODE => instruction(10 downto 8) <= "011";
						when FOURCODE => instruction(10 downto 8) <= "100";
						when FIVECODE => instruction(10 downto 8) <= "101";
						when SIXCODE => instruction(10 downto 8) <= "110";
						when SEVENCODE => instruction(10 downto 8) <= "111";
						when others => instruction <= (others => '1');
					end case;
					
					case sendbuffer(95 downto 88) is
						when ZEROCODE => instruction(7 downto 4) <= "0000";
						when ONECODE => instruction(7 downto 4) <= "0001";
						when TWOCODE => instruction(7 downto 4) <= "0010";
						when THREECODE => instruction(7 downto 4) <= "0011";
						when FOURCODE => instruction(7 downto 4) <= "0100";
						when FIVECODE => instruction(7 downto 4) <= "0101";
						when SIXCODE => instruction(7 downto 4) <= "0110";
						when SEVENCODE => instruction(7 downto 4) <= "0111";
						when EIGHTCODE => instruction(7 downto 4) <= "1000";
						when NINECODE => instruction(7 downto 4) <= "1001";
						when ACODE => instruction(7 downto 4) <= "1010";
						when BCODE => instruction(7 downto 4) <= "1011";
						when CCODE => instruction(7 downto 4) <= "1100";
						when DCODE => instruction(7 downto 4) <= "1101";
						when ECODE => instruction(7 downto 4) <= "1110";
						when FCODE => instruction(7 downto 4) <= "1111";
						when others => instruction <= (others => '1');
					end case;
					case sendbuffer(103 downto 96) is
						when ZEROCODE => instruction(3 downto 0) <= "0000";
						when ONECODE => instruction(3 downto 0) <= "0001";
						when TWOCODE => instruction(3 downto 0) <= "0010";
						when THREECODE => instruction(3 downto 0) <= "0011";
						when FOURCODE => instruction(3 downto 0) <= "0100";
						when FIVECODE => instruction(3 downto 0) <= "0101";
						when SIXCODE => instruction(3 downto 0) <= "0110";
						when SEVENCODE => instruction(3 downto 0) <= "0111";
						when EIGHTCODE => instruction(3 downto 0) <= "1000";
						when NINECODE => instruction(3 downto 0) <= "1001";
						when ACODE => instruction(3 downto 0) <= "1010";
						when BCODE => instruction(3 downto 0) <= "1011";
						when CCODE => instruction(3 downto 0) <= "1100";
						when DCODE => instruction(3 downto 0) <= "1101";
						when ECODE => instruction(3 downto 0) <= "1110";
						when FCODE => instruction(3 downto 0) <= "1111";
						when others => instruction <= (others => '1');
					end case;
					
				else
					instruction <= (others => '1');
				end if;
			else
				instruction <= (others => '1');
			end if;

		else
			instruction <= (others => '1');
		end if;

	when MCODE =>
		case sendbuffer(15 downto 8) is
			when FCODE =>
				if sendbuffer(23 downto 16) = ICODE and sendbuffer(31 downto 24) = HCODE and sendbuffer(39 downto 32) = SPACECODE then --MFIH
					instruction(15 downto 11) <= "11110";
					instruction(7 downto 0) <= (others => '0');
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				elsif sendbuffer(23 downto 16) = PCODE and sendbuffer(31 downto 24) = CCODE and sendbuffer(39 downto 32) = SPACECODE then --MFPC
					instruction(15 downto 11) <= "11101";
					instruction(7 downto 0) <= "01000000";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when OCODE =>
				if sendbuffer(23 downto 16) = VCODE and sendbuffer(31 downto 24) = ECODE and sendbuffer(39 downto 32) = SPACECODE then --MOVE
					instruction(15 downto 11) <= "01111";
					instruction(4 downto 0) <= "00000";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						if sendbuffer(63 downto 56) = SPACECODE and sendbuffer(71 downto 64) = RCODE then
							case sendbuffer(79 downto 72) is
								when ZEROCODE => instruction(7 downto 5) <= "000";
								when ONECODE => instruction(7 downto 5) <= "001";
								when TWOCODE => instruction(7 downto 5) <= "010";
								when THREECODE => instruction(7 downto 5) <= "011";
								when FOURCODE => instruction(7 downto 5) <= "100";
								when FIVECODE => instruction(7 downto 5) <= "101";
								when SIXCODE => instruction(7 downto 5) <= "110";
								when SEVENCODE => instruction(7 downto 5) <= "111";
								when others => instruction <= (others => '1');
							end case;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when TCODE =>
				if sendbuffer(23 downto 16) = ICODE and sendbuffer(31 downto 24) = HCODE and sendbuffer(39 downto 32) = SPACECODE then --MTIH
					instruction(15 downto 11) <= "11110";
					instruction(7 downto 0) <= "00000001";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				elsif sendbuffer(23 downto 16) = SCODE and sendbuffer(31 downto 24) = PCODE and sendbuffer(39 downto 32) = SPACECODE then --MTSP
					instruction(15 downto 8) <= "01100100";
					instruction(4 downto 0) <= "00000";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(7 downto 5) <= "000";
							when ONECODE => instruction(7 downto 5) <= "001";
							when TWOCODE => instruction(7 downto 5) <= "010";
							when THREECODE => instruction(7 downto 5) <= "011";
							when FOURCODE => instruction(7 downto 5) <= "100";
							when FIVECODE => instruction(7 downto 5) <= "101";
							when SIXCODE => instruction(7 downto 5) <= "110";
							when SEVENCODE => instruction(7 downto 5) <= "111";
							when others => instruction <= (others => '1');
						end case;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when others =>
				instruction <= (others => '1');
		end case;

	when NCODE =>
		if sendbuffer(15 downto 8) = OCODE and sendbuffer(23 downto 16) = PCODE then --NOP
			instruction <= NOP;
		else
			instruction <= (others => '1');
		end if;

	when OCODE =>
		if sendbuffer(15 downto 8) = RCODE and sendbuffer(23 downto 16) = SPACECODE then --OR
			instruction(15 downto 11) <= "11101";
			instruction(4 downto 0) <= "01101";
			if sendbuffer(31 downto 24) = RCODE then
				case sendbuffer(39 downto 32) is
					when ZEROCODE => instruction(10 downto 8) <= "000";
					when ONECODE => instruction(10 downto 8) <= "001";
					when TWOCODE => instruction(10 downto 8) <= "010";
					when THREECODE => instruction(10 downto 8) <= "011";
					when FOURCODE => instruction(10 downto 8) <= "100";
					when FIVECODE => instruction(10 downto 8) <= "101";
					when SIXCODE => instruction(10 downto 8) <= "110";
					when SEVENCODE => instruction(10 downto 8) <= "111";
					when others => instruction <= (others => '1');
				end case;
				if sendbuffer(47 downto 40) = SPACECODE and sendbuffer(55 downto 48) = RCODE then
					case sendbuffer(63 downto 56) is
						when ZEROCODE => instruction(7 downto 5) <= "000";
						when ONECODE => instruction(7 downto 5) <= "001";
						when TWOCODE => instruction(7 downto 5) <= "010";
						when THREECODE => instruction(7 downto 5) <= "011";
						when FOURCODE => instruction(7 downto 5) <= "100";
						when FIVECODE => instruction(7 downto 5) <= "101";
						when SIXCODE => instruction(7 downto 5) <= "110";
						when SEVENCODE => instruction(7 downto 5) <= "111";
						when others => instruction <= (others => '1');
					end case;
				else
					instruction <= (others => '1');
				end if;
			else
				instruction <= (others => '1');
			end if;
		else
			instruction <= (others => '1');
		end if;

	when SCODE =>
		case sendbuffer(15 downto 8) is
			when LCODE =>
				if sendbuffer(23 downto 16) = LCODE and sendbuffer(31 downto 24) = SPACECODE then --SLL
					instruction(15 downto 11) <= "00110";
					instruction(1 downto 0) <= "00";
					if sendbuffer(39 downto 32) = RCODE then
						case sendbuffer(47 downto 40) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						if sendbuffer(55 downto 48) = SPACECODE and sendbuffer(63 downto 56) = RCODE then
							case sendbuffer(71 downto 64) is
								when ZEROCODE => instruction(7 downto 5) <= "000";
								when ONECODE => instruction(7 downto 5) <= "001";
								when TWOCODE => instruction(7 downto 5) <= "010";
								when THREECODE => instruction(7 downto 5) <= "011";
								when FOURCODE => instruction(7 downto 5) <= "100";
								when FIVECODE => instruction(7 downto 5) <= "101";
								when SIXCODE => instruction(7 downto 5) <= "110";
								when SEVENCODE => instruction(7 downto 5) <= "111";
								when others => instruction <= (others => '1');
							end case;

							case sendbuffer(111 downto 104) is
								when ZEROCODE => instruction(4 downto 2) <= "000";
								when ONECODE => instruction(4 downto 2) <= "001";
								when TWOCODE => instruction(4 downto 2) <= "010";
								when THREECODE => instruction(4 downto 2) <= "011";
								when FOURCODE => instruction(4 downto 2) <= "100";
								when FIVECODE => instruction(4 downto 2) <= "101";
								when SIXCODE => instruction(4 downto 2) <= "110";
								when SEVENCODE => instruction(4 downto 2) <= "111";
								when others => instruction <= (others => '1');
							end case;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;

				elsif sendbuffer(23 downto 16) = TCODE and sendbuffer(31 downto 24) = ICODE and sendbuffer(39 downto 32) = SPACECODE then --SLTI
					instruction(15 downto 11) <= "01010";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						
						case sendbuffer(87 downto 80) is
							when ZEROCODE => instruction(7 downto 4) <= "0000";
							when ONECODE => instruction(7 downto 4) <= "0001";
							when TWOCODE => instruction(7 downto 4) <= "0010";
							when THREECODE => instruction(7 downto 4) <= "0011";
							when FOURCODE => instruction(7 downto 4) <= "0100";
							when FIVECODE => instruction(7 downto 4) <= "0101";
							when SIXCODE => instruction(7 downto 4) <= "0110";
							when SEVENCODE => instruction(7 downto 4) <= "0111";
							when EIGHTCODE => instruction(7 downto 4) <= "1000";
							when NINECODE => instruction(7 downto 4) <= "1001";
							when ACODE => instruction(7 downto 4) <= "1010";
							when BCODE => instruction(7 downto 4) <= "1011";
							when CCODE => instruction(7 downto 4) <= "1100";
							when DCODE => instruction(7 downto 4) <= "1101";
							when ECODE => instruction(7 downto 4) <= "1110";
							when FCODE => instruction(7 downto 4) <= "1111";
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(95 downto 88) is
							when ZEROCODE => instruction(3 downto 0) <= "0000";
							when ONECODE => instruction(3 downto 0) <= "0001";
							when TWOCODE => instruction(3 downto 0) <= "0010";
							when THREECODE => instruction(3 downto 0) <= "0011";
							when FOURCODE => instruction(3 downto 0) <= "0100";
							when FIVECODE => instruction(3 downto 0) <= "0101";
							when SIXCODE => instruction(3 downto 0) <= "0110";
							when SEVENCODE => instruction(3 downto 0) <= "0111";
							when EIGHTCODE => instruction(3 downto 0) <= "1000";
							when NINECODE => instruction(3 downto 0) <= "1001";
							when ACODE => instruction(3 downto 0) <= "1010";
							when BCODE => instruction(3 downto 0) <= "1011";
							when CCODE => instruction(3 downto 0) <= "1100";
							when DCODE => instruction(3 downto 0) <= "1101";
							when ECODE => instruction(3 downto 0) <= "1110";
							when FCODE => instruction(3 downto 0) <= "1111";
							when others => instruction <= (others => '1');
						end case;
						
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			
			when RCODE =>
				if sendbuffer(23 downto 16) = ACODE and sendbuffer(31 downto 24) = SPACECODE then --SRA
					instruction(15 downto 11) <= "00110";
					instruction(1 downto 0) <= "11";
					if sendbuffer(39 downto 32) = RCODE then
						case sendbuffer(47 downto 40) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						if sendbuffer(55 downto 48) = SPACECODE and sendbuffer(63 downto 56) = RCODE then
							case sendbuffer(71 downto 64) is
								when ZEROCODE => instruction(7 downto 5) <= "000";
								when ONECODE => instruction(7 downto 5) <= "001";
								when TWOCODE => instruction(7 downto 5) <= "010";
								when THREECODE => instruction(7 downto 5) <= "011";
								when FOURCODE => instruction(7 downto 5) <= "100";
								when FIVECODE => instruction(7 downto 5) <= "101";
								when SIXCODE => instruction(7 downto 5) <= "110";
								when SEVENCODE => instruction(7 downto 5) <= "111";
								when others => instruction <= (others => '1');
							end case;

							case sendbuffer(111 downto 104) is
								when ZEROCODE => instruction(4 downto 2) <= "000";
								when ONECODE => instruction(4 downto 2) <= "001";
								when TWOCODE => instruction(4 downto 2) <= "010";
								when THREECODE => instruction(4 downto 2) <= "011";
								when FOURCODE => instruction(4 downto 2) <= "100";
								when FIVECODE => instruction(4 downto 2) <= "101";
								when SIXCODE => instruction(4 downto 2) <= "110";
								when SEVENCODE => instruction(4 downto 2) <= "111";
								when others => instruction <= (others => '1');
							end case;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when UCODE =>
				if sendbuffer(23 downto 16) = BCODE and sendbuffer(31 downto 24) = UCODE and sendbuffer(39 downto 32) = SPACECODE then --SUBU
					instruction(15 downto 11) <= "11100";
					instruction(1 downto 0 ) <= "11";
					if sendbuffer(47 downto 40) = RCODE then
						case sendbuffer(55 downto 48) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						if sendbuffer(71 downto 64) = RCODE then
							case sendbuffer(79 downto 72) is
								when ZEROCODE => instruction(7 downto 5) <= "000";
								when ONECODE => instruction(7 downto 5) <= "001";
								when TWOCODE => instruction(7 downto 5) <= "010";
								when THREECODE => instruction(7 downto 5) <= "011";
								when FOURCODE => instruction(7 downto 5) <= "100";
								when FIVECODE => instruction(7 downto 5) <= "101";
								when SIXCODE => instruction(7 downto 5) <= "110";
								when SEVENCODE => instruction(7 downto 5) <= "111";
								when others => instruction <= (others => '1');
							end case;
							if sendbuffer(95 downto 88) = RCODE then
								case sendbuffer(103 downto 96) is
									when ZEROCODE => instruction(4 downto 2) <= "000";
									when ONECODE => instruction(4 downto 2) <= "001";
									when TWOCODE => instruction(4 downto 2) <= "010";
									when THREECODE => instruction(4 downto 2) <= "011";
									when FOURCODE => instruction(4 downto 2) <= "100";
									when FIVECODE => instruction(4 downto 2) <= "101";
									when SIXCODE => instruction(4 downto 2) <= "110";
									when SEVENCODE => instruction(4 downto 2) <= "111";
									when others => instruction <= (others => '1');
								end case;
							else
								instruction <= (others => '1');
							end if;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;

			when WCODE =>
				if sendbuffer(23 downto 16) = SPACECODE then --SW
					instruction(15 downto 11) <= "11011";
					if sendbuffer(31 downto 24) = RCODE then
						case sendbuffer(39 downto 32) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						if sendbuffer(47 downto 40) = SPACECODE and sendbuffer(55 downto 48) = RCODE then
							case sendbuffer(63 downto 56) is
								when ZEROCODE => instruction(7 downto 5) <= "000";
								when ONECODE => instruction(7 downto 5) <= "001";
								when TWOCODE => instruction(7 downto 5) <= "010";
								when THREECODE => instruction(7 downto 5) <= "011";
								when FOURCODE => instruction(7 downto 5) <= "100";
								when FIVECODE => instruction(7 downto 5) <= "101";
								when SIXCODE => instruction(7 downto 5) <= "110";
								when SEVENCODE => instruction(7 downto 5) <= "111";
								when others => instruction <= (others => '1');
							end case;

							case sendbuffer(95 downto 88) is
								when ZEROCODE => instruction(4) <= '0';
								when ONECODE => instruction(4) <= '1';
								when others => instruction <= (others => '1');
							end case;
							case sendbuffer(103 downto 96) is
								when ZEROCODE => instruction(3 downto 0) <= "0000";
								when ONECODE => instruction(3 downto 0) <= "0001";
								when TWOCODE => instruction(3 downto 0) <= "0010";
								when THREECODE => instruction(3 downto 0) <= "0011";
								when FOURCODE => instruction(3 downto 0) <= "0100";
								when FIVECODE => instruction(3 downto 0) <= "0101";
								when SIXCODE => instruction(3 downto 0) <= "0110";
								when SEVENCODE => instruction(3 downto 0) <= "0111";
								when EIGHTCODE => instruction(3 downto 0) <= "1000";
								when NINECODE => instruction(3 downto 0) <= "1001";
								when ACODE => instruction(3 downto 0) <= "1010";
								when BCODE => instruction(3 downto 0) <= "1011";
								when CCODE => instruction(3 downto 0) <= "1100";
								when DCODE => instruction(3 downto 0) <= "1101";
								when ECODE => instruction(3 downto 0) <= "1110";
								when FCODE => instruction(3 downto 0) <= "1111";
								when others => instruction <= (others => '1');
							end case;
						else
							instruction <= (others => '1');
						end if;
					else
						instruction <= (others => '1');
					end if;
				elsif sendbuffer(23 downto 16) = DOWNCODE and sendbuffer(31 downto 24) = SCODE and sendbuffer(39 downto 32) = PCODE and sendbuffer(47 downto 40) = SPACECODE then --SW_SP
					instruction(15 downto 11) <= "11010";
					if sendbuffer(55 downto 48) = RCODE then
						case sendbuffer(63 downto 56) is
							when ZEROCODE => instruction(10 downto 8) <= "000";
							when ONECODE => instruction(10 downto 8) <= "001";
							when TWOCODE => instruction(10 downto 8) <= "010";
							when THREECODE => instruction(10 downto 8) <= "011";
							when FOURCODE => instruction(10 downto 8) <= "100";
							when FIVECODE => instruction(10 downto 8) <= "101";
							when SIXCODE => instruction(10 downto 8) <= "110";
							when SEVENCODE => instruction(10 downto 8) <= "111";
							when others => instruction <= (others => '1');
						end case;
						
						case sendbuffer(95 downto 88) is
							when ZEROCODE => instruction(7 downto 4) <= "0000";
							when ONECODE => instruction(7 downto 4) <= "0001";
							when TWOCODE => instruction(7 downto 4) <= "0010";
							when THREECODE => instruction(7 downto 4) <= "0011";
							when FOURCODE => instruction(7 downto 4) <= "0100";
							when FIVECODE => instruction(7 downto 4) <= "0101";
							when SIXCODE => instruction(7 downto 4) <= "0110";
							when SEVENCODE => instruction(7 downto 4) <= "0111";
							when EIGHTCODE => instruction(7 downto 4) <= "1000";
							when NINECODE => instruction(7 downto 4) <= "1001";
							when ACODE => instruction(7 downto 4) <= "1010";
							when BCODE => instruction(7 downto 4) <= "1011";
							when CCODE => instruction(7 downto 4) <= "1100";
							when DCODE => instruction(7 downto 4) <= "1101";
							when ECODE => instruction(7 downto 4) <= "1110";
							when FCODE => instruction(7 downto 4) <= "1111";
							when others => instruction <= (others => '1');
						end case;
						case sendbuffer(103 downto 96) is
							when ZEROCODE => instruction(3 downto 0) <= "0000";
							when ONECODE => instruction(3 downto 0) <= "0001";
							when TWOCODE => instruction(3 downto 0) <= "0010";
							when THREECODE => instruction(3 downto 0) <= "0011";
							when FOURCODE => instruction(3 downto 0) <= "0100";
							when FIVECODE => instruction(3 downto 0) <= "0101";
							when SIXCODE => instruction(3 downto 0) <= "0110";
							when SEVENCODE => instruction(3 downto 0) <= "0111";
							when EIGHTCODE => instruction(3 downto 0) <= "1000";
							when NINECODE => instruction(3 downto 0) <= "1001";
							when ACODE => instruction(3 downto 0) <= "1010";
							when BCODE => instruction(3 downto 0) <= "1011";
							when CCODE => instruction(3 downto 0) <= "1100";
							when DCODE => instruction(3 downto 0) <= "1101";
							when ECODE => instruction(3 downto 0) <= "1110";
							when FCODE => instruction(3 downto 0) <= "1111";
							when others => instruction <= (others => '1');
						end case;
						
					else
						instruction <= (others => '1');
					end if;
				else
					instruction <= (others => '1');
				end if;
			when others =>
				instruction <= (others => '1');
		end case;

	when others =>
		instruction <= (others => '1');
end case;
end process;
end Behavioral;