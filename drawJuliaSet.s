.data
test_line:
	.asciz "*****above is OK*****\n"
@ drawJuliaSet(cY, frame);
@ cX = -700
@ width = 640
@ height = 480
@ frame[640][480] *** short(2bytes)
/*
	r4 = cY
	r5 = frame
	r6 = x
	r7 = zx
	r8 = y
	r9 = zy
	r10 = tmp
	r11 = i, color
*/
/*
	1. 4 Operand2 (check)
	2. 2 condetion (b is excluded)
	3. add lr, r0, pc	(check)
	***__aeabi_idiv*** r0 = r0 / r1
*/

.text
.const:
	.word -700		@const  zx = -700  
	.word 240		@const + 4
	.word 255		@const + 8
	.word 320		@const + 12
	.word 500		@const + 16
	.word 1000		@const + 20
	.word 1500		@const + 24
	.word 240000	@const + 28
	.word 480000	@const + 32
	.word 4000000	@const + 36
	.word 0xffff	@const + 40
.global drawJuliaSet

X_loop_finish:
	ldmfd	sp!, {r4-r11,lr}
	mov pc, lr
Y_loop_finish:
	add r6, #1
	b X_loop

drawJuliaSet:
	stmfd sp!, {r4-r11, lr}
	add lr, r0, pc	/*------ Must reserve ------*/
	
	mov r4, r0 @ r4 = cY
	mov r5, r1 @ r5 = frame
	mov r6, #0 @ default x = 0
	
X_loop:
	cmp r6, #640
	bge X_loop_finish
	movlt r8, #0 @ default y = 0
								/*------ Conditional Execution 1 ------*/

Y_loop:
	cmp r8, #480
	bge Y_loop_finish
/*---------------------------------------
			zx = (1500*x - 480000) / 320
			zy = (1000*y - 240000) / 240
			i = 255
---------------------------------------*/

@----- zx = (1500*x - 480000) / 320 -----
	ldr r0, .const+24   @ r0 = 1500
	ldr r1, .const+32   @ r1 = 480000
	rsb r1, r1, #0	    @ r1 = -480000
	mla r0, r0, r6, r1  @ r0 = 1500 * x - 480000 
	ldr r1, .const+12	@ r1 = 320
	bl __aeabi_idiv
	mov r7, r0	
@----------------------------------------

@----- zy = (1000*y - 240000) / 240 -----
	ldr r0, .const+20   @ r0 = 1000
	ldr r1, .const+28   @ r1 = 240000
	rsb r1, r1, #0	    @ r1 = -240000
	mla r0, r0, r8, r1  @ r0 = 1000 * y - 240000 
	ldr r1, .const+4 	@ r1 = 240
	bl __aeabi_idiv
	mov r9, r0			
@----------------------------------------
	
@-----           i = 255            ----
	ldr r11, .const+8
@---------------------------------------

Whlie_loop:		@ zx * zx + zy * zy < 4000000 && i > 0
	mul r0, r7, r7
	mul r1, r9, r9
	add r0, r0, r1
	ldr r1, .const+36
	cmp r0, r1
	bge While_loop_finish
	cmp r11, #0
	ble While_loop_finish
	
/*--------------------------------------
			tmp = (zx * zx - zy * zy)/1000-700	
			zy = (zx * zy)/500 + cY
			zx = tmp;
            i--;
--------------------------------------*/

@----- tmp = (zx * zx - zy * zy)/1000-700 -----
	mulgt r10, r7, r7 /*------ Conditional Execution 2 ------*/
	mul r0, r9, r9
	sub r10, r10, r0
	mov r0, r10
	ldr r1, .const + 20
	bl __aeabi_idiv
	mov r10, r0	
	mov r0, #700
	sub r10, r10, r0
@----------------------------------------------

@----- zy = (zx * zy)/500 + cY -----	
		mul r9, r7, r9
		mov r0, r9
		mov r1, #500
		bl __aeabi_idiv
		mov r9, r0
		add r9, r0, r4
@-----------------------------------


@----- 	zx = tmp;, i--; -----	
	mov r7, r10
	sub r11, #1
	b	Whlie_loop
@----------------------------

While_loop_finish:
/*--------------------------------------
			color = ((i&0xff)<<8) | (i&0xff);
			color = (~color)&0xffff;			
			frame[y][x] = color;	
			   [480][640] -> { [640], [640], .... }
short(2byte) site = 640*2*y + 2x
--------------------------------------*/	
	and r11, r11, #0xff				/*------ Operand2 1 ------*/
	mov r0, #8
	orr r11, r11, r11, lsl r0		/*------ Operand2 2 ------*/
	ldr r0, .const+40
	bic r11, r0, r11
	
	mov r0, #1280	@ r0 = 1280
	mul r0, r0, r8	@ r0 = 1280y	
									/*------ Operand2 3 ------*/
	mov r1, #0		@ r1 = 2
	add r1, r6, r6, lsr #0  @ r1 = 2x 
									/*------ Operand2 4 ------*/
	add r0, r0, r1	@ r0 = 1280y+2x
	add r0, r0, r5 	@ r0 = 1280y+2x + frame
	
	strh r11, [r0]
@---------------------------------------
	add r8, #1
	b Y_loop
	