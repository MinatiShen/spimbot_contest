.data

.text

## void
## decrypt(unsigned char *ciphertext, unsigned char *plaintext, unsigned char *key,
##         unsigned char rounds) {
##     unsigned char A[16], B[16], C[16], D[16];
##     key_addition(ciphertext, &key[16 * rounds], C);
##     inv_shift_rows(C, (unsigned int *) B);
##     inv_byte_substitution(B, A);
##     for (unsigned int k = rounds - 1; k > 0; k--) {
##         key_addition(A, &key[16 * k], D);
##         inv_mix_column(D, C);
##         inv_shift_rows(C, (unsigned int *) B);
##         inv_byte_substitution(B, A);
##     }
##     key_addition(A, key, plaintext);
##     return;
## }

.globl decrypt
decrypt:
	# Your code goes here :)
	sub $sp,$sp,36
	sw $s0,0($sp)
	sw $s1,4($sp)
	sw $s2,8($sp)
	sw $s3,12($sp)
	sw $s4,16($sp)
	sw $s5,20($sp)
	sw $s6,24($sp)
	sw $s7,28($sp)
	sw $ra,32($sp)
	move $s0,$a0	##ciphertext
	move $s1,$a1	##//plaintxt
	move $s2,$a2 	##/key
	move $s3,$a3 ##//rounds
	
	sub $sp,$sp,16
	move $s4,$sp ##//array A
	sub $sp,$sp,16
	move $s5,$sp ##//array B
	sub $sp,$sp,16
	move $s6,$sp ##//array C
	sub $sp,$sp,16
	move $s7,$sp ##//array D
	
	li $t0,16
	mul $t1,$t0,$s3 ##t1 16*rounds
	add $t2,$s2,$t1 ##key[16*rounds]
	##key addition set up
	move $a0,$s0
	move $a1,$t2
	move $a2,$s6
	jal key_addition ##key_addition(ciphertxt,key[16*rounds],C)
	##inv shift set up
	move $a0,$s6
	move $a1,$s5
	jal inv_shift_rows ##inv_shift(c,b)
	##inv_byte set up
	move $a0,$s5
	move $a1,$s4
	jal inv_byte_substitution

	li $t0,1

	sub $v1,$s3,$t0
	sub $sp,$sp,4
for_loop:
	ble $v1,0,next
	sw $v1,0($sp)
	li $t1,16
	mul $t1,$t1,$v1 #16*k
	#set up for key_addition
	add $a1,$s2,$t1
	move $a0,$s4
	move $a2,$s7
	jal key_addition

	#set up for inv_mix
	move $a0,$s7
	move $a1,$s6
	jal inv_mix_column

	#set up
	move $a0,$s6
	move $a1,$s5
	jal inv_shift_rows

	#set up invbyte sub
	move $a0,$s5
	move $a1,$s4
	jal inv_byte_substitution
	li $t0,1
	lw $v1,0($sp)
	sub $v1,$v1,$t0
	j for_loop

next:
	add $sp,$sp,4
	move $a0,$s4
	move $a1,$s2
	move $a2,$s1
	jal key_addition
	add $sp,$sp,64
	lw $s0,0($sp)
	lw $s1,4($sp)
	lw $s2,8($sp)
	lw $s3,12($sp)
	lw $s4,16($sp)
	lw $s5,20($sp)
	lw $s6,24($sp)
	lw $s7,28($sp)
	lw $ra,32($sp)
	add $sp,$sp,36
	jr $ra
