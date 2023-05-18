#java -jar MarsPlus.jar GomokuProjectFinal.asm
#cd Desktop/2340/Project

.data
labels:
		.asciiz "  A B C D E F G H J K L M N O P Q R S T\n"

numberLabels: 
		.word 19,18,17,16,15,14,13,12,11,10,09,08,07,06,05,04,03,02,01
		
board:		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
		
		
alphabet:	.byte 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'
		.byte 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q'
		.byte 'R', 'S', 'T'
		
move_msg:	.asciiz	"move?\n"
illegal_msg:	.asciiz	"Illegal Move\n"
winMessage:	.asciiz "Player Wins!\n"
endMessage:	.asciiz "Game Over!\n"
againMessage:	.asciiz "Play Again? 0 or 1\n"
userEnter:	.space 3
zero:		.word 0
moves:		.word 0
player:		.byte 'P'
computer:	.byte 'C'
newline:	.asciiz "\n"
space:		.asciiz " "
dot:		.byte '.'
collumnIndex:	.space 1
integer:	.space 1 # the input (integer) after character

pitch: .byte 69 #sound
duration: .byte 100
instrument: .byte 58
volume: .byte 100

.text
main:
	li	$s4, 0	#counter for array of moves
	j	mainLoop
	
mainLoop:	# create/update the board

	li	$v0, 4
	la	$a0, newline
	syscall
	
	li	$s0, 0	# tile counter
	li	$s1, 0 	# new row counter
	li	$s2, 361 # maximum tiles on the board (19 x 19 = 361)
	li	$s3, 0 #counter for array of word elements
	
	li	$v0, 4
	la	$a0, space
	syscall
	
	li	$v0, 4
	la	$a0, labels
	syscall
	
	jal	createBoard1
	
	li	$v0, 4
	la	$a0, labels
	syscall
	
	jal	AskUser
	
	# Turn the user input char into collumn index
	jal	findCollumn1
	
	# Update the board
	jal	PlayerInput
	
	lw	$s4, moves
	addi	$s4, $s4, 1
	sw 	$s4, moves
	
	jal	GenerateComputer

	# print newline
	li	$v0, 11
	lb	$a0, newline
	syscall
	
	lw	$s4, moves
	li	$t0, 0
	bge	$s4, 5, WinLoop
	
	j	mainLoop

AskUser:
	# asking for player move
	
	li	$v0, 4
	la	$a0, move_msg
	syscall
	
	li	$v0, 8
	la	$a0, userEnter
	li	$a1, 4
	syscall
	li	$t0, 0
	lbu	$a2, userEnter($t0)
	addi	$t0, $t0, 1
	lbu	$a1, userEnter($t0)
	addi	$t0, $t0, 1
	lbu	$a0, userEnter($t0)
	beq	$a0, 10, singleNum
	addi 	$a1, $a1, -48
	mul	$a1, $a1, 10
	addi	$a0, $a0, -48
	add	$a1, $a1, $a0
	addi	$a1, $a1, -1
	addi	$a1, $a1, -19
	mul	$a1, $a1, -1
	addi	$a1, $a1, -1
	move	$a0, $a2
	blt	$a0, 65, PlayerError
	bgt	$a0, 84, PlayerError
	blt	$a1, 0, PlayerError
	bgt	$a1, 18, PlayerError 
	jr	$ra

singleNum:
	addi 	$a1, $a1, -48
	addi	$a1, $a1, -1
	addi	$a1, $a1, -19
	mul	$a1, $a1, -1
	addi	$a1, $a1, -1
	move	$a0, $a2
	blt	$a0, 65, PlayerError
	bgt	$a0, 84, PlayerError
	blt	$a1, 0, PlayerError
	beq	$t6, 1,	findCollumn1
	jr	$ra
	
createBoard1:	
	addi	$s1, $s1, 19
	li	$v0, 1
	lw	$a0, numberLabels($s3)
	syscall
	li	$v0, 11
	lb	$a0, space
	syscall
	
	j	printRow

createBoard2:	
	li	$v0, 1
	lw	$a0, numberLabels($s3)
	syscall
	addi	$s3, $s3, 4
	
	li	$v0, 11
	lb	$a0, newline
	syscall
	
	bgt	$s3, 36, addSpace	#36 as after row number 1, s3 = 4.  After row 9, s3 = 36
	
	bgt	$s2, $s1, createBoard1
	jr	$ra

# prints space before right hand row number (only for if number is 1 digit)
addSpace:
	lb	$a0, space
	li	$v0, 11
	syscall
	
	# same 2 lines as in createBoard2:
	bgt	$s2, $s1, createBoard1
	jr	$ra
	
printRow:
	
	lb	$a0, board($s0)
	li	$v0, 11
	syscall
	
	# print out space
	lb	$a0, space
	li	$v0, 11
	syscall
	
	addi	$s0, $s0, 1
	bgt	$s1, $s0, printRow
	
	j	createBoard2
	
PlayerError:
	li	$v0, 4
	la	$a0, illegal_msg
	syscall
	
	li	$t6, 1
	
	j	AskUser
	
