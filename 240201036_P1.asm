#240201036 ELMAN HAMDİ

.data
# -9999 marks end of the list
firstList: .word 8, 3, 6, 200, 5, 2, 9, 1, -9999

space: .asciiz "-"
newline: .asciiz "\n"
x: .asciiz "x"

found: .asciiz " founded\n\n"
notfound: .asciiz " not founded\n\n"

min: .asciiz " : min\n\n"
max: .asciiz " : max\n\n"

number: .word -9999


.text
main:
	la $s0,number
	la $s2, ($s0)

	jal BUILT
	jal PRINT

	jal NEWLINE

	li $a0,7
	jal INSERT
	jal PRINT

	jal NEWLINE

	li $a0,5
	jal INSERT
	jal PRINT

	li $a0, 20
	jal FIND
	
	li $a0, 5
	jal FIND

	li $t0,1
	jal FINDMINMAX
	
	li $t0,0
	jal FINDMINMAX


	j EXIT

#------------------------------------------------------------------------------------------------------------
BUILT:
	la $t0, firstList #List is T0
	la $s3, ($s0)
	CONTINUE:
	lw $s1, ($s3)
	lw $t1, 0($t0) #List value
	
	lw $t5, 0($s0)						#Checks first 
	li $t7, -9999 						#element is 
	beq $t5, $t7, ROOT					#exist(if it is qwual -9999 then not exist)

	beq $t1,$t7, JUMPBACK 				#If t1 equal t7 than list is end, And exit from BUILT function

	beq $t1,$s1, EQUAL					#If equal thats mean the value which want to insert in BST already exist, then pass the value

	blt $t1,$s1, LEFT					#If t1(current element in List) is low than $s1 (temporary root) than go to LEFT function
		lw $t3, 8($s3)					
		beq $t3,$zero, INSERTRIGHT		#Checks t3(It is s3+8) is have a address if not t3 is 0 and than we can insert the element here 
		lw $s3, 8($s3)					#If not than just add 8 to s3 and continue to loop
		j CONTINUE
		INSERTRIGHT:					#Insert right side
			sw $t1, ($s2)				#Store the word in s2(End of  BST)
			la $t4,($s2)				
			sw $t4, 8($s3)				#Save adsress of new node to parent's right side( It's s3+ 8)
			la $t4, ($s3)
			sw $t4, 12($s2)				#Save adress of parent to new node's 12.th byte
			addi $s2, $s2, 16			#Update new s2(s2 is end of BST)
			la $s3, ($s0)				#Prepare s3 to new insert element
			addi $t0, $t0, 4			#New element
			j CONTINUE

	LEFT:								#Same as RIGHT side but just '4' instead of '8'
		lw $t3, 4($s3)
		beq $t3,$zero, INSERTLEFT
		lw $s3, 4($s3)
		j CONTINUE
		INSERTLEFT:
			sw $t1, ($s2)
			la $t4,($s2)
			sw $t4, 4($s3)
			la $t4, ($s3)
			sw $t4, 12($s2)
			addi $s2, $s2, 16
			la $s3, ($s0)
			addi $t0, $t0, 4
			j CONTINUE

	ROOT:								#Add root, update s2, pass to new list element
		sw $t1, ($s0)
		addi $s2,$s2,16
		addi $t0,$t0,4
		j CONTINUE

	EQUAL:								#Pass this element
		la $s3, ($s0)
		addi $t0, $t0, 4
		j CONTINUE


#------------------------------------------------------------------------------------------------------------
INSERT:
	la $s3, ($s0)
	move $t1, $a0

	INSERTLOOP:
	lw $s1, ($s3)



	lw $t5, 0($s0)						#Checks first 
	li $t7, -9999 						#element is 
	beq $t5, $t7, ROOT2					#exist(if it is qwual -9999 then not exist)


	beq $t1,$s1, EQUAL2					#If equal thats mean the value which want to insert in BST already exist, then does nothing

	blt $t1,$s1, LEFT2					#If t1 is low than $s1 (temporary root) than go to LEFT function
		lw $t3, 8($s3)
		beq $t3,$zero, INSERTRIGHT2		#Checks t3(It is s3+8) is have a address if not t3 is 0 and than we can insert the element here 
		lw $s3, 8($s3)					#If not than just add 8 to s3 and continue to loop
		j INSERTLOOP
		INSERTRIGHT2:
			sw $t1, ($s2)				#Store the word in s2(End of  BST)
			la $t4,($s2)
			sw $t4, 8($s3)				#Save adsress of new node to parent's right side( It's s3+ 8)
			la $t4, ($s3)
			sw $t4, 12($s2)				#Save adress of parent to new node's 12.th byte
			addi $s2, $s2, 16			#Update new s2(s2 is end of BST)
			jr $ra

	LEFT2:								#Same as RIGHT side but just '4' instead of '8'
		lw $t3, 4($s3)
		beq $t3,$zero, INSERTLEFT2
		lw $s3, 4($s3)
		j INSERTLOOP
		INSERTLEFT2:
			sw $t1, ($s2)
			la $t4,($s2)
			sw $t4, 4($s3)
			la $t4, ($s3)
			sw $t4, 12($s2)
			addi $s2, $s2, 16
			jr $ra


	ROOT2:								#Adds root, updates s2
		sw $t1, ($s0)
		addi $s2,$s2,16
		jr $ra

	EQUAL2:								#Do Nothing
		la $s3, ($s0)
		jr $ra

