
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
use work.nondeterminism.all;

entity Memory is
    Port (  Clock: in std_logic;
            reset: in std_logic;
            ---write address chanel
            waddr: in std_logic_vector(31 downto 0);
            wlen: in std_logic_vector(9 downto 0);
            wsize: in std_logic_vector(9 downto 0);
            wvalid: in std_logic;
            wready: out std_logic;
            ---write data channel
            wdata: in std_logic_vector(31 downto 0);
            wtrb: in std_logic_vector(3 downto 0);
            wlast: in std_logic;
            wvalid: in std_logic;
            wdataready: out std_logic;
            ---write response channel
            wrready: in std_logic;
            wrsp: out std_logic_vector(1 downto 0);
            
            );
end Memory;

architecture Behavioral of Memory is
     type rom_type is array (2**16-1 downto 0) of std_logic_vector (31 downto 0);     
     signal ROM_array : rom_type:= (others=> (others=>'0'));

begin
    
  waddr: process (Clock, reset)
    variable address: integer;
    variable len: std_logic_vector(9 downto 0);
    variable size: std_logic_vector(9 downto 0);
    variable state : integer :=0;
    variable lp: integer:=0;
    begin
    if reset ='1' then
       wready <= '1';
       wdataready <= '0';
    elsif (rising_edge(Clock)) then
    	if state = 1 then
    		if wvalid ='1' then
    			wready <='0';
    			address:=to_integer(unsigned(waddr));
    			len := wlen;
    			size := wsize;
    			state := 2;
    			wdataready <= '1';
    		end if;
    		
    	elsif state =2 then
    		if wvalid ='1' then
    		---not sure if lengh or length -1
    			if lp < len-1 then
    				
    				---strob here is not considered
        			ROM_array(address+lp) <= wdata(31 downto 0);
        			lp := lp +1;
        			if wlast ='1' then
        				state := 3;
        			end if;
        			wdataready <= '1';
        		else
        			state := 3;
        		end if;
        		
    		end if;
    	elsif state = 3 then
    		if 
    	end if;
    end if;
    
    
    
    
    
    end process;

end Behavioral;
