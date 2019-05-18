
//main function


//SWAP FUNCTION
//does what: swap the elements in a[i] and a[j]
//parameters: 
//X0 - starting address of a sublist
//X1 - index i 
//X2 - index j 
//X3 - temporary register
//return value - none
swap:

//PARTITION FUNCTION
//does what: seperate the sublists into two
// and place them relative to the pivot
//parameters: 
//X0 - starting address of a sublist
//X1 - # of int in the sublist (size)
//X2 - leftmost index to be partitioned (left) 
//X3 - rightmost index to be partitioned (right)
//return value - X0, index of the pivot element
partition:



//QUICKSORT FUNCTION
//does what: main f to recursively sort the list 
//parameters: 
//X0 - starting address of a sublist
//X1: # of int in the sublist
//return value - none
quicksort:
	SUBIS 	XZR, X1, #1		
	B.GE	true condition		//if size > 1 then */

