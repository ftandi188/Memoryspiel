library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Achtbit_Komp is
    port(
        inputs1 :   in std_logic_vector(7 downto 0);
        inputs2 :   in std_logic_vector(7 downto 0);
        bs1kl2  :   out std_logic;
        bs1gr2  :   out std_logic;
        bseq    :   out std_logic
    );
end Achtbit_Komp;

architecture Behavioral of Achtbit_Komp is

signal HighBits1kl2     :   std_logic;
signal HighBits1gr2     :   std_logic;
signal HighBitsEq       :   std_logic;

signal LowBits1kl2     :   std_logic;
signal LowBits1gr2     :   std_logic;
signal LowBitsEq       :   std_logic;

begin
    kHIGH   :   entity work.Vierbit_Komp port map(inputs1(7 downto 4), inputs2(7 downto 4), HighBits1kl2, HighBits1gr2, HighBitsEq);
    kLOW    :   entity work.Vierbit_Komp port map(inputs1(3 downto 0), inputs2(3 downto 0), LowBits1kl2, LowBits1gr2, LowBitsEq);
    
    process(HighBits1kl2, HighBits1gr2, HighBitsEq, LowBits1kl2, LowBits1gr2, LowBitsEq) begin
    
    bs1kl2 <= '0';
    bs1gr2 <= '0';
    bseq <= '0';
    
    if(HighBits1kl2 = '1') then
        bs1kl2 <= '1';
    elsif(HighBits1gr2 = '1') then
        bs1gr2 <= '1';
    elsif(HighBitsEq = '1') then
    
        if(LowBits1kl2 = '1') then
            bs1kl2 <= '1';
        elsif(LowBits1gr2 = '1') then
            bs1gr2 <= '1';
        elsif(LowBitsEq = '1') then
            bseq <= '1';
        end if;
    end if;
    end process;
end Behavioral;