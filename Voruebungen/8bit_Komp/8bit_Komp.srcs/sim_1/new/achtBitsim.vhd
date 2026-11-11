library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_achtBit is
end tb_achtBit;

architecture sim of tb_achtBit is
    signal inputs1      :   std_logic_vector(7 downto 0);
    signal inputs2      :   std_logic_vector(7 downto 0);
    signal bs1kl2       :   std_logic;
    signal bs1gr2       :   std_logic;
    signal bseq         :   std_logic;

begin

    uut : entity work.Achtbit_Komp
    port map(inputs1, inputs2, bs1kl2, bs1gr2, bseq);
   
    process
    begin
    
        inputs1 <= "01010011";
        inputs2 <= "11010011";
        wait for 10 ns;
        
        inputs1 <= "11010011";
        inputs2 <= "11010011";
        wait for 10 ns;
        
        inputs1 <= "01010011";
        inputs2 <= "00001011";
        wait for 10 ns;
        
        wait;
    end process;

end sim;
