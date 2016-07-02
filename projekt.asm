%include 'io.inc'
%include 'gfx.inc'
%include 'util.inc'

%define WIDTH  1024
%define HEIGHT 768

%define BATNR 	30
%define SHOOTABLE 	62
%define HATAR 60
%define BOSSBULLET 30

global main

section .text

activate_bossbullet:
	push 	ecx
	push 	esi
	push 	ebx
	mov 	ecx, BOSSBULLET
	dec 	ecx
	xor 	esi, esi
	.active:
		cmp 	dword [bossbullets_active+esi], 0
		jne  	.tovab
		mov  	dword [bossbullets_active+esi], 1
		mov 	ebx, [boss_x]
		add 	ebx, 70
		mov 	dword [bossbullets_x+esi], ebx
		mov 	ebx, [boss_y]
		add 	ebx, 50
		mov 	dword [bossbullets_y+esi], ebx
		mov 	dword [bossbullets_state+esi], 0
		jmp 	.veg
		.tovab:
		add 	esi, 4
	loop 	.active
	.veg:
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret

draw_bossbullet:
	push 	ebx
	push 	ecx
	mov 	ecx, ebx
	mov 	dword [iadd], 0
		cmp 	dword [bossbullet_state], 1
		jge 	.elso
		mov 	ebx, bullet0
		call 	draw_image
		inc 	dword [bossbullets_state+ecx]
		jmp 	.vege
	.elso:
		cmp 	dword [bossbullet_state], 2
		jge 	.masodik
		mov 	ebx, bullet1
		call 	draw_image
		inc 	dword [bossbullets_state+ecx]
		jmp 	.vege
	.masodik:
		cmp 	dword [bossbullet_state], 3
		jge 	.harmadik
		mov 	ebx, bullet2
		call 	draw_image
		inc 	dword [bossbullets_state+ecx]
		jmp 	.vege
	.harmadik:
		cmp 	dword [bossbullet_state], 1
		jge 	.negyedik
		mov 	ebx, bullet3
		call 	draw_image
		inc 	dword [bossbullets_state+ecx]
		jmp 	.vege
	.negyedik:
		mov 	ebx, bullet4
		call 	draw_image
		mov 	dword [bossbullets_state+ecx], 0
	.vege:
	pop 	ecx
	pop 	ebx
	ret
	
draw_bossbullets:
	push 	ecx
	push 	esi
	push 	ebx
	mov 	ecx, BOSSBULLET
	dec 	ecx
	xor 	esi, esi
	.shoot:
		cmp 	dword [bossbullets_active+esi], 1
		jne 	.nem 
		mov 	ebx, [bossbullets_x+esi]
		mov 	[x], ebx
		mov 	ebx, [bossbullets_y+esi]
		mov 	[y], ebx
		mov 	ebx, [bossbullets_state+esi]
		mov 	[bossbullet_state], ebx
		mov 	ebx, esi
		call 	draw_bossbullet
		
		sub 	dword [bossbullets_x+esi], 4
		cmp 	dword [bossbullets_x+esi], -4
		jge 	.nem
		mov 	dword [bossbullets_active+esi], 0
		mov 	dword [bossbullets_x+esi], 0
		mov 	dword [bossbullets_y+esi], 0
		.nem:
		add 	esi, 4
	loop 	.shoot
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret



draw_losemenu:
push 	eax
	push 	ebx
	push 	edx
	push 	esi
	mov 	dword [x], 0
	mov 	dword [y], 0
	mov 	ebx, lose
	call 	draw_image
	
	mov 	esi, eax
	call 	gfx_getmouse
	cmp 	eax, 450 
	jle 	.nems
	cmp 	eax, 630
	jge 	.nems
	cmp 	ebx, 300
	jle 	.nems
	cmp 	ebx, 330
	jge 	.nems
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, backc
	mov 	eax, esi
	call 	draw_image
	call 	gfx_getevent
	cmp 	eax, 1
	jne 	.kovs
	mov 	dword [winstate], 0
	call 	initialize_variables
	jmp 	.kovs
	.nems:
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, back
	mov 	eax, esi
	call 	draw_image
	.kovs:
	mov 	eax, esi
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	eax
	ret


draw_winmenu:
push 	eax
	push 	ebx
	push 	edx
	push 	esi
	mov 	dword [x], 0
	mov 	dword [y], 0
	mov 	ebx, win
	call 	draw_image
	
	mov 	esi, eax
	call 	gfx_getmouse
	cmp 	eax, 450 
	jle 	.nems
	cmp 	eax, 630
	jge 	.nems
	cmp 	ebx, 300
	jle 	.nems
	cmp 	ebx, 330
	jge 	.nems
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, backc
	mov 	eax, esi
	call 	draw_image
	call 	gfx_getevent
	cmp 	eax, 1
	jne 	.kovs
	mov 	dword [winstate], 0
	call 	initialize_variables
	jmp 	.kovs
	.nems:
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, back
	mov 	eax, esi
	call 	draw_image
	.kovs:
	mov 	eax, esi
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	eax
	ret

collision_character:
	push 	ebx
	push 	esi
	push 	ecx
	mov 	ecx, BOSSBULLET
	dec 	ecx
	xor 	esi, esi
	
	.ellenoriz:
	cmp 	ecx, 0
	jle 	.vege
	mov 	ebx, [char_x]
	add 	ebx, 60  
	cmp 	[bossbullets_x+esi], ebx
	jge 	.nem 	
	mov 	ebx, [char_x]
	sub 	ebx, 80
	cmp 	[bossbullets_x+esi], ebx
	jle 	.nem 	
	mov 	ebx, [char_y]
	add 	ebx, 60
	cmp 	[bossbullets_y+esi], ebx
	jge 	.nem
	mov 	ebx, [char_y]
	sub 	ebx, 40
	cmp 	[bossbullets_y+esi], ebx
	jle 	.nem
	cmp 	dword [bossbullets_active+esi], 0
	je 		.nem
	
	sub 	dword [char_health], 10
	cmp 	dword [char_health], 0
	jge 	.el
	mov 	dword [losestate], 1
	jmp 	.nem
	.el:
	mov 	ebx, [char_x]
	mov 	[x], ebx
	mov 	ebx, [char_y]
	mov 	[y], ebx
	call 	activate_explosion
	mov 	dword [bossbullets_active+esi], 0
	.nem:
	add 	esi, 4
	dec 	ecx
	jmp 	.ellenoriz
	.vege:
	pop 	ecx
	pop 	esi
	pop 	ebx
	ret	
	
	
	
