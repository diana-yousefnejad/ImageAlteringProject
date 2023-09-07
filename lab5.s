jal main
#                         CS 240, Lab #5
#
#      IMPORTANT NOTES:
#
#      Write your assembly code only in the marked blocks.
#
#      DO NOT change anything outside the marked blocks.
#
#      Remember to fill in your name, Red ID in the designated fields.
#
#
#      
###############################################################
#                           Data Section
.data
student_name: .asciiz "Diana Yousefnejad"
student_id: .asciiz "826351767"

identity_m: .word 1, 0, 0, 0, 1, 0
scale_m:    .word 2, 0, 0, 0, 1, 0
rotation_m: .word 0, 1, 0, 1, 0, 0
shear_m:    .word 1, 1, 0, 0, 1, 0

input_1: .byte 100, 60, 81, 2
input_2: .byte 10, 20, 30, 110, 127, 130, 210, 220, 230
input_3: .byte 0, 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55
output_1: .space 4
output_2: .space 9
output_3: .space 16
input_4: .byte 1, 2, 3, 4, 5,1, 2, 3, 4, 5,1, 2, 3, 4, 5,1, 2, 3, 4, 5,1, 2, 3, 4, 5
input_5: .byte 210, 220, 230,10, 20, 30, 110, 127, 130, 55 , 140, 210, 220, 230, 240, 2, 3, 4, 5,10
input_6: .byte 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55, 230, 240, 250, 255, 55,230, 240, 250, 255, 55
output_4: .space 25
output_5: .space 25
output_6: .space 25

# Part 1 tests data
# thresh value = 128
test_11_expected_output: .byte 0, 0, 0, 0
test_12_expected_output: .byte 0, 0, 0, 0, 0, 255, 255, 255, 255
test_13_expected_output: .byte 0, 0, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0

# Part 2 tests data
# identity and rotation on input 2
test_221_expected_output: .byte 10, 20, 30, 110, 127, 130, 210, 220, 230
test_222_expected_output: .byte 10, 110, 210, 20, 127, 220, 30, 130, 230
# identity, scale, rotation, and shear on input 3
test_231_expected_output: .byte 0, 10, 20, 30, 40, 110, 128, 130, 140, 210, 220, 230, 240, 250, 255, 55
test_232_expected_output: .byte 0, 20, 0, 0, 40, 128, 0, 0, 140, 220, 0, 0, 240, 255, 0, 0
test_233_expected_output: .byte 0, 40, 140, 240, 10, 110, 210, 250, 20, 128, 220, 255, 30, 130, 230, 55
test_234_expected_output: .byte 0, 10, 20, 30, 110, 128, 130, 0, 220, 230, 0, 0, 55, 0, 0, 0

# Part 3 tests data 
test_31_expected_output: .byte 4 3 1 5 2 4 3 1 5 2 4 3 1 5 2 4 3 1 5 2 4 3 1 5 2 
test_32_expected_output: .byte 10 230 210 20 220 130 127 30 55 110 230 220 140 240 210 5 4 2 10 3 40 30 10 110 20
test_33_expected_output: .byte 40 30 10 110 20 210 140 128 220 130 255 250 230 55 240 255 250 230 55 240 255 250 230 55 240

# Messages
new_line: .asciiz "\n"
space: .asciiz " "
i_str: .asciiz  "Program input:   " 
po_str: .asciiz "Program output:  " 
eo_str: .asciiz "Expected output: " 
t1_str: .asciiz "Testing part 1: \n" 
t2_str_0: .asciiz "Testing part 2 (identity): \n" 
t2_str_1: .asciiz "Testing part 2 (scale): \n" 
t2_str_2: .asciiz "Testing part 2 (rotation): \n" 
t2_str_3: .asciiz "Testing part 2 (shear): \n" 
t3_str: .asciiz "Testing part 3 (Cryptography): \n" 

line: .asciiz "__________________________________________________\n" 

# Files
fin: .asciiz "lenna.pgm"
fout_thresh: .asciiz "lenna_thresh.pgm"
fout_rotate: .asciiz "lenna_rotation.pgm"
fout_shear: .asciiz "lenna_shear.pgm"
fout_scale: .asciiz "lenna_scale.pgm"

fin2: .asciiz "textfile.pgm"
fout_crypt: .asciiz "text_crypt.pgm"

