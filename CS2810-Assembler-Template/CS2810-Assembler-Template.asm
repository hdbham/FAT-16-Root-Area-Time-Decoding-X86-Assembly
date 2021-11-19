; TITLE CS2810 Assembler #2
; Hunter Burningham
; 11/10/2021:

	INCLUDE Irvine32.inc ;include libraries
	.data

	;--------- Enter Data Here

	vTimeField byte "--:--:--",0

	vInput byte "Enter a FAT16 file time in hex format :",0
	vSemester byte "CS2810 Fall Semester 2021",0
	vAssignment byte "Assembler Assignment #2",0
	vName byte "Hunter Burningham",0


	.code
	main PROC
	;--------- Enter Code Below Here
	
	;-------- Header
	Call ClrScr

	Mov dh, 7 ; moves value to dh
	mov dl, 20 ; moves value to dl
	call gotoxy ;move cursor to dh,dl
	mov edx, offset vSemester ; moves data from vSemester pointer to edx
	call writestring ;writes from last register

	Mov dh, 8
	mov dl, 20
	call gotoxy
	mov edx, offset vAssignment
	call writestring

	Mov dh, 9
	mov dl, 20
	call gotoxy
	mov edx, offset vName
	call writestring

	;------ Input
	Mov dh, 11
	mov dl, 20
	call gotoxy
	mov edx, offset vInput
	call WriteString ; prompt
	call ReadHex ;stores input from user as hex in ax

	;------ Little Endian Reverse
	ror ax, 8 ;little endian reverse
	
	;------ Backup Input
	mov cx, ax 

	;------- HOURS
	and ax, 0f800h ;AND to register for mask
	shr ax, 11 ;take pov and move to least 

	mov bh, 10 ;take it and make it dec (divide by 10)
	div bh ; divides last register by divisor specified aboce
	or ax, 3030h ;add 30h offset to make ascii on AH, AL (quotient and remainder)

	mov word ptr [vTimefield+0], ax ;shifts value of ax into pointer adjusted by 0 chars

	;------- MINUTES
	mov ax, cx ;copy cx back into ax

	and ax, 07E0h ;AND to register for mask
	shr ax, 5 ;take pov and move to least 

	mov bh, 10 ;take it and make it dec (divide by 10)
	div bh ; divides last register by divisor specified aboce
	or ax, 3030h ;add 30h offset to make ascii on AH, AL (quotient and remainder)

	mov word ptr [vTimefield+3], ax ;shifts value of ax into pointer adjusted by 3 chars
	
	;------- SECONDS
	mov ax, cx ;copy cx back into ax

	and ax, 1Fh ;AND to register for mask
	shl ax, 1 ; move bits over left = multiply by 2 when in binary

	mov bh, 10 ;take it and make it dec (divide by 10)
	div bh ; divides last register by divisor specified aboce
	or ax, 3030h ;add 30h offset to make ascii on AH, AL (quotient and remainder)
	
	mov word ptr [vTimefield+6], ax ;shifts value of ax into pointer adjusted by 6 chars

	;------- PRINT 
	Mov dh, 12
	mov dl, 20
	call gotoxy
	mov edx, offset vTimefield
	call WriteString

	xor ecx, ecx 
	call ReadChar

	exit

main ENDP

END main