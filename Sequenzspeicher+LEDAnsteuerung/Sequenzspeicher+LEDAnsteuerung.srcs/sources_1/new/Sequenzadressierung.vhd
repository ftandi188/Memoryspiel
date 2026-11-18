
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
       inc_readS        : in STD_LOGIC; --von der LED-Matrix, um sich Stück für Stück die nächste Zahl zu ziehen
       inc2_readS       : in STD_Logic; -- vom Komperator,wenn der der Spieler es geschafft hat
       reset_cntrS      : in STD_LOGIC; -- vom Zustandsautomaten, wenn der Spielstand zurückgesetzt wird, Runde nicht geschafft oder Runde 64 erreicht, beginnt er bei 0 zu zählen
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
 signal erster_lese:     STD_LOGIC;

 signal generatorcounter : integer range 0 to 199;
 signal rnd_not_rdy: STD_LOGIC;
 
 signal readcounter : integer range 0 to 199;
 signal read_not_rdy: STD_LOGIC;
 
 signal s_speichern_bee : STD_LOGIC;
begin

 process(clk)
 begin
 
if rising_edge(clk) then 

-- alles zurücksetzen auf Startwerte am Anfang
    if reset_cntrS='1' then
    
        writeadress <=0; --Adresse zurücksetzen
        readadress <=0;  --Adresse zurücksetzen
        
        counter_write<=0;
        counter_read<=0;
        
        erster_schreib <='1';
        erster_lese <='1';
        
        rnd_not_rdy<='0';
        read_not_rdy<='0';
        
     end if;
-- zurücksetzen abgeschlossen
    
-- schreibvorgang beginn
    
    --
    if rnd_not_rdy ='0' then
       if generatorcounter < 18 then
          generatorcounter <= generatorcounter +1;
       else
          rnd_not_rdy <='1';
          
       end if;
    
    else
    --
        if erster_schreib='1' or rising_edge(inc_writeS) then 
            if counter_write <64 then
               
                writeadress <= counter_write;   
                counter_write <= counter_write +1;
                erster_schreib <='0';
            else 
         
              s_speichern_bee <='1'; -- internes Signal 
            end if;
        end if;
    end if;
end if;
-- schreibvorgang abgeschlossen

-- einlesevorgang beginn
if s_speichern_bee ='1' then
            
        if erster_lese='1' or inc2_readS='1' or inc_readS='1' then   
        
            if counter_read = counter_write then  -- damit wenn die LED-Matrix durchgelaufen ist, und der komperator eine Andresse anfordert, wieder bei 0 begonnen wird
                counter_read <=0;
               
             elsif counter_read <64 then
             
                readadress <= counter_read;
         
                counter_read <= counter_read +1;
                end if;
        end if;
-- einlesevorgang abgeschlossen

end if;

end process;
    
    write_adressS <=std_logic_vector(to_unsigned(writeadress,6));
    read_adressS <=std_logic_vector(to_unsigned(readadress, 6));

end Behavioral;
