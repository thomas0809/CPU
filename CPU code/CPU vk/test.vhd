--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:52:16 11/20/2015
-- Design Name:   
-- Module Name:   E:/computer organization/CPU/test.vhd
-- Project Name:  CPU
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         clk50_true : IN  std_logic;
         rst : IN  std_logic;
         clk0 : IN  std_logic;
         debug : OUT  std_logic_vector(15 downto 0);
         debug2 : OUT  std_logic_vector(6 downto 0);
         debug3 : OUT  std_logic_vector(6 downto 0);
         RAM2Data : INOUT  std_logic_vector(15 downto 0);
         RAM2Addr_out : OUT  std_logic_vector(17 downto 0);
         RAM2EN : OUT  std_logic;
         RAM2WE : OUT  std_logic;
         RAM2OE : OUT  std_logic;
         RAM1Data : INOUT  std_logic_vector(15 downto 0);
         RAM1Addr_out : OUT  std_logic_vector(17 downto 0);
         RAM1EN : OUT  std_logic;
         RAM1WE : OUT  std_logic;
         RAM1OE : OUT  std_logic;
         tsre : IN  std_logic;
         tbre : IN  std_logic;
         data_ready : IN  std_logic;
         wrn : OUT  std_logic;
         rdn : OUT  std_logic;
         clk_test0 : OUT  std_logic;
         clk_test1 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk50_true : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk0 : std_logic := '0';
   signal tsre : std_logic := '0';
   signal tbre : std_logic := '0';
   signal data_ready : std_logic := '0';

	--BiDirs
   signal RAM2Data : std_logic_vector(15 downto 0);
   signal RAM1Data : std_logic_vector(15 downto 0);

 	--Outputs
   signal debug : std_logic_vector(15 downto 0);
   signal debug2 : std_logic_vector(6 downto 0);
   signal debug3 : std_logic_vector(6 downto 0);
   signal RAM2Addr_out : std_logic_vector(17 downto 0);
   signal RAM2EN : std_logic;
   signal RAM2WE : std_logic;
   signal RAM2OE : std_logic;
   signal RAM1Addr_out : std_logic_vector(17 downto 0);
   signal RAM1EN : std_logic;
   signal RAM1WE : std_logic;
   signal RAM1OE : std_logic;
   signal wrn : std_logic;
   signal rdn : std_logic;
   signal clk_test0 : std_logic;
   signal clk_test1 : std_logic;

   -- Clock period definitions
   constant clk50_true_period : time := 10 ns;
   constant clk0_period : time := 10 ns;
   constant clk_test0_period : time := 10 ns;
   constant clk_test1_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          clk50_true => clk50_true,
          rst => rst,
          clk0 => clk0,
          debug => debug,
          debug2 => debug2,
          debug3 => debug3,
          RAM2Data => RAM2Data,
          RAM2Addr_out => RAM2Addr_out,
          RAM2EN => RAM2EN,
          RAM2WE => RAM2WE,
          RAM2OE => RAM2OE,
          RAM1Data => RAM1Data,
          RAM1Addr_out => RAM1Addr_out,
          RAM1EN => RAM1EN,
          RAM1WE => RAM1WE,
          RAM1OE => RAM1OE,
          tsre => tsre,
          tbre => tbre,
          data_ready => data_ready,
          wrn => wrn,
          rdn => rdn,
          clk_test0 => clk_test0,
          clk_test1 => clk_test1
        );

   -- Clock process definitions
   clk50_true_process :process
   begin
		clk50_true <= '0';
		wait for 10ns;
		clk50_true <= '1';
		wait for 10ns;
   end process;

END;
