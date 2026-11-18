library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test_Bench_Clock is
end Test_Bench_Clock;

architecture behavior of Test_Bench_Clock is

    
  signal  test_eingabe_comp : STD_LOGIC_VECTOR (3 downto 0);
    
    -- 1. Komponenten-Deklarationen
    component Zufallsgenerator is
        Port ( 
            clk         : in  STD_LOGIC;
            reset_cntrS : in  STD_LOGIC;
            LEDout      : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component Sequenzadressierung is
        Port (
            clk           : in  STD_LOGIC;
            inc_writeS    : in  STD_LOGIC;
            inc_readS     : in  STD_LOGIC;
            inc2_readS    : in  STD_LOGIC;
            reset_cntrS   : in  STD_LOGIC;
            read_adressS  : out STD_LOGIC_VECTOR(5 downto 0);
            write_adressS : out STD_LOGIC_VECTOR(5 downto 0)
            --now_giveout   : out STD_LOGIC;
            --now_store     : out STD_LOGIC;
            --speichern_bee : out STD_LOGIC
        );
    end component;

    component Sequenzspeicher is
        Port (
            clk           : in  STD_LOGIC;
            LEDout        : in  STD_LOGIC_VECTOR(3 downto 0);
            store_random  : in  STD_LOGIC;
            read_adressS  : in  STD_LOGIC_VECTOR(5 downto 0);
            write_adressS : in  STD_LOGIC_VECTOR(5 downto 0);
            --now_giveout   : in  STD_LOGIC;
            --now_store     : in  STD_LOGIC;
            
            inc_writeS    : out STD_LOGIC;
            
            sequenz_comp  : out STD_LOGIC_VECTOR(3 downto 0);
            matrix_ans    : out STD_LOGIC_VECTOR(3 downto 0)    
        );
    end component;

    component AnsteuerungLEDMatrix is
        Port (
            clk        : in  STD_LOGIC;
            en_LED     : in  STD_LOGIC;
            matrix_ans : in  STD_LOGIC_VECTOR(3 downto 0);
            --speichern_bee : in STD_LOGIC;
            ledspalte3 : out STD_LOGIC;
            ledspalte2 : out STD_LOGIC;
            ledspalte1 : out STD_LOGIC;
            ledspalte0 : out STD_LOGIC;        
            ledreihe3  : out STD_LOGIC;
            ledreihe2  : out STD_LOGIC;
            ledreihe1  : out STD_LOGIC;
            ledreihe0  : out STD_LOGIC
        );
    end component;
    
    
    
    component Komperator is
        Port(
    clk          : in STD_LOGIC;
    en_komp      : in STD_LOGIC;
    sequenz_comp : in STD_LOGIC_VECTOR(3 downto 0);
    eingabe_comp : in STD_LOGIC_VECTOR(3 downto 0);

    equal        : OUT STD_LOGIC;
    inc2_readS   : OUT STD_LOGIC;
    inc_readE    : OUT STD_LOGIC
    );
    end component;
    
  
  

    -- 2. Testbench-Signale
    signal clk           : STD_LOGIC; --hier was geändert
    signal reset_cntrS   : STD_LOGIC; --hier was geändert
    signal inc2_readS    : STD_LOGIC; --hier was geändert
    
    signal LEDout        : STD_LOGIC_VECTOR(3 downto 0);
    signal read_adressS  : STD_LOGIC_VECTOR(5 downto 0);
    signal write_adressS : STD_LOGIC_VECTOR(5 downto 0);
    --signal now_giveout   : STD_LOGIC;
    --signal now_store     : STD_LOGIC;
    signal inc_writeS    : STD_LOGIC;
    signal inc_readS     : STD_LOGIC;
    --signal speichern_bee : STD_LOGIC;
    signal sequenz_comp  : STD_LOGIC_VECTOR(3 downto 0);
    signal matrix_ans    : STD_LOGIC_VECTOR(3 downto 0);
    signal en_LED        : STD_LOGIC := '1'; ---Achtung geforced
    
    signal ledspalte3    : STD_LOGIC;
    signal ledspalte2    : STD_LOGIC;
    signal ledspalte1    : STD_LOGIC;
    signal ledspalte0    : STD_LOGIC;        
    signal ledreihe3     : STD_LOGIC;
    signal ledreihe2     : STD_LOGIC;
    signal ledreihe1     : STD_LOGIC;
    signal ledreihe0     : STD_LOGIC;
    
    signal eingabe_comp : STD_LOGIC_VECTOR(3 downto 0);
    signal en_komp : STD_LOGIC; 
    signal equal : STD_LOGIC;
    signal inc_readE : STD_LOGIC; 
    
    constant CLK_PERIOD  : time := 100 ns;

begin

     
     
     wrongcomptest : process(clk)
     variable test_zaehler : integer :=0;
     
     begin 

    if test_zaehler >=12 then
        test_eingabe_comp <= not sequenz_comp;
        
        else 
        
        test_eingabe_comp <= sequenz_comp;
        end if;
    end process;
     
    -- 3. Instantiierungen & Verschaltung
    uut_zufall: Zufallsgenerator
        port map (
            clk         => clk,
            reset_cntrS => reset_cntrS,
            LEDout      => LEDout
        );

    uut_adr: Sequenzadressierung
        port map (
            clk           => clk,
            inc_writeS    => inc_writeS,
            inc_readS     => inc_readS,
            inc2_readS    => inc2_readS,
            reset_cntrS   => reset_cntrS,
            read_adressS  => read_adressS,
            write_adressS => write_adressS
           
            );

    uut_speicher: Sequenzspeicher
        port map (
            clk           => clk,
            LEDout        => LEDout,
            store_random  => '1',
            read_adressS  => read_adressS,
            write_adressS => write_adressS,
           
            inc_writeS    => inc_writeS,
            sequenz_comp  => sequenz_comp,
            matrix_ans    => matrix_ans
        );

    uut_anstled: AnsteuerungLEDMatrix
        port map (
            clk        => clk,
            en_LED     => en_LED,
            matrix_ans => matrix_ans,
            ledspalte3 => ledspalte3,
            ledspalte2 => ledspalte2,
            ledspalte1 => ledspalte1,
            ledspalte0 => ledspalte0,
            ledreihe3  => ledreihe3,
            ledreihe2  => ledreihe2,
            ledreihe1  => ledreihe1,
            ledreihe0  => ledreihe0
        );
        
    uut_komper: Komperator
    port map (
    
    clk          => clk,
    en_komp      => en_komp,
    sequenz_comp => sequenz_comp,
    eingabe_comp => eingabe_comp,
    
    equal        => equal,
    inc2_readS   => inc2_readS,
    inc_readE    => inc_readE

    );
    
    -- 4. Takt-Generator-Prozess
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- 5. Stimuli-Prozess
    stim_process : process
    begin
        reset_cntrS <= '1';        
        --inc2_readS  <= '0';
        wait for 200 ns;
        
        reset_cntrS <= '0';
        wait for 8 us;
        
        --inc2_readS <= '1';
        wait for 7 us;
        --inc2_readS <= '0';
        
        wait;
    end process;

end behavior;