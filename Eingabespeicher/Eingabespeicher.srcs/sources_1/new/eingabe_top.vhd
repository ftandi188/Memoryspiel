library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eingabe_top is
    Port ( clk            : in  STD_LOGIC;
           en_store       : in  STD_LOGIC;
           key_code       : in  STD_LOGIC_VECTOR (3 downto 0);
           reset_cntrE    : in  STD_LOGIC;
           inc_readE      : in  STD_LOGIC;
           data_outE      : out STD_LOGIC_VECTOR (3 downto 0);
           read_addressE  : out STD_LOGIC_VECTOR (5 downto 0);
           write_addressE : out STD_LOGIC_VECTOR (5 downto 0));
end eingabe_top;

architecture Structural of eingabe_top is
    signal inc_writeE_s     : STD_LOGIC;
    signal read_addressE_s  : STD_LOGIC_VECTOR (5 downto 0);
    signal write_addressE_s : STD_LOGIC_VECTOR (5 downto 0);
begin

    u_speicher : entity work.eingabespeicher
        port map ( clk            => clk,
                   en_store       => en_store,
                   key_code       => key_code,
                   write_addressE => write_addressE_s,
                   read_addressE  => read_addressE_s,
                   inc_writeE     => inc_writeE_s,
                   data_outE      => data_outE );

    u_adressierung : entity work.eingabe_adressierung
        port map ( clk            => clk,
                   reset_cntrE    => reset_cntrE,
                   inc_writeE     => inc_writeE_s,
                   inc_readE      => inc_readE,
                   read_addressE  => read_addressE_s,
                   write_addressE => write_addressE_s );

    read_addressE  <= read_addressE_s;
    write_addressE <= write_addressE_s;

end Structural;