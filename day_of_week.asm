; Nathan Button
; CS_2810
;
; Requires: prompt and print_day to be loaded first
;
; Determines the day of the week from a given date using  Zeller Function.
;
; h = (q + (13(m+1)/5)+ K + K/4 + J/4 + 5J)%7
; 						~=
; (q + X + K + Y + Z + H) % 7
;   h = is the day of the week (0 = Saturday, 1 = Sunday ... 6 = Friday)
; 	q = day of the month
;		m = is the month where	k + 10; if x <= 2; else	k;
; 	K = the year of the century (year % 100)
;		J = the zero-based century floor(year/100)

.ORIG x3000

LD R7, PROMPT_AD
JSRR R7

ST R1, MONTH
ST R2, DAY
ST R3, YEAR

LD R3, MONTH
LD R4, DAY
LD R5, YEAR

	ADD R1, R1, R3
	JSR COMPUTE_M

	JSR COMPUTE_K
	JSR COMPUTE_J

CALC_X
	LD R2, M  ;load M into R2
	ADD R2, R2, #1 ;ADD 1 to M store in R2
	LD R1, V_13  ;Load 13 into R1
	JSR R1_MULT_R2
	LD R1, X_MUL_Y ;load in value

; Compute R1 / 5
	LD R2, V_5
	JSR R1_DIV_R2
	LD R5, X_DIV_Y
	ST R5, V_X

CALC_Y
	LD R2, V_4
  LD R1, K
	JSR R1_DIV_R2
	LD R5, X_DIV_Y
	ST R5, V_Y

CALC_Z
	LD R1, J
	LD R2, V_4
	JSR R1_DIV_R2
	LD R5, X_DIV_Y
	ST R5, V_Z

CALC_G
	LD R1, V_5
	LD R2, J
	JSR R1_MULT_R2

	LD R5, X_MUL_Y
	ST R5, V_G

ADD_ALL_SUB_PARTS
	LD R6, DAY
	LD R5, V_X
	ADD R6, R6, R5
	LD R5, K
	ADD R6, R6, R5
	LD R5, V_Y
	ADD R6, R6, R5
	LD R5, V_Z
	ADD R6, R6, R5
	LD R5, V_G
	ADD R6, R6, R5

CALC_MOD_OF_SUB_PARTS
	ADD R1, R6, #0
	LD R2, V_7
	JSR R1_MOD_R2

STORE_RESULTS
	LD R6, X_MOD_Y
	ST R6, DAY_OF_THE_WEEK

LD R3, PRINT_AD
JSRR R3
LD R3, MAIN_AD
JSRR R3
;--------------------------- LINKS ----------------------------
MAIN_AD .FILL x3000
PROMPT_AD .FILL x4000
PRINT_AD .FILL x4500

;--------------------------- START COMPUTE_M ----------------------------
COMPUTE_M
	ST R1, SAVE_R1			; Save reigisters
	ST R2, SAVE_R2
	ST R3, SAVE_R3

	LD R1, MONTH
	ADD R3, R1, #0
	AND R2, R2, #0
	ADD R2, R2, #-2
	ADD R1, R1, R2
	BRp MONTH_GT_2
	ADD R3, R3, #10
	BR #2
	MONTH_GT_2
		ADD R3, R3, #0
	ST R3, M
	LD R1, SAVE_R1			; Restore reigisters
	LD R2, SAVE_R2
	LD R3, SAVE_R3
	RET
;--------------------------- END COMPUTE_M ------------------------------
;--------------------------- START COMPUTE_K ----------------------------
COMPUTE_K
	ST R1, SAVE_R1			; Save reigisters
	ST R2, SAVE_R2
	ST R3, SAVE_R3
	ST R7, SAVE_R7

	LD R1, YEAR
	LD  R2, N_100
	JSR R1_MOD_R2
	LD R3, X_MOD_Y
	ST R3, K
	LD R1, SAVE_R1			; Restore reigisters
	LD R2, SAVE_R2
	LD R3, SAVE_R3
	LD R7, SAVE_R7
	RET
;--------------------------- END COMPUTE_K ----------------------------
;--------------------------- START COMPUTE_J ----------------------------
COMPUTE_J
	ST R1, SAVE_R1			; Save reigisters
	ST R2, SAVE_R2
	ST R3, SAVE_R3
	ST R7, SAVE_R7

	LD R1, YEAR
	LD  R2, N_100
	JSR R1_DIV_R2
	LD R3, X_DIV_Y
	ST R3, J
	LD R1, SAVE_R1			; Restore reigisters
	LD R2, SAVE_R2
	LD R3, SAVE_R3
	LD R7, SAVE_R7
	RET
