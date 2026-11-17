library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SiebenSegment_Decoder is
    port ( 
        selected_stelle :   in std_logic_vector (3 downto 0);
        cntr_select     :   in unsigned (1 downto 0);
        
        seg :   out std_logic_vector (6 downto 0);
        an  :   out std_logic_vector (3 downto 0)
    );
end SiebenSegment_Decoder;


architecture Behavioral of SiebenSegment_Decoder is
begin

    process(cntr_select)
    begin
        case cntr_select is
            when "00" => an <= "0111";      --AN3
            when "01" => an <= "1011";      --AN2
            when "10" => an <= "1101";      --AN1
            when "11" => an <= "1110";      --AN0
        end case;
    end process;
    
    process(selected_stelle)
    begin
        case selected_stelle is
            when "0000" => seg <= "1000000";     --LSB ist Seg A, MSB ist Seg G
            when "0001" => seg <= "1111001";
            when "0010" => seg <= "0100100";
            when "0011" => seg <= "0110000";
            when "0100" => seg <= "0011001";
            when "0101" => seg <= "0010010";
            when "0110" => seg <= "0000011";
            when "0111" => seg <= "1111000";
            when "1000" => seg <= "0000000";
            when "1001" => seg <= "0011000";
            
        end case;
    end process;

end Behavioral;
