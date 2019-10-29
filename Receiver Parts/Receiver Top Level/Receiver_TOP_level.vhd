library ieee;  
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_unSIGNED.ALL;

ENTITY Receiver_TOP_level IS

PORT( Switchero :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    Key, clk, reset_n, data_line :IN STD_LOGIC; 
    HEX0,HEX1 :OUT STD_LOGIC_VECTOR(6 DOWNTO 0));   
END Receiver_TOP_level;

ARCHITECTURE TOPS OF Receiver_TOP_level IS
----------------------------------------------------------------------------------
COMPONENT BCD2SSD IS
PORT(Bin :IN STD_LOGIC_VECTOR(3 downto 0);                             
     Hex :OUT STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT; 
----------------------------------------------------------------------------------
COMPONENT Encrypt_Decrypt IS
 port(Enable, Clk                  : in std_logic; 
      Data_In_Port1, Data_In_Port2 : in std_logic_vector(7 downto 0);
      Data_out  : out std_logic_vector(7 downto 0)); 
END COMPONENT;
---------------------------------------------------------------------------------- 
COMPONENT Delay IS
PORT (	enable, clk, reset_n :IN STD_LOGIC;
	flag :OUT STD_LOGIC);
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Synchronizer IS
PORT( clk,reset_n,Data_in:IN STD_LOGIC; 
    
      Wake, Data_out :OUT STD_LOGIC
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Shift_Reg IS
port(
	clk : in std_logic;
	reset_n :  in std_logic;
	serial_in :  in std_logic;
	--Dump: in std_logic;
	Paralell_out :  out std_logic);
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT Receiver_state IS
 port(Clk,reset_n :IN std_logic;
        key, data_line, CNT, Delay :IN STD_LOGIC;
        Delay_EN, Shift_EN, Decrypt_EN :OUT STD_LOGIC; 
		);
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT storage IS
port(Enable, Clk: in std_logic; 
	   Data_in : in std_logic_vector(7 downto 0);
       Data_out : out std_logic_vector(7 downto 0)); 
END COMPONENT;
----------------------------------------------------------------------------------
COMPONENT MOD8 IS
PORT(  enable1,enable2 :IN STD_LOGIC;
       clk :IN STD_LOGIC;
       reset_n :IN STD_LOGIC;
       CNT : out std_logic -- count is the flag which goes to the finite state machine
	); 
END COMPONENT;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
Signal Shifted_data, THEDATA :STD_LOGIC_vector(7 downto 0); --This is the serial out data form the shift reg  
Signal EncryptS_EN, DelayS_EN, ShiftS_EN, LoadS_EN :STD_LOGIC; -- Signals for the state machine
Signal counter : std_logic; --the count from the MOD8
Signal Synchronizer_data : STD_LOGIC;
Signal delay_signal : STD_LOGIC; --the signal for the delay &  flag to the shift register
Signal input_data_Encrypted : std_logic_vector(7 downto 0); --signal taking in teh switches data that is inputed   
BEGIN
----------------------------------------------------------------------------------
Display0: BCD2SSD
PORT MAP
( Bin => THEDATA(3 DOWNTO 0),
  Hex => HEX0
   );

Display1: BCD2SSD
PORT MAP
( Bin => THEDATA(7 DOWNTO 4),
  Hex => HEX1
  );
----------------------------------------------------------------------------------
--------------------------------------

Port_Mapping_Synchronizer: Synchronizer

PORT MAP

    ( clk => clk,
      reset_n => reset_n,
      Data_in  => data_line, 
      Data_out => Synchronizer_data
    );
--------------------------------------
--------------------------------------
    
Port_Mapping_ED : Encrypt_Decrypt

PORT MAP

    (Enable => EncryptS_EN,
     Clk => clk,
     Data_In_Port1 => Shifted_data, 
     Data_In_Port2 => Switchero, 
     Data_out => input_data_Encrypted 
    ); 
--------------------------------------
--------------------------------------

Port_Mapping_Shifter : Shift_Reg

PORT MAP

    (Paralell_out => Shifted_data,  
     clk => clk,
     reset_n => reset_n,  
     Serial_in => Synchronizer_data,
     Shift => ShiftS_EN,
     enable => delay_signal
    );
--------------------------------------
--------------------------------------

Port_Mapping_Delay : Delay

PORT MAP

    (enable => DelayS_EN, 
     clk => clk,
     reset_n => reset_n,
     flag => delay_signal
    );
--------------------------------------
--------------------------------------

Port_Mapping_statemachine : Receiver_state

PORT MAP

    ( Clk => clk,
      Reset_n => reset_n, 
      Key => Key,
      data_line => Wake,
      Delay_EN => delay_signal,
      CNT => counter, 
      Encrypt_EN => EncryptS_EN, 
      Delay_EN => DelayS_EN,
      Shift_EN => ShiftS_EN  
      );
--------------------------------------
--------------------------------------

Port_Mapping_MOD : MOD8

PORT MAP

    (clk => clk,
     reset_n => reset_n,
     enable1 => delay_signal,
     enable2 => ShiftS_EN,
     CNT => counter
    );
--------------------------------------
-------------------------------------- 

Port_Mapping_FlipFlop2 : storage

PORT MAP

    (Enable => Key, 
     Clk => clk,
     Data_in => input_data_Encrypted, 
     Data_out => THEDATA 
    );
--------------------------------------
--------------------------------------
END TOPS;
