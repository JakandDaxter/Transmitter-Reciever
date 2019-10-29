library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
  
use IEEE.NUMERIC_STD.ALL; 
 
use IEEE.STD_LOGIC_SIGNED.ALL; 

ENTITY MOD8 IS

	PORT(  enable1,enable2 :IN STD_LOGIC;
				clk :IN STD_LOGIC;
				reset_n :IN STD_LOGIC;
				CNT : in std_logic_vector(2 downto 0); -- count is the flag which goes to the finite state machine
				
			);
			
END MOD8;
	
ARCHITECTURE Counter OF MOD8 IS



signal counting: STD_LOGIC_VECTOR(3 DOWNTO 0);

signal counter_output: STD_LOGIC;


BEGIN

Modulous8: Process (reset_n, clk)

	BEGIN

IF (reset_n = '0') THEN

		coutning <= 0;
	
		ELSIF(RISING_EDGE(clk)) THEN
		
			IF(enable1 = '1') THEN
		
			IF(enable2 = '1') THEN
			
			IF(couting = "111") THEN
			
				counter_output <="000";
				
			ELSE
				
				counter_output <= counter_output + '1';
			
END PROCESS;

CNT <= counter_output;			
			
		
END Counter;
	
	
	