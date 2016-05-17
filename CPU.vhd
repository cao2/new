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
 
 file trace_file: TEXT open write_mode is "console1.txt";
 file trace_file1: TEXT open write_mode is "console2.txt";
 procedure read( variable adx: in std_logic_vector(15 downto 0);
 				 signal req: out std_logic_vector(50 downto 0);
 				variable data: out std_logic_vector(31 downto 0)) is
   		begin
   			req <= "101" & adx & "00000000000000000000000000000000";
   			wait for 3 ps;
   			req <= (others => '0');
   			wait until cpu_res(50 downto 50)= "1";
   			data := cpu_res(31 downto 0);	
   			wait for 10 ps;
 end  read;
 
 procedure write( variable adx: in std_logic_vector(15 downto 0);
 				 signal req: out std_logic_vector(50 downto 0);
 				variable data: in std_logic_vector(31 downto 0)) is
   		begin
   			req <= "110" & adx & data;
   			wait for 3 ps;
   			req <= (others => '0');
   			wait until cpu_res(50 downto 50)= "1";
   			wait for 10 ps;	
 end  write;
 
 
 
 
begin
   	req1: process(reset, Clock)
   	begin
   		if reset ='1' then
			cpu_req <= (others => '0');
		elsif (rising_edge(Clock)) then
			cpu_req <= tmp_req;
		end if;
   	end process;


-- processor random generate read or write request
 p1 : process 
     variable nilreq: std_logic_vector(50 downto 0):=(others=>'0');
     
     variable flag0: std_logic_vector(15 downto 0):="0000"&"0000"&"0000"&"0010";
     variable flag1: std_logic_vector(15 downto 0):="0000"&"0000"&"0000"&"0011";
     variable turn: std_logic_vector(15 downto 0):="0000"&"0000"&"0000"&"0100";
     variable shar: std_logic_vector(15 downto 0):="0000"&"0000"&"0000"&"0101";
     variable crit: std_logic_vector(15 downto 0):="0000"&"0000"&"0000"&"0110";


     variable turn_v: std_logic_vector(31 downto 0);
     variable flag0_v: std_logic_vector(31 downto 0);
     variable flag1_v: std_logic_vector(31 downto 0);
     variable crit_v: std_logic_vector(31 downto 0);
     
     variable crit_s: integer;
     
     variable zero: std_logic_vector(31 downto 0):="0000"&"0000"&"0000"&"0000"&"0000"&"0000"&"0000"&"0000";
     variable one: std_logic_vector(31 downto 0):="0000"&"0000"&"0000"&"0000"&"0000"&"0000"&"0000"&"0001";
     variable two: std_logic_vector(31 downto 0):="0000"&"0000"&"0000"&"0000"&"0000"&"0000"&"0000"&"0010";
     
     variable line_output:line;
     variable logsr: string(8 downto 1);
     
    begin
    	wait for 70 ps;
    	
    	write(flag0,tmp_req,zero);
    	write(flag1,tmp_req,zero);
    	---write(crit, tmp_req, zero);
	for I in 1 to 5 loop
    	if seed = 1 then
    		---flag0=1, turn =1
    		 
    		write(flag0,tmp_req,one);
    		---logsr :="1wrtef0:";
    		---write(line_output, logsr);
			---writeline(trace_file, line_output);
    		
    		
    		write(turn,tmp_req,one);
    		---logsr :="1wrtetr:";
    		---write(line_output, logsr);
			---writeline(trace_file, line_output);
    		
    		
    		read(turn, tmp_req, turn_v);
    		---logsr :="1redtur:";
    		---write(line_output, logsr);
    		---write(line_output, turn_v);
			---writeline(trace_file, line_output);
    		
    		
    		read(flag1, tmp_req, flag1_v);
    		---logsr :="1redfl1:";
    		---write(line_output, logsr);
    		---write(line_output, flag1_v);
			---writeline(trace_file, line_output);
    		
    		while turn_v=one and flag1_v=one loop
    			read(turn, tmp_req, turn_v);
    			read(flag1, tmp_req, flag1_v);
    			
    		
    			logsr :="1lP;trn:";
    			write(line_output, logsr);
    			---write(line_output, turn_v);
				writeline(trace_file, line_output);
			
				---logsr :="1lp:fg1:";
    			---write(line_output, logsr);
    			---write(line_output, flag1_v);
				---writeline(trace_file, line_output);
    		end loop;
    		---critical++
    		---logsr :="1utloop:";
    		---write(line_output, logsr);
			---writeline(trace_file, line_output);
			
    		read(crit, tmp_req, crit_v);  
    		---logsr :="1citica:";
    		---write(line_output, logsr);
    		---write(line_output, crit_v);
			---writeline(trace_file, line_output);
    		
    		  		
    		crit_v:= std_logic_vector(unsigned(crit_v)+1);
    		write(crit,tmp_req, crit_v);
    		
    		read(crit, tmp_req, crit_v);
    		logsr :="1citaft:";
    		write(line_output, logsr);
    		write(line_output, crit_v);
			writeline(trace_file, line_output);
			
			
    		---crit_v:= std_logic_vector(unsigned(crit_v)-1);
    		---write(crit,tmp_req, crit_v);
    		
    		---flag0=1
    		write(flag0,tmp_req,zero);
    	elsif seed=2 then
    		wait for 20 ps;
    		---flag1=1, turn =0
    		write(flag1,tmp_req,one);
    		---logsr :="2wrtef1:";
    		---write(line_output, logsr);
			---writeline(trace_file1, line_output);
    		
    		
    		write(turn,tmp_req,zero);
    		---logsr :="2wrtetr:";
    		---write(line_output, logsr);
			---writeline(trace_file1, line_output);
    		
    		
    		read(turn, tmp_req, turn_v);
    		---logsr :="2redtur:";
    		---write(line_output, logsr);
    		---write(line_output, turn_v);
			---writeline(trace_file1, line_output);
    		
    		
    		read(flag0, tmp_req, flag0_v);
    		---logsr :="2redfl0:";
    		---write(line_output, logsr);
    		---write(line_output, flag0_v);
			---writeline(trace_file1, line_output);
    		---while flag0==1&turn==0 wait
    		while turn_v=zero and flag0_v=one loop
    			read(turn, tmp_req, turn_v);
    			read(flag0, tmp_req, flag0_v);
    			
    		
    			logsr :="2lP;trn:";
    			write(line_output, logsr);
    			---write(line_output, turn_v);
				writeline(trace_file1, line_output);
			
				---logsr :="2lp:fg0:";
    			---write(line_output, logsr);
    			---write(line_output, flag0_v);
				---writeline(trace_file1, line_output);
    		end loop;
    		---critical
    		---logsr :="2utloop:";
    		---write(line_output, logsr);
			---writeline(trace_file1, line_output);
			
    		read(crit, tmp_req, crit_v); 
    		---logsr :="2citica:";
    		---write(line_output, logsr);
    		---write(line_output, crit_v);
			---writeline(trace_file1, line_output);
    		
    		   		
    		crit_v:= std_logic_vector(unsigned(crit_v)+1);
    		write(crit,tmp_req, crit_v);
    		
    		
    		
    		read(crit, tmp_req, crit_v);
    		logsr :="2citaft:";
    		write(line_output, logsr);
    		write(line_output, crit_v);
			writeline(trace_file1, line_output);
    		---crit_v:= std_logic_vector(unsigned(crit_v)-1);
    		---write(crit,tmp_req, crit_v);
    		
    		---flag1=0
    		write(flag1,tmp_req,zero);
    		
    	end if;
  end loop;	
        wait;

  end process; 
 
  
end Behavioral;