collision_boss:
	push 	ebx
	push 	esi
	push 	ecx
	mov 	ecx, SHOOTABLE
	dec 	ecx
	xor 	esi, esi
	.ellenoriz:
	cmp 	ecx, 0
	jle 	.vege
	mov 	ebx, [boss_x]
	add 	ebx, 200  ; tul szeles a boss
	cmp 	[bullets_x+esi], ebx
	jle 	.nem 	
	mov 	ebx, [boss_y]
	cmp 	[bullets_y+esi], ebx
	jle 	.nem
	add 	ebx, 300
	cmp 	[bullets_y+esi], ebx
	jge 	.nem
	cmp 	dword [bullets_active+esi], 0
	je 		.nem
	sub 	dword [boss_health], 10
	cmp 	dword [boss_health], 0
	jge 	.el
	mov 	dword [winstate], 1
	jmp 	.nem
	.el:
	mov 	ebx, [bullets_x+esi]
	add 	ebx, 20
	mov 	[x], ebx
	mov 	ebx, [bullets_y+esi]
	mov 	[y], ebx
	call 	activate_explosion
	mov 	dword [bullets_active+esi], 0
	.nem:
	add 	esi, 4
	dec 	ecx
	jmp 	.ellenoriz
	.vege:
	pop 	ecx
	pop 	esi
	pop 	ebx
	ret
draw_boss:
	push ebx
	mov 	dword [iadd], 0
	mov 	ebx, [boss_x]
	mov 	[x], ebx
	mov 	ebx, [boss_y]
	mov 	[y], ebx
		cmp 	dword [boss_state], 1
		jge 	.elso
		mov 	ebx, boss0
		call 	draw_image
		inc 	dword [boss_state]
		jmp 	.vege
	.elso:
		cmp 	dword [boss_state], 2
		jge 	.masodik
		mov 	ebx, boss1
		call 	draw_image
		inc 	dword [boss_state]
		jmp 	.vege
	.masodik:
		cmp 	dword [boss_state], 3
		jge		.harmadik
		mov 	ebx, boss2
		call 	draw_image
		inc 	dword [boss_state]
		jmp 	.vege
	.harmadik:
		cmp 	dword [boss_state], 4
		jge		.negyedik
		mov 	ebx, boss3
		call 	draw_image
		inc 	dword [boss_state]
		jmp 	.vege
	.negyedik:
		cmp 	dword [boss_state], 5
		jge		.otodik
		mov 	ebx, boss4
		call 	draw_image
		inc 	dword [boss_state]
		jmp 	.vege
	.otodik:
		cmp 	dword [boss_state], 6
		jge		.hatodik
		mov 	ebx, boss5
		call 	draw_image
		inc 	dword [boss_state]
		jmp 	.vege
	.hatodik: 	
		mov 	ebx, boss6
		call 	draw_image
		mov 	dword [boss_state], 0
	.vege:		
	mov 	dword [xmin],700
	mov 	dword [ymin],10
	mov 	ebx, 700
	add 	ebx,  [boss_health]
	mov 	[xmax], ebx
	mov 	dword [ymax],25
	call 	draw_rect
	pop 	ebx
	ret
kill_all:
	push 	ecx
	push	esi
	push 	ebx
	mov  	ecx, BATNR
	xor 	esi, esi
	.vegig:
		mov 	ebx, [batx+esi]
		mov 	[x], ebx
		mov 	ebx, [baty+esi]
		mov 	[y], ebx
		call 	activate_explosion
	add 	esi, 4
	loop 	.vegig
	mov 	dword [exploded], 1
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret
draw_pausemenu:
	push 	eax
	push 	ebx
	push 	edx
	push 	esi
	mov 	dword [x], 0
	mov 	dword [y], 0
	mov 	ebx, pausemenubac
	call 	draw_image
	
	mov 	esi, eax
	call 	gfx_getmouse
	cmp 	eax, 450 
	jle 	.nems
	cmp 	eax, 630
	jge 	.nems
	cmp 	ebx, 300
	jle 	.nems
	cmp 	ebx, 330
	jge 	.nems
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, backc
	mov 	eax, esi
	call 	draw_image
	call 	gfx_getevent
	cmp 	eax, 1
	jne 	.kovs
	mov 	dword [isstarted], 1
	mov 	dword [pausemenu], 0
	jmp 	.kovs
	.nems:
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, back
	mov 	eax, esi
	call 	draw_image
	.kovs:
	mov 	eax, esi
	
	mov 	esi, eax
	call 	gfx_getmouse
	cmp 	eax, 450 
	jle 	.neme
	cmp 	eax, 630
	jge 	.neme
	cmp 	ebx, 400
	jle 	.neme
	cmp 	ebx, 430
	jge 	.neme
	mov 	dword [x], 450
	mov 	dword [y], 400
	mov 	ebx, exit_gamec
	mov 	eax, esi
	call 	draw_image
	call 	gfx_getevent
	cmp 	eax, 1
	jne 	.kove
	call 	initialize_variables
	mov 	dword [isstarted], 0
	jmp 	.kove
	jmp 	.kove
	.neme:
	mov 	dword [x], 450
	mov 	dword [y], 400
	mov 	ebx, exit_game
	mov 	eax, esi
	call 	draw_image
	.kove:
	
	
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	eax
	ret


draw_menu:
	push 	eax
	push 	ebx
	push 	edx
	push 	esi
	mov 	dword [x], 0
	mov 	dword [y], 0
	mov 	ebx, menubackground
	call 	draw_image
	
	mov 	esi, eax
	call 	gfx_getmouse
	cmp 	eax, 450 
	jle 	.nems
	cmp 	eax, 630
	jge 	.nems
	cmp 	ebx, 300
	jle 	.nems
	cmp 	ebx, 330
	jge 	.nems
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, start_gamec
	mov 	eax, esi
	call 	draw_image
	call 	gfx_getevent
	cmp 	eax, 1
	jne 	.kovs
	mov 	dword [isstarted], 1
	jmp 	.kovs
	.nems:
	mov 	dword [x], 450
	mov 	dword [y], 300
	mov 	ebx, start_game
	mov 	eax, esi
	call 	draw_image
	.kovs:
	mov 	eax, esi
	
	mov 	esi, eax
	call 	gfx_getmouse
	cmp 	eax, 450 
	jle 	.neme
	cmp 	eax, 630
	jge 	.neme
	cmp 	ebx, 400
	jle 	.neme
	cmp 	ebx, 430
	jge 	.neme
	mov 	dword [x], 450
	mov 	dword [y], 400
	mov 	ebx, exit_gamec
	mov 	eax, esi
	call 	draw_image
	call 	gfx_getevent
	cmp 	eax, 1
	jne 	.kove
	mov 	dword [exit], 1
	jmp 	.kove
	jmp 	.kove
	.neme:
	mov 	dword [x], 450
	mov 	dword [y], 400
	mov 	ebx, exit_game
	mov 	eax, esi
	call 	draw_image
	.kove:
	
	
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	eax
ret

