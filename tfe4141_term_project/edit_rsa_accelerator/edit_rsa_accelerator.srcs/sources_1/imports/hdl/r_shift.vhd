library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity r_shift is
    generic(N : natural := 16);
    Port ( x_in : in STD_LOGIC_VECTOR (N+1 downto 0);
           x_out : out STD_LOGIC_VECTOR (N downto 0));
end r_shift;

architecture Behavioral of r_shift is

begin
x_out <= x_in(N+1 downto 1);

end Behavioral;
