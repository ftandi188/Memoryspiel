library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity topsegment is
    port ( 
        clk         :   in std_logic;
        
        inc_cntr    :   in std_logic;
        en_player1  :   in std_logic;
        en_player2  :   in std_logic;
        
        seg :   out std_logic_vector (6 downto 0);
        an  :   out std_logic_vector (3 downto 0)
    );
end topsegment;


architecture Behavioral of topsegment is
    signal score_player1 : std_logic_vector(5 downto 0);
    signal score_player2 : std_logic_vector(5 downto 0);

    signal zehner_pl1 : std_logic_vector(3 downto 0);
    signal einer_pl1  : std_logic_vector(3 downto 0);
    signal zehner_pl2 : std_logic_vector(3 downto 0);
    signal einer_pl2  : std_logic_vector(3 downto 0);

    signal selected_stelle : std_logic_vector(3 downto 0);
    signal cntr_select_int : unsigned(1 downto 0);

begin
    score_player1 <= "100101";
    score_player2 <= "001100";
    
    
--    u_rundenzaehler : entity work.Rundenzaehler
--port map(
--    inc_cntr      => inc_cntr,
--    en_player1    => en_player1,
--    en_player2    => en_player2,
--    score_player1 => score_player1,
--    score_player2 => score_player2
--);

u_bcd : entity work.BinaerZuBCD
port map(
    score_player1 => score_player1,
    score_player2 => score_player2,

    zehner_pl1 => zehner_pl1,
    einer_pl1  => einer_pl1,
    zehner_pl2 => zehner_pl2,
    einer_pl2  => einer_pl2
);

u_mux : entity work.Multiplexer
port map(
    clk => clk,

    zehner_pl1 => zehner_pl1,
    einer_pl1  => einer_pl1,
    zehner_pl2 => zehner_pl2,
    einer_pl2  => einer_pl2,

    selected_stelle => selected_stelle,
    cntr_select     => cntr_select_int
);

u_decoder : entity work.SiebenSegment_Decoder
port map(
    selected_stelle => selected_stelle,
    cntr_select     => cntr_select_int,

    seg => seg,
    an  => an
);

end Behavioral;
