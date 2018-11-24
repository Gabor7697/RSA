library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
generic(N : natural := 16);
    Port ( D : in STD_LOGIC_VECTOR (N downto 0);
           wr_en : in std_logic;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           lsb_out : out std_logic;
           Q : out STD_LOGIC_VECTOR (N downto 0));
end reg;

architecture Behavioral of reg is
   signal Q_i : STD_LOGIC_VECTOR (N downto 0);
begin

process(clk,rst)
begin
    if(rst = '0') then 
        Q_i <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (wr_en = '1') then
        Q_i <= D;
      end if;
    end if;
end process;
lsb_out <= Q_i(0);
Q <= Q_i;

end architecture;