PlayerInput: 
	# address = base_address + (row_index * collumn_size + collumn_index) * dataSize
	# base_adress is the "board" label
	# dataSize is byte which is 1
	li	$t0, 19 	# register $t0 holds the collumn size of constant 19
	
	# row_index * collumn_size
	# row_index is in register $a1
	mul	$a2, $a1, $t0

	# (row_index * collumn_size) + collumn_index
	# collumn_index is in register $a0
	add	$a2, $a2, $a0
	
	lb	$t3, board($a2)
	lb	$t4, player
	beq	$t3, $t4, PlayerError
	lb	$t4, computer
	beq	$t3, $t4, PlayerError
	
	# update to the board
	lb	$t1, player	# "player" label contains 'P', we'll replace '*' with that 
	sb	$t1, board($a2)
	li	$t6, 0
	jr	$ra
	
	
	
findCollumn1:
	# Since register $a0 holds a character, we'll need to turn it into collumn index
	# This will be the counter to keep track of the character index in "alphabet" label
	li	$t0, 0
findCollumn2:
	lb	$t1, alphabet($t0)
	beq	$a0, $t1, findCollumnReturn
	addi	$t0, $t0, 1
	j	findCollumn2
findCollumnReturn:
	sb	$t0, collumnIndex
	lb	$a0, collumnIndex
	beq	$t6, 1, PlayerInput
	jr	$ra
	
GenerateComputer:
	li	$v0, 42
	li	$a1, 19
	syscall
	add 	$a0, $a0, 1
	move	$t0, $a0
	
	li	$v0, 42
	li	$a1, 19
	syscall
	add 	$a0, $a0, 1
	move	$t1, $a0
	
	mul	$t0, $t0, $t1
	
	lb	$t3, board($t0)
	#li	$v0, 11
	#move	$a0, $t3
	#syscall
	
	#ERROR CHECKER
	lb	$t4, player
	beq	$t3, $t4, GenerateComputer
	lb	$t4, computer
	beq	$t3, $t4, GenerateComputer
	
	lb	$t2, computer
	sb	$t2, board($t0)
	jr	$ra
	
WinLoop:
	li	$t7,0
	lb	$t1, board($t0)
	lb	$t2, player
	addi	$t0, $t0, 1
	beq	$t1, $t2, WinCheck1
	beq	$t0, $s2, mainLoop
	j WinLoop
	
WinCheck1:
	addi	$t7, $t0, -2
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinCheck2
	addi	$t7, $t7, 1
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinCheck2
	addi	$t7, $t0, 2
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinCheck2
	addi	$t7, $t0, 1
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinCheck2
	j	DisplayWin
	
WinCheck2:
	li	$t7, 0
	addi	$t7, $t0, -39
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal1
	addi	$t7, $t7, 19
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal1
	addi	$t7, $t7, 38
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal1
	addi	$t7, $t7, 19
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal1
	
	j	DisplayWin
	
Diagonal1:
	
	li	$t7, 0
	addi	$t7, $t0, -41
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal2
	addi	$t7, $t7, 20
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal2
	addi	$t7, $t7, 40
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal2
	addi	$t7, $t7, 20
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, Diagonal2
	
	j DisplayWin

Diagonal2:
	
	li	$t7, 0
	addi	$t7, $t0, -37
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinLoop
	addi	$t7, $t7, 18
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinLoop
	addi	$t7, $t7, 36
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinLoop
	addi	$t7, $t7, 18
	bltz 	$t7, WinLoop
	bgt	$t7, $s2, WinLoop
	lb	$t1, board($t7)
	bne	$t1, $t2, WinLoop
	
	j 	DisplayWin
	
DisplayWin:
	
	li	$v0, 4
	la	$a0, newline
	syscall
	
	li	$s0, 0	# tile counter
	li	$s1, 0 	# new row counter
	li	$s2, 361 # maximum tiles on the board (19 x 19 = 361)
	li	$s3, 0 #counter for array of word elements
	
	li	$v0, 4
	la	$a0, space
	syscall
	
	li	$v0, 4
	la	$a0, labels
	syscall
	
	jal	createBoard1
	
	li	$v0, 4
	la	$a0, labels
	syscall
	
	li	$v0, 4
	la	$a0, winMessage
	syscall
	
	li 	$v0, 31 
	la 	$t0, pitch
	la 	$t1, duration 
	la 	$t2, instrument
	la 	$t3, volume 
	move 	$a0, $t0 
	move 	$a1, $t1 
	move 	$a2, $t2
	move 	$a3, $t3 
	syscall
	
	j 	playAgain

playAgain:
	li	$v0, 4
	la	$a0, againMessage
	syscall
	li	$v0, 5
	syscall
	li	$t0, 0
	lb	$t1, dot
	beq	$v0, 1, clearBoard
	j	exit

clearBoard:
	sb	$t1, board($t0)
	addi	$t0, $t0, 1
	beq	$t0, $s2, main
	j clearBoard

exit:	
	li	$v0, 4
	la	$a0, endMessage
	syscall
	li	$v0, 10
	syscall