# Input/output buffers
.align 2
in_buffer: .space 400000
in_buffer_end:
.align 2
out_buffer: .space 400000
out_buffer_end:

###############################################################
#                           Text Section
.text
# Utility function to print byte arrays
#a0: array
#a1: length
print_array:
li $t1, 0
move $t2, $a0
print:
lb $a0, ($t2)
andi $a0, $a0, 0xff
li $v0, 1   
syscall
li $v0, 4
la $a0, space
syscall
addi $t2, $t2, 1
addi $t1, $t1, 1
blt $t1, $a1, print
jr $ra
########################################################################################
#a0 = input array
#a1 = output array
#a2 = matrix
#s3 = input dim
#s4 = test str
#s5 = expected array
# Test transform function
########################################################################################
test_p2:
# save ra
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $sp, $sp, -4
sw $a0, 0($sp)
addi $sp, $sp, -4
sw $a1, 0($sp)
addi $sp, $sp, -4
sw $a2, 0($sp)
addi $sp, $sp, -4
sw $a3, 0($sp)
addi $sp, $sp, -4
sw $s4, 0($sp)
addi $sp, $sp, -4
sw $s5, 0($sp)


#a0: input buffer address
#a1: output buffer address
#a2: transform matrix address
#a3: image dimension  (Image will be square sized, i.e. total size = a3*a3)
jal transform 

lw $s5, 0($sp)    
addi $sp, $sp, 4
lw $s4, 0($sp)
addi $sp, $sp, 4
lw $s3, 0($sp)
addi $sp, $sp, 4
lw $s2, 0($sp)
addi $sp, $sp, 4
lw $s1, 0($sp)
addi $sp, $sp, 4
lw $s0, 0($sp)
addi $sp, $sp, 4

# s5: exp arraay
# s4: input string
# s3: input dimenstion
# s2: matrix
# s1: user out
# s0: inputd

mul $s3, $s3, $s3

move $a0, $s4
syscall
la $a0, i_str
syscall
move $a0, $s0
move $a1, $s3
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
move $a0, $s1
move $a1, $s3
jal print_array
li $v0, 4
la $a0, new_line
syscall
la $a0, eo_str
syscall
move $a0, $s5
move $a1, $s3
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

# restore ra
lw $ra, 0($sp)
addi $sp, $sp, 4

jr $ra
###############################################################
###############################################################
#                       PART 1 (Image Thresholding)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension (Image will be square sized, i.e., number of pixels = a2*a2)
#a3: threshold value 
###############################################################
.globl threshold
threshold:
############################## Part 1: your code begins here ###
mul $t0, $a2, $a2 #multiplies the dimensions
addi $t1, $0, 0 #initializes $t1 with 0
addiu $t4,$0, 0xFF #makes $t4 0xFF
addiu $t5,$0, 0x00 #makes $t5 0x00
for: 
beq $t0, $t1, done #checks if finished with array
lbu $t2, 0($a0) #loads input buffer address into $t2

blt $t2, $a3, next #checks if $t2 is less then threshold, if so go to next
sb $t4, 0($a1) #store 0xFF into $a1 output buffer address because $t2 is greater than the threshold
j done2 # jump to done2

next:
sb $t5, 0($a1) #store 0x00 into $a1 output buffer address because $t2 is less than the threshold

done2:
addi $t1, $t1,1 #increment $t1 by 1
addi $a0, $a0, 1 #increment $a0 by 1
addi $a1, $a1, 1 #increment $a1 by 1
j for  #jumps back to loop
done:
		
############################### Part 1: your code ends here ###
jr $ra
###############################################################
###############################################################
#                           PART 2 (Matrix Transform)
#a0: input buffer address
#a1: output buffer address
#a2: transform matrix address
#a3: image dimension  (Image will be square sized, i.e., number of pixels = a3*a3)
###############################################################
.globl transform
transform:
############################### Part 2: your code begins here ##


addiu $t0, $0, 0 #initialize $t0 with 0 (outerloop variable)

outerloop:

beq $t0, $a3, donE #checks if i = $a3
addiu $t1, $0, 0  #initializes j with 0

j innerloop #jumps to innerloop

innerloop:

beq $t1, $a3, outerLoopIncrement #if j = $a3 goes to outerloopIncrement 


#put i and j into two equations

#x0 = M00 x X + M01 x Y + M02

#y0 = M10 x X + M11 x Y + M12

