
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Sequenzadressierung is
Port 
(
--Allgemeiner Takt
        clk             : in  STD_LOGIC;
 -- Eingangssignale
       inc_writeS       : in STD_LOGIC; -- vom Sequenzspeicher, wenn erfolgreich eine Zahl geschrieben, bekommt er die nächste Schreibadresse 
       inc1_readS        : in STD_LOGIC; --von der LED-Matrix, um sich Stück für Stück die nächste Zahl zu ziehen
       inc2_readS       : in STD_Logic; -- vom Komperator,wenn der der Spieler es geschafft hat
       reset_cntrS      : in STD_LOGIC; -- vom Zustandsautomaten, wenn der Spielstand zurückgesetzt wird, Runde nicht geschafft oder Runde 64 erreicht, beginnt er bei 0 zu zählen
       en_led           : in STD_LOGIC;
       en_komp          : in STD_LOGIC;
       
--Ausgangssignale      
       read_adressS     : out STD_LOGIC_VECTOR(5 downto 0); --Aktuelle Leseadresse im Sequenzspeicher
       write_adressS    : out STD_LOGIC_VECTOR(5 downto 0) --Aktuelle Schreibadresse im Sequenzspeicher  
);
end Sequenzadressierung;

architecture Behavioral of Sequenzadressierung is
 
 signal writeadress : integer range 0 to 63;
 signal readadress : integer range 0 to 63;

 signal counter_write : integer range 0 to 63;
 signal counter_read : integer range 0 to 63;
 
 signal erster_schreib : STD_LOGIC;


 signal generatorcounter : integer range 0 to 199;
 signal rnd_not_rdy: STD_LOGIC;
 
 signal readcounter : integer range 0 to 199;
 signal read_not_rdy: STD_LOGIC;
 
 signal s_speichern_bee : STD_LOGIC;
 signal s_ledmatrix     : STD_LOGIC:='0';
 signal s_komperator    : STD_LOGIC:='0';
 
begin

 process(clk)
 begin
 
if rising_edge(clk) then 

                -- alles zurücksetzen (bis auf writeadress) auf Startwerte am Anfang
                    if reset_cntrS='1' then
                        counter_write<=0;
                        counter_read<=0;
                        s_speichern_bee<='0';
                        erster_schreib <='1';
                        generatorcounter<=0;
                        s_ledmatrix <='0';
                        s_komperator <='0';
                        rnd_not_rdy<='0';
                        read_not_rdy<='0';
                        
                     end if;
                -- zurücksetzen abgeschlossen 
-- schreibvorgang beginn  
    --
    if rnd_not_rdy ='0' then                        -- Verzögerung, der Zufallsgenerator braucht ne Gedenksekunde
       if generatorcounter < 18 then
            generatorcounter <= generatorcounter +1;  -- Verzögerung
       else
            rnd_not_rdy <='1';
       end if;
    
    else
    --
        writeadress <=0;  --Adresse zurücksetzen
        if erster_schreib='1' or inc_writeS='1' then    
            if counter_write <63 then
               
                writeadress <= counter_write;   
                counter_write <= counter_write +1;
                erster_schreib <='0';
            else 
 
              s_speichern_bee <='1'; -- internes Signal 
            end if;
        end if;
    end if;

-- schreibvorgang abgeschlossen

-- einlesevorgang beginn
        if s_speichern_bee ='1' then
           if  inc2_readS='1' or inc1_readS='1' then   
 
                    if en_LED='1' and s_ledmatrix ='0' then -- Auslesen für LED_Matrix
                        readadress <=0;
                        s_ledmatrix <='1';
                        
                    end if;
                    
                    if en_komp='1' and s_komperator ='0' then -- Auslesen für Komperator
                        readadress <=0;
                        s_komperator <='1';
                        counter_read <=0;
                    end if;                     
               
                    if counter_read <63 then
                        readadress <= counter_read;
                        counter_read <= counter_read +1;
                    end if;
             
            end if;
        end if;
 end if;
 
-- einlesevorgang abgeschlossen


end process;
    
    write_adressS <=std_logic_vector(to_unsigned(writeadress,6));
    read_adressS <=std_logic_vector(to_unsigned(readadress, 6));

end Behavioral;
