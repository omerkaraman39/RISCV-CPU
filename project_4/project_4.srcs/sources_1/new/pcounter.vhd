library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
    
    port (
        clk: in std_logic;
        reset: in std_logic;
        pc_in: in std_logic_vector(31 downto 0);
        pc_out: out std_logic_vector(31 downto 0)
    );
end entity program_counter;

architecture behavioral of program_counter is
    signal pc_reg: std_logic_vector(31 downto 0);
    signal exec_counter: std_logic_vector(4 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
            exec_counter <= (others => '0');
        elsif rising_edge(clk) then
            
                exec_counter <=  std_logic_vector(unsigned(exec_counter) + 1);
                if (exec_counter = "00011") then
                    pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);
                end if;
         
        end if;
    end process;

    pc_out <= pc_reg;
end architecture behavioral;
