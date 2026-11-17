library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rundenzaehler is
  port ( 
    inc_cntr    :   in std_logic;
    en_player1  :   in std_logic;
    en_player2  :   in std_logic;    
    score_player1   :   out std_logic_vector(5 downto 0);
    score_player2   :   out std_logic_vector(5 downto 0)
  );
end Rundenzaehler;

architecture Behavioral of Rundenzaehler is
    signal tempscore_player1    :   unsigned(5 downto 0) := (others => '0');
    signal tempscore_player2    :   unsigned(5 downto 0) := (others => '0');
begin

    process(inc_cntr)
    begin
        if rising_edge(inc_cntr) then
            if en_player1 = '1' then
                tempscore_player1 <= tempscore_player1 + 1;
            end if;
            if en_player2 = '1' then
                tempscore_player2 <= tempscore_player2 + 1;
            end if;
        end if;
    end process;           
    score_player1 <= std_logic_vector(tempscore_player1);
    score_player2 <= std_logic_vector(tempscore_player2);

end Behavioral;
