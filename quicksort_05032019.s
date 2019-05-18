//QUICKSORT
//does what: recursively sort the list, call for partition and then recursively call quicksort on the left and right based on the results of partitions
//parameters: 
//X0 - starting address of list (a)
//X1 - # of integers in the list (SIZE)
//X2 - stores the value from partition
//return value - none

//start of the quicksort function
quicksort: 

	//allocation of stack frame
	SUBI 	SP, SP, #32			//allocate stack frame
	STUR	FP, [SP, #0]		//save old frame ptr on the top of the stack
	ADDI	FP, SP, #24			//set new frame ptr
	STUR	LR, [FP, #-16]		//save the LR value
	STUR	X0, [FP, #-8]		//save the X0 value on stack, as X0 will be used by partition later

	ADDI	X2, XZR, #0			//initiating X2, making sure its 0
	SUBIS	XZR, X1, #1			//IF X1 > 1 
	B.GT	true_cond			//branch to "true_cond"
	B 		done				//false condition - skips all to "done"

true_cond: 
	BL		partitions			//call for partition, partition will store return value (pivot index) in X0
	ADD 	X2, X2, X0			//X2 (pivot position) = X0 <-- this X0 represents the pivot index
	LDUR	X0, [FP, #-8]		//restore the value of X0 from stack, X0 now represents starting address of array
	BL 		quicksort 			//call for quicksort(a,pivot_position) = (X0, X2) 
	//address of a [pivot_position + 1]
	//base address of the array + J + 1 
	//go back and understand what partition actually do!

	//size - pivot_position - 1
	STUR	X1, [FP, #0] 		//preserve the original value of X1  (SIZE)
	SUBS 	X1, X1, X2			//size (X1) - pivot_position (X2)
	SUBIS	X1, X1, #1			//size (X1) - 1	
	BL 		quicksort
	LDUR	X1, [FP, #0]		//restore original value of X0


//false condition below, nothing happens
done:
	LDUR LR, [FP, #-16] 		//restore the return address
	LDUR FP, [FP, #-24] 		//restore old frame pointer
	ADDI SP, SP, #32 			//deallocate stack frame
	//BR 	LR 					//branch back to caller 
	stop						//get rid of stop when done /w all
//end of quicksort