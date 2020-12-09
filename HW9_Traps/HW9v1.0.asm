;*****************************************************************************
;
;  Function Name:   Type Conversion Counter
;  Author: Dan Blanchette
;
;  Due Date: 04 - 27 - 2020
;
;  Revision: 1.0
;
;  Description:
;     This routine will ask for the number of letter in a string
;		it will then convert all lower case letters to upper case
;		then it will record the number of coversions it made using TRAPS
;
;  Register Usage:
;     R0 TRAP x23's ASCII values stored here / used for conversions or otherwise.
;     R1 Throw away register
;     R2 Holds count of converted chars
;     R3 Outer Loop Counter based on user input
;     R4 Holds the first CTERM label to convert the ascii value of the user's input to a numeric counter value. / Then used to store updated ascii values
;     R5 Throw away Register
;     R6 Throw away Register
;     R7 Reserved register updated with funcion returns / instruction positions
;
;   Pseudocode Algorithm:

		; Part 1) routine that will "cout <<" a prompt to enter a number 0-9 (Hint: Use a TRAP)
		;  input needs to be echoed back to the console. [ TRAP ]
		;
		; Part 2) The program must accept same amount of characters as indicated and echo them
		; Part 3) once echoed, the program will "convert" all lower case characters to upper case
		; and output it to console [ IE Hello == HELLO ] ( addition of characters against a value of - 32)
		; Part 4) counter to keep track of the amount of numbers that were converted.

;****************************************************************************/
.ORIG	x3000
	AND R0,R0, #0 ; Reserved for TRAP x23 to process user input
	AND R1,R1, #0
	AND R2,R2, #0
	AND R3,R3, #0
	AND R4,R4, #0
	AND R5,R5, #0
	AND R6,R6, #0
	AND R7,R7, #0
;
;
;
	LEA R4, MEMBLOCK ; pointer to captured user input into a block of memory
	STR R5, R4, #0
	LD R0, NEWLINE
	TRAP x21 ; OUTPUT NEWLINE ASCII VALUE
	LEA R0, PROMPT1 ; Create a pointer to the prompt 1 string
	TRAP x22 ; PUTS display the prompt
;
;
	JSR GetInt ; function to get integer and echo it
;
;
	LD R4 CTERM ; -48
	ADD R3, R3, R4 ; User's ASCII value - 48 ( to de-ASCII a loop counter for the # of characters )
	ADD R3, R3, #1 ; add one to the conversion to interate the loop correct # of times.
;
AGAIN	ADD R3, R3, #-1 ; DECREMENT THE LOOP
	BRp 	GETCHAR ; if R3's value is still positive get the next character from the user using the GETCHAR Subroutine
	BRz	TOTAL_LOWER	;BRz tally all uppercase conversions then display that number and HALT the program
;
;
;
; FUNCTION TO GET INTIAL INPUT AND RESUME PROGRAM
GetInt 	TRAP x23 ; GET USER INPUT
	TRAP x21 ; ECHO USER INPUT
	ADD R3,R0,#0 ; STORE USER INPUT IN R3
	LD R7, RETURN 
	RET
;
;
;
; Formatting and Prompts
NEWLINE	.FILL x000A ; create a new line
PROMPT1 .STRINGZ "Please enter a number ( 0 - 9 )"
PROMPT2 .STRINGZ "Enter a letter from the keyboard based on the number you selected: "
PROMPT3 .STRINGZ "Lowercase letters = "
;
;
UPDATE 	ADD R2,R2,#1 ; lower case letters converted counter
	LD R6,CONVERT; update R6 with -32
	ADD R0, R0, R6 ; UPDATE VALUE TO ASCII UPPERCASE
	ADD R5, R0, #0 ; temp hold results in R5
	ST R5, MEMBLOCK ; store results into the memory block
	ADD R4, R4, #1 ; point to next block in memory
	BRnzp	AGAIN
;
GETCHAR LD R0,  NEWLINE	
		TRAP x21
		LEA R0, PROMPT2
		TRAP x22; PUTS
		TRAP x23 ; Get user input
		TRAP x21 ; echo 
		LD R1, ASCII_CHECK ; -97 used for in equality check against the input if ( charInput >= 97 )
		ADD R6, R0, #0 ; store the ascii value in R6
		ADD R1, R6, R1 ; ADD ASCII input to -97
		ST R6, MEMBLOCK
		BRzp UPDATE ; if positive outcome ascii value was a lower case letter
		BRn AGAIN
;
; DISPLAY TOTAL CONVERTED LOWER CASE LETTERS
;
TOTAL_LOWER	 	 LD R0, NEWLINE
			 TRAP x21
;PRINT ALL USER INPUT	 
			 AND R0, R0, #0
			 LD R0, ARRAY
			 LEA R0, MEMBLOCK
			 TRAP x22 

;PRINT COUNT		 
			 LD R0, NEWLINE
			 TRAP x21
			 LD R6, CTERM2	
			 TRAP x21 ; OUT NL
			 LEA R0, PROMPT3
		         TRAP x22 ; PUTS
			 AND R0, R0, #0
		         ADD R0, R6, R2
			 TRAP x21
			 BRnzp DONE
			
;
ASCII_CHECK .FILL xFF9F ; -97
;
NEG_COUNT NOT R2, R2
	  ADD R2, R2, #1
;
SaveR2 .FILL x0000
;
;
ARRAY .FILL x30C1
CONVERT .FILL xFFE0 ; -32
CTERM .FILL xFFD0 ; -48
CTERM2 .FILL x0030
RETURN .FILL x300F
COUNT .FILL #10
MEMBLOCK .BLKW 10
DONE HALT
.END