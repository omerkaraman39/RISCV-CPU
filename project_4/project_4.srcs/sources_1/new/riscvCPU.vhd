
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity riscvCPU is

port (
clk : in std_logic;
rst : in std_logic;
zr : out std_logic;
rslt : out std_logic_vector(4 downto 0);
 adrs : in std_logic_vector( 7 downto 0)
);
end riscvCPU;

architecture Behavioral of riscvCPU is

component RISCValu
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
end component;

component ROM is

    port (
        clk : in std_logic;
        address : in std_logic_vector( 7 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end component;

signal funct3: std_logic_vector(2 downto 0);
signal funct7: std_logic_vector(7 downto 0);
signal rs1: std_logic_vector(4 downto 0);
signal rs2: std_logic_vector(4 downto 0);
signal prgaddress: std_logic_vector(31 downto 0);
signal dto: std_logic_vector(31 downto 0);
begin

u1: RISCValu port map(
clk => clk,

        reset => rst,
        funct3 => dto(14 downto 12),
        funct7 => dto(31 downto 25),
        rs1 => dto(19 downto 15),
        rs2 => dto(24 downto 20),
        result => rslt,
        zero => zr
        );
 
 u2: ROM port map(
 clk =>clk,
 address => adrs,
 data_out => dto
 );
 
 

end Behavioral;
