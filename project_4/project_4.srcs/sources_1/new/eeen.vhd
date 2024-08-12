library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity RISCValu is
    port (
        clk : in std_logic;
        reset : in std_logic;
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic_vector(6 downto 0);
        rs1 : in std_logic_vector(4 downto 0);
        rs2 : in std_logic_vector(4 downto 0);
        result : out std_logic_vector(4 downto 0);
        zero : out std_logic
    );
end RISCValu;

architecture Behavioral of RISCValu is

    signal op_a_signed, op_b_signed, result_signed : signed(4 downto 0);
    signal op_a_unsigned, op_b_unsigned, result_unsigned : unsigned(4 downto 0);
    signal result_signal: std_logic_vector(4 downto 0);
        
begin

    process(clk, reset)
    begin
        if reset = '1' then
            result_signal<= (others => '0');
            zero <= '0';
        elsif rising_edge(clk) then
            op_a_signed <= signed(rs1);
            op_b_signed <= signed(rs2);
            op_a_unsigned <= unsigned(rs1);
            op_b_unsigned <= unsigned(rs2);
            
            case funct3 is
                -- Arithmetic Operations
                when "000" => -- ADD
                    if funct7 = "0000000" then
                        result_signed <= op_a_signed + op_b_signed;
                        result_signal<= std_logic_vector(result_signed);
                    elsif funct7 = "0100000" then
                        result_signed <= op_a_signed - op_b_signed;
                        result_signal<= std_logic_vector(result_signed);
                    else
                        result_signal<= (others => 'X'); ----
                    end if;
                when "111" => -- AND
                    if funct7 = "0000000" then
                        result_unsigned <= op_a_unsigned and op_b_unsigned;
                        result_signal<= std_logic_vector(result_unsigned);
                    else
                        result_signal<= (others => 'X'); ----
                    end if;
                when "110" => -- OR
                    if funct7 = "0000000" then
                        result_unsigned <= op_a_unsigned or op_b_unsigned;
                        result_signal<= std_logic_vector(result_unsigned);
                    else
                        result_signal<= (others => 'X');  ----
                    end if;
                when "100" => -- XOR
                    if funct7 = "0000000" then
                        result_unsigned <= op_a_unsigned xor op_b_unsigned;
                        result_signal<= std_logic_vector(result_unsigned(4 downto 0));
                    else
                        result_signal<= (others => 'X');  -----
                    end if;
                -- Logical Shift Operations
                when "001" => -- SLL
                    if funct7 = "0000000" then
                        result_unsigned <= op_a_unsigned sll to_integer(unsigned(op_b_unsigned(4 downto 0)));
                        result_signal<= std_logic_vector(result_unsigned);
                    else
                        result_signal<= (others => 'X');  ----
                    end if;
                when "101" => -- SRL
                    if funct7 = "0000000" then
                        result_unsigned <= op_a_unsigned srl to_integer(unsigned(op_b_unsigned(4 downto 0)));
                        result_signal<= std_logic_vector(result_unsigned);
                    elsif funct7 = "0100000" then --SRA
                        result_signed <= shift_right(op_a_signed, to_integer(op_b_unsigned(4 downto 0)));
                        result_signal<= std_logic_vector(result_signed); 
               
                    else
                        result_signal<= "XXXXX"; -----
                    end if;
                -- Comparison Operations
                when "010" => -- SLT
                    if funct7 = "0000000" then
                        if op_a_signed < op_b_signed then
                            result_signal<= "00001"; ----
                        else
                            result_signal<= "00000";  -----
                        end if;
                    else
                        result_signal<= (others => 'X'); ----
                    end if;
                when "011" => -- SLTU
                    if funct7 = "0000000" then
                        if op_a_unsigned < op_b_unsigned then
                            result_signal<= "00001"; -----
                        else
                            result_signal<= "00000"; ----
                        end if;
                    else
                        result_signal<= (others => 'X');  -----
                    end if;
                -- Default
                when others =>
                    result_signal<= (others => 'X');  -----
            end case;
            --bütün resultlar result_signal olsun
            -- Check for zero result
            if result_signal= "00000" then --!!!---
                zero <= '1';
            else
                zero <= '0';
            end if;
        end if;
       end process;
       result <= result_signal;
     end Behavioral;
