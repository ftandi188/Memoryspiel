library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tastenfeld_top is
    generic (
        COL_DIV   : positive := 100_000;  -- Takte pro Spalte (100 MHz: 1 ms)
        ENTPR_DIV : positive := 400_000;  -- Takte pro Entprell-Tick = 1 Durchlauf (4 ms)
        THRESHOLD : positive := 5         -- Entprell-Schwelle
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        en_scan   : in  std_logic;                      -- von der FSM
        zeilen    : in  std_logic_vector(3 downto 0);   -- vom Tastenfeld (Pullup)
        spalten   : out std_logic_vector(3 downto 0);   -- zum Tastenfeld (Open-Drain)
        key_code  : out std_logic_vector(3 downto 0);   -- zum Eingabespeicher
        en_store  : out std_logic;                      -- zum Eingabespeicher
        key_press : out std_logic
    );
end tastenfeld_top;

architecture structural of tastenfeld_top is
    signal spalten_int : std_logic_vector(3 downto 0);
    signal key_valid_i : std_logic;
    signal key_code_i  : std_logic_vector(3 downto 0);
begin

    u_scanning: entity work.scanning
        generic map (COL_DIV => COL_DIV)
        port map (
            clk     => clk,
            rst     => rst,
            en_scan => en_scan,
            spalten => spalten_int
        );

    u_auswertung: entity work.auswertung
        port map (
            clk       => clk,
            rst       => rst,
            spalten   => spalten_int,
            zeilen    => zeilen,
            key_code  => key_code_i,
            key_valid => key_valid_i
        );

    u_entprellung: entity work.entprellung
        generic map (
            CLK_DIV   => ENTPR_DIV,
            THRESHOLD => THRESHOLD,
            CODE_W    => 4
        )
        port map (
            clk       => clk,
            rst       => rst,
            key_valid => key_valid_i,
            key_code  => key_code_i,
            en_store  => en_store,
            key_press => key_press
        );

    -- Open-Drain am Pin: aktive Spalte Low, sonst hochohmig
    gen_od: for c in 0 to 3 generate
        spalten(c) <= '0' when spalten_int(c) = '0' else 'Z';
    end generate;

    key_code <= key_code_i;

end structural;