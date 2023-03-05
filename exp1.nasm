global _start


section .bss
    input:  resb 1024
    result: resb 1024


section .text


read:
    mov rax, 0x0
    mov rdi, 0x0
    mov rsi, input
    mov rdx, 1024
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

    ret


_start:
    mov r8d, 10
    call read;первая система     
    mov r9d, edx
    call read;вторая система    
    mov r10d, edx
    mov r8d, r9d
    call read;число 
    mov eax, edx

    mov rsi, result
    call convert
    mov rsi, result 
    mov rax, 0x1
    mov rdi, 0x1
    mov rdx, 10
    syscall

    mov rax, 0x1
    mov rbx, 0x0
    int 80h
        
