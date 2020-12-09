			LDR R0, R5, #4  ; load parameter n ( change this from activation record to load from a temp register )
			BRz	FIB_BASE    ; n == 0
			ADD R0, R0, #-1 ;
			BRz FIB_BASE    ; n == 1
			
			
FIB_BASE
			AND R0, R0, #0 ; clear R0
			ADD R0, R0, #1 ; #1