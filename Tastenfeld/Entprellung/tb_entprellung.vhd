library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_entprellung is
end tb_entprellung;

architecture sim of tb_entprellung is
    constant CLK_PERIOD : time := 10 ns;
    constant TICK       : time := 4 * CLK_PERIOD;  -- passt zu CLK_DIV => 4

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal key_valid : std_logic := '0';
    signal key_code  : std_logic_vector(3 downto 0) := "0000";
    signal en_store  : std_logic;
    signal key_press : std_logic;
begin

    uut: entity work.entprellung
        generic map (CLK_DIV => 4, THRESHOLD => 5, CODE_W => 4)
        port map (clk => clk, rst => rst, key_valid => key_valid,
                  key_code => key_code, en_store => en_store,
                  key_press => key_press);

    clk <= not clk after CLK_PERIOD/2;

    stim: process
    begin
        wait for 5*TICK;
        rst <= '0';
        wait for 3*TICK;

        -- Taste 5 wird gedrückt, mit Prellen
        key_code  <= "0101";
        key_valid <= '1'; wait for 2*TICK;
        key_valid <= '0'; wait for 1*TICK;
        key_valid <= '1'; wait for 1*TICK;
        key_valid <= '0'; wait for 1*TICK;
        key_valid <= '1'; wait for 15*TICK;   -- stabil: ein Impuls erwartet

        -- Loslassen, mit Prellen
        key_valid <= '0'; wait for 2*TICK;
        key_valid <= '1'; wait for 1*TICK;
        key_valid <= '0'; wait for 10*TICK;

        -- Andere Taste (10)
        key_code  <= "1010";
        key_valid <= '1'; wait for 15*TICK;
        key_valid <= '0'; wait for 10*TICK;

        wait;
    end process;

end sim;