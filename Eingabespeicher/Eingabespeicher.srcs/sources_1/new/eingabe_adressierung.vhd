library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity eingabe_adressierung is
    Port ( clk            : in  STD_LOGIC;
           reset_cntrE    : in  STD_LOGIC;
           inc_writeE     : in  STD_LOGIC;
           inc_readE      : in  STD_LOGIC;
           read_addressE  : out STD_LOGIC_VECTOR (5 downto 0);
           write_addressE : out STD_LOGIC_VECTOR (5 downto 0));
end eingabe_adressierung;

architecture Behavioral of eingabe_adressierung is
    signal read_cnt  : unsigned(5 downto 0) := (others => '0');
    signal write_cnt : unsigned(5 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset_cntrE = '1' then            -- Reset hat Vorrang
                read_cnt  <= (others => '0');
                write_cnt <= (others => '0');
            else
                if inc_writeE = '1' then
                    write_cnt <= write_cnt + 1;  -- 63 -> 0 automatisch
                end if;
                if inc_readE = '1' then
                    read_cnt <= read_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    read_addressE  <= std_logic_vector(read_cnt);
    write_addressE <= std_logic_vector(write_cnt);

end Behavioral;