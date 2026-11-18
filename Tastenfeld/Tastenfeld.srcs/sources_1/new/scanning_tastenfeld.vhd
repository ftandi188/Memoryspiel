library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scanning is
    generic (
        COL_DIV : positive := 100_000  -- Takte pro Spalte: 100 MHz / 100000 = 1 ms pro Spalte
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        en_scan : in  std_logic;
        spalten : out std_logic_vector(3 downto 0)  -- Low-aktiv: Bit c = Spalte c
    );
end scanning;

architecture rtl of scanning is
    signal tick_cnt  : integer range 0 to COL_DIV-1 := 0;
    signal cntr_scan : unsigned(1 downto 0) := (others => '0');   -- läuft 0 bis 3
    signal spalten_r : std_logic_vector(3 downto 0) := (others => '1');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or en_scan = '0' then
                -- Scanning aus: alle Spalten inaktiv, Zähler zurücksetzen
                tick_cnt  <= 0;
                cntr_scan <= (others => '0');
                spalten_r <= (others => '1');
            else
                -- aktuelle Spalte auf Masse ziehen, alle anderen High
                spalten_r <= (others => '1');
                spalten_r(to_integer(cntr_scan)) <= '0';

                -- Takteiler: nach COL_DIV Takten zur nächsten Spalte
                if tick_cnt = COL_DIV-1 then
                    tick_cnt  <= 0;
                    cntr_scan <= cntr_scan + 1;   -- 3 + 1 = 0 (2-Bit-Überlauf)
                else
                    tick_cnt <= tick_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    spalten <= spalten_r;

end rtl;