;--------------------------- END COMPUTE_J ----------------------------
;--------------------------- START MUL ----------------------------
  R1_MULT_R2
  	ST R1, SAVE_R1			; Save registers
  	ST R2, SAVE_R2			;
  	ST R3, SAVE_R3			;
  	ST R4, SAVE_R4			;
  	;ST R7, SAVE_R7
  	AND R4, R4, #0			; Test the sign of X
  	ADD R1, R1, #0
  	BRn X_NEG			; If X is negative, change X to positive
  	BR #3
  	X_NEG
  		NOT R1, R1
  		ADD R1, R1, #1
  		NOT R4, R4
  	ADD R2, R2, #0
  	BRn Y_NEG			; If Y is negative, change Y to positive
  	BR #3				; Change Y to positive
  	Y_NEG
  		NOT R2, R2
  		ADD R2, R2, #1
  		NOT R4, R4
  	AND R3, R3, #0
  	MULT_REPEAT
  		ADD R3, R3, R1		; Perform addition on X
  		ADD R2, R2, #-1		; Use R2 as the counter
  		BRnp MULT_REPEAT	; Continue loop while counter not equal to 0

  	ADD R4, R4, #0			; Test the sign flag
  	BRn CHANGE_SIGN			; Change the result if sign flag is negative
  	BR #2
  	CHANGE_SIGN			; Change the sign of the result
  		NOT R3, R3
  		ADD R3, R3, #1
  	ST R3, X_MUL_Y			; Save the result
  	LD R1, SAVE_R1			; Restore registers
  	LD R2, SAVE_R2			;
  	LD R3, SAVE_R3			;
  	LD R4, SAVE_R4			;
  	RET
;--------------------------- END MUL ----------------------------
;--------------------------- START DIV ----------------------------
  R1_DIV_R2
  	ST R1, SAVE_R1			; Save registers
  	ST R2, SAVE_R2			;
  	ST R3, SAVE_R3			;
  	ST R4, SAVE_R4			;
  	ST R5, SAVE_R5			;

  	AND R3, R3, #0			; Initialize the whole part counter
  	AND R5, R5, #0			; Initialize the sign flag
  	ADD R1, R1, #0
  	BRn X_NEG_2			; If X is negative, change X to positive
  	BR #3
  	X_NEG_2
  		NOT R1, R1
  		ADD R1, R1, #1
  		NOT R5, R5
  	ADD R2, R2, #0
  	BRn Y_NEG_2
  	BR #3
  	Y_NEG_2
  		NOT R2, R2
  		ADD R2, R2, #1
  		NOT R5, R5

  	NOT R4, R2			; Initialize the decrement counter
  	ADD R4, R4, #1			;
  	DIV_REPEAT
  		ADD R1, R1, R4		; Subtract Y from X
  		BRn #2
  		ADD R3, R3, #1		; Increment the whole number counter
  		BR DIV_REPEAT		; Continue loop while X is still greater than Y
  	ADD R5, R5, #0			; Test the sign flag
  	BRn CHANGE_SIGN_2		; Change the result if sign flag is negative
  	BR #2
  	CHANGE_SIGN_2			; Change the sign of the result
  		NOT R3, R3
  		ADD R3, R3, #1
  	ST R3, X_DIV_Y			; Save the result
  	LD R1, SAVE_R1			; Restore registers
  	LD R2, SAVE_R2			;
  	LD R3, SAVE_R3			;
  	LD R4, SAVE_R4			;
  	LD R5, SAVE_R5
  	RET
;--------------------------- START DIV ----------------------------
;--------------------------- START MOD ----------------------------
  R1_MOD_R2
  	ST R1, SAVE_R1			; Save registors
  	ST R2, SAVE_R2			;
  	ST R3, SAVE_R3			;
  	ST R4, SAVE_R4			;
  	ST R5, SAVE_R5			;
  	;STI R7, SAVE_R7

  	AND R5, R5, #0
  	ADD R1, R1, #0
  	BRn X_NEG_3			; If X is negative, change X to positive
  	BR #3
  	X_NEG_3
  		NOT R1, R1
  		ADD R1, R1, #1
  		NOT R5, R5
  	ADD R2, R2, #0
  	BRn Y_NEG_3
  	BR #3
  	Y_NEG_3				; If Y is negative, change Y to positive
  		NOT R2, R2
  		ADD R2, R2, #1
  		NOT R5, R5
  	NOT R3, R2			; Initialize the decrement counter
  	ADD R3, R3, #1			;
  	ADD R4, R1, #0			; Initialize the modulo counter
  	MOD_REPEAT
  		ADD R1, R1, R3 		;
  		BRn #2			; If R3 cannot go into R1 exit loop
  		ADD R4, R4, R3		; else continue to calculate modulo
  		BR MOD_REPEAT
  	ST R4, X_MOD_Y
  	LD R1, SAVE_R1			; Restore registers
  	LD R2, SAVE_R2			;
  	LD R3, SAVE_R3			;
  	LD R4, SAVE_R4			;
  	LD R5, SAVE_R5			;
  	;LDI R7, SAVE_R7			;
  	RET
;--------------------------- END MOD ----------------------------
;--------------------------- VARS ----------------------------
    MONTH	.FILL #4
    DAY	.FILL #17
    YEAR	.FILL #2016
    DAY_OF_THE_WEEK .FILL #10
; ------ Equation Vars -----
    M	.FILL #0
    J	.FILL #0
    K	.FILL #0
; ----- Constants --------
    V_13 .FILL #13
    V_5 .FILL #5
    V_4 .FILL #4
    V_7 .FILL #7
; ----- Sub parts of Equation -----
    V_X .FILL #0
    V_Y .FILL #0
    V_Z .FILL #0
    V_G .FILL #0
; ---- Holders
    X_MUL_Y .FILL #0
    X_DIV_Y .FILL #0
    X_MOD_Y .FILL #0
    N_100	.FILL #100

; ---- Registry Save Values ------
SAVE_R1 .FILL x3500
SAVE_R2 .FILL x3501
SAVE_R3 .FILL x3502
SAVE_R4 .FILL x3503
SAVE_R5 .FILL x3504
SAVE_R7 .FILL x3505


.END
