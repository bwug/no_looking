library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

/*
Using SPI

MISO:
    Chip Select
    Slave address
    

MOSI
*/

/*
Breaking down "long get_LTC6953_SPI_FIELD(uint8_t cs, uint8_t f)"

uint8_t addrx;
uint8_t dxmsb;
uint8_t numbits;

addrx = (LTC6953_spi_map[f] & 0xff00) >> 8;

ff00 >> 8 is 1111 1111 0000 0000 shifted 8 so
ac00 & ff becomes:
1010 1100 & 1111 1111 = 1010 1100 x00 -> x00 b'1010 1100' -> Address

dxmsb = (LTC6953_spi_map[f] & 0x0070) >> 4;


numbits = (LTC6953_spi_map[f] & 0x000f) + 1;

fffa & 000f -> 000a + 1 -> 000b

*/

entity ltc_6953_interface is
    generic (
        bit_width : integer := 8
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        chip_select : out std_logic_vector(10 downto 0) -- Connect to the XDC
        
    );


end entity ltc_6953_interface;

architecture sim of ltc_6953_interface is

    -- 1 for read, 0 for write
    -- this will be attached to the end byte
    signal read_write   : std_logic := '0'; 
    signal address      : unsigned(7 downto 0) := (others => '0');
    signal command      : unsigned(7 downto 0) := (others => '0');
    signal code         : unsigned(15 downto 0) := (others => '0');
    signal addr         : unsigned(15 downto 0);

begin

generate_payload : process(clk, rst)

    -- Include an SPI module for frequency F_Hz with ports CS, Serial Clock and Serial Data

begin
    if(rst = '1') then
        read_write  <= '0';
        address     <= (others => '0');
        command     <= (others => '0');
    end if;

    if (rising_edge(clk)) then
        /*
        
            Following the LTC read_field command from the
            provided .cpp file from Analog themselves
            it seems the course of action is
                address(7 downto 0) >> 1 + unsigned(r/w)
            where the address is auto-generated, with the bit shift accounting
            for the read / write bit attached
            
        */
        code <= x"1C00"; -- Code for 38 00, read the 4th port on the board
        address <= (shift_left(code(15 downto 8), 1) or "00000001");
        command <= code(7 downto 0);
        chip_select(to_integer(address)) <= '0'; -- Chip select is active low

    end if;
end process generate_payload;

end architecture;