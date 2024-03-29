Library Ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shift_Reg is 
port(
	clk : in std_logic;
	reset_n :  in std_logic;
	serial_in :  in std_logic;
	Load: in std_logic;
	Din:  in std_logic_vector(7 downto 0);
	serial_out :  out std_logic);
end shift_reg;
architecture rtl of shift_reg is
	signal Shift_Reg : std_logic_vector(7 downto 0);
	begin
	shifter: process(clk,reset_n,Load,Shift_Reg) begin
			if (reset_n = '0') then
				Shift_Reg <= (others => '0');
			elsif (clk'event and clk = '1') then
				if (Enable = '1') then
					if (Load = '1') then -- load
						Shift_Reg <= Din;
					elsif(Shift = '1') -- shift
						-- shift right
							Shift_Reg(6 downto 0) <= Shift_Reg(7 downto 1);
							Shift_Reg(7) <= serial_in;
					end if;
				end if;    
		   end if;       
	end process;
	serial_out <= Shift_Reg(7); 
End rtl;