bat_collision:
	push 	ecx
	push 	edi
	push 	eax
	push 	ebx
	push 	edx
	push 	esi
	
	xor 	edi, edi
	mov 	ecx, BATNR
	mov 	eax, [char_x]
	mov 	ebx, [char_y]
	.megnez:
		cmp 	ecx, 0
		jl 		.end
		mov 	edx, [batx+edi]
		sub 	edx, 60  ; a karakter szelessege
		cmp 	eax, edx  ; ha bx>dx
		jle		.nem
		mov 	edx, [batx+edi]
		add 	edx, 70  ; deneverszelesseg - karakterszelesseg
		cmp 	eax, edx
		jge 	.nem	 	
		mov 	edx, [baty+edi]
		sub 	edx, 60  ; a karakter magassaga
		cmp 	ebx, edx
		jl 		.nem
		add 	edx, 180 ; a karakter es a denever magassaga
		cmp 	ebx, edx
		jge 	.nem
		sub 	dword [char_health], 10
		cmp 	dword [char_health], 0
		jg 		.megel
		mov 	dword [losestate], 1
		jmp 	.end
		.megel:
		push 	edx
		push 	esi
		push 	ecx
		mov 	ecx, [batx+edi]
		mov 	[x], ecx
		mov 	ecx, [baty+edi]
		mov 	[y], ecx
		call 	activate_explosion
		
		mov 	dword [batx+edi], 1022
		mov 	esi, 600
		call 	rand
		cdq 	
		idiv 	esi
		cmp 	edx, 0
		jg 		.ok
		neg 	edx
		.ok:
		mov  	dword [baty+edi], edx
		pop 	ecx
		pop 	esi
		pop 	edx
		.nem:	
		add 	edi, 4
		dec 	ecx
	jmp 	.megnez
	.end:
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	eax
	pop 	edi
	pop 	ecx 
	ret
draw_rect:
	push 	ecx
	push 	ebx
	push 	edx
	push 	esi
	push  	edi
	
	mov		esi, [ymin]		; ESI - line (Y)
	
	.yloop:
		cmp		esi, [ymax]
		jge		.yend	
		
		; Loop over the columns
		mov		edi, [xmin]	; EDI - column (X)
		
	.xloop:
		cmp		edi, [xmax]
		jge		.xend
		mov 	ebx, esi
		imul 	ebx, WIDTH
		add	 	ebx, edi
		imul 	ebx, 4
		mov 	[drawtmp], ebx
		xchg 	esi, [drawtmp]
		
		
		
			
		
		mov 	bl, 0
		mov		[eax+esi], bl
		mov 	bl, 0
		mov		[eax+esi+1], bl
		mov 	bl, 255
		mov		[eax+esi+2] , bl
		mov 	bl, 0
		mov		[eax+esi+3], bl
		
		xchg 	esi, [drawtmp]
		inc 	edi				;noveles x-en
		
		
		
		
		
		jmp		.xloop
	.xend:
		inc		esi
		jmp		.yloop	
	.yend:
	pop 	edi
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	ecx
	ret

bullet_collision:
	push 	ebx
	push 	edx
	push 	esi
	push 	edi
	push 	eax;temporalis hasznalat
	push 	ecx;
	xor 	esi, esi
	xor 	edi, edi
	xor 	ebx, ebx   ;bullet- szam
	xor 	edx, edx   ;denever- szam
	.bulletloop:
		cmp 	ebx, SHOOTABLE
		jg 	.bulletend
		xor 	edx, edx
		xor 	edi, edi
		.batloop:
			cmp 	edx, BATNR
			jg		.batend
			mov 	ecx, [batx+edi]
			sub 	ecx, 60  ; a golyo szelessege
			cmp 	[bullets_x+esi], ecx  ; ha bx>dx
			jle		.nem
			mov 	ecx, [batx+edi]
			add 	ecx, 90  ; deneverszelesseg- golyoszelesseg
			cmp 	[bullets_x+esi], ecx
			jge 	.nem	 	
			mov 	eax, [baty+edi]
			sub 	eax, 50  ; a golyo magassaga
			cmp 	[bullets_y+esi], eax
			jl 		.nem
			add 	eax, 180 ; a golyo es a denever magassaga
			cmp 	[bullets_y+esi], eax
			jge 	.nem
			mov 	ecx, [batx+edi]
			mov 	[x], ecx
			mov 	ecx, [baty+edi]
			mov 	[y], ecx
			call 	activate_explosion
			mov 	dword [bullets_active+esi], 0
			mov 	dword [bullets_x+esi], 0
			mov 	dword [bullets_y+esi], 0
			mov 	dword [batx+edi], 1022
			inc 	dword [shootcounter]
			push 	edx
			push 	esi
			mov 	esi, 600
			call 	rand
			cdq 	
			idiv 	esi
			cmp 	edx, 0
			jg 		.ok
			neg 	edx
			.ok:
			mov  	dword [baty+edi], edx
			pop 	esi
			pop 	edx
			.nem:
			inc 	edx
			add 	edi, 4
			jmp 	.batloop
		.batend:
		inc 	ebx
		add 	esi, 4
		jmp 	.bulletloop
	.bulletend:
	pop 	ecx
	pop 	eax
	pop 	edi
	pop 	esi
	pop 	edx
	pop 	edx
	ret
	
draw_explosions:
	push 	ecx
	push 	esi
	push 	ebx
	mov 	ecx, BATNR
	xor 	esi, esi
	.explode:
		cmp 	dword [explosions_active+esi], 1
		jne 	.nem 
		mov 	ebx, [explosions_x+esi]
		mov 	[x], ebx
		mov 	ebx, [explosions_y+esi]
		mov 	[y], ebx
		mov 	ebx, [explosions_state+esi]
		mov 	[explosion_state], ebx
		mov 	ebx, esi
		call 	draw_explosion
		
		.nem:
		add 	esi, 4
	loop 	.explode
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret
	
draw_explosion:
	push 	ebx
	push 	ecx
	mov 	ecx, ebx
	mov 	dword [iadd], 0
		cmp 	dword [explosion_state], 1
		jge 	.elso
		mov 	ebx, explosion0
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.elso:
		cmp 	dword [explosion_state], 2
		jge 	.masodik
		mov 	ebx, explosion1
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.masodik:
		cmp 	dword [explosion_state], 3
		jge 	.harmadik
		mov 	ebx, explosion2
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.harmadik:
		cmp 	dword [explosion_state], 4
		jge 	.negyedik
		mov 	ebx, explosion3
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.negyedik:
		cmp 	dword [explosion_state], 5
		jge 	.otodik
		mov 	ebx, explosion4
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.otodik:
		cmp 	dword [explosion_state], 6
		jge 	.hatodik
		mov 	ebx, explosion5
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.hatodik:
		cmp 	dword [explosion_state], 7
		jge 	.hetedik
		mov 	ebx, explosion6
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.hetedik:
		cmp 	dword [explosion_state], 8
		jge 	.nyolcadik
		mov 	ebx, explosion7
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.nyolcadik:
		cmp 	dword [explosion_state], 9
		jge 	.kilencedik
		mov 	ebx, explosion8
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.kilencedik:
		cmp 	dword [explosion_state], 10
		jge 	.tizedik
		mov 	ebx, explosion9
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.tizedik:
		cmp 	dword [explosion_state], 11
		jge 	.tizenegyedik
		mov 	ebx, explosion10
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.tizenegyedik:
		cmp 	dword [explosion_state], 12
		jge 	.tizenkettedik
		mov 	ebx, explosion11
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.tizenkettedik:
		cmp 	dword [explosion_state], 13
		jge 	.tizenharmadik
		mov 	ebx, explosion12
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.tizenharmadik:
		cmp 	dword [explosion_state], 14
		jge 	.tizennegyedik
		mov 	ebx, explosion13
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.tizennegyedik:
		cmp 	dword [explosion_state], 15
		jge 	.tizenotodik
		mov 	ebx, explosion14
		call 	draw_image
		inc 	dword [explosions_state+ecx]
		jmp 	.vege
	.tizenotodik:
		mov 	ebx, explosion15
		call 	draw_image
		mov  	dword [explosions_state+ecx], 0
		mov  	dword [explosions_active+ecx], 0
	.vege:
	pop 	ecx
	pop 	ebx
	ret
	
