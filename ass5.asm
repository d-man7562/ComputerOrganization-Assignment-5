section .data
    msg1 db 'Please type in your name: ' , 0DH, 0AH, 0 ;initial message to print
    msgLen1 equ $ - msg1            ;length of msg1

    msg2 db 'Nice to meet you! ' , 0DH, 0AH, 0  ;end message
    msgLen2 equ $ - msg2            ;length of msg2

    inputBuffer times 128 db 4          ;reserve 128 bytes for input

    charsWritten db 4       ;stores how many characters are written successfully
    charsRead dd 4          ;stores how many characters are read successfully


section .bss 
    stdHandle resd 1            ;reserved for writing data
    stdReadHandle resd 1        ;reserved for reading data, wouldve been better
                                ;to be called stdInputHandle but too late now

section .text
    extern _GetStdHandle@4, _WriteConsoleA@20, _ReadConsoleA@20, _ExitProcess@4
    global _start
_start:
    ;two blocks below print the first message
    ;standard output handle
    push -11        ;output constant is -11
    call _GetStdHandle@4        ;system call for win32 api
    mov [stdHandle], eax       ;saves handle

    ;print 'Please enter your name:'
push 0      ;reserved constant for number of bytes written
    push charsWritten   ;verifying
    push msgLen1        ;length of input
    push msg1           ;pointer to the message
    push dword [stdHandle]  ;standard output handle
    call _WriteConsoleA@20

    ;two blocks below handle string input
    ;standard input handle
push -10    ;input constant is -10
	call _GetStdHandle@4
	mov [stdReadHandle], eax ;save the handle
	
	;read the message to standard input, also prints it immediately
push 0
	push charsRead     ;verifying
	push 128        ;length of input (128 bytes)
	push inputBuffer    ;pointer to the message
	push dword [stdReadHandle]  ;standard input handle
	call _ReadConsoleA@20      ;system call


;two blocks below print second greeting message
;get std output handle
push -11                  ;output constant is -11
	call _GetStdHandle@4    ;system call
	mov [stdHandle], eax    ;saves handle
	call _WriteConsoleA@20  ;system call

;write nice to meet you to std ouptut
push 0          ;reserved placeholder
	push charsWritten   ;verifying
	push msgLen2        ;length of message
	push msg2           ;pointer to message
	push dword [stdHandle]  ;standard output handle
	call _WriteConsoleA@20  ;system call

;two blocks below print the name inputted at the start of the program
;get std output handle to std output
push -11                    ;output constant is -11
    call _GetStdHandle@4    ;system call
    mov [stdHandle], eax    ;saves handle
    call _WriteConsoleA@20  ;system call

    ;write the name
push 0                  ;reserved placeholder
    push charsRead      ;verifying
    push 128            ;length of message (128 bytes)
    push inputBuffer    ;pointer to the message
    push dword [stdHandle]  ;standard output handle
    call _WriteConsoleA@20  ;system call
 
;exit program
push 0          ;reserved placeholder
    call _ExitProcess@4 ;system call