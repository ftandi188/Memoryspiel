
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Komperator is
Port ( 
    --Eingangssignale
    clk          : in STD_LOGIC;
    en_komp      : in STD_LOGIC:='0';
    sequenz_comp : in STD_LOGIC_VECTOR(3 downto 0); --64x4 Bit Arraay von Sequenzspeicher
    eingabe_comp : in STD_LOGIC_VECTOR(3 downto 0); -- 64x4 Bit Array von Eingabefeld

    equal        : OUT STD_LOGIC;
    inc2_readS   : OUT STD_LOGIC;
    inc_readE    : OUT STD_LOGIC

);
end Komperator;

architecture Behavioral of Komperator is

     signal counterled : Integer range 0 to 63; -- Rundenzähler
     signal ersterunde : STD_LOGIC:='0';
     
     
    begin
        process(clk)
        begin 
        if rising_edge(clk) then
          
            if en_komp ='1' then
        
                if ersterunde = '0' then        --Initialisieren und Verzögerung
                    counterled <=0;
                    ersterunde <='1';
                    equal <='0';
                    inc2_readS<='1';
                    inc_readE<='1';
                    
                else                            --Initialisieren und Verzögerung
                
                    if ersterunde ='1' and counterled <63 then 
                
                        if (sequenz_comp = eingabe_comp) then -- wenn gleich
                            equal <='1';
                            counterled <= counterled +1;
                        end if;
                             
                        if (sequenz_comp /= eingabe_comp) then -- wenn ungleich
                            equal <='0';
                            inc2_readS<='0';
                            inc_readE<='0';
                            ersterunde<='0';
                        end if;
                     end if;
                        
                     if ersterunde ='1' and counterled = 63 then -- wenn maximum erreicht 
                            equal <='0';
                            inc2_readS<='0';
                            inc_readE<='0';
                            ersterunde<='0';
                       end if;
                end if;                     
        end if; 
end if;
end process;   
end Behavioral;
