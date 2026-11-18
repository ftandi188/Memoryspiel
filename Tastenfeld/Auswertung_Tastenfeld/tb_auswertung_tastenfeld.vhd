library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_auswertung is
end tb_auswertung;

architecture sim of tb_auswertung is
    constant CLK_PERIOD : time := 10 ns;
    constant COL_T      : time := 100 ns;   -- Zeit pro Spalte

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal spalten   : std_logic_vector(3 downto 0) := "1111";
    signal zeilen    : std_logic_vector(3 downto 0) := "1111";
    signal pressed   : std_logic_vector(15 downto 0) := (others => '0'); -- Index = Zeile*4 + Spalte
    signal key_code  : std_logic_vector(3 downto 0);
    signal key_valid : std_logic;
begin

    uut: entity work.auswertung
        port map (clk => clk, rst => rst, spalten => spalten, zeilen => zeilen,
                  key_code => key_code, key_valid => key_valid);

    clk <= not clk after CLK_PERIOD/2;

    -- Scanning: Spalten nacheinander auf Masse ziehen
    scan: process
        variable s : std_logic_vector(3 downto 0);
    begin
        wait until rst = '0';
        loop
            for c in 0 to 3 loop
                s := "1111";
                s(c) := '0';
                spalten <= s;
                wait for COL_T;
            end loop;
        end loop;
    end process;

    -- Tastenfeld: Zeile r ist Low, wenn dort eine gedrückte Taste in der aktiven Spalte liegt
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

    stim: process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 1200 ns;                                       -- t = 1300 ns
        pressed(9)  <= '1';                 wait for 2000 ns;   -- Taste 9 (Zeile 2, Spalte 1)
        pressed(3)  <= '1';                 wait for 2000 ns;   -- zusätzlich Taste 3
        pressed     <= (others => '0');     wait for 2000 ns;   -- alles loslassen
        pressed(0)  <= '1';                 wait for 2000 ns;   -- Taste 0
        pressed(0)  <= '0'; pressed(15) <= '1'; wait for 2000 ns; -- Taste 15
        pressed     <= (others => '0');     wait for 1000 ns;
        wait;
    end process;

end sim;