library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test_Bench_Clock is
end Test_Bench_Clock;

architecture behavior of Test_Bench_Clock is

    -- Deklaration des zu testenden Moduls (Unit Under Test - UUT)
    -- Passe diesen Namen an dein Top-Level an!
    
    component Zufallsgenerator is
        Port (
            clk      : in  STD_LOGIC;
           
            en_random   : in  STD_LOGIC;
            LEDout : out STD_LOGIC_VECTOR(3 downto 0)
           
        );
    end component;

    -- Testbench-Signale
    signal clk      : STD_LOGIC := '0';
    
    signal en_random    : STD_LOGIC := '0';
    signal LEDout : STD_LOGIC_VECTOR(3 downto 0);

    -- Taktperiode definieren: 100 ns (10 MHz)
    constant CLK_PERIOD : time := 100 ns;

begin

    -- Instantiierung der UUT
    uut: Zufallsgenerator
        port map (
            clk      => clk,
            en_random    => en_random,
            LEDout => LEDout
        );

    -- Takt-Generator-Prozess (läuft permanent)
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;
end behavior;