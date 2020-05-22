; ##### disclaimer #####
;****************************************
;*                                      *
;* KK  K EEEEE RRRR  NN  N  AAA  LL     *
;* KK KK EE    RR  R NNN N AA  A LL     *
;* KKK   EE    RR  R NNN N AA  A LL     *
;* KKK   EEEE  RRRR  NNNNN AAAAA LL     *
;* KK K  EE    RR  R NN NN AA  A LL     *
;* KK KK EE    RR  R NN NN AA  A LL     *
;* KK KK EEEEE RR  R NN NN AA  A LLLLL  *
;*                                      *
;***************************************
;
;***************************************
;* C64 KERNAL                          *
;*   MEMORY AND I/O DEPENDENT ROUTINES *
;* DRIVING THE HARDWARE OF THE         *
;* FOLLOWING CBM MODELS:               *
;*   COMMODORE 64 (NTSC OR PAL VIDEO)  *
;* COPYRIGHT (C) 1983 BY               *
;* COMMODORE BUSINESS MACHINES (CBM)   *
;***************************************
.SKI 3
;****LISTING DATE --1200 05 AUG 1983****
.SKI 3
;***************************************
;* THIS SOFTWARE IS FURNISHED FOR USE  *
;* USE IN THE VIC OR COMMODORE COMPUTER*
;* SERIES ONLY.                        *
;*                                     *
;* COPIES THEREOF MAY NOT BE PROVIDED  *
;* OR MADE AVAILABLE FOR USE ON ANY    *
;* OTHER SYSTEM.                       *
;*                                     *
;* THE INFORMATION IN THIS DOCUMENT IS *
;* SUBJECT TO CHANGE WITHOUT NOTICE.   *
;*                                     *
;* NO RESPONSIBILITY IS ASSUMED FOR    *
;* RELIABILITY OF THIS SOFTWARE. RSR   *
;*                                     *
;***************************************
; -------------------------------------------------------------
; ##### declaire #####
	*=$0000         ;declare 6510 ports
d6510	*=*+1           ;6510 data direction register
r6510	*=*+1           ;6510 data register
	*=$0002         ;miss 6510 regs
;virtual regs for machine language monitor
pch	*=*+1
pcl	*=*+1
flgs	*=*+1
acc	*=*+1
xr	*=*+1
yr	*=*+1
sp	*=*+1
invh	*=*+1           ;user modifiable irq
invl	*=*+1
.ski 3
	* =$90
status	*=*+1           ;i/o operation status byte
; crfac *=*+2 ;correction factor (unused)
stkey	*=*+1           ;stop key flag
svxt	*=*+1           ;temporary
verck	*=*+1           ;load or verify flag
c3p0	*=*+1           ;ieee buffered char flag
bsour	*=*+1           ;char buffer for ieee
syno	*=*+1           ;cassette sync #
xsav	*=*+1           ;temp for basin
ldtnd	*=*+1           ;index to logical file
dfltn	*=*+1           ;default input device #
dflto	*=*+1           ;default output device #
prty	*=*+1           ;cassette parity
dpsw	*=*+1           ;cassette dipole switch
msgflg	*=*+1           ;os message flag
ptr1	;cassette error pass1
t1	*=*+1           ;temporary 1
tmpc
ptr2	;cassette error pass2
t2	*=*+1           ;temporary 2
time	*=*+3           ;24 hour clock in 1/60th seconds
r2d2	;serial bus usage
pcntr	*=*+1           ;cassette stuff
; ptch *=*+1  (unused)
bsour1	;temp used by serial routine
firt	*=*+1
count	;temp used by serial routine
cntdn	*=*+1           ;cassette sync countdown
bufpt	*=*+1           ;cassette buffer pointer
inbit	;rs-232 rcvr input bit storage
shcnl	*=*+1           ;cassette short count
bitci	;rs-232 rcvr bit count in
rer	*=*+1           ;cassette read error
rinone	;rs-232 rcvr flag for start bit check
rez	*=*+1           ;cassete reading zeroes
ridata	;rs-232 rcvr byte buffer
rdflg	*=*+1           ;cassette read mode
riprty	;rs-232 rcvr parity storage
shcnh	*=*+1           ;cassette short cnt
sal	*=*+1
sah	*=*+1
eal	*=*+1
eah	*=*+1
cmp0	*=*+1
temp	*=*+1
tape1	*=*+2           ;address of tape buffer #1y.
bitts	;rs-232 trns bit count
snsw1	*=*+1
nxtbit	;rs-232 trns next bit to be sent
diff	*=*+1
rodata	;rs-232 trns byte buffer
prp	*=*+1
fnlen	*=*+1           ;length current file n str
la	*=*+1           ;current file logical addr
sa	*=*+1           ;current file 2nd addr
fa	*=*+1           ;current file primary addr
fnadr	*=*+2           ;addr current file name str
roprty	;rs-232 trns parity buffer
ochar	*=*+1
fsblk	*=*+1           ;cassette read block count
mych	*=*+1
cas1	*=*+1           ;cassette manual/controlled switch
tmp0
stal	*=*+1
stah	*=*+1
memuss	;cassette load temps (2 bytes)
tmp2	*=*+2
;
;variables for screen editor
;
lstx	*=*+1           ;key scan index
; sfst *=*+1 ;keyboard shift flag (unused)
ndx	*=*+1           ;index to keyboard q
rvs	*=*+1           ;rvs field on flag
indx	*=*+1
lsxp	*=*+1           ;x pos at start
lstp	*=*+1
sfdx	*=*+1           ;shift mode on print
blnsw	*=*+1           ;cursor blink enab
blnct	*=*+1           ;count to toggle cur
gdbln	*=*+1           ;char before cursor
blnon	*=*+1           ;on/off blink flag
crsw	*=*+1           ;input vs get flag
pnt	*=*+2           ;pointer to row
; point *=*+1   (unused)
pntr	*=*+1           ;pointer to column
qtsw	*=*+1           ;quote switch
lnmx	*=*+1           ;40/80 max positon
tblx	*=*+1
data	*=*+1
insrt	*=*+1           ;insert mode flag
ldtb1	*=*+26          ;line flags+endspace
user	*=*+2           ;screen editor color ip
keytab	*=*+2           ;keyscan table indirect
;rs-232 z-page
ribuf	*=*+2           ;rs-232 input buffer pointer
robuf	*=*+2           ;rs-232 output buffer pointer
frekzp	*=*+4           ;free kernal zero page 9/24/80
baszpt	*=*+1           ;location ($00ff) used by basic
.ski 3
	*=$100 
bad	*=*+1
	*=$200
buf	*=*+89          ;basic/monitor buffer
.ski
; tables for open files
;
lat	*=*+10          ;logical file numbers
fat	*=*+10          ;primary device numbers
sat	*=*+10          ;secondary addresses
.ski 2
; system storage
;
keyd	*=*+10          ;irq keyboard buffer
memstr	*=*+2           ;start of memory
memsiz	*=*+2           ;top of memory
timout	*=*+1           ;ieee timeout flag
.ski 2
; screen editor storage
;
color	*=*+1           ;activ color nybble
gdcol	*=*+1           ;original color before cursor
hibase	*=*+1           ;base location of screen (top)
xmax	*=*+1
rptflg	*=*+1           ;key repeat flag
kount	*=*+1
delay	*=*+1
shflag	*=*+1           ;shift flag byte
lstshf	*=*+1           ;last shift pattern
keylog	*=*+2           ;indirect for keyboard table setup
mode	*=*+1           ;0-pet mode, 1-cattacanna
autodn	*=*+1           ;auto scroll down flag(=0 on,<>0 off)
.ski 3
; rs-232 storage
;
m51ctr	*=*+1           ;6551 control register
m51cdr	*=*+1           ;6551 command register
m51ajb	*=*+2           ;non standard (bittime/2-100)
rsstat	*=*+1           ; rs-232 status register
bitnum	*=*+1           ;number of bits to send (fast response)
baudof	*=*+2           ;baud rate full bit time (created by open)
;
; reciever storage
;
; inbit *=*+1 ;input bit storage
; bitci *=*+1 ;bit count in
; rinone *=*+1 ;flag for start bit check
; ridata *=*+1 ;byte in buffer
; riprty *=*+1 ;byte in parity storage
ridbe	*=*+1           ;input buffer index to end
ridbs	*=*+1           ;input buffer pointer to start
;
; transmitter storage
;
; bitts *=*+1 ;# of bits to be sent
; nxtbit *=*+1 ;next bit to be sent
; roprty *=*+1 ;parity of byte sent
; rodata *=*+1 ;byte buffer out
rodbs	*=*+1           ;output buffer index to start
rodbe	*=*+1           ;output buffer index to end
;
irqtmp	*=*+2           ;holds irq during tape ops
;
; temp space for vic-40 variables ****
;
enabl	*=*+1           ;rs-232 enables (replaces ier)
caston	*=*+1           ;tod sense during cassettes
kika26	*=*+1           ;temp storage for cassette read routine
stupid	*=*+1           ;temp d1irq indicator for cassette read
lintmp	*=*+1           ;temporary for line index
palnts	*=*+1           ;pal vs ntsc flag 0=ntsc 1=pal
.ski 3
	*=$0300         ;rem program indirects(10)
	*=$0300+20      ;rem kernal/os indirects(20)
cinv	*=*+2           ;irq ram vector
cbinv	*=*+2           ;brk instr ram vector
nminv	*=*+2           ;nmi ram vector
iopen	*=*+2           ;indirects for code
iclose	*=*+2           ; conforms to kernal spec 8/19/80
ichkin	*=*+2
ickout	*=*+2
iclrch	*=*+2
ibasin	*=*+2
ibsout	*=*+2
istop	*=*+2
igetin	*=*+2
iclall	*=*+2
usrcmd	*=*+2
iload	*=*+2
isave	*=*+2           ;savesp
.ski 3
	*=$0300+60
tbuffr	*=*+192         ;cassette data buffer
.ski 3
	* =$400
vicscn	*=*+1024
ramloc
.ski 3
.pag 'declare'
; i/o devices
;
	* =$d000
vicreg	=* ;vic registers
.ski 2
	* =$d400
sidreg	=* ;sid registers
.ski 2
	* =$d800
viccol	*=*+1024        ;vic color nybbles
.ski 2
	* =$dc00        ;device1 6526 (page1 irq)
colm	;keyboard matrix
d1pra	*=*+1
rows	;keyboard matrix
d1prb	*=*+1
d1ddra	*=*+1
d1ddrb	*=*+1
d1t1l	*=*+1
d1t1h	*=*+1
d1t2l	*=*+1
d1t2h	*=*+1
d1tod1	*=*+1
d1tods	*=*+1
d1todm	*=*+1
d1todh	*=*+1
d1sdr	*=*+1
d1icr	*=*+1
d1cra	*=*+1
d1crb	*=*+1
.ski 2
	* =$dd00        ;device2 6526 (page2 nmi)
d2pra	*=*+1
d2prb	*=*+1
d2ddra	*=*+1
d2ddrb	*=*+1
d2t1l	*=*+1
d2t1h	*=*+1
d2t2l	*=*+1
d2t2h	*=*+1
d2tod1	*=*+1
d2tods	*=*+1
d2todm	*=*+1
d2todh	*=*+1
d2sdr	*=*+1
d2icr	*=*+1
d2cra	*=*+1
d2crb	*=*+1
.ski 2
timrb	=$19            ;6526 crb enable one-shot tb
.pag 'declare'
;tape block types
;
eot	=5 ;end of tape
blf	=1 ;basic load file
bdf	=2 ;basic data file
plf	=3 ;fixed program type
bdfh	=4 ;basic data file header
bufsz	=192            ;buffer size
;
;screen editor constants
;
llen	=40             ;single line 40 columns
llen2	=80             ;double line = 80 columns
nlines	=25             ;25 rows on screen
white	=$01            ;white screen color
blue	=$06            ;blue char color
cr	=$d             ;carriage return
.end
;rsr 8/3/80 add & change z-page
;rsr 8/11/80 add memuss & plf type
;rsr 8/22/80 add rs-232 routines
;rsr 8/24/80 add open variables
;rsr 8/29/80 add baud space move rs232 to z-page
;rsr 9/2/80 add screen editor vars&con
;rsr 12/7/81 modify for vic-40
; -------------------------------------------------------------
; ##### editor.1 #####
.pag 'screen editor'
maxchr=80
nwrap=2 ;max number of physical lines per logical line
;
;undefined function entry
;
; undefd ldx #0
; undef2 lda unmsg,x
; jsr prt
; inx
; cpx #unmsg2-unmsg
; bne undef2
; sec
; rts
;
; unmsg .byt $d,'?advanced function not available',$d
; unmsg2
;
;return address of 6526
;
iobase	ldx #<d1pra
	ldy #>d1pra
	rts
;
;return max rows,cols of screen
;
scrorg	ldx #llen
	ldy #nlines
	rts
;
;read/plot cursor position
;
plot	bcs plot10
	stx tblx
	sty pntr
	jsr stupt
plot10	ldx tblx
	ldy pntr
	rts
.ski 5
;initialize i/o
;
cint
;
; establish screen memory
;
	jsr panic       ;set up vic
;
	lda #0          ;make sure we're in pet mode
	sta mode
	sta blnon       ;we dont have a good char from the screen yet
.ski
	lda #<shflog    ;set shift logic indirects
	sta keylog
	lda #>shflog
	sta keylog+1
	lda #10
	sta xmax        ;maximum type ahead buffer size
	sta delay
	lda #$e         ;init color to light blue<<<<<<<<<<
	sta color
	lda #4
	sta kount       ;delay between key repeats
	lda #$c
	sta blnct
	sta blnsw
clsr	lda hibase      ;fill hi byte ptr table
	ora #$80
	tay
	lda #0
	tax
lps1	sty ldtb1,x
	clc
	adc #llen
	bcc lps2
	iny             ;carry bump hi byte
lps2	inx
	cpx #nlines+1   ;done # of lines?
	bne lps1        ;no...
	lda #$ff        ;tag end of line table
	sta ldtb1,x
	ldx #nlines-1   ;clear from the bottom line up
clear1	jsr clrln       ;see scroll routines
	dex
	bpl clear1
.ski 5
;home function
;
nxtd	ldy #0
	sty pntr        ;left column
	sty tblx        ;top line
;
;move cursor to tblx,pntr
;
stupt
	ldx tblx        ;get curent line index
	lda pntr        ;get character pointer
fndstr	ldy ldtb1,x     ;find begining of line
	bmi stok        ;branch if start found
	clc
	adc #llen       ;adjust pointer
	sta pntr
	dex
	bpl fndstr
;
stok	jsr setpnt      ;set up pnt indirect 901227-03**********
;
	lda #llen-1
	inx
fndend	ldy ldtb1,x
	bmi stdone
	clc
	adc #llen
	inx
	bpl fndend
stdone
	sta lnmx
	jmp scolor      ;make color pointer follow 901227-03**********
.ski 5
; this is a patch for input logic 901227-03**********
;   fixes input"xxxxxxx-40-xxxxx";a$ problem
;
finput	cpx lsxp        ;check if on same line
	beq finpux      ;yes..return to send
	jmp findst      ;check if we wrapped down...
finpux	rts
	nop             ;keep the space the same...
.ski 5
;panic nmi entry
;
vpan	jsr panic       ;fix vic screen
	jmp nxtd        ;home cursor
.ski 5
panic	lda #3          ;reset default i/o
	sta dflto
	lda #0
	sta dfltn
.ski 5
;init vic
;
initv	ldx #47         ;load all vic regs ***
px4	lda tvic-1,x
	sta vicreg-1,x
	dex
	bne px4
	rts
.ski 5
;
;remove character from queue
;
lp2	ldy keyd
	ldx #0
lp1	lda keyd+1,x
	sta keyd,x
	inx
	cpx ndx
	bne lp1
	dec ndx
	tya
	cli
	clc             ;good return
	rts
;
loop4	jsr prt
loop3
	lda ndx
	sta blnsw
	sta autodn      ;turn on auto scroll down
	beq loop3
	sei
	lda blnon
	beq lp21
	lda gdbln
	ldx gdcol       ;restore original color
	ldy #0
	sty blnon
	jsr dspp
lp21	jsr lp2
	cmp #$83        ;run key?
	bne lp22
	ldx #9
	sei
	stx ndx
lp23	lda runtb-1,x
	sta keyd-1,x
	dex
	bne lp23
	beq loop3
lp22	cmp #$d
	bne loop4
	ldy lnmx
	sty crsw
clp5	lda (pnt)y
	cmp #' 
	bne clp6
	dey
	bne clp5
clp6	iny
	sty indx
	ldy #0
	sty autodn      ;turn off auto scroll down
	sty pntr
	sty qtsw
	lda lsxp
	bmi lop5
	ldx tblx
	jsr finput      ;check for same line as start  901227-03**********
	cpx lsxp
	bne lop5
	lda lstp
	sta pntr
	cmp indx
	bcc lop5
	bcs clp2
.ski 5
;input a line until carriage return
;
loop5	tya
	pha
	txa
	pha
	lda crsw
	beq loop3
lop5	ldy pntr
	lda (pnt)y
notone
	sta data
lop51	and #$3f
	asl data
	bit data
	bpl lop54
	ora #$80
lop54	bcc lop52
	ldx qtsw
	bne lop53
lop52	bvs lop53
	ora #$40
lop53	inc pntr
	jsr qtswc
	cpy indx
	bne clp1
clp2	lda #0
	sta crsw
	lda #$d
	ldx dfltn       ;fix gets from screen
	cpx #3          ;is it the screen?
	beq clp2a
	ldx dflto
	cpx #3
	beq clp21
clp2a	jsr prt
clp21	lda #$d
clp1	sta data
	pla
	tax
	pla
	tay
	lda data
	cmp #$de        ;is it <pi> ?
	bne clp7
	lda #$ff
clp7	clc
	rts
.ski 5
qtswc	cmp #$22
	bne qtswl
	lda qtsw
	eor #$1
	sta qtsw
	lda #$22
