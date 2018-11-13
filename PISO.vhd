----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2018 02:34:28 PM
-- Design Name: 
-- Module Name: PISO - Behavioral
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

entity PISO is
generic( N : natural := 256;
        word_length : natural := 32);
    Port ( Data : in STD_LOGIC_VECTOR (N-1 downto 0);
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           load : in std_logic;
           
           Q : out STD_LOGIC_VECTOR(word_length-1 downto 0)
           );
end PISO;

architecture Behavioral of PISO is
signal temp: std_logic_vector(N-1 downto 0);

begin
process(clk,rst,en,Data)
begin
    if(rst = '1') then
        temp <= (others => '0');
    elsif(clk'event and clk = '1' and en = '1') then
        if(load = '1') then
         
            temp(N-word_length-1  downto 0) <= temp(N-1 downto word_length);
            temp(N-1 downto N-word_length) <= (others => '0');
        else 
            temp <= Data;
        end if;
    end if;
end process;
                
Q <= temp(word_length -1 downto 0);

end Behavioral;
