library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity entprellung is
    generic (
        CLK_DIV   : positive := 100_000; -- Abtasttakt: 100 MHz / 100000 = 1 kHz
        THRESHOLD : positive := 5;       -- Schwelle (max. 15, da 4-Bit-Zähler)
        CODE_W    : positive := 4        -- Breite des Keycodes
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        key_valid : in  std_logic;
        key_code  : in  std_logic_vector(CODE_W-1 downto 0);
        en_store  : out std_logic;
        key_press : out std_logic
    );
end entprellung;

architecture rtl of entprellung is
    signal tick_cnt  : integer range 0 to CLK_DIV-1 := 0;
    signal cntr      : unsigned(3 downto 0) := (others => '0');
    signal last_code : std_logic_vector(CODE_W-1 downto 0) := (others => '0');
    signal key_state : std_logic := '0';  -- '1' = Taste gilt als gedrückt
    signal pulse     : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            pulse <= '0';  -- Standardwert: Impuls nur 1 Takt lang

            if rst = '1' then
                tick_cnt  <= 0;
                cntr      <= (others => '0');
                last_code <= (others => '0');
                key_state <= '0';
            else
                -- Takteiler: Entprell-Logik läuft nur einmal pro Abtastperiode
                if tick_cnt = CLK_DIV-1 then
                    tick_cnt <= 0;

                    if key_valid = '1' then
                        if key_code /= last_code then
                            -- Keycode hat gewechselt: neu beginnen
                            last_code <= key_code;
                            cntr      <= (others => '0');
                            key_state <= '0';
                        elsif cntr < to_unsigned(THRESHOLD, 4) then
                            cntr <= cntr + 1;
                            -- Schwelle wird mit diesem Schritt erreicht
                            if cntr = to_unsigned(THRESHOLD-1, 4) and key_state = '0' then
                                key_state <= '1';
                                pulse     <= '1';
                            end if;
                        end if;
                    else
                        -- key_valid = 0 (Prellen oder losgelassen): zurückzählen
                        if cntr > 0 then
                            cntr <= cntr - 1;
                            if cntr = 1 then
                                key_state <= '0';
                            end if;
                        end if;
                    end if;

                else
                    tick_cnt <= tick_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    en_store  <= pulse;
    key_press <= pulse;

end rtl;