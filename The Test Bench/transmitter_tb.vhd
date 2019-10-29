--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*********  Copyright 2010, Rochester Institute of Technology  ***************
--*****************************************************************************
--
--  DESIGNER NAME:  Jeanne Christman
--
--       LAB NAME:  encryption transmitter
--
--      FILE NAME:  transmitter_tb.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This test bench will provide input to test the encryption transmitter
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 11/13/13 | JWC  | 1.0 | original 
-- | 11/12/16 | JWC  | 2.0 | Updated for new DE0-CV board
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;           -- need for conv_std_logic_vector
USE ieee.std_logic_unsigned.ALL;        -- need for "+"


ENTITY TOP_level_tb IS
END TOP_level_tb;


ARCHITECTURE test OF TOP_level_tb IS

   -- Component Declaration for the Unit Under Test (UUT)
   -- if you use a package with the component defined then you do not need this
component TOP_level is 
PORT ( clk, reset_n            : IN std_logic;
       Swithces              		 : IN std_logic_vector(7 downto 0);
		 Key1, Key2              : IN std_logic;
		 HEX0,HEX1               : OUT std_logic_vector(6 downto 0);
		 GPIO                : OUT std_logic;
	--	 LEDR                    : OUT std_logic_vector(7 downto 0)); -- this is for debugging purposes. You may choose to comment out
END component;

   -- define signals for component ports
   SIGNAL clk_tb          : std_logic                    := '0';
   SIGNAL reset_n_tb      : std_logic                    := '0';
   SIGNAL key1_tb         : std_logic                    := '1';
   SIGNAL key2_tb         : std_logic                    := '1';
   SIGNAL switcher_tb     : std_logic_vector(7 DOWNTO 0) := x"00";
   SIGNAL gpio_tb         : std_logic;

   -- Outputs
   SIGNAL hex0_tb   : std_logic_vector(6 DOWNTO 0);
   SIGNAL hex1_tb   : std_logic_vector(6 DOWNTO 0);
   
   -- signals for test bench control
   SIGNAL sim_done : boolean := false;
   SIGNAL PERIOD_c : time    := 20 ns;  -- 50MHz

BEGIN  -- test

   -- component instantiation
   UUT : TOP_level
      PORT MAP (
         clk           => clk_tb,
         reset_n       => reset_n_tb,
         Key1          => key1_tb,
		   Key2          => key2_tb,
         Swithces            => switcher_tb,
         --
		   GPIO        => gpio_tb,
         HEX0            => hex0_tb,
         HEX1            => hex1_tb
         );

   -- This creates an clock_50 that will shut off at the end of the Simulation
   -- this makes a clock_50 that you can shut off when you are done.
   clk_tb <= NOT clk_tb AFTER PERIOD_C/2 WHEN (NOT sim_done) ELSE '0';


   ---------------------------------------------------------------------------
   -- NAME: Stimulus
   --
   -- DESCRIPTION:
   --    This process will apply stimulus to the UUT.
   ---------------------------------------------------------------------------
   stimulus : PROCESS
   BEGIN
      -- de-assert all input except the reset which is asserted
      reset_n_tb      <= '0';
      key1_tb         <= '1';
		key2_tb         <= '1';
      switches_tb     <= x"55";

      -- now lets sync the stimulus to the clk
      -- move stimulus 1ns after clock edge
      WAIT UNTIL clk_tb = '1';
      WAIT FOR 1 ns;
      WAIT FOR PERIOD_c*2;

      -- de-assert reset
      reset_n_tb <= '1';
      WAIT FOR PERIOD_c*2;
      
      --switches now are at "01010101"

      WAIT FOR PERIOD_c*100;
      key1_tb <= '0';
      WAIT FOR PERIOD_c*10;
		key1_tb <= '1';
		switches_tb        <= x"FF";
    
    --lock in the encryption key which is "11111111".  XORing with all ones will
    --invert all of the bits.  
    --The resultant transmit data will drop low for 1us for the start bit and then 
    --go "10101010" at a 1 us rate.
    --a 1us rate means a new bit transmitted every 50 clock cycles
		 WAIT FOR PERIOD_c*10;
		 key2_tb <= '0';
     WAIT FOR PERIOD_c*10;
     key2_tb <= '1';
     WAIT FOR PERIOD_c*600;

	  switches_tb  <= x"12";
	  --switches now are at "00010010"

      WAIT FOR PERIOD_c*100;
      key1_tb <= '0';
      WAIT FOR PERIOD_c*10;
		key1_tb <= '1';
		switches_tb        <= x"34";
    
    --lock in the encryption key which is "00110100".  
	 -- XORing x"12" with x"34" = "00100110"
    --The resultant transmit data will drop low for 1us for the start bit and then 
    --go "00100110" at a 1 us rate.
    --a 1us rate means a new bit transmitted every 50 clock cycles
		 WAIT FOR PERIOD_c*10;
		 key2_tb <= '0';
     WAIT FOR PERIOD_c*10;
     key2_tb <= '1';
     WAIT FOR PERIOD_c*600;
      sim_done <= true;
     
report "simulation complete. This is not a self-checking testbench. You must verify your results manually. The first transmission should be 010101010 and the second should be 000100110.";
      -----------------------------------------------------------------------
      -- This Last WAIT statement needs to be here to prevent the PROCESS
      -- sequence from re starting.
      -----------------------------------------------------------------------
      WAIT;

   END PROCESS stimulus;

	


END test;