lw $t2, 0($a2) #M00 in $t2
lw $t3, 4($a2) #M01 in %t3
lw $t4, 8($a2) #M02 in $t4


mul $t5, $t2, $t1 #multiply M00 by $t1
mul $t6, $t3, $t0 #multiply M01 by $t0


addu $t7, $t5, $t6 #add $t5 and $t6
addu $t7, $t7, $t4 #add $t4


lw $t2, 12($a2) #M10 in $t2
lw $t3, 16($a2) #M11 in $t3
lw $t4, 20($a2) #M12 in $t4


mul $t5, $t2, $t1 #multiply $t2 and $t1 put in $t5
mul $t6, $t3, $t0 #multiply $t3 and $t0, put in $t6
addu $t8, $t5, $t6 #add $t5 and $t6 and mult to $t8 
addu $t8, $t8, $t4 #add M12


#checks for threshold
blt $t7, $0, over #if t7 less than 0, go to over
blt $t8, $0, over #if t8 less than 0, go to over
bge $t7, $a3, over #if $t7 greater than $a3, go to over
bge $t8, $a3, over #if #t8 greater than #a3, go to over





#offset
mul $t2, $t8, $a3 # mul $t8 and $a3
addu $t2, $t2, $t7 #add $t7 to $t2
#$t2 holds offset

#element address
addu $t3, $a0, $t2 #add #a0 and #t2 put in $t3
#$t3 holds element address

lbu $t4, 0($t3)  #load element address into $t4

sb $t4, 0($a1) #store $t4 into $a1
addiu $t1, $t1, 1 #increment $t1
addiu $a1, $a1, 1 #increment $a1
j innerloop #jump to innerloop

over:
sb $0, 0($a1)  #store 0 into $a1


addiu $a1, $a1, 1 #increment $a1
addiu $t1, $t1, 1 #increment $t1

j innerloop #jump to innerloop


outerLoopIncrement:
addiu $t0, $t0, 1 #increment $t0
j outerloop #jump to outerloop


donE:


############################### Part 2: your code ends here  ##
jr $ra
###############################################################
###############################################################
#                       PART 3 (Image Cryptography)
#a0: input buffer address
#a1: output buffer address
#a2: image dimension (Image will be square sized, i.e., number of pixels = a2*a2)
###############################################################
.globl cryptography
cryptography:
############################## Part 3: your code begins here ###
mul $t0, $a2, $a2 #multiply dimensions
addi $t1, $0, 0 #initialize $t1 with 0 (i)
addi $t5, $0, 5 #initialize $t5 with 5
loop: 
beq $t0, $t1, end #if i is the dimensions go to end
lbu $t2, 0($a0) #load $a0 into $t2


div $t1, $t5 #divide $t1 by 5
mfhi $t6 #store remainder into $t6

bne $t6, 0, check1 #if remainder is not 0, go to check1 
sb $t2, 2($a1) #store $t2 into #a1 offset = 2
j iterate #jump to iterate

check1:
bne $t6,1, check2 #if remainder is not 1 go to check2
sb $t2, 3($a1) #store $t2 into $a1 with offset of 3
j iterate #jump to iterate

check2:
bne $t6, 2, check3  #if remainder is not 2 go to check3
sb $t2, -1($a1) #store #t2 into $a1 with offset of -1
j iterate #jump to iterate

check3: 
bne $t6,3,check4 #if remainder is not 3 go to check3
sb $t2, -3,($a1) #store #t2 into $a1 with offset of -3
j iterate #jump to iterate

check4:
bne $t6,4,iterate #if remainder is not 4 go to iterate
sb $t2, -1($a1) #store $t2 into $a1
j iterate #jump to iterate

iterate:
addi $t1, $t1,1 #iterate #t1 by 1
addi $a0, $a0, 1 #iterate #a0 by 1
addi $a1, $a1, 1 #iterate #a1 by 1

j loop #jump to loop
end: 


		
############################### Part 3: your code ends here ###
jr $ra
###############################################################
###############################################################
###############################################################
#                          Main Function
main:

.text

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall


# Test threshold function
li $v0, 4
la $a0, t1_str
syscall

la $a0, input_1
la $a1, output_1
li $a2, 2
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_1
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_11_expected_output
li $a1, 4
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_2
la $a1, output_2
li $a2, 3
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_2
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_12_expected_output
li $a1, 9
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_3
la $a1, output_3
li $a2, 4
li $a3, 128
jal threshold

