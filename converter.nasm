global _start


section .rodata
    fsist: db "Enter first number base:"
    flen: equ $-fsist
    ssist: db "Enter first number base:"
    slen: equ $-ssist
    number: db "Enter number:"
    nlen: equ $-number
    res: db "Result:"
    rlen: equ $-res


section .bss
    input:  resb 256
    result: resb 256


section .text

read:
    mov rax, 0x0
    mov rdi, 0x0
    mov rsi, input
    mov rdx, 256
    syscall

    mov rsi, input
    xor rdx, rdx
    xor ecx, ecx
    .rloop:
        mov eax, r8d
        mov cl, [rsi]
        inc rsi
        cmp cl, 0
        jz .rend
        cmp cl, 10
        jz .rend

        .frc:
            cmp ecx, '='
            jnb .src
            sub ecx, '0'
            jnb .rdefault
        .src:
            cmp ecx, '^'
            jnb .trc
            sub ecx, '7'
            jnb .rdefault
        .trc:
            sub ecx, '>'
        .rdefault:
        mul edx
        mov edx, eax
        add edx, ecx
        jmp .rloop

    .rend:
    ret


convert:
    xor rcx, rcx 
    mov ebx, r10d
    .cloop:
        mov edx, 0
        div ebx
        push rdx
        inc ecx
        cmp eax, 0
        jnz .cloop
    
    .reverse:
        pop rax
        .fc:
            cmp al, 9
            ja .sc
            add al, '0'
            jmp .cdefault
        .sc:
            cmp al, 35
            ja .tc
            add al, '7'
            jmp .cdefault
        .tc:
            add al, '>'
        .cdefault:
        mov [rsi], al
        inc rsi
        dec ecx
        cmp ecx, 0

        jnz .reverse
        mov byte[rsi], 10

    ret


_start:

    ;read1: 
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, fsist
        mov rdx, flen
        syscall
        mov r8d, 10
        call read     
        push rdx

    ;read2:
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, ssist
        mov rdx, slen
        syscall
        mov r8d, 10
        call read    
        mov r10d, edx
        push rdx

    ;read_num:
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, number
        mov rdx, nlen
        syscall
        pop r10
        pop r8
        call read 
        mov eax, edx

    ;get_result:
        mov rsi, result
        call convert

    ;print_result:
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, res
        mov rdx, rlen
        syscall

        mov rsi, result 
        mov rax, 0x1
        mov rdi, 0x1
        mov rdx, 256
        syscall

    mov rax, 0x1
    mov rbx, 0x0
    int 80h 
