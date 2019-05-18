////////////////////////
//                    //
// Project Submission //
//                    //
////////////////////////

// Partner1: (your name here), (Student ID here)
// Partner2: (your name here), (Student ID here)

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

////////////////////////
//                    //
//       swap         //
//                    //
////////////////////////
swap:
    // x0: base address
    // x1: index 1
    // x2: index 2
    // Swap the elements at the given indices in the list

    // INSERT YOUR CODE HERE
	
	br lr 
    
////////////////////////
//                    //
//     partition      //
//                    //
////////////////////////
partition:
    // x0: base address
    // x1: The number of integers in the (sub)list
    // x2: Leftmost index to be partitioned in this iteration
    // x3: Rightmost index to be partitioned in this iteration
    // Return:
    // x0: The final index for the pivot element
    // Separate the list into two sections based on the pivot value
	
	// INSERT YOUR CODE HERE

	br lr

////////////////////////
//                    //
//     quickSort      //
//                    //
////////////////////////
quickSort:    
    // x0: base address
    // x1: The number of integers in the (sub)list

    // INSERT YOUR CODE HERE

	br lr
    
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