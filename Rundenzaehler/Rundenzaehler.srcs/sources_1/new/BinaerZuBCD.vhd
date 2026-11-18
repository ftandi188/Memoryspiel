library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BinaerZuBCD is
    port ( 
        score_player1   :   in std_logic_vector(5 downto 0);
        score_player2   :   in std_logic_vector(5 downto 0);
        zehner_pl1      :   out std_logic_vector (3 downto 0);
        einer_pl1       :   out std_logic_vector (3 downto 0);
        zehner_pl2      :   out std_logic_vector (3 downto 0);
        einer_pl2       :   out std_logic_vector (3 downto 0)
    );
end BinaerZuBCD;

architecture Behavioral of BinaerZuBCD is
    
begin
    process(score_player1)
        variable int_Zehner_pl1   :   unsigned(5 downto 0) := (others => '0');
        variable int_Einer_pl1    :   unsigned(5 downto 0) := (others => '0');
    
    begin
        int_Zehner_pl1 := unsigned(score_player1) /10;
        int_Einer_pl1 := unsigned(score_player1) mod 10;
        
        zehner_pl1 <= std_logic_vector(int_Zehner_pl1(3 downto 0));
        einer_pl1 <= std_logic_vector(int_Einer_pl1(3 downto 0));
        
    end process;
     
    process(score_player2)
        variable int_Zehner_pl2   :   unsigned(5 downto 0) := (others => '0');
        variable int_Einer_pl2    :   unsigned(5 downto 0) := (others => '0');
    
    begin
        int_Zehner_pl2 := unsigned(score_player2) /10;
        int_Einer_pl2 := unsigned(score_player2) mod 10;
        
        zehner_pl2 <= std_logic_vector(int_Zehner_pl2(3 downto 0));
        einer_pl2 <= std_logic_vector(int_Einer_pl2(3 downto 0));
        
    end process;
end Behavioral;
    