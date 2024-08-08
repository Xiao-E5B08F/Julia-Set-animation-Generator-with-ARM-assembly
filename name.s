.data
first_line:
	.asciz "*****Print Name*****\n"
group:
	.asciz "Team 17\n"
member1: 
	.asciz "Liu Yen Cheng\n"
member2:
	.asciz "Bai Hong Dek\n"
member3:
	.asciz "Chen Kong Sang\n"
str_format:
	.asciz "%s"
end_line:
	.asciz "*****End Print*****\n"
next_line:
	.asciz "\n"
.text
.global end_line
.global next_line
.global name
.global member1
.global member2
.global member3
.global group
name: 
	stmfd sp!, {lr}
	
	ldr	r0, =first_line
	bl	printf
	
	ldr r0, =group
	bl	printf
	ldr r0, =member1
	bl	printf
	ldr	r0, =member2
	bl	printf
	ldr	r0, =member3
	bl	printf
	ldr	r0, =end_line
	bl	printf
	
	ldmfd	sp!, {lr}
	mov pc, lr
.end
