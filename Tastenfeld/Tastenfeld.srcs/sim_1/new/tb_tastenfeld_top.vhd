library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_tastenfeld_top is
end tb_tastenfeld_top;

architecture sim of tb_tastenfeld_top is
    constant CLK_PERIOD : time := 10 ns;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal en_scan   : std_logic := '0';
    signal zeilen    : std_logic_vector(3 downto 0) := "1111";
    signal spalten   : std_logic_vector(3 downto 0);
    signal pressed   : std_logic_vector(15 downto 0) := (others => '0'); -- Index = Zeile*4 + Spalte
    signal key_code  : std_logic_vector(3 downto 0);
    signal en_store  : std_logic;
    signal key_press : std_logic;
begin

    uut: entity work.tastenfeld_top
        generic map (COL_DIV => 10, ENTPR_DIV => 40, THRESHOLD => 5)
        port map (clk => clk, rst => rst, en_scan => en_scan, zeilen => zeilen,
                  spalten => spalten, key_code => key_code,
                  en_store => en_store, key_press => key_press);

    clk <= not clk after CLK_PERIOD/2;

    -- Tastenfeld: Zeile r ist Low, wenn eine gedrückte Taste in der aktiven Spalte liegt
    keypad: process(spalten, pressed)
        variable z : std_logic_vector(3 downto 0);
    begin
        z := "1111";
        for r in 0 to 3 loop
            for c in 0 to 3 loop
                if spalten(c) = '0' and pressed(r*4 + c) = '1' then
                    z(r) := '0';
                end if;
            end loop;
        end loop;
        zeilen <= z;
    end process;

    -- Alle Tastenänderungen zu Beginn eines Durchlaufs (t = 100 ns + n * 400 ns)
    stim: process
    begin
        rst <= '1'; en_scan <= '0';
        wait for 100 ns;
        rst <= '0'; en_scan <= '1';                 -- t = 100 ns: Scanning startet
        wait for 1200 ns;                           -- t = 1300 ns
        pressed(9) <= '1'; wait for 400 ns;         -- Taste 9: Prellen (an, aus, an, aus) ...
        pressed(9) <= '0'; wait for 400 ns;
        pressed(9) <= '1'; wait for 400 ns;
        pressed(9) <= '0'; wait for 400 ns;
        pressed(9) <= '1'; wait for 4000 ns;        -- ... dann stabil gedrückt (10 Durchläufe)
        pressed(9) <= '0'; wait for 400 ns;         -- Loslassen mit Prellen
        pressed(9) <= '1'; wait for 400 ns;
        pressed(9) <= '0'; wait for 4000 ns;        -- losgelassen
        pressed(3) <= '1'; wait for 4000 ns;        -- Taste 3 sauber gedrückt (t = 11700 ns)
        pressed(3) <= '0'; wait for 3500 ns;        -- losgelassen
        wait;
    end process;

end sim;