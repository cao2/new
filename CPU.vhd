

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.nondeterminism.all;
use std.textio.all;
use IEEE.std_logic_textio.all; 


	
   

entity CPU is
    Port ( reset : in   std_logic;
           Clock: in std_logic;
           seed: in integer;
           cpu_res: in std_logic_vector(50 downto 0);
           cpu_req : out std_logic_vector(50 downto 0);
           full_c: in std_logic
           );
end CPU;


   
   	
architecture Behavioral of CPU is
 signal first_time : integer:=0;
 signal data: std_logic_vector(31 downto 0);
 signal adx : std_logic_vector(15 downto 0);
 signal tmp_req: std_logic_vector(50 downto 0);
 
 signal rand1:integer:=1;
 signal rand2: std_logic_vector(15 downto 0):="0101010101010111";
 signal rand3: std_logic_vector(31 downto 0):="10101010101010101010101010101010";
 
 
 procedure read( signal adx: in std_logic_vector(15 downto 0);
 				 signal req: out std_logic_vector(50 downto 0);
 				signal data: out std_logic_vector(31 downto 0)) is
   		begin
   			req <= "101" & adx & "00000000000000000000000000000000";
   			wait for 3 ps;
   			req <= (others => '0');
   			wait until cpu_res(50 downto 50)= "1";
   			data <= cpu_res(31 downto 0);	
   			wait for 10 ps;
 end  read;
 
 procedure write( signal adx: in std_logic_vector(15 downto 0);
 				 signal req: out std_logic_vector(50 downto 0);
 				signal data: in std_logic_vector(31 downto 0)) is
   		begin
   			req <= "110" & adx & data;
   			wait for 3 ps;
   			req <= (others => '0');
   			wait until cpu_res(50 downto 50)= "1";
   				
 end  write;
 
 
 
 
begin
	 
   	req1: process(reset, Clock)
   	begin
   		if reset ='1' then
			---tmp_req <= (others => '0');
			cpu_req <= (others => '0');
		elsif (rising_edge(Clock)) then
			cpu_req <= tmp_req;
			---tmp_req <= (others => '0');
		end if;
   	end process;
   	
	
-- processor random generate read or write request
    p1 : process 
     variable nilreq: std_logic_vector(50 downto 0):=(others=>'0');
     --if rand1 is 1 then read request
     --if rand1 is 2 then write request     
    begin
    	wait for 70 ps;
    	for I in 1 to 2 loop
    		--wait for 20 ps;
    		rand1 <= selection(2);
        	rand2 <=selection(2**2-1,3)&"0000000000000";
        	rand3 <=selection(2**15-1,32);
            if rand1=1 then
        		read (rand2, tmp_req, data);
        		
        		
        	else
        		write (rand2, tmp_req, rand3);
            	---tmp_req <= (others => '0');
          	end if;  
        end loop;
        
        wait;

  end process; 
 


  
end Behavioral;
