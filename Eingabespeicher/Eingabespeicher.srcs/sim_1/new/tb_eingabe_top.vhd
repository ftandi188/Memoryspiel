library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_eingabe_top is
end tb_eingabe_top;

architecture sim of tb_eingabe_top is
    constant T : time := 10 ns;

    signal clk            : std_logic := '0';
    signal en_store       : std_logic := '0';
    signal key_code       : std_logic_vector(3 downto 0) := (others => '0');
    signal reset_cntrE    : std_logic := '0';
    signal inc_readE      : std_logic := '0';
    signal data_outE      : std_logic_vector(3 downto 0);
    signal read_addressE  : std_logic_vector(5 downto 0);
    signal write_addressE : std_logic_vector(5 downto 0);
begin

    clk <= not clk after T/2;

    uut : entity work.eingabe_top
        port map ( clk            => clk,
                   en_store       => en_store,
                   key_code       => key_code,
                   reset_cntrE    => reset_cntrE,
                   inc_readE      => inc_readE,
                   data_outE      => data_outE,
                   read_addressE  => read_addressE,
                   write_addressE => write_addressE );

    stim : process
        -- Taste "eingeben": key_code anlegen, en_store 1 Takt lang
        procedure store(val : natural) is
        begin
            key_code <= std_logic_vector(to_unsigned(val, 4));
            en_store <= '1';  wait for T;
            en_store <= '0';  wait for 2*T;
        end procedure;

        -- Leseadresse um 1 erhoehen (inc_readE 1 Takt lang)
        procedure next_read is
        begin
            inc_readE <= '1';  wait for T;
            inc_readE <= '0';  wait for 2*T;
        end procedure;
    begin
        -- Test 1: Reset -> beide Adressen 0
        reset_cntrE <= '1';  wait for T;
        reset_cntrE <= '0';  wait for 2*T;
        assert unsigned(write_addressE) = 0 report "T1: write /= 0" severity error;
        assert unsigned(read_addressE)  = 0 report "T1: read /= 0"  severity error;

        -- Test 2: 4 Tasten eingeben (5, A, 3, F), write_address zaehlt mit
        store(5);   assert unsigned(write_addressE) = 1 report "T2: write /= 1" severity error;
        store(10);  assert unsigned(write_addressE) = 2 report "T2: write /= 2" severity error;
        store(3);   assert unsigned(write_addressE) = 3 report "T2: write /= 3" severity error;
        store(15);  assert unsigned(write_addressE) = 4 report "T2: write /= 4" severity error;

        -- Test 3: Auslesen wie der Komparator (read_address zaehlt mit)
        assert unsigned(data_outE) = 5  report "T3: Index 0 /= 5" severity error;
        next_read;
        assert unsigned(read_addressE) = 1 report "T3: read /= 1" severity error;
        assert unsigned(data_outE) = 10 report "T3: Index 1 /= A" severity error;
        next_read;
        assert unsigned(data_outE) = 3  report "T3: Index 2 /= 3" severity error;
        next_read;
        assert unsigned(data_outE) = 15 report "T3: Index 3 /= F" severity error;
        next_read;
        assert unsigned(read_addressE) = 4 report "T3: read /= 4" severity error;

        -- Test 4: ohne en_store bleibt write_address stehen
        key_code <= x"9";
        wait for 5*T;
        assert unsigned(write_addressE) = 4 report "T4: write hat sich ohne en_store veraendert" severity error;

        -- Test 5: Reset, neue Runde: Werte werden ueberschrieben
        reset_cntrE <= '1';  wait for T;
        reset_cntrE <= '0';  wait for 2*T;
        assert unsigned(write_addressE) = 0 report "T5: write /= 0" severity error;
        assert unsigned(read_addressE)  = 0 report "T5: read /= 0"  severity error;
        store(1);
        store(2);
        assert unsigned(write_addressE) = 2 report "T5: write /= 2" severity error;
        assert unsigned(data_outE) = 1 report "T5: Index 0 /= 1 (nicht ueberschrieben)" severity error;
        next_read;
        assert unsigned(data_outE) = 2 report "T5: Index 1 /= 2 (nicht ueberschrieben)" severity error;
        next_read;
        assert unsigned(data_outE) = 3 report "T5: Index 2 sollte noch alter Wert 3 sein" severity error;

        report "Testbench Eingabe Top fertig" severity note;
        wait;
    end process;

end sim;