#------------------------------------------------------------------------------------------------------------
FIND:
	move $t6, $ra 						#We using ra in this function, firstly I copy it to turn to back
	la $s3, ($s0)
	move $t1, $a0

	FINDLOOP:
	lw $s1, ($s3)

	lw $t5, 0($s0)						#Checks first 
	li $t7, -9999 						#element is 
	beq $t5, $t7, NOTFOUND				#exist(if it is qwual -9999 then not exist)


	beq $t1,$s1, FOUND					#Is equal t1 with temporary root

	blt $t1,$s1, LEFT3					#If t1 smaller than temporary root than go to LEFT3
		lw $t3, 8($s3)					
		beq $t3,$zero, NOTFOUND			#If t3(That is s3 + 8) is 0 than the value is didn't find
		lw $s3, 8($s3)					#Else continue with s3 + 8 (right side)
		j FINDLOOP
		
	LEFT3:								#Same as RIGHT side but just '4' instead of '8'
		lw $t3, 4($s3)
		beq $t3,$zero, NOTFOUND
		lw $s3, 4($s3)
		j FINDLOOP
		
	NOTFOUND:							#NotFound printing part
		li $v0, 0
		li $v1, 1
		jal PRINTNUMBER
		jal PRINTNOTFOUND
		move $ra, $t6
		jr $ra

	FOUND:								#Found printing part
		li $v0,1
		la $v1, ($s3)
		jal PRINTNUMBER
		jal PRINTFOUND
		move $ra, $t6
		jr $ra

	PRINTNUMBER:
		li $v0,1
		syscall
		jr $ra

	PRINTFOUND:
		la $a0 , found
		li $v0,4
		syscall
		jr $ra


	PRINTNOTFOUND:
		la $a0 , notfound
		li $v0,4
		syscall
		jr $ra

#------------------------------------------------------------------------------------------------------------
FINDMINMAX:
	la $s3, ($s0)
	move $t1, $t0					#t0 is a parameter

	FINDLOOP2:
	lw $s1, ($s3)					
	bne $t1, $zero, MAX				#If t1 != 0 than find max
		lw $t3, 4($s3)				
		beq $t3,$zero, RESULT		#If t3 (This is s3 + 4) is equal 0 than BST is ended and we found the result
		lw $s3, 4($s3)				#Else continue with left side 
		j FINDLOOP2
	MAX:							#Same as MIN side but just '4' instead of '8'
		lw $t3, 8($s3)				
		beq $t3,$zero, RESULT
		lw $s3, 8($s3)
		j FINDLOOP2
	RESULT:
		move $v0, $t1
		la $v1, ($s3)

		move $t6,$ra
		jal PRINTMINMAX				#Print the result
		move $ra,$t6
		jr $ra


PRINTMINMAX:						#Using v0 and v1, and print  (v0 == 0 then min, v0 == 1 then max, and v1 is value's address)
	
	beq $v0,$zero, MIN
		lw $a0, ($v1)
		li $v0,1
		syscall
		la $a0 , max
		li $v0,4
		syscall
		jr $ra
	MIN:
		lw $a0, ($v1)
		li $v0,1
		syscall
		la $a0 , min
		li $v0,4
		syscall
		jr $ra

#------------------------------------------------------------------------------------------------------------
PRINT: #just add 16 and prints all parents and childs for checking
	move $t6, $ra 					 #store $ra for go back
	la $s3, ($s0)

	LOOP:
	move $ra, $t6  
	la $t1, 0($s3) 
	lw $a0, 0($t1)
	beq $a0,$zero, 	JUMPBACK  		 #If equals 0 than means PRINT is and and jump back to $ra
	li $v0,1
	syscall 						 #Prints temporary roots

	jal SPACE

	lw $t1, 4($s3)
	beq $t1, $zero, RIGHTCHILD   	#If zero than prints "X"
	lw $a0, 0($t1)
	li $v0,1
	syscall
	j TOLEFT

	RIGHTCHILD:
		jal PRINTX

	TOLEFT:
	jal SPACE
	lw $t1, 8($s3)
	beq $t1, $zero, LEFTCHILD		#If zero than prints "X"
	lw $a0, 0($t1)
	li $v0,1
	syscall
	j TONEW							#end of node print newline
	
	LEFTCHILD:
		jal PRINTX

	TONEW:
	jal NEWLINE

	addi $s3,$s3,16					#Update s3 
	j LOOP

#FUNCTIONS OF PRINT

SPACE:
	la $a0 , space
	li $v0,4
	syscall
	jr $ra

NEWLINE:
	la $a0 , newline
	li $v0,4
	syscall
	jr $ra

PRINTX:
	la $a0 , x
	li $v0,4
	syscall
	jr $ra
#------------------------------------------------------------------------------------------------------------
JUMPBACK:
	jr $ra

EXIT:
	li $v0, 10
	syscall

