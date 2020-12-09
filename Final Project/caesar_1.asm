;*****************************************************************************
;
;  Function Name:   Caesar Cipher ( encryption ) final project
;
;  Author: Dan Blanchette
;
;  Due Date: 05/20/2020
;
;  Revision: 1.0
;
;  Description:
;     This routine will ask the user to specify a shift key value ( 0 - 9 )
;	  It will then prompt again for input of up to a 20 character message to be encrypted
;	  and will display the encrypted message
;  Notes:
;     See projectNotes.txt
;
;  Entry Paramaters:
;     R5 = Block memory array pointer
;     R4 = stores the input for the shift variable's contents
;	  R3 ch ASCII variable will be used for all ASCII related comparisions
;
;  Returns: blah blah in R0  (describe how the return value is handled)
;
;  Register Usage:
;     R0 used as temporary storage of TRAP input/ temp holder of ch ASCII variable input
;     R1 temp register
;     R2 temp register
;     R3 stores values for conversions
;     R4 preserves shift variable
;     R5 .BLKW pointer
;     R6 loop counter for word entry
;     R7 reserved for RET address of JSR intruction
;
;     All registers but Rn, Rn, and Rn are preserved by this function
;
;   Pseudocode Algorithm:
;


;****************************************************************************/


.ORIG 		x3000
		AND R0, R0, #0
		AND R1, R1, #0
		AND R2, R2, #0
		AND R3, R3, #0
		AND R4, R4, #0
		AND R5, R5, #0
		AND R6, R6, #0
		AND R7, R7, #0
	
	
		LEA R5, uInput
		LD  R3, Rem_ASCII 		; remove ascii code and get Base 10 value [ -48 ]
		LD  R2, MaxShift

		BR MAIN	

MAIN:
		LEA R0,	Prompt1 		; Get users shift value first
		PUTS
		IN
		ADD R1, R1, R0			;
		ADD R1, R1, R2			; bounds check R0 and ensure a value doesn't exceed ASCII 9 [ - 57 ] 
		BRp ERROR

		ADD R4, R0, #0 			; get user ASCII value # for the shift
		ADD R4, R4, R3 			; change the input to its binary value representation		
		BRz ERROR

		LD R2, LoopCount		; initialize R2 as the program loop counter 21 [ one more interation than needed ]
	
		LEA R0, Prompt2 		; user prompt for message
		PUTS
		BRnzp Message


;/************** LOOP***********************/
		
Message		ADD R2, R2, #-1		; decrement loop counter
		BRz DONE
		AND R1, R1, #0    	; clear R1 for re-use
		IN
		LD  R6, NewLine		; check if return was pressed
		ADD R1,	R0, R1		; if not space, restore R1 with a copy of R0's value
		ADD R1, R1, R6		; Check if return was pressed
		BRz DONE
		
		AND R1, R1, #0		
		LD  R6, isSpace		; R6 = -32

		ADD R1, R1, R0	  	; copy R0 into R1
		ADD R1, R1, R6	  	; check if space was entered
		BRz AddSpace		; preserve the space char in the array.
		
		AND R1, R1, #0		; Rest R1
		LD  R3, NegA		; check low range non-alphabetical character being entered

		ADD R1, R0, R1
		ADD R1, R1, R3
		BRn ERROR
		
		AND R1, R1, #0		; reset R1 val
		ADD R1, R1, R0

		LD  R3, NegZ		; check high range non-alphabetical character being entered
		ADD R1, R1, R3
		BRp ERROR
		
		AND R1, R1, #0		; reset R1 val
		ADD R1, R1, R0
		
		LD  R3, is_Z 	        ; R3 = -90 checking for max alpha ACSII value [ used to see if lower case characters are being entered ]

		AND R1, R1, #0		; reset R1
		ADD R1, R1, R0		

		LD R6,  NoWrap		; test to see if word wrapping is required
		AND R1, R1, #0
		ADD R1, R1, R0
		ADD R1, R1, R6
		BRnz encipher_C
		
		
		AND R1, R1, #0	        ; clear R1
		ADD R1,	R0, R1		; if not return, restore R1 with a copy of R0's value
		ADD R1, R1, R3    	; user input - 90 [ max negative number ] = 'z'
		BRnz isUpper		; if negative/zero flag is set, value go to isUpper function
		BRp toUpper	  	; if postitive value is determined in R1, then convert toUpper
