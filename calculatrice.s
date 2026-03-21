.data
Buf1:       .space 256
N:          .quad 256
n1:         .quad 0
operateur:  .byte 0
n2:         .quad 0
res:        .space 32
nl:         .ascii "\n"

.text
.globl _start

_start:
    /* LIRE L'EXPRESSION (l'entrée) */
    movq $0, %rax /*read*/
    movq $0, %rdi /*entr std clavier*/
    movq $Buf1, %rsi
    movq N, %rdx  /*max carac*/
    syscall

    /* POINTEUR SUR LE BUFFER (carac par carac)*/
    movq $Buf1, %rbx

main_loop:
    /* SKIP LES ESPACES */
    movb (%rbx), %al
    cmpb $32, %al  /* ' ' ? */
    jne not_space
    incq %rbx 
    jmp main_loop

not_space:
    /* FIN DE CHAINE */
    cmpb $10, %al  /* '\n' = fin */
    je fin_programme
    cmpb $0, %al /* 0 = fin*/
    je fin_programme

    /* CHIFFRE ? */
    cmpb $48, %al /* '0' */
    jl check_op /* si inf à 0*/
    cmpb $57, %al /* si sup à 9*/
    jg check_op

    /* LIRE UN NOMBRE ET L'EMPILER */
    movq $0, %rdx
read_num:
    movb (%rbx), %al
    cmpb $48, %al /*'0'*/
    jl end_num  /* jump si inf */
    cmpb $57, %al /* '9' */
    jg end_num  /* jump si sup */
    subb $48, %al  /* '0' */
    movzbq %al, %rsi
    imulq $10, %rdx /* '\n' */
    addq %rsi, %rdx
    incq %rbx
    jmp read_num

end_num:
    push %rdx /* res dans rdx */
    jmp main_loop

check_op:
    /* LIRE L'OPERATEUR */
    movb %al, operateur
    incq %rbx

    /* DEPILER LES DEUX OPERANDES (a et b)*/
    pop %rdi           /* sommet de pile */
    pop %rsi           /* sous le sommet */

    /* APPEL SELON L'OPERATEUR */
    cmpb $43, operateur    /* '+' */
    je call_plus
    cmpb $45, operateur    /* '-' */
    je call_moins
    cmpb $42, operateur    /* '*' */
    je call_mul
    cmpb $47, operateur    /* '/' */
    je call_div
    jmp main_loop

call_plus:
    call addition
    jmp apres_calcul
call_moins:
    call soustraction
    jmp apres_calcul
call_mul:
    call multiplication
    jmp apres_calcul
call_div:
    call division

apres_calcul:
    push %rax          /* PUSH du resultat sur la pile */
    jmp main_loop 

fin_programme:
    pop %rax           /* res final */
    movq %rax, %rdx
    jmp affiche


/* %rsi = a,  %rdi = b        */
/* %rax = a + b               */ 
addition:
    push %rbp
    movq %rsp, %rbp
    push %rbx

    movq %rsi, %rax
    addq %rdi, %rax

    pop %rbx
    movq %rbp, %rsp
    pop %rbp
    ret

                        
/* %rsi = a,  %rdi = b   */
/* Retour     : %rax = a - b  */
soustraction:
    push %rbp
    movq %rsp, %rbp
    push %rbx

    movq %rsi, %rax
    subq %rdi, %rax

    pop %rbx
    movq %rbp, %rsp
    pop %rbp
    ret

/* %rsi = a,  %rdi = b                       */
/*  %rax = a * b                               */
multiplication:
    push %rbp
    movq %rsp, %rbp
    push %rbx

    movq %rsi, %rax
    imulq %rdi, %rax

    pop %rbx
    movq %rbp, %rsp
    pop %rbp
    ret

/* %rsi = a,  %rdi = b (diviseur) */
/* %rax = a / b  (dividende) */
division:
    push %rbp
    movq %rsp, %rbp
    push %rbx

    movq %rsi, %rax
    movq $0, %rdx 
    divq %rdi

    pop %rbx
    movq %rbp, %rsp
    pop %rbp
    ret

/* AFFICHAGE DU RESULTAT (conversio en ASCII)    */

affiche:
    movq %rdx, %rax
    movq $res, %r8
    addq $31, %r8
    movb $0, (%r8)

    cmpq $0, %rax
    jne conv
    movb $48, (%r8)
    decq %r8
    movq $1, %r12
    jmp aff

conv:
    movq $0, %r12

conv_loop:
    movq $0, %rdx
    movq $10, %rcx
    divq %rcx
    addb $48, %dl
    decq %r8
    movb %dl, (%r8)
    incq %r12
    cmpq $0, %rax
    jne conv_loop
aff:
    /* AFFICHER RESULTAT */
    movq $1, %rax
    movq $1, %rdi
    movq %r8, %rsi
    movq %r12, %rdx
    syscall

    /* AFFICHER SAUT DE LIGNE */
    movq $1, %rax
    movq $1, %rdi
    movq $nl, %rsi
    movq $1, %rdx
    syscall

    /*FIN*/
    movq $60, %rax
    movq $0, %rdi
    syscall
