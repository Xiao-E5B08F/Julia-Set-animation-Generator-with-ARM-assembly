.data
first_line:
	.asciz "*****Input ID*****\n"
enter1:
	.asciz "** Please Enter Member 1 ID:**\n"
enter2:
	.asciz "** Please Enter Member 2 ID:**\n"
enter3:
	.asciz "** Please Enter Member 3 ID:**\n"
enterC:
	.asciz "** Please Enter Command **\n"
msg1:
	.asciz "*****Print Team Member ID and ID Summation*****\n"
IDsum_ask:
	.asciz "ID Summation = %d\n"
str_format:
	.asciz "%s"
int_format:
	.asciz "%d"
output_int:
	.asciz "%d\n"
P:
	.asciz "p"

ID1:
	.word 0
ID2:
	.word 0
ID3:
	.word 0
IDsum:
	.word 0
ID1_address:
	.word 0
ID2_address:
	.word 0
ID3_address:
	.word 0
IDsum_address:
	.word 0
char:
	.space 80
	
	
.text
.global IDsum_ask
.global ID1
.global ID2
.global ID3
.global IDsum
.global id

end_func:
	ldr r0, =end_line
	bl printf
	ldmfd	sp!, {pc}

id:
	stmfd sp!, {lr}
	
	ldr r4, =ID2_address
	str r1, [r4]
	ldr r4, =ID1_address
	
	subs r1, pc, lr	/*Must reserve, cannot add any_command upper*/

	str r0, [r4]	
	ldr r4, =ID3_address
	str r2, [r4]
	ldr r4, =IDsum_address
	str r3, [r4]
	
	ldr r0, =first_line
	bl printf
/*-----*****Input ID*****-----*/


	ldr r0, =enter1
	bl printf
/*-----** Please Enter Member 1 ID:**-----*/	
	ldr r0, =int_format
	ldr r1, =ID1
	bl scanf

	
	ldr r0, =enter2
	bl printf
/*-----** Please Enter Member 2 ID:**-----*/	
	ldr r0, =int_format
	ldr r1, =ID2 
	bl scanf
	

	ldr r0, =enter3
	bl printf
/*-----** Please Enter Member 3 ID:**-----*/	
	ldr r0, =int_format
	ldr r1, =ID3
	bl scanf
	

/*----- add ----- */
	mov r0, #0
	mov r1, #1	
	cmp r0, r1	@ Z clear 
	ldr r1, =ID1
	ldr r1, [r1]
	ldr r2, =ID2
	ldr r2, [r2]
	addne r3, r1, r2	@Conditional Execution 1
						@Format of Operand2 1
	
	mov r0, #10
	mov r1, #9
	subs r0, r0, r1, lsr #0		@C set
								@Format of Operand2 2
						
	ldrhi r1, =ID3		@Conditional Execution 2
	ldr r1, [r1]		
	add r3 , r3, r1
	add r3 , r3, #0		@Format of Operand2 3
	ldr r4, =IDsum
	str r3, [r4]
/*----- add ----- */

/*----- set parameter value -----*/
	ldr r0, =ID1
	ldr r0, [r0]
	ldr r1, = ID1_address
	ldr r1, [r1]
	str r0, [r1]
	
	ldr r0, =ID2
	ldr r0, [r0]
	ldr r1, = ID2_address
	ldr r1, [r1]
	str r0, [r1]
	
	ldr r0, =ID3
	ldr r0, [r0]
	ldr r1, = ID3_address
	ldr r1, [r1]
	str r0, [r1]
	
	ldr r0, =IDsum
	ldr r0, [r0]
	ldr r1, = IDsum_address
	ldr r1, [r1]
	str r0, [r1]
/*----- set parameter value -----*/


	ldr r0, =enterC
	bl printf
/*-----** Please Enter Command **-----*/	
	ldr r0, =str_format
	ldr r1, =char
	bl scanf
	
	ldr r0, =P
	ldrb r0, [r0]
	ldr r1, =char
	ldr r1, [r1]
	cmp r0, r1
	blne end_func 	@not equal should stop the func 
	
	
	ldreq r0, =msg1		@Conditional Execution 3
	bleq printf

/*-----*****Print Team Member ID and ID Summation*****-----*/		
	/*ID1*/
	ldr r0, =output_int
	ldr r2, =ID1
	ldr r1, [r2]
	bl printf

	/*ID2*/
	ldr r0, =output_int
	ldr r2, =ID1
	ldr r1, [r2], #4	@addressing mode 1
	ldr r1, [r2]		@addressing mode 2
	bl printf
	
	/*ID3*/
	ldr r0, =output_int
	ldr r2, =ID1
	ldr r1, [r2, #8]!	@addressing mode 3
	bl printf

	ldr r0, =next_line
	bl printf
	
	/*IDsum*/
	ldr r0, = IDsum_ask
	ldr r1, =ID3
	ldr r1, [r1, #4]	@addressing mode 4
	bl printf
	

	ldr r0, =end_line
	bl printf
	

	ldmfd	sp!, {lr}
	mov pc, lr
.end