;
;
;
isUpper 	BRnz encipher_D	   ; if 'XYZ' print it out
		NOT R3, R3
		ADD R3, R3, #1     ; +90 after 2's compliment
		ADD R1, R1, R3     ; get original value back
		BRp  encipher_A	   ; ch >= 'Z'


toUpper 	NOT R3, R3
		ADD R3, R3, #1     ; +90 after 2's compliment
		ADD R1, R1, R3     ; get original value back
		LD  R3, toUpperC   ; remove lower case value -32
		ADD R1, R1, R3	   ; R1 = lower case value
		LD  R3, is_R	   ;  -82 = 'R'  ch >= R they will require a word wrap thus encipher_B will be used
		ADD R1, R1, R3	   ;
		BRp encipher_A     ; needs WR 
		BRn encipher_B     ; doesn't need WR

encipher_A  	NOT R3, R3	; Requires Word Wrap 'R' - 'Z'
	   	ADD R3, R3, #1
	   	ADD R1, R1, R3 ; undo the test for 'R'

		LD  R3, WR
		ADD R1, R1, R3 ; -26
		ADD R1, R1, R4 ; apply cipher shift key
		STR R1, R5, #0
		ADD R5, R5, #1
		BRnzp Message
	

encipher_B 	NOT R3, R3	; The 'B' - 'Q' Case
	   	ADD R3, R3, #1
	   	ADD R1, R1, R3 ; undo the test for 'R'
	   	ADD R1, R1, R4 ; apply the shift key
		STR R1, R5, #0 ; store R1 in array
		ADD R5, R5, #1 ; next memory address block
	   	BRnzp Message

encipher_C	AND R1, R1, #0  ;The 'A' Case
		ADD R1, R1, R0
		ADD R1, R1, R4
		STR R1, R5, #0
		ADD R5, R5, #1
		BRnzp Message	

encipher_D	LD R3, WR
		AND R1, R1, #0  ; The 'XYZ' Case
		ADD R0, R0, R3  ; apply Word Wrap R0
		ADD R1, R1, R0  ; update R1 with R0's value
		ADD R1, R1, R4
		STR R1, R5, #0
		ADD R5, R5, #1
		BRnzp Message	

AddSpace 	STR R0, R5, #0
	 	ADD R5, R5, #1 
	 	BRnzp Message

DONE		AND R1, R1, #0
		STR R1, R5, #0
		LEA R0, uInput
		PUTS 
		HALT



ERROR		LEA R0, Eprompt
		PUTS
		HALT


uInput .BLKW #21









LoopCount	.Fill x0015	  ; Loop counter to be decremented
NewLine		.Fill xFFF6	  ; [ -10 ] checks for'\n'
NoWrap		.FILL xFFAF	  ; [ -81 ]  = 'Q' min value to be checked for to exlude word wrapping cipher
NegA		.FILL xFFBF 	  ; bounds checking low range
NegZ		.Fill xFF86	  ; boudns checking high range
MaxShift	.Fill xFFC7	  ; [ -57 ]  for bounds check on shift key value
Rem_ASCII 	.Fill xFFD0 	  ; [ -48 ]  removes ASCII value leaving just same value in binary or base 10	
CharCount 	.FIll xFFEC 	  ; [ -20 ]  Loop counter 
isSpace		.Fill xFFE0
WR		.Fill xFFE6	  ; [ -26 ]  start at 'A'
is_R		.Fill xFFAE	  ; [ -82 ]  'R'
is_Z		.Fill xFFA6	  ; [ -90 ]  'Z'	
toUpperC 	.Fill xFFE0 	  ; [ -32 ]

Prompt1    .STRINGZ "Enter the desired shift key number ( 1 - 9 ) for your encryption: "
Prompt2	   .STRINGZ "\nEnter a message to be encrypted: "
EndMessage .STRINGZ "\nYour encrypted message is: "
Eprompt    .STRINGZ "You have entered an incorrect value, The program will now end"

.END