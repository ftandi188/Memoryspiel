
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Sequenzspeicher is
Port (
--Allgemeiner Takt
        clk         : in  STD_LOGIC;
        
--Neue Werte von Sequenzspeicher

--Eingangssignale
       LEDout           : in STD_LOGIC_VECTOR(3 downto 0);--LEDout sind die untersten 4-Bit von Zufallsgenerator
       store_random     : in STD_LOGIC;
       
       read_adressS     : in STD_LOGIC_VECTOR(5 downto 0);
       write_adressS    : in STD_LOGIC_VECTOR(5 downto 0);
     
 --Ausgangssignale

       inc_writeS       : out STD_LOGIC;
       sequenz_comp     : out STD_LOGIC_VECTOR(3 downto 0);
       matrix_ans       : out STD_LOGIC_VECTOR(3 downto 0)   
);

end Sequenzspeicher;

architecture Behavioral of Sequenzspeicher is

        signal int_read_adressS     : integer range 0 to 63;
        signal int_write_adressS    : integer range 0 to 63;

        type t_Sequenzspeicher is array (0 to 63) of std_logic_vector (3 downto 0);
        signal speicher:t_Sequenzspeicher;

begin

int_read_adressS <=TO_INTEGER(unsigned(read_adressS));
int_write_adressS  <=TO_INTEGER(unsigned(write_adressS));   


-- einspeichern 
process(clk)

begin
 if rising_edge(store_random) then --Alternative zum testen!!! -->> if rising_edge(clk) then 
 
 inc_writeS<='0';
       
                if int_write_adressS <= 63 then
                  
                
                speicher(int_write_adressS)<=LEDout;-- an die Schreibadresse wird der aktuelle Wert 4-Bit wert reingemacht
                inc_writeS<='1';-- wenn er erfolgreich war, setzt er ein Signal auf inc_writeS, damit das Ding inkrementiert wird
                
                end if;
 end if;
 
 end process;
-- speichern beendet
 process(int_read_adressS)
 begin
        sequenz_comp<=(others=>'0');
        matrix_ans <=(others=>'0');
       
                if int_read_adressS <=63 then
            
                    sequenz_comp <=speicher(int_read_adressS); --hier könnte man auch nur ein Signal erwägen, da ja beides gleichzeitig dasselbe ist
                    matrix_ans <=speicher(int_read_adressS);
             
        end if;                 
             
           
  end process;
  
end Behavioral;
