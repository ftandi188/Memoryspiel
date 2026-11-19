library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity eingabespeicher is
    Port ( clk            : in  STD_LOGIC;
           en_store       : in  STD_LOGIC;
           key_code       : in  STD_LOGIC_VECTOR (3 downto 0);
           write_addressE : in  STD_LOGIC_VECTOR (5 downto 0);
           read_addressE  : in  STD_LOGIC_VECTOR (5 downto 0);
           inc_writeE     : out STD_LOGIC;
           data_outE      : out STD_LOGIC_VECTOR (3 downto 0));
end eingabespeicher;

architecture Behavioral of eingabespeicher is
    type mem_t is array (0 to 63) of std_logic_vector(3 downto 0);
    signal mem : mem_t := (others => (others => '0'));
begin

    -- Schreiben (synchron) und inc_writeE-Impuls
    process(clk)
    begin
        if rising_edge(clk) then
            inc_writeE <= '0';                  -- Standardwert: kein Impuls
            if en_store = '1' then
                mem(to_integer(unsigned(write_addressE))) <= key_code;
                inc_writeE <= '1';              -- 1 Takt High nach dem Speichern
            end if;
        end if;
    end process;

    -- Lesen (asynchron)
    data_outE <= mem(to_integer(unsigned(read_addressE)));

end Behavioral;