library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Vierbit_Komp is
    port (
        sw1     :   in  std_logic_vector(3 downto 0);
        sw2     :   in  std_logic_vector(3 downto 0);
        led1kl2 :   out std_logic;
        led1gr2 :   out std_logic;
        ledeq   :   out std_logic
    );
end Vierbit_Komp;

architecture Behavioral of Vierbit_Komp is
begin

    process (sw1, sw2) begin
    
        if(unsigned(sw1) < unsigned(sw2)) then
            led1kl2 <= '1';
            led1gr2 <= '0';
            ledeq <= '0';
        elsif(unsigned(sw1) > unsigned(sw2)) then
            led1kl2 <= '0';
            led1gr2 <= '1';
            ledeq <= '0';
        else
            led1kl2 <= '0';
            led1gr2 <= '0';
            ledeq <= '1';
        end if;
        
    end process;
end Behavioral;
