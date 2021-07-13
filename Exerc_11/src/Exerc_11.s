        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start

        ;a ideia aqui é converter um produtório (a operação de fatorial) em um somatório...
factr:  MOV     R0, #6 ;valor de entrada
        MOV     R2, #0 ;índice interno, registra qntas operações de soma ocorreram dentro de um loop
        MOV     R3, #1 ;fator seguinte do produtório, R5 será o fator antecessor
        MOV     R4, #1 ;índice externo, indica em qual termo do produtório estamos. Comeca em 2 pq começamos calculando 2 fatorial...
somaex: MOV     R5, R3 ;soma externa: salva o fator antecessor (:= fator sucessor da iteração anterior)...
somain: ADD     R3, R3, R5 ;soma interna: soma (fator seguinte)-vezes o fator antecessor
        ADD     R2, R2, #1 ;registra mais uma operação de soma no índice interno.
        CMP     R2, R4 ;foi feita a quantiade certa de operações de soma??
        IT      NE
          BNE   somain
        MOV     R2, #0 ;reseta índice interno
        ADD     R4, R4, #1 ;vai pro próximo fator...
        CMP     R4, R0 ;é o último fator??
        IT      NE
          BNE   somaex
        MOV     R0, R3
        BX      LR
        
main    BL      factr
        B       main

        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
