.def	temp	 = r16
.def	argument = r17		
.def	return	 = r18		

.org 0x00
jmp reset

.org 0x02
	jmp external_int0

external_int0:
	cli
	call findkey
	mov argument, r21
ut:	
	sbis UCSRA, UDRE
	rjmp ut
	out UDR, r21
	ldi r20, (1 << PC0 | 1 << PC1 | 1 << PC2 | 1 << PC3  )
	out PORTC, r20
	sei
	ret

reset:
     cli 
     ldi temp, low(RAMEND)
     out SPL, temp
     ldi temp, high(RAMEND)
     out SPH, temp    
     ldi r20, (0 << PD2)
     out DDRD, r20
     ldi r20, (0 << PC0 | 0 << PC1 | 0 << PC2 | 0 << PC3 | 1 << PC4 | 1 << PC5 | 1 << PC6 | 1 << PC7)
     out DDRC, r20  
     ldi r20, (1 << isc11)|(0<< isc10)|(1 << isc01)|(0 << isc00)
     out MCUCR, r20
     ldi r20, (1 << INT0) 
     out GICR, r20
     ldi r20, 0x33
     out UBRRL, r20
     ldi r20, 0x00
     out UBRRH, r20 
     ldi r20, (0 << UCSZ0 | 0 << UCSZ1 | 1 << UPM0 | 1 << UPM1 | 1 << USBS)
     out UCSRC, r20
     ldi r20, (1 << TXEN |  0 << UCSZ2 )
     out UCSRB, r20
     ldi r20, (0 << U2X)
     out UCSRA, r20
     ldi r20, (1 << PD2)
     out PORTD, r20    
     ldi r20, (1 << PC0 | 1 << PC1 | 1 << PC2 | 1 << PC3 )
     out PORTC, r20    
     sei 
loop:
      jmp loop
      
findkey:
	sbis PINC, 0
	jmp column_one
	sbis PINC, 1
	jmp column_two
	sbis PINC, 2
	jmp column_three
	sbis PINC, 3
	jmp column_four
	
column_one:
	sbi PORTC, 4
	sbis PINC, 0
	jmp four
	zero:
	    ldi r21, '0'
	    ret
	four:
	    sbi PORTC, 5
	    sbis PINC, 0
	    jmp eight
	    ldi r21, '4'
	    ret
	eight:
	    sbi PORTC, 6
	    sbis PINC, 0
	    jmp C
	    ldi r21, '8'
	    ret
	C:	
	    sbi PORTC, 7
	    sbis PINC, 0
	    ret
	    ldi r21, 'C'
	    ret
column_two:
	sbi PORTC, 4
	sbis PINC, 1
	jmp five
	one:
	    ldi r21, '1'
	    ret
	five:
	    sbi PORTC, 5
	    sbis PINC, 1
	    jmp nine
	    ldi r21, '5'
	    ret
	nine:
	    sbi PORTC, 6
	    sbis PINC, 1
	    jmp D
	    ldi r21, '9'
	    ret
	D:
	    sbi PORTC, 7
	    sbis PINC, 1
	    ret
	    ldi r21, 'D'
	    ret
column_three:
	sbi PORTC, 4
	sbis PINC, 2
	jmp six
	two:
	    ldi r21, '2'
	    ret
	six:
	    sbi PORTC, 5
	    sbis PINC, 2
	    jmp A
	    ldi r21, '6'
	    ret
	A:
	    sbi PORTC, 6
	    sbis PINC, 2
	    jmp E
	    ldi r21, 'A'
	    ret
	E:
	    sbi PORTC, 7
	    sbis PINC, 2
	    ret
	    ldi r21, 'E'
	    ret
column_four:
	sbi PORTC, 4
	sbis PINC, 3
	jmp seven
	three:
	    ldi r21, '3'
	    ret
	seven:
	    sbi PORTC, 5
	    sbis PINC, 3
	    jmp B
	    ldi r21, '7'
	    ret
	B:
	    sbi PORTC, 6
	    sbis PINC, 3
	    jmp F
	    ldi r21, 'B'
	    ret
	F:
	    sbi PORTC, 7
	    sbis PINC, 3
	    ret
	    ldi r21, 'F'
	    ret
	 
	ret
   