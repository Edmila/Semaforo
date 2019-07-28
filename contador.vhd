-- Semaforo Digtal Utilizando FPGA (Top Level)
--Autores: Edmila de Macedo e Gustavo Golzio.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
 
entity semaforo  is
	port(
	clock : in std_logic;
	reset : in std_logic;
	verde: out std_logic;	-- GPIO 34
	vermelho:out std_logic;	-- GPIO 35
	
		--------- MEMORIA FLASH
	led: out std_logic;
	key : in std_logic:='0';
	flash_adress:out std_logic_vector(21 downto 0);
	f_reset:out std_logic;
	f_out_ena: out std_logic;
	f_write_ena:out std_logic;
	f_data: in std_logic_vector(7 downto 0)
	);
	
end semaforo ;
 
architecture arq of semaforo  is

	signal temp:integer range 0 to 60;
	signal clk_1hz:std_logic;
	signal ver:std_logic_vector(7 downto 0);
	signal teste:std_logic_vector(7 downto 0):="00110000";--"01100000"; -- 30 e 60 que esta na memoria
	signal cont:std_logic;--_vector(7 downto 0);
		-- signal para o sinal convertido receber 30 do de que tem na memoriaa
	signal conver:integer range 0 to 30;
	signal conver1:integer range 0 to 31;
	signal conver2:integer range 0 to 32;
	signal conver3:integer range 0 to 33;
	signal conver4:integer range 0 to 34;

	component divisor_clk is
	port (clk_in: in std_logic;
        q: out std_logic);
	end component;

	begin
	----- FLASH --------
	flash_adress<= "0000000000000000000000"; 	-- endereço do que esta na memoria
	ver(7 downto 0)<= f_data when key='0' else (others => '0'); -- ver = dado que esta na memoria
	led<= '1' when ver = teste else '0';	-- acender o led caso o que esteja na memoria seja o mesmo que esta em teste
	f_reset<='1';
	f_out_ena<=key;
	f_write_ena<='1';
	-- 30 em bin e 30 em hexa		--o que tem em ver ta em hexa ai passa pra binario pra poder comparar
	
	conver <= 30 when ver = "00110000" else 0;  --"01100000"
	conver1 <= 31 when ver = "00110000" else 0; --"01100000"
	conver2 <= 32 when ver = "00110000" else 0; --"01100000"
	conver3 <= 33 when ver = "00110000" else 0; --"01100000"
	conver4 <= 34 when ver = "00110000" else 0; --"01100000"
	-- quando o que tem na memoria for igual àquele valor, entao vai ter o range  

	-- Declaracao do objeto
	divisor: divisor_clk port map(clk_in =>clock, q =>clk_1hz);

	process (reset, clock) --sensibilidade
	begin
        if reset = '1' then
            temp <= 0;
     elsif rising_edge(clk_1hz) then --elsif clock'event and clock ='1' then tambem serve
            temp <= temp + 1;
        end if;
    end process;
	 
	 verde <= '0' when temp = conver or temp = conver1 or temp = conver2 or temp = conver3 or temp = conver4 else '1'; 
	 vermelho <= '1' when temp = conver or temp = conver1 or temp = conver2 or temp = conver3 or temp = conver3 else '0'; 
	 
end arq;