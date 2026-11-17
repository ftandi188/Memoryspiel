library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplexer is
     port ( 
        clk             :   in std_logic;
        zehner_pl1      :   in std_logic_vector (3 downto 0);   --entspricht cntr_select = 0
        einer_pl1       :   in std_logic_vector (3 downto 0);   --entspricht cntr_select = 1
        zehner_pl2      :   in std_logic_vector (3 downto 0);   --entspricht cntr_select = 2
        einer_pl2       :   in std_logic_vector (3 downto 0);   --entspricht cntr_select = 3
        
        selected_stelle :   out std_logic_vector (3 downto 0);
        cntr_select     :   out unsigned (1 downto 0)
     );
end Multiplexer;

architecture Behavioral of Multiplexer is
    signal tick_cnt :   integer range 0 to 99999 := 0;
    signal intern_cntr_select   :   unsigned (1 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if tick_cnt = 99999 then
                tick_cnt <= 0;
        
                if intern_cntr_select = "00" then
                    intern_cntr_select <= "01";
                    selected_stelle <= einer_pl1;
                
                elsif intern_cntr_select = "01" then
                    intern_cntr_select <= "10";
                    selected_stelle <= zehner_pl2;
                
                elsif intern_cntr_select = "10" then
                    intern_cntr_select <= "11";
                    selected_stelle <= einer_pl2;
                
                elsif intern_cntr_select = "11" then
                    intern_cntr_select <= "00";
                    selected_stelle <= zehner_pl1;
                end if;
        
            else
                tick_cnt <= tick_cnt + 1;
            end if;
        end if;
    end process;
    cntr_select <= intern_cntr_select;
    
end Behavioral;
