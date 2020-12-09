;*****************************************************************************
;
;  Function Name:   Min-Max Function
;
;  Author: Dan Blanchette

;  Date: 04/15/2020
;
;  Revision: 1.0
;
;  Description:
;     This routine will find the minimum and maximum values for a 10 element array
;     with the data values = 1,3,7,2,5,4,8,7,0,2
;  Notes:
;	Function needs two Branches that will determine the value of the element.
;	Branch 1 will check to see if the zero flag is enabled 
;	[ This will constitute as a check for the lowest value 0 in the range 0-8 ]
;
;	Branch 2 will check for a maximum value [ possibly using a bitmask to look for 8 in the range 0-8 ] 
; 	There is also a need to store 10 values into memory.  
;
;  Entry Paramaters:
;     R0 = blah blah     (describe what the registers mean/contain upon entry)
;     R6 = blah blah
;     R7 = blah blah
;
;  Returns: blah blah in R0  (describe how the return value is handled)
;
;  Register Usage:
;     R0 contains blah as a calling parm; returns blah
;     R1 blah
;     R2 blah
;     R3 Not used
;     R4 Not used
;     R5 Not used
;     R6 Reserved for blah
;     R7 Reserved for blah
;

;****************************************************************************/
.orig	x3000
; clear all registers ( some may not be used in the execution of this program )
AND	R0, R0, R0 ; clear R0
AND	R1, R1, R1 ; clear R1
AND	R2, R2, R2 ; clear R2
AND	R3, R3, R3 ; clear R3
AND	R4, R4, R4 ; clear R4
AND	R5, R5, R5 ; clear R5
AND	R6, R6, R6 ; clear R6
AND	R7, R7, R7 ; clear R7

LEA		R1, STR	;Load address of the first string character
GETCH 	LDR R0, R1, #0	;get next char
		BRz  	DONE
LOOP 	LDI	R3, DSR
		BRzp LOOP
		STI	R0, DDR
		ADD R1, R1, #1
		BR 	LOOP
;
; set up the array and assign the data values to a memory register 
;
STR .STRINGZ "1372548702"
DONE HALT

			
.end