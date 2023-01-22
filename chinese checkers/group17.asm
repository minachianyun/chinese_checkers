;���ѵ{��
INCLUDE Irvine32.inc

;ø�X�ѽL
print PROTO 

;�ѽL�y�лP�p�µ��y���ഫ
Transfer PROTO,
	X1:sbyte,
	Y1:sbyte
	
;�P�_��J���y�ЬO�_�b�ѽL��
Boundary PROTO,
	x:sbyte,y:sbyte
	
;�P�_���L���a�ӧQ
Iswin PROTO

;�P�_��J����m�O�_���Ѥl
IsChess PROTO,
	boolx:sbyte,booly:sbyte

;��ܴѤl
Choose PROTO

;���ʴ��
movecursor PROTO

;���ʴѤl
movechess PROTO

;�Ѥl�y�е��c(�a���t���y��)
COOR STRUCT 
	X sbyte 0
	Y sbyte 0
COOR ENDS

.data
;15���ŴѦ�m
B COOR <-4, 8>, <-4, 7>, <-3, 7>, <-4, 6>, <-3, 6>, <-2, 6>, <-4, 5>, <-3, 5>, <-2, 5>, <-1, 5>, <-4, 4>, <-3, 4>, <-2, 4>, <-1, 4>, < 0, 4> 
;15�������Ѧ�m
M COOR <-4, 0>, <-4,-1>, <-3,-1>, <-4,-2>, <-3,-2>, <-2,-2>, <-4,-3>, <-3,-3>, <-2,-3>, <-1,-3>, <-4,-4>, <-3,-4>, <-2,-4>, <-1,-4>, < 0,-4>
;15���@�شѦ�m
Br COOR < 4, 0>, < 4,-1>, < 5,-1>, < 4,-2>, < 5,-2>, < 6,-2>, < 4,-3>, < 5,-3>, < 6,-3>, < 7,-3>, < 4,-4>, < 5,-4>, < 6,-4>, < 7,-4>, < 8,-4>

;��Ĺ��15���ŴѦ�m
;B COOR <4, -8>, <4, -7>, <3, -7>, <4, -6>, <3, -6>, <2, -6>, <4, -5>, <2, -3>, <2, -5>, <1, -5>, <4, -4>, <3, -4>, <2, -4>, <1, -4>, < 0, -4> 
;��Ĺ��15�������Ѧ�m
;M COOR <4, 0>, <4,1>, <4,2>, <4,3>, <4,4>, <3,0>, <3,2>, <3,3>, <3,4>, <2,2>, <2,3>, <2,4>, <1,3>, <1,4>, < 0,4>
;��Ĺ��15���@�شѦ�m
;Br COOR <-4, 0>, <-4,1>, <-4,2>, <-4,3>, <-4,4>, <-3,1>, <-5,2>, <-5,3>, <-5,4>, <-6,2>, <-6,3>, <-6,4>, <-7,3>, <-7,4>, <-8,4>

;�ѽL�˦�
dot byte "o"

;��Ц�m
cursor COOR < 0, 0>

;�����v
control byte 1

;�C�����A
chos   byte "choose",0
unchos byte "unlock",0
En     byte "end",0
bluewin		byte "The winner is blue!!!",0
magentawin	byte "The winner is magenta!!!",0
brownwin	byte "The winner is yellow!!!",0
jumporstop  byte "Choose another position to arrive, or press Enter again to stop the chess here. ",0
havechess	byte "This position has a chess. ",0
cantjump    byte "You can't jump to the position",0
chooseyourschess byte "You Can't choose other's chess or choose Nothing. Please choose your own chess! ",0

introduction byte "Sternhalma(Chinese checkers)",0
introduction2 byte "is a strategy board game of German origin that can be played by two, three, four, or six people,",0
introduction3 byte "playing individually or with partners. The game is a modern and simplified variation of the game Halma.",0
way_to_play byte "use 'up' 'down' 'left',and 'right' to control, 'enter' to select. ",0

.code
main PROC
		
		INVOKE print							;�L�X��l�ѽL

	gameconti:
		
		INVOKE Iswin							;�P�_���L���a�ӧQ
		cmp  ax,1								
		jz somebodywin							;�����a�ӧQ
		INVOKE Choose 							;��ܴѤl
		mov  edx, OFFSET chos					
		call WriteString						;��X"choose"���A
		INVOKE movechess						;���ʴѤl
		cmp  ax, 0
		jz   unchoose							;���s��ܴѤl
		INVOKE print							;ø�X�ѽL
		mov  edx, OFFSET En						
		call WriteString						;��X"end"���A
		
		add control, 1							;control = (control + 1) % 3 + 1
		cmp control, 3
		jng gameconti
		add control, -3
		mov al,control
		jmp gameconti							;�C���~��

	unchoose:									;���s��ܴѤl
		INVOKE print							;ø�X�ѽL
		mov  edx, OFFSET unchos					
		call WriteString						;��X"unlock"���A
		jmp  gameconti
				
	somebodywin:								;�����a�ӧQ
		cmp  bx,1
		jz   wblue
		cmp  bx,2
		jz   wmagenta
		cmp  bx,3
		jz   wbrown
		
	wblue:										;�ŴѳӧQ
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET bluewin					;�L�X"The winner is blue!!!"���A
		call WriteString
		jmp  endgame
		
	wmagenta:										;�����ѳӧQ
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET magentawin				;�L�X"The winner is magenta!!!"���A
		call WriteString
		jmp  endgame

	wbrown:									;�@�شѳӧQ
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET brownwin				;�L�X"The winner is brown!!!"���A
		call WriteString
		jmp  endgame
		
	endgame:									;�C������
		call readchar
		exit
		
main ENDP
;----------------------------------------------print----------------------------------------------
print PROC
		
		call clrscr								;�M�ſù�
		
		push eax								;�N�|�Ψ쪺�Ȧs�����e��J���|
		push ebx
		push ecx
		push esi
		
	;---ø�s�j�ѽL���I---
	;���h�j�� -8 <= i,j <= 8
	;�z�L Boundary �H�γz�L Transfer �ഫ�Aø�X�ѽL�W���I�X�ѽL�W���I
		mov  ecx, 17
	printintro:
		
		mov  al , 15
		call SetTextColor
		mov  dh , 1
		mov  dl , 0
		call Gotoxy
		mov  edx, OFFSET introduction
		call WriteString
		mov  dh , 2
		mov  dl , 0
		call Gotoxy
		mov  edx, OFFSET introduction2
		call WriteString
		mov  dh , 3
		mov  dl , 0
		call Gotoxy
		mov  edx, OFFSET introduction3
		call WriteString
		mov  al , 3
		call SetTextColor
		mov  dh , 27
		mov  dl , 0
		call Gotoxy
		mov edx, OFFSET way_to_play
		call WriteString
	outter:
		mov   bh , cl
		sub   bh , 9
		
		push  ecx
			
		mov   ecx, 17
	inner:
		mov   bl , cl
		sub   bl , 9
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   outofbound							;�I�X�� --> ���L�X
		
		INVOKE Transfer, bh, bl
		call Gotoxy								;��Ц�m�w�g�� Transfer ��n�A�é�J�A���Ȧs�� (dl,dh)
		mov  eax, white + ( black*16 )			;�]�w�e�����զ�A�I�����¦�
		call SetTextColor
		
		mov  al , dot
		call Writechar							;�L�X�I�I

	outofbound:
		
		loop inner
		
		pop ecx
		
		loop outter
		
	;---�j�ѽL���I---
	;���ӯx�}�����e�A�z�L Transfer �ഫ��ø�X
		mov  ecx, 15
		mov  esi, OFFSET B
	
	printblue:
		mov  bh , (COOR PTR [esi]).X
		mov  bl , (COOR PTR [esi]).Y
		INVOKE Transfer, bh, bl
		call Gotoxy
		mov  eax, 1 + ( black*16 )			;�]�w�e�����Ŧ�A�I�����¦�
		call SetTextColor
		
		mov  al , 3h
		call Writechar 						;�L�X�R��
		
		add  esi, TYPE COOR
		loop printblue
	
	;---�j�ѽL�����I---
	;���ӯx�}�����e�A�z�L Transfer �ഫ��ø�X
		mov  ecx, 15
		mov  esi, OFFSET M
		
	
	printmagenta:
		mov  bh , (COOR PTR [esi]).X
		mov  bl , (COOR PTR [esi]).Y
		INVOKE Transfer, bh, bl
		call Gotoxy
		mov  eax, 5 + ( black*16 )			;�]�w�e����������A�I�����¦�
		call SetTextColor
		
		mov  al , 6h
		call Writechar						;�L�X�®�
		
		add  esi, TYPE COOR
		loop printmagenta	
		
	;---�j�ѽL�@���I---
	;���ӯx�}�����e�A�z�L Transfer �ഫ��ø�X
		mov  ecx, 15
		mov  esi, OFFSET Br
		
	printbrown:
		mov  bh , (COOR PTR [esi]).X
		mov  bl , (COOR PTR [esi]).Y
		INVOKE Transfer, bh, bl
		call Gotoxy
		mov  eax, 6 + ( black*16 )		;�]�w�e�����@�ئ�A�I�����¦�
		call SetTextColor
		
		mov  al , 4h
		call Writechar						;�L�X�٧�
		add  esi, TYPE COOR
		loop printbrown
		
	;---�j�ѽL���---
		mov  bh , cursor.X
		mov  bl , cursor.Y
		INVOKE Transfer, bh, bl
		
		;ø�s"[" �A�H�C���
		sub  dl ,1
		call Gotoxy
		mov  eax, 11 + ( black*16 )
		call SetTextColor
		mov  al , "["
		call Writechar
		
		;ø�s"[" �A�H�C���
		add  dl ,2
		call Gotoxy
		mov  eax, 11 + ( black*16 )
		call SetTextColor
		mov  al , "]"
		call Writechar
		
	;�q���|���^�Ȧs�����e
		pop  esi
		pop  ecx
		pop  ebx
		pop  eax

		ret
		
