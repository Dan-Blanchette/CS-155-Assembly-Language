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
.ORIG x3000
	AND	R0, R0, R0
	AND	R1, R1, R1
	AND	R2, R2, R2
	LD	R0, xFA0		

START	LDI   R1, A
	BRzp  START
	STI   R0, B
	BRnzp DONE

A	.FILL xFE04
B	.FILL xFE06

ARRAY	.FILL 1 ; fill the an array with values from data
	.FILL 3
	.FILL 7
	.FILL 2
	.FILL 5
	.FILL 4
	.FILL 8
	.FILL 7
	.FILL 0
	.FILL 2 
DONE	HALT
.END   