activate_explosion: ; In: [x] ; [y]
	push 	ecx
	push 	esi
	push 	ebx
	mov 	ecx, BATNR
	xor 	esi, esi
	.active:
		cmp 	dword [explosions_active+esi], 0
		jne  	.tovab
		mov  	dword [explosions_active+esi], 1
		mov 	ebx, [x]
		mov 	dword [explosions_x+esi], ebx
		mov 	ebx, [y]
		mov 	dword [explosions_y+esi], ebx
		mov 	dword [explosions_state+esi], 0
		jmp 	.veg
		.tovab:
		add 	esi, 4
	loop 	.active
	.veg:
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret
	
	
	
activate_bullet:
	push 	ecx
	push 	esi
	push 	ebx
	mov 	ecx, SHOOTABLE
	dec 	ecx
	xor 	esi, esi
	.active:
		cmp 	dword [bullets_active+esi], 0
		jne  	.tovab
		mov  	dword [bullets_active+esi], 1
		mov 	ebx, [char_x]
		add 	ebx, 70
		mov 	dword [bullets_x+esi], ebx
		mov 	ebx, [char_y]
		mov 	dword [bullets_y+esi], ebx
		mov 	dword [bullets_state+esi], 0
		jmp 	.veg
		.tovab:
		add 	esi, 4
	loop 	.active
	.veg:
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret

draw_bullet:
	push 	ebx
	push 	ecx
	mov 	ecx, ebx
	mov 	dword [iadd], 0
		cmp 	dword [bullet_state], 1
		jge 	.elso
		mov 	ebx, bullet0
		call 	draw_image
		inc 	dword [bullets_state+ecx]
		jmp 	.vege
	.elso:
		cmp 	dword [bullet_state], 2
		jge 	.masodik
		mov 	ebx, bullet1
		call 	draw_image
		inc 	dword [bullets_state+ecx]
		jmp 	.vege
	.masodik:
		cmp 	dword [bullet_state], 3
		jge 	.harmadik
		mov 	ebx, bullet2
		call 	draw_image
		inc 	dword [bullets_state+ecx]
		jmp 	.vege
	.harmadik:
		cmp 	dword [bullet_state], 1
		jge 	.negyedik
		mov 	ebx, bullet3
		call 	draw_image
		inc 	dword [bullets_state+ecx]
		jmp 	.vege
	.negyedik:
		mov 	ebx, bullet4
		call 	draw_image
		mov 	dword [bullets_state+ecx], 0
	.vege:
	pop 	ecx
	pop 	ebx
	ret
	
draw_bullets: 
	push 	ecx
	push 	esi
	push 	ebx
	mov 	ecx, SHOOTABLE
	dec 	ecx
	xor 	esi, esi
	.shoot:
		cmp 	dword [bullets_active+esi], 1
		jne 	.nem 
		mov 	ebx, [bullets_x+esi]
		mov 	[x], ebx
		mov 	ebx, [bullets_y+esi]
		mov 	[y], ebx
		mov 	ebx, [bullets_state+esi]
		mov 	[bullet_state], ebx
		mov 	ebx, esi
		call 	draw_bullet
		
		add 	dword [bullets_x+esi], 4
		cmp 	dword [bullets_x+esi], 963
		jle 	.nem
		mov 	dword [bullets_active+esi], 0
		mov 	dword [bullets_x+esi], 0
		mov 	dword [bullets_y+esi], 0
		.nem:
		add 	esi, 4
	loop 	.shoot
	mov 	dword [x], 1019
	mov 	dword [y], 784
	mov 	ebx, [bullets_state+esi]
	mov 	[bullet_state], ebx
	mov 	ebx, esi
	call 	draw_bullet
	pop 	ebx
	pop 	esi
	pop 	ecx
	ret
	
draw_character:
	mov 	dword [iadd], 0
	mov 	ebx, [char_x]
	mov 	[x], ebx
	mov 	ebx, [char_y]
	mov 	[y], ebx
		cmp 	dword [char_state], 1
		jge 	.elso
		mov 	ebx, goku0
		call 	draw_image
		inc 	dword [char_state]
		jmp 	.vege
	.elso:
		cmp 	dword [char_state], 2
		jge 	.masodik
		mov 	ebx, goku1
		call 	draw_image
		inc 	dword [char_state]
		jmp 	.vege
	.masodik:
		cmp 	dword [char_state], 3
		jge		.harmadik
		mov 	ebx, goku2
		call 	draw_image
		inc 	dword [char_state]
		jmp 	.vege
	.harmadik:
		mov 	ebx, goku3
		call 	draw_image
		mov 	dword [char_state], 0
	.vege:		
	ret
draw_character_shooting:
	mov 	dword [iadd], 0
	mov 	ebx, [char_x]
	mov 	[x], ebx
	mov 	ebx, [char_y]
	mov 	[y], ebx
	
		cmp 	dword [char_shoot_state], 1
		jge 	.elso
		mov 	ebx, gokushoot0
		call 	draw_image
		inc 	dword [char_shoot_state]
		jmp 	.vege
	.elso:
		cmp 	dword [char_shoot_state], 2
		jge 	.masodik
		mov 	ebx, gokushoot1
		call 	draw_image
		inc 	dword [char_shoot_state]
		jmp 	.vege
	.masodik:
		cmp 	dword [char_shoot_state], 3
		jge		.harmadik
		mov 	ebx, gokushoot2
		call 	draw_image
		inc 	dword [char_shoot_state]
		jmp 	.vege
	.harmadik:
		cmp 	dword [char_shoot_state], 4
		jge		.negyedik
		mov 	ebx, gokushoot3
		call 	draw_image
		inc 	dword [char_shoot_state]
		jmp 	.vege
	.negyedik:
		cmp 	dword [char_shoot_state], 5
		jge		.otodik
		mov 	ebx, gokushoot4
		call 	draw_image
		inc 	dword [char_shoot_state]
		jmp 	.vege
	.otodik:
		mov 	ebx, gokushoot5
		call 	draw_image
		mov  	dword [char_shoot_state], 0
		mov 	dword [char_isshooting], 0
	.vege:		
	ret	
	
draw_bats:
	push 	ecx
	push 	edx
	mov 	ecx, BATNR
    xor 	edx, edx
	.rajzbat:
	mov 	ebx, [batx+edx]
	mov 	[x], ebx
	mov 	ebx, [baty+edx]
	mov 	[y], ebx
	call	draw_bat
	
	dec 	dword [batx+edx]
	dec 	dword [batx+edx]
	dec 	dword [batx+edx]
	cmp 	dword [batx+edx], -148
	jg 		.tov
	mov 	dword [batx+edx], 876
	.tov:
	
	add 	edx, 4
	loop 	.rajzbat
	pop 	edx
	pop 	ecx
	ret