print ENDP

;----------------------------------------------Transfer----------------------------------------------
Transfer PROC,
	X1:sbyte, Y1:sbyte
	
	;�N�|�Ψ쪺�Ȧs�����e��J���|
	push eax
	push ebx

	mov al, X1;
	mov bl, Y1;
	
	;2*x1 + y1 + 13 =x2
	
	add al, al
	add al, bl
	add al, 30
	mov dl, al
	
	;-y1 + 9 = y2
	neg bl
	add bl, 15
	mov dh, bl
	
	;�q���|���^�Ȧs�����e
	pop ebx
	pop eax
	
	ret

Transfer ENDP
;----------------------------------------------Boundary----------------------------------------------
Boundary PROC, ux:SBYTE, uy:SBYTE
		push ebx
	test_uptri: 
		
		;�P�_�O�_�b�W�T���̡A�u�n���@�����ŦX�A
		;�N�������h�P�_�O���O�U�T����
		cmp uy, -4
		jl test_downtri  ;y<-4
		cmp ux, -4 
		jl test_downtri  ;x<-4
		mov bl, ux
		add bl, uy
		cmp bl, 4  
		jg test_downtri  ;x+y>4
		jmp Istrue
		
		;�T�����ŦX�A�ҥH�b�W�T����
		;�N�������hIstrue�A�^��true(ax=1)�A�����{��

	test_downtri:
		;�P�_�O�_�b�U�T���̡A�u�n���@�����ŦX�A
		;�N�������hIsfalse�A�^��false(ax=0)�A�����{��
		cmp uy, 4 
		jg Isfalse  ;y > 4
		cmp ux, 4 
		jg Isfalse  ;x > 4
		mov bl, ux
		add bl, uy
		cmp bl, -4
		jl Isfalse  ;x+y>=-4
		
		;�T�����ŦX�A�ҥH�b�U�T���̴N
		;��Istrue�A�^��true(ax=1)�A�����{��
		
	Istrue:
		mov ax, 1
		jmp existBoundary
	Isfalse:
		mov ax, 0
	existBoundary:
		pop ebx
		ret
		
Boundary ENDP
;----------------------------------------------Iswin----------------------------------------------
Iswin PROC
		push edi
		push ecx
		mov ecx, 15
		mov edi, 0
	checkR:
		cmp (COOR PTR B[edi]).Y, -4   		;B���C�ӴѤl��Y�������p�󵥩�-4
		jg checkM                     		;�u�n���@���S���AR�N���i��Ĺ�A�N�������hcheck M
		cmp (COOR PTR B[edi]).X, 0			;B���C�ӴѤl��X�������j�󵥩�0
		jl checkM                     		;�u�n���@���S���AB�N���i��Ĺ�A�N�������hcheck M
		cmp (COOR PTR B[edi]).X, 4			;B���C�ӴѤl��X�������p�󵥩�4
		jg checkM                  	   		;�u�n���@���S���AB�N���i��Ĺ�A�N�������hcheck M
		add edi, TYPE COOR
		loop checkR
		mov bx, 1
		jmp Win                        		;B�C���Ѥl��Y���p�󵥩�-4�A�hBĹ�F
		
	checkM:
		mov ecx, 15
		mov edi, 0
	Mloop:
		mov bl, (COOR PTR M[edi]).X    		;M���C�ӴѤl������x+y>=4
		add bl, (COOR PTR M[edi]).Y
		cmp bl, 4 
		jl checkBr                    		;�u�n���@���S���AM�N���i��Ĺ�A�N�������hcheck Br
		cmp (COOR PTR M[edi]).Y, 0     		;M���C�ӴѤl��Y�������j�󵥩�0
		jl checkBr                    		;�u�n���@���S���AM�N���i��Ĺ�A�N�������hcheck Br
		cmp (COOR PTR M[edi]).Y, 4    		;M���C�ӴѤl��Y�������p�󵥩�4
		jg checkBr                      		;�u�n���@���S���AM���i��Ĺ�A�N�������hcheck Br
		add edi, TYPE COOR
		loop Mloop
		mov bx, 2
		jmp Win                       		;M���C�ӴѤl��x+y>=4�A�hMĹ�F
		
	checkBr:
		mov ecx, 15
		mov edi, 0
	Brloop:
		cmp (COOR PTR Br[edi]).X, -4    		;Br���C�ӴѤl��X�������p�󵥩�-4
		jg Conti                       		;�u�n���@���S���ABr�N���i��Ĺ�A�YB,M,Br���S���HĹ
		cmp (COOR PTR Br[edi]).Y, 0    		;Br���C�ӴѤl��Y�������j�󵥩�0
		jl Conti                      		;�u�n���@���S���ABr�N���i��Ĺ�A�YB,M,Br���S���HĹ Y
		cmp (COOR PTR Br[edi]).Y, 4    		;Br���C�ӴѤl��Y�������p�󵥩�4
		jg Conti                      		;�u�n���@���S���ABr�N���i��Ĺ�A�YB,M,Br���S���HĹ
		add edi, TYPE COOR
		loop Brloop
		mov bx, 3
		jmp Win								;Br�C���Ѥl��X���p�󵥩�-4�A�hBrĹ�F
		
	Win:									;�����a�ӧQ ax = 1
		mov ax, 1
		jmp existIswin
		
	Conti:									;�L���a�ӧQ ax = 0
		mov ax, 0;
		
	existIswin:
		pop ecx
		pop edi
		ret
		
Iswin ENDP
;----------------------------------------------movecursor----------------------------------------------
movecursor PROC

		push eax
		push ebx
	
	;���ݿ�J�W�B�U�B���B�k�Benter
	WaitInput:
		call readchar
		cmp  eax, 4800h						;�W
		jz   UP
		cmp  eax, 5000h						;�U
		jz   DOWN
		cmp  eax, 4B00h						;��
		jz   LEFT
		cmp  eax, 4D00h						;�k
		jz   RIGHT
		cmp  eax, 1C0Dh						;enter
		jz   OUTFUN
		jmp  WaitInput
	
	;�W -> Y�y��+1 �çP�_��m�O�_�W�X���
	UP:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, 1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;�U -> Y�y��-1 �çP�_��m�O�_�W�X���
	DOWN:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, -1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;�� -> X�y��-1 �çP�_��m�O�_�W�X���
	LEFT:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bh, -1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;�k -> X�y��+1 �çP�_��m�O�_�W�X���
	RIGHT:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bh, 1
		INVOKE Boundary, bh, bl
		cmp  ax , 0
		jz   WaitInput
		mov  cursor.X, bh
		mov  cursor.Y, bl
		INVOKE print
		jmp  WaitInput
	
	;enter ���X�禡
	OUTFUN:
		pop  ebx
		pop  eax
		ret
		
movecursor ENDP
;----------------------------------------------movechess----------------------------------------------
movechess PROC

		;�ŧi�ϰ��ܼ�  isjmp:�P�_�O�_��"��"��  chessx:�ѤlX�y��  chessy:�ѤlY�y��
		LOCAL isjmp : byte, chessx : sbyte,chessy : sbyte
		push ebx
		push edx
		
		;isjmp�w�]��0
		mov  isjmp, 0
		
	moveagain:
		
		;���ʴ��
		INVOKE movecursor
		
		;�N�Ѥl��l��m�g�J (bh, bl)
		mov  bh, (COOR PTR [esi]).X
		mov  chessx, bh
		mov  bl, (COOR PTR [esi]).Y
		mov  chessy, bl

		;�ˬd��Ц�m�O�_���Ѥl
		INVOKE IsChess, cursor.X, cursor.Y
		cmp  al, 0
		jz   startmove						;�Ӧ�m�L�Ѥl
		
		;�p�G(bh, bl) == (cursor.X, cursor.Y) => �B�z���ѵ��� �Ϊ� �������
		cmp  bh, cursor.X
		jnz  haschess
		cmp  bl, cursor.Y
		jnz  haschess
		jmp  startmove
	
	haschess:
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET havechess			;�L�X"This position has a chess."���A
		call WriteString
		jnz  moveagain	
		
	startmove:	
		;(bh, bl) ������Ӧ�m�P��l��m���t
		mov  bh, cursor.X
		mov  bl, cursor.Y
		sub  bh, chessx
		sub  bl, chessy
		
		;���L���Ѥl���ΧP�_����
		cmp  isjmp, 0
		jnz  jump							;�B�z"��"��
		
		cmp  bh, 1
		jz   xplusone						;X�y�Юt = +1(���B��)
		cmp  bh, 0
		jz   xremain1						;X�y�Юt = 0 (���B���B�������)
		cmp  bh, -1
		jz   xminusone						;X�y�Юt = -1(���B��)
		cmp  bh, 2
		jz   xplustwo						;X�y�Юt = +2(��)
		cmp  bh, -2
		jz   xminustwo						;X�y�Юt = -2(��)
		jmp  invalidmove					;X�y�Юt�W�X�d��(�D�k����)
	
	;X�y�Юt = +1(���B��)
	xplusone:
		cmp  bl, 0
		jz   moveright;						;Y�y�Юt = 0 (�V�k��)
		cmp  bl, -1	
		jz   moverightdown					;Y�y�Юt = -1(�V�k�U��)
		jmp  invalidmove					;Y�y�Юt�W�X�d��(�D�k����)
	
	;�V�k��
	moveright:
		mov  bh, chessx
		add  bh, 1
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;�V�k�U��
	moverightdown:
		mov  bh, chessx
		add  bh, 1
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, -1
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret

	;X�y�Юt = 0 (���B���B�������)
	xremain1:
		cmp  bl, 1
		jz   moverightup					;Y�y�Юt = 1 (�V�k�W��)
		cmp  bl, -1						
		jz   moveleftdown					;Y�y�Юt = -1 (�V���U��)
		cmp  bl, 0
		jz   unlock							;Y�y�Юt = 0 (�������)
		cmp  bl, 2
		jz   jumprightup					;Y�y�Юt = 2 (�V�k�W��)
		cmp  bl, -2
		jz   jumpleftdown					;Y�y�Юt = -2 (�V���U��)
		jmp  invalidmove					;Y�y�Юt�W�X�d��(�D�k����)

	;�������
	unlock:
		mov  ax, 0							;�]�w ax = 0 �ѥD�{���P�_�����v�ಾ
		pop  ebx
		ret
	
	;�V�k�W��
	moverightup:
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, 1
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;�V���U��
	moveleftdown:
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		sub  bl, 1
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;X�y�Юt = -1 (���B��)
	xminusone:
		cmp  bl, 0
		jz   moveleft						;Y�y�Юt = 0 (�V����)
		cmp  bl, 1
		jz   moveleftup						;Y�y�Юt = 1 (�V���W��)
		jmp  invalidmove					;Y�y�Юt�W�X�d��(�D�k����)
		
	;�V����
	moveleft:
		mov  bh, chessx
		add  bh, -1
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret
	
	;�V���W��
	moveleftup:
		mov  bh, chessx
		add  bh, -1
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, 1
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		INVOKE print
		mov  ax, 1
		pop  ebx
		ret

	;�o�̳B�z"��"��
	jump:
		cmp  bh, 2
		jz   xplustwo						;X�y�Юt = +2(��)
		cmp  bh, 0
		jz   xremain2						;X�y�Юt = 0 (��)
		cmp  bh, -2
		jz   xminustwo						;X�y�Юt = -2(��)
		jmp  invalidmove					;X�y�Юt�W�X�d��(�D�k����)
		
	xplustwo:
		cmp  bl, 0
		jz   jumpright						;Y�y�Юt = 0 (�V�k��)
		cmp  bl, -2
		jz   jumprightdown					;Y�y�Юt = -2 (�V�k�U��)
		jmp  invalidmove					;Y�y�Юt�W�X�d��(�D�k����)
		
	jumpright:
		mov  bh, cursor.X
		add  bh, -1
		mov  bl, cursor.Y
		INVOKE IsChess, bh, bl				;�P�_�n������V�O�_���Ѥl
		cmp  al, 0
		jz   invalidmove					;�n������V�L�Ѥl
		mov  bh, chessx
		add  bh, 2
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  isjmp, 1						;�]�w isjmp = 1
		INVOKE print
		jmp  jumpagain

	jumprightdown:
		mov  bh, cursor.X
		add  bh, -1
		mov  bl, cursor.Y
		add  bl, 1
		INVOKE IsChess, bh, bl				;�P�_�n������V�O�_���Ѥl
		cmp  al, 0
		jz   invalidmove					;�n������V�L�Ѥl
		mov  bh, chessx
		add  bh, 2
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, -2
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		mov  isjmp, 1						;�]�w isjmp = 1
		INVOKE print
		jmp  jumpagain
		
	xremain2:
		cmp  bl, 2	
		jz   jumprightup					;Y�y�Юt = 2 (�V�k�W��)
		cmp  bl, -2
		jz   jumpleftdown					;Y�y�Юt = -2 (�V���U��)
		cmp  bl, 0
		jz   jumpend						;Y�y�Юt = 0 (���ѵ���)
		jmp  invalidmove					;Y�y�Юt�W�X�d��(�D�k����)

	jumprightup:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, -1
		INVOKE IsChess, bh, bl				;�P�_�n������V�O�_���Ѥl
		cmp  al, 0
		jz   invalidmove					;�n������V�L�Ѥl
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, 2
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		mov  isjmp, 1						;�]�w isjmp = 1
		INVOKE print
		jmp  jumpagain

	jumpleftdown:
		mov  bh, cursor.X
		mov  bl, cursor.Y
		add  bl, 1
		INVOKE IsChess, bh, bl				;�P�_�n������V�O�_���Ѥl
		cmp  al, 0
		jz   invalidmove					;�n������V�L�Ѥl
		mov  bh, chessx
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, -2
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		mov  isjmp, 1						;�]�w isjmp = 1
		INVOKE print
		jmp  jumpagain
		
	xminustwo:
		cmp  bl, 2							;Y�y�Юt = 2 (�V���W��)
		jz   jumpleftup
		cmp  bl, 0							;Y�y�Юt = 0 (�V����)
		jz   jumpleft
		jmp  invalidmove					;Y�y�Юt�W�X�d��(�D�k����)

	jumpleftup:
		mov  bh, cursor.X
		add  bh, 1
		mov  bl, cursor.Y
		add  bl, -1
		INVOKE IsChess, bh, bl				;�P�_�n������V�O�_���Ѥl
		cmp  al, 0
		jz   invalidmove					;�n������V�L�Ѥl
		mov  bh, chessx
		add  bh, -2
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		add  bl, 2
		mov  (COOR PTR [esi]).Y, bl			;���ܺX�lY�y��
		mov  isjmp, 1						;�]�w isjmp = 1
		INVOKE print
		jmp  jumpagain

	jumpleft:
		mov  bh, cursor.X
		add  bh, 1
		mov  bl, cursor.Y
		INVOKE IsChess, bh, bl				;�P�_�n������V�O�_���Ѥl
		cmp  al, 0
		jz   invalidmove					;�n������V�L�Ѥl
		mov  bh, chessx
		add  bh, -2
		mov  (COOR PTR [esi]).X, bh			;���ܺX�lX�y��
		mov  bl, chessy
		mov  isjmp, 1						;�]�w isjmp = 1
		INVOKE print
		jmp  jumpagain

	;���ѥi�H�M�w�O�_�n�~���
	jumpagain:
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET jumporstop
		call WriteString
		jmp  moveagain
	
	;�D�k����
	invalidmove:	
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET cantjump
		call WriteString
		jmp  moveagain
	
	;��������
	jumpend:
		mov  ax, 1
		pop  edx
		pop  ebx
		ret

