library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PISO_Nto1 is
    generic(N : natural := 256);
    Port ( data : in STD_LOGIC_VECTOR (N-1 downto 0);
           load : in STD_LOGIC;
           shift : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           dout : out STD_LOGIC;
           empty : out STD_LOGIC);
end PISO_Nto1;

architecture Behavioral of PISO_Nto1 is

    signal s_data : STD_LOGIC_VECTOR (N-1 downto 0 );
    signal zero : std_logic_vector( N-1 downto 0);

begin
zero <= (others => '0');

process (clk, rst, load, shift) 
    begin
    if (rst = '0') then
        s_data <= (others => '0');
    elsif ((clk'event and clk = '1')) then
        if(load = '1') then
            s_data <= data;
        else
            if (shift = '1' ) then 
                s_data(N-2 downto 0) <= s_data(N-1 downto 1 );
                s_data(N-1) <= '0';
            else 
                s_data <= s_data;
            end if;
       end if;
    end if;
end process;  



dout <= s_data(0);
empty <= '1' when (s_data(N-1 downto 0) = zero)
          else '0';


end Behavioral;
