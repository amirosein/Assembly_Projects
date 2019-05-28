reset: 
	    cli  
	    ldi r16,0x00
	    out DDRA ,r16 ;define PORT A as Input
        ldi r16,0xFF
        out DDRB,r16 ;define PORT B as Output

  		ldi r16, (1 << ISC11 | 0 << ISC10)
	    out MCUCR, r16 
		ldi r16, (1 << INT0) 
	    out GICR, r16

        ldi r16,0x01
        out PORTB,r16 
;PORT Addresss valid to Data Valid in PIN = tPHL + tPZL +   ;1.5 clk= 41ns+30ns+1.5(62.5)ns = 164.75
;164.75/62.5 = 2.636 so we need 3 clk
	    nop
	    nop
	    nop
	 
		sei
Loop:
	    rjmp Loop

int0_isr:
;fist we check the keys because of high priority
		 ldi r20,8 ;to count which button is pressed
		 in r17,PINA 
		 cmp r17,0xff ;means no key was pressed
 ;so the interrupt is called because of printer
		 breq printer 
key_find:
		 call Delay20ms 
 	     dec r20
		 LSL r17 ;left shift the value of PIN
		BRCC key_found
;if the carry bit cleared we’ve found it
		 rjmp key_find ;again left shift to find the key

key_found:
		mov r18,r20 ;the pressed key is in r18
		 ret  

printer
;first we have to define PORT A as Output
		ldi r16,0xff
		out DDRA,r16 
		ldi r16,0x02 
		out PORTB , r16 ;output strobe High

		ldi r21,0x00 ;counter for number of characters
;give the number of pressed key to PORT A from r18
		out PORTA , r18
		CBI PORTB, 1 ;CP=0
		SBI PORTB, 1 ;CP=1
		CBI PORTB, 2 ;printer strobe Low
		;500ns / 62.5 ns = 8 pulse clk 
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		SBI PORTB, 2 ;printer strobe High
		inc r21		;update the counter
		;CP R21 , Number_of_values
		;BRNE printer
 		reti