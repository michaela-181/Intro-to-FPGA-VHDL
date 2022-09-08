----------------------------------------------------------------------------------
--
-- Author: M. Mitchell
-- Date: 9/6/22
--
-- Description:
-- Lab 1 top level instantiation of 7-SEGMENT decoder. SW11-S4 and the push-buttons 
-- determine which of the 7-SEGMENTS are active. Specifically:
-- 1. With no buttons pressed, the digit is displayed in any display that has the 
-- corresponding slider switch set HIGH from SW11 to SW4.
-- 2. When the UP BTN is pressed (BTNU), only the upper four displays will be active 
-- and showing the SW3 to SW0 value
-- 3. When the DOWN BTN is pressed (BTND), only the bottom four displays will be 
-- active and showing the SW3 to SW0 value
-- 4. When the CENTER BTN is pressed (BTNC), all of the displays will be active 
-- and showing all zeros
-- 5. Green LEDs light up according to which slider switch is in HIGH position
-- 6. Value of SW3-SW0 shows up on seven-segment display in hex
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab1_top is
    Port ( BTNC : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           SEG7_CATH : out STD_LOGIC_VECTOR (7 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end lab1_top;

architecture structure of lab1_top is

signal digit : std_logic_vector(3 downto 0);
signal hex_disp : std_logic_vector(7 downto 0);
signal anode_sel : std_logic_vector(7 downto 0);
signal led_state : std_logic_vector(15 downto 0);
signal btn_state : std_logic_vector(2 downto 0);

begin

    -- instatiation of decoder module
    digit <= SW (3 downto 0);
    decoder_1 : entity work.seg7_hex port map (digit, hex_disp);
    
    -- anode select from switches 11-4 (active low)
    anode_sel <= SW (11 downto 4);
    -- concactenate button states
    btn_state <= BTNC & BTNU & BTND;
    
    -- BTN logic
    with btn_state select
        AN <= 
        "00001111" when "010",
        "11110000" when "001",
        "00000000" when "100",
        not anode_sel when others;
        
    with btn_state select        
        SEG7_CATH <=
        hex_disp when "010",
        hex_disp when "001",
        "11000000" when "100",
        hex_disp when others;
    
    -- LD15-LD0 state matches it's corresponding switch state
    led_state <= SW(15 downto 0);
    LED <= led_state;

end structure;
