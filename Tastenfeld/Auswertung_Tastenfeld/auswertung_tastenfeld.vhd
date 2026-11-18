library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity auswertung is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        spalten   : in  std_logic_vector(3 downto 0);  -- Abtastsignal, Low-aktiv (Bit c = Spalte c)
        zeilen    : in  std_logic_vector(3 downto 0);  -- Pullup, Low = Taste gedrückt (Bit r = Zeile r)
        key_code  : out std_logic_vector(3 downto 0);
        key_valid : out std_logic
    );
end auswertung;

architecture rtl of auswertung is
    signal zeilen_meta  : std_logic_vector(3 downto 0) := (others => '1');
    signal zeilen_sync  : std_logic_vector(3 downto 0) := (others => '1');
    signal spalten_prev : std_logic_vector(3 downto 0) := (others => '1');

    signal found        : std_logic := '0';                         -- in diesem Durchlauf schon Taste gefunden?
    signal code_tmp     : std_logic_vector(3 downto 0) := (others => '0');

    signal key_valid_r  : std_logic := '0';
    signal key_code_r   : std_logic_vector(3 downto 0) := (others => '0');
begin

    process(clk)
        variable col       : integer range 0 to 3;
        variable col_ok    : boolean;
        variable row       : integer range 0 to 3;
        variable row_ok    : boolean;
        variable new_found : std_logic;
        variable new_code  : std_logic_vector(3 downto 0);
    begin
        if rising_edge(clk) then
            -- Zeilen einsynchronisieren
            zeilen_meta  <= zeilen;
            zeilen_sync  <= zeilen_meta;
            spalten_prev <= spalten;

            if rst = '1' then
                found       <= '0';
                code_tmp    <= (others => '0');
                key_valid_r <= '0';
                key_code_r  <= (others => '0');

            elsif spalten /= spalten_prev then
                -- Spaltenwechsel: die Zeilenwerte gehören zur bisherigen Spalte (spalten_prev)
                case spalten_prev is
                    when "1110" => col := 0; col_ok := true;
                    when "1101" => col := 1; col_ok := true;
                    when "1011" => col := 2; col_ok := true;
                    when "0111" => col := 3; col_ok := true;
                    when others => col := 0; col_ok := false;  -- z.B. "1111" = Scanning aus
                end case;

                -- Prioritätsencoder: niedrigste gedrückte Zeile gewinnt
                row    := 0;
                row_ok := false;
                for r in 3 downto 0 loop
                    if zeilen_sync(r) = '0' then
                        row    := r;
                        row_ok := true;
                    end if;
                end loop;

                new_found := found;
                new_code  := code_tmp;

                if not col_ok then
                    -- kein gültiger Spaltenzustand: angefangenen Durchlauf verwerfen
                    new_found := '0';
                elsif row_ok and found = '0' then
                    -- erste gefundene Taste im Durchlauf merken
                    new_found := '1';
                    new_code  := std_logic_vector(to_unsigned(row * 4 + col, 4));
                end if;

                if col_ok and col = 3 then
                    -- alle 4 Spalten abgetastet: Ausgänge aktualisieren
                    key_valid_r <= new_found;
                    if new_found = '1' then
                        key_code_r <= new_code;
                    end if;
                    found <= '0';
                else
                    found    <= new_found;
                    code_tmp <= new_code;
                end if;
            end if;
        end if;
    end process;

    key_valid <= key_valid_r;
    key_code  <= key_code_r;

end rtl;