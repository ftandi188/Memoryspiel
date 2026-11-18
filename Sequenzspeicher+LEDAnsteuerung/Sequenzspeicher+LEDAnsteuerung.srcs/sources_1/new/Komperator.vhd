
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Komperator is
Port ( 
    --Eingangssignale
    clk          : in STD_LOGIC;
    en_komp      : in STD_LOGIC:='0';
    sequenz_comp : in STD_LOGIC_VECTOR(3 downto 0);
    eingabe_comp : in STD_LOGIC_VECTOR(3 downto 0);

    equal        : OUT STD_LOGIC:='0';
    inc2_readS   : OUT STD_LOGIC:='0';
    inc_readE    : OUT STD_LOGIC:='0'

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
        
                if ersterunde = '0' then
                    counterled <=0;
                    ersterunde <='1';
                    equal <='0';
                    inc2_readS<='0';
                    inc_readE<='0';
                    
                elsif ersterunde ='1' and counterled <63 then 
                
                    inc2_readS<='1';
                    inc_readE<='1';
                    
               
                    
                     if (sequenz_comp = eingabe_comp) then
                        equal <='1';
                        counterled <= counterled +1;
                        
                     elsif counterled = 63 then
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
