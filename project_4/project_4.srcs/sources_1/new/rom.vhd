library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is

    port (
        clk : in std_logic;
        address : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end entity ROM;

architecture Behavioral of ROM is

    type rom_array is array (0 to 1) of std_logic_vector(31 downto 0);
    constant rom_data : rom_array := (
        -- Contents of the ROM
        -- Format: "data" -- ExamplEs
        "01000000001000011000001110110011","01000000001000011000001110110011"
        
    );

begin

    process (clk)
    begin
        if rising_edge(clk) then
            -- Read operation
            data_out <= rom_data(to_integer(unsigned(address)));
        end if;
    end process;

end architecture Behavioral;
