library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX is
generic(N: natural := 256);
    Port ( A : in STD_LOGIC_VECTOR (N-1 downto 0);
           B : in STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (N-1 downto 0)
           );
end MUX;

architecture Behavioral of MUX is
begin

O <= A when sel = '1' else
     B when sel = '0' else
     (others => '0');

end Behavioral;
