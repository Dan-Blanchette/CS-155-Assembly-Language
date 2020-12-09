;*****************************************************************************
;
;  Function Name:   String Getter
;
;  Author: Dan Blanchette

;  Date Due: 5-4-2020
;  Date Submitted : 5-4-2020
;
;  Revision: 1.0
;
;  Description:
;     This routine will echo user input to the console screen until the it finds a new line character. It will then echo the
;	  entire input using the top-level routine to do so.
;  Notes:
;  
;
;
;     
;
;  Returns: a pointer in R0 that points to a buffer that is storing the string.
;
;  Register Usage:
;     R0 = will be updated with user input.
;     R1 = temp data register.
;     R2 = Holds the address value not to be exceeded for characters
;     R3 = Holds trap hander's updated address to x0040
;     R4 = Holds the negative value of the newline character to check if it has been input by the user.
;     R5 = Array Pointer
;     R6 = Stack Pointer
;     R7 = Reserved for RET / JMP7.
;
;     All registers but R0 are preserved in this function
;
;   Pseudocode Algorithm:
;
; char newLine = x000A \\ ASCII Value	
;    if( char != newLine )
;   {
;	cin.getch();
; 	string str = cin.getch();
;	cout << str << \n;	
;   }
;   else
;   cout << str;



;****************************************************************************/
.ORIG   x3000
			AND R1, R1, #0
			AND R2, R2, #0
			AND R3, R3, #0 	
			AND R4, R4, #0
			AND R5, R5, #0
			AND R6, R6, #0
	
	
;"MAIN FUNCTION"
;	
		JSR Subr_Init 		; calls JSR init from main
Get_Input 	TRAP x40      		; calls the trap handler 		
;
Get_Output	ADD R5,R5, #1		; move to final array element
		ADD R1,R1, #0
		LDR R5,R1, #0
		LD R5, #0
		OUT     		; display your results	
		BRnzp EXIT    		; end of main program

Subr_Init   				; inititializes values, adresses, and the contents of the stack
;		
		LD R4, newLineCh
		LD R2, isTwenty
		LEA R6, Stack		; initialize R6 to point to the top of the stack 
		LEA R5, BUFFER		; create a pointer that points to the beginning of the Buffer Array ( BUFFER[20] )
		LEA R1, Move_Buff	; create a pointer to address x4000
		LDR R5, R1, #0		; R5 now points to element 0 of the			 
					; update x0040 with Trap_handler's subroutine
		LD  R1, TRP_ADDY	; R2 will temporarily hold x0040's address	
		LEA R3, TRAP_Handler	; R3 is a pointer to TRAP_Hndlr's first instruction address
		STR R3, R1, #0		; R2 was used to update R3's TRAP_Hndlr instruction to memory location x0040 
					; address x0040 is now able to call TRAP_HANDLER as it's routine instead of being a bad trap vector 
		RET 			; end of Subr_Init subroutine
;
;
TRAP_Handler 
		IN ; get user input
		ADD R1, R4, R0 		; test for newline character
		BRz Get_Output		; if return is entered move to the output subroutine
		STR R0, R5, #0		; Store the contents of R0 into BUFFER[20]
		ADD R5, R5, #1		; move to the next array element
		ADD R1, R5, R2 		; bit mask to test if address x4020 has been reached
		BRz ERROR1
		BR  Get_Input

; end of Trap Handler

; Data and constants here
EXIT 		 HALT
SaveR0		.Fill x0000		; Save register 0
isTwenty	.Fill xF04C		; -x4020
Stack		.Fill x8000
Move_Buff	.Fill x4000		
newLineCh	.Fill xFFF6 		; [ -10 ] negated newline value
ERROR_Mess	.STRINGz  "You have exceeded the keyboard buffer. The program will now terminate."
ERROR1 		LD R1, ERROR_Mess
	   	OUT
		HALT
;
TRP_ADDY 	.FILL x0040                    
BUFFER 		.BLKW  #21              ; set aside storage for an array to hold 20 characters from the keyboard
;
		.END