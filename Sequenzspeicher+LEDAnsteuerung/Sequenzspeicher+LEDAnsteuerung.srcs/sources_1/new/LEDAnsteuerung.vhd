library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--Backlog:
--Aktuell gibts noch n Dauerfeuer der LED's, soll ich n dummen Zähler machen? 

entity AnsteuerungLEDMatrix is

Port 
( 
 --Eingangssignale
 
 clk         : in STD_LOGIC;
 en_LED      : in STD_LOGIC;
 matrix_ans  : in STD_LOGIC_VECTOR(3 downto 0);
 
 -- Ausgangssignale
 inc1_readS: out std_logic;
 ledspalte3: out std_logic;
 ledspalte2: out std_logic;
 ledspalte1: out std_logic;
 ledspalte0: out std_logic;
 
 ledreihe3: out std_logic;
 ledreihe2: out std_logic;
 ledreihe1: out std_logic;
 ledreihe0: out std_logic
  );

end AnsteuerungLEDMatrix;

architecture Behavioral of AnsteuerungLEDMatrix is

begin
process(clk)

variable spalte : STD_LOGIC_VECTOR (3 downto 0);
variable reihe  : STD_LOGIC_VECTOR (3 downto 0);

variable spalte2bit: STD_LOGIC_VECTOR (1 downto 0);
variable reihe2bit : STD_LOGIC_VECTOR (1 downto 0);
variable start_ein : STD_LOGIC:='0';

begin

  if rising_edge(clk) then
    if en_LED='1' then 
                        if start_ein = '0' then --Verzögerung und Initialisieren 
                           start_ein :='1';
                           inc1_readS<='1';                           
                        end if;                 --Verzögerung und Initialisieren 
                        
        if start_ein ='1' then                  
      
            spalte :="0000";
            reihe :="0000";       
            spalte2bit:=matrix_ans(1 downto 0);
            reihe2bit:=matrix_ans(3 downto 2);
 
        case spalte2bit is
            when "00" => spalte :=  "0001";
            when "01" =>  spalte := "0010";
            when "10" =>  spalte := "0100";
            when "11" =>  spalte := "1000";
            when others => spalte := "0000";
        end case;
    
        case reihe2bit is
            when "00" => reihe := "0001";
            when "01" => reihe := "0010";
            when "10" => reihe := "0100";
            when "11" => reihe := "1000";
            when others => reihe := "0000";
        end case;
        
        end if;  
        
 ledspalte3 <=spalte(3);
 ledspalte2 <=spalte(2);
 ledspalte1 <=spalte(1);
 ledspalte0 <=spalte(0);
 
 ledreihe3 <=reihe(3);
 ledreihe2 <=reihe(2);
 ledreihe1 <=reihe(1);
 ledreihe0 <=reihe(0);
 
 
end if;
end if;
end process;
    
 
end Behavioral;

