library IEEE;
 
use IEEE.STD_LOGIC_1164.ALL;
  
use IEEE.NUMERIC_STD.ALL; 
 
use IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Mux IS

	PORT( q1, q2, q3 :IN STD_LOGIC;
	
	        sel :IN STD_LOGIC_VECTOR (1 DOWNTO 0);
	
			Edge :OUT STD_LOGIC
		);

END Mux;

Architecture Wake OF Mux  IS

Signal Edgy :STD_LOGIC; --signal for the output


BEGIN --ARCHITEVTURTE BEGINS

Selection: Process (sel)

	BEGIN
	
	case sel IS
	
WHEN "01" => Edgey <= q2;

WHEN "10" => Edgey <= q3;

WHEN OTHERS => Edgey <= q1;
	
					
END PROCESS;

Edge <= Edgey;

q2 <= '1';

q3 <= '0';

END Wake;