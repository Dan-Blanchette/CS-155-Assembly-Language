	.ORIG x3000
	AND R2, R2, #0 ; CLEARS REGISTER 2
	AND R3, R3, #0
	ADD R2, R2, #4	; UPDATE R2 WITH THE DECIMAL VALUE 4
	ADD R3, R3, #1

LOOP	ADD R2, R2, #-1
	BRz DONE
	ADD R3, R3, R3
	BRp LOOP	
DONE	HALT
	.END
