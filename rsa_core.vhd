library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rsa_core is
    generic(word_length : natural := 256);
    Port ( M : in STD_LOGIC_VECTOR (word_length -1 downto 0);
           E : in STD_LOGIC_VECTOR (word_length -1 downto 0);
           N : in STD_LOGIC_VECTOR (word_length -1 downto 0);
           data_rdy : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           done : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR (word_length -1 downto 0));
end rsa_core;

architecture Behavioral of rsa_core is

component  FM_Mod_Mult
generic( word_length : natural := word_length);
    Port ( N_i : in STD_LOGIC_VECTOR (word_length -1  downto 0);
           X : in STD_LOGIC_VECTOR (word_length -1  downto 0);
           Y : in STD_LOGIC_VECTOR (word_length -1  downto 0);
           NY : in STD_LOGIC_VECTOR (word_length   downto 0);
           enable : in STD_LOGIC;
           ready : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR (word_length -1  downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC);
   end component;
   
component MUX
generic(N: natural := word_length);
    Port ( A : in STD_LOGIC_VECTOR (N-1 downto 0);
           B : in STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (N-1 downto 0)
           );
end component;

component PISO_Nto1
    generic(N : natural := word_length);
    Port ( data : in STD_LOGIC_VECTOR (N-1 downto 0);
           load : in STD_LOGIC;
           shift : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           dout : out STD_LOGIC;
           empty : out STD_LOGIC);
end component;

component mod_exp_fsm
   generic(word_length : natural := word_length);
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
end component;

component reg_N 
        generic(N :natural := word_length);
Port ( data : in STD_LOGIC_VECTOR (N-1 downto 0);
       clk : in STD_LOGIC;
       rst : in STD_LOGIC;
       enable : in STD_LOGIC;
       dout : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component CLA
generic(word_length: natural := word_length);
            
    Port ( a : in STD_LOGIC_VECTOR (word_length -1  downto 0);
           b : in STD_LOGIC_VECTOR (word_length -1   downto 0);
           cin : in STD_LOGIC;
           result : out std_logic_vector(word_length -1 downto 0)
            
           );
end component;
signal s_mm_enable,s_wr_en, s_load_e, s_shift_e, s_E_lsb, s_empty, s_sel, s_mm_rdy, s_mc_enable, s_mc_rdy : std_logic;
signal s_mm_res,s_P, s_mc_res, s_P_reg, s_C_reg, s_m, s_C, s_Co: std_logic_vector(word_length-1 downto 0);
signal s_NY : std_logic_vector(word_length  downto 0);
signal s_NY_CLA, s_N_CLA, s_P_CLA : std_logic_vector(word_length + 3  downto 0);

begin
 s_NY <= s_NY_CLA(word_length downto 0);
 s_P_CLA <= ("0000")& s_P_reg;
 s_N_CLA <= ("0000")& N;
 
MULT_MM: FM_Mod_Mult
    generic map( word_length => word_length)
    Port map (
           N_i => N,
           X => s_M,
           Y => s_M,
           NY => s_NY,
           enable => s_mm_enable,
           ready =>  s_mm_rdy,
           result => s_mm_res,
           clk => clk,
           rst => rst
           );
           
  MULT_MC: FM_Mod_Mult
               generic map( word_length => word_length)
               Port map (
                      N_i => N,
                      X => s_C,
                      Y => s_M,
                      NY => s_NY,
                      enable => s_mc_enable,
                      ready =>  s_mc_rdy,
                      result => s_mc_res,
                      clk => clk,
                      rst => rst
                      );
                      
  MUX_MM: MUX
  generic map(N => word_length)
      Port map( 
             A => s_mm_res,
             B => M,
             sel => s_sel,
             O => s_P
             );

  MUX_MC: MUX
  generic map(N => word_length)
      Port map( 
             A => (others => '1'),
             B => s_mc_res,
             sel => s_sel,
             O => s_Co
             );
 REG_P: REG_N
         generic map(N => word_length)
         Port map( data => s_P,
                clk  => clk,
                rst => rst,
                enable => s_wr_en,
                dout  => s_P_reg
                );
    
 REG_C: REG_N
       generic map(N => word_length)
       Port map( data => s_Co,
                 clk  => clk,
                 rst => rst,
                 enable => s_wr_en,
                 dout  => s_C_reg
                 );  
E_SHIFT: PISO_Nto1
    generic map(N  =>  word_length)
    Port map( data => E,
              load => s_load_e,
              shift => s_shift_e,
              clk  => clk,
              rst => rst,
              dout => s_E_lsb,
              empty => s_empty
              );
EXP_FSM: mod_exp_fsm
    generic map(word_length => word_length)
    Port map ( Data_ready => data_rdy, 
               rst  => rst,
               clk => clk,
               e_lsb => s_E_lsb,
               e_reg_empty => s_empty,
               en_MM  => s_mm_enable,
               en_MC  => s_mc_enable,
               done_MM => s_mm_rdy,
               done_MC => s_mc_rdy,
               wr_en => s_wr_en,
               done_exp  => done,
               shift_e => s_shift_e,
               sel => s_sel
               );

CLA_NY: CLA
           generic map(word_length => word_length + 4)
           Port map (
                   a => s_P_CLA,
                   b => s_N_CLA,
                   cin => '0',
                   result => s_NY_CLA
           );

end Behavioral;
           