draw_backgrounds:
	push	ebx 	
	cmp 	dword [shootcounter], HATAR
	jle 	.nemvillog
	mov 	ebx, [villogas]
	mov 	[iadd], ebx
	inc  	dword [villogas]
	cmp 	dword [villogas], 3
	jl 		.nemvillog
	mov 	dword [villogas], 0
	.nemvillog:
	mov 	ebx, [backx1]
	mov 	dword [x], ebx
	mov 	dword [y], 0
	mov 	ebx, background1
	call 	draw_image
	dec 	dword [backx1]
	cmp 	dword [backx1], -1023
	jg 		.jolvan1
	mov 	dword [backx1], -1
	.jolvan1:
	mov 	dword [iadd],0
	mov 	ebx, [backx2]
	mov 	dword [x], ebx
	mov 	dword [y], 346
	mov 	ebx, background2
	call 	draw_image
	dec 	dword [backx2]
	dec 	dword [backx2]
	cmp 	dword [backx2], -1023
	jg 		.jolvan2
	mov 	dword [backx2], -1
	.jolvan2:
	mov 	ebx, [backx3]
	mov 	dword [x], ebx
	mov 	dword [y], 460
	mov 	ebx, background3
	call 	draw_image
	dec 	dword [backx3]
	dec 	dword [backx3]
	dec 	dword [backx3]
	cmp 	dword [backx3], -1023
	jg 		.jolvan3
	mov 	dword [backx3], -1
	.jolvan3:
	pop 	ebx
	ret
draw_bat:	
	push 	ebx
		mov 	dword [iadd], 150
		cmp 	dword [batstate+edx], 1
		jge 	.elso
		mov 	ebx, denever0
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.elso:
		cmp 	dword [batstate+edx], 2
		jge 	.masodik
		mov 	ebx, denever1
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.masodik:
		cmp 	dword [batstate+edx], 3
		jge		.harmadik
		mov 	ebx, denever2
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.harmadik:
		cmp 	dword [batstate+edx], 4
		jge		.negyedik
		mov 	ebx, denever3
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.negyedik:
		cmp 	dword [batstate+edx], 5
		jge		.otodik
		mov 	ebx, denever4
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.otodik:
		cmp 	dword [batstate+edx], 6
		jge		.hatodik
		mov 	ebx, denever5
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.hatodik:	
		cmp 	dword [batstate+edx], 7
		jge		.hetedik
		mov 	ebx, denever6
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.hetedik:
		cmp 	dword [batstate+edx], 8
		jge		.nyolcadik
		mov 	ebx, denever7
		call 	draw_image
		inc 	dword [batstate+edx]
		jmp 	.vege
	.nyolcadik:
		mov 	ebx, denever8
		call 	draw_image
		mov 	dword [batstate+edx], 0
	.vege:	
	mov 	dword [iadd], 0
	pop 	ebx
	ret
draw_image:  ; eax =  framebuffer ; ebx = data ; [x] = x; [y] = y; [iadd] = eltolas
	push 	ecx
	push 	ebx
	push 	edx
	push 	esi
	push  	edi
	
	mov 	dword [imgy], 0
	

	mov 	edx, ebx
	
	mov 	ebx, [edx+18]
	mov 	[imgw], ebx
	mov 	ebx, [edx+22]
	mov 	[imgh], ebx
	
	mov 	dword [imgx], 0
	mov 	ebx, [edx+10]
	mov 	dword [pointer], ebx
	mov 	ecx, [pointer]
	mov		esi, [y]		; ESI - line (Y)
	cmp 	esi, 0
	jge 	.yloop
	neg 	esi
	mov 	[imgy],esi
	
	xor 	esi, esi
	
	.yloop:
		cmp		esi, HEIGHT
		jge		.yend	
		
		; Loop over the columns
		mov		edi, [x]	; EDI - column (X)
		inc 	edi
		cmp 	edi, 0
		jge 	.xloop
		neg		edi
		mov 	[imgx], edi
		xchg 	[imgx], eax
		xchg 	[imgx], eax
		xor 	edi, edi
	.xloop:
		cmp		edi, WIDTH
		jge		.xend
		mov 	ebx, esi
		imul 	ebx, WIDTH
		add	 	ebx, edi
		imul 	ebx, 4
		mov 	[drawtmp], ebx
		xchg 	esi, [drawtmp]
		mov 	ecx, [imgy]
		mov 	ebx, [imgw]
		imul 	ecx, ebx
		add 	ecx, [imgx]
		
		imul 	ecx, 3
		add 	ecx, [pointer]
		add 	ecx, [iadd]
		
		mov 	bl, byte [edx+ecx]
		cmp 	bl, 0
		je 		.tov1
		mov		[eax+esi], bl
		
		.tov1:
		mov 	bl,  byte [edx+ecx+1]
		cmp 	bl, 0
		je 		.tov2
		mov		[eax+esi+1], bl
		
		.tov2:
		mov 	bl, byte [edx+ecx+2]
		cmp 	bl, 0
		je 		.tov3
		mov		[eax+esi+2], bl
		.tov3:
		mov 	bl, byte [edx+ecx+3]
		cmp 	bl ,0
		je 		.tov4
		mov		[eax+esi+3], bl
		.tov4:
		xchg 	esi, [drawtmp]	
		inc 	dword [imgx]
		inc 	edi				;noveles x-en
		
		mov 	ebx, [imgw]
		cmp 	dword [imgx], ebx 	;kiment-e x en
		jl 		.mehety
		
		mov 	dword [imgx], 0
		mov 	edi,[x]
		
		inc 	dword [imgy]
		inc 	esi
		.mehety:
		mov 	ebx, [imgh] 	;kiment-e y-on
		cmp 	dword [imgy], ebx
		jg 		.yend
		cmp 	esi, HEIGHT
		jg 		.yend
		
		mov 	ebx, [x] 	;kiment-e x en a kepernyorol
		add 	ebx, [imgx]
		cmp 	ebx, WIDTH
		jle 	.tovabb1
		inc 	dword [imgy]
		
		mov 	dword [imgx],0 
		inc 	esi
		mov 	edi, [x]
		.tovabb1:
		mov 	ebx, [imgh]
		add 	ebx, [y]
		cmp 	esi, HEIGHT
		jge 		.yend	
		
		
		jmp		.xloop
	.xend:
		;inc		esi
		jmp		.yloop	
	.yend:
	pop 	edi
	pop 	esi
	pop 	edx
	pop 	ebx
	pop 	ecx
	ret
