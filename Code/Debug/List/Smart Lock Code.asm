
;CodeVisionAVR C Compiler V4.00a 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _Admininterrupt
	JMP  _Setpc
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x2A,0x20
	.DB  0x74,0x6F,0x20,0x4C,0x6F,0x67,0x69,0x6E
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x79
	.DB  0x6F,0x75,0x72,0x20,0x49,0x44,0x3A,0x20
	.DB  0x0,0x25,0x63,0x0,0x57,0x72,0x6F,0x6E
	.DB  0x67,0x20,0x49,0x44,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x50,0x61,0x73,0x73,0x20
	.DB  0x43,0x6F,0x64,0x65,0x3A,0x20,0x0,0x53
	.DB  0x6F,0x72,0x72,0x79,0x2C,0x20,0x57,0x72
	.DB  0x6F,0x6E,0x67,0x20,0x50,0x43,0x0,0x57
	.DB  0x65,0x6C,0x63,0x6F,0x6D,0x20,0x3A,0x25
	.DB  0x73,0x20,0xA,0x20,0x20,0x20,0x44,0x6F
	.DB  0x6F,0x72,0x20,0x69,0x73,0x20,0x6F,0x70
	.DB  0x65,0x6E,0x69,0x6E,0x67,0x0,0xA,0x20
	.DB  0x20,0x44,0x6F,0x6F,0x72,0x20,0x69,0x73
	.DB  0x20,0x43,0x6C,0x6F,0x73,0x65,0x69,0x6E
	.DB  0x67,0x0,0x4E,0x65,0x77,0x20,0x50,0x43
	.DB  0x20,0x73,0x74,0x6F,0x72,0x65,0x64,0x20
	.DB  0x28,0x3A,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x41,0x64,0x6D,0x69,0x6E,0x20,0x50
	.DB  0x43,0x3A,0x20,0x0,0x53,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x49,0x44,0x3A,0x20
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x6E
	.DB  0x65,0x77,0x20,0x50,0x43,0x20,0x3A,0x20
	.DB  0x0,0xA,0x43,0x6F,0x6E,0x74,0x61,0x63
	.DB  0x74,0x20,0x41,0x64,0x6D,0x69,0x6E,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x49,0x44
	.DB  0x20,0x3A,0x20,0x0,0xA,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x4F,0x6C,0x64,0x20,0x50
	.DB  0x43,0x20,0x3A,0x20,0x0,0xA,0x52,0x65
	.DB  0x2D,0x65,0x6E,0x74,0x65,0x72,0x20,0x6E
	.DB  0x65,0x77,0x20,0x50,0x43,0x20,0x3A,0x20
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;char keyPad();
;void startSmartLock();
;void beepSound();
;int findUser(char dig1, char dig2, char dig3);
;unsigned char EE_Read(unsigned int address);
;void EE_Write(unsigned int address, unsigned char data);
;void initialPassCodes(char resetPc);
;int passCodeMatch( int id, char pas1, char pas2 , char pas3 );
;void openDoor();
;void closeDoor();
;void changePass();
;void ContactAdmin();
;void AdminPassChange();
;void newPassCode(int userId  , char dig1  , char dig2 , char dig3);
;void main(void){
; 0000 0022 void main(void){

	.CSEG
_main:
; .FSTART _main
; 0000 0023 // Start Code;
; 0000 0024 startSmartLock();
	RCALL _startSmartLock
; 0000 0025 while (1){
_0x3:
; 0000 0026 char num , dig1 , dig2 , dig3 ,userId ;
; 0000 0027 lcd_clear();
	SBIW R28,5
;	num -> Y+4
;	dig1 -> Y+3
;	dig2 -> Y+2
;	dig3 -> Y+1
;	userId -> Y+0
	RCALL _lcd_clear
; 0000 0028 lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0029 lcd_printf("Press * to Login");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x0
; 0000 002A num = keyPad();
	STD  Y+4,R30
; 0000 002B if(num != '*') continue;
	LDD  R26,Y+4
	CPI  R26,LOW(0x2A)
	BREQ _0x6
	ADIW R28,5
	RJMP _0x3
; 0000 002C lcd_clear();
_0x6:
	RCALL _lcd_clear
; 0000 002D lcd_printf("Enter your ID: ");// Ask for ID
	__POINTW1FN _0x0,17
	RCALL SUBOPT_0x0
; 0000 002E // Take 3 Digit ID and print it to the user
; 0000 002F dig1 = keyPad();
	RCALL SUBOPT_0x1
; 0000 0030 lcd_printf("%c" , dig1);
; 0000 0031 dig2 = keyPad();
; 0000 0032 lcd_printf("%c" , dig2);
; 0000 0033 dig3 = keyPad();
; 0000 0034 lcd_printf("%c" , dig3);
; 0000 0035 delay_ms(1000);
; 0000 0036 
; 0000 0037 // to Know user Id in data or is not Exist
; 0000 0038 userId = findUser(dig1, dig2, dig3 );
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _findUser
	ST   Y,R30
; 0000 0039 lcd_clear();
	RCALL _lcd_clear
; 0000 003A // if User id not exist
; 0000 003B if(userId == 10) {
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x7
; 0000 003C lcd_printf("Wrong ID");
	__POINTW1FN _0x0,36
	RCALL SUBOPT_0x2
; 0000 003D beepSound();
; 0000 003E beepSound();
	RCALL _beepSound
; 0000 003F continue;
	ADIW R28,5
	RJMP _0x3
; 0000 0040 }
; 0000 0041 lcd_printf("Enter Pass Code: ");
_0x7:
	__POINTW1FN _0x0,45
	RCALL SUBOPT_0x0
; 0000 0042 // Take 3 Digit ID and print it to the user
; 0000 0043 dig1 = keyPad();
	RCALL SUBOPT_0x1
; 0000 0044 lcd_printf("%c" , dig1);
; 0000 0045 dig2 = keyPad();
; 0000 0046 lcd_printf("%c" , dig2);
; 0000 0047 dig3 = keyPad();
; 0000 0048 lcd_printf("%c" , dig3);
; 0000 0049 delay_ms(1000);
; 0000 004A 
; 0000 004B lcd_clear();
	RCALL _lcd_clear
; 0000 004C // In case pass does not match
; 0000 004D if(passCodeMatch(userId , dig1 , dig2 , dig3 ) == 0 ){
	LD   R30,Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _passCodeMatch
	SBIW R30,0
	BRNE _0x8
; 0000 004E lcd_printf("Sorry, Wrong PC");
	__POINTW1FN _0x0,63
	RCALL SUBOPT_0x2
; 0000 004F beepSound();
; 0000 0050 continue;
	ADIW R28,5
	RJMP _0x3
; 0000 0051 }
; 0000 0052 
; 0000 0053 lcd_printf("Welcom :%s \n   Door is opening" ,  UsersNames[userId]);
_0x8:
	__POINTW1FN _0x0,79
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDI  R31,0
	RCALL __LSLW3
	SUBI R30,LOW(-_UsersNames)
	SBCI R31,HIGH(-_UsersNames)
	CLR  R22
	CLR  R23
	RCALL SUBOPT_0x3
; 0000 0054 openDoor();
	RCALL _openDoor
; 0000 0055 lcd_clear();
	RCALL _lcd_clear
; 0000 0056 lcd_printf("\n  Door is Closeing");
	__POINTW1FN _0x0,110
	RCALL SUBOPT_0x4
; 0000 0057 closeDoor();
	RCALL _closeDoor
; 0000 0058 }
	ADIW R28,5
	RJMP _0x3
; 0000 0059 
; 0000 005A }
_0x9:
	RJMP _0x9
; .FEND
;interrupt [2] void Admininterrupt(void){
; 0000 005D interrupt [2] void Admininterrupt(void){
_Admininterrupt:
; .FSTART _Admininterrupt
	RCALL SUBOPT_0x5
; 0000 005E AdminPassChange();
	RCALL _AdminPassChange
; 0000 005F }
	RJMP _0x79
; .FEND
;interrupt [3] void Setpc(void){
; 0000 0060 interrupt [3] void Setpc(void){
_Setpc:
; .FSTART _Setpc
	RCALL SUBOPT_0x5
; 0000 0061 changePass();
	RCALL _changePass
; 0000 0062 }
_0x79:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void newPassCode(int userId  , char dig1  , char dig2 , char dig3){
; 0000 0063 void newPassCode(int userId  , char dig1  , char dig2 , char dig3){
_newPassCode:
; .FSTART _newPassCode
; 0000 0064 
; 0000 0065 lcd_clear();
	RCALL SUBOPT_0x6
;	userId -> R20,R21
;	dig1 -> R19
;	dig2 -> R16
;	dig3 -> R17
	RCALL _lcd_clear
; 0000 0066 lcd_printf("New PC stored (:");
	__POINTW1FN _0x0,130
	RCALL SUBOPT_0x4
; 0000 0067 EE_Write(userId*3 , dig1);
	RCALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R19
	RCALL _EE_Write
; 0000 0068 EE_Write(userId*3 + 1 , dig2);
	RCALL SUBOPT_0x7
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R16
	RCALL _EE_Write
; 0000 0069 EE_Write(userId*3 + 2 , dig3);
	RCALL SUBOPT_0x7
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R17
	RCALL _EE_Write
; 0000 006A delay_ms(1500);
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	RCALL _delay_ms
; 0000 006B }
	RJMP _0x2080004
; .FEND
;void AdminPassChange(){
; 0000 006C void AdminPassChange(){
_AdminPassChange:
; .FSTART _AdminPassChange
; 0000 006D 
; 0000 006E char  dig1 , dig2 , dig3 ,userId;
; 0000 006F 
; 0000 0070 lcd_clear();
	RCALL __SAVELOCR4
;	dig1 -> R17
;	dig2 -> R16
;	dig3 -> R19
;	userId -> R18
	RCALL _lcd_clear
; 0000 0071 lcd_printf("Enter Admin PC: ");// Ask for ID
	__POINTW1FN _0x0,147
	RCALL SUBOPT_0x0
; 0000 0072 
; 0000 0073 // Take 3 Digit ID and print it to the user
; 0000 0074 dig1 = keyPad();
	RCALL SUBOPT_0x8
; 0000 0075 lcd_printf("%c" , dig1);
; 0000 0076 dig2 = keyPad();
	RCALL SUBOPT_0x9
; 0000 0077 lcd_printf("%c" , dig2);
; 0000 0078 dig3 = keyPad();
	RCALL SUBOPT_0xA
; 0000 0079 lcd_printf("%c" , dig3);
; 0000 007A delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 007B 
; 0000 007C if(passCodeMatch( 0 , dig1 , dig2 , dig3 ) == 0){
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	BRNE _0xA
; 0000 007D ContactAdmin();
	RCALL _ContactAdmin
; 0000 007E return ;
	RJMP _0x2080006
; 0000 007F }
; 0000 0080 
; 0000 0081 lcd_clear();
_0xA:
	RCALL _lcd_clear
; 0000 0082 lcd_printf("Student ID: ");// Ask for ID
	__POINTW1FN _0x0,164
	RCALL SUBOPT_0x0
; 0000 0083 
; 0000 0084 // Take 3 Digit ID and print it to the user
; 0000 0085 
; 0000 0086 dig1 = keyPad();
	RCALL SUBOPT_0x8
; 0000 0087 lcd_printf("%c" , dig1);
; 0000 0088 dig2 = keyPad();
	RCALL SUBOPT_0x9
; 0000 0089 lcd_printf("%c" , dig2);
; 0000 008A dig3 = keyPad();
	RCALL SUBOPT_0xA
; 0000 008B lcd_printf("%c" , dig3);
; 0000 008C delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 008D 
; 0000 008E // to Know user Id in data or is not Exist
; 0000 008F userId = findUser(dig1, dig2, dig3 );
	RCALL SUBOPT_0xD
; 0000 0090 lcd_clear();
	RCALL _lcd_clear
; 0000 0091 if ( userId == 10 ){
	CPI  R18,10
	BRNE _0xB
; 0000 0092 ContactAdmin();
	RCALL _ContactAdmin
; 0000 0093 return ;
	RJMP _0x2080006
; 0000 0094 }
; 0000 0095 
; 0000 0096 lcd_clear();
_0xB:
	RCALL SUBOPT_0xE
; 0000 0097 lcd_printf("Enter new PC : ");
; 0000 0098 dig1 = keyPad();
	RCALL SUBOPT_0x8
; 0000 0099 lcd_printf("%c" , dig1);
; 0000 009A dig2 = keyPad();
	RCALL SUBOPT_0x9
; 0000 009B lcd_printf("%c" , dig2);
; 0000 009C dig3 = keyPad();
	RCALL SUBOPT_0xA
; 0000 009D lcd_printf("%c" , dig3);
; 0000 009E 
; 0000 009F newPassCode(userId ,dig1 , dig2, dig3 );
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 00A0 }
_0x2080006:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;void ContactAdmin(){
; 0000 00A1 void ContactAdmin(){
_ContactAdmin:
; .FSTART _ContactAdmin
; 0000 00A2 lcd_clear();
	RCALL _lcd_clear
; 0000 00A3 lcd_printf("\nContact Admin");
	__POINTW1FN _0x0,193
	RCALL SUBOPT_0x2
; 0000 00A4 beepSound();
; 0000 00A5 beepSound();
	RCALL _beepSound
; 0000 00A6 }
	RET
; .FEND
;void changePass(){
; 0000 00A7 void changePass(){
_changePass:
; .FSTART _changePass
; 0000 00A8 char dig1 , dig2 , dig3 ,userId ,dig11 , dig22 , dig33 ;
; 0000 00A9 lcd_clear();
	SBIW R28,1
	RCALL __SAVELOCR6
;	dig1 -> R17
;	dig2 -> R16
;	dig3 -> R19
;	userId -> R18
;	dig11 -> R21
;	dig22 -> R20
;	dig33 -> Y+6
	RCALL _lcd_clear
; 0000 00AA lcd_printf("Enter ID : ");
	__POINTW1FN _0x0,208
	RCALL SUBOPT_0x0
; 0000 00AB 
; 0000 00AC dig1 = keyPad();
	RCALL SUBOPT_0x8
; 0000 00AD lcd_printf("%c" , dig1);
; 0000 00AE dig2 = keyPad();
	RCALL SUBOPT_0x9
; 0000 00AF lcd_printf("%c" , dig2);
; 0000 00B0 dig3 = keyPad();
	RCALL SUBOPT_0xA
; 0000 00B1 lcd_printf("%c" , dig3);
; 0000 00B2 
; 0000 00B3 userId = findUser(dig1, dig2, dig3 );
	RCALL SUBOPT_0xD
; 0000 00B4 
; 0000 00B5 if(userId == 10)// if User id not exist
	CPI  R18,10
	BRNE _0xC
; 0000 00B6 {
; 0000 00B7 ContactAdmin();
	RCALL _ContactAdmin
; 0000 00B8 return ;
	RJMP _0x2080005
; 0000 00B9 }
; 0000 00BA 
; 0000 00BB lcd_printf("\nEnter Old PC : ");
_0xC:
	__POINTW1FN _0x0,220
	RCALL SUBOPT_0x0
; 0000 00BC 
; 0000 00BD dig1 = keyPad();
	RCALL SUBOPT_0x8
; 0000 00BE lcd_printf("%c" , dig1);
; 0000 00BF dig2 = keyPad();
	RCALL SUBOPT_0x9
; 0000 00C0 lcd_printf("%c" , dig2);
; 0000 00C1 dig3 = keyPad();
	RCALL SUBOPT_0xA
; 0000 00C2 lcd_printf("%c" , dig3);
; 0000 00C3 
; 0000 00C4 if(passCodeMatch(userId , dig1 , dig2 , dig3 ) == 0 ){
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xC
	BRNE _0xD
; 0000 00C5 ContactAdmin();
	RCALL _ContactAdmin
; 0000 00C6 return ;
	RJMP _0x2080005
; 0000 00C7 }
; 0000 00C8 
; 0000 00C9 lcd_clear();
_0xD:
	RCALL SUBOPT_0xE
; 0000 00CA lcd_printf("Enter new PC : ");
; 0000 00CB dig1 = keyPad();
	RCALL SUBOPT_0x8
; 0000 00CC lcd_printf("%c" , dig1);
; 0000 00CD dig2 = keyPad();
	RCALL SUBOPT_0x9
; 0000 00CE lcd_printf("%c" , dig2);
; 0000 00CF dig3 = keyPad();
	RCALL SUBOPT_0xA
; 0000 00D0 lcd_printf("%c" , dig3);
; 0000 00D1 
; 0000 00D2 
; 0000 00D3 lcd_printf("\nRe-enter new PC : ");
	__POINTW1FN _0x0,237
	RCALL SUBOPT_0x0
; 0000 00D4 dig11 = keyPad();
	MOV  R21,R30
; 0000 00D5 lcd_printf("%c" , dig1);
	RCALL SUBOPT_0x11
	MOV  R30,R17
	RCALL SUBOPT_0x12
; 0000 00D6 dig22 = keyPad();
	RCALL _keyPad
	MOV  R20,R30
; 0000 00D7 lcd_printf("%c" , dig2);
	RCALL SUBOPT_0x11
	MOV  R30,R16
	RCALL SUBOPT_0x12
; 0000 00D8 dig33 = keyPad();
	RCALL _keyPad
	STD  Y+6,R30
; 0000 00D9 lcd_printf("%c" , dig3);
	RCALL SUBOPT_0x11
	MOV  R30,R19
	RCALL SUBOPT_0x12
; 0000 00DA 
; 0000 00DB if (dig1 != dig11 || dig2 != dig22 || dig3 !=dig33   ){
	CP   R21,R17
	BRNE _0xF
	CP   R20,R16
	BRNE _0xF
	LDD  R30,Y+6
	CP   R30,R19
	BREQ _0xE
_0xF:
; 0000 00DC ContactAdmin();
	RCALL _ContactAdmin
; 0000 00DD return ;
	RJMP _0x2080005
; 0000 00DE }
; 0000 00DF newPassCode(userId ,dig1 , dig2, dig3 );
_0xE:
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 00E0 }
_0x2080005:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
;void closeDoor(){
; 0000 00E1 void closeDoor(){
_closeDoor:
; .FSTART _closeDoor
; 0000 00E2 DDRC  |= (1 << 1);
	SBI  0x14,1
; 0000 00E3 PORTC |= (1 << 1);
	SBI  0x15,1
; 0000 00E4 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 00E5 PORTC &= ~(1 << 1);
	CBI  0x15,1
; 0000 00E6 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _0x2080002
; 0000 00E7 }
; .FEND
;void openDoor(){
; 0000 00E8 void openDoor(){
_openDoor:
; .FSTART _openDoor
; 0000 00E9 
; 0000 00EA DDRC  |= (1 << 0);
	SBI  0x14,0
; 0000 00EB PORTC |= (1 << 0);
	SBI  0x15,0
; 0000 00EC delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 00ED PORTC &= ~(1 << 0);
	CBI  0x15,0
; 0000 00EE delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _0x2080002
; 0000 00EF 
; 0000 00F0 }
; .FEND
;int passCodeMatch ( int id , char pas1, char pas2 , char pas3 ){
; 0000 00F1 int passCodeMatch ( int id , char pas1, char pas2 , char pas3 ){
_passCodeMatch:
; .FSTART _passCodeMatch
; 0000 00F2 if(EE_Read(3*id ) == pas1 &&
	RCALL SUBOPT_0x6
;	id -> R20,R21
;	pas1 -> R19
;	pas2 -> R16
;	pas3 -> R17
; 0000 00F3 EE_Read(3*id + 1) == pas2 &&
; 0000 00F4 EE_Read(3*id + 2) == pas3 )
	RCALL SUBOPT_0x7
	MOVW R26,R30
	RCALL _EE_Read
	CP   R19,R30
	BRNE _0x12
	RCALL SUBOPT_0x7
	ADIW R30,1
	MOVW R26,R30
	RCALL _EE_Read
	CP   R16,R30
	BRNE _0x12
	RCALL SUBOPT_0x7
	ADIW R30,2
	MOVW R26,R30
	RCALL _EE_Read
	CP   R17,R30
	BREQ _0x13
_0x12:
	RJMP _0x11
_0x13:
; 0000 00F5 {
; 0000 00F6 return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2080004
; 0000 00F7 }
; 0000 00F8 return 0;
_0x11:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2080004:
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; 0000 00F9 }
; .FEND
;void initialPassCodes(char resetPc){
; 0000 00FA void initialPassCodes(char resetPc){
_initialPassCodes:
; .FSTART _initialPassCodes
; 0000 00FB if ( resetPc == '1' ||
	ST   -Y,R17
	MOV  R17,R26
;	resetPc -> R17
; 0000 00FC EE_Read(0) == 255 &&
; 0000 00FD EE_Read(1) == 255 &&
; 0000 00FE EE_Read(2) == 255  ){
	CPI  R17,49
	BREQ _0x15
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _EE_Read
	CPI  R30,LOW(0xFF)
	BRNE _0x16
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _EE_Read
	CPI  R30,LOW(0xFF)
	BRNE _0x16
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _EE_Read
	CPI  R30,LOW(0xFF)
	BREQ _0x15
_0x16:
	RJMP _0x14
_0x15:
; 0000 00FF EE_Write(0 ,'2' );
	RCALL SUBOPT_0xB
	LDI  R26,LOW(50)
	RCALL _EE_Write
; 0000 0100 EE_Write(1 ,'0' );
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x13
; 0000 0101 EE_Write(2 ,'3' );
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x14
; 0000 0102 
; 0000 0103 EE_Write(3 ,'1' );
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(49)
	RCALL _EE_Write
; 0000 0104 EE_Write(4 ,'2' );
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x15
; 0000 0105 EE_Write(5 ,'9' );
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x16
; 0000 0106 
; 0000 0107 EE_Write(6 ,'3' );
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x14
; 0000 0108 EE_Write(7 ,'2' );
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x15
; 0000 0109 EE_Write(8 ,'5' );
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(53)
	RCALL _EE_Write
; 0000 010A 
; 0000 010B EE_Write(9 ,'4' );
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(52)
	RCALL _EE_Write
; 0000 010C EE_Write(10 ,'2' );
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x15
; 0000 010D EE_Write(11 ,'6' );
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(54)
	RCALL _EE_Write
; 0000 010E 
; 0000 010F EE_Write(12 ,'0' );
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RCALL SUBOPT_0x13
; 0000 0110 EE_Write(13 ,'7' );
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(55)
	RCALL _EE_Write
; 0000 0111 EE_Write(14 ,'9' );
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL SUBOPT_0x16
; 0000 0112 }
; 0000 0113 
; 0000 0114 }
_0x14:
	RJMP _0x2080001
; .FEND
;unsigned char EE_Read(unsigned int address){
; 0000 0115 unsigned char EE_Read(unsigned int address){
_EE_Read:
; .FSTART _EE_Read
; 0000 0116 while(EECR.1 == 1);    //Wait till EEPROM is ready
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	address -> R16,R17
_0x19:
	SBIC 0x1C,1
	RJMP _0x19
; 0000 0117 EEAR = address;        //Prepare the address you want to read from
	__OUTWR 16,17,30
; 0000 0118 EECR.0 = 1;            //Execute read command
	SBI  0x1C,0
; 0000 0119 return EEDR;
	IN   R30,0x1D
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 011A }
; .FEND
;void EE_Write(unsigned int address, unsigned char data){
; 0000 011B void EE_Write(unsigned int address, unsigned char data){
_EE_Write:
; .FSTART _EE_Write
; 0000 011C while(EECR.1 == 1);    //Wait till EEPROM is ready
	RCALL __SAVELOCR4
	MOV  R17,R26
	__GETWRS 18,19,4
;	address -> R18,R19
;	data -> R17
_0x1E:
	SBIC 0x1C,1
	RJMP _0x1E
; 0000 011D EEAR = address;        //Prepare the address you want to read from
	__OUTWR 18,19,30
; 0000 011E EEDR = data;           //Prepare the data you want to write in the address above
	OUT  0x1D,R17
; 0000 011F EECR.2 = 1;            //Master write enable
	SBI  0x1C,2
; 0000 0120 EECR.1 = 1;            //Write Enable
	SBI  0x1C,1
; 0000 0121 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;int findUser(char dig1, char dig2, char dig3){
; 0000 0122 int findUser(char dig1, char dig2, char dig3){
_findUser:
; .FSTART _findUser
; 0000 0123 int i = 0 ;
; 0000 0124 for (  ; i < 5 ; i = i + 1 ) {
	RCALL __SAVELOCR6
	MOV  R19,R26
	LDD  R18,Y+6
	LDD  R21,Y+7
;	dig1 -> R21
;	dig2 -> R18
;	dig3 -> R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0x26:
	__CPWRN 16,17,5
	BRGE _0x27
; 0000 0125 if(UsersIds[i][0] == dig1 &&
; 0000 0126 UsersIds[i][1] == dig2 &&
; 0000 0127 UsersIds[i][2] == dig3 )
	RCALL SUBOPT_0x17
	SUBI R30,LOW(-_UsersIds)
	SBCI R31,HIGH(-_UsersIds)
	LD   R26,Z
	CP   R21,R26
	BRNE _0x29
	RCALL SUBOPT_0x17
	__ADDW1MN _UsersIds,1
	LD   R26,Z
	CP   R18,R26
	BRNE _0x29
	RCALL SUBOPT_0x17
	__ADDW1MN _UsersIds,2
	LD   R26,Z
	CP   R19,R26
	BREQ _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 0128 return i;
	MOVW R30,R16
	RJMP _0x2080003
; 0000 0129 }
_0x28:
	__ADDWRN 16,17,1
	RJMP _0x26
_0x27:
; 0000 012A 
; 0000 012B return 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
_0x2080003:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 012C }
; .FEND
;void startSmartLock(){
; 0000 012D void startSmartLock(){
_startSmartLock:
; .FSTART _startSmartLock
; 0000 012E // interrupts
; 0000 012F bit_set(MCUCR , 1);
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 0130 bit_set(MCUCR , 3);
	IN   R30,0x35
	ORI  R30,8
	OUT  0x35,R30
; 0000 0131 bit_clr(MCUCR , 0);
	IN   R30,0x35
	ANDI R30,0xFE
	OUT  0x35,R30
; 0000 0132 bit_clr(MCUCR , 2);
	IN   R30,0x35
	ANDI R30,0xFB
	OUT  0x35,R30
; 0000 0133 #asm("sei")
	SEI
; 0000 0134 bit_set(GICR , 6);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0135 bit_set(GICR , 7);
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0136 
; 0000 0137 // Set KeyPad port ;
; 0000 0138 DDRB  = 0b00000111;
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 0139 PORTB = 0b11111000;
	LDI  R30,LOW(248)
	OUT  0x18,R30
; 0000 013A // Initiate LCD
; 0000 013B lcd_init(20);
	LDI  R26,LOW(20)
	RCALL _lcd_init
; 0000 013C 
; 0000 013D // Data
; 0000 013E UsersIds[0][0]= '1';
	LDI  R30,LOW(49)
	STS  _UsersIds,R30
; 0000 013F UsersIds[0][1]= '1';
	__PUTB1MN _UsersIds,1
; 0000 0140 UsersIds[0][2]= '1';
	__PUTB1MN _UsersIds,2
; 0000 0141 
; 0000 0142 UsersIds[1][0] ='1';
	__PUTB1MN _UsersIds,3
; 0000 0143 UsersIds[1][1] ='2';
	LDI  R30,LOW(50)
	__PUTB1MN _UsersIds,4
; 0000 0144 UsersIds[1][2] ='6';
	LDI  R30,LOW(54)
	__PUTB1MN _UsersIds,5
; 0000 0145 
; 0000 0146 UsersIds[2][0] ='1';
	LDI  R30,LOW(49)
	__PUTB1MN _UsersIds,6
; 0000 0147 UsersIds[2][1] ='2';
	LDI  R30,LOW(50)
	__PUTB1MN _UsersIds,7
; 0000 0148 UsersIds[2][2] ='8';
	LDI  R30,LOW(56)
	__PUTB1MN _UsersIds,8
; 0000 0149 
; 0000 014A UsersIds[3][0] ='1';
	LDI  R30,LOW(49)
	__PUTB1MN _UsersIds,9
; 0000 014B UsersIds[3][1] ='3';
	LDI  R30,LOW(51)
	__PUTB1MN _UsersIds,10
; 0000 014C UsersIds[3][2] ='0';
	LDI  R30,LOW(48)
	__PUTB1MN _UsersIds,11
; 0000 014D 
; 0000 014E UsersIds[4][0] ='1';
	LDI  R30,LOW(49)
	__PUTB1MN _UsersIds,12
; 0000 014F UsersIds[4][1] ='3';
	LDI  R30,LOW(51)
	__PUTB1MN _UsersIds,13
; 0000 0150 UsersIds[4][2] ='2';
	LDI  R30,LOW(50)
	__PUTB1MN _UsersIds,14
; 0000 0151 
; 0000 0152 
; 0000 0153 UsersNames[0][0] = 'P';
	LDI  R30,LOW(80)
	STS  _UsersNames,R30
; 0000 0154 UsersNames[0][1] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _UsersNames,1
; 0000 0155 UsersNames[0][2] = 'o';
	LDI  R30,LOW(111)
	__PUTB1MN _UsersNames,2
; 0000 0156 UsersNames[0][3] = 'f';
	LDI  R30,LOW(102)
	__PUTB1MN _UsersNames,3
; 0000 0157 
; 0000 0158 
; 0000 0159 UsersNames[1][0] = 'A';
	LDI  R30,LOW(65)
	__PUTB1MN _UsersNames,8
; 0000 015A UsersNames[1][1] = 'h';
	LDI  R30,LOW(104)
	__PUTB1MN _UsersNames,9
; 0000 015B UsersNames[1][2] = 'm';
	LDI  R30,LOW(109)
	__PUTB1MN _UsersNames,10
; 0000 015C UsersNames[1][3] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _UsersNames,11
; 0000 015D UsersNames[1][4] = 'd';
	LDI  R30,LOW(100)
	__PUTB1MN _UsersNames,12
; 0000 015E 
; 0000 015F UsersNames[2][0] = 'A';
	LDI  R30,LOW(65)
	__PUTB1MN _UsersNames,16
; 0000 0160 UsersNames[2][1] = 'm';
	LDI  R30,LOW(109)
	__PUTB1MN _UsersNames,17
; 0000 0161 UsersNames[2][2] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _UsersNames,18
; 0000 0162 
; 0000 0163 UsersNames[3][0] = 'A';
	LDI  R30,LOW(65)
	__PUTB1MN _UsersNames,24
; 0000 0164 UsersNames[3][1] = 'd';
	LDI  R30,LOW(100)
	__PUTB1MN _UsersNames,25
; 0000 0165 UsersNames[3][2] = 'e';
	LDI  R30,LOW(101)
	__PUTB1MN _UsersNames,26
; 0000 0166 UsersNames[3][3] = 'l';
	LDI  R30,LOW(108)
	__PUTB1MN _UsersNames,27
; 0000 0167 
; 0000 0168 
; 0000 0169 UsersNames[4][0] = 'O';
	LDI  R30,LOW(79)
	__PUTB1MN _UsersNames,32
; 0000 016A UsersNames[4][1] = 'm';
	LDI  R30,LOW(109)
	__PUTB1MN _UsersNames,33
; 0000 016B UsersNames[4][2] = 'a';
	LDI  R30,LOW(97)
	__PUTB1MN _UsersNames,34
; 0000 016C UsersNames[4][3] = 'r';
	LDI  R30,LOW(114)
	__PUTB1MN _UsersNames,35
; 0000 016D initialPassCodes('0');
	LDI  R26,LOW(48)
	RCALL _initialPassCodes
; 0000 016E }
	RET
; .FEND
;char keyPad(){
; 0000 016F char keyPad(){
_keyPad:
; .FSTART _keyPad
; 0000 0170 while(1){
_0x2B:
; 0000 0171 // C1
; 0000 0172 PORTB.0 = 0; PORTB.1 = 1; PORTB.2 = 1;
	CBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
; 0000 0173 //Only C1 is activated
; 0000 0174 switch(PINB){
	IN   R30,0x16
; 0000 0175 case 0b11110110:
	CPI  R30,LOW(0xF6)
	BRNE _0x37
; 0000 0176 while (PINB.3 == 0);
_0x38:
	SBIS 0x16,3
	RJMP _0x38
; 0000 0177 return '1';
	LDI  R30,LOW(49)
	RET
; 0000 0178 break;
	RJMP _0x36
; 0000 0179 
; 0000 017A case 0b11101110:
_0x37:
	CPI  R30,LOW(0xEE)
	BRNE _0x3B
; 0000 017B while (PINB.4 == 0);
_0x3C:
	SBIS 0x16,4
	RJMP _0x3C
; 0000 017C return '4';
	LDI  R30,LOW(52)
	RET
; 0000 017D break;
	RJMP _0x36
; 0000 017E 
; 0000 017F case 0b11011110:
_0x3B:
	CPI  R30,LOW(0xDE)
	BRNE _0x3F
; 0000 0180 while (PINB.5 == 0);
_0x40:
	SBIS 0x16,5
	RJMP _0x40
; 0000 0181 return '7';
	LDI  R30,LOW(55)
	RET
; 0000 0182 break;
	RJMP _0x36
; 0000 0183 
; 0000 0184 case 0b10111110:
_0x3F:
	CPI  R30,LOW(0xBE)
	BRNE _0x36
; 0000 0185 while (PINB.6 == 0);
_0x44:
	SBIS 0x16,6
	RJMP _0x44
; 0000 0186 return '*';
	LDI  R30,LOW(42)
	RET
; 0000 0187 break;
; 0000 0188 
; 0000 0189 }
_0x36:
; 0000 018A 
; 0000 018B // C2
; 0000 018C PORTB.0 = 1; PORTB.1 = 0; PORTB.2 = 1;
	SBI  0x18,0
	CBI  0x18,1
	SBI  0x18,2
; 0000 018D //Only C2 is activated
; 0000 018E switch(PINB){
	IN   R30,0x16
; 0000 018F case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0x50
; 0000 0190 while (PINB.3 == 0);
_0x51:
	SBIS 0x16,3
	RJMP _0x51
; 0000 0191 return '2';
	LDI  R30,LOW(50)
	RET
; 0000 0192 break;
	RJMP _0x4F
; 0000 0193 
; 0000 0194 case 0b11101101:
_0x50:
	CPI  R30,LOW(0xED)
	BRNE _0x54
; 0000 0195 while (PINB.4 == 0);
_0x55:
	SBIS 0x16,4
	RJMP _0x55
; 0000 0196 return '5';
	LDI  R30,LOW(53)
	RET
; 0000 0197 break;
	RJMP _0x4F
; 0000 0198 
; 0000 0199 case 0b11011101:
_0x54:
	CPI  R30,LOW(0xDD)
	BRNE _0x58
; 0000 019A while (PINB.5 == 0);
_0x59:
	SBIS 0x16,5
	RJMP _0x59
; 0000 019B return '8';
	LDI  R30,LOW(56)
	RET
; 0000 019C break;
	RJMP _0x4F
; 0000 019D 
; 0000 019E case 0b10111101:
_0x58:
	CPI  R30,LOW(0xBD)
	BRNE _0x4F
; 0000 019F while (PINB.6 == 0);
_0x5D:
	SBIS 0x16,6
	RJMP _0x5D
; 0000 01A0 return '0';
	LDI  R30,LOW(48)
	RET
; 0000 01A1 break;
; 0000 01A2 }
_0x4F:
; 0000 01A3 
; 0000 01A4 // C3
; 0000 01A5 PORTB.0 = 1; PORTB.1 = 1; PORTB.2 = 0;
	SBI  0x18,0
	SBI  0x18,1
	CBI  0x18,2
; 0000 01A6 //Only C3 is activated
; 0000 01A7 switch(PINB){
	IN   R30,0x16
; 0000 01A8 
; 0000 01A9 case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0x69
; 0000 01AA while (PINB.3 == 0);
_0x6A:
	SBIS 0x16,3
	RJMP _0x6A
; 0000 01AB return '3';
	LDI  R30,LOW(51)
	RET
; 0000 01AC break;
	RJMP _0x68
; 0000 01AD 
; 0000 01AE case 0b11101011:
_0x69:
	CPI  R30,LOW(0xEB)
	BRNE _0x6D
; 0000 01AF while (PINB.4 == 0);
_0x6E:
	SBIS 0x16,4
	RJMP _0x6E
; 0000 01B0 return '6';
	LDI  R30,LOW(54)
	RET
; 0000 01B1 break;
	RJMP _0x68
; 0000 01B2 
; 0000 01B3 case 0b11011011:
_0x6D:
	CPI  R30,LOW(0xDB)
	BRNE _0x71
; 0000 01B4 while (PINB.5 == 0);
_0x72:
	SBIS 0x16,5
	RJMP _0x72
; 0000 01B5 return '9';
	LDI  R30,LOW(57)
	RET
; 0000 01B6 break;
	RJMP _0x68
; 0000 01B7 
; 0000 01B8 case 0b10111011:
_0x71:
	CPI  R30,LOW(0xBB)
	BRNE _0x68
; 0000 01B9 while (PINB.6 == 0);
_0x76:
	SBIS 0x16,6
	RJMP _0x76
; 0000 01BA return '#';
	LDI  R30,LOW(35)
	RET
; 0000 01BB break;
; 0000 01BC 
; 0000 01BD }
_0x68:
; 0000 01BE 
; 0000 01BF }
	RJMP _0x2B
; 0000 01C0 }
; .FEND
;void beepSound(){
; 0000 01C1 void beepSound(){
_beepSound:
; .FSTART _beepSound
; 0000 01C2 DDRD  |= (1 << 5);
	SBI  0x11,5
; 0000 01C3 PORTD |= (1 << 5);
	SBI  0x12,5
; 0000 01C4 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01C5 PORTD &= ~(1 << 5);
	CBI  0x12,5
; 0000 01C6 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
_0x2080002:
	RCALL _delay_ms
; 0000 01C7 }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R5,R16
	MOV  R4,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x18
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x18
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	CPI  R17,10
	BREQ _0x2080001
_0x2000004:
	INC  R5
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	MOV  R7,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x19
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x1A
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x1A
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x1B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1C
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x1B
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x1B
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x1A
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x1C
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x1A
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x1C
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G101:
; .FSTART _put_lcd_G101
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printf:
; .FSTART _lcd_printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G101)
	LDI  R31,HIGH(_put_lcd_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_UsersIds:
	.BYTE 0xF
_UsersNames:
	.BYTE 0x28
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RJMP _keyPad

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x1:
	STD  Y+3,R30
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+5
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
	RCALL _keyPad
	STD  Y+2,R30
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+4
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
	RCALL _keyPad
	STD  Y+1,R30
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+3
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RJMP _beepSound

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x3:
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _lcd_printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	RCALL __SAVELOCR6
	MOV  R17,R26
	LDD  R16,Y+6
	LDD  R19,Y+7
	__GETWRS 20,21,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	MOVW R30,R20
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x8:
	MOV  R17,R30
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x9:
	RCALL _keyPad
	MOV  R16,R30
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0xA:
	RCALL _keyPad
	MOV  R19,R30
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R19
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _passCodeMatch
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RCALL _findUser
	MOV  R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL _lcd_clear
	__POINTW1FN _0x0,177
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	MOV  R30,R18
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	ST   -Y,R17
	ST   -Y,R16
	MOV  R26,R19
	RJMP _newPassCode

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	__POINTW1FN _0x0,33
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(48)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(51)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(50)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(57)
	RJMP _EE_Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	__MULBNWRU 16,17,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1A:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12:
__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