qtswl	rts
.ski 5
nxt33	ora #$40
nxt3	ldx rvs
	beq nvs
nc3	ora #$80
nvs	ldx insrt
	beq nvs1
	dec insrt
nvs1	ldx color put color on screen
	jsr dspp
	jsr wlogic      ;check for wraparound
loop2	pla
	tay
	lda insrt
	beq lop2
	lsr qtsw
lop2	pla
	tax
	pla
	clc             ;good return
	cli
	rts
.pag
wlogic
	jsr chkdwn      ;maybe we should we increment tblx
	inc pntr        ;bump charcter pointer
	lda lnmx        ;
	cmp pntr        ;if lnmx is less than pntr
	bcs wlgrts      ;branch if lnmx>=pntr
	cmp #maxchr-1   ;past max characters
	beq wlog10      ;branch if so
	lda autodn      ;should we auto scroll down?
	beq wlog20      ;branch if not
	jmp bmt1        ;else decide which way to scroll
.skip 3
wlog20
	ldx tblx        ;see if we should scroll down
	cpx #nlines
	bcc wlog30      ;branch if not
	jsr scrol       ;else do the scrol up
	dec tblx        ;and adjust curent line#
	ldx tblx
wlog30	asl ldtb1,x     ;wrap the line
	lsr ldtb1,x
	inx             ;index to next lline
	lda ldtb1,x     ;get high order byte of address
	ora #$80        ;make it a non-continuation line
	sta ldtb1,x     ;and put it back
	dex             ;get back to current line
	lda lnmx        ;continue the bytes taken out
	clc
	adc #llen
	sta lnmx
findst
	lda ldtb1,x     ;is this the first line?
	bmi finx        ;branch if so
	dex             ;else backup 1
	bne findst
finx
	jmp setpnt      ;make sure pnt is right
.ski
wlog10	dec tblx
	jsr nxln
	lda #0
	sta pntr        ;point to first byte
wlgrts	rts
.pag
bkln	ldx tblx
	bne bkln1
	stx pntr
	pla
	pla
	bne loop2
;
bkln1	dex
	stx tblx
	jsr stupt
	ldy lnmx
	sty pntr
	rts
.ski 5
;print routine
;
prt	pha
	sta data
	txa
	pha
	tya
	pha
	lda #0
	sta crsw
	ldy pntr
	lda data
	bpl *+5
	jmp nxtx
	cmp #$d
	bne njt1
	jmp nxt1
njt1	cmp #' 
	bcc ntcn
	cmp #$60        ;lower case?
	bcc njt8        ;no...
	and #$df        ;yes...make screen lower
	bne njt9        ;always
njt8	and #$3f
njt9	jsr qtswc
	jmp nxt3
ntcn	ldx insrt
	beq cnc3x
	jmp nc3
cnc3x	cmp #$14
	bne ntcn1
	tya
	bne bak1up
	jsr bkln
	jmp bk2
bak1up	jsr chkbak      ;should we dec tblx
	dey
	sty pntr
bk1	jsr scolor      ;fix color ptrs
bk15	iny
	lda (pnt)y
	dey
	sta (pnt)y
	iny
	lda (user)y
	dey
	sta (user)y
	iny
	cpy lnmx
	bne bk15
bk2	lda #' 
	sta (pnt)y 
	lda color
	sta (user)y
	bpl jpl3
ntcn1	ldx qtsw
	beq nc3w
cnc3	jmp nc3
nc3w	cmp #$12
	bne nc1
	sta rvs
nc1	cmp #$13
	bne nc2
	jsr nxtd
nc2	cmp #$1d
	bne ncx2
	iny
	jsr chkdwn
	sty pntr
	dey
	cpy lnmx
	bcc ncz2
	dec tblx
	jsr nxln
	ldy #0
jpl4	sty pntr
ncz2	jmp loop2
ncx2	cmp #$11
	bne colr1
	clc
	tya
	adc #llen
	tay
	inc tblx
	cmp lnmx
	bcc jpl4
	beq jpl4
	dec tblx
curs10	sbc #llen
	bcc gotdwn
	sta pntr
	bne curs10
gotdwn	jsr nxln
jpl3	jmp loop2
colr1	jsr chkcol      ;check for a color
	jmp lower       ;was jmp loop2
.ski 3
;check color
;
.ski 5
;shifted keys
;
nxtx
keepit
	and #$7f
	cmp #$7f
	bne nxtx1
	lda #$5e
nxtx1
nxtxa
	cmp #$20        ;is it a function key
	bcc uhuh
	jmp nxt33
uhuh
	cmp #$d
	bne up5
	jmp nxt1
up5	ldx  qtsw
	bne up6
	cmp #$14
	bne up9
	ldy lnmx
	lda (pnt)y
	cmp #' 
	bne ins3
	cpy pntr
	bne ins1
ins3	cpy #maxchr-1
	beq insext      ;exit if line too long
	jsr newlin      ;scroll down 1
ins1	ldy lnmx
	jsr scolor
ins2	dey
	lda (pnt)y
	iny
	sta (pnt)y
	dey
	lda (user)y
	iny
	sta (user)y
	dey
	cpy pntr
	bne ins2
	lda #$20
	sta (pnt)y
	lda color
	sta (user)y
	inc insrt
insext	jmp loop2
up9	ldx insrt
	beq up2
up6	ora #$40
	jmp nc3
up2	cmp #$11
	bne nxt2
	ldx tblx
	beq jpl2
	dec tblx
	lda pntr
	sec
	sbc #llen
	bcc upalin
	sta pntr
	bpl jpl2
upalin	jsr stupt
	bne jpl2
nxt2	cmp #$12
	bne nxt6
	lda #0
	sta rvs
nxt6	cmp #$1d
	bne nxt61
	tya
	beq bakbak
	jsr chkbak
	dey
	sty pntr
	jmp loop2
bakbak	jsr bkln
	jmp loop2
nxt61	cmp #$13
	bne sccl
	jsr clsr
jpl2	jmp loop2
sccl
	ora #$80        ;make it upper case
	jsr chkcol      ;try for color
	jmp upper       ;was jmp loop2
;
nxln	lsr lsxp
	ldx tblx
nxln2	inx
	cpx #nlines     ;off bottom?
	bne nxln1       ;no...
	jsr scrol       ;yes...scroll
nxln1	lda ldtb1,x     ;double line?
	bpl nxln2       ;yes...scroll again
	stx tblx
	jmp stupt
nxt1
	ldx #0
	stx insrt
	stx rvs
	stx qtsw
	stx pntr
	jsr nxln
jpl5	jmp loop2
;
;
; check for a decrement tblx
;
chkbak	ldx #nwrap
	lda #0
chklup	cmp pntr
	beq back
	clc
	adc #llen
	dex
	bne chklup
	rts
;
back	dec tblx
	rts
;
; check for increment tblx
;
chkdwn	ldx #nwrap
	lda #llen-1
dwnchk	cmp pntr
	beq dnline
	clc
	adc #llen
	dex
	bne dwnchk
	rts
;
dnline	ldx tblx
	cpx #nlines
	beq dwnbye
	inc tblx
;
dwnbye	rts
.ski2
chkcol
	ldx #15         ;there's 15 colors
chk1a	cmp coltab,x
	beq chk1b
	dex
	bpl chk1a
	rts
;
chk1b
	stx color       ;change the color
	rts
.ski1
coltab
;blk,wht,red,cyan,magenta,grn,blue,yellow
	.byt $90,$05,$1c,$9f,$9c,$1e,$1f,$9e
	.byt $81,$95,$96,$97,$98,$99,$9a,$9b
.end
; rsr modify for vic-40 system
; rsr 12/31/81 add 8 more colors
; -------------------------------------------------------------
; ##### editor.2 #####
.pag 'editor.2'
;screen scroll routine
;
scrol	lda sal
	pha
	lda sah
	pha
	lda eal
	pha
	lda eah
	pha
;
;   s c r o l l   u p
;
scro0	ldx #$ff
	dec tblx
	dec lsxp
	dec lintmp
scr10	inx             ;goto next line
	jsr setpnt      ;point to 'to' line
	cpx #nlines-1   ;done?
	bcs scr41       ;branch if so
;
	lda ldtb2+1,x   ;setup from pntr
	sta sal
	lda ldtb1+1,x
	jsr scrlin      ;scroll this line up1
	bmi scr10
;
scr41
	jsr clrln
;
	ldx #0          ;scroll hi byte pointers
scrl5	lda ldtb1,x
	and #$7f
	ldy ldtb1+1,x
	bpl scrl3
	ora #$80
scrl3	sta ldtb1,x
	inx
	cpx #nlines-1
	bne scrl5
;
	lda ldtb1+nlines-1
	ora #$80
	sta ldtb1+nlines-1
	lda ldtb1       ;double line?
	bpl scro0       ;yes...scroll again
;
	inc tblx
	inc lintmp
	lda #$7f        ;check for control key
	sta colm        ;drop line 2 on port b
	lda rows
	cmp #$fb        ;slow scroll key?(control)
	php             ;save status. restore port b
	lda #$7f        ;for stop key check
	sta colm
	plp
	bne mlp42
;
	ldy #0
mlp4	nop             ;delay
	dex
	bne mlp4
	dey
	bne mlp4
	sty ndx         ;clear key queue buffer
;
mlp42	ldx tblx
;
pulind	pla             ;restore old indirects
	sta eah
	pla
	sta eal
	pla
	sta sah
	pla
	sta sal
	rts
.page
newlin
	ldx tblx
bmt1	inx
; cpx #nlines ;exceded the number of lines ???
; beq bmt2 ;vic-40 code
	lda ldtb1,x     ;find last display line of this line
	bpl bmt1        ;table end mark=>$ff will abort...also
bmt2	stx lintmp      ;found it
;generate a new line
	cpx #nlines-1   ;is one line from bottom?
	beq newlx       ;yes...just clear last
	bcc newlx       ;<nlines...insert line
	jsr scrol       ;scroll everything
	ldx lintmp
	dex
	dec tblx
	jmp wlog30
newlx	lda sal
	pha
	lda sah
	pha
	lda eal
	pha
	lda eah
	pha
	ldx #nlines
scd10	dex
	jsr setpnt      ;set up to addr
	cpx lintmp
	bcc scr40
	beq scr40       ;branch if finished
	lda ldtb2-1,x   ;set from addr
	sta sal
	lda ldtb1-1,x
	jsr scrlin      ;scroll this line down
	bmi scd10
scr40
	jsr clrln
	ldx #nlines-2
scrd21
	cpx lintmp      ;done?
	bcc scrd22      ;branch if so
	lda ldtb1+1,x
	and #$7f
	ldy ldtb1,x     ;was it continued
	bpl scrd19      ;branch if so
	ora #$80
scrd19	sta ldtb1+1,x
	dex
	bne scrd21
scrd22
	ldx lintmp
	jsr wlog30
;
	jmp pulind      ;go pul old indirects and return
;
; scroll line from sal to pnt
; and colors from eal to user
;
scrlin
	and #$03        ;clear any garbage stuff
	ora hibase      ;put in hiorder bits
	sta sal+1
	jsr tofrom      ;color to & from addrs
	ldy #llen-1
scd20
	lda (sal)y
	sta (pnt)y
	lda (eal)y
	sta (user)y
	dey
	bpl scd20
	rts
;
; do color to and from addresses
; from character to and from adrs
;
tofrom
	jsr scolor
	lda sal         ;character from
	sta eal         ;make color from
	lda sal+1
	and #$03
	ora #>viccol
	sta eal+1
	rts
;
; set up pnt and y
; from .x
;
setpnt	lda ldtb2,x
	sta pnt
	lda ldtb1,x
	and #$03
	ora hibase
	sta pnt+1
	rts
;
; clear the line pointed to by .x
;
clrln	ldy #llen-1
	jsr setpnt
	jsr scolor
clr10	jsr cpatch      ;reversed order from 901227-02
	lda #$20        ;store a space
	sta (pnt)y     ;to display
	dey
	bpl clr10
	rts
	nop
.ski 5
;
;put a char on the screen
;
dspp	tay             ;save char
	lda #2
	sta blnct       ;blink cursor
	jsr scolor      ;set color ptr
	tya             ;restore color
dspp2	ldy pntr        ;get column
	sta (pnt)y      ;char to screen
	txa
	sta (user)y     ;color to screen
	rts
.ski 5
scolor	lda pnt         ;generate color ptr
	sta user
	lda pnt+1
	and #$03
	ora #>viccol    ;vic color ram
	sta user+1
	rts
.pag
key	jsr $ffea       ;update jiffy clock
	lda blnsw       ;blinking crsr ?
	bne key4        ;no
	dec blnct       ;time to blink ?
	bne key4        ;no
	lda #20         ;reset blink counter
repdo	sta blnct
	ldy pntr        ;cursor position
	lsr blnon       ;carry set if original char
	ldx gdcol       ;get char original color
	lda (pnt)y      ;get character
	bcs key5        ;branch if not needed
;
	inc blnon       ;set to 1
	sta gdbln       ;save original char
	jsr scolor
	lda (user)y     ;get original color
	sta gdcol       ;save it
	ldx color       ;blink in this color
	lda gdbln       ;with original character
;
key5	eor #$80        ;blink it
	jsr dspp2       ;display it
;
key4	lda r6510       ;get cassette switches
	and #$10        ;is switch down ?
	beq key3        ;branch if so
;
	ldy #0
	sty cas1        ;cassette off switch
;
	lda r6510
	ora #$20
	bne kl24        ;branch if motor is off
;
key3	lda cas1
	bne kl2
;
	lda r6510
	and #%011111    ;turn motor on
;
kl24
	sta r6510
;
kl2	jsr scnkey      ;scan keyboard
;
kprend	lda d1icr       ;clear interupt flags
	pla             ;restore registers
	tay
	pla
	tax
	pla
	rti             ;exit from irq routines
.ski 3
; ****** general keyboard scan ******
;
scnkey	lda #$00
	sta shflag
	ldy #64         ;last key index
	sty sfdx        ;null key found
	sta colm        ;raise all lines
	ldx rows        ;check for a key down
	cpx #$ff        ;no keys down?
	beq scnout      ;branch if none
	tay             ;.a=0 ldy #0
	lda #<mode1
	sta keytab
	lda #>mode1
	sta keytab+1
	lda #$fe        ;start with 1st column
	sta colm
scn20	ldx #8          ;8 row keyboard
	pha             ;save column output info
scn22	lda rows
	cmp rows        ;debounce keyboard
	bne scn22
scn30	lsr a           ;look for key down
	bcs ckit        ;none
	pha
	lda (keytab),y  ;get char code
	cmp #$05
	bcs spck2       ;if not special key go on
	cmp #$03        ;could it be a stop key?
	beq spck2       ;branch if so
	ora shflag
	sta shflag      ;put shift bit in flag byte
	bpl ckut
spck2
	sty sfdx        ;save key number
ckut	pla
ckit	iny
	cpy #65
	bcs ckit1       ;branch if finished
	dex
	bne scn30
	sec
	pla             ;reload column info
	rol a
	sta colm        ;next column on keyboard
	bne scn20       ;always branch
ckit1	pla             ;dump column output...all done
	jmp (keylog)    ;evaluate shift functions
rekey	ldy sfdx        ;get key index
	lda (keytab)y   ;get char code
	tax             ;save the char
	cpy lstx        ;same as prev char index?
	beq rpt10       ;yes
	ldy #$10        ;no - reset delay before repeat
	sty delay
	bne ckit2       ;always
rpt10	and #$7f        ;unshift it
	bit rptflg      ;check for repeat disable
	bmi rpt20       ;yes
	bvs scnrts
	cmp #$7f        ;no keys ?
scnout	beq ckit2       ;yes - get out
	cmp #$14        ;an inst/del key ?
	beq rpt20       ;yes - repeat it
	cmp #$20        ;a space key ?
	beq rpt20       ;yes
	cmp #$1d        ;a crsr left/right ?
	beq rpt20       ;yes
	cmp #$11        ;a crsr up/dwn ?
	bne scnrts      ;no - exit
rpt20	ldy delay       ;time to repeat ?
	beq rpt40       ;yes
	dec delay
	bne scnrts
rpt40	dec kount       ;time for next repeat ?
	bne scnrts      ;no
	ldy #4          ;yes - reset ctr
	sty kount
	ldy ndx         ;no repeat if queue full
	dey
	bpl scnrts
ckit2
	ldy sfdx        ;get index of key
	sty lstx        ;save this index to key found
	ldy shflag      ;update shift status
	sty lstshf
ckit3	cpx #$ff        ;a null key or no key ?
	beq scnrts      ;branch if so
	txa             ;need x as index so...
	ldx ndx         ;get # of chars in key queue
	cpx xmax        ;irq buffer full ?
	bcs scnrts      ;yes - no more insert
putque
	sta keyd,x      ;put raw data here
	inx
	stx ndx         ;update key queue count
scnrts	lda #$7f        ;setup pb7 for stop key sense
	sta colm
	rts
.pag
;
; shift logic
;
shflog
	lda shflag
	cmp #$03        ;commodore shift combination?
	bne keylg2      ;branch if not
	cmp lstshf      ;did i do this already
	beq scnrts      ;branch if so
	lda mode
	bmi shfout      ;dont shift if its minus
.ski
switch	lda vicreg+24   ;**********************************:
	eor #$02        ;turn on other case
	sta vicreg+24   ;point the vic there
	jmp shfout
.ski
;
keylg2
	asl a
	cmp #$08        ;was it a control key
	bcc nctrl       ;branch if not
	lda #6          ;else use table #4
;
nctrl
notkat
	tax
	lda keycod,x
	sta keytab
	lda keycod+1,x
	sta keytab+1
shfout
	jmp rekey
.end
; rsr 12/08/81 modify for vic-40
; rsr  2/18/82 modify for 6526 input pad sense
; rsr  3/11/82 fix keyboard debounce, repair file
; rsr  3/11/82 modify for commodore 64
; -------------------------------------------------------------
; ##### editor.3 #####
.pag 'keyboard tables'
keycod	;keyboard mode 'dispatch'
	.word mode1
	.word mode2
	.word mode3
	.word contrl    ;control keys