initialize_variables:
	;----------------------------denever pozicioinicializalas-------------------
	mov 	ecx, BATNR
	mov 	ebx, 430  ; max x
	add 	ebx, 600
	mov 	edi, 600  ; max y
	mov 	esi, 0	
	.rand:
		call 	rand
		cdq 	
		idiv 	ebx
		cmp 	edx, 0
		jg 		.oky
		neg 	edx
		.oky:
		mov 	dword [baty+esi], edx
		call 	rand
		cdq 	
		idiv 	edi
		cmp 	edx, 0
		jg 		.ok
		neg 	edx
		.ok:
		mov 	dword [batx+esi], 400
		add 	dword [batx+esi], edx
		
		call 	rand 
		mov 	ebx, 8
		cdq 
		idiv 	ebx
		cmp 	edx, 0
		jg 		.oks
		neg 	edx
		.oks:
		mov 	ebx, 600
		mov 	dword [batstate+esi], edx
		add 	esi, 4
	loop	.rand
	;----------------------------bullet pozicioinicializalas-------------------
	mov 	ecx, SHOOTABLE
	dec 	ecx
	xor 	esi, esi
	.aktivitas:
	mov 	dword [bullets_active+esi], 0
	add 	esi, 4
	loop 	.aktivitas
	mov 	dword [bullets_active+esi], 1
	
	
	mov 	ecx, BOSSBULLET
	dec 	ecx
	xor 	esi, esi
	.baktivitas:
	mov 	dword [bossbullets_active+esi], 0
	add 	esi, 4
	loop 	.baktivitas
	
	
	
	xor 	ebx, ebx
	;-------------------------explosion beallitas------------------------
	mov 	ecx, BATNR
	mov 	esi, 0	
	.beall:
		mov 	dword [explosions_active+esi], 0
		mov 	dword [explosions_state+esi], 0
		add 	esi, 4
	loop	.beall
	
	
	
	
	xor		esi, esi		; deltax (used for moving the image)
	xor		edi, edi		; deltay (used for moving the image)
	mov 	dword [isstarted], 0
	mov 	dword [exit], 0
	mov 	dword [pausemenu], 0
	mov 	dword [char_health], 300
	mov 	dword [char_x], 100
	mov 	dword [char_y], 100
	mov 	dword [shootcounter], 0
	mov 	dword [exploded], 0
	mov 	dword [boss_x], 424
	mov 	dword [boss_y], 100
	mov 	dword [boss_state], 0
	mov 	dword [boss_health], 300
	mov 	dword [winstate], 0
	mov 	dword [losestate], 0
ret	
	
main:
	; Create the graphics window
    mov		eax, WIDTH		; window width (X)
	mov		ebx, HEIGHT		; window hieght (Y)
	mov		ecx, 0			; window mode (NOT fullscreen!)
	mov		edx, caption	; window caption
	call	gfx_init
	
	test	eax, eax		; if the return value is 0, something went wrong
	jnz		.init
	; Print error message and exit
	mov		eax, errormsg
	call	io_writestr
	call	io_writeln
	ret
	
	
.init:
	mov		eax, infomsg	; print some usage info
	call	io_writestr
	call	io_writeln
	
	;------------------------kepek betoltese---------------------
	mov 	eax, deneverstr0
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever0
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever1
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever2
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever3
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr4
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever4
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr5
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever5
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr6
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever6
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr7
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever7
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, deneverstr8
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, denever8
	mov 	ecx, 68300
	call 	fio_read
	call 	fio_close
	
	mov 	eax, backgroundstr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, background1
	mov 	ecx, 2400000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, backgroundstr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, background2
	mov 	ecx, 1300000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, backgroundstr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, background3
	mov 	ecx, 1000000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokustr0
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, goku0
	mov 	ecx, 11000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokustr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, goku1
	mov 	ecx, 11000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokustr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, goku2
	mov 	ecx, 11000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokustr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, goku3
	mov 	ecx, 11000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokushootstr0
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, gokushoot0
	mov 	ecx, 9174
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokushootstr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, gokushoot1
	mov 	ecx, 20000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokushootstr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, gokushoot2
	mov 	ecx, 20000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokushootstr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, gokushoot3
	mov 	ecx, 20000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokushootstr4
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, gokushoot4
	mov 	ecx, 20000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, gokushootstr5
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, gokushoot5
	mov 	ecx, 20000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bulletstr0
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, bullet0
	mov 	ecx, 12000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bulletstr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, bullet1
	mov 	ecx, 12000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bulletstr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, bullet2
	mov 	ecx, 12000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bulletstr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, bullet3
	mov 	ecx, 12000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bulletstr4
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, bullet4
	mov 	ecx, 12000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr0
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion0
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion1
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion2
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion3
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr4
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion4
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr5
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion5
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr6
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion6
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr7
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion7
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr8
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion8
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr9
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion9
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr10
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion10
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr11
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion11
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr12
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion12
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr13
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion13
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr14
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion14
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, explosionstr15
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, explosion15
	mov 	ecx, 31000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, menubackgroundstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, menubackground
	mov 	ecx, 2400000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, pausemenubackstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, pausemenubac
	mov 	ecx, 2400000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, start_gamestr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, start_game
	mov 	ecx, 17000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, start_gamecstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, start_gamec
	mov 	ecx, 17000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, exit_gamestr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, exit_game
	mov 	ecx, 17000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, exit_gamecstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, exit_gamec
	mov 	ecx, 17000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, backstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, back
	mov 	ecx, 17000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, backcstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, backc
	mov 	ecx, 17000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr0
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss0
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr1
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss1
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr2
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss2
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr3
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss3
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr4
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss4
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr5
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss5
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, bossstr6
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, boss6
	mov 	ecx, 654000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, winstr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, win
	mov 	ecx, 2400000
	call 	fio_read
	call 	fio_close
	
	mov 	eax, losestr
	xor 	ebx, ebx
	call 	fio_open
	mov 	ebx, lose
	mov 	ecx, 2400000
	call 	fio_read
	call 	fio_close
	;----------------------------denever pozicioinicializalas-------------------
	mov 	ecx, BATNR
	mov 	ebx, 430  ; max x
	add 	ebx, 600
	mov 	edi, 600  ; max y
	mov 	esi, 0	
	.rand:
		call 	rand
		cdq 	
		idiv 	ebx
		cmp 	edx, 0
		jg 		.oky
		neg 	edx
		.oky:
		mov 	dword [baty+esi], edx
		call 	rand
		cdq 	
		idiv 	edi
		cmp 	edx, 0
		jg 		.ok
		neg 	edx
		.ok:
		mov 	dword [batx+esi], 400
		add 	dword [batx+esi], edx
		
		call 	rand 
		mov 	ebx, 8
		cdq 
		idiv 	ebx
		cmp 	edx, 0
		jg 		.oks
		neg 	edx
		.oks:
		mov 	ebx, 600
		mov 	dword [batstate+esi], edx
		add 	esi, 4
	loop	.rand
	;----------------------------bullet pozicioinicializalas-------------------
	mov 	ecx, SHOOTABLE
	dec 	ecx
	xor 	esi, esi
	.aktivitas:
	mov 	dword [bullets_active+esi], 0
	add 	esi, 4
	loop 	.aktivitas
	mov 	dword [bullets_active+esi], 1
	
	
	
	xor 	ebx, ebx
	;-------------------------exlosion beallitas------------------------
	mov 	ecx, BATNR
	mov 	esi, 0	
	.beall:
		mov 	dword [explosions_active+esi], 0
		add 	esi, 4
	loop	.beall
	
	
	xor		esi, esi		; deltax (used for moving the image)
	xor		edi, edi		; deltay (used for moving the image)
	; Main loop
