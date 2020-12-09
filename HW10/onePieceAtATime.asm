;*****************************************************************************
;
;  Function Name:   String Getter
;
;  Author: Dan Blanchette

;  Date: 5-1-2020
;
;  Revision: 1.0
;
;  Description:
;     This routine will echo user input to the console screen until the it finds a new line character. It will then echo the
;	  entire input using the top-level routine to do so.
;  Notes:
;  
;
;  Entry Paramaters:
;     R0 =    
;    
;     
;
;  Returns: a pointer in R0 that points to a buffer that is storing the string.
;
;  Register Usage:
;     R0 = User input GetCh
;     R1 =
;     R2 =
;     R3 =
;     R4 = hold the negative value of the newline character to check if it has been input by the user
;     R5 =
;     R6 = stack pointer
;     R7 = Reserved for RET / JMP7
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
			
LEA R6, BUFFER		; initialize R6 to point to the top of the stack
LD R2, TRP_ADDY
LEA R3, TRAP_Hndlr	; Store the address of TRx40_Hndlr into memory location x0040
STR R3, R2, #0
RET ; end of Init subroutine
Stack_Top .FILL  x5000 ; value for your initial R6 stack pointer value (Top Of Stack)
MAX_BUFFER .FILL xAFE0  ; comparison address to detect the maximum amount of characters that can exist in the stack buffer [ -x5020 ]
TRP_ADDY .FILL x0040 
TRAP_Hndlr ADD R1, R1, #0
BUFFER .BLKW #20
	.END

  
                





  
                






  
                



