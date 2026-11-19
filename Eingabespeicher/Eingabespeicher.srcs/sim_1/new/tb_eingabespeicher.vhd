library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_eingabespeicher is
end tb_eingabespeicher;

architecture sim of tb_eingabespeicher is
    constant T : time := 10 ns;

    signal clk            : std_logic := '0';
    signal en_store       : std_logic := '0';
    signal key_code       : std_logic_vector(3 downto 0) := (others => '0');
    signal write_addressE : std_logic_vector(5 downto 0) := (others => '0');
    signal read_addressE  : std_logic_vector(5 downto 0) := (others => '0');
    signal inc_writeE     : std_logic;
    signal data_outE      : std_logic_vector(3 downto 0);
begin

    clk <= not clk after T/2;

    uut : entity work.eingabespeicher
        port map ( clk            => clk,
                   en_store       => en_store,
                   key_code       => key_code,
                   write_addressE => write_addressE,
                   read_addressE  => read_addressE,
                   inc_writeE     => inc_writeE,
                   data_outE      => data_outE );

    stim : process
        -- Wert val an Index addr speichern (en_store 1 Takt lang)
        procedure store(addr : natural; val : natural) is
        begin
            write_addressE <= std_logic_vector(to_unsigned(addr, 6));
            key_code       <= std_logic_vector(to_unsigned(val, 4));
            en_store       <= '1';
            wait for T;
            assert inc_writeE = '1'
                report "store: inc_writeE nicht High nach dem Speichern" severity error;
            en_store       <= '0';
            wait for T;
            assert inc_writeE = '0'
                report "store: inc_writeE ist laenger als 1 Takt High" severity error;
        end procedure;

        -- Index addr lesen und mit erwartetem Wert exp vergleichen
        procedure check_read(addr : natural; exp : natural; msg : string) is
        begin
            read_addressE <= std_logic_vector(to_unsigned(addr, 6));
            wait for 1 ns;                      -- asynchron: kurz warten reicht
            assert unsigned(data_outE) = exp
                report "check_read: " & msg severity error;
        end procedure;
    begin
        wait for 2*T;

        -- Test 1: Startzustand, alles 0, kein inc_writeE
        check_read(0, 0, "T1: Index 0 /= 0");
        assert inc_writeE = '0' report "T1: inc_writeE ohne en_store" severity error;

        -- Test 2: drei Werte speichern und lesen (5, A, 3)
        store(0, 5);
        store(1, 10);
        store(2, 3);
        check_read(0, 5,  "T2: Index 0 /= 5");
        check_read(1, 10, "T2: Index 1 /= A");
        check_read(2, 3,  "T2: Index 2 /= 3");

        -- Test 3: ohne en_store wird NICHT gespeichert
        write_addressE <= std_logic_vector(to_unsigned(2, 6));
        key_code       <= x"F";
        wait for 3*T;
        check_read(2, 3, "T3: Index 2 wurde ohne en_store veraendert");
        assert inc_writeE = '0' report "T3: inc_writeE ohne en_store" severity error;

        -- Test 4: ueberschreiben
        store(0, 7);
        check_read(0, 7,  "T4: Index 0 /= 7");
        check_read(1, 10, "T4: Index 1 wurde veraendert");

        -- Test 5: alle 64 Plaetze beschreiben (Wert = Index mod 16) und pruefen
        for i in 0 to 63 loop
            store(i, i mod 16);
        end loop;
        for i in 0 to 63 loop
            check_read(i, i mod 16, "T5: falscher Wert im Durchlauf");
        end loop;

        report "Testbench Eingabespeicher fertig" severity note;
        wait;
    end process;

end sim;