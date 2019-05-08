		;		ARM Programming Assignment #3: 32 bit IEEE 754 single-precision multiplier
		;
		;		Write a 32-bit floating point multiplier. The numbers will be represented
		;       in the single-precision IEEE 754 floating-point standard. The result should
		;       also be in IEEE 754 binary32. Assume you only have normalized numbers, i.e.
		;       the exponent is never 0b00000000.
		;		Write the result in the provided "fill" word.

		;		Your code here

		ldr		R0, =floats
		ldr		R1, [R0]
		ldr		R2, [R0, #4]

		and		r3, r1, #0x80000000
		and		r4, r2, #0x80000000

		eor		r0, r3, r4

		ldr		r9, =0x7f800000
		and		r3, r1, r9
		and		r4, r2, r9

		mov		r3, r3, lsr #23
		mov		r4, r4, lsr #23
		sub		r3, r3, #127
		sub		r4, r4, #127

		add		r5, r3, r4

		ldr		r9, =0x007fffff
		and		r3, r1, r9
		and		r4, r2, r9
		orr		r3, r3, #0x00800000
		orr		r4, r4, #0x00800000


		stmfd	sp!, {r3-r4, r8-r9}
		mov		r6, #0
		mov		r7, #0
		mov		r9, #0

multi
		ands	r8, r3, #1
		beq		noadd

		adds	r7, r7, r4
		adc		r6, r6, r9

noadd
		mov		r9, r9, lsl #1
		movs	r4, r4, lsl #1
		adc		r9, r9, #0

		movs	r3, r3, lsr #1
		bne		multi
		end

floats	DCD		0xa0bcff0d, 0x13c0adea
result	FILL	8
