library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_scanning is
end tb_scanning;

architecture sim of tb_scanning is
    constant CLK_PERIOD : time := 10 ns;

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal en_scan : std_logic := '0';
    signal spalten : std_logic_vector(3 downto 0);
begin

    uut: entity work.scanning
        generic map (COL_DIV => 10)       -- 10 Takte = 100 ns pro Spalte
        port map (clk => clk, rst => rst, en_scan => en_scan, spalten => spalten);

    clk <= not clk after CLK_PERIOD/2;

    stim: process
    begin
        rst <= '1'; en_scan <= '0';
        wait for 100 ns;
        rst <= '0';
        wait for 200 ns;                  -- t = 300 ns
        en_scan <= '1'; wait for 1400 ns; -- Scanning läuft
        en_scan <= '0'; wait for 500 ns;  -- Scanning aus
        en_scan <= '1'; wait for 800 ns;  -- Scanning startet neu bei Spalte 0
        wait;
    end process;

end sim;