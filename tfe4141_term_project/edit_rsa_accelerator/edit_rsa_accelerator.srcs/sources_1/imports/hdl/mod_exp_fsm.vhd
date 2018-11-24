library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mod_exp_fsm is
    generic(word_length : natural := 256);
    Port ( Data_ready : out STD_LOGIC;
           Data_valid : in std_logic;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           load_e : out std_logic;
           e_lsb : in STD_LOGIC;
           rst_MULT : out std_logic;
           e_reg_empty : in STD_LOGIC;
           en_MM : out STD_LOGIC;
           en_MC : out STD_LOGIC;
           done_MM : in STD_LOGIC;
           done_MC : in STD_LOGIC;
           wr_en : out STD_LOGIC;
           done_exp : out STD_LOGIC;
           received: in std_logic;
           shift_e : out STD_LOGIC;
           sel : out STD_LOGIC);
end mod_exp_fsm;

architecture Behavioral of mod_exp_fsm is
type state is (idle, load_in, waitt, mult, reload, done);
signal pr_state, nx_state : state;

signal i, i_reg: natural range 0 to word_length;

begin

process(clk, rst)
begin
    if (rst = '0') then
        i_reg <= 0;
    elsif (clk'event and clk = '1') then
        i_reg <= i;
    end if;
end process;

process(clk, rst)
begin
    if (rst = '0') then
        pr_state <= idle;
    elsif (clk'event and clk = '1') then
        pr_state <= nx_state;
    end if;
end process;

process(pr_state, i, i_reg, Data_valid, e_lsb, e_reg_empty, done_MM, done_MC, received)
begin
Data_ready <= '0';
wr_en    <= '0';
sel      <= '0';
en_MM    <= '0';
en_MC    <= '0';
shift_e  <= '0';
done_exp <= '0';
i        <=  0 ;
load_e   <= '0';
rst_MULT <= '1';
case pr_state is
    when idle =>
        rst_MULT <= '0';
        Data_ready <= '1';
        if (Data_valid = '1') then
            nx_state <= load_in;
        else
            nx_state <= idle;
        end if;
    when load_in =>
        wr_en <= '1';
        load_e <= '1';
        nx_state <= waitt;
    when waitt => 
    if(e_reg_empty = '0') then
      if(e_lsb = '0') then
           en_MM <= '1';    
        else
           en_MM <= '1';
           en_MC <= '1';
        end if;
        i <= i_reg;
        nx_state <= mult;
      else
        nx_state <= done;
      end if;
    when mult =>         
        if(e_reg_empty = '0' and i < word_length -1 and (done_MM = '1'or done_MC = '1')) then
            i <= i_reg + 1;  
            nx_state <= reload;
            sel <= '1';
            wr_en <= '1';
            shift_e <= '1';
        else
           nx_state <= mult;
       end if;   
   when reload =>
        i <= i_reg;
        rst_MULT <= '0';
        nx_state <= waitt;
   when done =>
        done_exp <= '1';
        if(received = '1') then
            nx_state <= idle;
        else 
            nx_state <= done;
        end if;
   when  others =>
        nx_state <= idle;
   end case;
end process;
end Behavioral;
