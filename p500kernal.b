; Commodore P500 Kernal 901234-02 with Fastboot Patches from Steve Gray
; disassembled with DA65 18.4.2020 (Info-file from Ulrich Bassewitz)
; modified for ACME assembling by Vossi 05/2020
; v1.1 special f-keys
; v1.2 full ramtest selection (fast test checks only byte $0002 in each page)
; v1.3 all patches selectable
; v1.4 new F-keys for petsd+
; v1.5 superfast video if always in indirect bank 15
; v1.6 add txjmp routine from b-series rev -03 kernal (diag test detects too much RAM banks?)
; v1.7 moved tx-routines in the correct place = 100% identical to cbm2 04a kernal
; v1.8 basic SYS patched - now to selected bank -> Basic $8063 csys vector =  $EDDC-1: $DB, $ED
!cpu 6502
!ct pet		; Standard text/char conversion table -> pet = petscii
!to "kernal.bin", plain
; * switches
STANDARD_FKEYS	= 1	; Standard F-keys
FULL_RAMTEST	= 1	; Standard full and slow RAM-test
STANDARD_VIDEO	= 1	; Standard doublechecked video writes (original kernal unfinished)
;CBMPATCH	= 1	; CBM B-series patches, Vossi $3BF patches
;BANK15_VIDEO	= 1	; Superfast Video if indirect bank is always bank 15 (basic)
;SYSPATCH	= 1	; patched Basic SYS command
; * constants
FILL		= $AA	; Fills free memory areas with $AA
TEXTCOL		= $06	; Default text color:   $06 = blue
BGRCOL		= $01	; background color      $01 = white
EXTCOL		= $03	; exterior color        $03 = cyan
; ########################################### TODO ################################################
; 
; ########################################### BUGS ################################################
;
; ########################################### INFO ################################################
; loop3 E129 = Main loop - wait for key input
; **************************************** DISCLAIMER *********************************************
	;***************************************
	;*                                     *
	;* KK  K EEEEE RRRR  NN  N  AAA  LL    *
	;* KK KK EE    RR  R NNN N AA  A LL    *
	;* KKK   EE    RR  R NNN N AA  A LL    *
	;* KKK   EEEE  RRRR  NNNNN AAAAA LL    *
	;* KK K  EE    RR  R NN NN AA  A LL    *
	;* KK KK EE    RR  R NN NN AA  A LL    *
	;* KK KK EEEEE RR  R NN NN AA  A LLLLL *
	;*                                     *
	;***************************************
	;***************************************
	;* CBM KERNAL                          *
	;*   MEMORY AND I/O DEPENDENT ROUTINES *
	;* DRIVING THE HARDWARE OF THE         *
	;* FOLLOWING CBM MODEL :               *
	;*   P-SERIES (5XX)                    *
	;* COPYRIGHT (C) 1983 BY               *
	;* COMMODORE BUSINESS MACHINES (CBM)   *
	;***************************************
	;
	; 6509  used to extend memory on bc2 & p2 systems
	;   location - used to direct
	;   $0000 -  execution register (4 bits)
	;   $0001 -  indirect  register (4 bits)
	;
	;   these registers provide 4 extra high-order address control lines.  
	;     on 6509 reset all lines are high.
	;
	; current memory map:
	;   segment 15- $ffff-$e000  rom (kernal)
	;               $dfff-$df00  i/o  6525 tpi2
	;               $deff-$de00  i/o  6525 tpi1
	;               $ddff-$dd00  i/o  6551 acia
	;               $dcff-$dc00  i/o  6526 cia
	;               $dbff-$db00  i/o  unused (z80,8088,68008)
	;               $daff-$da00  i/o  6581 sid
	;               $d9ff-$d900  i/o  unused (disks)
	;               $d8ff-$d800  i/o  6569 vic
	;               $d7ff-$d400  color nybles
	;               $d3ff-$d000  video matrix
	;               $cfff-$c000  character dot rom
	;               $bfff-$8000  roms external (language)
	;               $7fff-$4000  roms external (extensions)
	;               $3fff-$2000  rom  external
	;               $1fff-$1000  rom  internal
	;               $0fff-$0400  unused
	;               $03ff-$0002  ram (kernal/basic system)
	;   segment 14- segment 4 open (future expansion)
	;   segment 3 - $ffff-$0002  ram p2 optinal
	;   segment 2 - $ffff-$0002  ram p2 optinal
	;   segment 1 - $ffff-$0002  ram p2 standard
	;   segment 0 - $ffff-$0002  ram p2 standard
	;
	; the 6509 registers appear in locations $0000 and $0001 in all segments of memory.
