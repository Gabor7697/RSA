library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mod_mult is
generic(N : natural := 16);
    Port (
           en : in STD_LOGIC;
           clk: in std_logic;
           rst : in STD_LOGIC;
           X : in STD_LOGIC_VECTOR (N-1 downto 0);
           wr_en : out std_logic;
           xi : out STD_LOGIC;
           dv : out std_logic
           );
end mod_mult;

architecture Behavioral of mod_mult is

type state is (idle, write, add, finish);

signal pr_state, nx_state : state;

signal i, i_reg : natural range 0 to N +1;
begin
process(clk,rst)
begin
    if rst = '0' then
        i_reg <= 0;
    elsif(clk'event and clk = '1') then
        i_reg <= i;
    end if;
end process; 

process(clk,rst)
begin   
    if rst = '0' then
        pr_state <= idle;
    elsif (clk'event and clk = '1') then 
        pr_state <= nx_state;
    end if;
end process;

process(en,pr_state, i, i_reg,X)
begin 
wr_en <= '0';
xi <= '0';
i <= 0;
dv <= '0';
 case pr_state is
    when idle => 
        if(en = '1') then
            nx_state <= write;
        else 
            nx_state <= idle;
        end if;
    when write =>
        wr_en <= '1';
        nx_state <= add;
    when add =>
        i <= i_reg + 1;
        if(i >= N) then 
         wr_en <= '0';
         nx_state <= finish;
        elsif (i < N) then
            wr_en <= '1';
            xi <= X(i_reg);
            nx_state <= add;
        else 
            nx_state <= idle;
        end if;
   when finish =>
    dv <= '1';
    nx_state <= idle;
  when others => 
    nx_state <=  finish;
end case;
         
end process;
end Behavioral;