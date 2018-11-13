----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2018 07:53:36 PM
-- Design Name: 
-- Module Name: mod_exp_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_exp_fsm is
    generic(word_length : natural := 256);
    Port ( Data_ready : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           e_lsb : in STD_LOGIC;
           e_reg_empty : in STD_LOGIC;
           en_MM : out STD_LOGIC;
           en_MC : out STD_LOGIC;
           done_MM : in STD_LOGIC;
           done_MC : in STD_LOGIC;
           wr_en : out STD_LOGIC;
           done_exp : out STD_LOGIC;
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

process(clk, rst, pr_state, i, i_reg, Data_ready, e_lsb, e_reg_empty, done_MM, done_MC)
begin
wr_en    <= '0';
sel      <= '0';
en_MM    <= '0';
en_MC    <= '0';
shift_e  <= '0';
done_exp <= '0';
i        <=  0 ;

case pr_state is
    when idle =>
        if (Data_ready = '1') then
            nx_state <= load_in;
        else
            nx_state <= idle;
        end if;
    when load_in =>
        wr_en <= '1';
        nx_state <= waitt;
    when waitt => 
        if(e_lsb = '0') then
           en_MM <= '1';    
        else
           en_MM <= '1';
           en_MC <= '1';
        end if;
        i <= i_reg;
        nx_state <= mult;
    when mult =>         
        if(e_reg_empty = '0' and i < word_length and (done_MM = '1'or done_MC = '1')) then
            nx_state <= reload;
            i <= i_reg + 1;  
        elsif(e_reg_empty = '1' and i >= word_length and (done_MM = '1'or done_MC = '1')) then 
            nx_state <= done;
        else
           nx_state <= mult;
       end if;   
   when reload =>
        i <= i_reg;
        wr_en <= '1';
        shift_e <= '1';
        sel <= '1';
        nx_state <= waitt;
   when done =>
        done_exp <= '1';
        nx_state <= idle;
   when  others =>
        nx_state <= idle;
   end case;
end process;
end Behavioral;
