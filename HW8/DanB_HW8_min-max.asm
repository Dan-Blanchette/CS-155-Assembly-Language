;*****************************************************************************
;
;  Function Name:   Min/Maxiumus
;
;  Author: Dan Blanchette
;  Credited peer help with equivalencey logic for this program : Austin K. and Aaron A.
;  Date: 04-17-2020
;
;  Revision: 2.0
;
;  Description:
;     This routine will find the lowest and highest value and print the results to the 
;	  Console output screen
;
;  Notes:
;     Function needs to compare 10 values the function works by using memory mapped addresses to display the array results
;
;  Entry Paramaters:
;    
;     
;     
;
;  Returns: 
;
;  Register Usage:
;     R0 pointer to array element
;     R1 set min value to point to element 0 for comparison
;     R2 set max value to point to element 0 for comparison
;     R3 will store the array elements current value
;     R4 temp register
;     R5 will be used as an overwrite register
;     R6 used to print string to console
;     R7 used to print string to console 
;
;   
;
;   Pseudocode Algorithm:
;
;    const int SIZE = 10; // 
;    int data[SIZE] = {1,3,7,2,5,4,8,7,0,2}; DATA .FILL 1 . FILL 3 .FILL 7,......
;    int minVal = array[0]; assign a register to element 0 R7 = 3 for its starting value
;    int maxVal = array[0]; assign re
;
;    for(int i = 1; i < SIZE; i++) // translate for loop into LC-3
;    {
;        if( array[i] < minVal ) translate if statment into LC-3
;        {
;            minVal = array[i]; 
;        }
;        else if ( array[i] > maxVal)
;        {
;            maxVal = array[i];
;       } 
;    }
;   cout << minVal << endl;
;   cout << maxVal << endl;
;**********************************************************************************************
.orig x3000
	;clear all registers
	AND R0, R0, #0 
	AND R1, R1, #0	
	AND R2, R2, #0	
	AND R3, R3, #0	
	AND R4, R4, #0	
	AND R5, R5, #0	
	ADD R6, R6, #0	
	 
	LEA R0, DATA 		; R0 is now a pointer to ELEMENT 0 of the array
;
	LDR R1, R0, #0 	; initialize the min value register to point to element 0
	LDR R2, R0, #0 	; initialize the max value register to point to element 0
;
AGAIN   LDR R3, R0, #0 	; load the current value stored in the array element into R3	
	ADD R0, R0, #1 	; position the pointer to point to the next array element
	ADD R3, R3, #0 	; check for sentinel
;
	BRn RESULTS 		; once the max and min are found, print the min&max
;
	ADD R4, R3, #0 		; copy the results of R3 into R4
	NOT R4, R4     		; flip the bits on R4's value
	ADD R4, R4, #1 		; 2's complement of R3's value now in R4

;**********Boolean Functions
IS_MIN 	ADD R5, R4, R1 		; evaluate the 2's comp value and the current array value store				
				; results in R5.
	BRp UPDATE_MIN 		; if the result is not 0 and not negative, a new min has been found;
				; transfer to next label to update the value
IS_MAX ADD R5, R4, R2;
	BRn UPDATE_MAX
	BR AGAIN
	
;********** Overwrites ***********				   
UPDATE_MIN  AND R1, R1, #0 	; clear and re-use R1
	    ADD R1, R3, #0
	    BR IS_MAX
;
UPDATE_MAX AND R2,R2,#0 ; clear and re-use R2
	   ADD R2, R3, #0
	   BR AGAIN
;
;***************Printing Functions
;	
RESULTS LD R0, ASCII 		; loaded x30 into R0
	ADD R1, R1, R0		; added x30 to the min
	ADD R2, R2, R0		; added x30 to the max

; PRINT MIN STRING TO CONSOLE
		LEA R6, MIN 	; load string array 
P_MIN	LDR R7, R6, #0 	; process string array store ASCII in R7
		BRz PRINT_MIN 	; if null terminator move to next Label
LP2		LDI R5, DSR 	; Activate the DSR for polling 
		BRzp LP2
		STI R7, DDR
		ADD R6, R6, #1
		BR P_MIN
;
; PRINT MIN VALUE
PRINT_MIN  	LDI R5, DSR		   			   
    		BRzp PRINT_MIN 	   	; POLL WHILE DSR != -integer
    		STI R1, DDR 		;Print out the min integer
		BR P_MAX
;
; PRINT THE MAX VALUE
PRINT_MAX  	LDI R5, DSR		   			   
    		BRzp PRINT_MAX 	   	; POLL WHILE DSR != -integer
    		STI R2, DDR		;Print out the min integer
		BR DONE
;		
;PRINT MAX STRING TO CONSOLE
P_MAX LEA	R6, MAX
LP1 	LDR R7, R6, #0
		BRz PRINT_MAX
LP4		LDI R5 DSR
		BRzp LP4
		STI R7, DDR
		ADD R6, R6, #1
		BR LP1
	
;/****** HALT COMMAND

DONE	HALT

;
; *************** DATA ARRAY *****************
DATA	.FILL 1
	.FILL 3
	.FILL 7
	.FILL 2
	.FILL 5
	.FILL 4
	.FILL 8
	.FILL 7
	.FILL 0
	.FILL 2
	.FILL -1

; CONSOLE OUTPUT LABELS		
MIN .STRINGZ "MIN = "		
MAX .STRINGZ "  MAX= "

; /******** DISPLAY REGISTER LABELS *************
ASCII	.FILL	x30 ; Credit to Austin K.
DSR	.FILL 	xFE04 ; LABEL HOLDS ADDRESS OF DSR
DDR	.FILL 	xFE06 ; LABEL HOLD ADDRESS OF DDR

.end