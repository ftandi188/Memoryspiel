library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_eingabe_adressierung is
end tb_eingabe_adressierung;

architecture sim of tb_eingabe_adressierung is
    constant T : time := 10 ns;

    signal clk            : std_logic := '0';
    signal reset_cntrE    : std_logic := '0';
    signal inc_writeE     : std_logic := '0';
    signal inc_readE      : std_logic := '0';
    signal read_addressE  : std_logic_vector(5 downto 0);
    signal write_addressE : std_logic_vector(5 downto 0);
begin

    clk <= not clk after T/2;

    uut : entity work.eingabe_adressierung
        port map ( clk            => clk,
                   reset_cntrE    => reset_cntrE,
                   inc_writeE     => inc_writeE,
                   inc_readE      => inc_readE,
                   read_addressE  => read_addressE,
                   write_addressE => write_addressE );

    stim : process
        -- Ein-Takt-Impuls auf einem Signal
        procedure pulse(signal s : out std_logic) is
        begin
            s <= '1';  wait for T;
            s <= '0';  wait for T;
        end procedure;
    begin
        -- Test 1: Reset
        pulse(reset_cntrE);
        assert unsigned(write_addressE) = 0 report "T1: write /= 0" severity error;
        assert unsigned(read_addressE)  = 0 report "T1: read /= 0"  severity error;

        -- Test 2: 3x inc_writeE -> write = 3, read bleibt 0
        pulse(inc_writeE);
        pulse(inc_writeE);
        pulse(inc_writeE);
        assert unsigned(write_addressE) = 3 report "T2: write /= 3" severity error;
        assert unsigned(read_addressE)  = 0 report "T2: read /= 0"  severity error;

        -- Test 3: 2x inc_readE -> read = 2, write bleibt 3
        pulse(inc_readE);
        pulse(inc_readE);
        assert unsigned(read_addressE)  = 2 report "T3: read /= 2"  severity error;
        assert unsigned(write_addressE) = 3 report "T3: write /= 3" severity error;

        -- Test 4: beide gleichzeitig -> write = 4, read = 3
        inc_writeE <= '1';  inc_readE <= '1';  wait for T;
        inc_writeE <= '0';  inc_readE <= '0';  wait for T;
        assert unsigned(write_addressE) = 4 report "T4: write /= 4" severity error;
        assert unsigned(read_addressE)  = 3 report "T4: read /= 3"  severity error;

        -- Test 5: Reset setzt beide zurueck
        pulse(reset_cntrE);
        assert unsigned(write_addressE) = 0 report "T5: write /= 0" severity error;
        assert unsigned(read_addressE)  = 0 report "T5: read /= 0"  severity error;

        -- Test 6: Ueberlauf, 64 Impulse -> wieder 0
        for i in 1 to 64 loop
            pulse(inc_writeE);
        end loop;
        assert unsigned(write_addressE) = 0 report "T6: kein Ueberlauf auf 0" severity error;

        report "Testbench Eingabe Adressierung fertig" severity note;
        wait;
    end process;

end sim;