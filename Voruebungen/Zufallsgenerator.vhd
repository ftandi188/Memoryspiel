library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Zufallsgenerator is
    Port ( 
        clk    : in  STD_LOGIC;
        enable : in  STD_LOGIC;
        LEDout : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Zufallsgenerator;

architecture Behavioral of Zufallsgenerator is
    --startet wenn das fpga startet
    signal counter : unsigned(31 downto 0) := (others => '0');

begin

    process(clk)
    
    variable temp :     STD_LOGIC_VECTOR(31 downto 0):= (others =>'0');
    variable seed_v :     STD_LOGIC_VECTOR(7 downto 0 ):=(Others=>'0');
    variable seed_n :     STD_LOGIC_VECTOR(7 downto 0 ):=(Others=>'0');
    variable schieben:  STD_LOGIC;
   
    begin   
        
        if rising_edge(clk)and (enable='1') then
            
            counter <= counter + 1; --zählt permanent
 
           temp := std_logic_vector(counter);
         
          seed_v(7) := temp(31) xor temp(3);
          seed_v(6) := temp(27) xor temp(19) xor temp(7)  xor temp(1);
          seed_v(5) := temp(29) xor temp(13) xor temp(5)  xor temp(0)xor temp(25);
          seed_v(4) := temp(25) xor temp(17) xor temp(9)  xor temp(4);
          seed_v(3) := temp(21) xor temp(1) xor temp(7)  xor temp(4);
          seed_v(2) := temp(12) xor temp(7) xor temp(4)  xor temp(3);
          seed_v(1) := temp(17) xor temp(5) xor temp(2)  xor temp(9);
          seed_v(0) := temp(30) xor temp(27) xor temp(10)  xor temp(1);
           
    schieben := seed_v(7) xor seed_v(4) xor seed_v (1) xor seed_v (0);
    seed_n := seed_n(6 downto 0) & schieben;
    
    LEDout(3) <=seed_n(3);
    LEDout(2) <=seed_v(7);
    LEDout(1) <=seed_n(5);
    LEDout(0) <=seed_v(0);
    
        end if;
    end process;

end Behavioral;


