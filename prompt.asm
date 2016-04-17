; Nathan Button
; CS_2810
; Sub program for day_of_week
;
; Prompts the user to enter the Month Day and Year and converts from ASCII to decimal and stores in R1, R2, R3 respectively


.ORIG x4000

JSR PROMT_MONTH_LOAD
JSR PROMT_DAY_LOAD
JSR PROMT_YEAR_LOAD

LD R1, MONTH
LD R2, DAY
LD R3, YEAR

LD R7, MAIN_AD
JSRR R7

--- LINK TO MAIN ---
MAIN_AD .FILL x3002

--- HOLDING VARS ----
MONTH .FILL #0
DAY .FILL #0
YEAR .FILL #0
TERM1		.BLKW		4

--- CONSTS ----
PROMT_MONTH .STRINGZ "Enter the month \n"
PROMT_DAY .STRINGZ  "Enter the day \n"
PROMT_YEAR .STRINGZ "Enter the year \n"
NL		.FILL		xFFF6
NEW_LINE_CHAR .FILL x000A
NegASCIIOffset .FILL  xFFD0

LookUp10       .FILL  #0
               .FILL  #10
               .FILL  #20
               .FILL  #30
               .FILL  #40
               .FILL  #50
               .FILL  #60
               .FILL  #70
               .FILL  #80
               .FILL  #90

LookUp100      .FILL  #0
               .FILL  #100
               .FILL  #200
               .FILL  #300
               .FILL  #400
               .FILL  #500
               .FILL  #600
               .FILL  #700
               .FILL  #800
               .FILL  #900

LookUp1000    	.FILL #0
								.FILL  #1000
								.FILL  #2000
								.FILL  #3000
								.FILL  #4000
								.FILL  #5000
								.FILL  #6000
								.FILL  #7000
								.FILL  #8000
								.FILL  #9000

RETLOCATION .FILL x0000

PROMT_MONTH_LOAD
  ST R7, RETLOCATION
  LEA	R0,PROMT_MONTH	; the following signals
  PUTS			; the operator

  LEA	R1,TERM1
  JSR	USER_INPUT
  LEA       R2,TERM1
  NOT       R2,R2
  ADD       R2,R2,#1
  ADD       R1,R1,R2      ; R1 now contains no. of char.

  JSR	ASCII_TO_BINARY

  ST R0, MONTH
  LD R7, RETLOCATION
  RET

PROMT_DAY_LOAD
  ST R7, RETLOCATION
  LEA	R0,PROMT_DAY	; the following signals
  PUTS			; the operator

  LEA	R1,TERM1
  JSR	USER_INPUT
  LEA       R2,TERM1
  NOT       R2,R2
  ADD       R2,R2,#1
  ADD       R1,R1,R2      ; R1 now contains no. of char.

  JSR	ASCII_TO_BINARY

  ST R0, DAY
  LD R7, RETLOCATION
  RET

PROMT_YEAR_LOAD
  ST R7, RETLOCATION
  LEA	R0,PROMT_YEAR	; the following signals
  PUTS			; the operator

  LEA	R1,TERM1
  JSR	USER_INPUT
  LEA       R2,TERM1
  NOT       R2,R2
  ADD       R2,R2,#1
  ADD       R1,R1,R2      ; R1 now contains no. of char.

  JSR	ASCII_TO_BINARY

  ST R0, YEAR
  LD R7, RETLOCATION
  RET

ASCII_TO_BINARY
  AND    R0,R0,#0      ; R0 will be used for our result
   ADD    R1,R1,#0      ; Test number of digits.
   BRz    RETURN		    ; There are no digits
; --------- ONES ----------------
   LD     R3,NegASCIIOffset  ; R3 gets xFFD0, i.e., -x0030
   LEA    R2,TERM1
   ADD    R2,R2,R1
   ADD    R2,R2,#-1     ; R2 now points to "ones" digit

   LDR    R4,R2,#0      ; R4 <-- "ones" digit
   ADD    R4,R4,R3      ; Strip off the ASCII template
   ADD    R0,R0,R4      ; Add ones contribution
; ------- CHECK IF DONE ----------
   ADD    R1,R1,#-1
   BRz    RETURN		    ; The original number had one digit
; --------- TENS ----------------
   ADD    R2,R2,#-1
   LDR    R4,R2,#0
   ADD    R4,R4,R3
   LEA    R5,LookUp10
   ADD    R5,R5,R4
   LDR    R4,R5,#0
   ADD    R0,R0,R4
; ------- CHECK IF DONE ----------
   ADD    R1,R1,#-1
   BRz    RETURN	; The original number had two digits
; --------- HUNDREDS ----------------
   ADD    R2,R2,#-1
   LDR    R4,R2,#0
   ADD    R4,R4,R3
   LEA    R5,LookUp100
   ADD    R5,R5,R4
   LDR    R4,R5,#0
   ADD    R0,R0,R4
; ------- CHECK IF DONE ----------
	 ADD    R1,R1,#-1
   BRz    RETURN	; The original number had three digits
; --------- THOUSANDS ----------------
   ADD    R2,R2,#-1
;
   LDR    R4,R2,#0
   ADD    R4,R4,R3
   LEA    R5,LookUp1000
   ADD    R5,R5,R4
   LDR    R4,R5,#0
   ADD    R0,R0,R4
RETURN
  RET
LOOP_RET .FILL x0000

USER_INPUT
	ST R7, LOOP_RET
  LOOP
	GETC		; to input a number
    OUT		; r0 to console
		LD      R7,NL  		; check for new line char
		ADD     R7,R7,R0   	; end of line
		BRz	#3
		STR	R0,R1,#0	; r0 to ( memory address stored in r1 + 0 )
    ADD	R1,R1,#1	; increments the memory pointer so that it points to next available memory
		BRnp	LOOP
		LD R7, LOOP_RET
		RET
.END