; ***************************************** ZEROPAGE **********************************************
	e6509		= $00		; 6509 execution bank reg
	i6509		= $01		; 6509 indirect bank reg
	;
	; $02-$8f BASIC zeropage 
	;
	; Kernal page zero variables
	; Kernal indirect address variables
	fnadr		= $90		; Address of file name string
	sal		= $93		; Current load/store address
	sah		= $94		;   low, high, bank
	sas		= $95
	eal		= $96		; End of load/save
	eah		= $97
	eas		= $98
	stal		= $99		; Start of load/save
	stah		= $9A
	stas		= $9B
	; Frequently used kernal variables
	status		= $9C		; I/O operation status
	fnlen		= $9D		; File name length
	la		= $9E		; Current logical index
	fa		= $9F		; Current first address
	sa		= $A0		; Current secondary address
	dfltn		= $A1		; Default input device
	dflto		= $A2		; Default output device
	; Tape buffer pointer
	tape1		= $A3		; Address of tape buffer
	; RS-232 input buffer
	ribuf		= $A6		; Input buffer
	; Variables for kernal speed
	stkey		= $A9		; Stop key flag
	ctemp		= $A9		; used to reduce cassette read times 
	c3po		= $AA		; IEEE buffer flag
	snsw1		= $AA		; used to reduce cassette read times 
	bsour		= $AB		; IEEE character buffer 
	; Cassette temps - overlays IPC buffer
	ipoint		= $AC		; next 2 bytes used for transx code
	syno		= $AC
	dpsw		= $AD
	; next 18 bytes also used for monitor
	ptr1		= $AE		; index to pass1 errors
	ptr2		= $AF		; index to pass2 errors
	pcntr		= $B0
	firt		= $B1
	cntdn		= $B2
	shcnl		= $B3
	rer		= $B4
	rez		= $B5
	rdflg		= $B6
	flagt1		= $B7		; temp during bit read time
	shcnh		= $B7
	cmp0		= $B8
	diff		= $B9
	prp		= $BA
	ochar		= $BB
	prty		= $BC
	fsblk		= $BD
	mych		= $BE
	cdata		= $BF		; how to turn cassette timers on
	; Monitor virtual registers - Place in these locations temporarly...
	pch		= $AE		; counter
	pcl		= $AF
	flgs		= $B0		; Processor status
	acc		= $B1		; Accumulator
	xr		= $B2		; X register
	yr		= $B3		; Y register
	sp		= $B4		; Stack pointer
	xi6509		= $B5		; Old indirection segment
	re6509		= $B6		; Return execution segment
	invh		= $B7		; User interrupt vector
	invl		= $B8
	; Monitor indirect variables
	tmp0		= $B9		; Temp pointer
	tmp2		= $BB		; Temp pointer
	; Other monitor variables
	tmpc		= $BD		; Place to save last cmd
	t6509		= $BE		; Temporary i6509
	ddisk		= $BF		; Default disk unit # for monitor
	; Screen editor page zero variables
	; Editor indirect variables
	pkybuf		= $C0		; Start adr of pgm key
	keypnt		= $C2		; Current pgm key buf
	sedsal		= $C4		; Scroll ptr
	sedeal		= $C6		; Scroll ptr
	pnt		= $C8		; Current character pointer
	; Editor variables for speed & size
	tblx		= $CA		; Cursor line
	pntr		= $CB		; Cursor column
	grmode		= $CC		; Graphic/text mode flag
	lstx		= $CD		; Last character index
	lstp		= $CE		; Screen editor start position
	lsxp		= $CF		; Screen editor start row
	crsw		= $D0		; cr flag - cr pressed -> input from screen
	ndx		= $D1		; Index to keyd queue
	qtsw		= $D2		; Quote mode flag
	insrt		= $D3		; Insert mode flag
	config		= $D4		; Char before blink (petii)
	indx		= $D5		; last byte position on line (##234-02##244-02)
	kyndx		= $D6		; count of program key string
	rptcnt		= $D7		; Deelay tween chars
	delay		= $D8		; Delay to next repeat
	sedt1		= $D9		; Frequently used temp variables
	sedt2		= $DA
	; Frequently used editor variables
	data		= $DB		; Current print data
	sctop		= $DC		; Top screen 0-24 of current window
	scbot		= $DD		; Bottom 0-24
	sclf		= $DE		; Left margin
	scrt		= $DF		; Right margin
	modkey		= $E0		; Keyscanner shift/control flags ($ff-nokey)
	norkey		= $E1		; Keyscanner normal key number ($ff-nokey)
	; Screen editor usage
	bitabl		= $E2		; Wrap bitmap
	blnon		= $E6		; Blinking cursor on
	blncnt		= $E7		; Blink counter
	user		= $E8		; Pointer to color RAM
	tcolor		= $EA		; Temporary color
	blnsw		= $EB		; Blink switch
	color		= $EC		; Character color
	gdcol		= $ED		; Color behind cursor
	saver		= $EE		; Temp store for output char
	scrseg		= $EF		; Segment /bank of video RAM
	; Free zero page space, 16 bytes
	zpend		= $F0
; ***************************************** ABSOLUTE **********************************************
	; System stack area
	stack		= $0100		; Stack
	bad		= $0100		; Cassette bad address table
	stackp		= $01FF		; System Stack pointer transx code
	; -------------------------------------------------------------------------------------------------
	; $200 - $256 Basic's ROM page work area
	buf		= $0200		; Basic input buffer
	; Basic RAM vectors
	ierror		= $0280         ; Basic error indirect
	; -------------------------------------------------------------------------------------------------
	; System RAM vectors
	cinv		= $0300		; IRQ vector
	cbinv		= $0302		; BRK vector
	nminv		= $0304		; NMI vector
	iopen		= $0306		; Open file vector
	iclose		= $0308		; Close file vector
	ichkin		= $030A		; Open channel in vector
	ickout		= $030C		; Open channel out vector
	iclrch		= $030E		; Close channel vector
	ibasin		= $0310		; Input from channel vector 
	ibsout		= $0312		; Output to channel vector
	istop		= $0314		; Check stop key vector
	igetin		= $0316		; Get from queue vector
	iclall		= $0318		; Close all files vector
	iload		= $031A		; Load from file vector
	isave		= $031C		; Save to file vector
	usrcmd		= $031E		; Monitor extension vector
	escvec		= $0320		; User ESC key vector
	ctlvec		= $0322		; unused control key vector
	isecnd		= $0324		; IEEE listen secondary address
	itksa		= $0326		; IEEE talk secondary address
	iacptr		= $0328		; IEEE character in routine
	iciout		= $032A		; IEEE character out routine
	iuntlk		= $032C		; IEEE bus untalk
	iunlsn		= $032E		; IEEE bus unlisten
	ilistn		= $0330		; IEEE listen device primary address
	italk		= $0332		; IEEE talk device primary address
	; Kernal absolute variables
	lat		= $0334		; Logical file numbers / table
	fat		= $033E		; Device numbers / table
	sat		= $0348		; Secondary addresses / table
	;
	lowadr		= $0352		; Start of system memory: low, high, bank
	hiadr		= $0355		; Top of system memory: low, high, bank
	memstr		= $0358		; Start of user memory: low, high, bank
	memsiz		= $035B		; Top of user memory: low, high, bank
	timout		= $035E		; IEEE timeout enable
	verck		= $035F		; load/verify flag
	ldtnd		= $0360		; Device table index
	msgflg		= $0361		; Message flag
	bufpt		= $0362		; Cassette buffer index
	; Kernal temporary (local) variables
	t1		= $0363
	t2		= $0364 
	xsav		= $0365 
	savx		= $0366 
	svxt		= $0367 
	temp		= $0368 
	alarm		= $0369		; IRQ variable holds 6526 IRQ's
	; Kernal cassette variables
	itape		= $036A		; Indirect for cassette code
	cassvo		= $036C		; Cassette read variable
	aservo		= $036D		; Flag1***indicates t1 timeout cassette read
	caston		= $036E		; How to turn on timers
	relsal		= $036F		; moveable start load address
	relsah		= $0370		; 
	relsas		= $0371		; 
	oldinv		= $0372		; restore user IRQ and i6509 after cassettes
	cas1		= $0375		; Cassette switch flag
	; RS-232 information storage
	m51ctr		= $0376		; 6551 control image
	m51cdr		= $0377		; 6551 command image
	rsstat		= $037A		; perm. RS-232 status
	dcdsr		= $037B		; last DCD/DSR value
	ridbs		= $037C		; Input start index
	ridbe		= $037D		; Input end index
	; Screen editor absolute
	; $037E - $037F Block some area for editor
	pkyend		= $0380		; Program key buffer end address
	keyseg		= $0382		; Segment / bank of function key texts
	rvs		= $0383		; Reverse mode flag
	lintmp		= $0384		; Line # between in and out 
	lstchr		= $0385		; Last char printed
	insflg		= $0386		; Insert mode flag
	scrdis		= $0387		; Scroll disable flag
	bitmsk		= $0388		; Temorary bitmask
	keyidx		= $0389		; Index to programmables
	logscr		= $038A		; Logical/physical scroll flag
	bellmd		= $038B		; Bell on/off flag
	pagsav		= $038C		; Temp RAM page
	keysiz		= $038D		; Sizes of function key texts
	tab		= $03A1		; Tabstop flags
	keyd		= $03AB		; Keyboard buffer
	funvec		= $03B5		; Vector: funktion key handler
	iwrtvrm		= $03B7		; Vector: video ram write routine
	iwrtcrm		= $03B9		; Vector: color ram write routine
	iunkwn1		= $03BB		; Vector: -> E039 nofunc
	iunkwn2		= $03BD		; Vector: -> E039 nofunc
	unknwn		= $03BF		; unknown from old editor (some flag like quote or insert?)
	; $03C0 - $3F7 Free absolute space
	absend		= $03C0
	; System warm start variables and vectors
	evect		= $03F8		; Warm start vector and flags 5 bytes
	; -------------------------------------------------------------------------------------------------
	; Free bank 15 RAM 1024 bytes
	ramloc          = $0400		; First free ram location
	; -------------------------------------------------------------------------------------------------
	; Kernal inter-process communication variables 
	ipbsiz		= 16            ; Ipc buffer size
	ipb		= $0800		; IPC buffer
	ijtab		= ipb+ipbsiz	; IPC jump table
	ipptab		= $0910		; IPC param spec table
	; Ipc buffer offsets
	ipccmd		= 0		; Ipc command
	ipcjmp		= 1		; Ipc jump address
	ipcin		= 3		; Ipc #input bytes
	ipcout		= 4		; Ipc #output bytes
	ipcdat		= 5		; Ipc data buffer (8 bytes max)
; *************************************** IO / EQUATES ********************************************
	; Equates
		irom	= $F		; System bank
		id55hz	= 14		; 55hz value required by ioinit
		warm	= $A5		; Warm start flag
		winit	= $5A  		; Initialization complete flag
		llen	= 40            ; Screen length
		nrows	= 25            ; Scrren length
		scxmax	= llen-1        ; Max column number
		scymax	= nrows-1       ; Max line number
		keymax	= 9             ; Keyboard buffer size - 1
		dblzer	= 89            ; Key code for double zero
		pgmkys	= 20            ; Number of progam keys
	; Tape block types
		eot	= 5             ; End of tape
		blf	= 1             ; Basic load file
		bdf	= 2             ; Basic data file
		bdfh	= 4             ; Basic data file header
		bufsz	= 192           ; Buffer size
		cr	= $d            ; Carriage return
	; ROM / RAM addresses
		basic	= $8000		; Start of ROM (language)
		chrrom	= $C000		; Character ROM
		scnram	= $D000		; Video RAM
		clrram	= $D400		; Color RAM nibbles
		kernal	= $E000		; Start of ROM (kernal)
	; 6569 VIC Video interface device
		vic	= $D800		; VIC
		memptr	= $18		; VIC memory pointers register
	; 6581 SID Sound interface device
		sid	= $DA00
		osc1	= $00		; base addresses osc1, osc2, osc3
		osc2	= $07
		osc3	= $0E
		freqlo	= $00		; osc registers
		freqhi	= $01
		pulsef	= $02
		pulsec	= $03
		oscctl	= $04
		atkdcy	= $05
		susrel	= $06
		fclow	= $15		; filter control
		fchi	= $16
		resnce	= $17
		volume	= $18
		potx	= $19		; pots, random number and env3 out
		poty	= $1A
		random	= $1B
		env3	= $1C
	; 6526 CIA for inter-process communication
		ipcia	= $DB00
		; pra  = data port
		; prb0 = busy1 (1=>6509 off dbus)
		; prb1 = busy2 (1=>8088/z80 off dbus)
		; prb2 = semaphore 8088/z80
		; prb3 = semaphore 6509
		; prb4 = unused
		; prb5 = unused
		; prb6 = irq to 8088/z80 (lo)
		; prb7 = unused
		sem88	= $04	; prb bit2
		sem65	= $08	; prb bit3
	; 6526 CIA Complex interface adapter - game / IEEE data / user
		; timer a: ieee local / cass local / music / game
		; timer b: ieee deadm / cass deadm / music / game
		;
		; pra0: ieee data1 / user / paddle game 1
		; pra1: ieee data2 / user / paddle game 2
		; pra2: ieee data3 / user
		; pra3: ieee data4 / user
		; pra4: ieee data5 / user
		; pra5: ieee data6 / user
		; pra6: ieee data7 / user / game trigger 14
		; pra7: ieee data8 / user / game trigger 24
		;
		; prb0: user / game 10
		; prb1: user / game 11
		; prb2: user / game 12
		; prb3: user / game 13
		; prb4: user / game 20
		; prb5: user / game 21
		; prb6: user / game 22
		; prb7: user / game 23
		;
		; flag: user / cassette read
		cia	= $DC00
		pra	= $0	; Data reg A
		prb	= $1	; Data reg B
		ddra	= $2	; Direction reg a
		ddrb	= $3	; Direction reg b
		talo	= $4	; Timer A low  byte
		tahi	= $5	; Timer A high byte
		tblo	= $6	; Timer B low  byte
		tbhi	= $7	; Timer B high byte
		tod10	= $8	; 10ths of seconds
		todsec	= $9	; Seconds
		todmin	= $A	; Minutes
		todhr	= $B	; Hours
		sdr	= $C	; Serial data register
		icr	= $D	; Interrupt control register
		cra	= $E	; Control register A
		crb	= $F	; Control register B
	; 6551 ACIA RS-232 and network interface
		acia	= $DD00
		drsn	= $0	; Transmitt/receive data register
		srsn	= $1	; Status register
		cdr	= $2	; Command register
		ctr	= $3	; Control register
		; Equates
		dsrerr	= $40	; Data set ready error
		dcderr	= $20	; Data carrier detect error
		doverr	= $08	; Receiver outer buffer overrun
	; 6525 TPI1 Triport interface device #1 - IEEE control / cassette / network / vic / irq
		tpi1	= $DE00
		; pa0: ieee dc control (ti parts)
		; pa1: ieee te control (ti parts) (t/r)
		; pa2: ieee ren
		; pa3: ieee atn
		; pa4: ieee dav
		; pa5: ieee eoi
		; pa6: ieee ndac
		; pa7: ieee nrfd
		;
		; pb0: ieee ifc
		; pb1: ieee srq
		; pb2: network transmitter enable
		; pb3: network receiver enable
		; pb4: arbitration logic switch
		; pb5: cassette write
		; pb6: cassette motor
		; pb7: cassette switch
		;
		; irq0: 50/60 hz irq
		; irq1: ieee srq
		; irq2: 6526 irq
		; irq3: (opt) 6526 inter-processor
		; irq4: 6551
		; *irq: 6569 (vic) / user devices
		; cb:   vic dot select - cr #7-6 11=bank 15, 01=bank 0
		; ca:   vic matrix select - cr #5-4 11=bank 15, 01=bank 0
		pa	= $0	; Port register A
		pb	= $1	; Port register B
		pc	= $2	; Port register C
		lir	= $2	; Interrupt latch register mc=1
		ddpa	= $3	; Data direction register A
		ddpb	= $4	; Data direction register B
		ddpc	= $5	; Data direction register C
		mir	= $5	; Interrupt mask register mc=1
		creg	= $6	; Control reg: #0 mc=IRQ mode / #1 ip= IRQ parity / #2-3 edge i3,i4	
		air	= $7	; Active interrupt register
		; Equates
		dc	= $01	; 75160/75161 control line
		te	= $02	; 75160/75161 control line
		ren	= $04	; Remote enable
		atn	= $08	; Attention
		dav	= $10	; Data available
		eoi	= $20	; End or identify
		ndac	= $40	; Not data accepted
		nrfd	= $80	; Not ready for data
		ifc	= $01	; Interface clear
		srq	= $02	; Service request
		;
		rddb	= nrfd+ndac+te+dc+ren	;directions for receiver
		tddb	= eoi+dav+atn+te+dc+ren	;directions for transmitt
		;
		eoist	= $40	; eoi status test
		tlkr	= $40	; device is talker
		lstnr	= $20	; device is listener
		utlkr	= $5f	; device untalk
		ulstn	= $3f	; device unlisten
		;       
		toout	= $01	; timeout status on output
		toin	= $02	; timeout status on input
		eoist	= $40	; eoi on input
		nodev	= $80	; no device on bus.
		sperr	= $10	; verify error
		; Equates for c3p0 flag bits 6 and 7.
		slock	= $40	; screen editor lock-out
		dibf	= $80	; data in output buffer
	; 6525 TPI2 Triport interface device #2
		tpi2	= $DF00
		; pa: kyrd out 8-15
		; pb: kybd out 0-7
		;
		; pc0: kybd in 0
		; pc1: kybd in 1
		; pc2: kybd in 2
		; pc3: kybd in 3
		; pc4: kybd in 4
		; pc5: kybd in 5
		; pc6: vic 16k bank select low
		; pc7: vic 16k bank select hi
; **************************************** COLD START *********************************************
!initmem FILL                   ; All unused memory filled with $AA
!zone cold
*= kernal
jmoncld:jmp monoff		; Monitor cold start
	nop
; ****************************************** EDITOR ***********************************************
	;***************************************
	;*                                     *
	;* EEEEE DDD   IIIII TTTTT  OOO  RRRR  *
	;* E     D  D    I     T   O   O R   R *
	;* E     D   D   I     T   O   O R   R *
	;* EEE   D   D   I     T   O   O RRRR  *
	;* E     D   D   I     T   O   O R R   *
	;* E     D  D    I     T   O   O R  R  *
	;* EEEE  DDD   IIIII   T    OOO  R   R *
	;*                                     *
	;***************************************
	;***************************************
	;*   CBM EDITOR FOR P-SERIES SYSTEMS   *
	;*   KEYBOARD AND SCREEN EDIT ROUTINES *
	;* DRIVING THE HARDWARE OF THE         *
	;* FOLLOWING CBM MODELS:               *
	;*   P-SERIES                          *
	;* COPYRIGHT (C) 1983 BY               *
	;* COMMODORE BUSINESS MACHINES (CBM)   *
	;***************************************
!zone editor
*= kernal+4
;****************************************
;
;  40 column pet ii screen editor
;    with unlimited screen line wrap
;
;****************************************
; E004 Jump vector table
jcint:  jmp cint		; Init Screen editor, VIC, F-keys
jlp2:	jmp lp2			; Read a key from keyboard to A
jloop5:	jmp loop5		; Read character from screen to A
jprt:	jmp prt			; Print character from A on screen
jscror:	jmp scrorg		; Return screen dimensions to X, Y
jkey:	jmp scnkey		; Keyboard scan
jmvcur: jmp nofunc		; not used in P500 - only for CRTC hardware cursor in b-series
jplot:  jmp plot		; Get/set the cursor position to/from X, Y
jiobas:	jmp iobase		; Return CIA base address to X, Y
jescrt:	jmp escape		; Handle an escape sequence
jfunky:	jmp keyfun		; Get/set/list function keys
; -------------------------------------------------------------------------------------------------
; E025 Get/set the cursor position
plot:   bcs rdplt		; if C=1 get cursor position
; set cursor
	stx tblx		; store line, last line 
	stx lsxp
	sty pntr		; store column, last column
	sty lstp
!ifdef CBMPATCH{		; ********** cbmii revision -03 PATCH **********
	jsr stupt		; Change pointer to this new line
rdplt:  ldx tblx
	ldy pntr		; load column, row
nofunc: rts
} else{
	jsr sreset		; set full screen window
	jsr stupt		; Change pointer to this new line
; get cursor pos
rdplt:  ldx tblx		; load row, column
	ldy pntr
nofunc: rts
}
*= $E03A
; -------------------------------------------------------------------------------------------------
; E03A Return CIA base address
iobase: ldx #<cia
	ldy #>cia
	rts
; -------------------------------------------------------------------------------------------------
; E03F Return screen dimensions
scrorg: ldx #llen		; 40 columns
	ldy #nrows		; 25 rows
	rts
; -------------------------------------------------------------------------------------------------
; $E044 Screen editor init (editor, F-Keys, VIC)
; Clear editor variables
cint:   lda #$00
	ldx #zpend-keypnt-1	; $C2-$EF
cloop1: sta keypnt,x		; clear page 0 variables
	dex
	bpl cloop1
	ldx #absend-rvs-1	; $38D-$3C9
cloop2: sta keysiz,x		; clear absolute variables but fkey alocatations
	dex
	bpl cloop2
; init some variables
	lda #irom
	sta scrseg		; store bank with video RAM = system bank
	lda #$0C
	sta blncnt		; init blink counter
	sta blnon
; init F-keys
	lda pkybuf
	ora pkybuf+1
	bne keycpy		; just copy f-keys if buffers are already alocatated
	lda hiadr
	sta pkyend		; get end of key area
	lda hiadr+1
	sta pkyend+1
	lda #$40		; NO SENSE - will be overwritten in alocat                
	ldx #$00	
	ldy #$02
	jsr aloca		; get 512 bytes at end of system memory $FEFF
	bcs noroom		; no room found...just reset the screen
	sta keyseg		; store bank for F-keys
	inx
	stx pkybuf		; save start address (returned X+1)
	bne room10
	iny
room10: sty pkybuf+1
keycpy: ldy #keyend-keydef	; load size of F-key texts
	jsr pagkey		; switch to indirect bank with key buffer
kyset1: lda keydef-1,y
	dey
	sta (pkybuf),y		; copy key texts to buffer
	bne kyset1
	jsr pagres    		; restore indirect bank
	ldy #$0A		; 10 F-key length bytes
kyset2: lda keylen-1,y
	sta keysiz-1,y		; copy F-key text length to $38D
	dey
	bne kyset2
; init VIC, screen
noroom: jsr sreset		; set full screen window
	ldx #$11		; init vic regs $21-$11
	ldy #$21
vicint:	lda tvic-1,x
	jsr wrtvic		; write A to VIC register Y
	dey
	dex
	bne vicint
	jsr txcrt		; set text mode
	ldx #$0A
edvecl: lda edvect-1,x		; copy extended editor vector table to $3B5
	sta funvec-1,x
	dex
	bne edvecl
	lda #TEXTCOL
	sta color		; init color
; E0C8 Clear screen, cursor home
clsr:	jsr nxtd		; Start at top of window
cls10:	jsr scrset		; set screen pointers
	jsr clrln		; clear the line
	cpx scbot		; done ?
	inx
	bcc cls10		; no
; E0D3 Cursor home
nxtd:   ldx sctop		; move to top
	stx tblx
	stx lsxp		; for input after home or clear
stu10:  ldy sclf		; left of the screen window
	sty pntr
	sty lstp
; E0DF Reset screen ptr to line begin
stupt:	ldx tblx		; get curent line index
; E0F1 Set screen ptr to line X 
scrset: lda ldtab2,x		; load start of screen line low
	sta pnt			; and store to screen, color RAM ptr
	sta user
	lda ldtab1,x		; load high
	sta pnt+1		; and store to char pointer
	and #$03
	ora #>clrram		; calc color RAM high and store to color RAM ptr
	sta user+1
	rts
; -------------------------------------------------------------------------------------------------
; *** Input routines ***
; E0F4 Remove character from queue
lp2:  	ldx kyndx		; are there any pgm keys
	beq lp3			; branch if not
	ldy keyidx		; get index to current char
	jsr pagkey		; switch to indirect bank with key buffer
	lda (keypnt),y		; get current byt
	jsr pagres		; restore indirect bank
	dec kyndx		; 1 byte down
	inc keyidx		; bump index to next char
	cli
	rts
; No F-key
lp3: 	ldy keyd		; get key from irq buffer
	ldx #$00
lp1:  	lda keyd+1,x		; shift key buffer
	sta keyd,x
	inx
	cpx ndx			; shift till last key in buffer
	bne lp1
	dec ndx			; decrease key index
	tya			; return char in A
	cli
	rts
; -------------------------------------------------------------------------------------------------
; E11F Screen input
loop4:	jsr prt			; print the character
!ifdef CBMPATCH{		; ********** Vossi p500 $3BF PATCH **********
	jmp loop3
} else{
	asl unknwn
	lsr unknwn		; clear bit#7 in $03BF
}
*= $E128
; E128 Main loop - wait for key input
loop3:  lda ndx			; check key and pgm-key index
	ora kyndx
	sta blnon
	beq loop3		; loop - wait for key input
; key available
	sei			; disable interrupts
	lda blnsw
	beq lp21		; skip if cursor blink already switched off
	lda config		; load char before blink
	ldy #$00
	sty blnsw		; switch off cursor blink
	ldx gdcol		; load color behind cursor
	jsr dspcol		; write char before blink
; check key
lp21:	jsr lp2			; get char from queue
	cmp #$0D
	bne loop4		; print char if not cr
; return recognized
	sta crsw		; set cr flag - we pass chars now
	jsr fndend		; check nxt line for cont (double line?)
	stx lintmp		; save last line number of sentence
	jsr fistrt		; find begining of line
	lda #$00
	sta qtsw		; clear quote mode
	ldy sclf		; retrieve from line start if left it
	lda lsxp		; input started row
	bmi lp80		; flag we left start line
	cmp tblx
	bcc lp80
	ldy lstp		; input started column
	cmp lintmp		; on start line
	bne lp70
	cpy indx		; past start column
	beq lp75		; ok if the same
lp70:	bcs clp2		; yes - null input
lp75:	sta tblx		; start from here on input
lp80:	sty pntr
	jmp lop5		; input a line
; -------------------------------------------------------------------------------------------------
; E174 Read character from screen
loop5:	tya
	pha
	txa
	pha
	lda crsw		; passing chars to input
	beq loop3		; no - buffer on screen
	bpl lop5		; not done - get next char
clp2:	lda #$00		; input done clear flag
	sta crsw
	lda #$0D		; pass a return
	bne clp7
lop5:	jsr stupt		; set pnt and user
	jsr get1ch		; get a screen char
; convert screencode to petscii
	sta data		; store screen code for bit#5,6,7 check temporary
	and #$3F		; clear bit#6,7 in A
	asl data		; check: scrcode bit#7->C
	bit data		; check: scrcode bit#6->N, #5->V (shiftet to left)
	bpl loop54		; skip if scrcode #6=0 x0x -> 00x
	ora #$80		; x1x -> 10x
loop54:	bcc loop52		; skip if scrcode #7=0 (not reverse)
	ldx qtsw
	bne loop53		; skip if bit#7=1 & quote on: 10x -> 00x, 11x -> 10x
				; if quote off or bit#7=0:
loop52:	bvs loop53		; skip if scrcode #5=1: 001 -> 001, 011 -> 101
	ora #$40		; 000 -> 010, 100 -> 110
loop53:	jsr qtswc
	ldy tblx		; on input end line ?
	cpy lintmp
	bcc clp00		; no
	ldy pntr		; on input end column ?
	cpy indx
	bcc clp00		; no
	ror crsw		; c=1 minus flags last char sent
	bmi clp1		; always
clp00:	jsr nxtchr		; at next char
clp1:	cmp #$DE		; a pi ?
	bne clp7		; no
	lda #$FF		; translate
clp7:	sta data
	pla
	tax
	pla
	tay
	lda data		; return petscii char in A
	rts
; -------------------------------------------------------------------------------------------------
; *** Test for quote mode ***
; E1C8 Switch quote mode depending on in A
qtswc:	cmp #$22
	bne qtswl		; skip if no quote-char
	lda qtsw
	eor #$01		; toggle quoteswitch
	sta qtsw
	lda #$22		; restore quote in A
qtswl:	rts
; -------------------------------------------------------------------------------------------------
; E1D5 *** Output chars ***
nxt3:	bit rvs
	bpl nvs
	ora #$80
nvs:	ldx insrt
	beq nvsa
	dec insrt
nvsa:	bit insflg		; are we in auto insert mode?
	bpl nvs1		; branch if not
	pha			; save the char
	jsr insert		; make room for this char
	ldx #$00
	stx insrt		; make sure we turn off insert mode.
	pla			; restore char
nvs1:	jsr dsppcc		; display the character
	jsr movchr		; move to next char pos
; -------------------------------------------------------------------------------------------------
; E1F6 ********* exit from prt *********
loop2:	lda data		; copy last char
	sta lstchr
	pla
	tay
	lda insrt
	beq lop2
	lsr qtsw		; clear quote switch if in insert mode
lop2:	pla
	tax
	pla
	rts
; -------------------------------------------------------------------------------------------------
;********************************
; Display a character
;********************************
; E207 Write blank ($20) at cusor position
doblnk: lda #' '		; load blank
; E209 Write char A with color or tcolor if color bit#7=1
dsppcc: ldx color		; load char color
	bpl dspcol
; E20D Write char A with tcolor
dsptco: ldx tcolor
; E20f Write char A with color X and set blink counter
dspcol: ldy #$02
	sty blncnt		; blink cusor
; E213 Write char A with color X
dspp:   ldy pntr		; load column
	jsr pagscr		; switch to screen ibank
	jsr jwrvrm		; write char to screen
	pha
	txa			; move color to A
	jsr jwrcrm		; write color to color RAM
	pla
	jmp pagres    		; restore indirect bank
; -------------------------------------------------------------------------------------------------
; E224 Subroutine to clear one line
;                  x = line number
;         clrln :  blank entire line
;         clrprt:  y = starting column position
clrln:	ldy sclf		; load left margin
	jsr clrbit		; make sure non-continued line
clrprt:	txa
	pha			; save X
	lda pntr
	pha			; remember column
	dey
clr10:	iny
	sty pntr
	jsr doblnk		; print a blank
	cpy scrt		; line completely blank?
	bne clr10		; branch if not
	pla
	sta pntr
	pla
	tax
	rts
; -------------------------------------------------------------------------------------------------
; E23F Grab a character from screen
get1ch: ldy pntr		; get char/color index
; E241 Get char from column Y
getych: jsr pagscr		; switch to screen ibank
	lda (pnt),y		; get the character
	pha
	lda #$00
	ora (user),y		; get color (ORA = always systembank)
	sta tcolor		; and store it to tcolor
	pla
	jmp pagres      	; restore indirect bank
; -------------------------------------------------------------------------------------------------
; E251 Set text/graphic mode (C=1 graphic)
ctext:	bcs grcrt		; skip if graphic mode
txcrt:	ldy #$02		; set Bit#1 for text character set   
	bne crtset
grcrt:	ldy #$00		; clear Bit#1 for graphic char set
crtset: sty grmode		; store new mode
	lda vic+memptr		; load vic memory pointers register
	and #$FD
	ora grmode		; clear bit #1 and set to desired mode (char-ROM base-adr bit#11)
	ldy #memptr
	jmp wrtvic		; write VIC memory pointers reg
; -------------------------------------------------------------------------------------------------
;**************************************************
;   Handle ram paging
;**************************************************
; E267 Switch to indirect bank with key buffer
pagkey: pha
	lda keyseg              ; for function key page
	jmp pagsub
; E26E Switch to indirect bank with video screen
pagscr: pha
	lda scrseg              ; for screen memory bank
pagsub: pha
	lda i6509		; get current page number
	sta pagsav              ; - and save it
	pla
	sta i6509               ; switch to new ibank
	pla                     ; restore a-reg
	rts
; -------------------------------------------------------------------------------------------------
; E27C Restore indirect bank
pagres: pha			; save a-reg
	lda pagsav		; get saved ram page number
	sta i6509               ; restore ram page number
	pla			; restore a-reg
	rts
; -------------------------------------------------------------------------------------------------
; E284 *** Print a char ***
prt:	pha
	cmp #$FF
	bne prt10
	lda #$DE		; convert pi character
prt10:	sta data		; save char
	txa			; save regs
	pha
	tya
	pha
	lda #$00		; clear cr flag
	sta crsw
	ldy pntr		; column we are in
	lda data
	and #$7F
	cmp #$20		; test if control character (< $20)
	bcc ntcn		; yes
!ifndef CBMPATCH{		; ********** Vossi p500 $3BF PATCH **********
	ldx qtsw		; test if in quote mode...
	beq njt1		; if not, skip
	ldx unknwn		; ?
	beq njt2
	jsr junkwn1		; vector -> nofunc (rts)
	lda data
	jmp njt2
njt1:	ldx insrt		; test if in insert mode
	bne njt2		; if not, skip
	bit unknwn		; ?
	bpl njt2
	jsr junkwn1		; vector -> nofunc (rts)
	lda data
	cmp #$22
	beq njt10
	jmp loop2
}
njt2:	ldx lstchr		; was last char an esc
	cpx #$1B
	bne njt10
	jsr escseq
	jmp loop2
njt10:	and #$3F		; no - make a screen char
njt20:	bit data
	bpl njt30		; skip ahead if normal set - 00 - 3f
	ora #$40		; convert a0 - bf to 60 - 7f & c0 - df to 40 - 5f
njt30:	jsr qtswc		; test for quote
	jmp nxt3		; put on screen
*= $E2E0
; E2E0 ********* Control keys *********
ntcn:	cmp #$0D		; test if a return
	beq ntcn20		; no inverse if yes
!ifdef CBMPATCH{		; ********** Vossi p500 $3BF PATCH **********
	cmp #$14		; test if insert or delete
	beq ntcn20		; allow in insert or quote mode
	cmp #$1b		; test if escape key
	bne ntcn1
	bit data
	bmi ntcn1		; its a $9b
	lda qtsw		; test if in quote mode...
	ora insrt		; ...or insert mode
	beq ntcn20		; if not, go execute remaining code
	jsr toqm		; else go turn off all modes
	sta data		; and forget about this character
	beq ntcn20		; always
ntcn1	cmp #$03		; test if a run/load or stop
} else{
	cmp #$1B		; test if escape key
	bne ntcn1
	bit data
	bmi ntcn1		; its a $9b
	lda qtsw		; test if in quote mode...
	ora insrt		; ...or insert mode
	beq ntcn20		; if not, go execute remaining code
	jsr toqm		; else go turn off all modes
	sta data		; and forget about this character
	beq ntcn20		; always
ntcn1:	cmp #$03		; test if a run/load or stop
	beq ntcn20
	cmp #$14		; test if insert or delete
}
	beq ntcn20		; no inverse if yes
	ldy insrt		; test if in insert mode
	bne ntcn10		; go reverse - if yes
	ldy qtsw		; check for quote mode
	beq ntcn20		; do not reverse if not
ntcn10:	ora #$80		; make reverse
	bne njt20
ntcn20:	lda data
	asl			; set carry if shifted ctrl
	tax
	jsr ctdsp		; indirect jsr
	jmp loop2
*= $E317
; E317 Control code dispatcher
ctdsp:	lda ctable+1,x		; hi byte
	pha
	lda ctable,x		; low byte
	pha
	lda data
	rts			; indirect jmp
; -------------------------------------------------------------------------------------------------
; E322 User control code jump vector
cuser:	jmp (ctlvec)
; -------------------------------------------------------------------------------------------------
; E325 Cursor down/up
cdnup:  bcs cup			; cursor up

cdwn:	jsr nxln
cdn10:	jsr getbit		; a wrapped line ?
	bcs cdrts		; skip if yes
	sec			; flag we left line
	ror lsxp

cdrts:  clc
	rts
; E334 Cursor up
cup:	ldx sctop		; cursor up
	cpx tblx		; at top of window ?
	bcs critgo		; yes - do nothing
cup10:	jsr cdn10		; about to wrap to a new line ?
	dec tblx		; up a line
	jmp stupt
; -------------------------------------------------------------------------------------------------
; E342 Cursor right/left
crtlf:  bcs cleft		; cursor left

crit:	jsr nxtchr		; cursor right
	bcs cdn10		; yes - test for wrap

critgo: rts
; E34A Cursor left
cleft:  jsr bakchr		; move back
	bcs critgo		; abort if at top left
	bne cdrts		; no - exit
	inc tblx
	bne cup10		; go set flag if needed
; -------------------------------------------------------------------------------------------------
; E355 RVS on/off
rvsf:   eor #$80
	sta rvs
	rts
; -------------------------------------------------------------------------------------------------
; E35B Home/clear
homclr:	bcc homes		; if C=0 home
	jmp clsr		; Clear screen, cursor home
; E360 Cursor home
homes:	cmp lstchr		; last char a home ?
	bne hm110		; no
	jsr sreset		; top=0,left=0,bot=nrows-1,rt=cols-1
hm110:  jmp nxtd		; set to top left
; -------------------------------------------------------------------------------------------------
; E36B Tab function
tabit:  ldy pntr
	bcs tabtog		; a tab toggle
tab1:	cpy scrt		; at right of window
	bcc tab2		; no - tab to next
	lda scrt		; set to screen right
	sta pntr
	rts

tab2:   iny			; find next tab stop
	jsr gettab
	beq tab1		; not yet !
	sty pntr
	rts
; E381 Toggle tabulator
tabtog: jsr gettab		; flip tab stop
	eor bitmsk
	sta tab,x
	rts
; -------------------------------------------------------------------------------------------------
; E38B Skip to next line
; wrap to top if scroll disabled
nxln:	ldx tblx
	cpx scbot		; of the bottom of window ?
	bcc nxln1		; no
	bit scrdis		; what if scrolling is disabled?
	bpl doscrl		; branch if scroll is enabled
	lda sctop		; wrap to top
	sta tblx
	bcs nowhop		; always

doscrl:	jsr scrup		; scroll it all
	clc			; indicate scroll ok
nxln1:	inc tblx
nowhop:	jmp stupt		; set line base adr
; -------------------------------------------------------------------------------------------------
; E3A5 A return or shift return
nxt1:   jsr fndend		; find the end of the current line
	inx
	jsr clrbit		; set next line as non-continued
	ldy sclf		; else point to start of next line
	sty pntr
	jsr nxln		; set up next line
	jmp toqm		; turn off all modes

; -------------------------------------------------------------------------------------------------
; E3B6
movlin: lda     ldtab2,x                        ; E3B6 BD 3A EC                 .:.
	sta     sedeal                          ; E3B9 85 C6                    ..
	sta     sedsal                          ; E3BB 85 C4                    ..
	lda     ldtab1,x                        ; E3BD BD 53 EC                 .S.
	sta     sedsal+1                        ; E3C0 85 C5                    ..
	and     #$03                            ; E3C2 29 03                    ).
	ora     #$D4                            ; E3C4 09 D4                    ..
	sta     sedeal+1                        ; E3C6 85 C7                    ..
	jsr pagscr			; switch to screen ibank
movl10: lda     (sedsal),y                      ; E3CB B1 C4                    ..
	jsr     jwrvrm				; write char to screen
	lda     #$00                            ; E3D0 A9 00                    ..
	ora     (sedeal),y                      ; E3D2 11 C6                    ..
	jsr     jwrcrm				; write color to color RAM
	cpy     scrt                            ; E3D7 C4 DF                    ..
	iny                                     ; E3D9 C8                       .
	bcc     movl10                          ; E3DA 90 EF                    ..
	jmp pagres    			; restore indirect bank

; -------------------------------------------------------------------------------------------------
; E3DF Scroll down
scrdwn: ldx     lsxp                            ; E3DF A6 CF                    ..
	bmi     scd30                           ; E3E1 30 06                    0.
	cpx     tblx                            ; E3E3 E4 CA                    ..
	bcc     scd30                           ; E3E5 90 02                    ..
	inc     lsxp                            ; E3E7 E6 CF                    ..
scd30:  ldx     scbot                           ; E3E9 A6 DD                    ..
scd10:  jsr     scrset                          ; E3EB 20 E1 E0                  ..
	ldy     sclf                            ; E3EE A4 DE                    ..
	cpx     tblx                            ; E3F0 E4 CA                    ..
	beq     scd20                           ; E3F2 F0 0E                    ..
	dex                                     ; E3F4 CA                       .
	jsr     getbt1                          ; E3F5 20 A8 E4                  ..
	inx                                     ; E3F8 E8                       .
	jsr     putbt1                          ; E3F9 20 B4 E4                  ..
	dex                                     ; E3FC CA                       .
	jsr     movlin                          ; E3FD 20 B6 E3                  ..
	bcs     scd10                           ; E400 B0 E9                    ..
scd20:  jsr     clrln                          ; E402 20 24 E2                  $.
	jmp     setbit                          ; E405 4C C3 E4                 L..

; -------------------------------------------------------------------------------------------------
; E408 Scroll up
scrup:  ldx     sctop                           ; E408 A6 DC                    ..
scru00: inx                                     ; E40A E8                       .
	jsr     getbt1                          ; E40B 20 A8 E4                  ..
	bcc     scru15                          ; E40E 90 0A                    ..
	cpx     scbot                           ; E410 E4 DD                    ..
	bcc     scru00                          ; E412 90 F6                    ..
	ldx     sctop                           ; E414 A6 DC                    ..
	inx                                     ; E416 E8                       .
	jsr     clrbit                          ; E417 20 B6 E4                  ..
scru15: dec     tblx                            ; E41A C6 CA                    ..
	bit     lsxp                            ; E41C 24 CF                    $.
	bmi     scru20                          ; E41E 30 02                    0.
	dec     lsxp                            ; E420 C6 CF                    ..
scru20: ldx     sctop                           ; E422 A6 DC                    ..
	cpx     sedt2                           ; E424 E4 DA                    ..
	bcs     scru30                          ; E426 B0 02                    ..
	dec     sedt2                           ; E428 C6 DA                    ..
scru30: jsr     scr10                           ; E42A 20 3F E4                  ?.
	ldx     sctop                           ; E42D A6 DC                    ..
	jsr     getbt1                          ; E42F 20 A8 E4                  ..
	php                                     ; E432 08                       .
	jsr     clrbit                          ; E433 20 B6 E4                  ..
	plp                                     ; E436 28                       (
	bcc     scru10                          ; E437 90 05                    ..
	bit     logscr                          ; E439 2C 8A 03                 ,..
	bmi     scrup                           ; E43C 30 CA                    0.
scru10: rts                                     ; E43E 60                       `

; -------------------------------------------------------------------------------------------------
; E43F
scr10:  jsr     scrset                          ; E43F 20 E1 E0                  ..
	ldy     sclf                            ; E442 A4 DE                    ..
	cpx     scbot                           ; E444 E4 DD                    ..
	bcs     scr40                           ; E446 B0 0E                    ..
	inx                                     ; E448 E8                       .
	jsr     getbt1                          ; E449 20 A8 E4                  ..
	dex                                     ; E44C CA                       .
	jsr     putbt1                          ; E44D 20 B4 E4                  ..
	inx                                     ; E450 E8                       .
	jsr     movlin                          ; E451 20 B6 E3                  ..
	bcs     scr10                           ; E454 B0 E9                    ..
; E456 Test for slow scroll
scr40:  jsr     clrln                          ; E456 20 24 E2                  $.
	ldx     #$FF                            ; E459 A2 FF                    ..
	ldy     #$FE                            ; E45B A0 FE                    ..
	jsr     getlin                          ; E45D 20 9A E4                  ..
	and     #$20                            ; E460 29 20                    ) 
	bne     scr80                           ; E462 D0 15                    ..
; E464 Slow scroll delay loop
scr60:  nop                                     ; E464 EA                       .
	nop                                     ; E465 EA                       .
	dex                                     ; E466 CA                       .
	bne     scr60                           ; E467 D0 FB                    ..
	dey                                     ; E469 88                       .
	bne     scr60                           ; E46A D0 F8                    ..
scr70:  sty     ndx                             ; E46C 84 D1                    ..
scr75:  ldx     #$7F                            ; E46E A2 7F                    ..
	stx     tpi2+pa                         ; E470 8E 00 DF                 ...
	ldx     #$FF                            ; E473 A2 FF                    ..
	stx     tpi2+pb                         ; E475 8E 01 DF                 ...
	rts                                     ; E478 60                       `

; -------------------------------------------------------------------------------------------------
; E479 Scroll stop
scr80:  ldx     #$F7                            ; E479 A2 F7                    ..
	ldy     #$FF                            ; E47B A0 FF                    ..
	jsr     getlin                          ; E47D 20 9A E4                  ..
	and     #$10                            ; E480 29 10                    ).
	bne     scr75                           ; E482 D0 EA                    ..
scr90:  jsr     getlin                          ; E484 20 9A E4                  ..
	and     #$10                            ; E487 29 10                    ).
	beq     scr90                           ; E489 F0 F9                    ..
scr95:  ldy     #$00                            ; E48B A0 00                    ..
	ldx     #$00                            ; E48D A2 00                    ..
	jsr     getlin                          ; E48F 20 9A E4                  ..
	and     #$3F                            ; E492 29 3F                    )?
	eor     #$3F                            ; E494 49 3F                    I?
	beq     scr95                           ; E496 F0 F3                    ..
	bne     scr70                           ; E498 D0 D2                    ..
; E49A Keyboard check for slow scroll
getlin: sei                                     ; E49A 78                       x
	stx     tpi2+pa                         ; E49B 8E 00 DF                 ...
	sty     tpi2+pb                         ; E49E 8C 01 DF                 ...
	jsr     getkey                          ; E4A1 20 EA E9                  ..
	cli                                     ; E4A4 58                       X
	rts                                     ; E4A5 60                       `

; -------------------------------------------------------------------------------------------------
; E4A6 Check for a double length line
getbit: ldx tblx		; load current line
; E4a8 Check line X for double length
getbt1: jsr bitpos		; Find bit table position for line X
	and bitabl,x		; check if bit for line is set in table
	cmp #$01
	jmp bitout		; return 0 if not a double length line
; -------------------------------------------------------------------------------------------------
; E4B2 Mark current line as double length C=1, unmark C=0
putbit: ldx tblx		; load current line
; E4B4 Mark line X as double length C=1, unmark C=0
putbt1: bcs setbit		; branch to mark line if C=1
; E4B6 Clear double length line mark
clrbit: jsr bitpos		; Find bit table position for line X
	eor #$FF		; bit value = 0
	and bitabl,x		; clear bit
bitsav: sta bitabl,x		; and store it to table at byte position X
bitout: ldx bitmsk		; Move byte table position to X
	rts
; -------------------------------------------------------------------------------------------------
; E4C3 Mark a double length line
setbit: bit scrdis
	bvs getbt1		; branch if scrolling is disabled
	jsr bitpos		; Find bit table position for line X
	ora bitabl,x		; set bit in table
	bne bitsav		; branch always to save byte to table
; Find bit table position for line X
bitpos: stx bitmsk		; remember line
	txa
	and #$07		; isolate bit#0-2
	tax
	lda bits,x		; load bit value from table
	pha			; remember it
	lda bitmsk
	lsr			; divide line by 8 for byte position in bit table
	lsr
	lsr
	tax			; move byte pos to X
	pla			; return bit value in A
	rts
; -------------------------------------------------------------------------------------------------
;**********************************
; ***** Move to start of line
;
; E4E2 Find line start/end
	bcc fndend		; if C=0 find line end - NOT USED
; E4E5 cursor to line start (esc-j)
fndfst:	ldy sclf
	sty pntr		; set to leftmost column
fistrt:	jsr getbit		; find start of current line
	bcc fnd0		; branch if found
	dec tblx		; up a line
	bpl fistrt		; always
	inc tblx		; whoops went too far
fnd0:	jmp stupt		; set line base adr
; -------------------------------------------------------------------------------------------------
; ****** Find last non-blank char of line
; pntr= column #
; tblx= line #
;
; E4F7 cursor to end of line (esc-k)
fndend:	inc tblx
	jsr getbit		; is this line continued
	bcs fndend		; branch if so
	dec tblx		; found it - compensate for inc tblx
	jsr stupt		; reset screen pointer to line start
	ldy scrt		; get right margin
	sty pntr		; point to right margin
	bpl eloup2		; always
eloup1:	jsr bakchr		; backup one char
	bcs endbye		; if at top left get out
eloup2: jsr get1ch		; get char from screen
	cmp #$20
	bne endbye		; yes, space
	cpy sclf		; are we at the left margin?
	bne eloup1		; branch if not
	jsr getbit		; if we're on a wraped line
	bcs eloup1		; always scan the above line
endbye: sty indx		; remember this
	rts
; -------------------------------------------------------------------------------------------------
; E521 Move to next char
; scroll if enabled
; wrap to top if disabled
nxtchr:	pha
	ldy pntr
	cpy scrt		; are we at the right margin?
	bcc bumpnt		; branch if not
	jsr nxln		; point to nextline
	ldy sclf		; point to first char of 1st line
	dey
	sec			; set to show moved to new line
bumpnt:	iny			; increment char index
	sty pntr
	pla
	rts
; -------------------------------------------------------------------------------------------------
; E534 Backup one char - Move one char left
; wrap up and stop a top left
bakchr:	ldy pntr
	dey
	bmi bakot1
	cpy sclf		; are we at the left margin
	bcs bakout		; no - past it
bakot1:	ldy sctop
	cpy tblx		; are we at top line last character?
	bcs bakot2		; leave with carry set
	dec tblx		; else backup a line
	pha
	jsr stupt		; set line base adr
	pla
	ldy scrt		; move cursor to right side
bakout: sty pntr
	cpy scrt		; set z-flag if moved to new line
	clc			; always clear
bakot2: rts
; -------------------------------------------------------------------------------------------------
; E552
savpos: ldy     pntr                            ; E552 A4 CB                    ..
	sty     sedt1                           ; E554 84 D9                    ..
	ldx     tblx                            ; E556 A6 CA                    ..
	stx     sedt2                           ; E558 86 DA                    ..
	rts                                     ; E55A 60                       `

; -------------------------------------------------------------------------------------------------
; E55B
delins: bcs     insert                          ; E55B B0 34                    .4
delete: jsr     cleft                           ; E55D 20 4A E3                  J.
	jsr     savpos                          ; E560 20 52 E5                  R.
	bcs     delout                          ; E563 B0 0F                    ..
deloop: cpy     scrt                            ; E565 C4 DF                    ..
	bcc     delop1                          ; E567 90 16                    ..
	ldx     tblx                            ; E569 A6 CA                    ..
	inx                                     ; E56B E8                       .
	jsr     getbt1                          ; E56C 20 A8 E4                  ..
	bcs     delop1                          ; E56F B0 0E                    ..
	jsr     doblnk                          ; E571 20 07 E2                  ..
delout: lda     sedt1                           ; E574 A5 D9                    ..
	sta     pntr                            ; E576 85 CB                    ..
	lda     sedt2                           ; E578 A5 DA                    ..
	sta     tblx                            ; E57A 85 CA                    ..
	jmp     stupt                          ; E57C 4C DF E0                 L..

; -------------------------------------------------------------------------------------------------
; E57F
delop1: jsr     nxtchr                         ; E57F 20 21 E5                  !.
	jsr     get1ch                          ; E582 20 3F E2                  ?.
	jsr     bakchr                          ; E585 20 34 E5                  4.
	jsr     dsptco                           ; E588 20 0D E2                  ..
	jsr     nxtchr                         ; E58B 20 21 E5                  !.
	jmp     deloop                          ; E58E 4C 65 E5                 Le.

; -------------------------------------------------------------------------------------------------
; E591
insert: jsr     savpos                          ; E591 20 52 E5                  R.
	jsr     fndend                          ; E594 20 F7 E4                  ..
	cpx     sedt2                           ; E597 E4 DA                    ..
	bne     ins10                           ; E599 D0 02                    ..
	cpy     sedt1                           ; E59B C4 D9                    ..
ins10:  bcc     ins50                           ; E59D 90 21                    .!
	jsr     movchr                          ; E59F 20 DB E5                  ..
	bcs     insout                          ; E5A2 B0 22                    ."
ins30:  jsr     bakchr                          ; E5A4 20 34 E5                  4.
	jsr     get1ch                          ; E5A7 20 3F E2                  ?.
	jsr     nxtchr                         ; E5AA 20 21 E5                  !.
	jsr     dsptco                           ; E5AD 20 0D E2                  ..
	jsr     bakchr                          ; E5B0 20 34 E5                  4.
	ldx     tblx                            ; E5B3 A6 CA                    ..
	cpx     sedt2                           ; E5B5 E4 DA                    ..
	bne     ins30                           ; E5B7 D0 EB                    ..
	cpy     sedt1                           ; E5B9 C4 D9                    ..
	bne     ins30                           ; E5BB D0 E7                    ..
	jsr     doblnk                          ; E5BD 20 07 E2                  ..
ins50:  inc     insrt                           ; E5C0 E6 D3                    ..
	bne     insout                          ; E5C2 D0 02                    ..
	dec     insrt                           ; E5C4 C6 D3                    ..
insout: jmp     delout                          ; E5C6 4C 74 E5                 Lt.

; -------------------------------------------------------------------------------------------------
; E5C9
stprun: bcc     runrts                          ; E5C9 90 0F                    ..
	sei                                     ; E5CB 78                       x
	ldx     #$09                            ; E5CC A2 09                    ..
	stx     ndx                             ; E5CE 86 D1                    ..
runlop: lda     runtb-1,x
	sta     tab+9,x                         ; E5D3 9D AA 03                 ...
	dex                                     ; E5D6 CA                       .
	bne     runlop                          ; E5D7 D0 F7                    ..
	cli                                     ; E5D9 58                       X
runrts: rts                                     ; E5DA 60                       `

; -------------------------------------------------------------------------------------------------
; E5DB
movchr: cpy     scrt                            ; E5DB C4 DF                    ..
	bcc     movc10                          ; E5DD 90 0B                    ..
	ldx     tblx                            ; E5DF A6 CA                    ..
	cpx     scbot                           ; E5E1 E4 DD                    ..
	bcc     movc10                          ; E5E3 90 05                    ..
	bit     scrdis                          ; E5E5 2C 87 03                 ,..
	bmi     movc30                          ; E5E8 30 17                    0.
movc10: jsr     stupt                          ; E5EA 20 DF E0                  ..
	jsr     nxtchr                         ; E5ED 20 21 E5                  !.
	bcc     movc30                          ; E5F0 90 0F                    ..
	jsr     getbit                          ; E5F2 20 A6 E4                  ..
	bcs     movc20                          ; E5F5 B0 09                    ..
	sec                                     ; E5F7 38                       8
	bit     scrdis                          ; E5F8 2C 87 03                 ,..
	bvs     movc30                          ; E5FB 70 04                    p.
	jsr     scrdwn                          ; E5FD 20 DF E3                  ..
movc20: clc                                     ; E600 18                       .
movc30: rts                                     ; E601 60                       `

; -------------------------------------------------------------------------------------------------
; E602 
chkcol:	ldy #$10		; there's 16 colors
chk1a:	dey
	bmi chk1b
	cmp coltab,y
	bne chk1a
	sty color		; change the color
	rts
chk1b:	jmp cuser
; -------------------------------------------------------------------------------------------------
; E612 Write a byte to the VIC chip
!ifdef STANDARD_VIDEO{          ; ********** Standard video **********
wrtvic: sta saver               ; remember value
wrtvrpt:lda saver
	sta vic,y               ; store value to VIC register
	eor vic,y               ; check stored value
	beq wrtvok              ; jump to end if success
	cpy #$20
	bcs wrtvg20             ; jump if reg >= $20
	cpy #$11
	bcc wrtvrpt             ; write again if register < $10 is different
	and wrtvtbl - $11,y     ; clear unused bits with register mask table 
	bne wrtvrpt             ; write register again if different
wrtvg20:and #$0F                ; clear upper nibble because only bit#0-3 used
	bne wrtvrpt             ; write register again if different
wrtvok: lda saver
	rts
wrtvtbl:!byte $7F,$00,$00,$00,$FF,$3F,$FF,$FE
	!byte $00,$0F,$FF,$FF,$FF,$FF,$FF
} else{                         ; ********** Fast video PATCH **********
wrtvic: sta vic,y
	rts
}
*= $E641
; -------------------------------------------------------------------------------------------------
; E641 Write char A to screen at current line, column Y
!ifdef STANDARD_VIDEO{		; ********** Standard video **********
wrvram:	sta saver		; remember value
wrtrrpt:lda saver
	sta (pnt),y		; store to screen RAM
	lda (pnt),y		; load from screen
	eor saver		; check if same
	bne wrtrrpt		; repeat store if not equal
	lda saver
	rts
} else{                         ; ********** Fast video PATCH **********
wrvram:	sta (pnt),y		; store byte to screen line pointer + coulmn X
	rts
}
*= $E650
; -------------------------------------------------------------------------------------------------
; E650 Write color to color RAM at current line, column Y
!ifdef STANDARD_VIDEO{          ; ********** Standard video **********
wrcram:	sta saver		; remember value
	lda i6509
	pha			; remember indirect bank
	lda #irom
	sta i6509		; switch to system bank
wrtcrpt:lda saver
	sta (user),y		; store to color RAM
	eor (user),y		; check if same
	and #$0F		; load and isolate low nibble
	bne wrtcrpt		; repeat if not equal
	pla
	sta i6509		; restore ibank
	lda saver
	rts
} else{
!ifdef BANK15_VIDEO{            ; ********** Video bank15 PATCH **********
wrcram:	sta (user),y		; store to color RAM
	rts
	} else{                 ; ********** Fast video PATCH **********
wrcram:	sta saver		; remember value
	lda i6509
	pha			; remember indirect bank
	lda #irom
	sta i6509		; switch to system bank
	lda saver
	sta (user),y		; store to color RAM
	pla
	sta i6509		; restore ibank
	lda saver
	rts
}
}
*= $E669
; -------------------------------------------------------------------------------------------------
; E669
junkwn1:jmp (iunkwn1)		; vector -> nofunc (rts)
; -------------------------------------------------------------------------------------------------
; E66C
junkwn2:jmp (iunkwn2)		; vector -> nofunc (rts)
; -------------------------------------------------------------------------------------------------
; E66F Jump vector: Write char to screen
jwrvrm:jmp     (iwrtvrm)		; -> $03B7 -> $E641
; -------------------------------------------------------------------------------------------------
; E672 Jump vector: Write color to color RAM
jwrcrm:jmp     (iwrtcrm)		; -> $03B9 -> $E650
; -------------------------------------------------------------------------------------------------
; E675 Ring the bell
bell:   lda     bellmd                          ; E675 AD 8B 03                 ...
	bne     LE6A2                           ; E678 D0 28                    .(
	lda     #$0F                            ; E67A A9 0F                    ..
	sta     sid+volume                      ; E67C 8D 18 DA                 ...
	lda     #$00                            ; E67F A9 00                    ..
	sta     sid+osc1+atkdcy                        ; E681 8D 05 DA                 ...
	lda     #$F8                            ; E684 A9 F8                    ..
	sta     sid+osc1+susrel                        ; E686 8D 06 DA                 ...
	lda     #$40                            ; E689 A9 40                    .@
	sta     sid+osc1+freqhi                    ; E68B 8D 01 DA                 ...
	lda     #$80                            ; E68E A9 80                    ..
	sta     sid+osc3+freqhi                    ; E690 8D 0F DA                 ...
	ldx     #$15                            ; E693 A2 15                    ..
	stx     sid+osc1+oscctl                       ; E695 8E 04 DA                 ...
	ldy     #$00                            ; E698 A0 00                    ..
LE69A:  iny                                     ; E69A C8                       .
	nop                                     ; E69B EA                       .
	bne     LE69A                           ; E69C D0 FC                    ..
	dex                                     ; E69E CA                       .
	stx     sid+osc1+oscctl                       ; E69F 8E 04 DA                 ...
LE6A2:  rts                                     ; E6A2 60                       `

; -------------------------------------------------------------------------------------------------
; E6A3 Clear last input number
ce:     lda     pntr                            ; E6A3 A5 CB                    ..
	pha                                     ; E6A5 48                       H
LE6A6:  ldy     pntr                            ; E6A6 A4 CB                    ..
	dey                                     ; E6A8 88                       .
	jsr     getych                          ; E6A9 20 41 E2                  A.
	cmp     #$2B                            ; E6AC C9 2B                    .+
	beq     LE6B4                           ; E6AE F0 04                    ..
	cmp     #$2D                            ; E6B0 C9 2D                    .-
	bne     LE6BC                           ; E6B2 D0 08                    ..
LE6B4:  dey                                     ; E6B4 88                       .
	jsr     getych                          ; E6B5 20 41 E2                  A.
	cmp     #$05                            ; E6B8 C9 05                    ..
	bne     LE6D6                           ; E6BA D0 1A                    ..
LE6BC:  cmp     #$05                            ; E6BC C9 05                    ..
	bne     LE6C4                           ; E6BE D0 04                    ..
	dey                                     ; E6C0 88                       .
	jsr     getych                          ; E6C1 20 41 E2                  A.
LE6C4:  cmp     #$2E                            ; E6C4 C9 2E                    ..
	bcc     LE6D6                           ; E6C6 90 0E                    ..
	cmp     #$2F                            ; E6C8 C9 2F                    ./
	beq     LE6D6                           ; E6CA F0 0A                    ..
	cmp     #$3A                            ; E6CC C9 3A                    .:
	bcs     LE6D6                           ; E6CE B0 06                    ..
	jsr     delete                          ; E6D0 20 5D E5                  ].
	jmp     LE6A6                           ; E6D3 4C A6 E6                 L..

LE6D6:  pla                                     ; E6D6 68                       h
	cmp     pntr                            ; E6D7 C5 CB                    ..
	bne     LE6A2                           ; E6D9 D0 C7                    ..
	jmp     delete                          ; E6DB 4C 5D E5                 L].

; -------------------------------------------------------------------------------------------------
; E6DE Handle an escape sequence
escseq: jmp (escvec)

; -------------------------------------------------------------------------------------------------
; E6E1 Insert a line (esc-i)
iline:  jsr scrdwn
	jsr stu10
	inx
	jsr getbt1
	php
	jsr putbit
	plp
	bcs linrts
	sec
	ror lsxp
linrts: rts
; -------------------------------------------------------------------------------------------------
	bcs iline
; E6F8 Delete a line (esc-d)
dline:  jsr fistrt
	lda sctop
	pha
	lda tblx
	sta sctop
	lda logscr
	pha
	lda #$80
	sta logscr
	jsr scru15
	pla
	sta logscr
	lda sctop
	sta tblx
	pla
	sta sctop
	sec
	ror lsxp
	jmp stu10
; -------------------------------------------------------------------------------------------------
; E71F Erase to end of line (esc-q)
etoeol: clc
	!byte $24               ; skips next instruction with bit $xx
; E721 Erase to start of line (esc-p)
etosol: sec
	jsr savpos                          ; E722 20 52 E5                  R.
	bcs LE739                           ; E725 B0 12                    ..
LE727:  jsr clrprt                          ; E727 20 29 E2                  ).
	inc tblx                            ; E72A E6 CA                    ..
	jsr stupt                          ; E72C 20 DF E0                  ..
	ldy sclf                            ; E72F A4 DE                    ..
	jsr getbit                          ; E731 20 A6 E4                  ..
	bcs LE727                           ; E734 B0 F1                    ..
etout:  jmp delout                          ; E736 4C 74 E5                 Lt.
; -------------------------------------------------------------------------------------------------
; E739
LE739:  jsr doblnk                          ; E739 20 07 E2                  ..
	cpy sclf                            ; E73C C4 DE                    ..
	bne LE745                           ; E73E D0 05                    ..
	jsr getbit                          ; E740 20 A6 E4                  ..
	bcc etout                           ; E743 90 F1                    ..
LE745:  jsr bakchr                          ; E745 20 34 E5                  4.
	bcc LE739                           ; E748 90 EF                    ..
;*****************************
; scroll up
;*****************************
; E74A Scroll upwards (esc-v)
esuup:	clc
	!byte $24               ; skips next instruction with bit $xx
; E74C Scroll downwards (esc-w)
esddn:	sec
; E74D Scroll screen depending on carry
suup:	jsr savpos
	bcs sddn
	txa
	pha
	jsr scrup
	pla
	sta sedt2
	jmp etout
;*****************************
; scroll down
;*****************************
sddn:   jsr getbit
	bcs sddn2
	sec
	ror lsxp		; set flag - left line
sddn2:  lda sctop
	sta tblx		; scroll from screen top
	jsr scrdwn
	jsr clrbit		; make first line non-continued
	jmp etout
; -------------------------------------------------------------------------------------------------
;**************************************
; Turn off all modes
;   expected to return zero
;**************************************
; E772 Reset modes: insert, reverse, quote
toqm:	lda #0
	sta insrt
	sta rvs
	sta qtsw
!ifndef CBMPATCH{		; ********** Vossi p500 $3BF PATCH **********
	sta unknwn
}
	rts
*= $E77F
; -------------------------------------------------------------------------------------------------
; E77F Allow scrolling (esc-l)
scrsw0: clc
	bcc scrsw
; E782 Disallow scrolling (esc-m)
scrsw1:sec
scrsw:  lda #$00
	ror
	sta scrdis
	rts
; -------------------------------------------------------------------------------------------------
; E78A Insert mode off
insoff: clc                                     ; E78A 18                       .
	bcc     inssw                           ; E78B 90 01                    ..
; E78D Insert mode on
inson:  sec                                     ; E78D 38                       8
inssw:  lda     #$00                            ; E78E A9 00                    ..
	ror                                     ; E790 6A                       j
	sta     insflg                          ; E791 8D 86 03                 ...
	rts                                     ; E794 60                       `
; -------------------------------------------------------------------------------------------------
; E795
logoff: clc                                     ; E795 18                       .
	bcc     logsw                           ; E796 90 01                    ..
logon:  sec                                     ; E798 38                       8
logsw:  lda     #$00                            ; E799 A9 00                    ..
	ror                                     ; E79B 6A                       j
	sta     logscr                          ; E79C 8D 8A 03                 ...
	rts                                     ; E79F 60                       `
; -------------------------------------------------------------------------------------------------
; E7A0 Not used - removed in patch 3
unused:	lda     unknwn                           ; E7A0 AD BF 03                 ...
	eor     #$C0                            ; E7A3 49 C0                    I.
	sta     unknwn                           ; E7A5 8D BF 03                 ...
	rts                                     ; E7A8 60                       `
; -------------------------------------------------------------------------------------------------
; E7A9 Get/set/list function keys
keyfun: dey                                     ; E7A9 88                       .
	bmi     listkey                         ; E7AA 30 03                    0.
	jmp     addkey                          ; E7AC 4C 6C E8                 Ll.

; -------------------------------------------------------------------------------------------------
; E7AF List function keys
listkey:ldy     #$00                            ; E7AF A0 00                    ..
listlp: iny                                     ; E7B1 C8                       .
	sty     sedt1                           ; E7B2 84 D9                    ..
	dey                                     ; E7B4 88                       .
	lda     keysiz,y                        ; E7B5 B9 8D 03                 ...
	beq     nodefn                          ; E7B8 F0 77                    .w
	sta     keyidx                          ; E7BA 8D 89 03                 ...
	jsr     findky                          ; E7BD 20 15 EA                  ..
	sta     keypnt                          ; E7C0 85 C2                    ..
	stx     keypnt+1                        ; E7C2 86 C3                    ..
	ldx     #$03                            ; E7C4 A2 03                    ..
preamb: lda     keword,x                        ; E7C6 BD 56 E8                 .V.
	jsr     jbsout                          ; E7C9 20 53 E8                  S.
	dex                                     ; E7CC CA                       .
	bpl     preamb                          ; E7CD 10 F7                    ..
	ldx     #$2F                            ; E7CF A2 2F                    ./
	lda     sedt1                           ; E7D1 A5 D9                    ..
	sec                                     ; E7D3 38                       8
ky2asc: inx                                     ; E7D4 E8                       .
	sbc     #$0A                            ; E7D5 E9 0A                    ..
	bcs     ky2asc                          ; E7D7 B0 FB                    ..
	adc     #$3A                            ; E7D9 69 3A                    i:
	cpx     #$30                            ; E7DB E0 30                    .0
	beq     nosec                           ; E7DD F0 06                    ..
	pha                                     ; E7DF 48                       H
	txa                                     ; E7E0 8A                       .
	jsr     jbsout                          ; E7E1 20 53 E8                  S.
	pla                                     ; E7E4 68                       h
nosec:  jsr     jbsout                          ; E7E5 20 53 E8                  S.
	ldy     #$00                            ; E7E8 A0 00                    ..
	lda     #$2C                            ; E7EA A9 2C                    .,
	ldx     #$06                            ; E7EC A2 06                    ..
LE7EE:  cpx     #$08                            ; E7EE E0 08                    ..
	beq     LE7F5                           ; E7F0 F0 03                    ..
	jsr     jbsout                          ; E7F2 20 53 E8                  S.
LE7F5:  php                                     ; E7F5 08                       .
	jsr pagkey				; switch to indirect bank with key buffer
	lda     (keypnt),y                      ; E7F9 B1 C2                    ..
	jsr pagres    			; restore indirect bank
	plp                                     ; E7FE 28                       (
	cmp     #$0D                            ; E7FF C9 0D                    ..
	beq     LE83C                           ; E801 F0 39                    .9
	cmp     #$8D                            ; E803 C9 8D                    ..
	beq     LE83C                           ; E805 F0 35                    .5
	cmp     #$22                            ; E807 C9 22                    ."
	beq     LE840                           ; E809 F0 35                    .5
	cpx     #$08                            ; E80B E0 08                    ..
	beq     lstk10                          ; E80D F0 09                    ..
	pha                                     ; E80F 48                       H
	lda     #$22                            ; E810 A9 22                    ."
	jsr     jbsout                          ; E812 20 53 E8                  S.
	pla                                     ; E815 68                       h
	ldx     #$08                            ; E816 A2 08                    ..
lstk10: jsr     jbsout                          ; E818 20 53 E8                  S.
	lda     #$2B                            ; E81B A9 2B                    .+
	iny                                     ; E81D C8                       .
	cpy     keyidx                          ; E81E CC 89 03                 ...
	bne     LE7EE                           ; E821 D0 CB                    ..
	cpx     #$06                            ; E823 E0 06                    ..
	beq     lstk30                          ; E825 F0 05                    ..
	lda     #$22                            ; E827 A9 22                    ."
	jsr     jbsout                          ; E829 20 53 E8                  S.
lstk30: lda     #$0D                            ; E82C A9 0D                    ..
	jsr     jbsout                          ; E82E 20 53 E8                  S.
nodefn: ldy     sedt1                           ; E831 A4 D9                    ..
	cpy     #$14                            ; E833 C0 14                    ..
	beq     LE83A                           ; E835 F0 03                    ..
	jmp     listlp                          ; E837 4C B1 E7                 L..

LE83A:  clc                                     ; E83A 18                       .
	rts                                     ; E83B 60                       `
; -------------------------------------------------------------------------------------------------
; E83C
LE83C:  clc                                     ; E83C 18                       .
LE83D:  lda     crword,x                        ; E83D BD 5A E8                 .Z.
LE840:  bcc     LE845                           ; E840 90 03                    ..
	lda     qtword,x                        ; E842 BD 63 E8                 .c.
LE845:  php                                     ; E845 08                       .
	jsr     jbsout                          ; E846 20 53 E8                  S.
	plp                                     ; E849 28                       (
	dex                                     ; E84A CA                       .
	bpl     LE83D                           ; E84B 10 F0                    ..
	lda     #$29                            ; E84D A9 29                    .)
	ldx     #$06                            ; E84F A2 06                    ..
	bne     lstk10                          ; E851 D0 C5                    ..
; Jump vector: BSOUT via indirect vector
jbsout: jmp     (ibsout)                        ; E853 6C 12 03                 l..

; -------------------------------------------------------------------------------------------------
; E856 
keword: !pet   " yek"                           ; E856 20 59 45 4B               YEK
crword: !pet   "31($rhc+"                       ; E85A 33 31 28 24 52 48 43 2B  31($RHC+
	!byte   $22                                     ; E862 22                       "
qtword: !pet   "43($rhc+"                       ; E863 34 33 28 24 52 48 43 2B  43($RHC+
	!byte   $22                                     ; E86B 22                       "
; -------------------------------------------------------------------------------------------------
; E86C Get/set a function key
addkey: pha                                     ; E86C 48                       H
	tax                                     ; E86D AA                       .
	sty     sedt1                           ; E86E 84 D9                    ..
	lda     e6509,x                         ; E870 B5 00                    ..
	sec                                     ; E872 38                       8
	sbc     keysiz,y                        ; E873 F9 8D 03                 ...
	sta     sedt2                           ; E876 85 DA                    ..
	iny                                     ; E878 C8                       .
	jsr     findky                          ; E879 20 15 EA                  ..
	sta     sedsal                          ; E87C 85 C4                    ..
	stx     sedsal+1                        ; E87E 86 C5                    ..
	ldy     #$14                            ; E880 A0 14                    ..
	jsr     findky                          ; E882 20 15 EA                  ..
	sta     sedeal                          ; E885 85 C6                    ..
	stx     sedeal+1                        ; E887 86 C7                    ..
	ldy     sedt2                           ; E889 A4 DA                    ..
	bmi     keysho                          ; E88B 30 15                    0.
	clc                                     ; E88D 18                       .
	sbc     pkyend                          ; E88E ED 80 03                 ...
	tay                                     ; E891 A8                       .
	txa                                     ; E892 8A                       .
	sbc     pkyend+1                        ; E893 ED 81 03                 ...
	tax                                     ; E896 AA                       .
	tya                                     ; E897 98                       .
	clc                                     ; E898 18                       .
	adc     sedt2                           ; E899 65 DA                    e.
	txa                                     ; E89B 8A                       .
	adc     #$00                            ; E89C 69 00                    i.
	bcc     keysho                          ; E89E 90 02                    ..
	pla                                     ; E8A0 68                       h
	rts                                     ; E8A1 60                       `

; -------------------------------------------------------------------------------------------------
; E8A2
keysho: jsr pagkey				; switch to indirect bank with key buffer
kymove: lda     sedeal                          ; E8A5 A5 C6                    ..
	clc                                     ; E8A7 18                       .
	sbc     sedsal                          ; E8A8 E5 C4                    ..
	lda     sedeal+1                        ; E8AA A5 C7                    ..
	sbc     sedsal+1                        ; E8AC E5 C5                    ..
	bcc     keyins                          ; E8AE 90 28                    .(
	ldy     #$00                            ; E8B0 A0 00                    ..
	lda     sedt2                           ; E8B2 A5 DA                    ..
	bmi     kshort                          ; E8B4 30 10                    0.
	lda     sedeal                          ; E8B6 A5 C6                    ..
	bne     newky4                          ; E8B8 D0 02                    ..
	dec     sedeal+1                        ; E8BA C6 C7                    ..
newky4: dec     sedeal                          ; E8BC C6 C6                    ..
	lda     (sedeal),y                      ; E8BE B1 C6                    ..
	ldy     sedt2                           ; E8C0 A4 DA                    ..
	sta     (sedeal),y                      ; E8C2 91 C6                    ..
	bpl     kymove                          ; E8C4 10 DF                    ..
kshort: lda     (sedsal),y                      ; E8C6 B1 C4                    ..
	ldy     sedt2                           ; E8C8 A4 DA                    ..
	dec     sedsal+1                        ; E8CA C6 C5                    ..
	sta     (sedsal),y                      ; E8CC 91 C4                    ..
	inc     sedsal+1                        ; E8CE E6 C5                    ..
	inc     sedsal                          ; E8D0 E6 C4                    ..
	bne     kymove                          ; E8D2 D0 D1                    ..
	inc     sedsal+1                        ; E8D4 E6 C5                    ..
	bne     kymove                          ; E8D6 D0 CD                    ..
keyins: ldy     sedt1                           ; E8D8 A4 D9                    ..
	jsr     findky                          ; E8DA 20 15 EA                  ..
	sta     sedsal                          ; E8DD 85 C4                    ..
	stx     sedsal+1                        ; E8DF 86 C5                    ..
	ldy     sedt1                           ; E8E1 A4 D9                    ..
	pla                                     ; E8E3 68                       h
	tax                                     ; E8E4 AA                       .
	lda     e6509,x                         ; E8E5 B5 00                    ..
	sta     keysiz,y                        ; E8E7 99 8D 03                 ...
	tay                                     ; E8EA A8                       .
	lda     i6509,x                         ; E8EB B5 01                    ..
	sta     sedeal                          ; E8ED 85 C6                    ..
	lda     $02,x                           ; E8EF B5 02                    ..
	sta     sedeal+1                        ; E8F1 85 C7                    ..
kyinlp: dey                                     ; E8F3 88                       .
	bmi     kyinok                          ; E8F4 30 11                    0.
	lda     $03,x                           ; E8F6 B5 03                    ..
	sta     i6509                           ; E8F8 85 01                    ..
	lda     (sedeal),y                      ; E8FA B1 C6                    ..
	jsr pagres    			; restore indirect bank
	jsr pagkey				; switch to indirect bank with key buffer
	sta     (sedsal),y                      ; E902 91 C4                    ..
	jmp     kyinlp                          ; E904 4C F3 E8                 L..

kyinok: jsr pagres    			; restore indirect bank
	clc                                     ; E90A 18                       .
	rts                                     ; E90B 60                       `

; -------------------------------------------------------------------------------------------------
; E90C Keyboard scan
scnkey: jsr     junkwn2		; vector -> nofunc (rts)
	lda     blnon                           ; E90F A5 E6                    ..
	bne     key                             ; E911 D0 20                    . 
	dec     blncnt                          ; E913 C6 E7                    ..
	bne     key                             ; E915 D0 1C                    ..
	lda     #$14                            ; E917 A9 14                    ..
	sta     blncnt                          ; E919 85 E7                    ..
	jsr     get1ch                          ; E91B 20 3F E2                  ?.
	ldx     gdcol                           ; E91E A6 ED                    ..
	lsr     blnsw                           ; E920 46 EB                    F.
	bcs     LE92E                           ; E922 B0 0A                    ..
	inc     blnsw                           ; E924 E6 EB                    ..
	sta     config                          ; E926 85 D4                    ..
	ldx     tcolor                          ; E928 A6 EA                    ..
	stx     gdcol                           ; E92A 86 ED                    ..
	ldx     color                           ; E92C A6 EC                    ..
LE92E:  eor     #$80                            ; E92E 49 80                    I.
	jsr     dspp                            ; E930 20 13 E2                  ..
; E933 Poll the keyboard and place the result into the kbd buffer
key:    ldy     #$FF                            ; E933 A0 FF                    ..
	sty     modkey                          ; E935 84 E0                    ..
	sty     norkey                          ; E937 84 E1                    ..
	iny                                     ; E939 C8                       .
	sty     tpi2+pb                         ; E93A 8C 01 DF                 ...
	sty     tpi2+pa                         ; E93D 8C 00 DF                 ...
	jsr     getkey                          ; E940 20 EA E9                  ..
	and     #$3F                            ; E943 29 3F                    )?
	eor     #$3F                            ; E945 49 3F                    I?
	beq     nulxit                          ; E947 F0 76                    .v
	lda     #$FF                            ; E949 A9 FF                    ..
	sta     tpi2+pa                         ; E94B 8D 00 DF                 ...
	asl                                     ; E94E 0A                       .
	sta     tpi2+pb                         ; E94F 8D 01 DF                 ...
	jsr     getkey                          ; E952 20 EA E9                  ..
	pha                                     ; E955 48                       H
	sta     modkey                          ; E956 85 E0                    ..
	ora     #$30                            ; E958 09 30                    .0
	bne     line01                          ; E95A D0 03                    ..
linelp: jsr     getkey                          ; E95C 20 EA E9                  ..
line01: ldx     #$05                            ; E95F A2 05                    ..
kyloop: lsr                                     ; E961 4A                       J
	bcc     havkey                          ; E962 90 10                    ..
	iny                                     ; E964 C8                       .
	dex                                     ; E965 CA                       .
	bpl     kyloop                          ; E966 10 F9                    ..
	sec                                     ; E968 38                       8
	rol     tpi2+pb                         ; E969 2E 01 DF                 ...
	rol     tpi2+pa                         ; E96C 2E 00 DF                 ...
	bcs     linelp                          ; E96F B0 EB                    ..
	pla                                     ; E971 68                       h
	bcc     nulxit                          ; E972 90 4B                    .K
havkey: ldx     normtb,y                        ; E974 BE B1 EA                 ...
	sty     norkey                          ; E977 84 E1                    ..
	pla                                     ; E979 68                       h
	asl                                     ; E97A 0A                       .
	asl                                     ; E97B 0A                       .
	asl                                     ; E97C 0A                       .
	bcc     doctl                           ; E97D 90 0E                    ..
	bmi     havasc                          ; E97F 30 0F                    0.
	ldx     shfttb,y                        ; E981 BE 11 EB                 ...
	lda     grmode                          ; E984 A5 CC                    ..
	bne     havasc                          ; E986 D0 08                    ..
	ldx     shftgr,y                        ; E988 BE 71 EB                 .q.
	bne     havasc                          ; E98B D0 03                    ..
doctl:  ldx     ctltbl,y                        ; E98D BE D1 EB                 ...
havasc: cpx     #$FF                            ; E990 E0 FF                    ..
	beq     keyxit                          ; E992 F0 2D                    .-
	txa                                     ; E994 8A                       .
	cmp     #$E0                            ; E995 C9 E0                    ..
	bcc     notfun                          ; E997 90 09                    ..
	tya                                     ; E999 98                       .
	pha                                     ; E99A 48                       H
	jsr     funjmp                          ; E99B 20 F3 E9                  ..
	pla                                     ; E99E 68                       h
	tay                                     ; E99F A8                       .
	bcs     keyxit                          ; E9A0 B0 1F                    ..
; E9A2 Not a function key
notfun: txa                                     ; E9A2 8A                       .
	cpy     lstx                            ; E9A3 C4 CD                    ..
	beq     dorpt                           ; E9A5 F0 27                    .'
	ldx     #$13                            ; E9A7 A2 13                    ..
	stx     delay                           ; E9A9 86 D8                    ..
	ldx     ndx                             ; E9AB A6 D1                    ..
	cpx     #$09                            ; E9AD E0 09                    ..
	beq     nulxit                          ; E9AF F0 0E                    ..
	cpy     #$59                            ; E9B1 C0 59                    .Y
	bne     savkey                          ; E9B3 D0 29                    .)
	cpx     #$08                            ; E9B5 E0 08                    ..
	beq     nulxit                          ; E9B7 F0 06                    ..
	sta     keyd,x                          ; E9B9 9D AB 03                 ...
	inx                                     ; E9BC E8                       .
	bne     savkey                          ; E9BD D0 1F                    ..
nulxit: ldy     #$FF                            ; E9BF A0 FF                    ..
keyxit: sty     lstx                            ; E9C1 84 CD                    ..
keyxt2: ldx     #$7F                            ; E9C3 A2 7F                    ..
	stx     tpi2+pa                         ; E9C5 8E 00 DF                 ...
	ldx     #$FF                            ; E9C8 A2 FF                    ..
	stx     tpi2+pb                         ; E9CA 8E 01 DF                 ...
	rts                                     ; E9CD 60                       `

; -------------------------------------------------------------------------------------------------
; E9CE Handle key repeat
dorpt:  dec     delay                           ; E9CE C6 D8                    ..
	bpl     keyxt2                          ; E9D0 10 F1                    ..
	inc     delay                           ; E9D2 E6 D8                    ..
	dec     rptcnt                          ; E9D4 C6 D7                    ..
	bpl     keyxt2                          ; E9D6 10 EB                    ..
	inc     rptcnt                          ; E9D8 E6 D7                    ..
	ldx     ndx                             ; E9DA A6 D1                    ..
	bne     keyxt2                          ; E9DC D0 E5                    ..
; E9DE Store key in keyboard buffer
savkey: sta     keyd,x                          ; E9DE 9D AB 03                 ...
	inx                                     ; E9E1 E8                       .
	stx     ndx                             ; E9E2 86 D1                    ..
	ldx     #$03                            ; E9E4 A2 03                    ..
	stx     rptcnt                          ; E9E6 86 D7                    ..
	bne     keyxit                          ; E9E8 D0 D7                    ..
; E9EA Read keyboard matrix and debounce
getkey: lda     tpi2+pc                         ; E9EA AD 02 DF                 ...
	cmp     tpi2+pc                         ; E9ED CD 02 DF                 ...
	bne     getkey                          ; E9F0 D0 F8                    ..
	rts                                     ; E9F2 60                       `

; -------------------------------------------------------------------------------------------------
; E9F3 Jump vector: Called when a function key has been pressed
funjmp: jmp     (funvec)                        ; E9F3 6C B5 03                 l..

; -------------------------------------------------------------------------------------------------
; E9F6
funkey: cpy     lstx                            ; E9F6 C4 CD                    ..
	beq     funrts                          ; E9F8 F0 19                    ..
	lda     ndx                             ; E9FA A5 D1                    ..
	ora     kyndx                           ; E9FC 05 D6                    ..
	bne     funrts                          ; E9FE D0 13                    ..
	sta     keyidx                          ; EA00 8D 89 03                 ...
	txa                                     ; EA03 8A                       .
	and     #$1F                            ; EA04 29 1F                    ).
	tay                                     ; EA06 A8                       .
	lda     keysiz,y                        ; EA07 B9 8D 03                 ...
	sta     kyndx                           ; EA0A 85 D6                    ..
	jsr     findky                          ; EA0C 20 15 EA                  ..
	sta     keypnt                          ; EA0F 85 C2                    ..
	stx     keypnt+1                        ; EA11 86 C3                    ..
; EA13 Default function key handler
funrts: sec                                     ; EA13 38                       8
	rts                                     ; EA14 60                       `

; -------------------------------------------------------------------------------------------------
; EA15 Find a function key definition
findky: lda     pkybuf                          ; EA15 A5 C0                    ..
	ldx     pkybuf+1                        ; EA17 A6 C1                    ..
findlp: clc                                     ; EA19 18                       .
	dey                                     ; EA1A 88                       .
	bmi     fndout                          ; EA1B 30 08                    0.
	adc     keysiz,y                        ; EA1D 79 8D 03                 y..
	bcc     findlp                          ; EA20 90 F7                    ..
	inx                                     ; EA22 E8                       .
	bne     findlp                          ; EA23 D0 F4                    ..
fndout: rts                                     ; EA25 60                       `

; -------------------------------------------------------------------------------------------------
; EA26 Calculate tabulator position
gettab: tya                                     ; EA26 98                       .
	and     #$07                            ; EA27 29 07                    ).
	tax                                     ; EA29 AA                       .
	lda     bits,x                          ; EA2A BD EF EC                 ...
	sta     bitmsk                          ; EA2D 8D 88 03                 ...
	tya                                     ; EA30 98                       .
	lsr                                     ; EA31 4A                       J
	lsr                                     ; EA32 4A                       J
	lsr                                     ; EA33 4A                       J
	tax                                     ; EA34 AA                       .
	lda     tab,x                           ; EA35 BD A1 03                 ...
	bit     bitmsk                          ; EA38 2C 88 03                 ,..
	rts                                     ; EA3B 60                       `

; -------------------------------------------------------------------------------------------------
; EA3C Handle an escape sequence
escape: and #$7F
	sec
	sbc #$41
	cmp #$1A
	bcc escgo
escrts: rts
; -------------------------------------------------------------------------------------------------
; EA46 Call an escape sequence routine
escgo:  asl                                     ; EA46 0A                       .
	tax                                     ; EA47 AA                       .
	lda     escvct+1,x                     ; EA48 BD 52 EA                 .R.
	pha                                     ; EA4B 48                       H
	lda     escvct,x                       ; EA4C BD 51 EA                 .Q.
	pha                                     ; EA4F 48                       H
	rts                                     ; EA50 60                       `

; -------------------------------------------------------------------------------------------------
; EA51 Escape sequence table
escvct:	!word auton-1		; a Auto insert
	!word sethtb-1		; b set bottom
	!word autoff-1		; c cancel auto insert
	!word dline-1		; d Delete line
	!word notimp-1		; e
	!word notimp-1		; f
	!word bellon-1		; g enable bell
	!word bellof-1		; h disable bell
	!word iline-1		; i Insert line
	!word fndfst-1		; j Move to start of line
	!word fndend-1		; k Move to end of line
	!word scrsw0-1		; l enable scrolling
	!word scrsw1-1		; m disable scrolling
	!word notimp-1		; n
	!word toqm-1		; o cancel insert, quote and reverse
	!word etosol-1		; p Erase to start of line
	!word etoeol-1		; q Erase to end of line
	!word notimp-1		; r
	!word notimp-1		; s
	!word sethtt-1		; t Set top left of page
	!word notimp-1		; u
	!word esuup-1		; v Scroll up
	!word esddn-1		; w Scroll down
	!word escrts-1		; x cancel esacpe sequence
	!word notimp-1		; y
	!word notimp-1		; z
; -------------------------------------------------------------------------------------------------
; EA85 Set top left window corner (esc-t)
sethtt: clc                     ; set upper left corner with C=0
	!byte $24               ; skip next instruction with bit $xx
; EA87 Set bottom right window corner (esc-b)
sethtb: sec                     ; set lower right corner with C=1
window: ldx pntr                ; load cursor column
	lda tblx                ; load cursour row
	bcc settps              ; set upper left corner if C=0
setbts: sta scbot               ; store last row
	stx scrt                ; store last column
	rts
; -------------------------------------------------------------------------------------------------
; EA93 Set full screen window
sreset: lda #scymax		; load last row, column of screen
	ldx #scxmax
	jsr setbts              ; et lower right corner
	lda #$00                ; clear A, X to first row, column
	tax
settps: sta sctop               ; set first row
	stx sclf                ; set first column
	rts
; -------------------------------------------------------------------------------------------------
; EAA2 Bell on (esc-g)
bellon: lda #$00                ; $00 = bell on
; EAA4 Bell off (esc-h)
bellof:sta bellmd              ; store bell flag - any value = bell off
; EAA7 Not implemented escape sequences jump here
notimp: rts
; -------------------------------------------------------------------------------------------------
; EAA8 Auto insert mode off (esc-c)
autoff: lda #$00
	!byte $2C               ; skips next instruction with bit $xxxx
; EAAB Auto insert mode on (esc-a)
auton:  lda #$FF
	sta insflg
	rts
; -------------------------------------------------------------------------------------------------
; EAB1 Keyboard tables
normtb:					; keyboard table - no control/no shift
	;line 0: f1, escape, tab, null, shift, control
	 !byte $e0,$1b,$09,$ff,$00,$01
	;line 1: f2, 1, q, a, z, null
	 !byte $e1,$31,$51,$41,$5a,$ff
	;line 2: f3, 2, w, s, x, c
	 !byte $e2,$32,$57,$53,$58,$43
	;line 3: f4, 3, e, d, f, v
	 !byte $e3,$33,$45,$44,$46,$56
	;line 4: f5, 4, r, t, g, b
	 !byte $e4,$34,$52,$54,$47,$42
	;line 5: f6, 5, 6, y, h, n
	 !byte $e5,$35,$36,$59,$48,$4e
	;line 6: f7, 7, u, j, m, space
	 !byte $e6,$37,$55,$4a,$4d,$20
	;line 7: f8, 8, i, k, "," , .
	 !byte $e7,$38,$49,$4b,$2c,$2e
	;line 8: f9, 9, o, l, ;, /
	 !byte $e8,$39,$4f,$4c,$3b,$2f
	;line 9: f10, 0, -, p, [, '
	 !byte $e9,$30,$2d,$50,$5b,$27
	;line 10: down cursor, =, _, ], return, pi
	 !byte $11,$3d,$5f,$5d,$0d,$de
	;line 11: up cur, lt cur, rt cur, del, cmdr, null
	 !byte $91,$9d,$1d,$14,$02,$ff
	;line 12: home, ?, 7, 4, 1, 0
	 !byte $13,$3f,$37,$34,$31,$30
	;line 13: rvs on, cancel, 8, 5, 2, decimal point
	 !byte $12,$04,$38,$35,$32,$2e
	;line 14: graphic, mult, 9, 6, 3, 00
	 !byte $8e,$2a,$39,$36,$33,$30
	;line 15: stop, div, subtr, add, enter, null
	 !byte $03,$2f,$2d,$2b,$0d,$ff

shfttb:					; keyboard table - shift only & text mode
	;line 0: f11, sht esc, tab toggle, null, shift, ctl
	 !byte $ea,$1b,$89,$ff,$00,$01
	;line 1: f12, !, q, a, z, null
	 !byte $eb,$21,$d1,$c1,$da,$ff
	;line 2: f13, @, w, s, x, c
	 !byte $ec,$40,$d7,$d3,$d8,$c3
	;line 3: f14, #, e, d, f, v
	 !byte $ed,$23,$c5,$c4,$c6,$d6
	;line 4: f15, $, r, t, g, b
	 !byte $ee,$24,$d2,$d4,$c7,$c2
	;line 5: f16, %, ^, y, h, n
	 !byte $ef,$25,$5e,$d9,$c8,$ce
	;line 6: f17, &, u, j, m, shifted space
	 !byte $f0,$26,$d5,$ca,$cd,$a0
	;line 7: f18, *, i, k, <, >
	 !byte $f1,$2a,$c9,$cb,$3c,$3e
	;line 8: f19, (, o, l, :, ?
	 !byte $f2,$28,$cf,$cc,$3a,$3f
	;line 9: f20, ), -, p, [, "
	 !byte $f3,$29,$2d,$d0,$5b,$22
	;line 10: down cursor, +, pound sign, ], sht return, pi
	 !byte $11,$2b,$5c,$5d,$8d,$de
	;line 11: up cursor,left cursor,right cursor, ins, cmdr, null
	 !byte $91,$9d,$1d,$94,$82,$ff
	;line 12: clear/home, ?, 7, 4, 1, 0
	 !byte $93,$3f,$37,$34,$31,$30
	;line 13: rvs off, shft cancel, 8, 5, 2, decimal point
	 !byte $92,$84,$38,$35,$32,$2e
	;line 14: text, mult, 9, 6, 3, 00
	 !byte $0e,$2a,$39,$36,$33,$30
	;line 15: run, div, subtr, add, enter, null
	 !byte $83,$2f,$2d,$2b,$8d,$ff

shftgr:					; keyboard table - shift only & graphic mode
	;line 0: f11, sht esc, tab toggle, null, shift, ctl
	 !byte $ea,$1b,$89,$ff,$00,$01
	;line 1: f12, !, gr, gr, gr, null
	 !byte $eb,$21,$d1,$c1,$da,$ff
	;line 2: f13, @, gr, gr, gr, gr
	 !byte $ec,$40,$d7,$d3,$d8,$c0
	;line 3: f14, #, gr, gr, gr, gr
	 !byte $ed,$23,$c5,$c4,$c6,$c3
	;line 4: f15, $, gr, gr, gr, gr
	 !byte $ee,$24,$d2,$d4,$c7,$c2
	;line 5: f16, %, ^, gr, gr, gr
	 !byte $ef,$25,$5e,$d9,$c8,$dd
	;line 6: f17, &, gr, gr, gr, shifted space
	 !byte $f0,$26,$d5,$ca,$cd,$a0
	;line 7: f18, *, gr, gr, <, >
	 !byte $f1,$2a,$c9,$cb,$3c,$3e
	;line 8: f19, (, gr, gr, :, ?
	 !byte $f2,$28,$cf,$d6,$3a,$3f
	;line 9: f20, ), -, gr, [, "
	 !byte $f3,$29,$2d,$d0,$5b,$22
	;line 10: down cursor, +, pound, ], shifted return, pi
	 !byte $11,$2b,$5c,$5d,$8d,$de
	;line 11: up cursor,left cursor,right cursor, ins, cmdr, null
	 !byte $91,$9d,$1d,$94,$82,$ff
	;line 12: clear/home,gr,gr,gr,gr,gr
	 !byte $93,$b7,$b4,$b1,$b0,$ad
	;line 13: rvs off,gr,gr,gr,gr,gr
	 !byte $92,$b8,$b5,$b2,$ae,$bd
	;line 14: text,gr,gr,gr,gr,00
	 !byte $0e,$b9,$b6,$b3,$db,$30
	;line 15: run,gr,gr,gr,gr,null
	 !byte $83,$af,$aa,$ab,$8d,$ff

ctltbl:					; keyboard table... control characters, any mode
	;line 0: null,null,null,null,null
	 !byte $ff,$ff,$ff,$ff,$ff,$ff
	;line 1: null,gr,q,a,z,null
	 !byte $ff,$a1,$11,$01,$1a,$ff
	;line 2: null,gr,w,s,x,c
	 !byte $ff,$a2,$17,$13,$18,$03
	;line 3: null,gr,e,d,f,v
	 !byte $ff,$a3,$05,$04,$06,$16
	;line 4: null,gr,r,t,g,b
	 !byte $ff,$a4,$12,$14,$07,$02
	;line 5: null,gr,gr,y,h,n
	 !byte $ff,$a5,$a7,$19,$08,$0e
	;line 6: null,gr,u,j,m,null
	 !byte $ff,$be,$15,$0a,$0d,$ff
	;line 7: null,gr,i,k,gr,null
	 !byte $ff,$bb,$09,$0b,$ce,$ff
	;line 8: null,gr,o,l,gr,null
	 !byte $ff,$bf,$0f,$0c,$dc,$ff
	;line 9: null,gr,gr,p,gr,gr
	 !byte $ff,$ac,$bc,$10,$cc,$a8
	;line 10: null,gr,gr,gr,null,gr
	 !byte $ff,$a9,$df,$ba,$ff,$a6
	;line 11: null,null,null,null,null,null
	 !byte $ff,$ff,$ff,$ff,$ff,$ff
	;line 12: null,lred,yell,mag,wht,blk
	 !byte $ff,$96,$9e,$9c,$05,$90
	;line 13: null,lblue,org,grn,red,null
	 !byte $ff,$99,$81,$1e,$1c,$ff
	;line 14: null,gray3,brown,blue,cyan,null
	 !byte $ff,$9a,$95,$1f,$9f,$ff
	;line 15: null,gray1,gray2,purple,null,null
	 !byte $ff,$97,$98,$9b,$ff,$ff
; -------------------------------------------------------------------------------------------------
; EC31 <SHIFT> <RUN/STOP> String: DLOAD "*" + RUN
runtb:  !pet "d",$CC,$22        ; dL"
	!pet "*",$0D            ; * <RETURN>
	!pet "run",$0D          ; run <RETURN>
; -------------------------------------------------------------------------------------------------
;****** address of screen lines ******
; EC3A Start of screen lines, low bytes
ldtab2: !byte $00,$28,$50,$78,$A0,$C8,$F0,$18
	!byte $40,$68,$90,$B8,$E0,$08,$30,$58
	!byte $80,$A8,$D0,$F8,$20,$48,$70,$98
	!byte $C0
; EC53 Start of screen lines, high bytes
ldtab1: !byte $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D1
	!byte $D1,$D1,$D1,$D1,$D1,$D2,$D2,$D2
	!byte $D2,$D2,$D2,$D2,$D3,$D3,$D3,$D3
	!byte $D3
; -------------------------------------------------------------------------------------------------
; EC6C Dispatch table (control codes $00-$1F, $80-$9F)
ctable:	!word cuser-1
	!word chkcol-1		; -/orange
	!word cuser-1
	!word stprun-1		; stop/run
	!word ce-1		; cancel
	!word chkcol-1		; white/-
	!word unused-1		; unused - from rev.01/02 editor (uses $03BF)
	!word bell-1		; bell/-
	!word cuser-1
	!word tabit-1		; tab/tab toggle
	!word cuser-1
	!word cuser-1
	!word cuser-1
	!word nxt1-1		; return or shifted return
	!word ctext-1		; text/graphic mode
	!word window-1		; set top/bottom
	!word chkcol-1		; -/black
	!word cdnup-1		; cursor down/up
	!word rvsf-1		; rvs on/off
	!word homclr-1		; home/clr
	!word delins-1		; delete/insert character
	!word chkcol-1		; -/brown
	!word chkcol-1		; -/lightred
	!word chkcol-1		; -/gray1
	!word chkcol-1		; -/gray2
	!word chkcol-1		; -/lightgreen
	!word chkcol-1		; -/lightblue
	!word chkcol-1		; -/gray3
	!word chkcol-1		; red/purple
	!word crtlf-1		; cursor right/left
	!word chkcol-1		; green/yellow
	!word chkcol-1		; blue/cyan
; -------------------------------------------------------------------------------------------------
!ifdef STANDARD_FKEYS{          ; ********** Standard F-keys **********
; ECAC Length of function key texts
keylen: !byte $05,$04,$06,$06,$05,$06,$04,$09
	!byte $07,$05                   ; 57 bytes keydef-text
; ECB6 Function key definitions
keydef: !pet "print"                    ; F1
	!pet "list"                     ; F2
	!pet "dload",$22                ; F3
	!pet "dsave",$22                ; F4
	!pet "dopen"                    ; F5
	!pet "dclose"                   ; F6
	!pet "copy"                     ; F7
	!pet "directory"                ; F8
	!pet "scratch"                  ; F9
	!pet "chr$("                    ; F10
; -------------------------------------------------------------------------------------------------
} else{                         ; ********** F-keys PATCH **********
; ECAC Length of function key texts
keylen: !byte $03,$03,$03,$03,$0d,$0d,$04,$09
	!byte $03,$03                   ; 57 bytes keydef-text
; ECB6 Function key definitions
keydef: !pet "rU",$0d                   ; F1
	!pet "lI",$0d                   ; F2
	!pet "dL",$22                   ; F3
	!pet "dS",$22                   ; F4
	!pet "oP8,8,15,",$22,"cd:"      ; F5
	!pet "oP9,9,15,",$22,"cd:"      ; F6
	!pet "dcL",$0d                  ; F7
	!pet "diRd0onu8"                ; F8
	!pet "sC",$22                   ; F9
	!pet "hE",$22                   ; F10
}
; Length of function key texts
;keylen: !byte $03,$04,$06,$06,$05,$05,$04,$09
;        !byte $08,$07                   ; 57 bytes keydef-text
; Function key definitions
;keydef: !pet "run"                      ; F1
;        !pet "list"                     ; F2
;        !pet "dload",$22                ; F3
;        !pet "dsave",$22                ; F4
;        !pet "print"                    ; F5
;        !pet "chr$("                    ; F6
;        !pet "bank"                     ; F7
;        !pet "directory"                ; F8
;        !pet "scratch",$22              ; F9
;        !pet "header",$22               ; F10
;}
keyend:
; -------------------------------------------------------------------------------------------------
; ECEF bits  -  bit position table
bits:	!byte $80,$40,$20,$10,$08,$04,$02,$01
; -------------------------------------------------------------------------------------------------
; ECF7 VIC initialization table regs $11-$21 
tvic:	!byte $1B,$00,$00,$00,$00,$08,$00,$40
	!byte $8F,$00,$00,$00,$00,$00,$00,EXTCOL
	!byte BGRCOL
; -------------------------------------------------------------------------------------------------
; ED08 Extended editor vector table (copied to $3B5)
edvect:	!word funkey
	!word wrvram
	!word wrcram
	!word nofunc
	!word nofunc
; -------------------------------------------------------------------------------------------------
; ED12 Color control code table
; blk,wht,red,cyan,magenta,grn,blue,yellow
coltab:	!byte $90,$05,$1C,$9F,$9C,$1E,$1F,$9E
; org,brown,lred,gray1,gray2,lgreen,lblue,gray3,purple
	!byte $81,$95,$96,$97,$98,$99,$9A,$9B
; rsr modify for vic-40 system			*** Just for fun from rev.1 c64-kernal rev.1 ;) ***
; rsr 12/31/81 add 8 more colors
; -------------------------------------------------------------------------------------------------
; ED22 Unused space
	!byte $00
!ifdef SYSPATCH{
poker	= $1B
dfbank	= $0257
getpin	= $B4B9
*= $EDDC
csys:	jsr getpin      ; get positive integer
	lda i6509
	pha
	lda dfbank 	; current bank
	cmp #$f
	beq fligm
	ldx poker
	ldy poker+1
	jsr newsys
csysrz	=*-1
	pla
	sta $1
	rts
fligm:
	lda #>csysrz    ;push return address
	pha
	lda #<csysrz
	pha
	jmp (poker)
	rts	
}
; ****************************************** KERNAL ***********************************************
!zone kernal
*= kernal+$E00
;************************************************
;* kernal monitor                               *
;*                                              *
;* entry via call (jmp) or breakpoint (brk)     *
;* ---functions---                              *
;* <:>      alter memory                        *
;* <;>      alter registers                     *
;* <r>      display registers                   *
;* <m>      display memory                      *
;* <g>      start execution of code             *
;* <l>      load memory                         *
;* <s>      save memory                         *
;* <v>      view segment                        *
;* <@>      disk command                        *
;* <x>      warm start basic                    *
;* <u>      set default disk unit               *
;* <other>  load and execute from disk          *
;*                                              *
;* for syntax & semantics see cbm kernal manual *
;* copyright (c) 1981 by cbm                    *
;************************************************
; EE00 Monitor entry after boot (no basic)
monon:	jsr     ioinit                          ; EE00 20 FE F9                  ..
	jsr     restor                          ; EE03 20 B1 FB                  ..
	jsr     jcint                           ; EE06 20 04 E0                  ..
; EE09 Monitor cold start
monoff:	jsr     clrch                          ; EE09 20 CC FF                  ..
	lda     #winit		; waste two bytes so timc=60950
	ldx     #$00                            ; EE0E A2 00                    ..
	ldy     #$EE                            ; EE10 A0 EE                    ..
	jsr     vreset                          ; EE12 20 D9 FB                  ..
	cli                                     ; EE15 58                       X
; EE16 Monitor entry using SYS
timc:   lda     #$C0                            ; EE16 A9 C0                    ..
	sta     msgflg                          ; EE18 8D 61 03                 .a.
	lda     #$40                            ; EE1B A9 40                    .@
	sta     tmpc                            ; EE1D 85 BD                    ..
	bne     b3                              ; EE1F D0 10                    ..
; EE21 Monitor entry via BRK
timb:   jsr     clrch                          ; EE21 20 CC FF                  ..
	lda     #$53                            ; EE24 A9 53                    .S
	sta     tmpc                            ; EE26 85 BD                    ..
	cld                                     ; EE28 D8                       .
	ldx     #$05                            ; EE29 A2 05                    ..
; EE2B Pop registers from stack and save them
b2:     pla                                     ; EE2B 68                       h
	sta     pch,x                           ; EE2C 95 AE                    ..
	dex                                     ; EE2E CA                       .
	bpl     b2                              ; EE2F 10 FA                    ..
; EE31 Save indirect segment and other stuff
b3:     lda     i6509                           ; EE31 A5 01                    ..
	sta     xi6509                          ; EE33 85 B5                    ..
	lda     cinv                            ; EE35 AD 00 03                 ...
	sta     invl                            ; EE38 85 B8                    ..
	lda     cinv+1                          ; EE3A AD 01 03                 ...
	sta     invh                            ; EE3D 85 B7                    ..
	tsx                                     ; EE3F BA                       .
	stx     sp                              ; EE40 86 B4                    ..
	cli                                     ; EE42 58                       X
	lda     #$08                            ; EE43 A9 08                    ..
	sta     ddisk                           ; EE45 85 BF                    ..
	ldy     tmpc                            ; EE47 A4 BD                    ..
	jsr     spmsg                           ; EE49 20 23 F2                  #.
	lda     #$52                            ; EE4C A9 52                    .R
	bne     mcmd                            ; EE4E D0 23                    .#
; EE50 Invalid monitor input, print "?" + CR + "."
erropr: jsr     outqst                          ; EE50 20 1E EF                  ..
	pla                                     ; EE53 68                       h
	pla                                     ; EE54 68                       h
	lda     #$C0                            ; EE55 A9 C0                    ..
	sta     msgflg                          ; EE57 8D 61 03                 .a.
	lda     #$00                            ; EE5A A9 00                    ..
	sta     fnadr                           ; EE5C 85 90                    ..
	lda     #$02                            ; EE5E A9 02                    ..
	sta     fnadr+1                         ; EE60 85 91                    ..
	lda     #$0F                            ; EE62 A9 0F                    ..
	sta     fnadr+2                         ; EE64 85 92                    ..
	jsr     crlf                            ; EE66 20 21 EF                  !.
st1:    jsr     basin                          ; EE69 20 CF FF                  ..
	cmp     #$20                            ; EE6C C9 20                    . 
	beq     st1                             ; EE6E F0 F9                    ..
	jmp     (usrcmd)                        ; EE70 6C 1E 03                 l..

; -------------------------------------------------------------------------------------------------
; EE73 Search for a monitor command in the table
mcmd:   ldx     #$00                            ; EE73 A2 00                    ..
	stx     fnlen                           ; EE75 86 9D                    ..
	tay                                     ; EE77 A8                       .
	lda     #$EE                            ; EE78 A9 EE                    ..
	pha                                     ; EE7A 48                       H
	lda     #$54                            ; EE7B A9 54                    .T
	pha                                     ; EE7D 48                       H
	tya                                     ; EE7E 98                       .
s1:     cmp     cmds,x                          ; EE7F DD D1 EE                 ...
	bne     s2                              ; EE82 D0 10                    ..
	sta     savx                            ; EE84 8D 66 03                 .f.
	lda     cmds+1,x                        ; EE87 BD D2 EE                 ...
	sta     tmp0                            ; EE8A 85 B9                    ..
	lda     cmds+2,x                        ; EE8C BD D3 EE                 ...
	sta     tmp0+1                          ; EE8F 85 BA                    ..
	jmp     (tmp0)                          ; EE91 6C B9 00                 l..

; -------------------------------------------------------------------------------------------------
; EE94 Increment X to point to next command in table
s2:     inx                                     ; EE94 E8                       .
	inx                                     ; EE95 E8                       .
	inx                                     ; EE96 E8                       .
	cpx     #$24                            ; EE97 E0 24                    .$
	bcc     s1                              ; EE99 90 E4                    ..
	ldx     #$00                            ; EE9B A2 00                    ..
; EE9D Check for a disk command
s3:     cmp     #$0D                            ; EE9D C9 0D                    ..
	beq     s4                              ; EE9F F0 0D                    ..
	cmp     #$20                            ; EEA1 C9 20                    . 
	beq     s4                              ; EEA3 F0 09                    ..
	sta     $0200,x                         ; EEA5 9D 00 02                 ...
	jsr     basin                          ; EEA8 20 CF FF                  ..
	inx                                     ; EEAB E8                       .
	bne     s3                              ; EEAC D0 EF                    ..
; EEAE Handle a disk command
s4:     sta     tmpc                            ; EEAE 85 BD                    ..
	txa                                     ; EEB0 8A                       .
	beq     s5                              ; EEB1 F0 1D                    ..
	sta     fnlen                           ; EEB3 85 9D                    ..
	lda     #$40                            ; EEB5 A9 40                    .@
	sta     msgflg                          ; EEB7 8D 61 03                 .a.
	lda     ddisk                           ; EEBA A5 BF                    ..
	sta     fa                              ; EEBC 85 9F                    ..
	lda     #$0F                            ; EEBE A9 0F                    ..
	sta     i6509                           ; EEC0 85 01                    ..
	ldx     #$FF                            ; EEC2 A2 FF                    ..
	ldy     #$FF                            ; EEC4 A0 FF                    ..
	jsr     load                           ; EEC6 20 D5 FF                  ..
	bcs     s5                              ; EEC9 B0 05                    ..
	lda     tmpc                            ; EECB A5 BD                    ..
	jmp     (stal)                          ; EECD 6C 99 00                 l..

s5:     rts                                     ; EED0 60                       `
; -------------------------------------------------------------------------------------------------
; EED1 Table with monitor commands. One letter command followed by address.
cmds:   !pet         ":"                                ; EED1 3A                       :
	!word   msetmem                         ; EED2 F7 EF                    ..
; -------------------------------------------------------------------------------------------------
	!pet         ";"                                ; EED4 3B                       ;
	!word   msetreg                         ; EED5 C5 EF                    ..
; -------------------------------------------------------------------------------------------------
	!pet         "r"                                ; EED7 52                       R
	!word   mregs                           ; EED8 41 EF                    A.
; -------------------------------------------------------------------------------------------------
	!pet         "m"                                ; EEDA 4D                       M
	!word   mdump                           ; EEDB 84 EF                    ..
; -------------------------------------------------------------------------------------------------
	!pet         "g"                                ; EEDD 47                       G
	!word   mgo                             ; EEDE 14 F0                    ..
; -------------------------------------------------------------------------------------------------
	!pet         "l"                                ; EEE0 4C                       L
	!word   mload                           ; EEE1 43 F0                    C.
; -------------------------------------------------------------------------------------------------
	!pet         "s"                                ; EEE3 53                       S
	!word   mload                           ; EEE4 43 F0                    C.
; -------------------------------------------------------------------------------------------------
	!pet         "v"                                ; EEE6 56                       V
	!word   mbank                           ; EEE7 DF EF                    ..
; -------------------------------------------------------------------------------------------------
	!pet   "@"                                      ; EEE9 40                       @
	!word   mdisk                           ; EEEA 68 F1                    h.
; -------------------------------------------------------------------------------------------------
	!pet         "z"                                ; EEEC 5A                       Z
	!word   ipcgov                          ; EEED 72 FF                    r.
; -------------------------------------------------------------------------------------------------
	!pet         "x"                                ; EEEF 58                       X
	!word   mexit                           ; EEF0 F5 EE                    ..
; -------------------------------------------------------------------------------------------------
	!pet         "u"                                ; EEF2 55                       U
	!word   mdunit                          ; EEF3 EB EF                    ..
; -------------------------------------------------------------------------------------------------
; EEF5 Monitor command 'x' (exit)
mexit:  pla                                     ; EEF5 68                       h
	pla                                     ; EEF6 68                       h
	sei                                     ; EEF7 78                       x
	jmp     (evect)                         ; EEF8 6C F8 03                 l..

; -------------------------------------------------------------------------------------------------
; EEFB Move tmp0/tmp0+1 to PC memory location
putpc:  lda     tmp0                            ; EEFB A5 B9                    ..
	sta     pcl                             ; EEFD 85 AF                    ..
	lda     tmp0+1                          ; EEFF A5 BA                    ..
	sta     pch                             ; EF01 85 AE                    ..
	rts                                     ; EF03 60                       `

; -------------------------------------------------------------------------------------------------
; EF04 Set tmp0 to point to the saved regs in zero page
setr:   lda     #<flgs                          ; EF04 A9 B0                    ..
	sta     tmp0                            ; EF06 85 B9                    ..
	lda     #>flgs                            ; EF08 A9 00                    ..
	sta     tmp0+1                          ; EF0A 85 BA                    ..
	lda     #$0F                            ; EF0C A9 0F                    ..
	sta     i6509                           ; EF0E 85 01                    ..
	lda     #$05                            ; EF10 A9 05                    ..
	rts                                     ; EF12 60                       `

; -------------------------------------------------------------------------------------------------
; EF13 Print CR + '.' + A + ' '
altrit: pha                                     ; EF13 48                       H
	jsr     crlf                            ; EF14 20 21 EF                  !.
	pla                                     ; EF17 68                       h
	jsr     kbsout                          ; EF18 20 D2 FF                  ..
; Print ' '
space:  lda     #$20                            ; EF1B A9 20                    . 
!byte   $2C                                     ; EF1D 2C                       ,
; Print '?'
outqst: lda     #$3F                            ; EF1E A9 3F                    .?
!byte   $2C                                     ; EF20 2C                       ,
; Print CR + '.'
crlf:   lda     #$0D                            ; EF21 A9 0D                    ..
	jmp     kbsout                          ; EF23 4C D2 FF                 L..

; -------------------------------------------------------------------------------------------------
; EF26 Header for 'r' command
reghead:
	!byte   $0D
	!pet   "   pc  irq  sr ac xr yr sp"
; -------------------------------------------------------------------------------------------------
; EF41 Monitor command 'r' (regs)
mregs:  ldx     #$00                            ; EF41 A2 00                    ..
LEF43:  lda     reghead,x                       ; EF43 BD 26 EF                 .&.
	jsr     kbsout                          ; EF46 20 D2 FF                  ..
	inx                                     ; EF49 E8                       .
	cpx     #$1B                            ; EF4A E0 1B                    ..
	bne     LEF43                           ; EF4C D0 F5                    ..
	lda     #$3B                            ; EF4E A9 3B                    .;
	jsr     altrit                          ; EF50 20 13 EF                  ..
	ldx     pch                             ; EF53 A6 AE                    ..
	ldy     pcl                             ; EF55 A4 AF                    ..
	jsr     hex4                            ; EF57 20 F9 F0                  ..
	jsr     space                           ; EF5A 20 1B EF                  ..
	ldx     invh                            ; EF5D A6 B7                    ..
	ldy     invl                            ; EF5F A4 B8                    ..
	jsr     hex4                            ; EF61 20 F9 F0                  ..
	jsr     setr                            ; EF64 20 04 EF                  ..
LEF67:  sta     tmpc                            ; EF67 85 BD                    ..
	ldy     #$00                            ; EF69 A0 00                    ..
	sty     fnlen                           ; EF6B 84 9D                    ..
LEF6D:  jsr     space                           ; EF6D 20 1B EF                  ..
	lda     (tmp0),y                        ; EF70 B1 B9                    ..
	jsr     hex2                            ; EF72 20 FE F0                  ..
	inc     tmp0                            ; EF75 E6 B9                    ..
	bne     LEF7F                           ; EF77 D0 06                    ..
	inc     tmp0+1                          ; EF79 E6 BA                    ..
	bne     LEF7F                           ; EF7B D0 02                    ..
	dec     fnlen                           ; EF7D C6 9D                    ..
LEF7F:  dec     tmpc                            ; EF7F C6 BD                    ..
	bne     LEF6D                           ; EF81 D0 EA                    ..
	rts                                     ; EF83 60                       `

; -------------------------------------------------------------------------------------------------
; EF84 Monitor command 'm' (memory dump)
mdump:  jsr     rdfour                          ; EF84 20 26 F1                  &.
	bcs     LEFC2                           ; EF87 B0 39                    .9
	jsr     xchgtmp                         ; EF89 20 16 F1                  ..
	jsr     rdfour                          ; EF8C 20 26 F1                  &.
	bcc     LEF99                           ; EF8F 90 08                    ..
	lda     tmp2                            ; EF91 A5 BB                    ..
	sta     tmp0                            ; EF93 85 B9                    ..
	lda     tmp2+1                          ; EF95 A5 BC                    ..
	sta     tmp0+1                          ; EF97 85 BA                    ..
LEF99:  jsr     xchgtmp                         ; EF99 20 16 F1                  ..
LEF9C:  jsr     stop                           ; EF9C 20 E1 FF                  ..
	beq     LEFC1                           ; EF9F F0 20                    . 
	lda     #$3A                            ; EFA1 A9 3A                    .:
	jsr     altrit                          ; EFA3 20 13 EF                  ..
	ldx     tmp0+1                          ; EFA6 A6 BA                    ..
	ldy     tmp0                            ; EFA8 A4 B9                    ..
	jsr     hex4                            ; EFAA 20 F9 F0                  ..
	lda     #$08                            ; EFAD A9 08                    ..
	jsr     LEF67                           ; EFAF 20 67 EF                  g.
	lda     fnlen                           ; EFB2 A5 9D                    ..
	bne     LEFC1                           ; EFB4 D0 0B                    ..
	sec                                     ; EFB6 38                       8
	lda     tmp2                            ; EFB7 A5 BB                    ..
	sbc     tmp0                            ; EFB9 E5 B9                    ..
	lda     tmp2+1                          ; EFBB A5 BC                    ..
	sbc     tmp0+1                          ; EFBD E5 BA                    ..
	bcs     LEF9C                           ; EFBF B0 DB                    ..
LEFC1:  rts                                     ; EFC1 60                       `

LEFC2:  jmp     erropr                          ; EFC2 4C 50 EE                 LP.

; -------------------------------------------------------------------------------------------------
; EFC5 Monitor command ';' (set registers)
msetreg:jsr     rdfour                          ; EFC5 20 26 F1                  &.
	bcs     LEFC2                           ; EFC8 B0 F8                    ..
	jsr     putpc                           ; EFCA 20 FB EE                  ..
	jsr     rdfour                          ; EFCD 20 26 F1                  &.
	bcs     LEFC2                           ; EFD0 B0 F0                    ..
	lda     tmp0                            ; EFD2 A5 B9                    ..
	sta     invl                            ; EFD4 85 B8                    ..
	lda     tmp0+1                          ; EFD6 A5 BA                    ..
	sta     invh                            ; EFD8 85 B7                    ..
	jsr     setr                            ; EFDA 20 04 EF                  ..
	bne     LEFFE                           ; EFDD D0 1F                    ..
; EFDF Monitor command 'v' (set bank)
mbank:  jsr     rdtwo                           ; EFDF 20 33 F1                  3.
	bcs     LEFC2                           ; EFE2 B0 DE                    ..
	cmp     #$10                            ; EFE4 C9 10                    ..
	bcs     LEFC2                           ; EFE6 B0 DA                    ..
	sta     i6509                           ; EFE8 85 01                    ..
	rts                                     ; EFEA 60                       `

; -------------------------------------------------------------------------------------------------
; EFEB Monitor command 'u' (unit)
mdunit: jsr     rdtwo                           ; EFEB 20 33 F1                  3.
	bcs     LEFC2                           ; EFEE B0 D2                    ..
	cmp     #$20                            ; EFF0 C9 20                    . 
	bcs     LEFC2                           ; EFF2 B0 CE                    ..
	sta     ddisk                           ; EFF4 85 BF                    ..
	rts                                     ; EFF6 60                       `

; -------------------------------------------------------------------------------------------------
; EFF7 Monitor command ':' (set memory)
msetmem:jsr     rdfour                          ; EFF7 20 26 F1                  &.
	bcs     LEFC2                           ; EFFA B0 C6                    ..
	lda     #$08                            ; EFFC A9 08                    ..
LEFFE:  sta     tmpc                            ; EFFE 85 BD                    ..
-       jsr     rdtwo                           ; F000 20 33 F1                  3.
	bcs     ++                              ; F003 B0 0E                    ..
	ldy     #$00                            ; F005 A0 00                    ..
	sta     (tmp0),y                        ; F007 91 B9                    ..
	inc     tmp0                            ; F009 E6 B9                    ..
	bne     +                               ; F00B D0 02                    ..
	inc     tmp0+1                          ; F00D E6 BA                    ..
+       dec     tmpc                            ; F00F C6 BD                    ..
	bne     -                               ; F011 D0 ED                    ..
++      rts                                     ; F013 60                       `

; -------------------------------------------------------------------------------------------------
; F014 Monitor command 'g' (go)
mgo:    jsr     rdone                           ; F014 20 62 F1                  b.
	beq     LF021                           ; F017 F0 08                    ..
	jsr     rdfour                          ; F019 20 26 F1                  &.
	bcs     LF040                           ; F01C B0 22                    ."
	jsr     putpc                           ; F01E 20 FB EE                  ..
LF021:  ldx     sp                              ; F021 A6 B4                    ..
	txs                                     ; F023 9A                       .
	sei                                     ; F024 78                       x
	lda     invh                            ; F025 A5 B7                    ..
	sta     cinv+1                          ; F027 8D 01 03                 ...
	lda     invl                            ; F02A A5 B8                    ..
	sta     cinv                            ; F02C 8D 00 03                 ...
	lda     xi6509                          ; F02F A5 B5                    ..
	sta     i6509                           ; F031 85 01                    ..
	ldx     #$00                            ; F033 A2 00                    ..
LF035:  lda     pch,x                           ; F035 B5 AE                    ..
	pha                                     ; F037 48                       H
	inx                                     ; F038 E8                       .
	cpx     #$06                            ; F039 E0 06                    ..
	bne     LF035                           ; F03B D0 F8                    ..
	jmp     prend                           ; F03D 4C B3 FC                 L..

LF040:  jmp     erropr                          ; F040 4C 50 EE                 LP.

; -------------------------------------------------------------------------------------------------
; F043 Monitor commands 'l' and 's' (load & save)
mload:  ldy     #$01                            ; F043 A0 01                    ..
	sty     fa                              ; F045 84 9F                    ..
	dey                                     ; F047 88                       .
	lda     #$FF                            ; F048 A9 FF                    ..
	sta     tmp0                            ; F04A 85 B9                    ..
	sta     tmp0+1                          ; F04C 85 BA                    ..
	lda     i6509                           ; F04E A5 01                    ..
	sta     t6509                           ; F050 85 BE                    ..
	lda     #$0F                            ; F052 A9 0F                    ..
	sta     i6509                           ; F054 85 01                    ..
LF056:  jsr     rdone                           ; F056 20 62 F1                  b.
	beq     LF077                           ; F059 F0 1C                    ..
	cmp     #$20                            ; F05B C9 20                    . 
	beq     LF056                           ; F05D F0 F7                    ..
	cmp     #$22                            ; F05F C9 22                    ."
LF061:  bne     LF040                           ; F061 D0 DD                    ..
LF063:  jsr     rdone                           ; F063 20 62 F1                  b.
	beq     LF077                           ; F066 F0 0F                    ..
	cmp     #$22                            ; F068 C9 22                    ."
	beq     LF089                           ; F06A F0 1D                    ..
	sta     (fnadr),y                       ; F06C 91 90                    ..
	inc     fnlen                           ; F06E E6 9D                    ..
	iny                                     ; F070 C8                       .
	cpy     #$10                            ; F071 C0 10                    ..
	beq     LF040                           ; F073 F0 CB                    ..
	bne     LF063                           ; F075 D0 EC                    ..
LF077:  lda     savx                            ; F077 AD 66 03                 .f.
	cmp     #$4C                            ; F07A C9 4C                    .L
	bne     LF061                           ; F07C D0 E3                    ..
	lda     t6509                           ; F07E A5 BE                    ..
	and     #$0F                            ; F080 29 0F                    ).
	ldx     tmp0                            ; F082 A6 B9                    ..
	ldy     tmp0+1                          ; F084 A4 BA                    ..
	jmp     load                           ; F086 4C D5 FF                 L..

; -------------------------------------------------------------------------------------------------
; F089
LF089:  jsr     rdone                           ; F089 20 62 F1                  b.
	beq     LF077                           ; F08C F0 E9                    ..
	cmp     #$2C                            ; F08E C9 2C                    .,
LF090:  bne     LF061                           ; F090 D0 CF                    ..
	jsr     rdtwo                           ; F092 20 33 F1                  3.
	bcs     LF0F6                           ; F095 B0 5F                    ._
	sta     fa                              ; F097 85 9F                    ..
	jsr     rdone                           ; F099 20 62 F1                  b.
	beq     LF077                           ; F09C F0 D9                    ..
	cmp     #$2C                            ; F09E C9 2C                    .,
LF0A0:  bne     LF090                           ; F0A0 D0 EE                    ..
	jsr     rdtwo                           ; F0A2 20 33 F1                  3.
	bcs     LF0F6                           ; F0A5 B0 4F                    .O
	cmp     #$10                            ; F0A7 C9 10                    ..
	bcs     LF0F6                           ; F0A9 B0 4B                    .K
	sta     t6509                           ; F0AB 85 BE                    ..
	sta     stas                            ; F0AD 85 9B                    ..
	jsr     rdfour                          ; F0AF 20 26 F1                  &.
	bcs     LF0F6                           ; F0B2 B0 42                    .B
	lda     tmp0                            ; F0B4 A5 B9                    ..
	sta     stal                            ; F0B6 85 99                    ..
	lda     tmp0+1                          ; F0B8 A5 BA                    ..
	sta     stah                            ; F0BA 85 9A                    ..
	jsr     rdone                           ; F0BC 20 62 F1                  b.
	beq     LF077                           ; F0BF F0 B6                    ..
	cmp     #$2C                            ; F0C1 C9 2C                    .,
	bne     LF0F6                           ; F0C3 D0 31                    .1
	jsr     rdtwo                           ; F0C5 20 33 F1                  3.
	bcs     LF0F6                           ; F0C8 B0 2C                    .,
	cmp     #$10                            ; F0CA C9 10                    ..
	bcs     LF0F6                           ; F0CC B0 28                    .(
	sta     eas                             ; F0CE 85 98                    ..
	jsr     rdfour                          ; F0D0 20 26 F1                  &.
	bcs     LF0F6                           ; F0D3 B0 21                    .!
	lda     tmp0                            ; F0D5 A5 B9                    ..
	sta     eal                             ; F0D7 85 96                    ..
	lda     tmp0+1                          ; F0D9 A5 BA                    ..
	sta     eah                             ; F0DB 85 97                    ..
LF0DD:  jsr     basin                          ; F0DD 20 CF FF                  ..
	cmp     #$20                            ; F0E0 C9 20                    . 
	beq     LF0DD                           ; F0E2 F0 F9                    ..
	cmp     #$0D                            ; F0E4 C9 0D                    ..
LF0E6:  bne     LF0A0                           ; F0E6 D0 B8                    ..
	lda     savx                            ; F0E8 AD 66 03                 .f.
	cmp     #$53                            ; F0EB C9 53                    .S
	bne     LF0E6                           ; F0ED D0 F7                    ..
	ldx     #$99                            ; F0EF A2 99                    ..
	ldy     #$96                            ; F0F1 A0 96                    ..
	jmp     save                           ; F0F3 4C D8 FF                 L..

LF0F6:  jmp     erropr                          ; F0F6 4C 50 EE                 LP.

; -------------------------------------------------------------------------------------------------
; F0F9 Output X/Y as 4 hex bytes
hex4:   txa                                     ; F0F9 8A                       .
	jsr     hex2                            ; F0FA 20 FE F0                  ..
	tya                                     ; F0FD 98                       .
; F0FE Output A as two hex bytes
hex2:   pha                                     ; F0FE 48                       H
	lsr                                     ; F0FF 4A                       J
	lsr                                     ; F100 4A                       J
	lsr                                     ; F101 4A                       J
	lsr                                     ; F102 4A                       J
	jsr     hex1                            ; F103 20 0A F1                  ..
	tax                                     ; F106 AA                       .
	pla                                     ; F107 68                       h
	and     #$0F                            ; F108 29 0F                    ).
; F10A Output low nibble of A as one hex byte
hex1:   clc                                     ; F10A 18                       .
	adc     #$F6                            ; F10B 69 F6                    i.
	bcc     LF111                           ; F10D 90 02                    ..
	adc     #$06                            ; F10F 69 06                    i.
LF111:  adc     #$3A                            ; F111 69 3A                    i:
	jmp     kbsout                          ; F113 4C D2 FF                 L..

; -------------------------------------------------------------------------------------------------
; F116 Exchange tmp0 and invl
xchgtmp:ldx     #$02                            ; F116 A2 02                    ..
-       lda     invl,x                          ; F118 B5 B8                    ..
	pha                                     ; F11A 48                       H
	lda     tmp0+1,x                        ; F11B B5 BA                    ..
	sta     invl,x                          ; F11D 95 B8                    ..
	pla                                     ; F11F 68                       h
	sta     tmp0+1,x                        ; F120 95 BA                    ..
	dex                                     ; F122 CA                       .
	bne     -                               ; F123 D0 F3                    ..
	rts                                     ; F125 60                       `

; -------------------------------------------------------------------------------------------------
; F126 Read 4 chars from input into tmp0/tmp0+1
rdfour: jsr     rdtwo                           ; F126 20 33 F1                  3.
	bcs     +                               ; F129 B0 07                    ..
	sta     tmp0+1                          ; F12B 85 BA                    ..
	jsr     rdtwo                           ; F12D 20 33 F1                  3.
	sta     tmp0                            ; F130 85 B9                    ..
+       rts                                     ; F132 60                       `

; -------------------------------------------------------------------------------------------------
; F133 Read 2 chars from input into A
rdtwo:  lda     #$00                            ; F133 A9 00                    ..
	sta     stack                           ; F135 8D 00 01                 ...
	jsr     rdone                           ; F138 20 62 F1                  b.
	beq     +                               ; F13B F0 19                    ..
	cmp     #$20                            ; F13D C9 20                    . 
	beq     rdtwo                           ; F13F F0 F2                    ..
	jsr     hexit                           ; F141 20 57 F1                  W.
	asl                                     ; F144 0A                       .
	asl                                     ; F145 0A                       .
	asl                                     ; F146 0A                       .
	asl                                     ; F147 0A                       .
	sta     stack                           ; F148 8D 00 01                 ...
	jsr     rdone                           ; F14B 20 62 F1                  b.
	beq     +                               ; F14E F0 06                    ..
	jsr     hexit                           ; F150 20 57 F1                  W.
	ora     stack                           ; F153 0D 00 01                 ...
+       rts                                     ; F156 60                       `

; -------------------------------------------------------------------------------------------------
; F157 Convert char in A into hex value
hexit:  cmp     #$3A                            ; F157 C9 3A                    .:
	php                                     ; F159 08                       .
	and     #$0F                            ; F15A 29 0F                    ).
	plp                                     ; F15C 28                       (
	bcc     +                               ; F15D 90 02                    ..
	adc     #$08                            ; F15F 69 08                    i.
+       rts                                     ; F161 60                       `

; -------------------------------------------------------------------------------------------------
; F162 Input one char, check for CR
rdone:  jsr     basin                          ; F162 20 CF FF                  ..
	cmp     #$0D                            ; F165 C9 0D                    ..
	rts                                     ; F167 60                       `

; -------------------------------------------------------------------------------------------------
; F168 Monitor command '@' (disk commands)
mdisk:  lda     #$00                            ; F168 A9 00                    ..
	sta     status                          ; F16A 85 9C                    ..
	sta     fnlen                           ; F16C 85 9D                    ..
	ldx     ddisk                           ; F16E A6 BF                    ..
	ldy     #$0F                            ; F170 A0 0F                    ..
	jsr     setlfs                          ; F172 20 4F FB                  O.
	clc                                     ; F175 18                       .
	jsr     open                           ; F176 20 C0 FF                  ..
	bcs     LF1BF                           ; F179 B0 44                    .D
	jsr     rdone                           ; F17B 20 62 F1                  b.
	beq     LF19D                           ; F17E F0 1D                    ..
	pha                                     ; F180 48                       H
	ldx     #$00                            ; F181 A2 00                    ..
	jsr     ckout                          ; F183 20 C9 FF                  ..
	pla                                     ; F186 68                       h
	bcs     LF1BF                           ; F187 B0 36                    .6
	bcc     LF18E                           ; F189 90 03                    ..
LF18B:  jsr     basin                          ; F18B 20 CF FF                  ..
LF18E:  cmp     #$0D                            ; F18E C9 0D                    ..
	php                                     ; F190 08                       .
	jsr     kbsout                          ; F191 20 D2 FF                  ..
	lda     status                          ; F194 A5 9C                    ..
	bne     LF1BB                           ; F196 D0 23                    .#
	plp                                     ; F198 28                       (
	bne     LF18B                           ; F199 D0 F0                    ..
	beq     LF1BF                           ; F19B F0 22                    ."
LF19D:  jsr     crlf                            ; F19D 20 21 EF                  !.
	ldx     #$00                            ; F1A0 A2 00                    ..
	jsr     chkin                          ; F1A2 20 C6 FF                  ..
	bcs     LF1BF                           ; F1A5 B0 18                    ..
LF1A7:  jsr     basin                          ; F1A7 20 CF FF                  ..
	cmp     #$0D                            ; F1AA C9 0D                    ..
	php                                     ; F1AC 08                       .
	jsr     kbsout                          ; F1AD 20 D2 FF                  ..
	lda     status                          ; F1B0 A5 9C                    ..
	and     #$BF                            ; F1B2 29 BF                    ).
	bne     LF1BB                           ; F1B4 D0 05                    ..
	plp                                     ; F1B6 28                       (
	bne     LF1A7                           ; F1B7 D0 EE                    ..
	beq     LF1BF                           ; F1B9 F0 04                    ..
LF1BB:  pla                                     ; F1BB 68                       h
	jsr     error5                          ; F1BC 20 4C F9                  L.
LF1BF:  jsr     clrch                          ; F1BF 20 CC FF                  ..
	lda     #$00                            ; F1C2 A9 00                    ..
	clc                                     ; F1C4 18                       .
	jmp     close                          ; F1C5 4C C3 FF                 L..

; -------------------------------------------------------------------------------------------------
; F1C8
	!byte   $EA,$EA
; -------------------------------------------------------------------------------------------------
; F1CA Table with kernal messages
kmsgtab:!byte   $0D                                     ; F1CA 0D                       .
	!pet   "i/o error "                             ; F1CB 49 2F 4F 20 45 52 52 4F  I/O ERRO
							; F1D3 52 20                    R 
	!byte   $A3,$0D                                 ; F1D5 A3 0D                    ..
	!pet   "searching"                              ; F1D7 53 45 41 52 43 48 49 4E  SEARCHIN
							; F1DF 47                       G
	!byte   $A0                                     ; F1E0 A0                       .
	!pet   "for"                                    ; F1E1 46 4F 52                 FOR
	!byte   $A0,$0D                                 ; F1E4 A0 0D                    ..
	!pet   "loadin"                                 ; F1E6 4C 4F 41 44 49 4E        LOADIN
	!byte   $C7,$0D                                 ; F1EC C7 0D                    ..
	!pet   "saving"                                 ; F1EE 53 41 56 49 4E 47        SAVING
	!byte   $A0,$0D                                 ; F1F4 A0 0D                    ..
	!pet   "verifyin"                               ; F1F6 56 45 52 49 46 59 49 4E  VERIFYIN
	!byte   $C7,$0D                                 ; F1FE C7 0D                    ..
	!pet   "found"                                  ; F200 46 4F 55 4E 44           FOUND
	!byte   $A0,$0D                                 ; F205 A0 0D                    ..
	!pet   "ok"                                     ; F207 4F 4B                    OK
	!byte   $8D,$0D                                 ; F209 8D 0D                    ..
	!pet   "** monitor 1.0 **"                      ; F20B 2A 2A 20 4D 4F 4E 49 54  ** MONIT
							; F213 4F 52 20 31 2E 30 20 2A  OR 1.0 *
							; F21B 2A                       *
	!byte   $8D,$0D                                 ; F21C 8D 0D                    ..
	!pet   "brea"                                   ; F21E 42 52 45 41              BREA
	!byte   $CB                                     ; F222 CB                       .
; -------------------------------------------------------------------------------------------------
; F223 Test error flag, print system message
spmsg:  bit     msgflg                          ; F223 2C 61 03                 ,a.
	bpl     LF235                           ; F226 10 0D                    ..
; F228 Print system message, offset in Y
msg:    lda     kmsgtab,y                       ; F228 B9 CA F1                 ...
	php                                     ; F22B 08                       .
	and     #$7F                            ; F22C 29 7F                    ).
	jsr     kbsout                          ; F22E 20 D2 FF                  ..
	iny                                     ; F231 C8                       .
	plp                                     ; F232 28                       (
	bpl     msg                             ; F233 10 F3                    ..
LF235:  clc                                     ; F235 18                       .
	rts                                     ; F236 60                       `

; -------------------------------------------------------------------------------------------------
; F237 Output talk on IEC bus
ntalk:   ora     #$40                            ; F237 09 40                    .@
	bne     LF23D                           ; F239 D0 02                    ..
; F23B Output listen on IEC bus
nlistn:  ora     #$20                            ; F23B 09 20                    . 
LF23D:  pha                                     ; F23D 48                       H
	lda     #$3B                            ; F23E A9 3B                    .;
	sta     tpi1+ddpa                       ; F240 8D 03 DE                 ...
	lda     #$FF                            ; F243 A9 FF                    ..
	sta     cia+pra                        ; F245 8D 00 DC                 ...
	sta     cia+ddra                       ; F248 8D 02 DC                 ...
	lda     #$FE                            ; F24B A9 FE                    ..
	sta     tpi1+pa                         ; F24D 8D 00 DE                 ...
	lda     c3po                            ; F250 A5 AA                    ..
	bpl     LF26F                           ; F252 10 1B                    ..
	lda     tpi1+pa                         ; F254 AD 00 DE                 ...
	and     #$DF                            ; F257 29 DF                    ).
	sta     tpi1+pa                         ; F259 8D 00 DE                 ...
	lda     bsour                           ; F25C A5 AB                    ..
	jsr     txbyte                          ; F25E 20 C0 F2                  ..
	lda     c3po                            ; F261 A5 AA                    ..
	and     #$7F                            ; F263 29 7F                    ).
	sta     c3po                            ; F265 85 AA                    ..
	lda     tpi1+pa                         ; F267 AD 00 DE                 ...
	ora     #$20                            ; F26A 09 20                    . 
	sta     tpi1+pa                         ; F26C 8D 00 DE                 ...
LF26F:  lda     tpi1+pa                         ; F26F AD 00 DE                 ...
	and     #$F7                            ; F272 29 F7                    ).
	sta     tpi1+pa                         ; F274 8D 00 DE                 ...
	pla                                     ; F277 68                       h
	jmp     txbyte                          ; F278 4C C0 F2                 L..

; -------------------------------------------------------------------------------------------------
; F27B Output secondary address after listen on IEC bus
nsecnd:  jsr     txbyte                          ; F27B 20 C0 F2                  ..
; F27E NOT ATN high after secnd
secatn: lda     tpi1+pa                         ; F27E AD 00 DE                 ...
	ora     #$08                            ; F281 09 08                    ..
	sta     tpi1+pa                         ; F283 8D 00 DE                 ...
	rts                                     ; F286 60                       `

; -------------------------------------------------------------------------------------------------
; F287 Output secondary address on IEC bus
ntksa:   jsr     txbyte                          ; F287 20 C0 F2                  ..
tkatn:  lda     #$3D                            ; F28A A9 3D                    .=
	and     tpi1+pa                         ; F28C 2D 00 DE                 -..
; F28F Output A on IEC, switch data to input
setlns: sta     tpi1+pa                         ; F28F 8D 00 DE                 ...
	lda     #$C3                            ; F292 A9 C3                    ..
	sta     tpi1+ddpa                       ; F294 8D 03 DE                 ...
	lda     #$00                            ; F297 A9 00                    ..
	sta     cia+ddra                       ; F299 8D 02 DC                 ...
	beq     secatn                          ; F29C F0 E0                    ..
; F29E Output A on IEC with EOF flag
nciout:  pha                                     ; F29E 48                       H
	lda     c3po                            ; F29F A5 AA                    ..
	bpl     LF2AA                           ; F2A1 10 07                    ..
	lda     bsour                           ; F2A3 A5 AB                    ..
	jsr     txbyte                          ; F2A5 20 C0 F2                  ..
	lda     c3po                            ; F2A8 A5 AA                    ..
LF2AA:  ora     #$80                            ; F2AA 09 80                    ..
	sta     c3po                            ; F2AC 85 AA                    ..
	pla                                     ; F2AE 68                       h
	sta     bsour                           ; F2AF 85 AB                    ..
	rts                                     ; F2B1 60                       `

; -------------------------------------------------------------------------------------------------
; F2B2 Output untalk on IEC
nuntlk: lda     #$5F                            ; F2B2 A9 5F                    ._
	bne     LF2B8                           ; F2B4 D0 02                    ..
; F2B6 Output unlisten on IEC
nunlsn:  lda     #$3F                            ; F2B6 A9 3F                    .?
LF2B8:  jsr     LF23D                           ; F2B8 20 3D F2                  =.
	lda     #$FD                            ; F2BB A9 FD                    ..
	jmp     setlns                          ; F2BD 4C 8F F2                 L..

; -------------------------------------------------------------------------------------------------
; F2C0 Output A on IEC without EOF flag
txbyte: eor     #$FF                            ; F2C0 49 FF                    I.
	sta     cia+pra                        ; F2C2 8D 00 DC                 ...
	lda     tpi1+pa                         ; F2C5 AD 00 DE                 ...
	ora     #$12                            ; F2C8 09 12                    ..
	sta     tpi1+pa                         ; F2CA 8D 00 DE                 ...
	bit     tpi1+pa                         ; F2CD 2C 00 DE                 ,..
	bvc     txbyt1                          ; F2D0 50 09                    P.
	bpl     txbyt1                          ; F2D2 10 07                    ..
	lda     #$80                            ; F2D4 A9 80                    ..
	jsr     udst                            ; F2D6 20 6E FB                  n.
	bne     txbyt6                          ; F2D9 D0 30                    .0
txbyt1: lda     tpi1+pa                         ; F2DB AD 00 DE                 ...
	bpl     txbyt1                          ; F2DE 10 FB                    ..
	and     #$EF                            ; F2E0 29 EF                    ).
	sta     tpi1+pa                         ; F2E2 8D 00 DE                 ...
txbyt2: jsr     timeron                         ; F2E5 20 76 F3                  v.
	bcc     txbyt4                          ; F2E8 90 01                    ..
txbyt3: sec                                     ; F2EA 38                       8
txbyt4: bit     tpi1+pa                         ; F2EB 2C 00 DE                 ,..
	bvs     txbyt5                          ; F2EE 70 13                    p.
	lda     cia+icr                        ; F2F0 AD 0D DC                 ...
	and     #$02                            ; F2F3 29 02                    ).
	beq     txbyt4                          ; F2F5 F0 F4                    ..
	lda     timout                          ; F2F7 AD 5E 03                 .^.
	bmi     txbyt2                          ; F2FA 30 E9                    0.
	bcc     txbyt3                          ; F2FC 90 EC                    ..
	lda     #$01                            ; F2FE A9 01                    ..
	jsr     udst                            ; F300 20 6E FB                  n.
txbyt5: lda     tpi1+pa                         ; F303 AD 00 DE                 ...
	ora     #$10                            ; F306 09 10                    ..
	sta     tpi1+pa                         ; F308 8D 00 DE                 ...
txbyt6: lda     #$FF                            ; F30B A9 FF                    ..
	sta     cia+pra                        ; F30D 8D 00 DC                 ...
	rts                                     ; F310 60                       `

; -------------------------------------------------------------------------------------------------
; F311 Read char from IEC bus into A
nacptr:  lda     tpi1+pa                         ; F311 AD 00 DE                 ...
	and     #$BD                            ; F314 29 BD                    ).
	ora     #$81                            ; F316 09 81                    ..
	sta     tpi1+pa                         ; F318 8D 00 DE                 ...
LF31B:  jsr     timeron                         ; F31B 20 76 F3                  v.
	bcc     LF321                           ; F31E 90 01                    ..
LF320:  sec                                     ; F320 38                       8
LF321:  lda     tpi1+pa                         ; F321 AD 00 DE                 ...
	and     #$10                            ; F324 29 10                    ).
	beq     LF346                           ; F326 F0 1E                    ..
	lda     cia+icr                        ; F328 AD 0D DC                 ...
	and     #$02                            ; F32B 29 02                    ).
	beq     LF321                           ; F32D F0 F2                    ..
	lda     timout                          ; F32F AD 5E 03                 .^.
	bmi     LF31B                           ; F332 30 E7                    0.
	bcc     LF320                           ; F334 90 EA                    ..
	lda     #$02                            ; F336 A9 02                    ..
	jsr     udst                            ; F338 20 6E FB                  n.
	lda     tpi1+pa                         ; F33B AD 00 DE                 ...
	and     #$3D                            ; F33E 29 3D                    )=
	sta     tpi1+pa                         ; F340 8D 00 DE                 ...
	lda     #$0D                            ; F343 A9 0D                    ..
	rts                                     ; F345 60                       `

; -------------------------------------------------------------------------------------------------
; F346
LF346:  lda     tpi1+pa                         ; F346 AD 00 DE                 ...
	and     #$7F                            ; F349 29 7F                    ).
	sta     tpi1+pa                         ; F34B 8D 00 DE                 ...
	and     #$20                            ; F34E 29 20                    ) 
	bne     LF357                           ; F350 D0 05                    ..
	lda     #$40                            ; F352 A9 40                    .@
	jsr     udst                            ; F354 20 6E FB                  n.
LF357:  lda     cia+pra                        ; F357 AD 00 DC                 ...
	eor     #$FF                            ; F35A 49 FF                    I.
	pha                                     ; F35C 48                       H
	lda     tpi1+pa                         ; F35D AD 00 DE                 ...
	ora     #$40                            ; F360 09 40                    .@
	sta     tpi1+pa                         ; F362 8D 00 DE                 ...
LF365:  lda     tpi1+pa                         ; F365 AD 00 DE                 ...
	and     #$10                            ; F368 29 10                    ).
	beq     LF365                           ; F36A F0 F9                    ..
	lda     tpi1+pa                         ; F36C AD 00 DE                 ...
	and     #$BF                            ; F36F 29 BF                    ).
	sta     tpi1+pa                         ; F371 8D 00 DE                 ...
	pla                                     ; F374 68                       h
	rts                                     ; F375 60                       `

; -------------------------------------------------------------------------------------------------
; F376 Set timer for timeout on IEC
timeron:lda     #$80                            ; F376 A9 80                    ..
	sta     cia+tbhi                       ; F378 8D 07 DC                 ...
	lda     #$11                            ; F37B A9 11                    ..
	sta     cia+crb                        ; F37D 8D 0F DC                 ...
	lda     cia+icr                        ; F380 AD 0D DC                 ...
	clc                                     ; F383 18                       .
	rts                                     ; F384 60                       `

; -------------------------------------------------------------------------------------------------
; F385
	jmp     error9                          ; F385 4C 58 F9                 LX.
; -------------------------------------------------------------------------------------------------
; opn232 - open an rs-232 channel
;   if sa=1 then output channel
;   if sa=2 then input  channel
;   if sa=3 then bidirectional channel
;   if sa>128 then ascii conversion enabled
;
;   filename consists of 0-4 bytes
;  byte #1- control register 6551
;  byte #2- command register 6551
;  byte #3- c/r lf delay...60ths of sec   (unimplemented)
;  byte #4- auto c/r insert afer xx chars (unimplemented)
;
;    actions:
;  1. clear  rs232 status:  rsstat
;  2. set 6551 contrl (ctr) register
;  3. set 6551 command (cdr) register
;       cdr bits (7-4) = filename byte 2 bits (7-4)
;                (3-2) = 00  (xmitter off)
;                (1)   = 1   (receiver off)
;                (0)   = 0   (dtr off)
;  4. do buffer alocatation, if needed
;---------------------------------------------
; F388
opn232:	jsr     rdst232                         ; F388 20 35 F4                  5.
	ldy     #$00                            ; F38B A0 00                    ..
LF38D:  cpy     fnlen                           ; F38D C4 9D                    ..
	beq     LF39C                           ; F38F F0 0B                    ..
	jsr     fnadry                          ; F391 20 A0 FE                  ..
	sta     m51ctr,y                        ; F394 99 76 03                 .v.
	iny                                     ; F397 C8                       .
	cpy     #$04                            ; F398 C0 04                    ..
	bne     LF38D                           ; F39A D0 F1                    ..
LF39C:  lda     m51ctr                          ; F39C AD 76 03                 .v.
	sta     acia+ctr                       ; F39F 8D 03 DD                 ...
	lda     m51cdr                          ; F3A2 AD 77 03                 .w.
	and     #$F2                            ; F3A5 29 F2                    ).
	ora     #$02                            ; F3A7 09 02                    ..
	sta     acia+cdr                        ; F3A9 8D 02 DD                 ...
	clc                                     ; F3AC 18                       .
	lda     sa                              ; F3AD A5 A0                    ..
	and     #$02                            ; F3AF 29 02                    ).
	beq     LF3C8                           ; F3B1 F0 15                    ..
	lda     ridbe                           ; F3B3 AD 7D 03                 .}.
	sta     ridbs                           ; F3B6 8D 7C 03                 .|.
	lda     ribuf+2                         ; F3B9 A5 A8                    ..
	and     #$F0                            ; F3BB 29 F0                    ).
	beq     LF3C8                           ; F3BD F0 09                    ..
	jsr     req256                         ; F3BF 20 03 F4                  ..
	sta     ribuf+2                         ; F3C2 85 A8                    ..
	stx     ribuf                           ; F3C4 86 A6                    ..
	sty     ribuf+1                         ; F3C6 84 A7                    ..
LF3C8:  bcc     LF3CD                           ; F3C8 90 03                    ..
	jmp     errorx                          ; F3CA 4C 5A F9                 LZ.
LF3CD:  rts                                     ; F3CD 60                       `

; -------------------------------------------------------------------------------------------------
; F3CE Convert PETSCII into ASCII for RS232
toascii:cmp     #$41                            ; F3CE C9 41                    .A
	bcc     LF3E2                           ; F3D0 90 10                    ..
	cmp     #$5B                            ; F3D2 C9 5B                    .[
	bcs     LF3D8                           ; F3D4 B0 02                    ..
	ora     #$20                            ; F3D6 09 20                    . 
LF3D8:  cmp     #$C1                            ; F3D8 C9 C1                    ..
	bcc     LF3E2                           ; F3DA 90 06                    ..
	cmp     #$DB                            ; F3DC C9 DB                    ..
	bcs     LF3E2                           ; F3DE B0 02                    ..
	and     #$7F                            ; F3E0 29 7F                    ).
LF3E2:  rts                                     ; F3E2 60                       `

; -------------------------------------------------------------------------------------------------
; F3E3 Convert ASCII to PETSCII for RS232
tocbm:  cmp     #$41                            ; F3E3 C9 41                    .A
	bcc     LF3F7                           ; F3E5 90 10                    ..
	cmp     #$5B                            ; F3E7 C9 5B                    .[
	bcs     LF3ED                           ; F3E9 B0 02                    ..
	ora     #$80                            ; F3EB 09 80                    ..
LF3ED:  cmp     #$61                            ; F3ED C9 61                    .a
	bcc     LF3F7                           ; F3EF 90 06                    ..
	cmp     #$7B                            ; F3F1 C9 7B                    .{
	bcs     LF3F7                           ; F3F3 B0 02                    ..
	and     #$DF                            ; F3F5 29 DF                    ).
LF3F7:  rts                                     ; F3F7 60                       `

; -------------------------------------------------------------------------------------------------
; F3F8 Allow RS232 interrupts
xon232: lda     acia+cdr                        ; F3F8 AD 02 DD                 ...
	ora     #$09                            ; F3FB 09 09                    ..
	and     #$FB                            ; F3FD 29 FB                    ).
	sta     acia+cdr                        ; F3FF 8D 02 DD                 ...
	rts                                     ; F402 60                       `
; -------------------------------------------------------------------------------------------------
; F403 req256 - request 256 bytes of space
;  (don't care where we get it...)
req256:	ldx #$00
	ldy #$01		; one page = 256 bytes
; -------------------------------------------------------------------------------------------------
; alocat - alocatate space
;  entry:
; *  .a- if .a=$ff then don't care what segment
; *  .a- if .a=$80 then we want bottom of memory
; *  .a- if .a=$40 then we want top of memory
; *  .a- if .a=$0x then we need segment x
;    .x- low # of bytes needed
;    .y- high # of bytes needed
;
;  exit :
;    c-clr  no problem alocatating space
;     .a,.x,.y is start address of alocatated space
;    c-set  problem with alocatation
;     if .a =$ff then alocatation refused (cannot cross segment boundrys)
; *   if .a =$8x then bottom of memory needs to be changed
;     if .a =$4x then top of memory needs to be changed
; *   if .a =$c0 then bottom>top  !! fatal error !!
;     return to language
;
; *=> not implemented yet  10/30/81 rsr (only top alocatation)
;-----------------------------------------------------------------------
; F407 alocatate buffer space X=low, Y=high bytes
alocat:
tttop:	txa			; calc new hiadr
	sec
	eor #$FF
	adc hiadr		; sub low from end of system RAM
	tax
	tya
	eor #$FF
	adc hiadr+1		; sub high
	tay
	lda hiadr+2		; load highest system RAM bank
	bcs top010
refuse:	lda #$FF		; allocation refused...crossed boundry
topbad:	ora #$40		; want top of memory changed
	sec			; C=1 Not enough memory available 
	rts			; return unsuccessful

top010:	cpy memsiz+1		; compare new high address with user memory high
	bcc topbad		; branch if new high lower = not enough memory alocatatable
	bne topxit		; branch to memoryok if new high > 
	cpx memsiz		; if higbyte equal compare low
	bcc topbad		; branch if lower = not enough memory alocatatable
topxit:	stx hiadr		; store new end of system memory ($)
	sty hiadr+1
	clc
	rts
; -------------------------------------------------------------------------------------------------
; rst232 - reset rs232 and dcd/dsr status
;          note, the dcd and dsr bits of rsstat reflect whether a
;          dsr or dcd error occured since the last time the user
;          examined rsstat.
;          dcdsr has the dcd/dsr states prior to their last state
;          changes.
;-----------------------------------------------------------------
; F435 Read the RS232 status
rdst232:php                                     ; F435 08                       .
	sei                                     ; F436 78                       x
	lda     acia+srsn                     ; F437 AD 01 DD                 ...
	and     #$60                            ; F43A 29 60                    )`
	sta     rsstat                          ; F43C 8D 7A 03                 .z.
	sta     dcdsr                           ; F43F 8D 7B 03                 .{.
	plp                                     ; F442 28                       (
	rts                                     ; F443 60                       `

; -------------------------------------------------------------------------------------------------
;*****************************************
;* getin -- get character from channel   *
;*      channel is determined by dfltn.  *
;* if device is 0, keyboard queue is     *
;* examined and a character removed if   *
;* available.  devices 1,3-31 advance to *
;* basin.                                *
;*                                       *
;* exit:  .a = character                 *
;*        cy = 1, stop key error for cas-*
;*                cassetes and rs232     *
;*           = 0, otherwise.             *
;*        z  = 1, if kbd and queue empty.*
;*****************************************
; F444 GETIN: Input 1 byte from the current input device
ngetin:  lda     dfltn                           ; F444 A5 A1                    ..
	bne     getinc2                         ; F446 D0 0C                    ..
	lda     ndx                             ; F448 A5 D1                    ..
	ora     kyndx                           ; F44A 05 D6                    ..
	beq     LF4A1                           ; F44C F0 53                    .S
	sei                                     ; F44E 78                       x
	jsr     jlp2                          ; F44F 20 07 E0                  ..
	clc                                     ; F452 18                       .
	rts                                     ; F453 60                       `

; -------------------------------------------------------------------------------------------------
; F454 Check for input from device 2 (RS232)
getinc2:cmp     #$02                            ; F454 C9 02                    ..
	beq     getin2                          ; F456 F0 03                    ..
	jmp     basin                          ; F458 4C CF FF                 L..

; -------------------------------------------------------------------------------------------------
; F45B GETIN routine for device 2 (RS232)
getin2: sty     xsav                            ; F45B 8C 65 03                 .e.
	stx     savx                            ; F45E 8E 66 03                 .f.
	ldy     ridbs                           ; F461 AC 7C 03                 .|.
	cpy     ridbe                           ; F464 CC 7D 03                 .}.
	bne     gn232a                          ; F467 D0 16                    ..
	lda     acia+cdr                        ; F469 AD 02 DD                 ...
	and     #$FD                            ; F46C 29 FD                    ).
	ora     #$01                            ; F46E 09 01                    ..
	sta     acia+cdr                        ; F470 8D 02 DD                 ...
	lda     rsstat                          ; F473 AD 7A 03                 .z.
	ora     #$10                            ; F476 09 10                    ..
	sta     rsstat                          ; F478 8D 7A 03                 .z.
	lda     #$00                            ; F47B A9 00                    ..
	beq     LF49B                           ; F47D F0 1C                    ..
; F47F Get one byte from RS232 input buffer
gn232a: lda     rsstat                          ; F47F AD 7A 03                 .z.
	and     #$EF                            ; F482 29 EF                    ).
	sta     rsstat                          ; F484 8D 7A 03                 .z.
	ldx     i6509                           ; F487 A6 01                    ..
	lda     ribuf+2                         ; F489 A5 A8                    ..
	sta     i6509                           ; F48B 85 01                    ..
	lda     (ribuf),y                       ; F48D B1 A6                    ..
	stx     i6509                           ; F48F 86 01                    ..
	inc     ridbs                           ; F491 EE 7C 03                 .|.
	bit     sa                              ; F494 24 A0                    $.
	bpl     LF49B                           ; F496 10 03                    ..
	jsr     tocbm                           ; F498 20 E3 F3                  ..
LF49B:  ldy     xsav                            ; F49B AC 65 03                 .e.
	ldx     savx                            ; F49E AE 66 03                 .f.
LF4A1:  clc                                     ; F4A1 18                       .
	rts                                     ; F4A2 60                       `

; -------------------------------------------------------------------------------------------------
;***************************************
;* basin-- input character from channel*
;*     input differs from get on device*
;* #0 function which is keyboard. the  *
;* screen editor makes ready an entire *
;* line which is passed char by char   *
;* up to the carriage return.  note,   *
;* rs232 uses getin to get each char.  *
;* other devices are:                  *
;*      0 -- keyboard                  *
;*      1 -- cassette #1               *
;*      2 -- rs232                     *
;*      3 -- screen                    *
;*   4-31 -- ieee   bus                *
;*                                     *
;* exit: cy=1, stop key error for cas- *
;*             settes and rs232.       *
;*       cy=0, otherwise.              *
;*                                     *
;*       all other errors must be de-  *
;*       tected by checking status !   *
;***************************************
; F4A3 BASIN: Input 1 byte from the current input device
nbasin:  lda     dfltn                           ; F4A3 A5 A1                    ..
	bne     basinc3                         ; F4A5 D0 0B                    ..
	lda     pntr                            ; F4A7 A5 CB                    ..
	sta     lstp                            ; F4A9 85 CE                    ..
	lda     tblx                            ; F4AB A5 CA                    ..
	sta     lsxp                            ; F4AD 85 CF                    ..
	jmp     basin3                          ; F4AF 4C BC F4                 L..

; -------------------------------------------------------------------------------------------------
; F4B2 Check for input from device 3 (screen)
basinc3:cmp     #$03                            ; F4B2 C9 03                    ..
	bne     LF4C1                           ; F4B4 D0 0B                    ..
	sta     crsw                            ; F4B6 85 D0                    ..
	lda     scrt                            ; F4B8 A5 DF                    ..
	sta     indx                            ; F4BA 85 D5                    ..
; F4BC BASIN: input from device 3 (screen)
basin3: jsr     jloop5                         ; F4BC 20 0A E0                  ..
	clc                                     ; F4BF 18                       .
	rts                                     ; F4C0 60                       `

; -------------------------------------------------------------------------------------------------
; F4C1 BASIN dispatcher, check inut devices
LF4C1:  bcs     LF4CA                           ; F4C1 B0 07                    ..
	cmp     #$02                            ; F4C3 C9 02                    ..
	beq     basin2                          ; F4C5 F0 10                    ..
	jsr     xtape                            ; F4C7 20 68 FE                  h.
LF4CA:  lda     status                          ; F4CA A5 9C                    ..
	beq     basind                          ; F4CC F0 04                    ..
LF4CE:  lda     #$0D                            ; F4CE A9 0D                    ..
LF4D0:  clc                                     ; F4D0 18                       .
LF4D1:  rts                                     ; F4D1 60                       `

; -------------------------------------------------------------------------------------------------
; F4D2 BASIN entry for IEC devices
basind: jsr     acptr                          ; F4D2 20 A5 FF                  ..
	clc                                     ; F4D5 18                       .
	rts                                     ; F4D6 60                       `

; -------------------------------------------------------------------------------------------------
; F4D7 BASIN routine for device 2 (RS232)
basin2: jsr     getin                          ; F4D7 20 E4 FF                  ..
	bcs     LF4D1                           ; F4DA B0 F5                    ..
	cmp     #$00                            ; F4DC C9 00                    ..
	bne     LF4D0                           ; F4DE D0 F0                    ..
	lda     rsstat                          ; F4E0 AD 7A 03                 .z.
	and     #$10                            ; F4E3 29 10                    ).
	beq     LF4D0                           ; F4E5 F0 E9                    ..
	lda     rsstat                          ; F4E7 AD 7A 03                 .z.
	and     #$60                            ; F4EA 29 60                    )`
	bne     LF4CE                           ; F4EC D0 E0                    ..
	jsr     stop                           ; F4EE 20 E1 FF                  ..
	bne     basin2                          ; F4F1 D0 E4                    ..
	sec                                     ; F4F3 38                       8
	rts                                     ; F4F4 60                       `

; -------------------------------------------------------------------------------------------------
;***************************************
;* bsout -- out character to channel   *
;*     determined by variable dflto:   *
;*     0 -- invalid                    *
;*     1 -- cassette #1                *
;*     2 -- rs232                      *
;*     3 -- screen                     *
;*  4-31 -- ieee   bus                 *
;*                                     *
;* exit:  cy=1, stop key error for cas-*
;*              settes and rs232.      *
;*        cy=0, otherwise.             *
;*                                     *
;*       note, other errors must be de-*
;*       tected by checking status !   *
;***************************************
; F4F5 Output 1 byte on current output device
nbsout:  pha                                     ; F4F5 48                       H
	lda     dflto                           ; F4F6 A5 A2                    ..
	cmp     #$03                            ; F4F8 C9 03                    ..
	bne     LF502                           ; F4FA D0 06                    ..
	pla                                     ; F4FC 68                       h
	jsr     jprt                          ; F4FD 20 0D E0                  ..
	clc                                     ; F500 18                       .
	rts                                     ; F501 60                       `

; -------------------------------------------------------------------------------------------------
; F502
LF502:  bcc     LF50A                           ; F502 90 06                    ..
	pla                                     ; F504 68                       h
	jsr     ciout                          ; F505 20 A8 FF                  ..
	clc                                     ; F508 18                       .
	rts                                     ; F509 60                       `

; -------------------------------------------------------------------------------------------------
; F50A
LF50A:  cmp     #$02                            ; F50A C9 02                    ..
	beq     LF518                           ; F50C F0 0A                    ..
	pla                                     ; F50E 68                       h
	jsr     xtape                            ; F50F 20 68 FE                  h.
LF512:  pla                                     ; F512 68                       h
	bcc     LF517                           ; F513 90 02                    ..
	lda     #$00                            ; F515 A9 00                    ..
LF517:  rts                                     ; F517 60                       `

; -------------------------------------------------------------------------------------------------
; F518
LF518:  stx     t1                              ; F518 8E 63 03                 .c.
	sty     t2                              ; F51B 8C 64 03                 .d.
	lda     rsstat                          ; F51E AD 7A 03                 .z.
	and     #$60                            ; F521 29 60                    )`
	bne     LF547                           ; F523 D0 22                    ."
	pla                                     ; F525 68                       h
	bit     sa                              ; F526 24 A0                    $.
	bpl     LF52D                           ; F528 10 03                    ..
	jsr     toascii                         ; F52A 20 CE F3                  ..
LF52D:  sta     acia+drsn                       ; F52D 8D 00 DD                 ...
	pha                                     ; F530 48                       H
LF531:  lda     rsstat                          ; F531 AD 7A 03                 .z.
	and     #$60                            ; F534 29 60                    )`
	bne     LF547                           ; F536 D0 0F                    ..
	lda     acia+srsn                     ; F538 AD 01 DD                 ...
	and     #$10                            ; F53B 29 10                    ).
	bne     LF547                           ; F53D D0 08                    ..
	jsr     stop                           ; F53F 20 E1 FF                  ..
	bne     LF531                           ; F542 D0 ED                    ..
	sec                                     ; F544 38                       8
	bcs     LF512                           ; F545 B0 CB                    ..
LF547:  pla                                     ; F547 68                       h
	ldx     t1                              ; F548 AE 63 03                 .c.
	ldy     t2                              ; F54B AC 64 03                 .d.
	clc                                     ; F54E 18                       .
	rts                                     ; F54F 60                       `

; -------------------------------------------------------------------------------------------------
;***************************************
;* nchkin -- open channel for input    *
;*                                     *
;* the number of the logical file to be*
;* opened for input is passed in .x.   *
;* chkin searches the logical file     *
;* to look up device and command info. *
;* errors are reported if the device   *
;* was not opened for input ,(e.g.     *
;* cassette write file), or the logical*
;* file has no reference in the tables.*
;* device 0, (keyboard), and device 3  *
;* (screen), require no table entries  *
;* and are handled separate.           *
;***************************************
; F550 Open an input channel (la in X)
nchkin:  jsr     lookup                          ; F550 20 45 F6                  E.
	beq     LF558                           ; F553 F0 03                    ..
	jmp     error3                          ; F555 4C 46 F9                 LF.

; -------------------------------------------------------------------------------------------------
; F558
LF558:  jsr     fz100                           ; F558 20 57 F6                  W.
	lda     fa                              ; F55B A5 9F                    ..
	beq     LF58D                           ; F55D F0 2E                    ..
	cmp     #$03                            ; F55F C9 03                    ..
	beq     LF58D                           ; F561 F0 2A                    .*
	bcs     LF591                           ; F563 B0 2C                    .,
	cmp     #$02                            ; F565 C9 02                    ..
	bne     LF587                           ; F567 D0 1E                    ..
	lda     sa                              ; F569 A5 A0                    ..
	and     #$02                            ; F56B 29 02                    ).
	beq     LF58A                           ; F56D F0 1B                    ..
	and     acia+cdr                        ; F56F 2D 02 DD                 -..
	beq     LF583                           ; F572 F0 0F                    ..
	eor     #$FF                            ; F574 49 FF                    I.
	and     acia+cdr                        ; F576 2D 02 DD                 -..
	ora     #$01                            ; F579 09 01                    ..
	pha                                     ; F57B 48                       H
	jsr     rdst232                         ; F57C 20 35 F4                  5.
	pla                                     ; F57F 68                       h
	sta     acia+cdr                        ; F580 8D 02 DD                 ...
LF583:  lda     #$02                            ; F583 A9 02                    ..
	bne     LF58D                           ; F585 D0 06                    ..
LF587:  jsr     xtape                            ; F587 20 68 FE                  h.
LF58A:  jmp     error6                          ; F58A 4C 4F F9                 LO.

; -------------------------------------------------------------------------------------------------
; F58D
LF58D:  sta     dfltn                           ; F58D 85 A1                    ..
	clc                                     ; F58F 18                       .
	rts                                     ; F590 60                       `

; -------------------------------------------------------------------------------------------------
; F591
LF591:  tax                                     ; F591 AA                       .
	jsr     talk                           ; F592 20 B4 FF                  ..
	lda     sa                              ; F595 A5 A0                    ..
	bpl     LF59F                           ; F597 10 06                    ..
	jsr     tkatn                           ; F599 20 8A F2                  ..
	jmp     LF5A2                           ; F59C 4C A2 F5                 L..

; -------------------------------------------------------------------------------------------------
; F59F
LF59F:  jsr     ktksa                           ; F59F 20 96 FF                  ..
LF5A2:  txa                                     ; F5A2 8A                       .
	bit     status                          ; F5A3 24 9C                    $.
	bpl     LF58D                           ; F5A5 10 E6                    ..
	jmp     error5                          ; F5A7 4C 4C F9                 LL.

; -------------------------------------------------------------------------------------------------
;***************************************
;* chkout -- open channel for output   *
;*                                     *
;* the number of the logical file to be*
;* opened for output is passed in .x.  *
;* chkout searches the logical file    *
;* to look up device and command info. *
;* errors are reported if the device   *
;* was not opened for input ,(e.g.     *
;* keyboard), or the logical file has  *
;* reference in the tables.            *
;* device 0, (keyboard), and device 3  *
;* (screen), require no table entries  *
;* and are handled separate.           *
;***************************************
; F5AA Open an output channel (la in X)
nckout:  jsr     lookup                          ; F5AA 20 45 F6                  E.
	beq     LF5B2                           ; F5AD F0 03                    ..
	jmp     error3                          ; F5AF 4C 46 F9                 LF.

; -------------------------------------------------------------------------------------------------
; F5B2
LF5B2:  jsr     fz100                           ; F5B2 20 57 F6                  W.
	lda     fa                              ; F5B5 A5 9F                    ..
	bne     LF5BC                           ; F5B7 D0 03                    ..
LF5B9:  jmp     error7                          ; F5B9 4C 52 F9                 LR.

; -------------------------------------------------------------------------------------------------
; F5BC
LF5BC:  cmp     #$03                            ; F5BC C9 03                    ..
	beq     LF5D8                           ; F5BE F0 18                    ..
	bcs     LF5DC                           ; F5C0 B0 1A                    ..
	cmp     #$02                            ; F5C2 C9 02                    ..
	bne     LF5D5                           ; F5C4 D0 0F                    ..
	lda     sa                              ; F5C6 A5 A0                    ..
	lsr                                     ; F5C8 4A                       J
	bcc     LF5B9                           ; F5C9 90 EE                    ..
	jsr     rdst232                         ; F5CB 20 35 F4                  5.
	jsr     xon232                          ; F5CE 20 F8 F3                  ..
	lda     #$02                            ; F5D1 A9 02                    ..
	bne     LF5D8                           ; F5D3 D0 03                    ..
LF5D5:  jsr     xtape                            ; F5D5 20 68 FE                  h.
LF5D8:  sta     dflto                           ; F5D8 85 A2                    ..
	clc                                     ; F5DA 18                       .
	rts                                     ; F5DB 60                       `

; -------------------------------------------------------------------------------------------------
; F5DC
LF5DC:  tax                                     ; F5DC AA                       .
	jsr     listn                         ; F5DD 20 B1 FF                  ..
	lda     sa                              ; F5E0 A5 A0                    ..
	bpl     LF5E9                           ; F5E2 10 05                    ..
	jsr     secatn                          ; F5E4 20 7E F2                  ~.
	bne     LF5EC                           ; F5E7 D0 03                    ..
LF5E9:  jsr     secnd                          ; F5E9 20 93 FF                  ..
LF5EC:  txa                                     ; F5EC 8A                       .
	bit     status                          ; F5ED 24 9C                    $.
	bpl     LF5D8                           ; F5EF 10 E7                    ..
	jmp     error5                          ; F5F1 4C 4C F9                 LL.

; -------------------------------------------------------------------------------------------------
;*************************************
;* nclose -- close logical file      *
;*                                   *
;* enter:                            *
;*     cy =1 ,transmit close to dev- *
;*            ice.                   *
;*     cy =0 ,only remove from kernal*
;*            tables.                *
;*                                   *
;*     the logical file number of the*
;* file to be closed is passed in .a.*
;* keyboard, screen, and files not   *
;* open pass straight through. tape  *
;* files open for write are closed by*
;* dumping the last buffer and       *
;* conditionally writing an end of   *
;* tape block.serial files are closed*
;* by sending a close file command if*
;* a secondary address was specified *
;* in its open command.              *
;*************************************
; F5F4 Close a logical file
nclose:  php                                     ; F5F4 08                       .
	jsr     LF64A                           ; F5F5 20 4A F6                  J.
	beq     LF5FD                           ; F5F8 F0 03                    ..
	plp                                     ; F5FA 28                       (
	clc                                     ; F5FB 18                       .
	rts                                     ; F5FC 60                       `

; -------------------------------------------------------------------------------------------------
; F5FD
LF5FD:  jsr     fz100                           ; F5FD 20 57 F6                  W.
	plp                                     ; F600 28                       (
	txa                                     ; F601 8A                       .
	pha                                     ; F602 48                       H
	bcc     LF624                           ; F603 90 1F                    ..
	lda     fa                              ; F605 A5 9F                    ..
	beq     LF624                           ; F607 F0 1B                    ..
	cmp     #$03                            ; F609 C9 03                    ..
	beq     LF624                           ; F60B F0 17                    ..
	bcs     LF621                           ; F60D B0 12                    ..
	cmp     #$02                            ; F60F C9 02                    ..
	bne     LF61A                           ; F611 D0 07                    ..
	lda     #$00                            ; F613 A9 00                    ..
	sta     acia+cdr                        ; F615 8D 02 DD                 ...
	beq     LF624                           ; F618 F0 0A                    ..
LF61A:  pla                                     ; F61A 68                       h
	jsr     LF625                           ; F61B 20 25 F6                  %.
	jsr     xtape                            ; F61E 20 68 FE                  h.
LF621:  jsr     clsei                           ; F621 20 C6 F8                  ..
LF624:  pla                                     ; F624 68                       h
LF625:  tax                                     ; F625 AA                       .
	dec     ldtnd                           ; F626 CE 60 03                 .`.
	cpx     ldtnd                           ; F629 EC 60 03                 .`.
	beq     LF643                           ; F62C F0 15                    ..
	ldy     ldtnd                           ; F62E AC 60 03                 .`.
	lda     lat,y                           ; F631 B9 34 03                 .4.
	sta     lat,x                           ; F634 9D 34 03                 .4.
	lda     fat,y                           ; F637 B9 3E 03                 .>.
	sta     fat,x                           ; F63A 9D 3E 03                 .>.
	lda     sat,y                           ; F63D B9 48 03                 .H.
	sta     sat,x                           ; F640 9D 48 03                 .H.
LF643:  clc                                     ; F643 18                       .
	rts                                     ; F644 60                       `

; -------------------------------------------------------------------------------------------------
; F645
lookup: lda     #$00                            ; F645 A9 00                    ..
	sta     status                          ; F647 85 9C                    ..
	txa                                     ; F649 8A                       .
LF64A:  ldx     ldtnd                           ; F64A AE 60 03                 .`.
LF64D:  dex                                     ; F64D CA                       .
	bmi     LF67D                           ; F64E 30 2D                    0-
	cmp     lat,x                           ; F650 DD 34 03                 .4.
	bne     LF64D                           ; F653 D0 F8                    ..
	clc                                     ; F655 18                       .
	rts                                     ; F656 60                       `

; -------------------------------------------------------------------------------------------------
; F657
fz100:  lda     lat,x                           ; F657 BD 34 03                 .4.
	sta     la                              ; F65A 85 9E                    ..
	lda     fat,x                           ; F65C BD 3E 03                 .>.
	sta     fa                              ; F65F 85 9F                    ..
	lda     sat,x                           ; F661 BD 48 03                 .H.
	sta     sa                              ; F664 85 A0                    ..
	rts                                     ; F666 60                       `

; -------------------------------------------------------------------------------------------------
; F667
lkupsa: tya                                     ; F667 98                       .
	ldx     ldtnd                           ; F668 AE 60 03                 .`.
LF66B:  dex                                     ; F66B CA                       .
	bmi     LF67D                           ; F66C 30 0F                    0.
	cmp     sat,x                           ; F66E DD 48 03                 .H.
	bne     LF66B                           ; F671 D0 F8                    ..
	clc                                     ; F673 18                       .
LF674:  jsr     fz100                           ; F674 20 57 F6                  W.
	tay                                     ; F677 A8                       .
	lda     la                              ; F678 A5 9E                    ..
	ldx     fa                              ; F67A A6 9F                    ..
	rts                                     ; F67C 60                       `

; -------------------------------------------------------------------------------------------------
; F67D
LF67D:  sec                                     ; F67D 38                       8
	rts                                     ; F67E 60                       `

; -------------------------------------------------------------------------------------------------
; F67F
lkupla: tax                                     ; F67F AA                       .
	jsr     lookup                          ; F680 20 45 F6                  E.
	bcc     LF674                           ; F683 90 EF                    ..
	rts                                     ; F685 60                       `

; -------------------------------------------------------------------------------------------------
;******************************************
;* nclall -- close all logical files      *
;*      deletes all table entries and     *
;* restores default i/o channels          *
;* and clears ieee port devices           *
;******************************************
;------------------------------------------
; new ncall
;  closes all files untill done or an
;  error occurs.
;  entry:
;    c-clr => close all files
;    c-set => .a = fa (device to be closed)
;------------------------------------------
; F686 Close all logical files
nclall: ror     xsav                            ; F686 6E 65 03                 ne.
	sta     savx                            ; F689 8D 66 03                 .f.
LF68C:  ldx     ldtnd                           ; F68C AE 60 03                 .`.
LF68F:  dex                                     ; F68F CA                       .
	bmi     LF6A8                           ; F690 30 16                    0.
	bit     xsav                            ; F692 2C 65 03                 ,e.
	bpl     LF69F                           ; F695 10 08                    ..
	lda     savx                            ; F697 AD 66 03                 .f.
	cmp     fat,x                           ; F69A DD 3E 03                 .>.
	bne     LF68F                           ; F69D D0 F0                    ..
LF69F:  lda     lat,x                           ; F69F BD 34 03                 .4.
	sec                                     ; F6A2 38                       8
	jsr     close                          ; F6A3 20 C3 FF                  ..
	bcc     LF68C                           ; F6A6 90 E4                    ..
LF6A8:  lda     #$00                            ; F6A8 A9 00                    ..
	sta     ldtnd                           ; F6AA 8D 60 03                 .`.
;********************************************
;* nclrch -- clear channels                 *
;*   unlisten or untalk ieee devices, but   *
;* leave others alone.  default channels    *
;* are restored.                            *
;********************************************
; F6AD Unlisten/untalk on IEC
nclrch:  ldx     #$03                            ; F6AD A2 03                    ..
	cpx     dflto                           ; F6AF E4 A2                    ..
	bcs     LF6B6                           ; F6B1 B0 03                    ..
	jsr     unlsn                          ; F6B3 20 AE FF                  ..
LF6B6:  cpx     dfltn                           ; F6B6 E4 A1                    ..
	bcs     LF6BD                           ; F6B8 B0 03                    ..
	jsr     untlk                         ; F6BA 20 AB FF                  ..
LF6BD:  ldx     #$03                            ; F6BD A2 03                    ..
	stx     dflto                           ; F6BF 86 A2                    ..
	lda     #$00                            ; F6C1 A9 00                    ..
	sta     dfltn                           ; F6C3 85 A1                    ..
	rts                                     ; F6C5 60                       `

; -------------------------------------------------------------------------------------------------
;***********************************
;*                                 *
;* open function                   *
;*                                 *
;* enter: cy=1, transmit command to*
;*              device.            *
;*        cy=0, perform open opera-*
;*              tion.              *
;*                                 *
;* la, fa, sa must be set up prior *
;* to the call to this routine, as *
;* well as the file name descript- *
;* tor.                            *
;*                                 *
;***********************************
; F6C6 Open a logical file, output the filename
nopen:   bcc     LF6CB                           ; F6C6 90 03                    ..
	jmp     tranr                           ; F6C8 4C 41 F7                 LA.

; -------------------------------------------------------------------------------------------------
;***********************************
;*                                 *
;* create an entry in the logical  *
;* files tables consisting of      *
;* logical file number--la, device *
;* number--fa, and secondary cmd-- *
;* sa.                             *
;*                                 *
;* a file name descriptor, fnadr & *
;* fnlen, is passed to this routine*
;*                                 *
;***********************************
; F6CB
LF6CB:  ldx     la                              ; F6CB A6 9E                    ..
	jsr     lookup                          ; F6CD 20 45 F6                  E.
	bne     LF6D5                           ; F6D0 D0 03                    ..
	jmp     error2                          ; F6D2 4C 43 F9                 LC.

; -------------------------------------------------------------------------------------------------
; F6D5
LF6D5:  ldx     ldtnd                           ; F6D5 AE 60 03                 .`.
	cpx     #$0A                            ; F6D8 E0 0A                    ..
	bcc     LF6DF                           ; F6DA 90 03                    ..
	jmp     error1                          ; F6DC 4C 40 F9                 L@.

; -------------------------------------------------------------------------------------------------
; F6DF
LF6DF:  inc     ldtnd                           ; F6DF EE 60 03                 .`.
	lda     la                              ; F6E2 A5 9E                    ..
	sta     lat,x                           ; F6E4 9D 34 03                 .4.
	lda     sa                              ; F6E7 A5 A0                    ..
	ora     #$60                            ; F6E9 09 60                    .`
	sta     sa                              ; F6EB 85 A0                    ..
	sta     sat,x                           ; F6ED 9D 48 03                 .H.
	lda     fa                              ; F6F0 A5 9F                    ..
	sta     fat,x                           ; F6F2 9D 3E 03                 .>.
	beq     LF70C                           ; F6F5 F0 15                    ..
	cmp     #$03                            ; F6F7 C9 03                    ..
	beq     LF70C                           ; F6F9 F0 11                    ..
	bcc     LF702                           ; F6FB 90 05                    ..
	jsr     openi                           ; F6FD 20 0E F7                  ..
	bcc     LF70C                           ; F700 90 0A                    ..
LF702:  cmp     #$02                            ; F702 C9 02                    ..
	bne     LF709                           ; F704 D0 03                    ..
	jmp     opn232                         ; F706 4C 88 F3                 L..

; -------------------------------------------------------------------------------------------------
; F709
LF709:  jsr     xtape                            ; F709 20 68 FE                  h.
LF70C:  clc                                     ; F70C 18                       .
	rts                                     ; F70D 60                       `

; -------------------------------------------------------------------------------------------------
; F70E Open on IEC
openi:  lda     sa                              ; F70E A5 A0                    ..
	bmi     LF73F                           ; F710 30 2D                    0-
	ldy     fnlen                           ; F712 A4 9D                    ..
	beq     LF73F                           ; F714 F0 29                    .)
	lda     fa                              ; F716 A5 9F                    ..
	jsr     listn                         ; F718 20 B1 FF                  ..
	lda     sa                              ; F71B A5 A0                    ..
	ora     #$F0                            ; F71D 09 F0                    ..
; F71F Output sa and filename on IEC
openib: jsr     secnd                          ; F71F 20 93 FF                  ..
	lda     status                          ; F722 A5 9C                    ..
	bpl     LF72B                           ; F724 10 05                    ..
	pla                                     ; F726 68                       h
	pla                                     ; F727 68                       h
	jmp     error5                          ; F728 4C 4C F9                 LL.

; -------------------------------------------------------------------------------------------------
; F72B
LF72B:  lda     fnlen                           ; F72B A5 9D                    ..
	beq     LF73C                           ; F72D F0 0D                    ..
; F72F Output filename on IEC
openfn: ldy     #$00                            ; F72F A0 00                    ..
LF731:  jsr     fnadry                          ; F731 20 A0 FE                  ..
	jsr     ciout                          ; F734 20 A8 FF                  ..
	iny                                     ; F737 C8                       .
	cpy     fnlen                           ; F738 C4 9D                    ..
	bne     LF731                           ; F73A D0 F5                    ..
LF73C:  jsr     unlsn                          ; F73C 20 AE FF                  ..
LF73F:  clc                                     ; F73F 18                       .
	rts                                     ; F740 60                       `

; -------------------------------------------------------------------------------------------------
;*****************************************
;*  transmit command to device           *
;*                                       *
;*   fnlen,fnadr must be set up already  *
;*   to contain the command string.      *
;*   fa must be set for the device.      *
;*****************************************
; F741 Output sa 15 + name on IEC
tranr:  lda     fa                              ; F741 A5 9F                    ..
	jsr     listn                         ; F743 20 B1 FF                  ..
	lda     #$6F                            ; F746 A9 6F                    .o
	sta     sa                              ; F748 85 A0                    ..
	jmp     openib                          ; F74A 4C 1F F7                 L..

; -------------------------------------------------------------------------------------------------
;**************************************
;* load ram function     10/30/81     *
;*                                    *
;*  loads from cassette 1 or 2, or    *
;*  ieee bus devices >=4 to 31 as     *
;*  determined by contents of         *
;*  variable fa.                      *
;* entry:                             *
;*   .a(bit 7)=0 performs load        *
;*   .a(bit 7)=1 performs verify      *
;*   .a(bits 0123)=start segment      *
;*   .x=start address low             *
;*   .y=start address high            *
;*   if .x=$ff & .y=$ff => fixed load *
;* exit:                              *
;*   .a(bits 0123)=end segment        *
;*   .x=end address low               *
;*   .y=end address high              *
;*                                    *
;**************************************
; F74D Load from logical file
nload:   stx     relsal                          ; F74D 8E 6F 03                 .o.
	sty     relsah                          ; F750 8C 70 03                 .p.
	sta     verck                           ; F753 8D 5F 03                 ._.
	sta     relsas                          ; F756 8D 71 03                 .q.
	lda     #$00                            ; F759 A9 00                    ..
	sta     status                          ; F75B 85 9C                    ..
	lda     fa                              ; F75D A5 9F                    ..
	bne     load2                           ; F75F D0 03                    ..
load1:  jmp     error9                          ; F761 4C 58 F9                 LX.

; -------------------------------------------------------------------------------------------------
; F764 Dispatch based on load device
load2:  cmp     #$03                            ; F764 C9 03                    ..
	beq     load1                           ; F766 F0 F9                    ..
	bcs     load3                           ; F768 B0 03                    ..
	jmp     load11                          ; F76A 4C 17 F8                 L..

; -------------------------------------------------------------------------------------------------
; F76D Load from IEC
load3:  lda     #$60                            ; F76D A9 60                    .`
	sta     sa                              ; F76F 85 A0                    ..
	ldy     fnlen                           ; F771 A4 9D                    ..
	bne     load4                           ; F773 D0 03                    ..
	jmp     error8                          ; F775 4C 55 F9                 LU.

; -------------------------------------------------------------------------------------------------
; F778
load4:  jsr     srching                         ; F778 20 22 F8                  ".
	jsr     openi                           ; F77B 20 0E F7                  ..
	lda     fa                              ; F77E A5 9F                    ..
	jsr     talk                           ; F780 20 B4 FF                  ..
	lda     sa                              ; F783 A5 A0                    ..
	jsr     ktksa                           ; F785 20 96 FF                  ..
	jsr     acptr                          ; F788 20 A5 FF                  ..
	sta     eal                             ; F78B 85 96                    ..
	sta     stal                            ; F78D 85 99                    ..
	lda     status                          ; F78F A5 9C                    ..
	lsr                                     ; F791 4A                       J
	lsr                                     ; F792 4A                       J
	bcc     load5                           ; F793 90 03                    ..
	jmp     error4                          ; F795 4C 49 F9                 LI.

; -------------------------------------------------------------------------------------------------
; F798
load5:  jsr     acptr                          ; F798 20 A5 FF                  ..
	sta     eah                             ; F79B 85 97                    ..
	sta     stah                            ; F79D 85 9A                    ..
	jsr     loading                         ; F79F 20 47 F8                  G.
	lda     relsas                          ; F7A2 AD 71 03                 .q.
	sta     eas                             ; F7A5 85 98                    ..
	sta     stas                            ; F7A7 85 9B                    ..
	lda     relsal                          ; F7A9 AD 6F 03                 .o.
	and     relsah                          ; F7AC 2D 70 03                 -p.
	cmp     #$FF                            ; F7AF C9 FF                    ..
	beq     load6                           ; F7B1 F0 0E                    ..
	lda     relsal                          ; F7B3 AD 6F 03                 .o.
	sta     eal                             ; F7B6 85 96                    ..
	sta     stal                            ; F7B8 85 99                    ..
	lda     relsah                          ; F7BA AD 70 03                 .p.
	sta     eah                             ; F7BD 85 97                    ..
	sta     stah                            ; F7BF 85 9A                    ..
; F7C1 Wait if IEC timeout
load6:  lda     #$FD                            ; F7C1 A9 FD                    ..
	and     status                          ; F7C3 25 9C                    %.
	sta     status                          ; F7C5 85 9C                    ..
	jsr     stop                           ; F7C7 20 E1 FF                  ..
	bne     load7                           ; F7CA D0 03                    ..
	jmp     break                           ; F7CC 4C BA F8                 L..

; -------------------------------------------------------------------------------------------------
; F7CF
load7:  jsr     acptr                          ; F7CF 20 A5 FF                  ..
	tax                                     ; F7D2 AA                       .
	lda     status                          ; F7D3 A5 9C                    ..
	lsr                                     ; F7D5 4A                       J
	lsr                                     ; F7D6 4A                       J
	bcs     load6                           ; F7D7 B0 E8                    ..
	txa                                     ; F7D9 8A                       .
	ldx     i6509                           ; F7DA A6 01                    ..
	ldy     eas                             ; F7DC A4 98                    ..
	sty     i6509                           ; F7DE 84 01                    ..
	ldy     #$00                            ; F7E0 A0 00                    ..
	bit     verck                           ; F7E2 2C 5F 03                 ,_.
	bpl     load8                           ; F7E5 10 0E                    ..
	sta     sal                             ; F7E7 85 93                    ..
	lda     (eal),y                         ; F7E9 B1 96                    ..
	cmp     sal                             ; F7EB C5 93                    ..
	beq     load9                           ; F7ED F0 08                    ..
	lda     #$10                            ; F7EF A9 10                    ..
	jsr     udst                            ; F7F1 20 6E FB                  n.
	!byte   $AD                                     ; F7F4 AD                       .
load8:  sta     (eal),y                         ; F7F5 91 96                    ..
load9:  stx     i6509                           ; F7F7 86 01                    ..
	inc     eal                             ; F7F9 E6 96                    ..
	bne     load10                          ; F7FB D0 0A                    ..
	inc     eah                             ; F7FD E6 97                    ..
	bne     load10                          ; F7FF D0 06                    ..
	inc     eas                             ; F801 E6 98                    ..
	lda     #$02                            ; F803 A9 02                    ..
	sta     eal                             ; F805 85 96                    ..
load10: bit     status                          ; F807 24 9C                    $.
	bvc     load6                           ; F809 50 B6                    P.
	jsr     untlk                         ; F80B 20 AB FF                  ..
	jsr     clsei                           ; F80E 20 C6 F8                  ..
	jmp     load12                          ; F811 4C 1A F8                 L..

; -------------------------------------------------------------------------------------------------
; F814 
	jmp     error4                          ; F814 4C 49 F9                 LI.

; -------------------------------------------------------------------------------------------------
; F817 Load from cassette
load11: jsr     xtape                            ; F817 20 68 FE                  h.
load12: clc                                     ; F81A 18                       .
	lda     eas                             ; F81B A5 98                    ..
	ldx     eal                             ; F81D A6 96                    ..
	ldy     eah                             ; F81F A4 97                    ..
	rts                                     ; F821 60                       `

; -------------------------------------------------------------------------------------------------
; F822 In direct mode, print "searching ..."
srching:bit     msgflg                          ; F822 2C 61 03                 ,a.
	bpl     LF846                           ; F825 10 1F                    ..
	ldy     #$0C                            ; F827 A0 0C                    ..
	jsr     spmsg                           ; F829 20 23 F2                  #.
	lda     fnlen                           ; F82C A5 9D                    ..
	beq     LF846                           ; F82E F0 16                    ..
	ldy     #$17                            ; F830 A0 17                    ..
	jsr     spmsg                           ; F832 20 23 F2                  #.
outfn:  ldy     fnlen                           ; F835 A4 9D                    ..
	beq     LF846                           ; F837 F0 0D                    ..
	ldy     #$00                            ; F839 A0 00                    ..
LF83B:  jsr     fnadry                          ; F83B 20 A0 FE                  ..
	jsr     kbsout                          ; F83E 20 D2 FF                  ..
	iny                                     ; F841 C8                       .
	cpy     fnlen                           ; F842 C4 9D                    ..
	bne     LF83B                           ; F844 D0 F5                    ..
LF846:  rts                                     ; F846 60                       `

; -------------------------------------------------------------------------------------------------
; F847 In direct mode, print "loading ..."
loading:ldy     #$1B                            ; F847 A0 1B                    ..
	lda     verck                           ; F849 AD 5F 03                 ._.
	bpl     LF850                           ; F84C 10 02                    ..
	ldy     #$2B                            ; F84E A0 2B                    .+
LF850:  jmp     spmsg                           ; F850 4C 23 F2                 L#.

; -------------------------------------------------------------------------------------------------
;***************************************
;* nsave              10/30/81         *
;*                                     *
;* saves to cassette 1 or 2, or        *
;* ieee devices 4>=n>=31 as selected   *
;* by variable fa.                     *
;*                                     *
;* .x => zpage address of start vector *
;* .y => zpage address of end vector   *
;***************************************
; F853 Save to logical file
nsave:   lda     e6509,x                         ; F853 B5 00                    ..
	sta     stal                            ; F855 85 99                    ..
	lda     i6509,x                         ; F857 B5 01                    ..
	sta     stah                            ; F859 85 9A                    ..
	lda     $02,x                           ; F85B B5 02                    ..
	sta     stas                            ; F85D 85 9B                    ..
	tya                                     ; F85F 98                       .
	tax                                     ; F860 AA                       .
	lda     e6509,x                         ; F861 B5 00                    ..
	sta     eal                             ; F863 85 96                    ..
	lda     i6509,x                         ; F865 B5 01                    ..
	sta     eah                             ; F867 85 97                    ..
	lda     $02,x                           ; F869 B5 02                    ..
	sta     eas                             ; F86B 85 98                    ..
	lda     fa                              ; F86D A5 9F                    ..
	bne     save2                           ; F86F D0 03                    ..
save1:  jmp     error9                          ; F871 4C 58 F9                 LX.

; -------------------------------------------------------------------------------------------------
; F874 
save2:  cmp     #$03                            ; F874 C9 03                    ..
	beq     save1                           ; F876 F0 F9                    ..
	bcc     save8                           ; F878 90 63                    .c
	lda     #$61                            ; F87A A9 61                    .a
	sta     sa                              ; F87C 85 A0                    ..
	ldy     fnlen                           ; F87E A4 9D                    ..
	bne     save3                           ; F880 D0 03                    ..
	jmp     error8                          ; F882 4C 55 F9                 LU.

; -------------------------------------------------------------------------------------------------
; F885 Open file on IEC for writing
save3:  jsr     openi                           ; F885 20 0E F7                  ..
	jsr     saving                          ; F888 20 E0 F8                  ..
	lda     fa                              ; F88B A5 9F                    ..
	jsr     listn                         ; F88D 20 B1 FF                  ..
	lda     sa                              ; F890 A5 A0                    ..
	jsr     secnd                          ; F892 20 93 FF                  ..
	ldx     i6509                           ; F895 A6 01                    ..
	jsr     rd300                           ; F897 20 70 FE                  p.
	lda     sal                             ; F89A A5 93                    ..
	jsr     ciout                          ; F89C 20 A8 FF                  ..
	lda     sah                             ; F89F A5 94                    ..
	jsr     ciout                          ; F8A1 20 A8 FF                  ..
	ldy     #$00                            ; F8A4 A0 00                    ..
save4:  jsr     cmpste                          ; F8A6 20 7F FE                  ..
	bcs     save5                           ; F8A9 B0 16                    ..
	lda     (sal),y                         ; F8AB B1 93                    ..
	jsr     ciout                          ; F8AD 20 A8 FF                  ..
	jsr     incsal                          ; F8B0 20 8D FE                  ..
	jsr     stop                           ; F8B3 20 E1 FF                  ..
	bne     save4                           ; F8B6 D0 EE                    ..
	stx     i6509                           ; F8B8 86 01                    ..
break:  jsr     clsei                           ; F8BA 20 C6 F8                  ..
	lda     #$00                            ; F8BD A9 00                    ..
	sec                                     ; F8BF 38                       8
	rts                                     ; F8C0 60                       `

; -------------------------------------------------------------------------------------------------
; F8C1 
save5:  stx     i6509                           ; F8C1 86 01                    ..
	jsr     unlsn                          ; F8C3 20 AE FF                  ..
; F8C6 Close IEC program file
clsei:  bit     sa                              ; F8C6 24 A0                    $.
	bmi     save6                           ; F8C8 30 11                    0.
	lda     fa                              ; F8CA A5 9F                    ..
	jsr     listn                         ; F8CC 20 B1 FF                  ..
	lda     sa                              ; F8CF A5 A0                    ..
	and     #$EF                            ; F8D1 29 EF                    ).
	ora     #$E0                            ; F8D3 09 E0                    ..
	jsr     secnd                          ; F8D5 20 93 FF                  ..
	jsr     unlsn                          ; F8D8 20 AE FF                  ..
save6:  clc                                     ; F8DB 18                       .
save7:  rts                                     ; F8DC 60                       `

; -------------------------------------------------------------------------------------------------
; F8DD Open device number < 3 for writing
save8:  jsr     xtape                            ; F8DD 20 68 FE                  h.
; F8E0 In direct mode, print "saving ..."
saving: lda     msgflg                          ; F8E0 AD 61 03                 .a.
	bpl     save7                           ; F8E3 10 F7                    ..
	ldy     #$23                            ; F8E5 A0 23                    .#
	jsr     spmsg                           ; F8E7 20 23 F2                  #.
	jmp     outfn                           ; F8EA 4C 35 F8                 L5.
; -------------------------------------------------------------------------------------------------
; time and alarm routines for 6526
;      rsr 11/12/81
;
; rdtim - read the time
;  .y = (bit7=pm,bit6/5=t8/t4,bits4-0 hrs)
;  .x = (bit7=t2,bits6-0 minutes)
;  .a = (bit7=t1,bits6-0 seconds)
;----------------------------------------
; F8ED Read the time from the TOD clock
rdtim:  lda     cia+tod10                      ; F8ED AD 08 DC                 ...
	pha                                     ; F8F0 48                       H
	pha                                     ; F8F1 48                       H
	asl                                     ; F8F2 0A                       .
	asl                                     ; F8F3 0A                       .
	asl                                     ; F8F4 0A                       .
	and     #$60                            ; F8F5 29 60                    )`
	ora     cia+todhr                      ; F8F7 0D 0B DC                 ...
	tay                                     ; F8FA A8                       .
	pla                                     ; F8FB 68                       h
	ror                                     ; F8FC 6A                       j
	ror                                     ; F8FD 6A                       j
	and     #$80                            ; F8FE 29 80                    ).
	ora     cia+todsec                     ; F900 0D 09 DC                 ...
	sta     sal                             ; F903 85 93                    ..
	ror                                     ; F905 6A                       j
	and     #$80                            ; F906 29 80                    ).
	ora     cia+todmin                     ; F908 0D 0A DC                 ...
	tax                                     ; F90B AA                       .
	pla                                     ; F90C 68                       h
	cmp     cia+tod10                      ; F90D CD 08 DC                 ...
	bne     rdtim                           ; F910 D0 DB                    ..
	lda     sal                             ; F912 A5 93                    ..
	rts                                     ; F914 60                       `

; -------------------------------------------------------------------------------------------------
;----------------------------------------
; settim - set tod and alarm
;  c-set => set alarm
;  c-clr => set tod
;  registers same as rdtim
;----------------------------------------
; F915 Set the time
settim: pha                                     ; F915 48                       H
	pha                                     ; F916 48                       H
	ror                                     ; F917 6A                       j
	and     #$80                            ; F918 29 80                    ).
	ora     cia+crb                        ; F91A 0D 0F DC                 ...
	sta     cia+crb                        ; F91D 8D 0F DC                 ...
	tya                                     ; F920 98                       .
	rol                                     ; F921 2A                       *
	rol                                     ; F922 2A                       *
	rol     sal                             ; F923 26 93                    &.
	rol                                     ; F925 2A                       *
	rol     sal                             ; F926 26 93                    &.
	txa                                     ; F928 8A                       .
	rol                                     ; F929 2A                       *
	rol     sal                             ; F92A 26 93                    &.
	pla                                     ; F92C 68                       h
	rol                                     ; F92D 2A                       *
	rol     sal                             ; F92E 26 93                    &.
	sty     cia+todhr                      ; F930 8C 0B DC                 ...
	stx     cia+todmin                     ; F933 8E 0A DC                 ...
	pla                                     ; F936 68                       h
	sta     cia+todsec                     ; F937 8D 09 DC                 ...
	lda     sal                             ; F93A A5 93                    ..
	sta     cia+tod10                      ; F93C 8D 08 DC                 ...
	rts                                     ; F93F 60                       `

; -------------------------------------------------------------------------------------------------
;************************************
;* error handler                    *
;*  restores i/o channels to default*
;*  prints kernal error message if  *
;*  bit 6 of msgflg set.  returns   *
;*  with error # in .a and carry.   *
;************************************
; F940 Output "i/o error: 1" (too many files)
error1: lda     #$01                            ; F940 A9 01                    ..
!byte   $2C                                     ; F942 2C                       ,
; Output "i/o error: 2" (file open)
error2: lda     #$02                            ; F943 A9 02                    ..
!byte   $2C                                     ; F945 2C                       ,
; Output "i/o error: 3" (file not open)
error3: lda     #$03                            ; F946 A9 03                    ..
!byte   $2C                                     ; F948 2C                       ,
; Output "i/o error: 4" (file not found)
error4: lda     #$04                            ; F949 A9 04                    ..
!byte   $2C                                     ; F94B 2C                       ,
; Output "i/o error: 5" (device not present)
error5: lda     #$05                            ; F94C A9 05                    ..
!byte   $2C                                     ; F94E 2C                       ,
; Output "i/o error: 6" (not input file)
error6: lda     #$06                            ; F94F A9 06                    ..
!byte   $2C                                     ; F951 2C                       ,
; Output "i/o error: 7" (not output file)
error7: lda     #$07                            ; F952 A9 07                    ..
!byte   $2C                                     ; F954 2C                       ,
; Output "i/o error: 8" (missing file name)
error8: lda     #$08                            ; F955 A9 08                    ..
!byte   $2C                                     ; F957 2C                       ,
; Output "i/o error: 9" (illegal device number)
error9: lda     #$09                            ; F958 A9 09                    ..
; F95A Error output routine
errorx: pha                                     ; F95A 48                       H
	jsr     clrch                          ; F95B 20 CC FF                  ..
	ldy     #$00                            ; F95E A0 00                    ..
	bit     msgflg                          ; F960 2C 61 03                 ,a.
	bvc     LF96F                           ; F963 50 0A                    P.
	jsr     msg                             ; F965 20 28 F2                  (.
	pla                                     ; F968 68                       h
	pha                                     ; F969 48                       H
	ora     #$30                            ; F96A 09 30                    .0
	jsr     kbsout                          ; F96C 20 D2 FF                  ..
LF96F:  pla                                     ; F96F 68                       h
	sec                                     ; F970 38                       8
	rts                                     ; F971 60                       `

; -------------------------------------------------------------------------------------------------
;***************************************
;* stop -- check stop key flag and     *
;* return z flag set if flag true.     *
;* also closes active channels and     *
;* flushes keyboard queue.             *
;* also returns key downs from last    *
;* keyboard row in .a.                 *
;***************************************
; F972 Check the stop key
nstop:   lda     stkey                           ; F972 A5 A9                    ..
	and     #$01                            ; F974 29 01                    ).
	bne     LF97F                           ; F976 D0 07                    ..
	php                                     ; F978 08                       .
	jsr     clrch                          ; F979 20 CC FF                  ..
	sta     ndx                             ; F97C 85 D1                    ..
	plp                                     ; F97E 28                       (
LF97F:  rts                                     ; F97F 60                       `

; -------------------------------------------------------------------------------------------------
; udtim - update the stop key location
;   expects keyboard outputs set to
;   default value. bit 0 of stkey =0
;   for stop key down.
;---------------------------------------
; F980 
udtim:  lda     tpi2+pc                         ; F980 AD 02 DF                 ...
	lsr                                     ; F983 4A                       J
	bcs     LF998                           ; F984 B0 12                    ..
	lda     #$FE                            ; F986 A9 FE                    ..
	sta     tpi2+pb                         ; F988 8D 01 DF                 ...
	lda     #$10                            ; F98B A9 10                    ..
	and     tpi2+pc                         ; F98D 2D 02 DF                 -..
	bne     LF993                           ; F990 D0 01                    ..
	sec                                     ; F992 38                       8
LF993:  lda     #$FF                            ; F993 A9 FF                    ..
	sta     tpi2+pb                         ; F995 8D 01 DF                 ...
LF998:  rol                                     ; F998 2A                       *
	sta     stkey                           ; F999 85 A9                    ..
	rts                                     ; F99B 60                       `
; -------------------------------------------------------------------------------------------------
; start - system reset routine
;  kernal checks on 4k boundries from $1000-$8000
;    first occurance has priority.
;    if no occurance then $e000 is used for vector
;    $e000 => monitor start
;  kernal expects:
;    $x000 - jmp init  (cold start)
;    $x003 - jmp winit (warm start)
;    $x006 - 'c'(+$80)=> kernal cold start first
;    $x007 - 'b'+$80
;    $x008 - 'm'+$80
;    $x009 - 'x'  x=4k bank (1-8)
;------------------------------------------------
; F99C Test bytes for ROMs
patall: !byte $C2,$CD
; F99E System reset routine
start:	ldx #$FE		; $1ff reserved for stackpointer
	sei                     ; disable interrupts
	txs                     ; init stack
	cld                     ; clear decimal flag
	lda #$FF
	eor evect+2
	eor evect+3             ; compare warm start flags if both are $A5
	beq swarm               ; if yes, branches to warm start
; F9AD System cold start
scold:	lda #$06                ; set pointer to $0006 = position ROM ident bytes
	sta eal
	lda #$00
	sta eah
	sta evect               ; set warm start vector lowbyte to $00
	ldx #$30                ; init 4. rom ident byte compare value to $30 = '0'
sloop0: ldy #$03                ; set counter to 4th ROM ident byte
	lda eah
	bmi sloop2              ; no ROM found -> monitor cold boot
	clc
	adc #$10                ; next rom position to check highbyte +$10
	sta eah
	inx                     ; next 4. byte compare value $31, $32, $33...
	txa
	cmp (eal),y             ; compare if 4. byte $31 at address $1006+3, $32 at $2006...
	bne sloop0              ; 4. byte does not mach - > next ROM pos. $2000, $3000...
	dey                     ; check next byte backwards if 4th byte matches
sloop1: lda (eal),y             ; load 3., 2., 1. byte
	dey
	bmi sloop3              ; 2. + 3. byte matches - autostart ROM found!
	cmp patall,y            ; compare test bytes 'M', 'B'
	beq sloop1              ; 3. byte OK -> check 2. byte
	bne sloop0              ; 2. or 3. ident byte does not mach -> next ROM position
sloop2: ldy #$E0                ; if no ROM found set start vector to $E000 = monitor cold boot
	!byte $2C
sloop3: ldy eah
	sty evect+1             ; store rom address highbyte to warm start vector
	tax                     ; move 1. ident byte to x to set N-flag
	bpl swarm               ; jump to warm start if value is positive ('c'=$43)
	jsr ioinit              ; I/O register init $F9FE (TPI1, TPI2, CIA, TOD)
	lda #$F0
	sta pkybuf+1            ; start F-keys
	jsr jcint               ; initialize $E004 -> cint $E044 (editor, F-Keys, VIC)
	jsr ramtas              ; ram-test $FA94
	jsr restor              ; init standard-vectors $FBB1 (copies $0300 Vector Table)
	jsr jcint               ; initialize $E004 -> cint $E044 (editor, F-Keys, VIC)
	lda #warm		; Kernal initilize done flag
	sta evect+2             ; save first warm start flag $A5
; F9FB Warm start entry
swarm:  jmp (evect)             ; jump to basic warm start $BBA0
; -------------------------------------------------------------------------------------------------
;-----------------------------------------
; ioinit - initilize i/o system
;   6509/6525/6525/6526
;   must be entered with irq's disabled
;------------------------------------------
; F9FE I/O register init (TPI1, TPI2, CIA, TOD)
ioinit: lda #$F3
	sta tpi1+creg           ; TPI1 interrupt mode = on, parity / VIC bank 15 selected for both
	lda #$FF
	sta tpi1+mir            ; TPI1 enable all interrupts
	lda #$5C
	sta tpi1+pb             ; TPI1 PB IEEE ifc=0, netw.=0, arb.sw.=1, cass. write=0,motor=1 
	lda #$7D                ; TPI1 DDRB input: cassette switch, IEEE srq
	sta tpi1+ddpb           ; TPI1 DDRB output: IEEE ifc, network, arb.sw., cass. motor,write
	lda #$3D     
	sta tpi1+pa             ; TPI1 PA IEEE dc=1, te=0, ren=1, atn=1, dav=1, eo=1
	lda #$3F                ; TPI1 DDRA input:  IEEE ndac, nfrd
	sta tpi1+ddpa           ; TPI1 DDRA output: IEEE dc, te, ren, atn, dav, eoi
	lda #$FF     
	sta tpi2+pa             ; TPI2 PA keyboard 8-15=1
	sta tpi1+pb             ; TPI1 PB IEEE ifc=1, network=1, arb.sw.=1, cass. motor=1,write=1
	sta tpi2+ddpa           ; TPI2 DDRA output keyboard 8-15
	sta tpi2+ddpb           ; TPI2 DDRB output keyboard 0-7
	lsr tpi2+pa             ; TPI2 PA keyboard 15 bit #7=0
	lda #$C0     
	sta tpi2+pc             ; TPI2 PC VIC 16k bank select=11 $c000-$ffff
	sta tpi2+ddpc           ; TPI2 DDRC input: #0-5 keyboard 0-5 / output: #6-7 VIC 16k bank
	lda #$84     
	sta cia+icr            ; CIA2 ICR #7=set, #2=ALRM enable TOD interrupt
	ldy #$00     
	sty cia+ddra           ; CIA2 DDRA input: IEEE data, #6,7 also trigger 1,2
	sty cia+ddrb           ; CIA2 DDRB input: game 1,2
	sty cia+crb            ; CIA2 CRB Timer B stop, PB7=off, cont, Phi2, activate TOD write
	sta cia+tod10          ; CIA2 clear TOD 1/10 seconds
	sty tpi1+lir            ; TPI1 clear all interrupts
; Check for 50/60 Hz system frequency
io100:  lda tpi1+lir            ; load interrupt latch reg
	ror                     ; shift bit #0 to carry
	bcc io100               ; check again till bit #0 appears (50/60Hz source from PSU) 
	sty tpi1+lir            ; TPI1 clear all interrupts
	ldx #$00   
	ldy #$00
io110:  inx
	bne io110               ; delay 256x -> 1.28 ms @ 1MHz
	iny        
	lda tpi1+lir            ; load interrrupt latch reg
	ror                     ; shift bit #0 to carry
	bcc io110               ; check again till bit #0 appears (50/60Hz source from PSU)              
	cpy #id55hz   
	bcc io120               ; branch if signal appears again in 14 tries = <18ms -> 60Hz
	lda #$88                ; if not -> 50Hz / set extra bit #7 in A for TOD=50Hz
	!byte $2C               ; and skip next instruction
io120:  lda #$08
	sta cia+cra            ; CIA2 CRA set TOD=50/60Hz / run mode=continuous
	lda ipcia+icr            ; CIA1 clear interrupt reg
	lda #$90    
	sta ipcia+icr            ; CIA1 set flag interrupt source
	lda #$40    
	sta ipcia+prb            ; CIA1 set bit #6
	lda #$00    
	sta ipcia+ddra           ; CIA1 DDRA input
	sta ipcia+crb            ; CIA1 CRB stop timer B
	sta ipcia+cra            ; CIA1 CRA stop timer A
	lda #$48     
	sta ipcia+ddrb           ; CIA1 DDRB output: bit # 3,6 / all other input
	lda #$01    
	ora tpi1+pb             ; TPI1 PB set bit #0 IEEE ifc=1
	sta tpi1+pb 
	rts         
; -------------------------------------------------------------------------------------------------
; ramtas - initilize lower ram with $00
;  and test all system dynamic ram
;  set ram limits (64k bank min size)
;  alocatate initial buffer space
;  turn off rs232 and cassette buffers
;  reset xtape vectors to non-cassette
;-----------------------------------------
; FA94 RAM-test / vector init
ramtas: lda #$00                ; init value A = $00, counter X = $00
	tax
px1:    sta $0002,x             ; clear ZP above 6509 bank regs
	sta buf,x            ; clear basic input buffer from $0200       
	sta evect-$100,x        ; clear kernal RAM till evct $03F8
	inx
	bne px1                 ; clear next byte
	lda #$00
	sta i6509               ; select bank 0
	sta memstr+2            ; set user memory start bank = 0
	sta lowadr+2            ; set system memory start bank = 0
	lda #$02
	sta memstr              ; set user memory lowbyte = 0
	sta lowadr              ; set system memory lowbyte = 0
	dec i6509               ; decrease bank because of inc in next line
sizlop: inc i6509               ; increase bank
	lda i6509
	cmp #irom         ; check if bank 15
	beq size                ; end RAM test if reached bank 15
	ldy #$02                ; start RAM test at $0002, sal/sah already $0000
siz100: lda (sal),y
	tax                     ; save memory value in X 
	lda #$55                ; test with $55
	sta (sal),y
	lda (sal),y
	cmp #$55                ; check if $55 
	bne size                ; end test if different
	asl                     ; test with $AA
	sta (sal),y
	lda (sal),y
	cmp #$AA                ; check if $AA
	bne size                ; end test if different
	txa
	sta (sal),y             ; restore old memory value from X
!ifdef FULL_RAMTEST{            ; ********** Full RAM-test **********
	iny
	bne siz100              ; test next byte
} else{                         ; ********** Fast RAM-test PATCH **********
	nop
	nop
	nop
}
	inc sah
	bne siz100              ; test next page
	beq sizlop              ; test next bank
; FAE3 Store RAM size
size:   ldx i6509
	dex                     ; calc last tested bank
	txa                     ; remember last RAM bank in A
	ldx #$FF
	ldy #$FE
	sta hiadr+2             ; store highest RAM bank
	sty hiadr+1             ; store end of system memory = $FEFF 
	stx hiadr
	ldy #$FB                ; user memory top = $FBFF
	clc
	jsr memtop              ; set user memory top with C=0
	dec ribuf+2             ; init rs232 buffer bank to $FF
	dec tape1+2             ; init tape buffer bank to $FF
	lda #$6B                ; init tape routines vector to $FE6B
	sta itape
	lda #$FE
	sta itape+1
	rts
; -------------------------------------------------------------------------------------------------
; FB09 standard vector table - initialized at boot from restor sub to cinv $0300
jmptab: !word kirq              ; FB09 -> FBF8
	!word timb              ; FB0B -> EE21
	!word panic             ; FB0D -> FCB8
	!word nopen              ; FB0F -> F6C6
	!word nclose             ; FB11 -> F5F4
	!word nchkin             ; FB13 -> F550
	!word nckout             ; FB15 -> F5AA
	!word nclrch             ; FB17 -> F6AD
	!word nbasin             ; FB19 -> F4A3
	!word nbsout             ; FB1B -> F4F5
	!word nstop              ; FB1D -> F972
	!word ngetin             ; FB1F -> F444
	!word nclall            ; FB21 -> F686
	!word nload              ; FB23 -> F74D
	!word nsave              ; FB25 -> F853
	!word mcmd              ; FB27 -> EE73
	!word jescrt           ; FB29 -> E01F
	!word jescrt           ; FB2B -> E01F
	!word nsecnd            ; FB2D -> F27B
	!word ntksa              ; FB2F -> F287
	!word nacptr             ; FB31 -> F311
	!word nciout             ; FB33 -> F29E
	!word nuntlk            ; FB35 -> F2B2
	!word nunlsn             ; FB37 -> F2B6
	!word nlistn             ; FB39 -> F23B
	!word ntalk              ; FB3B -> F237
; -------------------------------------------------------------------------------------------------
; FB3D NMI entry, jumps indirect to NMI routine
nmi:    jmp (nminv)             ; ($0304) default -> panic = $FCB8
; -------------------------------------------------------------------------------------------------
; FB40 Set the file name address
setnam: sta     fnlen                           ; FB40 85 9D                    ..
	lda     e6509,x                         ; FB42 B5 00                    ..
	sta     fnadr                           ; FB44 85 90                    ..
	lda     i6509,x                         ; FB46 B5 01                    ..
	sta     fnadr+1                         ; FB48 85 91                    ..
	lda     $02,x                           ; FB4A B5 02                    ..
	sta     fnadr+2                         ; FB4C 85 92                    ..
	rts                                     ; FB4E 60                       `

; -------------------------------------------------------------------------------------------------
; FB4F Set logical file number
setlfs: sta     la                              ; FB4F 85 9E                    ..
	stx     fa                              ; FB51 86 9F                    ..
	sty     sa                              ; FB53 84 A0                    ..
	rts                                     ; FB55 60                       `

; -------------------------------------------------------------------------------------------------
; FB56 Read/write the system status byte
readst: bcc     storst                          ; FB56 90 1B                    ..
	lda     fa                              ; FB58 A5 9F                    ..
	cmp     #$02                            ; FB5A C9 02                    ..
	bne     readss                          ; FB5C D0 0E                    ..
	lda     rsstat                          ; FB5E AD 7A 03                 .z.
	pha                                     ; FB61 48                       H
	lda     #$00                            ; FB62 A9 00                    ..
	sta     rsstat                          ; FB64 8D 7A 03                 .z.
	pla                                     ; FB67 68                       h
	rts                                     ; FB68 60                       `

; -------------------------------------------------------------------------------------------------
; FB69 Set the system message flag
setmsg: sta     msgflg                          ; FB69 8D 61 03                 .a.
readss: lda     status                          ; FB6C A5 9C                    ..
; ORA A in status
udst:   ora     status                          ; FB6E 05 9C                    ..
	sta     status                          ; FB70 85 9C                    ..
	rts                                     ; FB72 60                       `

; -------------------------------------------------------------------------------------------------
; FB73 Write the status byte
storst: pha                                     ; FB73 48                       H
	lda     fa                              ; FB74 A5 9F                    ..
	cmp     #$02                            ; FB76 C9 02                    ..
	bne     storss                          ; FB78 D0 05                    ..
	pla                                     ; FB7A 68                       h
	sta     rsstat                          ; FB7B 8D 7A 03                 .z.
	rts                                     ; FB7E 60                       `

storss: pla                                     ; FB7F 68                       h
	sta     status                          ; FB80 85 9C                    ..
	rts                                     ; FB82 60                       `

; -------------------------------------------------------------------------------------------------
; FB83 IEC timeout on/off
settmo: sta     timout                          ; FB83 8D 5E 03                 .^.
	rts                                     ; FB86 60                       `

; -------------------------------------------------------------------------------------------------
; FB87 Get/set top of available memory
memtop: bcc settop              ; set user memory top with C=0
	lda memsiz+2            ; load memory top in A, Y, X
	ldx memsiz
	ldy memsiz+1
settop: stx memsiz              ; set user memory top
	sty memsiz+1
	sta memsiz+2
	rts
; -------------------------------------------------------------------------------------------------
; FB9C Get/set bottom of available memory
membot: bcc     setbot                          ; FB9C 90 09                    ..
	lda     memstr+2                        ; FB9E AD 5A 03                 .Z.
	ldx     memstr                          ; FBA1 AE 58 03                 .X.
	ldy     memstr+1                        ; FBA4 AC 59 03                 .Y.
setbot: stx     memstr                          ; FBA7 8E 58 03                 .X.
	sty     memstr+1                        ; FBAA 8C 59 03                 .Y.
	sta     memstr+2                        ; FBAD 8D 5A 03                 .Z.
	rts                                     ; FBB0 60                       `

; -------------------------------------------------------------------------------------------------
; FBB1 Restore the system vector table at $0300
restor: ldx     #<jmptab        ; load vector table address in kernal
	ldy     #>jmptab
	lda     #irom
	clc
; FBB8 Get/set the system vector table
vector: stx     sal             ; store address
	sty     sah
	ldx     i6509           ; remember ibank
	sta     i6509           ; set new ibank
	bcc     vect50          ; carry=0 -> set/restore table
; get table/copy to new address
	ldy     #$33
vect20: lda     cinv,y
	sta     (sal),y         ; copy from $F0300 to new address/bank
	dey
	bpl     vect20
; set/restore table
vect50: ldy     #$33
vect60: lda     (sal),y
	sta     cinv,y          ; copy to table at $F0300
	dey
	bpl     vect60
	stx     i6509           ; restore ibank
	rts
; -------------------------------------------------------------------------------------------------
; FBD9 
vreset: stx     evect                           ; FBD9 8E F8 03                 ...
	sty     evect+1                         ; FBDC 8C F9 03                 ...
	lda     #$5A                            ; FBDF A9 5A                    .Z
	sta     evect+3                         ; FBE1 8D FB 03                 ...
	rts                                     ; FBE4 60                       `
; -------------------------------------------------------------------------------------------------
;**********************************************
;* nirq - handler for:       10/30/81 rsr     *
;* 6525 irq's:::::::::::::::::::::::::::::::::*
;* 6551 irq's                                 *
;*   (receiver,transmitter,dcd & dsr changes) *
;* 6526 irq's                                 *
;*   (alarm, timera, timerb)                  *
;* 6526 irq's                                 *
;*   (2nd processor)                          *
;* ieee srq                                   *
;* keyboard scan (50/60hz irq)                *
;*                                            *
;* also at present does not handle any of the *
;* 6566 (vic) interrupts.                     *
;**********************************************
; FBE5 IRQ routine
nirq:	pha                                     ; FBE5 48                       H
	txa                                     ; FBE6 8A                       .
	pha                                     ; FBE7 48                       H
	tya                                     ; FBE8 98                       .
	pha                                     ; FBE9 48                       H
	tsx                                     ; FBEA BA                       .
	lda     stack+4,x                       ; FBEB BD 04 01                 ...
	and     #$10                            ; FBEE 29 10                    ).
	bne     brkirq                          ; FBF0 D0 03                    ..
	jmp     (cinv)                          ; FBF2 6C 00 03                 l..

; -------------------------------------------------------------------------------------------------
; FBF5 
brkirq: jmp     (cbinv)                         ; FBF5 6C 02 03                 l..

; -------------------------------------------------------------------------------------------------
; FBF8 Standard IRQ routine via indirect vector cinv
kirq:   lda     i6509                           ; FBF8 A5 01                    ..
	pha                                     ; FBFA 48                       H
	cld                                     ; FBFB D8                       .
	lda     tpi1+air                        ; FBFC AD 07 DE                 ...
	bne     kirq1                           ; FBFF D0 03                    ..
	jmp     prendn                          ; FC01 4C B0 FC                 L..

; -------------------------------------------------------------------------------------------------
; FC04 Check for ACIA IRQ
kirq1:  cmp     #$10                            ; FC04 C9 10                    ..
	beq     kirq2                           ; FC06 F0 03                    ..
	jmp     kirq8                           ; FC08 4C 69 FC                 Li.

; -------------------------------------------------------------------------------------------------
; FC0B Handle ACIA IRQ
kirq2:  lda     acia+srsn                     ; FC0B AD 01 DD                 ...
	tax                                     ; FC0E AA                       .
	and     #$60                            ; FC0F 29 60                    )`
	tay                                     ; FC11 A8                       .
	eor     dcdsr                           ; FC12 4D 7B 03                 M{.
	beq     LFC24                           ; FC15 F0 0D                    ..
	tya                                     ; FC17 98                       .
	sta     dcdsr                           ; FC18 8D 7B 03                 .{.
	ora     rsstat                          ; FC1B 0D 7A 03                 .z.
	sta     rsstat                          ; FC1E 8D 7A 03                 .z.
	jmp     LFCAD                           ; FC21 4C AD FC                 L..

LFC24:  txa                                     ; FC24 8A                       .
	and     #$08                            ; FC25 29 08                    ).
	beq     LFC4E                           ; FC27 F0 25                    .%
	ldy     ridbe                           ; FC29 AC 7D 03                 .}.
	iny                                     ; FC2C C8                       .
	cpy     ridbs                           ; FC2D CC 7C 03                 .|.
	bne     LFC36                           ; FC30 D0 04                    ..
	lda     #$08                            ; FC32 A9 08                    ..
	bne     LFC48                           ; FC34 D0 12                    ..
LFC36:  sty     ridbe                           ; FC36 8C 7D 03                 .}.
	dey                                     ; FC39 88                       .
	ldx     ribuf+2                         ; FC3A A6 A8                    ..
	stx     i6509                           ; FC3C 86 01                    ..
	lda     acia+drsn                       ; FC3E AD 00 DD                 ...
	sta     (ribuf),y                       ; FC41 91 A6                    ..
	lda     acia+srsn                     ; FC43 AD 01 DD                 ...
	and     #$07                            ; FC46 29 07                    ).
LFC48:  ora     rsstat                          ; FC48 0D 7A 03                 .z.
	sta     rsstat                          ; FC4B 8D 7A 03                 .z.
LFC4E:  lda     acia+srsn                     ; FC4E AD 01 DD                 ...
	and     #$10                            ; FC51 29 10                    ).
	beq     LFC66                           ; FC53 F0 11                    ..
	lda     acia+cdr                        ; FC55 AD 02 DD                 ...
	and     #$0C                            ; FC58 29 0C                    ).
	cmp     #$04                            ; FC5A C9 04                    ..
	bne     LFC66                           ; FC5C D0 08                    ..
	lda     #$F3                            ; FC5E A9 F3                    ..
	and     acia+cdr                        ; FC60 2D 02 DD                 -..
	sta     acia+cdr                        ; FC63 8D 02 DD                 ...
LFC66:  jmp     LFCAD                           ; FC66 4C AD FC                 L..

; -------------------------------------------------------------------------------------------------
; FC69 Check for coprozessor IRQ
kirq8:  cmp     #$08                            ; FC69 C9 08                    ..
	bne     kirq9                           ; FC6B D0 0A                    ..
	lda     ipcia+icr                        ; FC6D AD 0D DB                 ...
	cli                                     ; FC70 58                       X
	jsr     ipserv                          ; FC71 20 56 FD                  V.
	jmp     LFCAD                           ; FC74 4C AD FC                 L..

; -------------------------------------------------------------------------------------------------
; FC77 Check for CIA IRQ
kirq9:  cli                                     ; FC77 58                       X
	cmp     #$04                            ; FC78 C9 04                    ..
	bne     kirq10                          ; FC7A D0 0C                    ..
	lda     cia+icr                        ; FC7C AD 0D DC                 ...
	ora     alarm                           ; FC7F 0D 69 03                 .i.
	sta     alarm                           ; FC82 8D 69 03                 .i.
	jmp     LFCAD                           ; FC85 4C AD FC                 L..

; -------------------------------------------------------------------------------------------------
; FC88 Check for IEC bus IRQ (and ignore it)
kirq10: cmp     #$02                            ; FC88 C9 02                    ..
	bne     kirq11                          ; FC8A D0 03                    ..
	jmp     LFCAD                           ; FC8C 4C AD FC                 L..

; -------------------------------------------------------------------------------------------------
; FC8F Must be a 50/60Hz IRQ - poll keyboard, update time
kirq11: jsr     jkey                         ; FC8F 20 13 E0                  ..
	jsr     udtim                           ; FC92 20 80 F9                  ..
	lda     tpi1+pb                         ; FC95 AD 01 DE                 ...
	bpl     LFCA3                           ; FC98 10 09                    ..
	ldy     #$00                            ; FC9A A0 00                    ..
	sty     cas1                            ; FC9C 8C 75 03                 .u.
	ora     #$40                            ; FC9F 09 40                    .@
	bne     LFCAA                           ; FCA1 D0 07                    ..
LFCA3:  ldy     cas1                            ; FCA3 AC 75 03                 .u.
	bne     LFCAD                           ; FCA6 D0 05                    ..
	and     #$BF                            ; FCA8 29 BF                    ).
LFCAA:  sta     tpi1+pb                         ; FCAA 8D 01 DE                 ...
LFCAD:  sta     tpi1+air                        ; FCAD 8D 07 DE                 ...
; IRQ end, restore indirect segment and registers
prendn: pla                                     ; FCB0 68                       h
	sta     i6509                           ; FCB1 85 01                    ..
; IRQ end, restore registers
prend:  pla                                     ; FCB3 68                       h
	tay                                     ; FCB4 A8                       .
	pla                                     ; FCB5 68                       h
	tax                                     ; FCB6 AA                       .
	pla                                     ; FCB7 68                       h
; Default NMI routine
panic:  rti                                     ; FCB8 40                       @

; -------------------------------------------------------------------------------------------------
; send a request
;   enter:   ipb buffer is initialized to hold the
;            command
;            input parameter bytes
;
;   exit:    ipb buffer holds
;            output parameter bytes
;            all other bytes in ipb unchanged
;---------------------------------------------------------------
; FCB9 Coprocessor request
ipcrq:  lda     ipb                             ; FCB9 AD 00 08                 ...
	and     #$7F                            ; FCBC 29 7F                    ).
	tay                                     ; FCBE A8                       .
	jsr     getpar                          ; FCBF 20 2F FE                  /.
	lda     #$04                            ; FCC2 A9 04                    ..
	and     ipcia+prb                        ; FCC4 2D 01 DB                 -..
	bne     ipcrq                           ; FCC7 D0 F0                    ..
	lda     #$08                            ; FCC9 A9 08                    ..
	ora     ipcia+prb                        ; FCCB 0D 01 DB                 ...
	sta     ipcia+prb                        ; FCCE 8D 01 DB                 ...
	nop                                     ; FCD1 EA                       .
	lda     ipcia+prb                        ; FCD2 AD 01 DB                 ...
	tax                                     ; FCD5 AA                       .
	and     #$04                            ; FCD6 29 04                    ).
	beq     LFCE6                           ; FCD8 F0 0C                    ..
	txa                                     ; FCDA 8A                       .
	eor     #$08                            ; FCDB 49 08                    I.
	sta     ipcia+prb                        ; FCDD 8D 01 DB                 ...
	txa                                     ; FCE0 8A                       .
	nop                                     ; FCE1 EA                       .
	nop                                     ; FCE2 EA                       .
	nop                                     ; FCE3 EA                       .
	bne     ipcrq                           ; FCE4 D0 D3                    ..
LFCE6:  lda     #$FF                            ; FCE6 A9 FF                    ..
	sta     ipcia+ddra                       ; FCE8 8D 02 DB                 ...
	lda     ipb                             ; FCEB AD 00 08                 ...
	sta     ipcia+pra                        ; FCEE 8D 00 DB                 ...
	jsr     frebus                          ; FCF1 20 16 FE                  ..
	lda     ipcia+prb                        ; FCF4 AD 01 DB                 ...
	and     #$BF                            ; FCF7 29 BF                    ).
	sta     ipcia+prb                        ; FCF9 8D 01 DB                 ...
	ora     #$40                            ; FCFC 09 40                    .@
	cli                                     ; FCFE 58                       X
	nop                                     ; FCFF EA                       .
	nop                                     ; FD00 EA                       .
	nop                                     ; FD01 EA                       .
	sta     ipcia+prb                        ; FD02 8D 01 DB                 ...
	jsr     waithi                          ; FD05 20 FC FD                  ..
	lda     #$00                            ; FD08 A9 00                    ..
	sta     ipcia+ddra                       ; FD0A 8D 02 DB                 ...
	jsr     acklo                           ; FD0D 20 04 FE                  ..
	jsr     waitlo                          ; FD10 20 F4 FD                  ..
	ldy     #$00                            ; FD13 A0 00                    ..
	beq     LFD34                           ; FD15 F0 1D                    ..
LFD17:  lda     #$FF                            ; FD17 A9 FF                    ..
	sta     ipcia+ddra                       ; FD19 8D 02 DB                 ...
	lda     ipb+5,y                         ; FD1C B9 05 08                 ...
	sta     ipcia+pra                        ; FD1F 8D 00 DB                 ...
	jsr     ackhi                           ; FD22 20 0D FE                  ..
	jsr     waithi                          ; FD25 20 FC FD                  ..
	lda     #$00                            ; FD28 A9 00                    ..
	sta     ipcia+ddra                       ; FD2A 8D 02 DB                 ...
	jsr     acklo                           ; FD2D 20 04 FE                  ..
	jsr     waitlo                          ; FD30 20 F4 FD                  ..
	iny                                     ; FD33 C8                       .
LFD34:  cpy     ipb+3                           ; FD34 CC 03 08                 ...
	bne     LFD17                           ; FD37 D0 DE                    ..
	ldy     #$00                            ; FD39 A0 00                    ..
	beq     LFD50                           ; FD3B F0 13                    ..
LFD3D:  jsr     ackhi                           ; FD3D 20 0D FE                  ..
	jsr     waithi                          ; FD40 20 FC FD                  ..
	lda     ipcia+pra                        ; FD43 AD 00 DB                 ...
	sta     ipb+5,y                         ; FD46 99 05 08                 ...
	jsr     acklo                           ; FD49 20 04 FE                  ..
	jsr     waitlo                          ; FD4C 20 F4 FD                  ..
	iny                                     ; FD4F C8                       .
LFD50:  cpy     ipb+4                           ; FD50 CC 04 08                 ...
	bne     LFD3D                           ; FD53 D0 E8                    ..
	rts                                     ; FD55 60                       `

; -------------------------------------------------------------------------------------------------
; service an 8088 request
;-------------------------------------------------------------------
; FD56 Coprocessor irq handler
ipserv: lda     #$00                            ; FD56 A9 00                    ..
	sta     ipcia+ddra                       ; FD58 8D 02 DB                 ...
	lda     ipcia+pra                        ; FD5B AD 00 DB                 ...
	sta     ipb                             ; FD5E 8D 00 08                 ...
	and     #$7F                            ; FD61 29 7F                    ).
	tay                                     ; FD63 A8                       .
	jsr     getpar                          ; FD64 20 2F FE                  /.
	tya                                     ; FD67 98                       .
	asl                                     ; FD68 0A                       .
	tay                                     ; FD69 A8                       .
	lda     ijtab,y                         ; FD6A B9 10 08                 ...
	sta     ipb+1                           ; FD6D 8D 01 08                 ...
	iny                                     ; FD70 C8                       .
	lda     ijtab,y                         ; FD71 B9 10 08                 ...
	sta     ipb+2                           ; FD74 8D 02 08                 ...
	jsr     ackhi                           ; FD77 20 0D FE                  ..
	jsr     waitlo                          ; FD7A 20 F4 FD                  ..
	ldy     #$00                            ; FD7D A0 00                    ..
LFD7F:  cpy     ipb+3                           ; FD7F CC 03 08                 ...
	beq     LFD99                           ; FD82 F0 15                    ..
	jsr     acklo                           ; FD84 20 04 FE                  ..
	jsr     waithi                          ; FD87 20 FC FD                  ..
	lda     ipcia+pra                        ; FD8A AD 00 DB                 ...
	sta     ipb+5,y                         ; FD8D 99 05 08                 ...
	jsr     ackhi                           ; FD90 20 0D FE                  ..
	jsr     waitlo                          ; FD93 20 F4 FD                  ..
	iny                                     ; FD96 C8                       .
	bne     LFD7F                           ; FD97 D0 E6                    ..
LFD99:  bit     ipb                             ; FD99 2C 00 08                 ,..
	bmi     LFDD1                           ; FD9C 30 33                    03
	lda     #$FD                            ; FD9E A9 FD                    ..
	pha                                     ; FDA0 48                       H
	lda     #$A6                            ; FDA1 A9 A6                    ..
	pha                                     ; FDA3 48                       H
	jmp     (ipb+1)                         ; FDA4 6C 01 08                 l..

; -------------------------------------------------------------------------------------------------
; FDA7 
	jsr     acklo                           ; FDA7 20 04 FE                  ..
	ldy     #$00                            ; FDAA A0 00                    ..
	beq     LFDCB                           ; FDAC F0 1D                    ..
LFDAE:  jsr     waithi                          ; FDAE 20 FC FD                  ..
	lda     #$FF                            ; FDB1 A9 FF                    ..
	sta     ipcia+ddra                       ; FDB3 8D 02 DB                 ...
	lda     ipb+5,y                         ; FDB6 B9 05 08                 ...
	sta     ipcia+pra                        ; FDB9 8D 00 DB                 ...
	jsr     ackhi                           ; FDBC 20 0D FE                  ..
	jsr     waitlo                          ; FDBF 20 F4 FD                  ..
	lda     #$00                            ; FDC2 A9 00                    ..
	sta     ipcia+ddra                       ; FDC4 8D 02 DB                 ...
	jsr     acklo                           ; FDC7 20 04 FE                  ..
	iny                                     ; FDCA C8                       .
LFDCB:  cpy     ipb+4                           ; FDCB CC 04 08                 ...
	bne     LFDAE                           ; FDCE D0 DE                    ..
LFDD0:  rts                                     ; FDD0 60                       `

; -------------------------------------------------------------------------------------------------
; FDD1 
LFDD1:  lda     #$FD                            ; FDD1 A9 FD                    ..
	pha                                     ; FDD3 48                       H
	lda     #$DC                            ; FDD4 A9 DC                    ..
	pha                                     ; FDD6 48                       H
	jsr     getbus                          ; FDD7 20 1F FE                  ..
	jmp     (ipb+1)                         ; FDDA 6C 01 08                 l..

; -------------------------------------------------------------------------------------------------
; FDDD 
	jsr     frebus                          ; FDDD 20 16 FE                  ..
	lda     ipb+4                           ; FDE0 AD 04 08                 ...
	sta     ipb+3                           ; FDE3 8D 03 08                 ...
	sta     ipb                             ; FDE6 8D 00 08                 ...
	lda     #$00                            ; FDE9 A9 00                    ..
	sta     ipb+4                           ; FDEB 8D 04 08                 ...
	jsr     ipcrq                           ; FDEE 20 B9 FC                  ..
	jmp     LFDD0                           ; FDF1 4C D0 FD                 L..

; -------------------------------------------------------------------------------------------------
; FDF4 
waitlo: lda     ipcia+prb                        ; FDF4 AD 01 DB                 ...
	and     #$04                            ; FDF7 29 04                    ).
	bne     waitlo                          ; FDF9 D0 F9                    ..
	rts                                     ; FDFB 60                       `

; -------------------------------------------------------------------------------------------------
; FDFC 
waithi: lda     ipcia+prb                        ; FDFC AD 01 DB                 ...
	and     #$04                            ; FDFF 29 04                    ).
	beq     waithi                          ; FE01 F0 F9                    ..
	rts                                     ; FE03 60                       `

; -------------------------------------------------------------------------------------------------
; FE04 
acklo:  lda     ipcia+prb                        ; FE04 AD 01 DB                 ...
	and     #$F7                            ; FE07 29 F7                    ).
	sta     ipcia+prb                        ; FE09 8D 01 DB                 ...
	rts                                     ; FE0C 60                       `

; -------------------------------------------------------------------------------------------------
; FE0D 
ackhi:  lda     #$08                            ; FE0D A9 08                    ..
	ora     ipcia+prb                        ; FE0F 0D 01 DB                 ...
	sta     ipcia+prb                        ; FE12 8D 01 DB                 ...
	rts                                     ; FE15 60                       `

; -------------------------------------------------------------------------------------------------
; FE16 Free the bus for the coprocessor
frebus: lda     tpi1+pb                         ; FE16 AD 01 DE                 ...
	and     #$EF                            ; FE19 29 EF                    ).
	sta     tpi1+pb                         ; FE1B 8D 01 DE                 ...
	rts                                     ; FE1E 60                       `

; -------------------------------------------------------------------------------------------------
; FE1F Wait until we own the bus
getbus: lda     ipcia+prb                        ; FE1F AD 01 DB                 ...
	and     #$02                            ; FE22 29 02                    ).
	beq     getbus                          ; FE24 F0 F9                    ..
	lda     tpi1+pb                         ; FE26 AD 01 DE                 ...
	ora     #$10                            ; FE29 09 10                    ..
	sta     tpi1+pb                         ; FE2B 8D 01 DE                 ...
	rts                                     ; FE2E 60                       `

; -------------------------------------------------------------------------------------------------
; FE2F Place coprocessor parameters into buffer
getpar: lda     ipptab,y                        ; FE2F B9 10 09                 ...
	pha                                     ; FE32 48                       H
	and     #$0F                            ; FE33 29 0F                    ).
	sta     ipb+3                           ; FE35 8D 03 08                 ...
	pla                                     ; FE38 68                       h
	lsr                                     ; FE39 4A                       J
	lsr                                     ; FE3A 4A                       J
	lsr                                     ; FE3B 4A                       J
	lsr                                     ; FE3C 4A                       J
	sta     ipb+4                           ; FE3D 8D 04 08                 ...
	rts                                     ; FE40 60                       `

; -------------------------------------------------------------------------------------------------
; FE41 End of coprocessor irq handler
ipcgo:  ldx     #$FF                            ; FE41 A2 FF                    ..
	stx     i6509                           ; FE43 86 01                    ..
	lda     tpi1+pb                         ; FE45 AD 01 DE                 ...
	and     #$EF                            ; FE48 29 EF                    ).
	sta     tpi1+pb                         ; FE4A 8D 01 DE                 ...
	nop                                     ; FE4D EA                       .
	lda     ipcia+prb                        ; FE4E AD 01 DB                 ...
	ror                                     ; FE51 6A                       j
	bcs     ipcgx                           ; FE52 B0 01                    ..
	rts                                     ; FE54 60                       `

; -------------------------------------------------------------------------------------------------
; FE55 Prepare for coprocessor takeover
ipcgx:  lda     #$00                            ; FE55 A9 00                    ..
	sei                                     ; FE57 78                       x
	sta     ipcia+prb                        ; FE58 8D 01 DB                 ...
	lda     #$40                            ; FE5B A9 40                    .@
	nop                                     ; FE5D EA                       .
	nop                                     ; FE5E EA                       .
	nop                                     ; FE5F EA                       .
	nop                                     ; FE60 EA                       .
	sta     ipcia+prb                        ; FE61 8D 01 DB                 ...
	cli                                     ; FE64 58                       X
; FE65 Wait while the coprocessor has the bus
iploop: jmp     iploop                          ; FE65 4C 65 FE                 Le.

; -------------------------------------------------------------------------------------------------
; no cassette routines avaliable
;
; FE68 Standard value for itape is nocass (below).
xtape:	jmp     (itape)		; goto tape device indirect
;
nocass:	pla			; remove jsr xtape and return
	pla
	jmp error5		; send back ?device not present
; -------------------------------------------------------------------------------------------------
; some needed routines
; FE70 
rd300:	lda stah
	sta sah
	lda stal
	sta sal
	lda stas
	sta sas
	sta i6509
	rts
; FE7F 
cmpste: sec
	lda sal
	sbc eal
	lda sah
	sbc eah
	lda sas
	sbc eas
	rts
!ifndef CBMPATCH{
; FE8D 
incsal: inc sal
	bne incr20
	inc sah
	bne incr20
	inc sas
	lda sas
	sta i6509
	lda #$02		; skip $0000 and $0001
	sta sal
incr20:	rts
}
; -------------------------------------------------------------------------------------------------
;-------------------------------------
; tapery - get from the tape buffer
;   lda (tape1)y ;replacement
;-------------------------------------
;tapiry iny
;tapery ldx i6509
; lda tape1+2
; sta i6509
; lda (tape1)y
; stx i6509
; rts
;-------------------------------------
; tapewy - put char in the tape buffer
;   sta (tape1)y ;replacement
;-------------------------------------
;tapzwy ldy #$ff ;first byte in buffer
;tapiwy iny ;auto inc into buffer
;tapewy ldx i6509
; pha
; lda tape1+2
; sta i6509
; pla
; sta (tape1)y
; stx i6509
; rts
;-------------------------------------
; fnadry - get from file name buffer
;   lda (fnadr)y ;replacement
;-------------------------------------
; FEA0 Load a byte from the file name
fnadry: ldx i6509
	lda fnadr+2
	sta i6509
	lda (fnadr),y
	stx i6509
	rts
; -------------------------------------------------------------------------------------------------
!ifdef CBMPATCH{		; ********** cbmii revision -03 PATCH **********
*= $FE9D
; ##### transx #####
; txjmp - transfer-of-execution jumper
;   entry - .a=seg # .x=low .y=high
;   caller must be a jsr txjmp
;   all registers and i6509 destroyed
;   returns directly to caller...
txjmp	sta i6509		; bp routine
	txa
	clc
	adc #2			; add 2 to target address
	bcc txjmp1
	iny
txjmp1:	tax
	tya
	pha			; store target+2 to stack
	txa
	pha
	jsr ipinit		; go initilize ipoint
	lda #$fe
	sta (ipoint),y		; $fe to top of foreign stack
; 04/14/83 bp
; transfer exec routines for cbm2
}
; -------------------------------------------------------------------------------------------------
; FEAB Support routine for cross bank calls
exsub:	php			; save status
	sei			; disable interrupts
	pha			; .a
	txa
	pha			; .x
	tya
	pha			; .y
	jsr ipinit		; init ipoint and load stack from xfer seg
	tay			; .y is xfer seg stack pointer
	lda e6509		; push return segment to user stack
	jsr putas		; push .a to other stack
	lda #<excrt2		; xfer seg rts routn
	ldx #>excrt2		; xfer seg rts routn
	jsr putaxs		; put .a.x to xfer seg stack
	tsx
	lda stack+5,x		; .sp +5 is actual routn addr lo
	sec
	sbc #$03		; -3 for jsr to this routn
	pha			; save .a
	lda stack+6,x		; hi addr
	sbc #$00
	tax			; .x hi
	pla			; restore .a lo
	jsr putaxs		; save .a.x onto xfer seg stack
	tya			; xfer seg stack pointer
excomm:	sec
	sbc #$04		; 4 bytes .y.x.a.p
	sta stackp		; xfer seg new stack pointer temp storage
	tay			; use this as new pointer also
	ldx #$04		; 4 bytes .y.x.a.p
exsu10:	pla
	iny
	sta (ipoint),y		; push regs from this stack to xfer seg stack
	dex
	bne exsu10
	ldy stackp		; restore .y as stack pointer for xfer seg
	lda #<expul2		; pull regs and rts routn
	ldx #>expul2		; .hi prendn routn in xfer seg
	jsr putaxs		; put .a.x on xfer seg stack
	pla			; fix stack
	pla			; fix stack
exgby:	tsx
	stx stackp		; save current stack pointer this seg
	tya			; .y is stack pointer for xfer seg
	tax
	txs			; new stack for xfer seg
	lda i6509		; xfer seg #
	jmp gbye		; good bye
; -------------------------------------------------------------------------------------------------
	nop			; returns here if rti
; FEFE Return from call to foreign bank
excrts: php			; .p
	php			; .p
!ifdef CBMPATCH{		; ********** cbmii revision -03 PATCH **********
	sei             	; dis ints
}
	pha			; .a
	txa
	pha			; .x
	tya
	pha			; .y
	tsx
	lda stack+6,x		; sp +6 is return seg
	sta i6509		; restore i6509 to return seg
	jsr ipinit		; init ipoint and load stack from xfer seg
	jmp excomm
; -------------------------------------------------------------------------------------------------
; FF11 ipoint = $100, Y = $FF (stack)
ipinit: ldy #$01
	sty ipoint+1
	dey
	sty ipoint		; ipoint=$0100
	dey			; .y=$ff
	lda (ipoint),y		; load stack pointer from $001ff
	rts
; -------------------------------------------------------------------------------------------------
; FF1C Place X/A to ipoint (build stack in foreign bank)
putaxs: pha			; save A
	txa
	sta (ipoint),y		; .x hi
	dey
	pla
; FF22 Place A to ipoint (build stack in foreign bank)
putas:  sta (ipoint),y		; .a lo
	dey
	rts
; -------------------------------------------------------------------------------------------------
; FF26 Pull registers after calling subroutine in foreign bank
expull: pla
	tay			; .y
	pla
	tax			; .x
	pla			; .a
	plp			; .p
	rts
; -------------------------------------------------------------------------------------------------
; FF2D Helper routine to route interrupts from foreign to system bank
exnmi:  php			; .p
	jmp (hwnmi)		; do nmi proc
; -------------------------------------------------------------------------------------------------
; FF31 Helper routine to route BRK insns from foreign to system bank
exbrk:  brk
	nop
	rts
; -------------------------------------------------------------------------------------------------
; FF34 Helper routine to route interrupts from foreign to system bank
exirq:  cli
	rts
exend:
;
excrt2=excrts-1
expul2=expull-1
; -------------------------------------------------------------------------------------------------
; (FF36) Unused space
	!byte $AC
; -------------------------------------------------------------------------------------------------
!ifdef CBMPATCH{		; ***** moved to place to transfer routines right!
; FE8D 
incsal: inc sal
	bne incr20
	inc sah
	bne incr20
	inc sas
	lda sas
	sta i6509
	lda #$02		; skip $0000 and $0001
	sta sal
incr20:	rts
}
; -------------------------------------------------------------------------------------------------
; ##### vectors #####
; FF6F (FF6C) Jump table kernal functions
!ifdef CBMPATCH{		; ********** cbmii revision -03 PATCH **********
*= $FF6C
newsys:	jmp txjmp		; Transfer-of-execution jumper
}
*= $FF6F
	jmp vreset		; Power-on/off vector reset
ipcgov:	jmp ipcgo		; Loop for ipc system
	jmp jfunky		; Function key vector
	jmp ipcrq		; Send ipc request
	jmp ioinit		; I/O initialization
	jmp jcint		; Screen initialization
aloca:	jmp alocat		; Allocation routine
	jmp vector		; read/set I/O vectors
	jmp restor		; restore I/O vectors
	jmp lkupsa		; Match sa--return sa,fa
	jmp lkupla		; Match la--return sa,fa
	jmp setmsg		; Control o.s. messages
secnd:	jmp (isecnd)		; Send sa after listen
ktksa:	jmp (itksa)		; Send sa after talk
	jmp memtop		; set/read top of memory
	jmp membot		; set/read bottom of memory
	jmp jkey		; Scan keyboard
	jmp settmo		; set timeout in IEEE
acptr:	jmp (iacptr)		; Handshake IEEE byte in
ciout:	jmp (iciout)		; Handshake IEEE byte out
untlk:	jmp (iuntlk)		; Send untalk out IEEE
unlsn:	jmp (iunlsn)		; Send unlisten out IEEE
listn:	jmp (ilistn)		; Send listen out IEEE
talk:	jmp (italk)		; Send talk out IEEE
	jmp readst		; read/write I/O status byte
	jmp setlfs		; set la, fa, sa
	jmp setnam		; set length and fn adr
open:	jmp (iopen)		; Open logical file/transmit command
close:	jmp (iclose)		; Close logical file
chkin:	jmp (ichkin)		; Open channel in
ckout:	jmp (ickout)		; Open channel out
clrch:	jmp (iclrch)		; Close I/O channel
basin:	jmp (ibasin)		; Input from channel
kbsout:	jmp (ibsout)		; Output to channel
load:	jmp (iload)		; Load from file
save:	jmp (isave)		; Save to file
	jmp settim		; Set internal clock
	jmp rdtim		; read internal clock
stop: 	jmp (istop)		; scan stop key
getin:	jmp (igetin)		; Get char from q
clall:	jmp (iclall)		; Close all files
	jmp udtim		; increment clock
	jmp jscror		; Screen org
	jmp jplot		; read/set x,y coord
	jmp jiobas		; return I/O base
; -------------------------------------------------------------------------------------------------
; FFF6 Actual execution segment switch routine
gbye:	sta e6509		; goodbye...
	rts
	!byte $80
*= $FFFA
; -------------------------------------------------------------------------------------------------
; FFFA Hardware vectors
hwnmi:  !word nmi		; FB3D Program defineable
	!word start		; F99E Initialization code
	!word nirq		; FBE5 Interrupt handler