;
; cottaconna mode
;
;.word mode1  ;pet mode1
;.word mode2  ;pet mode2
;.word cctta3 ;dummy word
;.word contrl
;
; extended katakana mode
;
;.word cctta2 ;katakana characters
;.word cctta3 ;limited graphics
;.word cctta3 ;dummy
;.word contrl
.ski 5
.pag 'editor.3'
mode1
;del,3,5,7,9,+,yen sign,1
	.byt $14,$0d,$1d,$88,$85,$86,$87,$11
;return,w,r,y,i,p,*,left arrow
	.byt $33,$57,$41,$34,$5a,$53,$45,$01
;rt crsr,a,d,g,j,l,;,ctrl
	.byt $35,$52,$44,$36,$43,$46,$54,$58
;f4,4,6,8,0,-,home,2
	.byt $37,$59,$47,$38,$42,$48,$55,$56
;f1,z,c,b,m,.,r.shiftt,space
	.byt $39,$49,$4a,$30,$4d,$4b,$4f,$4e
;f2,s,f,h,k,:,=,com.key
	.byt $2b,$50,$4c,$2d,$2e,$3a,$40,$2c
;f3,e,t,u,o,@,exp,q
	.byt $5c,$2a,$3b,$13,$01,$3d,$5e,$2f
;crsr dwn,l.shift,x,v,n,,,/,stop
	.byt $31,$5f,$04,$32,$20,$02,$51,$03
	.byt $ff        ;end of table null
.ski3
mode2	;shift
;ins,%,',),+,yen,!
	.byt $94,$8d,$9d,$8c,$89,$8a,$8b,$91
;sreturn,w,r,y,i,p,*,sleft arrow
	.byt $23,$d7,$c1,$24,$da,$d3,$c5,$01
;lf.crsr,a,d,g,j,l,;,ctrl
	.byt $25,$d2,$c4,$26,$c3,$c6,$d4,$d8