.mainloop:
	; Draw something
	
	
	mov 	eax, 30
	call 	sleep
	call	gfx_map			; map the framebuffer -> EAX will contain the pointer
	cmp 	dword [losestate], 1
	jne 	.nemlose
	mov 	dword [isstarted], 0
	mov 	dword [pausemenu], 0
	call 	draw_losemenu
	jmp 	.nemjatek
	.nemlose:
	cmp 	dword [winstate], 1
	jne 	.megnem
	mov 	dword [isstarted], 0
	mov 	dword [pausemenu], 0
	call 	draw_winmenu
	jmp 	.nemjatek
	.megnem:
	cmp 	dword [isstarted], 0 
	jne 	.jatek
	call 	draw_menu
	cmp 	dword [exit], 1
	je 		.end
	jmp 	.nemjatek
	.jatek:
	cmp 	dword [pausemenu], 0
	je 		.tenyleg_jatek
	call 	draw_pausemenu
	jmp 	.nemjatek
	.tenyleg_jatek:
	call 	draw_backgrounds
	cmp 	dword [char_isshooting], 1
	jne 	.nemlo
	call 	draw_character_shooting
	jmp 	.lo
	.nemlo:
	call 	draw_character
	.lo:
	call 	draw_bullets
	
	
	mov 	dword [xmin],10
	mov 	dword [ymin],10
	mov 	ebx, 10
	add 	ebx,  [char_health]
	mov 	[xmax], ebx
	mov 	dword [ymax],25
	call 	draw_rect
	cmp 	dword [shootcounter],HATAR
	jle 	.nemboss
	;--------------------boss---------------
	cmp 	dword [exploded], 0
	jne 	.boss
	call 	kill_all
	.boss:
	call 	draw_boss
	push 	eax 
	push 	edx
	mov 	eax , [boss_y]
	mov 	ebx, 4
	cdq
	idiv 	ebx
	cmp 	edx, 1 	
	jne 	.nelojj
	call 	activate_bossbullet
	.nelojj:
	pop 	edx
	pop 	eax
	call 	draw_bossbullets
	mov 	ebx, [dyy]
	add 	dword [boss_y], ebx
	cmp 	dword [boss_y], 0
	jge 	.okfel
	mov 	ebx, [dyy]
	neg 	ebx
	mov 	[dyy], ebx
	.okfel:
	cmp 	dword [boss_y], 400
	jle 	.okle
	mov 	ebx, [dyy]
	neg 	ebx
	mov 	[dyy], ebx
	.okle:
	call 	collision_boss
	call 	collision_character
	;--------------------------------------
	jmp 	.nemjatek
	.nemboss:
	call 	draw_bats
	call 	bullet_collision
	call 	bat_collision
	.nemjatek:
	call 	draw_explosions
	call	gfx_unmap		; unmap the framebuffer
	call	gfx_draw		; draw the contents of the framebuffer (*must* be called once in each iteration!)
	
	; Query and handle the events (loop!)
	xor		ebx, ebx		; load some constants into registers: 0, -1, 1
	mov		ecx, -1
	mov		edx, 1
	
.eventloop:
	call	gfx_getevent
	
	; Handle movement: keyboard
	cmp		eax, 'w'	; w key pressed
	cmove	edi, ecx	; deltay = -1 (if equal)
	cmp		eax, -'w'	; w key released
	cmove	edi, ebx	; deltay = 0 (if equal)
	cmp		eax, 's'	; s key pressed
	cmove	edi, edx	; deltay = 1 (if equal)
	cmp		eax, -'s'	; s key released
	cmove	edi, ebx	; deltay = 0
	cmp		eax, 'a'
	cmove	esi, ecx
	cmp		eax, -'a'
	cmove	esi, ebx
	cmp		eax, 'd'
	cmove	esi, edx
	cmp		eax, -'d'
	cmove	esi, ebx
	
	mov 	ebx, 10
	cmp 	eax, ' '
	cmove 	esi, ebx
	xor 	ebx, ebx
	cmp 	eax, -' '
	cmove 	esi, ebx
	
	
	; Handle movement: mouse
	cmp		eax, 1			; left button pressed
	jne		.eventloop1
	mov		dword [movemouse], 1
	call	gfx_getmouse
	mov		[prevmousex], eax
	mov		[prevmousey], ebx
	jmp		.eventloop
.eventloop1:
	cmp		eax, -1			; left button released
	jne		.eventloop2
	mov		dword [movemouse], 0
	jmp		.eventloop
.eventloop2:

	; Handle exit
	cmp		eax, 23			; the window close button was pressed: exit
	je		.end
	cmp		eax, 27			; ESC: exit
	jne		.nempause
	cmp 	dword [isstarted], 1
	jne 	.nempause
	mov 	dword [pausemenu], 1
	.nempause:
	test	eax, eax		; 0: no more events
	jnz		.eventloop
	
	
	; Query the mouse position if the left button is pressed, and update the offset
	cmp		dword [movemouse], 0
	je		.updateoffset
	call	gfx_getmouse	; EAX - x, EBX - y
	mov		ecx, eax
	mov		edx, ebx
	sub		eax, [prevmousex]
	sub		ebx, [prevmousey]
	sub		[offsetx], eax
	sub		[offsety], ebx
	mov		[prevmousex], ecx
	mov		[prevmousey], edx
	
.updateoffset:
	add		[offsetx], esi
	add		[offsety], edi
	cmp 	esi, 10
	jne  	.tova
	cmp 	dword [char_isshooting], 0
	jne 	.veg
	mov 	dword [char_isshooting], 1
	call 	activate_bullet
	jmp		.veg
	.tova:
	cmp 	dword [char_x], 0
	jge 	.okx1
	mov 	dword [char_x], 0
	.okx1:
	cmp 	dword [char_x], 700
	jle 	.okx2
	mov 	dword [char_x], 700
	.okx2:
	mov  	ebx, esi
	shl 	ebx, 3
	add 	[char_x], ebx
	
	cmp 	dword [char_y], 0
	jge 	.oky1
	mov 	dword [char_y], 0
	.oky1:
	cmp 	dword [char_y], 708
	jle 	.oky2
	mov 	dword [char_y], 708
	.oky2:
	mov  	ebx, edi
	shl 	ebx, 3
	add 	[char_y], ebx
	.veg:
	
	jmp 	.mainloop
	
    
	; Exit
.end:
	call	gfx_destroy
    ret
    
