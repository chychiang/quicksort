////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: Cheng-Yu Chiang, A15456001
// Partner2: (your name here), (Student ID here)

//==============================================================================================================================
////////////////////////
//                    //
//       main         //
//                    //
////////////////////////

    lda x0, array
    lda x1, arraySize
	ldur x1, [x1, #0]
    bl printList
    
    lda x0, array
    lda x1, arraySize
    ldur x1, [x1, #0]
    bl quickSort    

    lda x0, array
    lda x1, arraySize
    ldur x1, [x1, #0]
    bl printList
	stop

//==============================================================================================================================
////////////////////////
//                    //
//       swap         //
//                    //
////////////////////////
//does what: swap the elements in a[i] and a[j]
//parameters: 
//X0 - starting address of a sublist
//X1 - index i 
//X2 - index j 
//X3, X4 - temporary register
//return value - none
swap:
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
	SUB 	X0, X0, X2  


done: 
	LDUR LR, [FP, #-16] 		// restore the return address
	LDUR FP, [FP, #-24] 		// restore old frame pointer
	ADDI SP, SP, #32 			// deallocate stack frame
	BR LR 					// return to the caller

    
//==============================================================================================================================
////////////////////////
//                    //
//     partition      //
//                    //
////////////////////////
//Partition function
//parameters:
//X0 - starting address of list
//X1 - size
//X2 - leftmost index
//X3 - rightmost index

//used registers
//X5 = i
//X6 = j
//X7 - used to hold size temporarily
//X8 - used to hold left temporarily
//X9 - used to hold right temporarily
//X10 - value of pivot
//X11 - temp value
//X12 - a[i]

//returns:
//X0 - pivot index

//notes for swap function
//X0 - starting address of a sublist
//X1 - index i 
//X2 - index j 
//X3 and X4 used

//start of function
partition:
	//allocating frame and stuff [WIP, im not entire confident on this section]
	SUBI SP, SP, #24	//pushing stack frame
	STUR FP, [SP, #0]	//save old frame ptr on the top of the stack
	ADDI FP, SP, #16	//set new frame ptr
	STUR LR, [FP, #-8]	//save the LR value

partitionNoLink:
	//hold size, left, and right so that I don’t lose them in other function calls
	MOV X7, X1 //X7 holds size
	MOV X8, X2 //X8 holds left
	MOV X9, X3 //X9 holds right

//Swap(a, (left+right)/2, right) = Swap (X0, X1, X2)
	//X0 (a) is already set
	//X1 = (X8+X9)/2 (left+right)/2
	ADD X1, X2, X3
	ADDI X11, XZR , #2
	UDIV X1, X1, X11		//X1 SET
	MOV X2, X3			//X2 SET
	BL swap

//i and j set to leftmost index
	MOV X5, X8 //i is in X5
	MOV X6, X8 //j is in X6

//pivot ← a[right]
//load value of pivot (a[right]) into X10
	ADDI X11, XZR, #8 //set X11 to 8
	MUL X11, X9, X11 	//mul “right” by 8 to refer to the memory index
	ADD X0, X0, X11 	//shift a to index value “right”
	LDUR X10, [X0, #0] 	//load value into X10
	SUB X0, X0, X11 	//shift a back to its original position


//WHILE LOOP 
//while i < right do:
pivotLoop:
	SUBS XZR, X5, X9 //compare i and right
	B.LT contPivotLoop //if i<right, continue loop
	B endPivotLoop //otherwise end the loop

contPivotLoop:
	//loading a[i] (X0[X5]) into X12
	ADDI X11, XZR, #8 	//set X11 to 8
	MUL X11, X5, X11 	//mul i by 8 to refer to the memory index
	ADD X0, X0, X11 	//shift a to the memory index value
	LDUR X12, [X0, #0] 	//load value into X12
	SUB X0, X0, X11 	//shift a back to its original position

SUBS XZR, X12, X10 //compare a[i] (X12) to pivot (X10)
	B.LT compareSwap
	B.EQ checkIEven
	B compareDontSwap

checkIEven:
	//to check if i is even, divide i by 2, then multiply it by 2, if even, i will equal its original value
	ADDI X1, XZR #2
	SDIV X11, X5, X1 //divide i by 2, rounded down, and store it in X11
	MUL X11, X11, X1 //multiply the divided value by 2
	SUBS XZR, X5, X11 //compare the original i to the rounded down to even version
	B.NE compareDontSwap //branch if the compare is not equal, that i is not even


compareSwap: //come here if a[i] less than pivot, OR a[i] = pivot and i even
	//swap (a, i, j): (X0 X1 X2)
	//X0 is already set to a
	MOV X1, X5 		//load i(X5) into X1
	MOV X2, X6 		//load j(X6) into X2
	BL swap 		//call swap with parameters set
	ADDI X6, X6, #1 //increment j 

compareDontSwap: //jump here if a[i] greater than pivot, or a[i] = pivot and i is odd
	//increment i by 1
	ADDI X5, X5, #1
	B pivotLoop //jump back to the start of the while loop to do comparisons


endPivotLoop:
	//swap (a, j, right): (X0 X1 X2)
	//X0 is already set to a
	MOV X1, X6 //load j(X6) into X1
	MOV X2, X9 //load (a stable version of)right(X9) into X2
	BL swap //call swap with parameters set

	ADDI X1, XZR, #4
	SDIV X11, X7, X1  //divide size by 4, store it in X11
	SUBS XZR, X6, X11 //compare j to size/4
	B.GE recurPartitionCheck //don’t do the following instructions if j >= size/4

	//call partition again with the parameters: (a, size, j+1, right) = (X0 X1 X2 X3)
	//X0 is already set to a
	MOV X1, X7 //load size(X7) into X1
	MOV X2, X6 //load j(X6) into X2
	ADDI X2, X2, #1 //make X2 j+1 instead of just j
	MOV X3, X9 //load right(X9) into X3
	B partitionNoLink


recurPartitionCheck:
//else if j >= (size - size/4)
	ADDI X1, XZR, #4 //move the value 4 into X1
	SDIV X11, X7, X1 //divide size by 4, store it in X11
	SUB X11, X7, X11 //calculate size - size/4
	SUBS XZR, X6, X11//compare j to size - size/4
	B.LT endPartition //dont do the following instructions if j < size - size/4

	//call partition again with the parameters: (a, size, left, j - 1) = (X0 X1 X2 X3)
	//X0 is already set to a
	MOV X1, X7 //load size(X7) into X1
	MOV X2, X8 //load left(X8) into X2
	MOV X3, X6 //load j(X6) into X3
	SUBI X3, X3, #1 //make X3 j-1 instead of just j
	B partitionNoLink

endPartition:
	//set X0 (the returned pivot index) to j(X6)
	MOV X0, X6
	//popping stuff out of stack
	LDUR	LR, [FP, #-8]
	SUBI	FP, SP, #16
	LDUR	FP, [SP, #0]
	ADDI 	SP, SP, #24
	BR LR		//link back to caller

//==============================================================================================================================
////////////////////////
//                    //
//     quickSort      //
//                    //
////////////////////////
//does: recursively sort the list, call for partition and then recursively 
//call quicksort on the left and right based on the results of partitions
//parameters: 
//X0 - starting address of list (a)
//X1 - # of integers in the list (SIZE)
//other used registers:
//X2 - stores the value from partition
//X11 - temp
//return value - none

//start of the quicksort function
quicksort: 

	//allocation of stack frame
	SUBI 	SP, SP, #40			//allocate stack frame
	STUR	FP, [SP, #0]		//save old frame ptr on the top of the stack
	ADDI	FP, SP, #32			//set new frame ptr
	STUR	LR, [FP, #-24]		//save the LR value
	STUR	X0, [FP, #-16]		//save the X0 value on stack, as X0 will be used by partition later
	stur 	x1, [fp, #-8]
	

	SUBIS	XZR, X1, #1			//IF X1 > 1 
	B.GT	true_cond			//branch to "true_cond"
	B 		donequicksort		//false condition - skips all to "done"

true_cond: 
	mov  	x2, xzr 			//X2 = 0 
	SUBI 	X3, X1, #1			//X3 = size - 1
	//a is already set
	//partition (a, size, 0, size - 1) (X0,X1,X2,X3)
	//all parameters are set now - call partition 
	BL		partition			//calls partition, which will store return value (pivot index) in X0
	Stur x0, [fp, #0]		//store
	mov  	x1, X0 				//write the return value from partition as the second parameter (size) of function quicksort
	LDUR	X0, [FP, #-16]		//restore the value of X0 from stack, X0 <- starting address of array 
	//all parameters for quicksort(a, pivot_position) are set, call qs
	BL 		quicksort 			//call for quicksort(a,pivot_position) = (X0, X1) 

	//size - pivot_position - 1
	ldur x0, [fp, #-16] 	//load original value of x0(starting address)
	ldur x1, [fp, #-8]	//load original value of x1(size)
	Ldur x2, [fp, #0]	//load original value of x2
	SUB 	X1, X1, X2		//size (X1) - pivot_position (X2)
	SUBI	X1, X1, #1		//size (X1) - 1	
	//X1 should be set now
	
	addi   	x11, xzr, #8
	mul  	x11, x11, x2 
	addi x11, x11, #8
	add x0, x0, x11 	//address of a[pivot_position+1]
	//x0 and x1 set, call quicksort...
	BL 		quicksort

donequicksort:
	LDUR 	LR, [FP, #-24] 		//restore the return address
	LDUR 	FP, [SP, #0] 		//restore old frame pointer
	ADDI 	SP, SP, #40 		//deallocate stack frame
	BR 		LR 					//branch back to caller 
//end of quicksort

    
//==============================================================================================================================
////////////////////////
//                    //
//     printList      //
//                    //
////////////////////////
printList:
    // x0: base address
    // x1: length of the array

	mov x2, xzr
	addi x5, xzr, #32
	addi x6, xzr, #10
printList_loop:
    cmp x2, x1
    b.eq printList_loopEnd
    lsl x3, x2, #3
    add x3, x3, x0
	ldur x4, [x3, #0]
    putint x4
    putchar x5
    addi x2, x2, #1
    b printList_loop
printList_loopEnd:    
    putchar x6
    br lr
