		;		ARM Programming Assignment #3: IEEE 754 to TNS bit-level marshaller
		;
		;		Write a program to convert a 32-bit single-precision IEEE 754 floating-point
		;       number to the Tandem Non-stop Series (TNS) format. Refer to the README for a
		;       description of the format. Convert the numbers in `floats` and write the TNS
		;       equivalents into the `tns` area, one after the other.
		;
		;       Bonus:
		;       1. (30 extra points) Implement the reverse conversion, from TNS to IEEE.
		;       2. (50 extra points) Organize the code into two subroutines, with stack
		;          support.
		;       3. (10 extra points) In the main program, implement a round-trip conversion
		;          and prove the results match the initial values in 'floats'.  Define a
		;          `FILL` region to hold the IEEE 754 results.
		;

	LDR R0, =EEEI
	LDR R1,  [R0]
	LDR R0, =TNS
	LDR R2,  [R0]
	LDR R0, =SELECT
	LDR R0, [R0]
	CBZ R0, EEEI32

tns
	AND R3, R1, #0X80000000
	AND R4, R1, #0X7F800000
	MOV R6, #0X007fffff
	AND R5, R1, R6
	LSR R4, #23
	LSL R5, #8
	SUB R4,#0X7F
	ADD R4,#0X100
	ORR R3, R3, R4
	ORR R3, R3, R5
	CMP R2, R3
	BNE notE
	B E

EEEI
	AND R3, R2, #0X80000000
	MOV R6, #0X7FFFFE00
	AND R4, R2, R6
	MOV R7, #0X000001FF
	AND R5, R2, R7
	SUB R5, #0X100

	ADD R5, #0X7F
	LSR R4, #8
	LSL R5, #23
	ORR R3, R3, R4
	ORR R3, R3, R5
	CMP R1, R4
	BNE notE
	B E

floats	DCD	0xa0bcff0d, 0x13c0adea
tns 		FILL 16