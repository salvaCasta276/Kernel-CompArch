GLOBAL cpuVendor
GLOBAL getstatuskeyboard
GLOBAL getcharacter
GLOBAL getRtcStatus
GLOBAL setRtcBinary
GLOBAL getkeyStatus 
GLOBAL getcharacterC
GLOBAL getMem
GLOBAL getFromRTC
GLOBAL backupRSP
GLOBAL resetRSP
GLOBAL getRegs


section .text
	
backupRSP:
	mov rax , rsp 
	ret


;; en rdi tengo el valor del rsp a restaurar 
resetRSP:
	pop rax
	mov rsp, rdi
	push rax
	ret 





cpuVendor:
	push rbp
	mov rbp, rsp

	push rbx

	mov rax, 0
	cpuid


	mov [rdi], ebx
	mov [rdi + 4], edx
	mov [rdi + 8], ecx

	mov byte [rdi+13], 0

	mov rax, rdi

	pop rbx

	mov rsp, rbp
	pop rbp
	ret


 
 
;4 la hora 
;2 los minutos 
; 0 los segundos 
getFromRTC:

    push rbp
    mov rbp, rsp
	push rbx 
	
	xor rax , rax 
    mov rbx, rdi
	mov al , bl
    out 70h, al
    in al, 71h

	pop rbx
    mov rsp, rbp
    pop rbp

    ret




getRtcStatus: 
	push rbp 
	mov rbp , rsp 

	xor rax , rax 
	mov al , 0x0B
	out 70h , al 
	in al , 71h


	mov rsp , rbp
	pop rbp 
	ret


getkeyStatus: 
	push rbp 
	mov rbp , rsp 

	xor rax , rax 
	in al , 0x64  ;;si el ultimo bit es cero no hay nada en el buffer 

	mov rsp , rbp 
	pop rbp 
	ret 

getcharacterC:
	push rbp 
	mov rbp , rsp 

	xor rax , rax 
	in al , 0x60

	mov rsp , rbp
	pop rbp 
	ret 


;;setea el RTC para que devuelva en binario.
	setRtcBinary: 
		push rbp 
		mov rbp , rsp 

		xor rax , rax 
		mov al , 0x0B
		out 70h , al 
		xor rax , rax 
		mov al , 0x06
		out 71h , al

		mov rsp,rbp 
		pop rbp 
		ret

;;en rdi char * donde se van a guardar 
;; en rsi char * con una direccion de memoria valida 
getMem : 

	;;push rax 
	;;push rcx 

	mov rcx , 4
_loop:
	mov rax, 0
	mov [rdi], rax
	mov al, [rsi]
    mov [rdi] , al
	add rdi , 8
	add rsi , 1 
	dec rcx 
	cmp rcx , 0 
	jge _loop

	
	;;sub rdi , 8 
	;;sub rsi , 8

	;;pop rcx 
	;;pop rax
	ret

getRegs:
	push rbp
	mov rbp, rsp
	mov rcx, 16
	mov rdx, rbp
	add rdx, 104
_loop2:
	mov r8, [rdx]
	mov rax, r8
	mov qword [rdi], rax
	add rdi, 8
	add rdx, 8
	dec rcx
	cmp rcx, 0
	jg _loop2	
	mov rsp, rbp
	pop rbp
	ret
	
