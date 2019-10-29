library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Receiver_state is
   port(Clk,reset_n :IN std_logic;
        key, data_line :IN STD_LOGIC;
        Start,shift_start       :OUT STD_LOGIC;
		);
end Receiver_state;
 

architecture Behavioral of Receiver_state is

TYPE state_type IS (Key2,Wait1,Shift,Cryption);
SIGNAL current_state, next_state: state_type;
 
BEGIN   

sync: process(clk, reset_n)
	BEGIN
		if(reset_n = '0') then
			current_state <= IDLE;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		END IF;

End PROCESS;

comb: PROCESS(current_state,)
  BEGIN
	CASE(current_state) IS
	When Key2 => --waits for Key2 to be pressed
		if (key = '1') then 
		    next_state <= Wait1;
		else 
		    next_state <= Key2;
		end if;
	When Wait1 => --waits for the data_line to drop
		if ( data_line = '0') then 
		    next_state <= Shift;
		else 
		    next_state <= Wait1;
		end if;
	When Shift => --sends out the shift bit
	        next_state <= Cryption;
	END CASE;
	
	When Cryption => --sends out the start bit
	        next_state <= Key2;
	END CASE;
	
End PROCESS;

Start_Bit: PROCESS(current_state) BEGIN --output for the start bit
	CASE(current_state) IS
	When Cryption => Start <= '1';
	When others => Start <= '0';
END PROCESS;

Shift_Bit: PROCESS(current_state) BEGIN --output for the shift bit
	CASE(current_state) IS
	When Shift => shift_start <= '1';
	When others => shift_start <= '0';
END PROCESS;

end Behavioral;