;,$,&,(,      ,"
	.byt $27,$d9,$c7,$28,$c2,$c8,$d5,$d6
;f5,z,c,b,m,.,r.shift,sspace
	.byt $29,$c9,$ca,$30,$cd,$cb,$cf,$ce
;f6,s,f,h,k,:,=,scom.key
	.byt $db,$d0,$cc,$dd,$3e,$5b,$ba,$3c
;f7,e,t,u,o,@,pi,g
	.byt $a9,$c0,$5d,$93,$01,$3d,$de,$3f
;crsr dwn,l.shift,x,v,n,,,/,run
	.byt $21,$5f,$04,$22,$a0,$02,$d1,$83
	.byt $ff        ;end of table null
;
mode3	;left window grahpics
;ins,c10,c12,c14,9,+,pound sign,c8
	.byt $94,$8d,$9d,$8c,$89,$8a,$8b,$91
;return,w,r,y,i,p,*,lft.arrow
	.byt $96,$b3,$b0,$97,$ad,$ae,$b1,$01
;lf.crsr,a,d,g,j,l,;,ctrl
	.byt $98,$b2,$ac,$99,$bc,$bb,$a3,$bd
;f8,c11,c13,c15,0,-,home,c9
	.byt $9a,$b7,$a5,$9b,$bf,$b4,$b8,$be
;f2,z,c,b,m,.,r.shift,space
	.byt $29,$a2,$b5,$30,$a7,$a1,$b9,$aa
;f4,s,f,h,k,:,=,com.key
	.byt $a6,$af,$b6,$dc,$3e,$5b,$a4,$3c
;f6,e,t,u,o,@,pi,q
	.byt $a8,$df,$5d,$93,$01,$3d,$de,$3f
;crsr.up,l.shift,x,v,n,,,/,stop
	.byt $81,$5f,$04,$95,$a0,$02,$ab,$83
	.byt $ff        ;end of table null
;cctta2 ;was cctta2 in japanese version
lower
	cmp #$0e        ;does he want lower case?
	bne upper       ;branch if not
	lda vicreg+24   ;else set vic to point to lower case
	ora #$02
	bne ulset       ;jmp
.ski
upper
	cmp #$8e        ;does he want upper case
	bne lock        ;branch if not
	lda vicreg+24   ;make sure vic point to upper/pet set
	and #$ff-$02
ulset	sta vicreg+24
outhre	jmp loop2
.ski
lock
	cmp #8          ;does he want to lock in this mode?
	bne unlock      ;branch if not
	lda #$80        ;else set lock switch on
	ora mode        ;don't hurt anything - just in case
	bmi lexit
.ski
unlock
	cmp #9          ;does he want to unlock the keyboard?
	bne outhre      ;branch if not
	lda #$7f        ;clear the lock switch
	and mode        ;dont hurt anything
lexit	sta mode
	jmp loop2       ;get out
;cctta3
;.byt $04,$ff,$ff,$ff,$ff,$ff,$e2,$9d
;run-k24-k31
;.byt $83,$01,$ff,$ff,$ff,$ff,$ff,$91
;k32-k39.f5
;.byt $a0,$ff,$ff,$ff,$ff,$ee,$01,$89
;co.key,k40-k47.f6
;.byt $02,$ff,$ff,$ff,$ff,$e1,$fd,$8a
;k48-k55
;.byt $ff,$ff,$ff,$ff,$ff,$b0,$e0,$8b
;k56-k63
;.byt $f2,$f4,$f6,$ff,$f0,$ed,$93,$8c
;.byt $ff ;end of table null
.ski3
contrl
;null,red,purple,blue,rvs ,null,null,black
	.byt $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
;null, w  ,reverse, y  , i  , p  ,null,music
	.byt $1c,$17,$01,$9f,$1a,$13,$05,$ff
	.byt $9c,$12,$04,$1e,$03,$06,$14,$18
;null,cyan,green,yellow,rvs off,null,null,white
	.byt $1f,$19,$07,$9e,$02,$08,$15,$16
	.byt $12,$09,$0a,$92,$0d,$0b,$0f,$0e
	.byt $ff,$10,$0c,$ff,$ff,$1b,$00,$ff
	.byt $1c,$ff,$1d,$ff,$ff,$1f,$1e,$ff
	.byt $90,$06,$ff,$05,$ff,$ff,$11,$ff
	.byt $ff        ;end of table null
tvic
	.byt 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;sprites (0-16)
	.byt $9b,55,0,0,0,$08,0,$14,$0F,0,0,0,0,0,0 ;data (17-31)
	.byt 14,6,1,2,3,4,0,1,2,3,4,5,6,7 ;32-46
;
runtb	.byt 'load',$d,'run',$d
;
linz0	= vicscn
linz1	= linz0+llen
linz2	= linz1+llen
linz3	= linz2+llen
linz4	= linz3+llen
linz5	= linz4+llen
linz6	= linz5+llen
linz7	= linz6+llen
linz8	= linz7+llen
linz9	= linz8+llen
linz10	= linz9+llen
linz11	= linz10+llen
linz12	= linz11+llen
linz13	= linz12+llen
linz14	= linz13+llen
linz15	= linz14+llen
linz16	= linz15+llen
linz17	= linz16+llen
linz18	= linz17+llen
linz19	= linz18+llen
linz20	= linz19+llen
linz21	= linz20+llen
linz22	= linz21+llen
linz23	= linz22+llen
linz24	= linz23+llen
.skip 3
;****** screen lines lo byte table ******
;
ldtb2
	.byte <linz0
	.byte <linz1
	.byte <linz2
	.byte <linz3
	.byte <linz4
	.byte <linz5
	.byte <linz6
	.byte <linz7
	.byte <linz8
	.byte <linz9
	.byte <linz10
	.byte <linz11
	.byte <linz12
	.byte <linz13
	.byte <linz14
	.byte <linz15
	.byte <linz16
	.byte <linz17
	.byte <linz18
	.byte <linz19
	.byte <linz20
	.byte <linz21
	.byte <linz22
	.byte <linz23
	.byte <linz24
.end
; rsr 12/08/81 modify for vic-40 keyscan
; rsr  2/17/81 modify for the stinking 6526r2 chip
; rsr  3/11/82 modify for commodore 64
; rsr  3/28/82 modify for new pla
; -------------------------------------------------------------
; ##### serial4.0 #####
.pag 'serial routines'
;command serial bus device to talk
;
talk	ora #$40        ;make a talk adr
	.byt $2c        ;skip two bytes
.ski 3
;command serial bus device to listen
;
listn	ora #$20        ;make a listen adr
	jsr rsp232      ;protect self from rs232 nmi's
list1	pha
;
;
	bit c3p0        ;character left in buf?
	bpl list2       ;no...
;
;send buffered character
;
	sec             ;set eoi flag
	ror r2d2
;
	jsr isour       ;send last character
;
	lsr c3p0        ;buffer clear flag
	lsr r2d2        ;clear eoi flag
;
;
list2	pla             ;talk/listen address
	sta bsour
	sei
	jsr datahi
	cmp #$3f        ;clkhi only on unlisten
	bne list5
	jsr clkhi
;
list5	lda d2pra       ;assert attention
	ora #$08
	sta d2pra
;
.ski 3
isoura	sei
	jsr clklo       ;set clock line low
	jsr datahi
	jsr w1ms        ;delay 1 ms
.ski 3
isour	sei             ;no irq's allowed
	jsr datahi      ;make sure data is released
	jsr debpia      ;data should be low
	bcs nodev
	jsr clkhi       ;clock line high
	bit r2d2        ;eoi flag test
	bpl noeoi
; do the eoi
isr02	jsr debpia      ;wait for data to go high
	bcc isr02
;
isr03	jsr debpia      ;wait for data to go low
	bcs isr03
;
noeoi	jsr debpia      ;wait for data high
	bcc noeoi
	jsr clklo       ;set clock low
;
; set to send data
;
	lda #$08        ;count 8 bits
	sta count
;
isr01
	lda d2pra       ;debounce the bus
	cmp d2pra
	bne isr01
	asl a           ;set the flags
	bcc frmerr      ;data must be hi
;
	ror bsour       ;next bit into carry
	bcs isrhi
	jsr datalo
	bne isrclk
isrhi	jsr datahi
isrclk	jsr clkhi       ;clock hi
	nop
	nop
	nop
	nop
	lda d2pra
	and #$ff-$20    ;data high
	ora #$10        ;clock low
	sta d2pra
	dec count
	bne isr01
	lda #$04        ;set timer for 1ms
	sta d1t2h
	lda #timrb      ;trigger timer
	sta d1crb
	lda d1icr       ;clear the timer flags<<<<<<<<<<<<<
isr04	lda d1icr
	and #$02
	bne frmerr
	jsr debpia
	bcs isr04
	cli             ;let irq's continue
	rts
;
nodev	;device not present error
	lda #$80
	.byt $2c
frmerr	;framing error
	lda #$03
csberr	jsr udst        ;commodore serial buss error entry
	cli             ;irq's were off...turn on
	clc             ;make sure no kernal error returned
	bcc dlabye      ;turn atn off ,release all lines
;
.ski 3
;send secondary address after listen
;
secnd	sta bsour       ;buffer character
	jsr isoura      ;send it
.ski 3
;release attention after listen
;
scatn	lda d2pra
	and #$ff-$08
	sta d2pra       ;release attention
	rts
.ski 3
;talk second address
;
tksa	sta bsour       ;buffer character
	jsr isoura      ;send second addr
.ski 3
tkatn	;shift over to listener
	sei             ;no irq's here
	jsr datalo      ;data line low
	jsr scatn
	jsr clkhi       ;clock line high jsr/rts
tkatn1	jsr debpia      ;wait for clock to go low
	bmi tkatn1
	cli             ;irq's okay now
	rts
.ski 3
;buffered output to serial bus
;
ciout	bit c3p0        ;buffered char?
	bmi ci2         ;yes...send last
;
	sec             ;no...
	ror c3p0        ;set buffered char flag
	bne ci4         ;branch always
;
ci2	pha             ;save current char
	jsr isour       ;send last char
	pla             ;restore current char
ci4	sta bsour       ;buffer current char
	clc             ;carry-good exit
	rts
.ski 3
;send untalk command on serial bus
;
untlk	sei
	jsr clklo
	lda d2pra       ;pull atn
	ora #$08
	sta d2pra
	lda #$5f        ;untalk command
	.byt $2c        ;skip two bytes
.ski 3
;send unlisten command on serial bus
;
unlsn	lda #$3f        ;unlisten command
	jsr list1       ;send it
;
; release all lines
dlabye	jsr scatn       ;always release atn
; delay then release clock and data
;
dladlh	txa             ;delay approx 60 us
	ldx #10
dlad00	dex
	bne dlad00
	tax
	jsr clkhi
	jmp datahi
.ski 3
;input a byte from serial bus
;
acptr
	sei             ;no irq allowed
	lda #$00        ;set eoi/error flag
	sta count
	jsr clkhi       ;make sure clock line is released
acp00a	jsr debpia      ;wait for clock high
	bpl acp00a
;
eoiacp
	lda #$01        ;set timer 2 for 256us
	sta d1t2h
	lda #timrb
	sta d1crb
	jsr datahi      ;data line high (makes timming more like vic-20
	lda d1icr       ;clear the timer flags<<<<<<<<<<<<
acp00	lda d1icr
	and #$02        ;check the timer
	bne acp00b      ;ran out.....
	jsr debpia      ;check the clock line
	bmi acp00       ;no not yet
	bpl acp01       ;yes.....
;
acp00b	lda count       ;check for error (twice thru timeouts)
	beq acp00c
	lda #2
	jmp csberr      ; st = 2 read timeout
;
; timer ran out do an eoi thing
;
acp00c	jsr datalo      ;data line low
	jsr clkhi       ; delay and then set datahi (fix for 40us c64)
	lda #$40
	jsr udst        ;or an eoi bit into status
	inc count       ;go around again for error check on eoi
	bne eoiacp
;
; do the byte transfer
;
acp01	lda #08         ;set up counter
	sta count
;
acp03	lda d2pra       ;wait for clock high
	cmp d2pra       ;debounce
	bne acp03
	asl a           ;shift data into carry
	bpl acp03       ;clock still low...
	ror bsour1      ;rotate data in
;
acp03a	lda d2pra       ;wait for clock low
	cmp d2pra       ;debounce
	bne acp03a
	asl a
	bmi acp03a
	dec count
	bne acp03       ;more bits.....
;...exit...
	jsr datalo      ;data low
	bit status      ;check for eoi
	bvc acp04       ;none...
;
	jsr dladlh      ;delay then set data high
;
acp04	lda bsour1
	cli             ;irq is ok
	clc             ;good exit
	rts
;
clkhi	;set clock line high (inverted)
	lda d2pra
	and #$ff-$10
	sta d2pra
	rts
;
clklo	;set clock line low  (inverted)
	lda d2pra
	ora #$10
	sta d2pra
	rts
;
;
datahi	;set data line high (inverted)
	lda d2pra
	and #$ff-$20
	sta d2pra
	rts
;
datalo	;set data line low  (inverted)
	lda d2pra
	ora #$20
	sta d2pra
	rts
;
debpia	lda d2pra       ;debounce the pia
	cmp d2pra
	bne debpia
	asl a           ;shift the data bit into the carry...
	rts             ;...and the clock into neg flag
;
w1ms	;delay 1ms using loop
	txa             ;save .x
	ldx #200-16     ;1000us-(1000/500*8=#40us holds)
w1ms1	dex             ;5us loop
	bne w1ms1
	tax             ;restore .x
	rts
.end
;*******************************
;written 8/11/80 bob fairbairn
;test serial0.6 8/12/80  rjf
;change i/o structure 8/21/80 rjf
;more i/o changes 8/24/80 rjf
;final release into kernal 8/26/80 rjf
;some clean up 9/8/80 rsr
;add irq protect on isour and tkatn 9/22/80 rsr
;fix untalk 10/7/80 rsr
;modify for vic-40 i/o system 12/08/81 rsr
;add sei to (untlk,isoura,list2) 12/14/81 rsr
;modify for 6526 flags fix errs 12/31/81 rsr
;modify for commodore 64 i/o  3/11/82 rsr
;change acptr eoi for better response 3/28/82 rsr
;change wait 1 ms routine for less code 4/8/82 rsr
;******************************
.end
; -------------------------------------------------------------
; ##### rs232trans #####
.page 'rs-232 transmitt'
; rstrab - entry for nmi continue routine
; rstbgn - entry for start transmitter
;
;   rsr - 8/18/80
;
; variables used
;   bitts - # of bits to be sent (<>0 not done)
;   nxtbit - byte contains next bit to be sent
;   roprty - byte contains parity bit calculated
;   rodata - stores data byte currently being transmitted
;   rodbs - output buffer index start
;   rodbe - output buffer index end
;   if rodbs=rodbe then buffer empty
;   robuf - indirect pointer to data buffer
;   rsstat - rs-232 status byte
;
;   xxx us - normal bit path
;   xxx us - worst case parity bit path
;   xxx us - stop bit path
;   xxx us - start bit path
;
rstrab	lda bitts       ;check for place in byte...
	beq rstbgn      ;...done, =0 start next
;
	bmi rst050      ;...doing stop bits
;
	lsr rodata      ;shift data into carry
	ldx #00         ;prepare for a zero
	bcc rst005      ;yes...a zero
	dex             ;no...make an $ff
rst005	txa             ;ready to send
;
	eor roprty      ;calc into parity
	sta roprty
;
	dec bitts       ;bit count down
	beq rst010      ;want a parity instead
;
rstext	txa             ;calc bit whole to send
	and #$04        ;goes out d2pa2
	sta nxtbit
	rts
.page 'rs-232 transmitt'
; calculate parity
;  nxtbit =0 upon entry
;
rst010	lda #$20        ;check 6551 reg bits
	bit m51cdr
	beq rspno       ;...no parity, send a stop
	bmi rst040      ;...not real parity
	bvs rst030      ;...even parity
;
	lda roprty      ;calc odd parity
	bne rspext      ;correct guess
;
rswext	dex             ;wrong guess...its a one
;
rspext	dec bitts       ;one stop bit always
	lda m51ctr      ;check # of stop bits
	bpl rstext      ;...one
	dec bitts       ;...two
	bne rstext      ;jump
;
rspno	;line to send cannot be pb0
	inc bitts       ;counts as one stop bit
	bne rswext      ;jump to flip to one
;
rst030	lda roprty      ;even parity
	beq rspext      ;correct guess...exit
	bne rswext      ;wrong...flip and exit
;
rst040	bvs rspext      ;wanted space
	bvc rswext      ; wanted mark
.ski 3
; stop bits
;
rst050	inc bitts       ;stop bit count towards zero
	ldx #$ff        ;send stop bit
	bne rstext      ;jump to exit
;
.pag 'rs-232 transmitt'
; rstbgn - entry to start byte trans
;
rstbgn	lda m51cdr      ;check for 3/x line
	lsr a
	bcc rst060      ;3 line...no check
	bit d2prb       ;check for...
	bpl dsrerr      ;...dsr error
	bvc ctserr      ;...cts error
;
; set up to send next byte
;
rst060	lda #0
	sta roprty      ;zero parity
	sta nxtbit      ;send start bit
	ldx bitnum      ;get # of bits
rst070	stx bitts       ;bitts=#of bitts+1
;
rst080	ldy rodbs       ;check buffer pointers
	cpy rodbe
	beq rsodne      ;all done...
;
	lda (robuf)y    ;get data...
	sta rodata      ;...into byte buffer
	inc rodbs       ;move pointer to next
	rts
.ski 3
; set errors
;
dsrerr	lda #$40        ;dsr gone error
	.byt $2c
ctserr	lda #$10        ;cts gone error
	ora rsstat
	sta rsstat
;
; errors turn off t1
;
rsodne	lda #$01        ;kill t1 nmi
;entry to turn off an enabled nmi...
oenabl	sta d2icr       ;toss bad/old nmi
	eor enabl       ;flip enable
	ora #$80        ;enable good nmi's
	sta enabl
	sta d2icr
	rts
.ski 3
; bitcnt - cal # of bits to be sent
;   returns #of bits+1
;
bitcnt	ldx #9          ;calc word length
	lda #$20
	bit m51ctr
	beq bit010
	dex             ;bit 5 high is a 7 or 5
bit010	bvc bit020
	dex             ;bit 6 high is a 6 or 5
	dex
bit020	rts
.end
; rsr  8/24/80 correct some mistakes
; rsr  8/27/80 change bitnum base to #bits+1
; rsr 12/11/81 modify for vic-40
; rsr  3/11/82 fix enables for bad/old nmi's
; -------------------------------------------------------------
; ##### rs232rcvr #####
.pag 'rs-232 receiver'
; rsrcvr - nmi routine to collect
;  data into bytes
;
; rsr 8/18/80
;
; variables used
;   inbit - input bit value
;   bitci - bit count in
;   rinone - flag for start bit check <>0 start bit
;   ridata - byte input buffer
;   riprty - holds byte input parity
;   ribuf - indirect pointer to data buffer
;   ridbe - input buffer index to end
;   ridbs - input buffer pointer to start
;   if ridbe=ridbs then input buffer empty
;
rsrcvr	ldx rinone      ;check for start bit
	bne rsrtrt      ;was start bit
;
	dec bitci       ;check where we are in input...
	beq rsr030      ;have a full byte
	bmi rsr020      ;getting stop bits
;
; calc parity
;
	lda inbit       ;get data up
	eor riprty      ;calc new parity
	sta riprty
;
; shift data bit in
;
	lsr inbit       ;in bit pos 0
	ror ridata      ;c into data
;
; exit
;
rsrext	rts
.pag 'rs-232 receiver'
; have stop bit, so store in buffer
;
rsr018	dec bitci       ;no parity, dec so check works
rsr020	lda inbit       ;get data...
	beq rsr060      ;...zero, an error?
;
	lda m51ctr      ;check for correct # of stop bits
	asl a           ;carry tell how may stop bits
	lda #01
	adc bitci
	bne rsrext      ;no..exit
;
; rsrabl - enable to recieve a byte
;
rsrabl	lda #$90        ;enable flag for next byte
	sta d2icr       ;toss bad/old nmi
	ora enabl       ;mark in enable register***********
	sta enabl       ;re-enabled by jmp oenabl
	sta rinone      ;flag for start bit
;
rsrsxt	lda #$02        ;disable t2
	jmp oenabl      ;flip-off enabl***************
.ski 2
; reciever start bit check
;
rsrtrt	lda inbit       ;check if space
	bne rsrabl      ;bad...try again
	jmp prtyp       ;go to parity patch 901227-03
; sta rinone ;good...disable flag
; rts ;and exit
.ski 4
;
; put data in buffer (at parity time)
;
rsr030	ldy ridbe       ;get end
	iny
	cpy ridbs       ;have we passed start?
	beq recerr      ;yes...error
;
	sty ridbe       ;move ridbe foward
	dey
;
	lda ridata      ;get byte buffer up
	ldx bitnum      ;shift untill full byte
rsr031	cpx #9          ;always 8 bits
	beq rsr032
	lsr a           ;fill with zeros
	inx
	bne rsr031
;
rsr032	sta (ribuf)y    ;data to page buffer
;
; parity checking
;
	lda #$20        ;check 6551 command register
	bit m51cdr
	beq rsr018      ;no parity bit so stop bit
	bmi rsrext      ;no parity check
;
; check calc parity
;
	lda inbit
	eor riprty      ;put in with parity
	beq rsr050      ;even parity
	bvs rsrext      ;odd...okay so exit
	.byt $2c        ;skip two
rsr050	bvc rsrext      ;even...okay so exit
;
; errors reported
	lda #1          ;parity error
	.byt $2c
recerr	lda #$4         ;reciever overrun
	.byt $2c
breake	lda #$80        ;break detected
	.byt $2c
framee	lda #$02        ;frame error
err232	ora rsstat
	sta rsstat
	jmp rsrabl      ;bad exit so hang ##????????##
;
; check for errors
;
rsr060	lda ridata      ;expecting stop...
	bne framee      ;frame error
	beq breake      ;could be a break
.end
; rsr -  8/21/80 add mods
; rsr -  8/24/80 fix errors
; rsr -  8/27/80 fix major errors
; rsr -  8/30/80 fix t2 adjust
; rsr - 12/11/81 modify for vic-40 i/o
; rsr -  3/11/82 fix for bad/old nmi's
; -------------------------------------------------------------
; ##### rs232inout #####
.pag 'rs232 inout'
; output a file over usr port
;  using rs232
;
cko232	sta dflto       ;set default out
	lda m51cdr      ;check for 3/x line
	lsr a
	bcc cko100      ;3line...no turn around
;
;*turn around logic
;
; check for dsr and rts
;
	lda #$02        ;bit rts is on
	bit d2prb
	bpl ckdsrx      ;no dsr...error
	bne cko100      ;rts...outputing or full duplex
;
; check for active input
;  rts will be low if currently inputing
;
cko020	lda enabl
	and #$02        ;look at ier for t2
	bne cko020      ;hang untill input done
;
; wait for cts to be off as spec reqs
;
cko030	bit d2prb
	bvs cko030
;
; turn on rts
;
	lda d2prb
	ora #$02
	sta d2prb
;
; wait for cts to go on
;
cko040	bit d2prb
	bvs cko100      ;done...
	bmi cko040      ;we still have dsr
;
ckdsrx	lda #$40        ;a data set ready error
	sta rsstat      ;major error....will require reopen
;
cko100	clc             ;no error
	rts
;
.page 'rs232 inout'
; bso232 - output a char rs232
;   data passed in t1 from bsout
;
; hang loop for buffer full
;
bsobad	jsr bso100      ;keep trying to start system...
;
; buffer handler
;
bso232	ldy rodbe
	iny
	cpy rodbs       ;check for buffer full
	beq bsobad      ;hang if so...trying to restart
	sty rodbe       ;indicate new start
	dey
	lda t1          ;get data...
	sta (robuf)y    ;store data
;
; set up if necessary to output
;
bso100	lda enabl       ;check for a t1 nmi enable
	lsr a           ;bit 0
	bcs bso120      ;running....so exit
;
; set up t1 nmi's
;
bso110	lda #$10        ;turn off timer to prevent false start...
	sta d2cra
	lda baudof      ;set up timer1
	sta d2t1l
	lda baudof+1
	sta d2t1h
	lda #$81
	jsr oenabl
	jsr rstbgn      ;set up to send (will stop on cts or dsr error)
	lda #$11        ;turn on timer
	sta d2cra
bso120	rts
.page 'rs232 inout'
; input a file over user port
;  using rs232
;
cki232	sta dfltn       ;set default input
;
	lda m51cdr      ;check for 3/x line
	lsr a
	bcc cki100      ;3 line...no handshake
;
	and #$08        ;full/half check (byte shifted above)
	beq cki100      ;full...no handshake
;
;*turn around logic
;
; check if dsr and not rts
;
	lda #$02        ;bit rts is on
	bit d2prb
	bpl ckdsrx      ;no dsr...error
	beq cki110      ;rts low...in correct mode
;
; wait for active output to be done
;
cki010	lda enabl
	lsr a           ;check t1 (bit 0)
	bcs cki010
;
; turn off rts
;
	lda d2prb
	and #$ff-02
	sta d2prb
;
; wait for dcd to go high (in spec)
;
cki020	lda d2prb
	and #$04
	beq cki020
;
; enable flag for rs232 input
;
cki080	lda #$90
	clc             ;no error
	jmp oenabl      ;flag in enabl**********
;
; if not 3 line half then...
;  see if we need to turn on flag
;
cki100	lda enabl       ;check for flag or t2 active
	and #$12
	beq cki080      ;no need to turn on
cki110	clc             ;no error
	rts
.page 'rs232 inout'
; bsi232 - input a char rs232
;
; buffer handler
;
bsi232	lda rsstat      ;get status up to change...
	ldy ridbs       ;get last byte address
	cpy ridbe       ;see if buffer empty
	beq bsi010      ;return a null if no char
;
	and #$ff-$08    ;clear buffer empty status
	sta rsstat
	lda (ribuf)y    ;get last char
	inc ridbs       ;inc to next pos
;
; receiver always runs
;
	rts
;
bsi010	ora #$08        ;set buffer empty status
	sta rsstat
	lda #$0         ;return a null
	rts
.ski 4
; rsp232 - protect serial/cass from rs232 nmi's
;
rsp232	pha             ;save .a
	lda enabl       ;does rs232 have any enables?
	beq rspok       ;no...
rspoff	lda enabl       ;wait untill done
	and #%00000011  ; with t1 & t2
	bne rspoff
	lda #%00010000  ; disable flag (need to renable in user code)
	sta d2icr       ;turn of enabl************
	lda #0
	sta enabl       ;clear all enabls
rspok	pla             ;all done
	rts
.end
; rsr  8/24/80 original code out
; rsr  8/25/80 original code in
; rsr  9/22/80 remove parallel refs & fix xline logic
; rsr 12/11/81 modify for vic-40 i/o
; rsr  2/15/82 fix some enabl problems
; rsr  3/31/82 fix flase starts on transmitt
; rsr  5/12/82 reduce code and fix x-line cts hold-off
; -------------------------------------------------------------
; ##### messages #####
.pag 'messages'
ms1	.byt $d,'i/o error ',$a3
ms5	.byt $d,'searching',$a0
ms6	.byt 'for',$a0
ms7	.byt $d,'press play on tap',$c5
ms8	.byt 'press record & play on tap',$c5
ms10	.byt $d,'loadin',$c7
ms11	.byt $d,'saving',$a0
ms21	.byt $d,'verifyin',$c7
ms17	.byt $d,'found',$a0
ms18	.byt $d,'ok',$8d
; ms34 .byt $d,'monitor',$8d
; ms36 .byt $d,'brea',$cb
.ski 5
;print message to screen only if
;output enabled
;
spmsg	bit msgflg      ;printing messages?
	bpl msg10       ;no...
msg	lda ms1,y
	php
	and #$7f
	jsr bsout
	iny
	plp
	bpl msg
msg10	clc
	rts
.end
; -------------------------------------------------------------
; ##### channelio #####
.pag 'channel i/o'
;***************************************
;* getin -- get character from channel *
;*      channel is determined by dfltn.*
;* if device is 0, keyboard queue is   *
;* examined and a character removed if *
;* available.  if queue is empty, z    *
;* flag is returned set.  devices 1-31 *
;* advance to basin.                   *
;***************************************
;
ngetin	lda dfltn       ;check device
	bne gn10        ;not keyboard
;
	lda ndx         ;queue index
	beq gn20        ;nobody there...exit
;
	sei
	jmp lp2         ;go remove a character
;
gn10	cmp #2          ;is it rs-232
	bne bn10        ;no...use basin
;
gn232	sty xsav        ;save .y, used in rs232
	jsr bsi232
	ldy xsav        ;restore .y
gn20	clc             ;good return
	rts
.ski 3
;***************************************
;* basin-- input character from channel*
;*     input differs from get on device*
;* #0 function which is keyboard. the  *
;* screen editor makes ready an entire *
;* line which is passed char by char   *
;* up to the carriage return.  other   *
;* devices are:                        *
;*      0 -- keyboard                  *
;*      1 -- cassette #1               *
;*      2 -- rs232                     *
;*      3 -- screen                    *
;*   4-31 -- serial bus                *
;***************************************
;
nbasin	lda dfltn       ;check device
	bne bn10        ;is not keyboard...
;
;input from keyboard
;
	lda pntr        ;save current...
	sta lstp        ;... cursor column
	lda tblx        ;save current...
	sta lsxp        ;... line number
	jmp loop5       ;blink cursor until return
;
bn10	cmp #3          ;is input from screen?
	bne bn20        ;no...
;
	sta crsw        ;fake a carriage return
	lda lnmx        ;say we ended...
	sta indx        ;...up on this line
	jmp loop5       ;pick up characters
;
bn20	bcs bn30        ;devices >3
	cmp #2          ;rs232?
	beq bn50
;
;input from cassette buffers
;
	stx xsav
	jsr jtget
	bcs jtg37       ;stop key/error
	pha
	jsr jtget
	bcs jtg36       ;stop key/error
	bne jtg35       ;not an end of file
	lda #64         ;tell user eof
	jsr udst        ;in status
jtg35	dec bufpt
	ldx xsav        ;.x preserved
	pla             ;character returned
;c-clear from jtget
	rts             ;all done
;
jtg36	tax             ;save error info
	pla             ;toss data
	txa             ;restore error
jtg37	ldx xsav        ;return
	rts             ;error return c-set from jtget
.ski 3
;get a character from appropriate
;cassette buffer
;
jtget	jsr jtp20       ;buffer pointer wrap?
	bne jtg10       ;no...
	jsr rblk        ;yes...read next block
	bcs bn33        ;stop key pressed
	lda #0
	sta bufpt       ;point to begin.
	beq jtget       ;branch always
;
jtg10	lda (tape1)y    ;get char from buf
	clc             ;good return
	rts 
.ski 3
;input from serial bus
;
bn30	lda status      ;status from last
	beq bn35        ;was good
bn31	lda #$d         ;bad...all done
bn32	clc             ;valid data
bn33	rts
;
bn35	jmp acptr       ;good...handshake
;
;input from rs232
;
bn50	jsr gn232       ;get info
	bcs bn33        ;error return
	cmp #00
	bne bn32        ;good data...exit
	lda rsstat      ;check for dsr or dcd error
	and #$60
	bne bn31        ;an error...exit with c/r
	beq bn50        ;no error...stay in loop
.pag 'channel output'
;***************************************
;* bsout -- out character to channel   *
;*     determined by variable dflto:   *
;*     0 -- invalid                    *
;*     1 -- cassette #1                *
;*     2 -- rs232                      *
;*     3 -- screen                     *
;*  4-31 -- serial bus                 *
;***************************************
;
nbsout	pha             ;preserve .a
	lda dflto       ;check device
	cmp #3          ;is it the screen?
	bne bo10        ;no...
;
;print to crt
;
	pla             ;restore data
	jmp prt         ;print on crt
;
bo10
	bcc bo20        ;device 1 or 2
;
;print to serial bus
;
	pla
	jmp ciout
;
;print to cassette devices
;
bo20	lsr a           ;rs232?
	pla             ;get data off stack...
;
casout	sta t1          ;pass data in t1
; casout must be entered with carry set!!!
;preserve registers
;
	txa
	pha
	tya
	pha
	bcc bo50        ;c-clr means dflto=2 (rs232)
;
	jsr jtp20       ;check buffer pointer
	bne jtp10       ;has not reached end
	jsr wblk        ;write full buffer
	bcs rstor       ;abort on stop key
;
;put buffer type byte
;
	lda #bdf
	ldy #0
	sta (tape1)y
;
;reset buffer pointer
;
	iny             ;make .y=1
	sty bufpt       ;bufpt=1
;
jtp10	lda t1
	sta (tape1)y    ;data to buffer
;
;restore .x and .y
;
rstoa	clc             ;good return
rstor	pla
	tay
	pla
	tax
	lda t1          ;get .a for return
	bcc rstor1      ;no error
	lda #00         ;stop error if c-set
rstor1	rts
;
;output to rs232
;
bo50	jsr bso232      ;pass data through variable t1
	jmp rstoa       ;go restore all..always good
.end
; rsr 5/12/82 fix bsout for no reg affect but errors
; -------------------------------------------------------------
; ##### openchannel #####
.pag 'open channel'
;***************************************
;* chkin -- open channel for input     *
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
;
nchkin	jsr lookup      ;see if file known
	beq jx310       ;yup...
;
	jmp error3      ;no...file not open
;
jx310	jsr jz100       ;extract file info
;
	lda fa
	beq jx320       ;is keyboard...done.
;
;could be screen, keyboard, or serial
;
	cmp #3
	beq jx320       ;is screen...done.
	bcs jx330       ;is serial...address it
	cmp #2          ;rs232?
	bne jx315       ;no...
;
	jmp cki232
;
;some extra checks for tape
;
jx315	ldx sa
	cpx #$60        ;is command a read?
	beq jx320       ;yes...o.k....done
;
	jmp error6      ;not input file
;
jx320	sta dfltn       ;all input come from here
;
	clc             ;good exit
	rts
;
;an serial device has to be a talker
;
jx330	tax             ;device # for dflto
	jsr talk        ;tell him to talk
;
	lda sa          ;a second?
	bpl jx340       ;yes...send it
	jsr tkatn       ;no...let go
	jmp jx350
;
jx340	jsr tksa        ;send second
;
jx350	txa
	bit status      ;did he listen?
	bpl jx320       ;yes
;
	jmp error5      ;device not present
.pag 'open channel out'
;***************************************
;* chkout -- open channel for output     *
;*                                     *
;* the number of the logical file to be*
;* opened for output is passed in .x.  *
;* chkout searches the logical file    *
;* to look up device and command info. *
;* errors are reported if the device   *
;* was not opened for input ,(e.g.     *
;* keyboard), or the logical file has   *
;* reference in the tables.             *
;* device 0, (keyboard), and device 3  *
;* (screen), require no table entries  *
;* and are handled separate.           *
;***************************************
;
nckout	jsr lookup      ;is file in table?
	beq ck5         ;yes...
;
	jmp error3      ;no...file not open
;
ck5	jsr jz100       ;extract table info
;
	lda fa          ;is it keyboard?
	bne ck10        ;no...something else.
;
ck20	jmp error7      ;yes...not output file
;
;could be screen,serial,or tapes
;
ck10	cmp #3
	beq ck30        ;is screen...done
	bcs ck40        ;is serial...address it
	cmp #2          ;rs232?
	bne ck15
;
	jmp cko232
;
;
;special tape channel handling
;
ck15	ldx sa
	cpx #$60        ;is command read?
	beq ck20        ;yes...error
;
ck30	sta dflto       ;all output goes here
;
	clc             ;good exit
	rts
;
ck40	tax             ;save device for dflto
	jsr listn       ;tell him to listen
;
	lda sa          ;is there a second?
	bpl ck50        ;yes...
;
	jsr scatn       ;no...release lines
	bne ck60        ;branch always
;
ck50	jsr secnd       ;send second...
;
ck60	txa
	bit status      ;did he listen?
	bpl ck30        ;yes...finish up
;
	jmp error5      ;no...device not present
.end
; -------------------------------------------------------------
; ##### close #####
.pag 'close'
;***************************************
;* close -- close logical file       *
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
;***************************************
;
nclose	jsr jltlk       ;look file up
	beq jx050       ;open...
	clc             ;else return
	rts
;
jx050	jsr jz100       ;extract table data
	txa             ;save table index
	pha
;
	lda fa          ;check device number
	beq jx150       ;is keyboard...done
	cmp #3
	beq jx150       ;is screen...done
	bcs jx120       ;is serial...process
	cmp #2          ;rs232?
	bne jx115       ;no...
;
; rs-232 close
;
; remove file from tables
	pla
	jsr jxrmv
;
	jsr cln232      ;clean up rs232 for close
;
; deallocate buffers
;
	jsr gettop      ;get memsiz
	lda ribuf+1     ;check input allocation
	beq cls010      ;not...allocated
	iny
cls010	lda robuf+1     ;check output allocation
	beq cls020
	iny
cls020	lda #00         ;deallocate
	sta ribuf+1
	sta robuf+1
; flag top of memory change
	jmp memtcf      ;go set new top
;
;close cassette file
;
jx115	lda sa          ;was it a tape read?
	and #$f
	beq jx150       ;yes
;
	jsr zzz         ;no. . .it is write
	lda #0          ;end of file character
	sec             ;need to set carry for casout (else rs232 output!)
	jsr casout      ;put in end of file
	jsr wblk
	bcc jx117       ;no errors...
	pla             ;clean stack for error
	lda #0          ;break key error
	rts
;
jx117	lda sa
	cmp #$62        ;write end of tape block?
	bne jx150       ;no...
;
	lda #eot
	jsr tapeh       ;write end of tape block
	jmp jx150
;
;close an serial file
;
jx120	jsr clsei
;
;entry to remove a give logical file
;from table of logical, primary,
;and secondary addresses
;
jx150	pla             ;get table index off stack
;
; jxrmv - entry to use as an rs-232 subroutine
;
jxrmv	tax
	dec ldtnd
	cpx ldtnd       ;is deleted file at end?
	beq jx170       ;yes...done
;
;delete entry in middle by moving
;last entry to that position.
;
	ldy ldtnd
	lda lat,y
	sta lat,x
	lda fat,y
	sta fat,x
	lda sat,y
	sta sat,x
;
jx170	clc             ;close exit
jx175	rts
.ski 5
;lookup tablized logical file data
;
lookup	lda #0
	sta status
	txa
jltlk	ldx ldtnd
jx600	dex
	bmi jz101
	cmp lat,x
	bne jx600
	rts
.ski 5
;routine to fetch table entries
;
jz100	lda lat,x
	sta la
	lda fat,x
	sta fa
	lda sat,x
	sta sa
jz101	rts
.end
; rsr  5/12/82 - modify for cln232
; -------------------------------------------------------------
; ##### clall #####
.pag 'close all files'
;***************************************
;* clall -- close all logical files  *
;*      deletes all table entries and*
;* restores default i/o channels     *
;* and clears ieee port devices      *
;*************************************
;
nclall	lda #0
	sta ldtnd       ;forget all files
.ski 3
;********************************************
;* clrch -- clear channels                  *
;*   unlisten or untalk ieee devices, but   *
;* leave others alone.  default channels    *
;* are restored.                            *
;********************************************
;
nclrch	ldx #3
	cpx dflto       ;is output channel ieee?
	bcs jx750       ;no...
;
	jsr unlsn       ;yes...unlisten it
;
jx750	cpx dfltn       ;is input channel ieee?
	bcs clall2      ;no...
;
	jsr untlk       ;yes...untalk it
;
;restore default values
;
;
clall2	stx dflto       ;output chan=3=screen
	lda #0
	sta dfltn       ;input chan=0=keyboard
	rts
.end
; -------------------------------------------------------------
; ##### open #####
.pag 'open file'
;***********************************
;*                                 *
;* open function                   *
;*                                 *
;* creates an entry in the logical *
;* files tables consisting of      *
;* logical file number--la, device *
;* number--fa, and secondary cmd-- *
;* sa.                             *
;*                                 *
;* a file name descriptor, fnadr & *
;* fnlen are passed to this routine*
;*                                 *
;***********************************
;
nopen	ldx la          ;check file #
	bne op98        ;is not the keyboard
;
	jmp error6      ;not input file...
;
op98	jsr lookup      ;see if in table
	bne op100       ;not found...o.k.
;
	jmp error2      ;file open
;
op100	ldx ldtnd       ;logical device table end
	cpx #10         ;maximum # of open files
	bcc op110       ;less than 10...o.k.
;
	jmp error1      ;too many files
;
op110	inc ldtnd       ;new file
	lda la
	sta lat,x       ;store logical file #
	lda sa
	ora #$60        ;make sa an serial command
	sta sa
	sta sat,x       ;store command #
	lda fa
	sta fat,x       ;store device #
;
;perform device specific open tasks
;
	beq op175       ;is keyboard...done.
	cmp #3
	beq op175       ;is screen...done.
	bcc op150       ;are cassettes 1 & 2
;
	jsr openi       ;is on serial...open it
	bcc op175       ;branch always...done
;
;perform tape open stuff
;
op150	cmp #2
	bne op152
;
	jmp opn232
;
op152	jsr zzz         ;see if tape buffer
	bcs op155       ;yes
;
	jmp error9      ;no...deallocated
;
op155	lda sa
	and #$f         ;mask off command
	bne op200       ;non zero is tape write
;
;open cassete tape file to read
;
	jsr cste1       ;tell "press play"
	bcs op180       ;stop key pressed
;
	jsr luking      ;tell user "searching"
;
	lda fnlen
	beq op170       ;looking for any file
;
	jsr faf         ;looking for named file
	bcc op171       ;found it!!!
	beq op180       ;stop key pressed
;
op160	jmp error4      ;file not found
;
op170	jsr fah         ;get any old header
	beq op180       ;stop key pressed
	bcc op171       ;all o.k.
	bcs op160       ;file not found...
;
;open cassette tape for write
;
op200	jsr cste2       ;tell "press play and record"
	bcs op180       ;stop key pressed
	lda #bdfh       ;data file header type
	jsr tapeh       ;write it
;
;finish open for tape read/write
;
op171	lda #bufsz-1    ;assume force read
;
	ldy sa
	cpy #$60        ;open for read?
	beq op172
;
;set pointers for buffering data
;
	ldy #0
	lda #bdf        ;type flag for block
	sta (tape1)y    ;to begin of buffer
	tya
;
op172	sta bufpt       ;point to data
op175	clc             ;flag good open
op180	rts             ;exit in peace
.ski 5
openi	lda sa
	bmi op175       ;no sa...done
;
	ldy fnlen
	beq op175       ;no file name...done
;
	lda #0          ;clear the serial status
	sta status
;
	lda fa
	jsr listn       ;device la to listen
;
	lda sa
	ora #$f0
	jsr secnd
;
	lda status      ;anybody home?
	bpl op35        ;yes...continue
;
;this routine is called by other
;kernal routines which are called
;directly by os.  kill return
;address to return to os.
;
	pla
	pla
	jmp error5      ;device not present
;
op35	lda fnlen
	beq op45        ;no name...done sequence
;
;send file name over serial
;
	ldy #0
op40	lda (fnadr)y
	jsr ciout
	iny
	cpy fnlen
	bne op40
;
op45	jmp cunlsn      ;jsr unlsn: clc: rts
.page 'open rs232 file'
; opn232 - open an rs-232 or parallel port file
;
; variables initilized
;   bitnum - # of bits to be sent calc from m51ctr
;   baudof - baud rate full
;   rsstat - rs-232 status reg
;   m51ctr - 6551 control reg
;   m51cdr - 6551 command reg
;   m51ajb - user baud rate (clock/baud/2-100)
;   enabl  - 6526 nmi enables (1-nmi bit on)
;
opn232	jsr cln232      ;set up rs232, .y=0 on return
;
; pass prams to m51regs
;
	sty rsstat      ;clear status
;
opn020	cpy fnlen       ;check if at end of filename
	beq opn025      ;yes...
;
	lda (fnadr)y    ;move data
	sta m51ctr,y    ;to m51regs
	iny
	cpy #4          ;only 4 possible prams
	bne opn020
;
; calc # of bits
;
opn025	jsr bitcnt
	stx bitnum
;
; calc baud rate
;
	lda m51ctr
	and #$0f
	beq opn028
;
; calculate start-test rate...
;  different than original release 901227-01
;
	asl a           ;get offset into tables
	tax
	lda palnts      ;get tv standard
	bne opn026
	ldy baudo-1,x   ;ntsc standard
	lda baudo-2,x
	jmp opn027
;
opn026	ldy baudop-1,x  ;pal standard
	lda baudop-2,x
opn027	sty m51ajb+1    ;hold start rate in m51ajb
	sta m51ajb
opn028	lda m51ajb      ;calculate baud rate
	asl
	jsr popen       ;goto patch area
;
; check for 3/x line response
;
opn030	lda m51cdr      ;bit 0 of m51cdr
	lsr a
	bcc opn050      ;...3 line
;
; check for x line proper states
;
	lda d2prb
	asl a
	bcs opn050
	jsr ckdsrx      ;change from jmp to prevent system 
;
; set up buffer pointers (dbe=dbs)
;
opn050	lda ridbe
	sta ridbs
	lda rodbe
	sta rodbs
;
; allocate buffers
;
opn055	jsr gettop      ;get memsiz
	lda ribuf+1     ;in allocation...
	bne opn060      ;already
	dey             ;there goes 256 bytes
	sty ribuf+1
	stx ribuf
opn060	lda robuf+1     ;out allocation...
	bne memtcf      ;alreay
	dey             ;there goes 256 bytes
	sty robuf+1
	stx robuf
memtcf	sec             ;signal top of memory change
	lda #$f0
	jmp settop      ;top changed
;
; cln232 - clean up 232 system for open/close
;  set up ddrb and cb2 for rs-232
;
cln232	lda #$7f        ;clear nmi's
	sta d2icr
	lda #%00000110  ;ddrb
	sta d2ddrb
	sta d2prb       ;dtr,rts high
	lda #$04        ;output high pa2
	ora d2pra
	sta d2pra
	ldy #00
	sty enabl       ;clear enabls
	rts
.end
; rsr  8/25/80 - add rs-232 code
; rsr  8/26/80 - top of memory handler
; rsr  8/29/80 - add filename to m51regs
; rsr  9/02/80 - fix ordering of rs-232 routines
; rsr 12/11/81 - modify for vic-40 i/o
; rsr  2/08/82 - clear status in openi
; rsr  5/12/82 - compact rs232 open/close code
; -------------------------------------------------------------
; ##### load #####
.pag 'load function'
;**********************************
;* load ram function              *
;*                                *
;* loads from cassette 1 or 2, or *
;* serial bus devices >=4 to 31   *
;* as determined by contents of   *
;* variable fa. verify flag in .a *
;*                                *
;* alt load if sa=0, normal sa=1  *
;* .x , .y load address if sa=0   *
;* .a=0 performs load,<> is verify*
;*                                *
;* high load return in x,y.       *
;*                                *
;**********************************
.ski 3
loadsp	stx memuss      ;.x has low alt start
	sty memuss+1
load	jmp (iload)     ;monitor load entry
;
nload	sta verck       ;store verify flag
	lda #0
	sta status
;
	lda fa          ;check device number
	bne ld20
;
ld10	jmp error9      ;bad device #-keyboard
;
ld20	cmp #3
	beq ld10        ;disallow screen load
	bcc ld100       ;handle tapes different
;
;load from cbm ieee device
;
	ldy fnlen       ;must have file name
	bne ld25        ;yes...ok
;
	jmp error8      ;missing file name
;
ld25	ldx sa          ;save sa in .x
	jsr luking      ;tell user looking
	lda #$60        ;special load command
	sta sa
	jsr openi       ;open the file
;
	lda fa
	jsr talk        ;establish the channel
	lda sa
	jsr tksa        ;tell it to load
;
	jsr acptr       ;get first byte
	sta eal
;
	lda status      ;test status for error
	lsr a
	lsr a
	bcs ld90        ;file not found...
	jsr acptr
	sta eah
;
	txa             ;find out old sa
	bne ld30        ;sa<>0 use disk address
	lda memuss      ;else load where user wants
	sta eal
	lda memuss+1
	sta eah
ld30	jsr loding      ;tell user loading
;
ld40	lda #$fd        ;mask off timeout
	and status
	sta status
;
	jsr stop        ;stop key?
	bne ld45        ;no...
;
	jmp break       ;stop key pressed
;
ld45	jsr acptr       ;get byte off ieee
	tax
	lda status      ;was there a timeout?
	lsr a
	lsr a
	bcs ld40        ;yes...try again
	txa
	ldy verck       ;performing verify?
	beq ld50        ;no...load
	ldy #0
	cmp (eal)y      ;verify it
	beq ld60        ;o.k....
	lda #sperr      ;no good...verify error
	jsr udst        ;update status
	.byt $2c        ;skip next store
;
ld50	sta (eal)y
ld60	inc eal         ;increment store addr
	bne ld64
	inc eah
ld64	bit status      ;eoi?
	bvc ld40        ;no...continue load
;
	jsr untlk       ;close channel
	jsr clsei       ;close the file
	bcc ld180       ;branch always
;
ld90	jmp error4      ;file not found
;
;load from tape
;
ld100	lsr a
	bcs ld102       ;if c-set then it's cassette
;
	jmp error9      ;bad device #
;
ld102	jsr zzz         ;set pointers at tape
	bcs ld104
	jmp error9      ;deallocated...
ld104	jsr cste1       ;tell user about buttons
	bcs ld190       ;stop key pressed?
	jsr luking      ;tell user searching
;
ld112	lda fnlen       ;is there a name?
	beq ld150       ;none...load anything
	jsr faf         ;find a file on tape
	bcc ld170       ;got it!
	beq ld190       ;stop key pressed
	bcs ld90        ;nope...end of tape
;
ld150	jsr fah         ;find any header
	beq ld190       ;stop key pressed
	bcs ld90        ;no header
;
ld170	lda status
	and #sperr      ;must got header right
	sec
	bne ld190       ;is bad
;
	cpx #blf        ;is it a movable program...
	beq ld178       ;yes
;
	cpx #plf        ;is it a program
	bne ld112       ;no...its something else
;
ld177	ldy #1          ;fixed load...
	lda (tape1)y    ;...the address in the...
	sta memuss      ;...buffer is the start address
	iny
	lda (tape1)y
	sta memuss+1
	bcs ld179       ;jmp ..carry set by cpx's
;
ld178	lda sa          ;check for monitor load...
	bne ld177       ;...yes we want fixed type
;
ld179	ldy #3          ;tapea - tapesta
;carry set by cpx's
	lda (tape1)y
	ldy #1
	sbc (tape1)y
	tax             ;low to .x
	ldy #4
	lda (tape1)y
	ldy #2
	sbc (tape1)y
	tay             ;high to .y
;
	clc             ;ea = sta+(tapea-tapesta)
	txa
	adc memuss      ;
	sta eal
	tya
	adc memuss+1
	sta eah
	lda memuss      ;set up starting address
	sta stal
	lda memuss+1
	sta stah
	jsr loding      ;tell user loading
	jsr trd         ;do tape block load
	.byt $24        ;carry from trd
;
ld180	clc             ;good exit
;
; set up end load address
;
	ldx eal
	ldy eah
;
ld190	rts
.ski 5
;subroutine to print to console:
;
;searching [for name]
;
luking	lda msgflg      ;supposed to print?
	bpl ld115       ;...no
	ldy #ms5-ms1    ;"searching"
	jsr msg
	lda fnlen
	beq ld115
	ldy #ms6-ms1    ;"for"
	jsr msg
.ski 3
;subroutine to output file name
;
outfn	ldy fnlen       ;is there a name?
	beq ld115       ;no...done
	ldy #0
ld110	lda (fnadr)y
	jsr bsout
	iny
	cpy fnlen
	bne ld110
;
ld115	rts
.ski 3
;subroutine to print:
;
;loading/verifing
;
loding	ldy #ms10-ms1   ;assume 'loading'
	lda verck       ;check flag
	beq ld410       ;are doing load
	ldy #ms21-ms1   ;are 'verifying'
ld410	jmp spmsg
.end
; -------------------------------------------------------------
; ##### save #####
.pag 'save function'
;***********************************
;* save                            *
;*                                 *
;* saves to cassette 1 or 2, or    *
;* ieee devices 4>=n>=31 as select-*
;* ed by variable fa.              *
;*                                 *
;*start of save is indirect at .a  *
;*end of save is .x,.y             *
;***********************************
.ski 3
savesp	stx eal
	sty eah
	tax             ;set up start
	lda $00,x
	sta stal
	lda $01,x
	sta stah
;
save	jmp (isave)
nsave	lda fa  ***monitor entry
	bne sv20
;
sv10	jmp error9      ;bad device #
;
sv20	cmp #3
	beq sv10
	bcc sv100
	lda #$61
	sta sa
	ldy fnlen
	bne sv25
;
	jmp error8      ;missing file name
;
sv25	jsr openi
	jsr saving
	lda fa
	jsr listn
	lda sa
	jsr secnd
	ldy #0
	jsr rd300
	lda sal
	jsr ciout
	lda sah
	jsr ciout
sv30	jsr cmpste      ;compare start to end
	bcs sv50        ;have reached end
	lda (sal)y
	jsr ciout
	jsr stop
	bne sv40
;
break	jsr clsei
	lda #0
	sec
	rts
;
sv40	jsr incsal      ;increment current addr.
	bne sv30
sv50	jsr unlsn
.ski 5
clsei	bit sa
	bmi clsei2
	lda fa
	jsr listn
	lda sa
	and #$ef
	ora #$e0
	jsr secnd
;
cunlsn	jsr unlsn       ;entry for openi
;
clsei2	clc
	rts
.ski 5
sv100	lsr a
	bcs sv102       ;if c-set then it's cassette
;
	jmp error9      ;bad device #
;
sv102	jsr zzz         ;get addr of tape
	bcc sv10        ;buffer is deallocated
	jsr cste2
	bcs sv115       ;stop key pressed
	jsr saving      ;tell user 'saving'
sv105	ldx #plf        ;decide type to save
	lda sa          ;1-plf 0-blf
	and #01
	bne sv106
	ldx #blf
sv106	txa
	jsr tapeh
	bcs sv115       ;stop key pressed
	jsr twrt
	bcs sv115       ;stop key pressed
	lda sa
	and #2          ;write end of tape?
	beq sv110       ;no...
;
	lda #eot
	jsr tapeh
	.byt $24        ;skip 1 byte
;
sv110	clc
sv115	rts
.ski 3
;subroutine to output:
;'saving <file name>'
;
saving	lda msgflg
	bpl sv115       ;no print
;
	ldy #ms11-ms1   ;'saving'
	jsr msg
	jmp outfn       ;<file name>
.end
; -------------------------------------------------------------
; ##### time #####
.pag 'time function'
;***********************************
;*                                 *
;* time                            *
;*                                 *
;*consists of three functions:     *
;* (1) udtim-- update time. usually*
;*     called every 60th second.   *
;* (2) settim-- set time. .y=msd,  *
;*     .x=next significant,.a=lsd  *
;* (3) rdtim-- read time. .y=msd,  *
;*     .x=next significant,.a=lsd  *
;*                                 *
;***********************************
.ski
;interrupts are coming from the 6526 timers
;
udtim	ldx #0          ;pre-load for later
;
;here we proceed with an increment
;of the time register.
;
ud20	inc time+2
	bne ud30
	inc time+1
	bne ud30
	inc time
;
;here we check for roll-over 23:59:59
;and reset the clock to zero if true
;
ud30	sec
	lda time+2
	sbc #$01
	lda time+1
	sbc #$1a
	lda time
	sbc #$4f
	bcc ud60
;
;time has rolled--zero register
;
	stx time
	stx time+1
	stx time+2
;
;set stop key flag here
;
ud60	lda rows        ;wait for it to settle
	cmp rows
	bne ud60        ;still bouncing
	tax             ;set flags...
	bmi ud80        ;no stop key...exit  stop key=$7f
	ldx #$ff-$42    ;check for a shift key (c64 keyboard)
	stx colm
ud70	ldx rows        ;wait to settle...
	cpx rows
	bne ud70
	sta colm        ;!!!!!watch out...stop key .a=$7f...same as colms was...
	inx             ;any key down aborts
	bne ud90        ;leave same as before...
ud80	sta stkey       ;save for other routines
ud90	rts
.ski 5
rdtim	sei             ;keep time from rolling
	lda time+2      ;get lsd
	ldx time+1      ;get next most sig.
	ldy time        ;get msd
.ski 5
settim	sei             ;keep time from changing
	sta time+2      ;store lsd
	stx time+1      ;next most significant
	sty time        ;store msd
	cli
	rts
.end
; rsr 8/21/80 remove crfac change stop
; rsr 3/29/82 add shit key check for commodore 64
; -------------------------------------------------------------
; ##### errorhandler #####
.pag 'error handler'
;***************************************
;* stop -- check stop key flag and     *
;* return z flag set if flag true.     *
;* also closes active channels and     *
;* flushes keyboard queue.             *
;* also returns key downs from last    *
;* keyboard row in .a.                 *
;***************************************
nstop	lda stkey       ;value of last row
	cmp #$7f        ;check stop key position
	bne stop2       ;not down
	php
	jsr clrch       ;clear channels
	sta ndx         ;flush queue
	plp
stop2	rts
.ski 5
;************************************
;*                                  *
;* error handler                    *
;*                                  *
;* prints kernal error message if   *
;* bit 6 of msgflg set.  returns    *
;* with error # in .a and carry.    *
;*                                  *
;************************************
;
error1	lda #1          ;too many files
	.byt $2c
error2	lda #2          ;file open
	.byt $2c
error3	lda #3          ;file not open
	.byt $2c
error4	lda #4          ;file not found
	.byt $2c
error5	lda #5          ;device not present
	.byt $2c
error6	lda #6          ;not input file
	.byt $2c
error7	lda #7          ;not output file
	.byt $2c
error8	lda #8          ;missing file name
	.byt $2c
error9	lda #9          ;bad device #
;
	pha             ;error number on stack
	jsr clrch       ;restore i/o channels
;
	ldy #ms1-ms1
	bit msgflg      ;are we printing error?
	bvc erexit      ;no...
;
	jsr msg         ;print "cbm i/o error #"
	pla
	pha
	ora #$30        ;make error # ascii
	jsr bsout       ;print it
;
erexit	pla
	sec
	rts
.end
; -------------------------------------------------------------
; ##### tapefile #####
.pag 'tape files'
;fah -- find any header
;
;reads tape device until one of following
;block types found: bdfh--basic data
;file header, blf--basic load file
;for success carry is clear on return.
;for failure carry is set on return.
;in addition accumulator is 0 if stop
;key was pressed.
;
fah	lda verck       ;save old verify
	pha
	jsr rblk        ;read tape block
	pla
	sta verck       ;restore verify flag
	bcs fah40       ;read terminated
;
	ldy #0
	lda (tape1)y    ;get header type
;
	cmp #eot        ;check end of tape?
	beq fah40       ;yes...failure
;
	cmp #blf        ;basic load file?
	beq fah50       ;yes...success
;
	cmp #plf        ;fixed load file?
	beq fah50       ;yes...success
;
	cmp #bdfh       ;basic data file?
	bne fah         ;no...keep trying
;
fah50	tax             ;return file type in .x
	bit msgflg      ;printing messages?
	bpl fah45       ;no...
;
	ldy #ms17-ms1   ;print "found"
	jsr msg
;
;output complete file name
;
	ldy #5
fah55	lda (tape1)y
	jsr bsout
	iny
	cpy #21
	bne fah55
;
fah56	lda time+1      ;set up for time out...
	jsr fpatch      ;goto patch...
	nop
;
fah45	clc             ;success flag
	dey             ;make nonzero for okay return
;
fah40	rts
.ski 5
;tapeh--write tape header
;error if tape buffer de-allocated
;carry clear if o.k.
;
tapeh	sta t1
;
;determine address of buffer
;
	jsr zzz
	bcc th40        ;buffer was de-allocated
;
;preserve start and end addresses
;for case of header for load file
;
	lda stah
	pha
	lda stal
	pha
	lda eah
	pha
	lda eal
	pha
;
;put blanks in tape buffer
;
	ldy #bufsz-1
	lda #' 
blnk2	sta (tape1)y
	dey
	bne blnk2
;
;put block type in header
;
	lda t1
	sta (tape1)y
;
;put start load address in header
;
	iny
	lda stal
	sta (tape1)y
	iny
	lda stah
	sta (tape1)y
;
;put end load address in header
;
	iny
	lda eal
	sta (tape1)y
	iny
	lda eah
	sta (tape1)y
;
;put file name in header
;
	iny
	sty t2
	ldy #0
	sty t1
th20	ldy t1
	cpy fnlen
	beq th30
	lda (fnadr)y
	ldy t2
	sta (tape1)y
	inc t1
	inc t2
	bne th20
;
;set up start and end address of header
;
th30	jsr ldad1
;
;set up time for leader
;
	lda #$69
	sta shcnh
;
	jsr twrt2       ;write header on tape
;
;restore start and end address of
;load file.
;
	tay             ;save error code in .y
	pla
	sta eal
	pla 
	sta eah
	pla
	sta stal
	pla
	sta stah
	tya             ;restore error code for return
;
th40	rts
.ski 5
;function to return tape buffer
;address in tape1
;
zzz	ldx tape1       ;assume tape1
	ldy tape1+1
	cpy #>buf       ;check for allocation...
;...[tape1+1]=0 or 1 means deallocated
;...c clr => deallocated
	rts
.ski 5
ldad1	jsr zzz         ;get ptr to cassette
	txa
	sta stal        ;save start low
	clc
	adc #bufsz      ;compute pointer to end
	sta eal         ;save end low
	tya
	sta stah        ;save start high
	adc #0          ;compute pointer to end
	sta eah         ;save end high
	rts
.ski 5
faf	jsr fah         ;find any header
	bcs faf40       ;failed
;
;success...see if right name
;
	ldy #5          ;offset into tape header
	sty t2
	ldy #0          ;offset into file name
	sty t1
faf20	cpy fnlen       ;compare this many
	beq faf30       ;done
;
	lda (fnadr)y
	ldy t2
	cmp (tape1)y
	bne faf         ;mismatch--try next header
	inc t1
	inc t2
	ldy t1
	bne faf20       ;branch always
;
faf30	clc             ;success flag
faf40	rts
.end
; rsr  4/10/82 add key down test in fah...
; -------------------------------------------------------------
; ##### tapecontrol #####
.pag 'tape control'
jtp20	jsr zzz
	inc bufpt
	ldy bufpt
	cpy #bufsz
	rts
.ski 5
;stays in routine d2t1ll play switch
;
cste1	jsr cs10
	beq cs25
	ldy #ms7-ms1    ;"press play..."
cs30	jsr msg
cs40	jsr tstop       ;watch for stop key
	jsr cs10        ;watch cassette switches
	bne cs40
	ldy #ms18-ms1   ;"ok"
	jmp msg
.ski 5
;subr returns <> for cassette switch
;
cs10	lda #$10        ;check port
	bit r6510       ;closed?...
	bne cs25        ;no. . .
	bit r6510       ;check again to debounce
cs25	clc             ;good return
	rts
.ski 5
;checks for play & record
;
cste2	jsr cs10
	beq cs25
	ldy #ms8-ms1    ;"record"
	bne cs30
.ski 5
;read header block entry
;
rblk	lda #0
	sta status
	sta verck
	jsr ldad1
.ski 3
;read load block entry
;
trd	jsr cste1       ;say 'press play'
	bcs twrt3       ;stop key pressed
	sei
	lda #0          ;clear flags...
	sta rdflg
	sta snsw1
	sta cmp0
	sta ptr1
	sta ptr2
	sta dpsw
	lda #$90        ;enable for ca1 irq...read line
	ldx #14         ;point irq vector to read
	bne tape        ;jmp
.ski 5
;write header block entry
;
wblk	jsr ldad1
;
;write load block entry
;
twrt	lda #20         ;between block shorts
	sta shcnh
twrt2	jsr cste2       ;say 'press play & record'
twrt3	bcs stop3       ;stop key pressed
	sei
	lda #$82        ;enable t2 irqs...write time
	ldx #8          ;vector irq to wrtz
.ski 5
;start tape operation entry point
;
tape	ldy #$7f        ;kill unwanted irq's
	sty d1icr
	sta d1icr       ;turn on wanted
	lda d1cra       ;calc timer enables
	ora #$19
	sta d1crb       ;turn on t2 irq's for cass write(one shot)
	and #$91        ;save tod 50/60 indication
	sta caston      ;place in auto mode for t1
; wait for rs-232 to finish
	jsr rsp232
; disable screen display
	lda vicreg+17
	and #$ff-$10    ;disable screen
	sta vicreg+17
; move irq to irqtemp for cass ops
	lda cinv
	sta irqtmp
	lda cinv+1
	sta irqtmp+1
	jsr bsiv        ;go change irq vector
	lda #2          ;fsblk starts at 2
	sta fsblk
	jsr newch       ;prep local counters and flags
	lda r6510       ;turn motor on
	and #%011111    ;low turns on
	sta r6510
	sta cas1        ;flag internal control of cass motor
	ldx #$ff        ;delay between blocks
tp32	ldy #$ff
tp35	dey
	bne tp35
	dex
	bne tp32
	cli
tp40	lda irqtmp+1    ;check for interrupt vector...
	cmp cinv+1      ;...pointing at key routine
	clc
	beq stop3       ;...yes return
	jsr tstop       ;...no check for stop key
;
; 60 hz keyscan ignored
;
	jsr ud60        ; stop key check
	jmp tp40        ;stay in loop untill tapes are done
.ski 5
tstop	jsr stop        ;stop key down?
	clc             ;assume no stop
	bne stop4       ;we were right
;
;stop key down...
;
	jsr tnif        ;turn off cassettes
	sec             ;failure flag
	pla             ;back one square...
	pla
;
; lda #0 ;stop key flag
;
stop3	lda #0          ;deallocate irqtmp
	sta irqtmp+1    ;if c-set then stop key
stop4	rts
.ski 5
;
; stt1 - set up timeout watch for next dipole
;
stt1	stx temp        ;.x has constant for timeout
	lda cmp0        ;cmp0*5
	asl a
	asl a
	clc
	adc cmp0
	clc 
	adc temp        ;adjust long byte count
	sta temp
	lda #0
	bit cmp0        ;check cmp0 ...
	bmi stt2        ;...minus, no adjust
	rol a           ;...plus so adjust pos
stt2	asl temp        ;multiply corrected value by 4
	rol a
	asl temp
	rol a
	tax
stt3	lda d1t2l       ;watch out for d1t2h rollover...
	cmp #22         ;...time for routine...!!!...
	bcc stt3        ;...too close so wait untill past
	adc temp        ;calculate and...
	sta d1t1l       ;...store adusted time count
	txa
	adc d1t2h       ;adjust for high time count
	sta d1t1h
	lda caston      ;enable timers
	sta d1cra
	sta stupid      ;non-zero means an t1 irq has not occured yet
	lda d1icr       ;clear old t1 interrupt
	and #$10        ;check for old-flag irq
	beq stt4        ;no...normal exit
	lda #>stt4      ;push simulated return address on stack
	pha
	lda #<stt4
	pha
	jmp simirq
stt4	cli             ;allow for re-entry code
	rts
.end
; rsr 8/25/80 modify i/o for mod2 hardware
; rsr 12/11/81 modify i/o for vic-40
; rsr 2/9/82 add screen disable for tape
; rsr 3/28/82 add t2irq to start cassette write
; rsr 3/28/82 add cassette read timer1 flag
; rsr 5/11/82 change so we don't miss any irq's
; rsr 5/14/82 simulate an irq
; -------------------------------------------------------------
; ##### read #####
.page 'cassette read'
; variables used in cassette read routines
;
;  rez - counts zeros (if z then correct # of dipoles)
;  rer - flags errors (if z then no error)
;  diff - used to preserve syno (outside of bit routines)
;  syno - flags if we have block sync (16 zero dipoles)
;  snsw1 - flags if we have byte sync (a longlong)
;  data - holds most recent dipole bit value
;  mych - holds input byte being built
;  firt - used to indicate which half of dipole we're in
;  svxt - temp used to adjust software servo
;  temp - used to hold dipole time during type calculations
;  prty - holds current calculated parity bit
;  prp - has combined error values from bit routines
;  fsblk - indicate which block we're looking at (0 to exit)
;  shcnl - holds fsblk, used to direct routines, because of exit case
;  rdflg - holds function mode
;     mi - waiting for block sync
;     vs - in data block reading data
;     ne - waiting for byte sync
;  sal - indirect to data storage area
;  shcnh - left over from debugging
;  bad - storage space for bad read locations (bottom of stack)
;  ptr1 - count of read locations in error (pointer into bad, max 61)
;  ptr2 - count of re-read locations (pointer into bad, during re-read)
;  verchk - verify or load flag (z - loading)
;  cmp0 - software servo (+/- adjust to time calcs)
;  dpsw - if nz then expecting ll/l combination that ends a byte
;  pcntr - counts down from 8-0 for data then to ff for parity
;  stupid - hold indicator (nz - no t1irq yet) for t1irq
;  kika26 - holds old d1icr after clear on read
;
.pag 'cassette read'
read	ldx d1t2h       ;get time since last interrupt
	ldy #$ff        ;compute counter difference
	tya
	sbc d1t2l
	cpx d1t2h       ;check for timer high rollover...
	bne read        ;...yes then recompute
	stx temp
	tax
	sty d1t2l       ;reload timer2 (count down from $ffff)
	sty d1t2h
	lda #$19        ;enable timer
	sta d1crb
	lda d1icr       ;clear read interrupt
	sta kika26      ;save for latter
	tya
	sbc temp        ;calculate high
	stx temp
	lsr a           ;move two bits from high to temp
	ror temp
	lsr a
	ror temp
	lda cmp0        ;calc min pulse value
	clc
	adc #60
	cmp temp        ;if pulse less than min...
	bcs rdbk        ;...then ignore as noise
	ldx dpsw        ;check if last bit...
	beq rjdj        ;...no then continue
	jmp radj        ;...yes then go finish byte
.ski 2
rjdj	ldx pcntr       ;if 9 bits read...
	bmi jrad2       ;... then goto ending
	ldx #0          ;set bit value to zero
	adc #48         ;add up to half way between...
	adc cmp0        ;...short pulse and sync pulse
	cmp temp        ;check for short...
	bcs radx2       ;...yes it's a short
	inx             ;set bit value to one
	adc #38         ;move to middle of high
	adc cmp0
	cmp temp        ;check for one...
	bcs radl        ;...yes it's a one
	adc #44         ;move to longlong
	adc cmp0
	cmp temp        ;check for longlong...
	bcc srer        ;...greater than is error
jrad2	jmp rad2        ;...it's a longlong
.ski 2
srer	lda snsw1       ;if not syncronized...
	beq rdbk        ;...then no error
	sta rer         ;...else flag rer
	bne rdbk        ;jmp
.ski 2
radx2	inc rez         ;count rez up on zeros
	bcs rad5        ;jmp
radl	dec rez         ;count rez down on ones
rad5	sec             ;calc actual value for compare store
	sbc #19
	sbc temp        ;subtract input value from constant...
	adc svxt        ;...add difference to temp storage...
	sta svxt        ;...used later to adjust soft servo
	lda firt        ;flip dipole flag
	eor #1
	sta firt
	beq rad3        ;second half of dipole
	stx data        ;first half so store its value
.ski 3
rdbk	lda snsw1       ;if no byte start...
	beq radbk       ;...then return
	lda kika26      ;check to see if timer1 irqd us...
	and #$01
	bne radkx       ;...yes
	lda stupid      ;check for old t1irq
	bne radbk       ;no...so exit
;
radkx	lda #0          ;...yes, set dipole flag for first half
	sta firt
	sta stupid      ;set t1irq flag
	lda pcntr       ;check where we are in byte...
	bpl rad4        ;...doing data
	bmi jrad2       ;...process parity
.ski 2
radp	ldx #166        ;set up for longlong timeout
	jsr stt1
	lda prty        ;if parity not even...
	bne srer        ;...then go set error
radbk	jmp prend       ;go restore regs and rti
.ski 3
rad3	lda svxt        ;adjust the software servo (cmp0)
	beq rout1       ;no adjust
	bmi rout2       ;adjust for more base time
	dec cmp0        ;adjust for less base time
	.byt $2c        ;skip two bytes
rout2	inc cmp0
rout1	lda #0          ;clear difference value
	sta svxt
;check for consecutive like values in dipole...
	cpx data
	bne rad4        ;...no, go process info
	txa             ;...yes so check the values...
	bne srer        ;if they were ones then  error
; consecutive zeros
	lda rez         ;...check how many zeros have happened
	bmi rdbk        ;...if many don't check
	cmp #16         ;... do we have 16 yet?...
	bcc rdbk        ;....no so continue
	sta syno        ;....yes so flag syno (between blocks)
	bcs rdbk        ;jmp
.ski 3
rad4	txa             ;move read data to .a
	eor prty        ;calculate parity
	sta prty
	lda snsw1       ;real data?...
	beq radbk       ;...no so forget by exiting
	dec pcntr       ;dec bit count
	bmi radp        ;if minus then  time for parity
	lsr data        ;shift bit from data...
	ror mych        ;...into byte storage (mych) buffer
	ldx #218        ;set up for next dipole
	jsr stt1
	jmp prend       ;restore regs and rti
.ski 3
; rad2 - longlong handler (could be a long one)
rad2	lda syno        ;have we gotten block sync...
	beq rad2y       ;...no
	lda snsw1       ;check if we've had a real byte start...
	beq rad2x       ;...no
rad2y	lda pcntr       ;are we at end of byte...
	bmi rad2x       ;yes...go adjust for longlong
	jmp radl        ;...no so treat it as a long one read
.ski 2
rad2x	lsr temp        ;adjust timeout for...
	lda #147        ;...longlong pulse value
	sec
	sbc temp
	adc cmp0
	asl a
	tax             ;and set timeout for last bit
	jsr stt1
	inc dpsw        ;set bit throw away flag
	lda snsw1       ;if byte syncronized....
	bne radq2       ;...then skip to pass char
	lda syno        ;throws out data untill block sync...
	beq rdbk2       ;...no block sync
	sta rer         ;flag data as error
	lda #0          ;kill 16 sync flag
	sta syno
	lda #$81        ;set up for timer1 interrupts
	sta d1icr
	sta snsw1       ;flag that we have byte syncronized
;
radq2	lda syno        ;save syno status
	sta diff
	beq radk        ;no block sync, no byte looking
	lda #0          ;turn off byte sync switch
	sta snsw1
	lda #$01        ;disable timer1 interrupts
	sta d1icr
radk	lda mych        ;pass character to byte routine
	sta ochar
	lda rer         ;combine error values with zero count...
	ora rez
	sta prp         ;...and save in prp
rdbk2	jmp prend       ;go back and get last byte
.ski 2
radj	jsr newch       ;finish byte, clr flags
	sta dpsw        ;clear bit throw away flag
	ldx #218        ;initilize for next dipole
	jsr stt1
	lda fsblk       ;check for last value
	beq rd15
	sta shcnl
.pag 'byte handler'
;*************************************************
;* byte handler of cassette read                 *
;*                                               *
;* this portion of in line code is passed the    *
;* byte assembled from reading tape in ochar.    *
;* rer is set if the byte read is in error.      *
;* rez is set if the interrupt program is reading*
;* zeros.  rdflg tells us what we are doing.     *
;* bit 7 says to ignore bytes until rez is set   *
;* bit 6 says to load the byte. otherwise rdflg  *
;* is a countdown after sync.  if verck is set   *
;* we do a compare instead of a store and set    *
;* status.  fsblk counts the two blocks. ptr1 is *
;* index to error table for pass1.  ptr2 is index*
;* to correction table for pass2.                *
;*************************************************
;
sperr=16
ckerr=32
sberr=4
lberr=8
;
rd15	lda #$f
;
	bit rdflg       ;test function mode
	bpl rd20        ;not waiting for zeros
;
	lda diff        ;zeros yet?
	bne rd12        ;yes...wait for sync
	ldx fsblk       ;is pass over?
	dex             ;...if fsblk zero then no error (first good)
	bne rd10        ;no...
;
	lda #lberr
	jsr udst        ;yes...long block error
	bne rd10        ;branch always
;
rd12	lda #0
	sta rdflg       ;new mode is wait for sync
rd10	jmp prend       ;exit...done
;
rd20	bvs rd60        ;we are loading
	bne rd200       ;we are syncing
;
	lda diff        ;do we have block sync...
	bne rd10        ;...yes, exit
	lda prp         ;if first byte has error...
	bne rd10        ;...then skip (exit)
	lda shcnl       ;move fsblk to carry...
	lsr a
	lda ochar       ; should be a header count char
	bmi rd22        ;if neg then firstblock data
	bcc rd40        ;...expecting firstblock data...yes
	clc
rd22	bcs rd40        ;expecting second block?...yes
	and #$f         ;mask off high store header count...
	sta rdflg       ;...in mode flag (have correct block)
rd200	dec rdflg       ;wait untill we get real data...
	bne rd10        ;...9876543210 real
	lda #$40        ;next up is real data...
	sta rdflg       ;...set data mode
	jsr rd300       ;go setup address pointers
	lda #0          ;debug code##################################################
	sta shcnh
	beq rd10        ;jmp to continue
.ski 2
rd40	lda #$80        ;we want to...
	sta rdflg       ;ignore bytes mode
	bne rd10        ;jmp
.ski 2
rd60	lda diff        ;check for end of block...
	beq rd70        ;...okay
;
	lda #sberr      ;short block error
	jsr udst
	lda #0          ;force rdflg for an end
	jmp rd161
.ski 2
rd70	jsr cmpste      ;check for end of storage area
	bcc *+5         ;not done yet
	jmp rd160
	ldx shcnl       ;check which pass...
	dex
	beq rd58        ;...second pass
	lda verck       ;check if load or verify...
	beq rd80        ;...loading
	ldy #0          ;...just verifying
	lda ochar
	cmp (sal)y      ;compare with data in pet
	beq rd80        ;...good so continue
	lda #1          ;...bad so flag...
	sta prp         ;...as an error
.ski 1
; store bad locations for second pass re-try
rd80	lda prp         ;chk for errors...
	beq rd59        ;...no errors
	ldx #61         ;max allowed is 30
	cpx ptr1        ;are we at max?...
	bcc rd55        ;...yes, flag as second pass error
	ldx ptr1        ;get index into bad...
	lda sah         ;...and store the bad location
	sta bad+1,x     ;...in bad table
	lda sal
	sta bad,x
	inx             ;advance pointer to next
	inx
	stx ptr1
	jmp rd59        ;go store character
.ski 2
; check bad table for re-try (second pass)
rd58	ldx ptr2        ;have we done all in the table?...
	cpx ptr1
	beq rd90        ;...yes
	lda sal         ;see if this is next in the table...
	cmp bad,x
	bne rd90        ;...no
	lda sah
	cmp bad+1,x
	bne rd90        ;...no
	inc ptr2        ;we found next one, so advance pointer
	inc ptr2
	lda verck       ;doing a load or verify?...
	beq rd52        ;...loading
	lda ochar       ;...verifying, so check
	ldy #0
	cmp (sal)y
	beq rd90        ;...okay
	iny             ;make .y= 1
	sty prp         ;flag it as an error
.ski 2
rd52	lda prp         ;a second pass error?...
	beq rd59        ;...no
;second pass err
rd55	lda #sperr
	jsr udst
	bne rd90        ;jmp
.ski 2
rd59	lda verck       ;load or verify?...
	bne rd90        ;...verify, don't store
	tay             ;make y zero
	lda ochar
	sta (sal)y      ;store character
rd90	jsr incsal      ;increment addr.
	bne rd180       ;branch always
.ski 3
rd160	lda #$80        ;set mode skip next data
rd161	sta rdflg
;
; modify for c64 6526's
;
	sei             ;protect clearing of t1 information
	ldx #$01
	stx d1icr       ;clear t1 enable...
	ldx d1icr       ;clear the interrupt
	ldx fsblk       ;dec fsblk for next pass...
	dex
	bmi rd167       ;we are done...fsblk=0
	stx fsblk       ;...else fsblk=next
rd167	dec shcnl       ;dec pass calc...
	beq rd175       ;...all done
	lda ptr1        ;check for first pass errors...
	bne rd180       ;...yes so continue
	sta fsblk       ;clear fsblk if no errors...
	beq rd180       ;jmp to exit
.ski 2
rd175	jsr tnif        ;read it all...exit
	jsr rd300       ;restore sal & sah
	ldy #0          ;set shcnh to zero...
	sty shcnh       ;...used to calc parity byte
;
;compute parity over load
;
vprty	lda (sal)y      ;calc block bcc
	eor shcnh
	sta shcnh
	jsr incsal      ;increment address
	jsr cmpste      ;test against end
	bcc vprty       ;not done yet...
	lda shcnh       ;check for bcc char match...
	eor ochar
	beq rd180       ;...yes, exit
;chksum error
	lda #ckerr
	jsr udst
rd180	jmp prend
.ski 4
rd300	lda stah        ; restore starting address...
	sta sah         ;...pointers (sah & sal)
	lda stal
	sta sal
	rts
.ski 4
newch	lda #8          ;set up for 8 bits+parity
	sta pcntr
	lda #0          ;initilize...
	sta firt        ;..dipole counter
	sta rer         ;..error flag
	sta prty        ;..parity bit
	sta rez         ;..zero count
	rts             ;.a=0 on return
.end
; rsr 7/31/80 add comments
; rsr 3/28/82 modify for c64 (add stupid/comments)
; rsr 3/29/82 put block t1irq control
; rsr 5/11/82 modify c64 stupid code
; -------------------------------------------------------------
; ##### write #####
.pag 'tape write'
; cassette info - fsblk is block counter for record
;       fsblk = 2 -first header
;             = 1 -first data
;             = 0 -second data
;
; write - toggle write bit according to lsb in ochar
;
write	lda ochar       ;shift bit to write into carry
	lsr a
	lda #96         ;...c clr write short
	bcc wrt1
wrtw	lda #176        ;...c set write long
wrt1	ldx #0          ;set and store time
wrtx	sta d1t2l
	stx d1t2h
	lda d1icr       ;clear irq
	lda #$19        ;enable timer (one-shot)
	sta d1crb
	lda r6510       ;toggle write bit
	eor #$08
	sta r6510
	and #$08        ;leave only write bit
	rts
;
wrtl3	sec             ;flag prp for end of block
	ror prp
	bmi wrt3        ; jmp
;
; wrtn - called at the end of each byte
;   to write a long rer    rez
;              hhhhhhllllllhhhlll...
;
wrtn	lda rer         ;check for one long
	bne wrtn1
	lda #16         ;write a long bit
	ldx #1
	jsr wrtx
	bne wrt3
	inc rer
	lda prp         ;if end of block(bit set by wrtl3)...
	bpl wrt3        ;...no end continue
	jmp wrnc        ;...end ...finish off
;
wrtn1	lda rez         ;check for a one bit
	bne wrtn2
	jsr wrtw
	bne wrt3
	inc rez
	bne wrt3
;
wrtn2	jsr write
	bne wrt3        ;on bit low exit
	lda firt        ;check for first of dipole
	eor #1
	sta firt
	beq wrt2        ;dipole done
	lda ochar       ;flips bit for complementary right
	eor #1
	sta ochar
	and #1          ;toggle parity
	eor prty
	sta prty
wrt3	jmp prend       ;restore regs and rti exit
;
wrt2	lsr ochar       ;move to next bit
	dec pcntr       ;dec counter for # of bits
	lda pcntr       ;check for 8 bits sent...
	beq wrt4        ;...if yes move in parity
	bpl wrt3        ;...else send rest
;
wrts	jsr newch       ;clean up counters
	cli             ;allow for interrupts to nest
	lda cntdn       ;are we writing header counters?...
	beq wrt6        ;...no
; write header counters (9876543210 to help with read)
	ldx #0          ;clear bcc
	stx data
wrts1	dec cntdn
	ldx fsblk       ;check for first block header
	cpx #2
	bne wrt61       ;...no
	ora #$80        ;...yes mark first block header
wrt61	sta ochar       ;write characters in header
	bne wrt3
;
wrt6	jsr cmpste      ;compare start:end
	bcc wrt7        ;not done
	bne wrtl3       ;go mark end
	inc sah
	lda data        ;write out bcc
	sta ochar
	bcs wrt3        ;jmp
;
wrt7	ldy #0          ;get next character
	lda (sal)y
	sta ochar       ;store in output character
	eor data        ;update bcc
	sta data
	jsr incsal      ;increment fetch address
	bne wrt3        ;branch always
;
wrt4	lda prty        ;move parity into ochar...
	eor #1
	sta ochar       ;...to be written as next bit
wrtbk	jmp prend       ;restore regs and rti exit
;
wrnc	dec fsblk       ;check for end
	bne wrend       ;...block only
	jsr tnof        ;...write, so turn off motor
wrend	lda #80         ;put 80 cassette syncs at end
	sta shcnl
	ldx #8
	sei
	jsr bsiv        ;set vector to write zeros
	bne wrtbk       ;jmp
;
wrtz	lda #120        ;write leading zeros for sync
	jsr wrt1
	bne wrtbk
	dec shcnl       ;check if done with low sync...
	bne wrtbk       ;...no
	jsr newch       ;...yes clear up counters
	dec shcnh       ;check if done with sync...
	bpl wrtbk       ;...no
	ldx #10         ;...yes so set vector for data
	jsr bsiv
	cli
	inc shcnh       ;zero shcnh
	lda fsblk       ;if done then...
	beq stky        ;...goto system restore
	jsr rd300
	ldx #9          ;set up for header count
	stx cntdn
	stx prp         ;clear endof block flag
	bne wrts        ;jmp
;
tnif	php             ;clean up interrupts and restore pia's
	sei
	lda vicreg+17   ;unlock vic
	ora #$10        ;enable display
	sta vicreg+17
	jsr tnof        ;turn off motor
	lda #$7f        ;clear interrupts
	sta d1icr
	jsr iokeys      ;restore keyboard irq from timmer1
	lda irqtmp+1    ;restore keyboard interrupt vector
	beq tniq        ;no irq (irq vector cannot be z-page)
	sta cinv+1
	lda irqtmp
	sta cinv
tniq	plp
	rts
;
stky	jsr tnif        ;go restore system interrupts
	beq wrtbk       ;came for cassette irq so rti
;
; bsiv - subroutine to change irq vectors
;  entrys - .x = 8 write zeros to tape
;           .x = 10 write data to tape
;           .x = 12 restore to keyscan
;           .x = 14 read data from tape
;
bsiv	lda bsit-8,x    ;move irq vectors, table to indirect
	sta cinv
	lda bsit+1-8,x
	sta cinv+1
	rts
;
tnof	lda r6510       ;turn off cassette motor
	ora #$20        ;
	sta r6510
	rts
.ski 3
;compare start and end load/save
;addresses.  subroutine called by
;tape read, save, tape write
;
cmpste	sec
	lda sal
	sbc eal
	lda sah
	sbc eah
	rts
.ski 3
;increment address pointer sal
;
incsal	inc sal
	bne incr
	inc sah
incr	rts
.end
; rsr 7/28/80 add comments
; rsr 8/4/80 changed i/o for vixen
; rsr 8/21/80 changed i/o for vixen mod
; rsr 8/25/80 changed i/o for vixen mod2
; rsr 12/11/81 modify i/o for vic-40
; rsr 2/9/82 add vic turn on, replace sah with prp
; -------------------------------------------------------------
; ##### init #####
.page 'initialization'
; start - system reset
; will goto rom at $8000...
; if locs $8004-$8008
; = 'cbm80'
;    ^^^  > these have msb set
; kernal expects...
; $8000- .word initilize (hard start)
; $8002- .word panic (warm start)
; ... else basic system used
; ******************testing only***************
; use auto disk/cassette load when developed...
;
start	ldx #$ff
	sei
	txs
	cld
	jsr a0int       ;test for $a0 rom in
	bne start1
	jmp ($8000)     ; go init as $a000 rom wants
start1	stx vicreg+22   ;set up refresh (.x=<5)
	jsr ioinit      ;go initilize i/o devices
	jsr ramtas      ;go ram test and set
	jsr restor      ;go set up os vectors
;
	jsr pcint       ;go initilize screen newxxx
	cli             ;interrupts okay now
	jmp ($a000)     ;go to basic system
.ski 4
; a0int - test for an $8000 rom
;  returns z - $8000 in
;
a0int	ldx #tbla0e-tbla0r ;check for $8000
a0in1	lda tbla0r-1,x
	cmp $8004-1,x
	bne a0in2
	dex
	bne a0in1
a0in2	rts
;
tbla0r	.byt $c3,$c2,$cd,'80' ;..cbm80..
tbla0e
.ski 4
; restor - set kernal indirects and vectors (system)
;
restor	ldx #<vectss
	ldy #>vectss
	clc
;
; vector - set kernal indirect and vectors (user)
;
vector	stx tmp2
	sty tmp2+1
	ldy #vectse-vectss-1
movos1	lda cinv,y      ;get from storage
	bcs movos2      ;c...want storage to user
	lda (tmp2)y     ;...want user to storage
movos2	sta (tmp2)y     ;put in user
	sta cinv,y      ;put in storage
	dey
	bpl movos1
	rts
;
vectss	.wor key,timb,nnmi
	.wor nopen,nclose,nchkin
	.wor nckout,nclrch,nbasin
	.wor nbsout,nstop,ngetin
	.wor nclall,timb ;goto break on a usrcmd jmp
	.wor nload,nsave
vectse
.page 'initilize code'
; ramtas - memory size check and set
;
ramtas	lda #0          ;zero low memory
	tay             ;start at 0002
ramtz0	sta $0002,y     ;zero page
	sta $0200,y     ;user buffers and vars
	sta $0300,y     ;system space and user space
	iny
	bne ramtz0
;
;allocate tape buffers
;
	ldx #<tbuffr
	ldy #>tbuffr
	stx tape1
	sty tape1+1
;
; set top of memory
;
ramtbt
	tay             ;move $00 to .y
	lda #3          ;set high inital index
	sta tmp0+1
;
ramtz1	inc tmp0+1      ;move index thru memory
ramtz2	lda (tmp0)y     ;get present data
	tax             ;save in .x
	lda #$55        ;do a $55,$aa test
	sta (tmp0)y
	cmp (tmp0)y
	bne size
	rol a
	sta (tmp0)y
	cmp (tmp0)y
	bne size
	txa             ;restore old data
	sta (tmp0)y
	iny
	bne ramtz2
	beq ramtz1
;
size	tya             ;set top of memory
	tax
	ldy tmp0+1
	clc
	jsr settop
	lda #$08        ;set bottom of memory
	sta memstr+1    ;always at $0800
	lda #$04        ;screen always at $400
	sta hibase      ;set base of screen
	rts
.ski 3
bsit	.wor wrtz,wrtn,key,read ;table of indirects for cassette irq's
.pag 'initilize code'
; ioinit - initilize io devices
;
ioinit	lda #$7f        ;kill interrupts
	sta d1icr
	sta d2icr
	sta d1pra       ;turn on stop key
	lda #%00001000  ;shut off timers
	sta d1cra
	sta d2cra
	sta d1crb
	sta d2crb
; configure ports
	ldx #$00        ;set up keyboard inputs
	stx d1ddrb      ;keyboard inputs
	stx d2ddrb      ;user port (no rs-232)
	stx sidreg+24   ;turn off sid
	dex
	stx d1ddra      ;keyboard outputs
	lda #%00000111  ;set serial/va14/15 (clkhi)
	sta d2pra
	lda #%00111111  ;set serial in/out, va14/15out
	sta d2ddra
;
; set up the 6510 lines
;
	lda #%11100111  ;motor on, hiram lowram charen high
	sta r6510
	lda #%00101111  ;mtr out,sw in,wr out,control out
	sta d6510
;
;jsr clkhi ;clkhi to release serial devices  ^
;
iokeys	lda palnts      ;pal or ntsc
	beq i0010	;ntsc
	lda #<sixtyp
	sta d1t1l
	lda #>sixtyp
	jmp i0020
i0010	lda #<sixty     ;keyboard scan irq's
	sta d1t1l
	lda #>sixty
i0020	sta d1t1h
	jmp piokey
; lda #$81 ;enable t1 irq's
; sta d1icr
; lda d1cra
; and #$80 ;save only tod bit
; ora #%00010001 ;enable timer1
; sta d1cra
; jmp clklo ;release the clock line
;
; sixty hertz value
;
sixty	= 17045         ; ntsc
sixtyp	= 16421         ; pal
.page 'init - sys subs'
setnam	sta fnlen
	stx fnadr
	sty fnadr+1
	rts
.ski 5
setlfs	sta la
	stx fa
	sty sa
	rts
.ski 5
readss	lda fa          ;see which devices' to read
	cmp #2          ;is it rs-232?
	bne readst      ;no...read serial/cass
	lda rsstat      ;yes...get rs-232 up
	pha
	lda #00         ;clear rs232 status when read
	sta rsstat
	pla
	rts
setmsg	sta msgflg
readst	lda status
udst	ora status
	sta status
	rts
.ski 5
settmo	sta timout
	rts
.ski 5
memtop	bcc settop
;
;carry set--read top of memory
;
gettop	ldx memsiz
	ldy memsiz+1
;
;carry clear--set top of memory
;
settop	stx memsiz
	sty memsiz+1
	rts
.ski 5
;manage bottom of memory
;
membot	bcc setbot
;
;carry set--read bottom of memory
;
	ldx memstr
	ldy memstr+1
;
;carry clear--set bottom of memory
;
setbot	stx memstr
	sty memstr+1
	rts
.end
; rsr 8/5/80 change io structure
; rsr 8/15/80 add memory test
; rsr 8/21/80 change i/o for mod
; rsr 8/25/80 change i/o for mod2
; rsr 8/29/80 change ramtest for hardware mistake
; rsr 9/22/80 change so ram hang rs232 status read
; rsr 5/12/82 change start1 order to remove disk problem
; -------------------------------------------------------------
; ##### rs232nmi #####
.page 'nmi handler'
nmi	sei             ;no irq's allowed...
	jmp (nminv)     ;...could mess up cassettes
nnmi	pha
	txa
	pha
	tya
	pha
nnmi10	lda #$7f        ;disable all nmi's
	sta d2icr
	ldy d2icr       ;check if real nmi...
	bmi nnmi20      ;no...rs232/other
;
nnmi18	jsr a0int       ;check if $a0 in...no .y
	bne nnmi19      ;...no
	jmp ($8002)     ;...yes
;
; check for stop key down
;
nnmi19
	jsr ud60        ;no .y
	jsr stop        ;no .y
	bne nnmi20      ;no stop key...test for rs232
;
; timb - where system goes on a brk instruction
;
timb	jsr restor      ;restore system indirects
	jsr ioinit      ;restore i/o for basic
	jsr cint        ;restore screen for basic
	jmp ($a002)     ;...no, so basic warm start
.ski 2
; disable nmi's untill ready
;  save on stack
;
nnmi20	tya             ;.y saved through restore
	and enabl       ;show only enables
	tax             ;save in .x for latter
;
; t1 nmi check - transmitt a bit
;
	and #$01        ;check for t1
	beq nnmi30      ;no...
;
	lda d2pra
	and #$ff-$04    ;fix for current i/o
	ora nxtbit      ;load data and...
	sta d2pra       ;...send it
;
	lda enabl       ;restore nmi's
	sta d2icr       ;ready for next...
;
; because of 6526 icr structure...
;  handle another nmi as a subroutine
;
	txa             ;test for another nmi
	and #$12        ;test for t2 or flag
	beq nnmi25
	and #$02        ;check for t2
	beq nnmi22      ;must be a flag
;
	jsr t2nmi       ;handle a normal bit in...
	jmp nnmi25      ;...then continue output
;
nnmi22	jsr flnmi       ;handle a start bit...
;
nnmi25	jsr rstrab      ;go calc info (code could be in line)
	jmp nmirti
;
.ski 2
; t2 nmi check - recieve a bit
;
nnmi30	txa
	and #$02        ;mask to t2
	beq nnmi40      ;no...
;
	jsr t2nmi       ;handle interrupt
	jmp nmirti
.ski 2
; flag nmi handler - recieve a start bit
;
nnmi40	txa             ;check for edge
	and #$10        ;on flag...
	beq nmirti      ;no...
;
	jsr flnmi       ;start bit routine
.ski 2
nmirti	lda enabl       ;restore nmi's
	sta d2icr
prend	pla             ;because of missing screen editor
	tay
	pla
	tax
	pla
	rti
.ski 4
; baudo table contains values
;  for 14.31818e6/14/baud rate/2 (ntsc)
;
baudo	.wor 10277-cbit ; 50 baud
	.wor 6818-cbit  ;   75   baud
	.wor 4649-cbit  ;  110   baud
	.wor 3800-cbit  ;  134.6 baud
	.wor 3409-cbit  ;  150   baud
	.wor 1705-cbit  ;  300   baud
	.wor 852-cbit   ;  600   baud
	.wor 426-cbit   ; 1200   baud
	.wor 284-cbit   ; 1800   baud
	.wor 213-cbit   ; 2400   baud
;
; cbit - an adjustment to make next t2 hit near center
;   of the next bit.
;   aprox the time to service a cb1 nmi
cbit	=100            ;cycles
.pag 'nmi - subroutines'
; t2nmi - subroutine to handle an rs232
;  bit input.
;
t2nmi	lda d2prb       ;get data in
	and #01         ;mask off...
	sta inbit       ;...save for latter
;
; update t2 for mid bit check
;   (worst case <213 cycles to here)
;   (calc 125 cycles+43-66 dead)
;
	lda d2t2l       ;calc new time & clr nmi
	sbc #22+6
	adc baudof
	sta d2t2l
	lda d2t2h
	adc baudof+1
	sta d2t2h
;
	lda #$11        ;enable timer
	sta d2crb
;
	lda enabl       ;restore nmi's early...
	sta d2icr
;
	lda #$ff        ;enable count from $ffff
	sta d2t2l
	sta d2t2h
;
	jmp rsrcvr      ;go shift in...
.ski 3
; flnmi - subroutine to handle the
;  start bit timing..
;
; check for noise ?
;
flnmi
;
; get half bit rate value
;
	lda m51ajb
	sta d2t2l
	lda m51ajb+1
	sta d2t2h
;
	lda #$11        ;enable timer
	sta d2crb
;
	lda #$12        ;disable flag, enable t2
	eor enabl
	sta enabl
;ora #$82
;sta d2icr
;
	lda #$ff        ;preset for count down
	sta d2t2l
	sta d2t2h
;
	ldx bitnum      ;get #of bits in
	stx bitci       ;put in rcvrcnt
	rts
;
; popen - patches open rs232 for universal kernal
;
popen	tax             ;we're calculating baud rate
	lda m51ajb+1    ; m51ajb=freq/baud/2-100
	rol a
	tay
	txa
	adc #cbit+cbit
	sta baudof
	tya
	adc #0
	sta baudof+1
	rts
	nop
	nop
.end
; rsr  8/02/80 - routine for panic
; rsr  8/08/80 - panic & stop key
; rsr  8/12/80 - change for a0int a subroutine
; rsr  8/19/80 - add rs-232 checks
; rsr  8/21/80 - modify rs-232
; rsr  8/29/80 - change panic order for jack
; rsr  8/30/80 - add t2
; rsr  9/22/80 - add 1800 baud opps!
; rsr 12/08/81 - modify for vic-40 system
; rsr 12/11/81 - continue modifications (vic-40)
; rsr 12/14/81 - modify for 6526 timer adjust
; rsr  2/09/82 - fix enable for flag nmi
; rsr  2/16/82 - rewrite for 6526 problems
; rsr  3/11/82 - change nmi renable, fix restore
; rsr  3/29/82 - enables are always or'ed with $80
; -------------------------------------------------------------
; ##### irqfile #####
.page 'irqfile - dispatcher'
; simirq - simulate an irq (for cassette read)
;  enter by a jsr simirq
;
simirq	php
	pla             ;fix the break flag
	and #$ef
	pha
; puls - checks for real irq's or breaks
;
puls	pha
	txa
	pha
	tya
	pha
	tsx
	lda $104,x      ;get old p status
	and #$10        ;break flag?
	beq puls1       ;...no
	jmp (cbinv)     ;...yes...break instr
puls1	jmp (cinv)      ;...irq
.ski 5
.pag "irqfile-patches 6/82"
; pcint - add universal to cinit
;
pcint	jsr cint
p0010	lda vicreg+18   ;check raster compare for zero
	bne p0010       ;if it's zero then check value
	lda vicreg+25   ;get raster irq value
	and #$01
	sta palnts      ;place in pal/ntsc indicator
	jmp iokeys
;
; piokey - add universal to iokeys
;
piokey	lda #$81        ;enable t1 irq's
	sta d1icr
	lda d1cra
	and #$80        ;save only tod bit
	ora #%00010001  ;enable timer1
	sta d1cra
	jmp clklo       ;release the clock line***901227-03***
	*=$e500-20
;
; baudop - baud rate table for pal
;   .985248e6/baud-rate/2-100
;
baudop	.wor 9853-cbit ;50 baud
	.wor 6568-cbit ;75 baud
	.wor 4478-cbit ;110 baus
	.wor 3660-cbit ;134.6 baud
	.wor 3284-cbit ;150 baud
	.wor 1642-cbit ;300 baud
	.wor 821-cbit  ;600 baud
	.wor 411-cbit  ;1200 baud
	.wor 274-cbit  ;1800 baud
	.wor 205-cbit  ;2400 baud
.page "irqfile -  patches"
	*=$e500-32      ;(20-12)
; fpatch - tape filename timeout
;
fpatch	adc #2          ;time is (8 to 13 sec of display)
fpat00	ldy stkey       ;check for key down on last row...
	iny
	bne fpat01      ;key...exit loop
	cmp time+1      ;watch timer
	bne fpat00
fpat01	rts
.ski 5
	*=$e500-38      ;(32-6)
; cpatch - fix to clear line...modified 901227-03
;  prevents white character flash...
cpatch                  ;always clear to current foregnd color
	lda color
	sta (user)y
	rts
.ski 5
	*=$e500-45      ;(38-7)
; prtyp - rs232 parity patch...added 901227-03
;
prtyp	sta rinone      ;good receiver start...disable flag
	lda #1          ;set parity to 1 always
	sta riprty
	rts
.end
; -------------------------------------------------------------
; ##### vectors #####
.pag 'jump table/vectors'
	*=$ff8a-9
	jmp pcint
	jmp ioinit
	jmp ramtas
	*=$ff8a         ;new vectors for basic
	jmp restor      ;restore vectors to initial system
	jmp vector      ;change vectors for user
	* =$ff90
	jmp setmsg      ;control o.s. messages
	jmp secnd       ;send sa after listen
	jmp tksa        ;send sa after talk
	jmp memtop      ;set/read top of memory
	jmp membot      ;set/read bottom of memory
	jmp scnkey      ;scan keyboard
	jmp settmo      ;set timeout in ieee
	jmp acptr       ;handshake ieee byte in
	jmp ciout       ;handshake ieee byte out
	jmp untlk       ;send untalk out ieee
	jmp unlsn       ;send unlisten out ieee
	jmp listn       ;send listen out ieee
	jmp talk        ;send talk out ieee
	jmp readss      ;return i/o status byte
	jmp setlfs      ;set la, fa, sa
	jmp setnam      ;set length and fn adr
open	jmp (iopen)     ;open logical file
close	jmp (iclose)    ;close logical file
chkin	jmp (ichkin)    ;open channel in
ckout	jmp (ickout)    ;open channel out
clrch	jmp (iclrch)    ;close i/o channel
basin	jmp (ibasin)    ;input from channel
bsout	jmp (ibsout)    ;output to channel
	jmp loadsp      ;load from file
	jmp savesp      ;save to file
	jmp settim      ;set internal clock
	jmp rdtim       ;read internal clock
stop	jmp (istop)     ;scan stop key
getin	jmp (igetin)    ;get char from q
clall	jmp (iclall)    ;close all files
	jmp udtim       ;increment clock
jscrog	jmp scrorg      ;screen org
jplot	jmp plot        ;read/set x,y coord
jiobas	jmp iobase      ;return i/o base
.ski 5
.pag 'jump table/vectors'
	*=$fffa
	.wor nmi        ;program defineable
	.wor start      ;initialization code
	.wor puls       ;interrupt handler
.end
