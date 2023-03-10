convert:
    ;push   number
    ;push   system
    ;push   output
    ;return output
    pop r15
    pop rsi
    pop rbx
    pop rax
    
    add rsi, 1000
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
    
    push rsi
    push r15
    ret
