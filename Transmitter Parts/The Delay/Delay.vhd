library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
  
use IEEE.NUMERIC_STD.ALL; 
 
use IEEE.STD_LOGIC_SIGNED.ALL; 

ENTITY Delay IS

PORT (	enable, clk, reset_n :IN STD_LOGIC;

			flag :OUT STD_LOGIC; 
			
			);
END Delay;

ARCHITECTURE Clock OF Delay IS

------------------------------------------------------------------------------------------------------------ the mux stuff
constant micro_sec 		: STD_LOGIC_VECTOR(27 DOWNTO 0) := X"0000031";
------------------------------------------------------------------------------------------------------------

Signal Maxwell 			:STD_LOGIC_VECTOR (27 DOWNTO 0); -- is the signal which gets the microsecond value for the delay.

Signal internal_test		:STD_LOGIC;

signal flager 				:STD_LOGIC;

Signal Max_Val 			:STD_LOGIC_VECTOR (27 DOWNTO 0);

BEGIN 


Reaching_a_micro_second : Process (clk, reset_n,flager) -- clocks the enable for the shift register

BEGIN

IF (reset_n = '0') THEN
 
				flager  <= '0';
 
         Maxwell <= (OTHERS => '0');
                      
            ELSIF (RISING_EDGE(clk)) THEN
 
						IF ( Maxwell = Max_Val) THEN
						
									flager <= '1';
						
							IF(enable = '1') THEN
           
							Maxwell <= (OTHERS => '0');           
 
                   ELSE 
						    
					flager <= '0';
                                   
            Maxwell <= Maxwell +'1';
END IF;
                       
END IF;

END PROCESS;



flag <= flager;

tst_pt <= internal_test;

END Clock;