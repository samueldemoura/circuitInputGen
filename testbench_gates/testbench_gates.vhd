library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use STD.TEXTIO.ALL ;

entity testbench_gates is -- no inputs or outputs
end;
architecture sim of testbench_gates is
	component gates
		port (a, b: in STD_LOGIC_VECTOR(3 downto 0);
		y1, y2, y3, y4, y5: out STD_LOGIC_VECTOR(3 downto 0));
	end component;
signal clk: STD_LOGIC;
signal a, b, y1, y2, y3, y4, y5: STD_LOGIC_VECTOR(3 downto 0);
signal yexpected1, yexpected2, yexpected3, yexpected4, yexpected5: STD_LOGIC_VECTOR(3 downto 0);
constant MEMSIZE: integer := 256;
type tvarray is array (MEMSIZE downto 0) of
STD_LOGIC_VECTOR (27 downto 0);
signal testvectors: tvarray;
shared variable vectornum, errors: integer;
begin
-- instantiate device under test
dut: gates port map (a, b, y1, y2, y3, y4, y5);
-- generate clock
process begin
	clk <= '1'; wait for 10 ns;  
	clk <= '0'; wait for 5 ns;
end process;
-- at start of test, load vectors
-- and pulse reset
process is
file tv: TEXT;
variable i, j: integer;
variable L: line;
variable ch: character;
begin
	-- read file of test vectors
	i := 0;
	FILE_OPEN (tv, "./example.tv", READ_MODE);
	while not endfile(tv) loop
		readline (tv, L);
		for j in 27 downto 0 loop
			read (L, ch);
			if (ch = '_') then read (L, ch);
			end if;
			if (ch = '0') then
			testvectors (i) (j) <= '0';
			else testvectors (i) (j) <= '1';
			end if;
		end loop;
		i := i + 1;
	end loop;
	vectornum := 0; errors := 0;
	-- reset <= '1'; wait for 27 ns; reset <= '0';
	wait;
end process;
-- apply test vectors on rising edge of clk
process (clk) begin
	if (clk'event and clk='1') then   
		a <= testvectors (vectornum) (27 downto 24); --after 1 ns;
		b <= testvectors (vectornum) (23 downto 20); --after 1 ns;
		yexpected1 <= testvectors (vectornum)(19 downto 16); --after 1 ns;
		yexpected2 <= testvectors (vectornum)(15 downto 12); --after 1 ns;
		yexpected3 <= testvectors (vectornum)(11 downto 8); --after 1 ns;
		yexpected4 <= testvectors (vectornum)(7 downto 4); --after 1 ns;
		yexpected5 <= testvectors (vectornum)(3 downto 0); --after 1 ns;
	end if;
end process;
-- check results on falling edge of clk
process (clk) begin
	if (clk'event and clk = '0')then
		for k in 0 to 3 loop
			assert y1(k)= yexpected1(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado yesp ="& STD_LOGIC'image(yexpected1(k))&"Valor Obtido: y1("&integer'image(k)&") ="& STD_LOGIC'image(y1(k));
			
			if (y1 /= yexpected1) then
				errors := errors + 1;
			end if;
				
			assert y2(k)= yexpected2(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado yesp ="& STD_LOGIC'image(yexpected2(k))&"Valor Obtido: y2("&integer'image(k)&") ="& STD_LOGIC'image(y2(k));
			
			if (y2(k) /= yexpected2(k)) then
				errors := errors + 1;
			end if;
				
			assert y3(k)= yexpected3(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado yesp ="& STD_LOGIC'image(yexpected3(k))&"Valor Obtido: y3("&integer'image(k)&") ="& STD_LOGIC'image(y3(k));
			
			if (y3(k) /= yexpected3(k)) then
				errors := errors + 1;
			end if;
			
			assert y4(k)= yexpected4(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado yesp ="& STD_LOGIC'image(yexpected4(k))&"Valor Obtido: y4("&integer'image(k)&") ="& STD_LOGIC'image(y4(k));	
			
			if (y4(k) /= yexpected4(k)) then
				errors := errors + 1;
			end if;
				
			assert y5(k)= yexpected5(k)
				report "Vetor deu erro n. Teste: " &integer'image(vectornum)&". Esperado yesp ="& STD_LOGIC'image(yexpected5(k))&"Valor Obtido: y5("&integer'image(k)&") ="& STD_LOGIC'image(y5(k));
			
			if (y5(k) /= yexpected5(k)) then
				errors := errors + 1;
			end if;
		end loop;
		
		vectornum := vectornum + 1;
		if (is_x (testvectors(vectornum))) then
			if (errors = 0) then
				report "Just kidding --" &
				integer'image (vectornum) &
				"tests completed successfully."
				severity failure;
			else
				report integer'image (vectornum) &
				"tests completed, errors = " &
				integer'image (errors)
				severity failure;
			end if;
		end if;
	end if;
	
end process;
end;