section .bss
	;-------------------memoria a denevereknek-------------
	denever0 resb 68300
	denever1 resb 68300
	denever2 resb 68300
	denever3 resb 68300
	denever4 resb 68300
	denever5 resb 68300
	denever6 resb 68300
	denever7 resb 68300
	denever8 resb 68300
	
	background1 resb 2400000
	background2 resb 1300000
	background3 resb 1000000
	
	menubackground resb 2400000
	pausemenubac resb 2400000
	start_game resb 17000
	start_gamec resb 17000
	exit_game resb 17000
	exit_gamec resb 17000
	back resb 17000
	backc resb 17000
	win resb 2400000
	lose resb 2400000
	
	
	;-------------------memoria a jatekosnak-------------
	goku0 resb 11000
	goku1 resb 11000
	goku2 resb 11000
	goku3 resb 11000
	gokushoot0 resb 9174
	gokushoot1 resb 20000
	gokushoot2 resb 20000
	gokushoot3 resb 20000
	gokushoot4 resb 20000
	gokushoot5 resb 20000
	bullet0 resb 12000
	bullet1 resb 12000
	bullet2 resb 12000
	bullet3 resb 12000
	bullet4 resb 12000
	boss0 resb 654000 
	boss1 resb 654000  
	boss2 resb 654000 
	boss3 resb 654000 
	boss4 resb 654000 
	boss5 resb 654000 
	boss6 resb 654000 
	
	
	bullets_x resd SHOOTABLE
	bullets_y resd SHOOTABLE
	bullets_active resd SHOOTABLE
	bullets_state resd SHOOTABLE
	
	bossbullets_x resd BOSSBULLET
	bossbullets_y resd BOSSBULLET
	bossbullets_active resd BOSSBULLET
	bossbullets_state resd BOSSBULLET
	
	explosions_x resd BATNR
	explosions_y resd BATNR
	explosions_state resd BATNR
	explosions_active resd BATNR
	
	
	explosion0 resb 31000
	explosion1 resb 31000
	explosion2 resb 31000
	explosion3 resb 31000
	explosion4 resb 31000
	explosion5 resb 31000
	explosion6 resb 31000
	explosion7 resb 31000
	explosion8 resb 31000
	explosion9 resb 31000
	explosion10 resb 31000
	explosion11 resb 31000
	explosion12 resb 31000
	explosion13 resb 31000
	explosion14 resb 31000
	explosion15 resb 31000
	;-------------------denever pozicio-------------
	
	batx resd BATNR
	baty resd BATNR
	batstate resd BATNR
section .data
	;-------------------ablak-------------
    caption db "THE GAME", 0
	infomsg db "Use WASD and mouse (drag) to move the image!", 0
	errormsg db "ERROR: could not initialize graphics!", 0
	
	; These are used for moving the image
	offsetx dd 0
	offsety dd 0
	
	movemouse dd 0  ; bool (true while the left button is pressed)
	prevmousex dd 0
	prevmousey dd 0
	
	tmpecx dd 0
	tmpeax dd 0
	;--------------------------kepstringek-----------
	gokustr0 db "goku0.bmp", 0
	gokustr1 db "goku1.bmp", 0
	gokustr2 db "goku2.bmp", 0
	gokustr3 db "goku3.bmp", 0
	gokushootstr0 db "shoot0.bmp", 0
	gokushootstr1 db "shoot1.bmp", 0
	gokushootstr2 db "shoot2.bmp", 0
	gokushootstr3 db "shoot3.bmp", 0
	gokushootstr4 db "shoot4.bmp", 0
	gokushootstr5 db "shoot5.bmp", 0
	bulletstr0 db "gokubullet0.bmp",0
	bulletstr1 db "gokubullet1.bmp",0
	bulletstr2 db "gokubullet2.bmp",0
	bulletstr3 db "gokubullet3.bmp",0
	bulletstr4 db "gokubullet4.bmp",0
	
	bossstr0 db "boss0.bmp", 0
	bossstr1 db "boss1.bmp", 0
	bossstr2 db "boss2.bmp", 0
	bossstr3 db "boss3.bmp", 0
	bossstr4 db "boss4.bmp", 0
	bossstr5 db "boss5.bmp", 0
	bossstr6 db "boss6.bmp", 0
	
	szemet1 db "gdsdfds", 0000
	
	deneverstr0 db "bat0.bmp",0
	deneverstr1 db "bat1.bmp",0
	deneverstr2 db "bat2.bmp",0
	deneverstr3 db "bat3.bmp",0
	deneverstr4 db "bat4.bmp",0
	deneverstr5 db "bat5.bmp",0
	deneverstr6 db "bat6.bmp",0
	deneverstr7 db "bat7.bmp",0
	deneverstr8 db "bat8.bmp",0
	backgroundstr1 db "layer1.bmp", 0
	backgroundstr2 db "layer2.bmp", 0
	backgroundstr3 db "layer3.bmp", 0
	menubackgroundstr db "menubackground.bmp", 0
	start_gamestr db "start_game.bmp", 0
	start_gamecstr db "start_gamec.bmp", 0
	backstr db "back.bmp", 0
	backcstr db "backc.bmp", 0
	exit_gamestr db "exit_game.bmp", 0
	exit_gamecstr db "exit_gamec.bmp", 0
	pausemenubackstr db "pausemenu.bmp", 0
	winstr db "win.bmp", 0
	losestr db "lose.bmp", 0
	
	explosionstr0 db "explosion0.bmp", 0
	explosionstr1 db "explosion1.bmp", 0
	explosionstr2 db "explosion2.bmp", 0
	explosionstr3 db "explosion3.bmp", 0
	explosionstr4 db "explosion4.bmp", 0
	explosionstr5 db "explosion5.bmp", 0
	explosionstr6 db "explosion6.bmp", 0
	explosionstr7 db "explosion7.bmp", 0
	explosionstr8 db "explosion8.bmp", 0
	explosionstr9 db "explosion9.bmp", 0
	explosionstr10 db "explosion10.bmp", 0
	explosionstr11 db "explosion11.bmp", 0
	explosionstr12 db "explosion12.bmp", 0
	explosionstr13 db "explosion13.bmp", 0
	explosionstr14 db "explosion14.bmp", 0
	szemet db "0000" , 0
	explosionstr15 db "explosion15.bmp", 0
	
	;-------------------kep es hatterkezeles-------------
	backx1 dd 0
	backx2 dd 0
	backx3 dd 0
	
	
	kep_test_handler dd 0
	kep_offset dd 54
	
	
	
	bat_state dd 0
	
	
	
	draw dd 0
	x dd 4 
	y dd 4
	drawindex dd 0
	drawtmp dd 0
	imgx dd 0
	imgy dd 0
	pointer dd 0
	imgw dd 0 
	imgh dd 0
	iadd dd 0
	
	xmin dd 0
	xmax dd 0
	ymin dd 0
	ymax dd 0
	villogas dd 0
	dyy dd 5 
	;------------boss es jatekfazis info-------------
	boss_state dd 0
	boss_x dd 424
	boss_y dd 100
	boss_health dd 300
	bossbullet_state dd 0
	
	exploded dd 0
	explosion_state dd 0
	isstarted dd 0
	pausemenu dd 0
	exit dd 0
	shootcounter dd 0
	winstate dd 0
	losestate dd 0
	;-----------------karakterinformaciok-------------
	char_state dd 0
	char_shoot_state dd 0
	char_isshooting dd 0
	char_health dd 300
	char_x dd 100
	char_y dd 100
	bullet_state dd 0
	