library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_N is
    generic(N :natural := 256);
    Port ( data : in STD_LOGIC_VECTOR (N-1 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           enable : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (N-1 downto 0));
end reg_N;

architecture Behavioral of reg_N is

begin

process(clk,rst)
begin
    if(rst = '0') then
        dout <= (others => '0');
    elsif(clk'event and clk = '1') then
        if(enable = '1') then
            dout <= data;
        end if;
    end if;
end process;
 
end Behavioral;
