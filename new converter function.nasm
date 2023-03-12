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

    numsys: db "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

section .bss
    input:  resb 256
    result: resb 256


section .text

read:
    ;push system
    ;return number
    pop r15
    pop r8
    xor rax, rax
    mov rsi, input
    mov rdx, 256
    syscall

    mov rsi, input
    xor rdx, rdx
    xor rcx, rcx
    .rloop:
        mov rax, r8
        mov cl, [rsi]
        inc rsi
        cmp cl, 10
        jna .rend

        mov rdi, numsys
        .sloop:
            cmp cl, [rdi]
            jz .send
            inc rdi
            jmp .sloop
        .send:
        sub rdi, numsys
        mul rdx
        mov rdx, rax
        add rdx, rdi
        jmp .rloop

    .rend:
    push rdx
    push r15
    ret


convert:
    ;push   number
    ;push   system
    ;push   output
    ;return output
    ;return len_output
    pop r15
    pop rsi
    pop rbx
    pop rax
    
    add rsi, 255
    mov rcx, rsi
    mov byte[rsi], 10

    .cloop:
        xor rdx, rdx
        div rbx
        add rdx, numsys
        mov dl, [rdx]
        
        dec rsi
        mov [rsi], dl 
        cmp rax, 0
        jnz .cloop  
    
    sub rcx, rsi
    inc rcx

    push rcx
    push rsi
    push r15
    ret


_start:
    ;read1: 
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, fsist
        mov rdx, flen
        syscall
        push 10
        call read     

    ;read2:
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, ssist
        mov rdx, slen
        syscall
        push 10
        call read    

    ;read_num:
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, number
        mov rdx, nlen
        syscall
        pop r10
        call read 
        mov eax, edx

    ;get_result:
        mov rsi, result
        push r10
        push rsi
        call convert

    ;print_result:
        mov rax, 0x1
        mov rdi, 0x1
        mov rsi, res
        mov rdx, rlen
        syscall

    ;print_result:
        mov rax, 0x1
        mov rdi, 0x1
        pop rsi
        pop rdx
        syscall

    mov rax, 0x3c
    mov rdi, 0x0
    syscall 
