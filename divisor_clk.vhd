-- DIVISOR DE CLOCK para dar o tempo correto
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
 
entity divisor_clk is
port (clk_in: in std_logic;
        q: out std_logic);
end divisor_clk;
 
architecture behavioral of divisor_clk is
signal clk_div: std_logic;
begin
 
process(clk_in)
variable count: integer:= 0;                                               
begin                                                      
    if(clk_in'event and clk_in='1') then
        count:= count+1;
        if(count = 25000000) then
            clk_div <= not clk_div;
            count:= 1;
        end if;
    end if;
end process;
 
q <= clk_div;
 
end behavioral;