movechess ENDP
;----------------------------------------------Choose----------------------------------------------
Choose PROC
		push eax;
		push ecx;
		push ebx;
		push edx;
		push edi;
	stage_move:
		INVOKE Movecursor                   ;���ʴ��
		INVOKE print
		INVOKE Boundary, cursor.X, cursor.Y ;�T�{��Ц��S���b�ѽL��
		cmp ax, 1
		jne stage_move                      ;�S�����ܦ^�첾�ʴ�Ъ����A 
		INVOKE IsChess, cursor.X, cursor.Y  ;�T�{��쪺�O���O���T���Ѥl(�O���O�Mcontrol�ۦP)
		cmp al, control
		jne invalidchoose                 	;������ܦ^�첾�ʴ�Ъ����A  
		mov bl, al
		mov ecx, 15                         ;count=15
		mov ah, cursor.X                    ;���Ъ�XY�Ƕiax
		mov al, cursor.Y
		cmp bl, 1                           ;�O�Ŵ�
		je chessB
		cmp bl, 2                           ;�O������
		je chessM
		cmp bl, 3                           ;�O�@�ش�
		je chessBr
		
	chessB: 
		mov edi, OFFSET B                   ;edi����B(�Ŵ�)���_�l��m
		jmp stage_return
		
	chessM:
		mov edi, OFFSET M                  ;edi����M(������)���_�l��m	
		jmp stage_return
		
	chessBr:
		mov edi, OFFSET Br                   ;edi����Br(�@�ش�)���_�l��m	
		jmp stage_return
		
	stage_return:
		cmp ah, (COOR PTR [edi]).X
		jnz reloop							;X�y�Ф���
		cmp al, (COOR PTR [edi]).Y
		jnz reloop							;Y�y�Ф���
		jmp stage_find						;���۲Ŧ�m���Ѥl
		
	reloop:
		add edi, TYPE COOR					;�P�_������O�_���U�@���Ѥl
		loop stage_return
		
	stage_find:
		mov esi, edi                        ;�^��esi=edi
		pop eax;
		pop ecx;
		pop ebx;
		pop edx;
		pop edi;
		ret
		
	;�D�k����Ѥl
	invalidchoose:
		mov  dh, 0
		mov  dl, 0
		call Gotoxy
		mov  edx, OFFSET chooseyourschess
		call WriteString					;�L�X"You Can't choose other's chess or choose Nothing. Please choose your own chess! "���A
		INVOKE Transfer, cursor.X, cursor.Y
		call Gotoxy
		jmp stage_move                      ;������ܦ^�첾�ʴ�Ъ����A	
		
Choose ENDP
;----------------------------------------------IsChess----------------------------------------------
IsChess PROC,
		boolx: sbyte, booly: sbyte
		
		;�N�ϥΪ��Ȧs�����Ȧs����|
		push ecx							
		push ebx
		push edi
		
		mov ecx, 45							;�]�w�j�馸��
		mov edi, OFFSET B					;�]�wedi����B���O�����m
	find:
		mov bl, (COOR PTR [edi]).X
		mov bh, (COOR PTR [edi]).Y
		
		cmp boolx, bl
		jnz addpointer						;X�y�Ф���
		cmp booly, bh
		jnz addpointer						;Y�y�Ф���
		jz lookecx
		
	addpointer:
		add edi, TYPE COOR
		loop find
		
	;��������m���Ѥl �P�_ecx�d�� �����Ѥl���Ҧ���
	lookecx:
		cmp ecx, 30
		jg findr							;�Ŵ�
		cmp ecx, 15
		jg findg							;������
		cmp ecx, 0
		jg findy							;�@�ش�
		cmp ecx, 0
		jz nofind							;�L�Ѥl
		
	;�Ŵ�  al = 1
	findr:
		mov al, 1
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
	;������	al = 2
	findg:
		mov al, 2
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
	;�@�ش�  al = 3
	findy:
		mov al, 3
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
	;�L�Ѥl	 al = 0
	nofind:
		mov al, 0
		pop  edi
		pop  ebx
		pop  ecx
		ret
		
IsChess ENDP
END main	