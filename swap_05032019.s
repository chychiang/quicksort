//SWAP FUNCTION
//does what: swap the elements in a[i] and a[j]
//parameters: 
//X0 - starting address of a sublist
//X1 - index i 
//X2 - index j 
//X3, X4 - temporary register
//return value - none
	
	ADDI	X1, XZR, #1			//input of X1
	ADDI 	X2, XZR, #5			//input of X2

swap:
	//allocating frame and stuff
	SUBI 	SP, SP, #32			//allocate stack frame
	STUR	FP, [SP, #0]		//save old frame ptr on the top of the stack
	ADDI	FP, SP, #24			//set new frame ptr
	STUR	LR, [FP, #-16]		//save the LR value
	STUR	X1, [FP, #-8]		//save the X1 value on stack
	
	//actual start of the program	
	ADDI 	X4, XZR, #8 		//set X4 to be constant 8
	
	//X3 = a[i] and then storing X3's value on stack
	MUL		X1, X1, X4			//translating index to address offset
	ADD 	X0, X0, X1			//moving the data ptr to a[i]
	LDUR	X3, [X0, #0]		//loading a[i] to X3
	STUR	X3, [FP, #0]		//saving X3 data onto stack
	SUB 	X0, X0, X1			//return the value of X0

	//X3 = a[j]
	MUL 	X2, X2, X4			//translating index to address offset
	ADD 	X0, X0, X2			//moving data ptr to a[j]
	LDUR	X3, [X0, #0]		//loading a[j] to X3
	SUB 	X0, X0, X2			//return data ptr to original position

	//a[i] = a[j]
	ADD 	X0, X0, X1			//moving data ptr to a[i]
	STUR	X3, [X0, #0]		//storing a[j] to a[i]
	SUB 	X0, X0, X1			//return data ptr to original position

	//restoring: X3 = a[i] --> a[j] = X3
	LDUR	X3, [FP, #0]		//restoring the first value of X3
	ADD 	X0, X0, X2			//moving the data ptr to a[j]
	STUR	X3, [X0, #0]		//storing a[i] to a[j]

done: 
	LDUR LR, [FP, #-16] 		// restore the return address
	LDUR FP, [FP, #-24] 		// restore old frame pointer
	ADDI SP, SP, #32 			// deallocate stack frame
	//BR LR 					// return to the caller
	stop 						//only using stop here - other functions imcomplete


