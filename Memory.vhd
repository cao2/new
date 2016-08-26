
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
            wdvalid: in std_logic;
            wdataready: out std_logic;
            ---write response channel
            wrready: in std_logic;
            wrvalid: out std_logic;
            wrsp: out std_logic_vector(1 downto 0);
            
            ---read address channel
            raddr: in std_logic_vector(31 downto 0);
            rlen: in std_logic_vector(9 downto 0);
            rsize: in std_logic_vector(9 downto 0);
            rvalid: in std_logic;
            rready: out std_logic;
            ---read data channel
            rdata: out std_logic_vector(31 downto 0);
            rstrb: out std_logic_vector(3 downto 0);
            rlast: out std_logic;
            rdvalid: out std_logic;
            rdready: in std_logic;
            rres: out std_logic_vector(1 downto 0)
            );
end Memory;

architecture Behavioral of Memory is
     type rom_type is array (2**16-1 downto 0) of std_logic_vector (31 downto 0);     
     signal ROM_array : rom_type:= (others=> (others=>'0'));

begin
  
  write: process (Clock, reset)
    variable address: integer;
    variable len: integer;
    variable size: std_logic_vector(9 downto 0);
    variable state : integer :=0;
    variable lp: integer:=0;
    begin
    if reset ='1' then
       wready <= '1';
       wdataready <= '0';
    elsif (rising_edge(Clock)) then
    	if state = 0 then
    	    wrvalid <= '0';
    	    wrsp <= "10";
    		if wvalid ='1' then
    			wready <='0';
    			address:=to_integer(unsigned(waddr));
    			len := to_integer(unsigned(wlen));
    			size := wsize;
    			state := 2;
    			wdataready <= '1';
    		end if;
    		
    	elsif state =2 then
    		if wdvalid ='1' then
    		---not sure if lengh or length -1
    			if lp < len-1 then
    			    wdataready <= '0';
    				---strob here is not considered
        			ROM_array(address+lp) <= wdata(31 downto 0);
        			lp := lp +1;
        			wdataready <= '1';
        			if wlast ='1' then
        				state := 3;
        			end if;
        		else
        			state := 3;
        		end if;
        		
    		end if;
    	elsif state = 3 then
    		if wrready = '1' then
    		    wrvalid <= '1';
    		    wrsp <= "00";
    		    state :=0;
    		end if;
    	end if;
    end if;
    end process;
    
    
    
    read: process (Clock, reset)
    variable address: integer;
    variable len: integer;
    variable size: std_logic_vector(9 downto 0);
    variable state : integer :=0;
    variable lp: integer:=0;
    begin
    if reset ='1' then
       rready <= '1';
       rdvalid <= '0';
       rstrb <= "1111";
       rlast <= '0';
    elsif (rising_edge(Clock)) then
    	if state = 0 then
    		if rvalid ='1' then
    			rready <='0';
    			address:=to_integer(unsigned(raddr));
    			len := to_integer(unsigned(rlen));
    			size := rsize;
    			state := 2;
    		end if;
    		
    	elsif state =2 then
    		if rdready = '1' then
    			if lp < len-1 then
    			    rdvalid <= '1';
    				---strob here is not considered
        			rdata <= ROM_array(address+lp);
        			lp := lp +1;
        			rres <= "00";
        			if lp = len-1 then
        				state := 3;
        				rlast <= '1';
        			end if;
        		else
        			state := 3;
        		end if;
        		
    		end if;
    	elsif state = 3 then
    		rdvalid <= '0';
    		rlast <= '0';
    		state := 0;
    	end if;
    end if;
    end process;

end Behavioral;
