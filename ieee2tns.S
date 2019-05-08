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

		LDR		R0, =floats
		LDR		R1, [R0]
		LDR		R2, [R0, #4]
		LDR		R0, =SELECT
		LDR		R0, [R0]
		CMP		R0, #0
		BEQ		EEEI32

tns
		LDR		R0, =name
		LDR		R10, [R0]
		LDR		R11, [R0, #4]
		LDR		R12, [R0, #8]
		AND		R3, R1, R10
		AND		R4, R1, R11
		AND		R5, R1, R12
		LSR		R4, R4, #23
		LSL		R5, R5, #8
		SUB		R4, R4, #0X7F
		ADD		R4, R4, #0X100
		ORR		R3, R3, R4
		ORR		R3, R3, R5
		CMP		R2, R3
		BNE		notE
		B		nums

EEEI32
		LDR		R0, =sname
		LDR		R10, [R0]
		LDR		R11, [R0, #4]
		LDR		R12, [R0, #8]
		AND		R3, R2, R10
		MOV		R6, R11
		AND		R4, R2, R6
		AND		R5, R2, R12
		SUB		R5, R5, #0X100
		ADD		R5, R5, #0X7F
		LSR		R4, R4, #8
		LSL		R5, R4, #23
		ORR		R3, R3, R4
		ORR		R3, R3, R5
		CMP		R1, R4
		BNE		notE

nums
		LDR		R4, =result
		LDR		R5, [R4]
		B		store

notE
		LDR		R4, =result
		LDR		R5, [R4, #4]

store
		LDR		R0, =tns
		STR		R5, [R0]

stop	END

SELECT	DCD		0			;if its 0, its eeei to tns, if its a 1, its the other way around
result	DCD		0, 1 		;0 if its equal. 1 if it is not equal
name	DCD		0X80000000, 0X7F800000, 0X007fffff
sname	DCD		0X80000000, 0X7FFFFE00, 0X000001FF
floats	DCD		0xa0bcff0d, 0x13c0adea
tns		FILL	16