la $a0, i_str
syscall
la $a0, input_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_3
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_13_expected_output
li $a1, 16
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

# Part 2 testing
#a0 = input array
#a1 = output array
#a2 = matrix
#s3 = input dim
#s4 = test str
#s5 = expected array

la $a0, input_2
la $a1, output_2
la $a2, identity_m
li $a3, 3 # dim
la $s4, t2_str_0
la $s5, test_221_expected_output
jal test_p2

la $a0, input_2
la $a1, output_2
la $a2, rotation_m
li $a3, 3 # dim
la $s4, t2_str_2
la $s5, test_222_expected_output
jal test_p2

########
la $a0, input_3
la $a1, output_3
la $a2, identity_m
li $a3, 4 # dim
la $s4, t2_str_0
la $s5, test_231_expected_output
jal test_p2

la $a0, input_3
la $a1, output_3
la $a2, scale_m
li $a3, 4 # dim
la $s4, t2_str_1
la $s5, test_232_expected_output
jal test_p2

la $a0, input_3
la $a1, output_3
la $a2, rotation_m
li $a3, 4 # dim
la $s4, t2_str_2
la $s5, test_233_expected_output
jal test_p2

la $a0, input_3
la $a1, output_3
la $a2, shear_m
li $a3, 4 # dim
la $s4, t2_str_3
la $s5, test_234_expected_output
jal test_p2


#Test Part 3
li $v0, 4
la $a0, t3_str
syscall

la $a0, input_4
la $a1, output_4
li $a2, 5
li $a3, 128
jal cryptography

la $a0, i_str
syscall
la $a0, input_4
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_4
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_31_expected_output
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_5
la $a1, output_5
li $a2, 5
li $a3, 128
jal cryptography

la $a0, i_str
syscall
la $a0, input_5
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_5
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_32_expected_output
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall

la $a0, input_6
la $a1, output_6
li $a2, 5
li $a3, 128
jal cryptography

la $a0, i_str
syscall
la $a0, input_6
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, po_str
syscall
la $a0, output_6
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall

la $a0, eo_str
syscall
la $a0, test_33_expected_output
li $a1, 25
jal print_array
li $v0, 4
la $a0, new_line
syscall
syscall


#### Test on images
#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall

## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Threshold
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
li $a2, 512
li $a3, 80
jal threshold 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_thresh      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall    

###################################
#### Test on images for cryptography
#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin2      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall

## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Threshold
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
li $a2, 500
li $a3, 80
jal cryptography 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_crypt      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall    

###################################



#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Rotate
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
la $a2, rotation_m
li $a3, 512
jal transform 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_rotate      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# Shear
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
la $a2, shear_m
li $a3, 512
jal transform 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_shear      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall




#open the file for writing
li   $v0, 13       # system call for open file
la   $a0, fin      # board file name
li   $a1, 0        # Open for reading
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor

#read from file
li   $v0, 14       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, in_buffer   # address of buffer to which to read
la   $a2, in_buffer_end     # hardcoded buffer length
sub $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall



## Copy the header
la $t0, in_buffer
la $t1, out_buffer
lw $t2, ($t0)
sw $t2, ($t1)
lw $t2, 4($t0)
sw $t2, 4($t1)
lw $t2, 8($t0)
sw $t2, 8($t1)
lw $t2, 12($t0)
sw $t2, 12($t1)

# scale
la $a0, in_buffer
addi $a0, $a0, 16
la $a1, out_buffer
addi $a1, $a1, 16
la $a2, scale_m
li $a3, 512
jal transform 


#open a file for writing
li   $v0, 13       # system call for open file
la   $a0, fout_scale      # board file name
li   $a1, 1        # Open for writing
li   $a2, 0
syscall            # open a file (file descriptor returned in $v0)
move $s6, $v0      # save the file descriptor
# write back
li   $v0, 15       # system call for read from file
move $a0, $s6      # file descriptor
la   $a1, out_buffer   # address of buffer to which to read
la   $a2, out_buffer_end     # hardcoded buffer length
subu $a2, $a2, $a1
syscall            # read from file

# Close the file
li   $v0, 16       # system call for close file
move $a0, $s6      # file descriptor to close
syscall


_end_program:
# end program
li $v0, 10
syscall
