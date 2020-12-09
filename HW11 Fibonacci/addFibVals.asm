			LDR R0, R6, #0  ; read the return value at the top of the stack
			ADD R6, R6, #-1 ; pop the return value 
			LDR R1, R5, #-1 ; read temporary value: ( fib_n1 n - 1 )
			ADD R0, R0, R1  ; Fib_n1 ( n -1 ) + Fib_n2 ( n - 2 )  
			BR FIB_END      ; BR to end of code