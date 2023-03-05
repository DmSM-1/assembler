global _start


section .bss
    result: resb 1024


section .text


convert:
    xor rcx, rcx 
    mov ebx, 16
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
            jmp .defoult
        .sc:
            cmp al, 35
            ja .tc
            add al, '7'
            jmp .defoult
        .tc:
            add al, '>'
        .defoult:

        mov [rsi], al
        inc rsi
        dec ecx
    
        cmp ecx, 0
        jnz .reverse

    ret


_start:     
    mov eax, 43523
    mov rsi, result
    call convert
    ;xor rax, rax
    ;dec cl    
    ;mov rax, r8
    ;shr rax, cl
    mov rsi, result 
    mov rax, 0x1
    mov rdi, 0x1
    mov rdx, 10
    syscall

    mov rax, 0x1
    mov rbx, 0x0
    int 80h
        