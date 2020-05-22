system	= 0             ;cbm system =0  pet system =1
sysage	= 0             ;monitor = 0   cassette = 1
syssiz	= 0             ;no packing = 0  packing = 1
; -------------------------------------------------------------
; ##### disclaimer #####
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
;
;*****LISTING DATE --17:00 31 MAY  1983
;
;***************************************
;* CBM KERNAL                          *
;*   MEMORY AND I/O DEPENDENT ROUTINES *
;* DRIVING THE HARDWARE OF THE         *
;* FOLLOWING CBM MODELS:               *
;*   P-SERIES (5XX) & B-SERIES (7XX)   *
;* COPYRIGHT (C) 1983 BY               *
;* COMMODORE BUSINESS MACHINES (CBM)   *
;***************************************
.SKI 2
;***************************************
;* THIS SOFTWARE IS FURNISHED FOR USE  *
;* USE IN THE CBM P-SERIES AND B-SERIES*
;* COMPUTERS.                          *
;*                                     *
;* COPIES THEREOF MAY NOT BE PROVIDED  *
;* OR MADE AVAILABLE FOR USE ON ANY    *
;* OTHER SYSTEM.                       *
;*                                     *
;* THE INFORMATION IN THIS DOCUMENT IS *
;* SUBJECT TO CHANGE WITHOUT NOTICE.   *
;*                                     *
;* NO RESPONSIBILITY IS ASSUMED FOR    *
;* RELIABILITY OF THIS SOFTWARE.  RSR  *
;*                                     *
;***************************************
.end
; -------------------------------------------------------------
; ##### declare #####
.pag 'declare 03/11/83'
	* =$0000
;------------------------------------------------------
; 6509  used to extend memory on bc2 & p2 systems
;   location - used to direct
;   $0000 -  execution register (4 bits)
;   $0001 -  indirect  register (4 bits)
;
;   these registers provide 4 extra high-order address
;   control lines.  on 6509 reset all lines are high.
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
;               $d8ff-$d800  i/o  6566 vic/ 6845 80-col
;               $d7ff-$d400  color nybles/80-col screen
;               $d3ff-$d000  video matrix/80-col screen
;               $cfff-$c000  character dot rom (p2 only)
;               $bfff-$8000  roms external (language)
;               $7fff-$4000  roms external (extensions)
;               $3fff-$2000  rom  external
;               $1fff-$1000  rom  internal
;               $0fff-$0400  unused
;               $03ff-$0002  ram (kernal/basic system)
;   segment 14- segment 8 open (future expansion)
;   segment 7 - $ffff-$0002  ram expansion (external)
;   segment 6 - $ffff-$0002  ram expansion (external)
;   segment 5 - $ffff-$0002  ram expansion (external)
;   segment 4 - $ffff-$0002  ram b2 expansion (p2 external)
;   segment 3 - $ffff-$0002  ram expansion
;   segment 2 - $ffff-$0002  ram b2 standard (p2 optinal)
;   segment 1 - $ffff-$0002  ram b2 p2 standard
;   segment 0 - $ffff-$0002  ram p2 standard (b2 optional)
;
; the 6509 registers appear in locations $0000 and
; $0001 in all segments of memory.
;
;------------------------------------------------------
e6509	*=*+1           ;6509 execution   register
i6509	*=*+1           ;6509 indirection register
.ski 2
irom	=$f             ;indirect=rom or execution=rom
	.ife sysage <
.page 'declare - monitor'
;
;virtual registers
;
	*=$ae           ;place in these locations temporarly...
pch	*=*+1           ;program counter
pcl	*=*+1
;
flgs	*=*+1           ;processor status
;
acc	*=*+1           ;accumulator
;
xr	*=*+1           ;.x register
;
yr	*=*+1           ;.y register
;
sp	*=*+1           ;stack pointer
;
xi6509	*=*+1           ;old indirection segment
;
re6509	*=*+1           ;return execution segment
;
invh	*=*+1           ;user interrupt vector
invl	*=*+1
;
;monitor indirect variables
;
tmp0	*=*+2
tmp2	*=*+2
;
;other monitor variables
;
tmpc	*=*+1           ;place to save last cmd
t6509	*=*+1           ;temporary i6509
ddisk	*=*+1           ;default disk unit # for monitor
;
>
.pag 'declare - kernal'
	* =$90
;kernal page zero variables
;
;kernal indirect address variables
;
fnadr	*=*+3           ;address of file name string
sal	*=*+1           ;current load/store address
sah	*=*+1
sas	*=*+1
eal	*=*+1           ;end of load/save
eah	*=*+1
eas	*=*+1
stal	*=*+1           ;start of load/save
stah	*=*+1
stas	*=*+1
;
;frequently used kernal variables
;
status	*=*+1           ;i/o operation status
fnlen	*=*+1           ;file name length
la	*=*+1           ;current logical index
fa	*=*+1           ;current first address
sa	*=*+1           ;current second address
dfltn	*=*+1           ;default input device
dflto	*=*+1           ;default output device
;
;tape buffer pointer
;
tape1	*=*+3           ;address of tape buffer
;
;rs-232 buffer pointers
;
ribuf	*=*+3           ;input buffer
;
;variables for kernal speed
;
stkey	*=*+1           ;stop key flag
ctemp	;used to reduce cassette read times
c3po	*=*+1           ;ieee buffer flag
snsw1	;used to reduce cassette read times
bsour	*=*+1           ;ieee character buffer
;
;   cassette temps - overlays ipc buffer
;
ipoint	;next 2 bytes used for transx code
syno	*=*+1
dpsw	*=*+1
; next 18 bytes also used for monitor
ptr1	*=*+1           ;index to pass1 errors
ptr2	*=*+1           ;index to pass2 errors
pcntr	*=*+1
firt	*=*+1
cntdn	*=*+1
shcnl	*=*+1
rer	*=*+1
rez	*=*+1
rdflg	*=*+1
flagt1	;temp during bit read time
shcnh	*=*+1
cmp0	*=*+1
diff	*=*+1
prp	*=*+1
ochar	*=*+1
prty	*=*+1
fsblk	*=*+1
mych	*=*+1
cdata	*=*+1           ;how to turn cassette timers on
.pag 'declare-editor'
;screen editor page zero variables
;
;editor indirect address variables
;
	*=$c0           ;leave some space
pkybuf	*=*+2           ;start adr of pgm key
keypnt	*=*+2           ;current pgm key buf
sedsal	*=*+2           ;scroll ptr
sedeal	*=*+2           ;scroll ptr
pnt	*=*+2           ;current character pointer
;
;editor variables for speed & size
;
tblx	*=*+1           ;cursor line
pntr	*=*+1           ;cursor column
grmode	*=*+1           ;graphic/text mode flag
lstx	*=*+1           ;last character index
lstp	*=*+1           ;screen edit start position
lsxp	*=*+1
crsw	*=*+1           ;
ndx	*=*+1           ;index to keyd queue
qtsw	*=*+1           ;quote mode flag
insrt	*=*+1           ;insert mode flag
config	*=*+1           ;coursor type / char before blink (petii)
indx	*=*+1           ;last byte posistion on line (##234-02##244-02)
kyndx	*=*+1           ;count of program key string
rptcnt	*=*+1           ;delay tween chars
delay	*=*+1           ;delay to next repeat
;
sedt1	*=*+1           ;frequently used temp variables
sedt2	*=*+1
;
;frequently used editor variables
;
data	*=*+1           ;current print data
sctop	*=*+1           ;top screen 0-25
scbot	*=*+1           ;bottom 0-25
sclf	*=*+1           ;left margin
scrt	*=*+1           ;right margin
modkey	*=*+1           ;keyscanner shift/control flags ($ff-nokey)
norkey	*=*+1           ;keyscanner normal key number ($ff-nokey)
;
; see screen editor listings for usage in this area
;
	* =$f0          ;free zero page space, 16 bytes
.pag 'declare absolute'
	* =$100         ;system stack area
bad	*=*+1           ;cassette bad address table
	* =$1ff
stackp	*=*+1           ;system stack pointer transx code
	* =$200
buf	*=*+256         ;basic's rom page work area
;
;system ram vectors
;
cinv	*=*+2           ;irq vector
cbinv	*=*+2           ;brk vector
nminv	*=*+2           ;nmi vector
iopen	*=*+2           ;open file vector
iclose	*=*+2           ;close file vector
ichkin	*=*+2           ;open chn in vector
ickout	*=*+2           ;open chn out vector
iclrch	*=*+2           ;close channel vector
ibasin	*=*+2           ;input from chn vector
ibsout	*=*+2           ;output to chn vector
istop	*=*+2           ;check stop key vector
igetin	*=*+2           ;get from queue vector
iclall	*=*+2           ;close all files vector
iload	*=*+2           ;load from file vector
isave	*=*+2           ;save to file vector
usrcmd	*=*+2           ;monitor extension vector
escvec	*=*+2           ;user esc key vector
ctlvec	*=*+2           ;unused control key vector
isecnd	*=*+2           ;ieee listen secondary address
itksa	*=*+2           ;ieee talk secondary address
iacptr	*=*+2           ;ieee character in routine
iciout	*=*+2           ;ieee character out routine
iuntlk	*=*+2           ;ieee bus untalk
iunlsn	*=*+2           ;ieee bus unlistn
ilistn	*=*+2           ;ieee listen device primary address
italk	*=*+2           ;ieee talk device primary address
;
;kernal absolute variables
;
lat	*=*+10          ;logical file numbers
fat	*=*+10          ;device numbers
sat	*=*+10          ;secondary addresses
;
;
lowadr	*=*+3           ;start of system memory
hiadr	*=*+3           ;top of system memory
memstr	*=*+3           ;start of user memory
memsiz	*=*+3           ;top of user memory
timout	*=*+1           ;ieee timeout enable
verck	*=*+1           ;load/verify flag
ldtnd	*=*+1           ;device table index
msgflg	*=*+1           ;message flag
bufpt	*=*+1           ;cassette buffer index
;
;kernal temporary (local) variable
;
t1	*=*+1
t2	*=*+1
xsav	*=*+1
savx	*=*+1
svxt	*=*+1
temp	*=*+1
alarm	*=*+1           ; irq variable holds 6526 irq's
;
;kernal cassette variables
;
itape	*=*+2           ;indirect for cassette code
cassvo	*=*+1           ;cassette read  variable
aservo	*=*+1           ;flagt1***indicates t1 timeout cassette read
caston	*=*+1           ;how to turn on timers
relsal	*=*+1           ;moveable start load addr
relsah	*=*+1
relsas	*=*+1
oldinv	*=*+3           ;restore user irq and i6509 after cassettes
cas1	*=*+1           ;cassette switch flag
;
;rs-232 information storage
;
m51ctr	*=*+1           ;6551 control image
m51cdr	*=*+1           ;6551 command image
	*=*+2
rsstat	*=*+1           ;perm. rs-232 status
dcdsr	*=*+1           ;last dcd/dsr value
ridbs	*=*+1           ;input start index
ridbe	*=*+1           ;input end index
.pag 'declare absolute'
;
;screen editor absolute
;
	*=$380          ;block some area for editor
pkyend	*=*+2           ;program key buffer end ADDRESS
pagsav	*=*+1           ;temp ram page
;
; see screen editor listings for other variables
;
	* =$3c0         ;free absolute space start
;
; system warm start variables and vectors
;
	* =$3f8
evect	*=*+5
warm	=$a5            ;warm start flag
winit	=$5a            ;initilization complete flag
	* =$400
ramloc
.pag 'declare ipc'
;
; kernal inter-process communication variables
	* = $0800
ipbsiz	= 16            ;ipc buffer size
;
;   ipc buffer offsets
;
ipccmd	= 0             ;ipc command
ipcjmp	= 1             ;ipc jump address
ipcin	= 3             ;ipc #input bytes
ipcout	= 4             ;ipc #output bytes
ipcdat	= 5             ;ipc data buffer (8 bytes max)
;
ipb	*=*+ipbsiz      ;ipc buffer
ipjtab	*=*+256         ;ipc jump table
ipptab	*=*+128         ;ipc param spec table
;
.end
; -------------------------------------------------------------
; ##### equate #####
.pag 'equate 04/29/83'
;tape block types
;
eot	= 5             ;end of tape
blf	= 1             ;basic load file
bdf	= 2             ;basic data file
bdfh	= 4             ;basic data file header
bufsz	= 192           ;buffer size
cr	= $d            ;carriage return
basic	= $8000         ;start of rom (language)
kernal	= $e000         ;start of rom (kernal)
.ski 5
; 6845 video display controller for bc2
;
vdc	= $d800
adreg	= $0            ;address register
dareg	= $1            ;data register
.ski 3
; 6581 sid sound interface device
;   register list
sid	= $da00
;
; base addresses osc1, osc2, osc3
osc1	= $00
osc2	= $07
osc3	= $0e
;
; osc registers
freqlo	= $00
freqhi	= $01
pulsef	= $02
pulsec	= $03
oscctl	= $04
atkdcy	= $05
susrel	= $06
;
; filter control
fclow	= $15
fchi	= $16
resnce	= $17
volume	= $18
;
; pots, random number, and env3 out
potx	= $19
poty	= $1a
random	= $1b
env3	= $1c
.pag 'equate 6526'
; 6526 cia  complex interface adapter
;  game / ieee data / user
;
;   timer a: ieee local / cass local / music / game
;   timer b: ieee deadm / cass deadm / music / game
;
;   pra0 : ieee data1 / user / paddle game 1
;   pra1 : ieee data2 / user / paddle game 2
;   pra2 : ieee data3 / user
;   pra3 : ieee data4 / user
;   pra4 : ieee data5 / user
;   pra5 : ieee data6 / user
;   pra6 : ieee data7 / user / game trigger 14
;   pra7 : ieee data8 / user / game trigger 24
;
;   prb0 : user / game 10
;   prb1 : user / game 11
;   prb2 : user / game 12
;   prb3 : user / game 13
;   prb4 : user / game 20
;   prb5 : user / game 21
;   prb6 : user / game 22
;   prb7 : user / game 23
;
;   flag : user / cassette read
;   pc   : user
;   ct   : user
;   sp   : user
;
cia	= $dc00
pra	= $0            ;data reg a
prb	= $1            ;data reg b
ddra	= $2            ;direction reg a
ddrb	= $3            ;direction reg b
talo	= $4            ;timer a low  byte
tahi	= $5            ;timer a high byte
tblo	= $6            ;timer b low  byte
tbhi	= $7            ;timer b high byte
tod10	= $8            ;10ths of seconds
todsec	= $9            ;seconds
todmin	= $a            ;minutes
todhr	= $b            ;hours
sdr	= $c            ;serial data register
icr	= $d            ;interrupt control register
cra	= $e            ;control register a
crb	= $f            ;control register b
.page 'equate ipc'
;
; 6526 cia for inter-process communication
;
;    pra  = data port
;    prb0 = busy1 (1=>6509 off dbus)
;    prb1 = busy2 (1=>8088/z80 off dbus)
;    prb2 = semaphore 8088/z80
;    prb3 = semaphore 6509
;    prb4 = unused
;    prb5 = unused
;    prb6 = irq to 8088/z80 (lo)
;    prb7 = unused
;
ipcia	= $db00
;
sem88	= $04           ;prb bit2
sem65	= $08           ;prb bit3
.page 'equate 6551'
; 6551 acia  rs-232c and network interface
;
acia	= $dd00
drsn	= $00           ;transmitt/receive data register
srsn	= $01           ;status register
cdr	= $02           ;command register
ctr	= $03           ;control register
.ski 5
dsrerr	= $40           ;data set ready error
dcderr	= $20           ;data carrier detect error
doverr	= $08           ;receiver outer buffer overrun
.page 'equate 6525/d1'
; 6525 tpi1  triport interface device #1
;  ieee control / cassette / network / vic / irq
;
;   pa0 : ieee dc control (ti parts)
;   pa1 : ieee te control (ti parts) (t/r)
;   pa2 : ieee ren
;   pa3 : ieee atn
;   pa4 : ieee dav
;   pa5 : ieee eoi
;   pa6 : ieee ndac
;   pa7 : ieee nrfd
;
;   pb0 : ieee ifc
;   pb1 : ieee srq
;   pb2 : network transmitter enable
;   pb3 : network receiver enable
;   pb4 : arbitration logic switch
;   pb5 : cassette write
;   pb6 : cassette motor
;   pb7 : cassette switch
;
;   irq0: 50/60 hz irq
;   irq1: ieee srq
;   irq2: 6526 irq
;   irq3: (opt) 6526 inter-processor
;   irq4: 6551
;   *irq: 6566 (vic) / user devices
;   cb  : vic dot select
;   ca  : vic matrix select
;
tpi1	= $de00
pa	= $0            ;port register a
pb	= $1            ;port register b
pc	= $2            ;port register c
lir	= $2            ;interrupt latch register mc= 1
ddpa	= $3            ;data direction register a
ddpb	= $4            ;data direction register b
ddpc	= $5            ;data direction register c
mir	= $5            ;interrupt mask register mc= 1
creg	= $6            ;control register
air	= $7            ;active interrupt register
;
freq	= $01           ;irq line 50/60 hz found on...
	.ife system <
id55hz	= 27            ;55 hz value required by ioinit
>
	.ifn system <
id55hz	= 14            ;55hz value required by ioinit
>
.page 'equate 6525/d2'
; 6525 tpi2 tirport interface device #2
;  keyboard / vic 16k control
;
;   pa0 : kybd out 8
;   pa1 : kybd out 9
;   pa2 : kybd out 10
;   pa3 : kybd out 11
;   pa4 : kybd out 12
;   pa5 : kybd out 13
;   pa6 : kybd out 14
;   pa7 : kybd out 15
;
;   pb0 : kybd out 0
;   pb1 : kybd out 1
;   pb2 : kybd out 2
;   pb3 : kybd out 3
;   pb4 : kybd out 4
;   pb5 : kybd out 5
;   pb6 : kybd out 6
;   pb7 : kybd out 7
;
;   pc0 : kybd in 0
;   pc1 : kybd in 1
;   pc2 : kybd in 2
;   pc3 : kybd in 3
;   pc4 : kybd in 4
;   pc5 : kybd in 5
;   pc6 : vic 16k bank select low
;   pc7 : vic 16k bank select hi
;
tpi2	= $df00
.page 'equate ieee lines'
; ieee line equates
;
dc	= $01           ;75160/75161 control line
te	= $02           ;75160/75161 control line
ren	= $04           ;remote enable
atn	= $08           ;attention
dav	= $10           ;data available
eoi	= $20           ;end or identify
ndac	= $40           ;not data accepted
nrfd	= $80           ;not ready for data
ifc	= $01           ;interface clear
srq	= $02           ;service request
;       
rddb	= nrfd+ndac+te+dc+ren ;directions for receiver
tddb	= eoi+dav+atn+te+dc+ren ;directions for transmitt
;
eoist	= $40           ;eoi status test
tlkr	= $40           ;device is talker
lstnr	= $20           ;device is listener
utlkr	= $5f           ;device untalk
ulstn	= $3f           ;device unlisten
;       
toout	= $01           ;timeout status on output
toin	= $02           ;timeout status on input
eoist	= $40           ;eoi on input
nodev	= $80           ;no device on bus.
sperr	= $10           ;verify error
;       
;        equates for c3p0 flag bits 6 and 7.
;       
slock	= $40           ;screen editor lock-out
dibf	= $80           ;data in output buffer
.end
; -------------------------------------------------------------
	* = kernal
	jmp monoff      ;cold start vector
	nop
;	* = kernal+$0e00 ;3.5k code space (screen editor)

.opt nosym
.end
; -------------------------------------------------------------
; ##### disclaimer #####
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
;
;***************************************
;* CBM EDITOR FOR B/BX-SERIES SYSTEMS  *
;*   KEYBOARD AND SCREEN EDIT ROUTINES *
;* DRIVING THE HARDWARE OF THE         *
;* FOLLOWING CBM MODELS:               *
;*   B/BX-SERIES OR B128/256           *
;* COPYRIGHT (C) 1983 BY               *
;* COMMODORE BUSINESS MACHINES (CBM)   *
;***************************************
.SKI 3
;*****LISTING DATE --15:00 31 MAY 1983
.SKI 3
;***************************************
;* THIS SOFTWARE IS FURNISHED FOR USE  *
;* USE IN THE CBM B/BX COMPUTERS.      *
;*                                     *
;* COPIES THEREOF MAY NOT BE PROVIDED  *
;* OR MADE AVAILABLE FOR USE ON ANY    *
;* OTHER SYSTEM.                       *
;*                                     *
;* THE INFORMATION IN THIS DOCUMENT IS *
;* SUBJECT TO CHANGE WITHOUT NOTICE.   *
;*                                     *
;* NO RESPONSIBILITY IS ASSUMED FOR    *
;* RELIABILITY OF THIS SOFTWARE.       *
;*                                RSR  *
;***************************************
.end
; -------------------------------------------------------------
; ##### declare #####
.pag 'declare 05/01/83'
	* =$0
;------------------------------------------------------
; 6509  used to extend memory on bc2 & p2 systems
;   bits 0-5 used to direct:
;     execution register (4 bits)
;     indirect  register (4 bits)
;
;   these bits can be expanded to sixteen (16) segment
;   control lines.  on 6509 reset all lines are high.
;
; current memory map:
;   segment 15- $ffff-$e000  rom (kernal)
;               $dfff-$df00  i/o  6525 tpi2
;               $deff-$de00  i/o  6525 tpi1
;               $ddff-$dd00  i/o  6551 acia
;               $dcff-$dc00  i/o  6526 cia
;               $dbff-$db00  i/o  unused (z80,8088,6809)
;               $daff-$da00  i/o  6581 sid
;               $d9ff-$d900  i/o  unused (disks)
;               $d8ff-$d800  i/o  6566 vic/ 6845 80-col
;               $d7ff-$d400  color nybles/80-col screen
;               $d3ff-$d000  video matrix/80-col screen
;               $cfff-$c000  character dot rom (p2 only)
;               $bfff-$8000  roms external (language)
;               $7fff-$4000  roms external (extensions)
;               $3fff-$2000  rom  external
;               $1fff-$1000  rom  internal
;               $0fff-$0400  unused
;               $03ff-$0002  ram (kernal/basic system)
;   segment 14- segment 8 open (future expansion)
;   segment 7 - $ffff-$0002  ram expansion (external)
;   segment 6 - $ffff-$0002  ram expansion (external)
;   segment 5 - $ffff-$0002  ram expansion (external)
;   segment 4 - $ffff-$0002  ram expansion (external)
;   segment 3 - $ffff-$0002  ram expansion
;   segment 2 - $ffff-$0002  ram expansion
;   segment 1 - $ffff-$0002  ram expansion
;   segment 0 - $ffff-$0002  ram user/basic system
;
; the 6509 registers appear in locations $0000 and
; $0001 in all segments of memory.
;
;------------------------------------------------------
e6509	*=*+1           ;6509 execution   register
i6509	*=*+1           ;6509 indirection register
.ski 2
irom	=$f             ;indirect=rom or execution=rom
.pag 'declare - kernal'
	* =$90
;kernal page zero variables
;
;kernal indirect address variables
;
fnadr	*=*+3           ;address of file name string
sal	*=*+1           ;current load/store address
sah	*=*+1
sas	*=*+1
eal	*=*+1           ;end of load/save
eah	*=*+1
eas	*=*+1
stal	*=*+1           ;start of load/save
stah	*=*+1
stas	*=*+1
;
;frequently used kernal variables
;
status	*=*+1           ;i/o operation status
fnlen	*=*+1           ;file name length
la	*=*+1           ;current logical index
fa	*=*+1           ;current first address
sa	*=*+1           ;current second address
dfltn	*=*+1           ;default input device
dflto	*=*+1           ;default output device
;
;tape buffer pointer
;
tape1	*=*+3           ;address of tape buffer
;
; see kernal listing for allocation information
;
.pag 'declare-editor'
;screen editor page zero variables
;
;editor indirect address variables
;
	*=$c0           ;leave some space
pkybuf	*=*+2           ;start adr of pgm key
keypnt	*=*+2           ;current pgm key buf
sedsal	*=*+2           ;scroll ptr
sedeal	*=*+2           ;scroll ptr
pnt	*=*+2           ;current character pointer
;
;editor variables for speed & size
;
tblx	*=*+1           ;cursor line
pntr	*=*+1           ;cursor column
grmode	*=*+1           ;graphic/text mode flag
lstx	*=*+1           ;last character index
lstp	*=*+1           ;screen edit start position
lsxp	*=*+1
crsw	*=*+1           ;
ndx	*=*+1           ;index to keyd queue
qtsw	*=*+1           ;quote mode flag
insrt	*=*+1           ;border color
config	*=*+1           ;cursor type
indx	*=*+1           ;last byte posistion of line
kyndx	*=*+1           ;count of program key string
rptcnt	*=*+1           ;delay tween chars
delay	*=*+1           ;delay to next repeat
;
sedt1	*=*+1           ;frequently used temp variables
sedt2	*=*+1
;
;frequently used editor variables
;
data	*=*+1           ;current print data
sctop	*=*+1           ;top screen 0-25
scbot	*=*+1           ;bottom 0-25
sclf	*=*+1           ;left margin
scrt	*=*+1           ;right margin
modkey	*=*+1           ;keyscanner mode   byte ($ff - no key down last scan)
norkey	*=*+1           ;keyscanner normal byte ($ff - no key down last scan)
bitabl	*=*+4           ;wrap bitmap
zpend
.pag 'declare absolute'
;
	* =$100
; stack space
	* =$200
buf	*=*+256         ;basic's line input
;
; this area reserved for kernal absolutes
;  see kernal listing for other locations
;
ctlvec	=$0322
escvec	=$0320
hiadr	=$0355
bsout	=$ffd2          ;kernal vector
.pag 'declare absolute'
;
;screen editor absolute
;
	*=$380          ;block some area for editor
pkyend	*=*+2           ;program key buffer end address
keyseg	*=*+1           ;segment number for function key ram page
keysiz	*=*+20          ;function key sizes ...don't clear...
rvs	*=*+1           ;reverse field flag
lintmp	*=*+1           ;line # tween in and out
lstchr	*=*+1           ;last char printed
insflg	*=*+1           ;auto insert flag
scrdis	*=*+1           ;scroll disable flag
fktmp	;also used for function key temporary
bitmsk	*=*+1           ;temporary bitmask
keyidx	*=*+1           ;index to programmables
logscr	*=*+1           ;logical/physical scroll flag
bellmd	*=*+1           ;flag to turn on end of line bell
pagsav	*=*+1           ;temp ram page
;
tab	*=*+10          ;tabstop flags (80 max)
;
keyd	*=*+10          ;key character queue
funvec	*=*+2           ;indirect jump vector for function keys
sedt3	*=*+1           ;another temp used during function key listing
absend
;
; system warm start variables and vectors
;
	* =$3f8
evect	*=*+5
warm	=$a5            ;warm start flag
winit	=$5a            ;initilization complete flag
	* =$400
ramloc
.end
; -------------------------------------------------------------
; ##### equate #####
.pag 'equate 11/12/82'
;tape block types
;
eot	= 5             ;end of tape
blf	= 1             ;basic load file
bdf	= 2             ;basic data file
bdfh	= 4             ;basic data file header
bufsz	= 192           ;buffer size
cr	= $d            ;carriage return
basic	= $8000         ;start of rom (language)
kernal	= $e000         ;start of rom (kernal)
.ski 5
; 6845 video display controller for bc2
;
vdc	= $d800
adreg	= $0            ;address register
dareg	= $1            ;data register
.ski 3
; 6581 sid sound interface device
;   register list
sid	= $da00
;
; base addresses osc1, osc2, osc3
osc1	= $00
osc2	= $07
osc3	= $0e
;
; osc registers
freqlo	= $00
freqhi	= $01
pulsef	= $02
pulsec	= $03
oscctl	= $04
atkdcy	= $05
susrel	= $06
;
; filter control
fclow	= $15
fchi	= $16
resnce	= $17
volume	= $18
;
; pots, random number, and env3 out
potx	= $19
poty	= $1a
random	= $1b
env3	= $1c
.pag 'equate 6526'
; 6526 cia  complex interface adapter
;  game / ieee data / user
;
;   timer a: ieee local / cass local / music / game
;   timer b: ieee deadm / cass deadm / music / game
;
;   pra0 : ieee data1 / user
;   pra1 : ieee data2 / user
;   pra2 : ieee data3 / user
;   pra3 : ieee data4 / user
;   pra4 : ieee data5 / user
;   pra5 : ieee data6 / user
;   pra6 : ieee data7 / user / game trigger 14
;   pra7 : ieee data8 / user / game trigger 24
;
;   prb0 : user / game 10
;   prb1 : user / game 11
;   prb2 : user / game 12
;   prb3 : user / game 13
;   prb4 : user / game 20
;   prb5 : user / game 21
;   prb6 : user / game 22
;   prb7 : user / game 23
;
;   flag : user
;   pc   : user
;   ct   : user
;   sp   : user
;
cia	= $dc00
pra	= $0            ;data reg a
prb	= $1            ;data reg b
ddra	= $2            ;direction reg a
ddrb	= $3            ;direction reg b
talo	= $4            ;timer a low  byte
tahi	= $5            ;timer a high byte
tblo	= $6            ;timer b low  byte
tbhi	= $7            ;timer b high byte
tod10	= $8            ;10ths of seconds
todsec	= $9            ;seconds
todmin	= $a            ;minutes
todhr	= $b            ;hours
sdr	= $c            ;serial data register
icr	= $d            ;interrupt control register
cra	= $e            ;control register a
crb	= $f            ;control register b
.page 'equate 6551'
; 6551 acia  rs-232c and network interface
;
acia	= $dd00
drsn	= $00           ;transmitt/receive data register
srsn	= $01           ;status register
cdr	= $02           ;command register
ctr	= $03           ;control register
.ski 5
dsrerr	= $40           ;data set ready error
dcderr	= $20           ;data carrier detect error
doverr	= $08           ;receiver outer buffer overrun
.page 'equate 6525/d1'
; 6525 tpi1  triport interface device #1
;  ieee control / cassette / network / vic / irq
;
;   pa0 : ieee dc control (ti parts)
;   pa1 : ieee te control (ti parts) (t/r)
;   pa2 : ieee ren
;   pa3 : ieee atn
;   pa4 : ieee dav
;   pa5 : ieee eoi
;   pa6 : ieee ndac
;   pa7 : ieee nrfd
;
;   pb0 : ieee ifc
;   pb1 : ieee srq
;   pb2 : network transmitter enable
;   pb3 : network receiver enable
;   pb4 : arbitration logic switch
;   pb5 : cassette write
;   pb6 : cassette motor
;   pb7 : cassette switch
;
;   irq0: 50/60 hz irq
;   irq1: ieee srq
;   irq2: 6526 irq
;   irq3: cassette read
;   irq4: 6551
;   *irq: 6566 (vic) / user devices
;   cb  : vic dot select
;   ca  : vic matrix select
;
tpi1	= $de00
pa	= $0            ;port register a
pb	= $1            ;port register b
pc	= $2            ;port register c
lir	= $2            ;interrupt latch register mc= 1
ddpa	= $3            ;data direction register a
ddpb	= $4            ;data direction register b
ddpc	= $5            ;data direction register c
mir	= $5            ;interrupt mask register mc= 1
creg	= $6            ;control register
air	= $7            ;active interrupt register
;
freq	= $01           ;irq line 50/60 hz found on...
id55hz	= 27            ;55 hz value required by ioinit
.page 'equate 6525/d2'
; 6525 tpi2 tirport interface device #2
;  keyboard / vic 16k control
;
;   pa0 : kybd out 8
;   pa1 : kybd out 9
;   pa2 : kybd out 10
;   pa3 : kybd out 11
;   pa4 : kybd out 12
;   pa5 : kybd out 13
;   pa6 : kybd out 14
;   pa7 : kybd out 15
;
;   pb0 : kybd out 0
;   pb1 : kybd out 1
;   pb2 : kybd out 2
;   pb3 : kybd out 3
;   pb4 : kybd out 4
;   pb5 : kybd out 5
;   pb6 : kybd out 6
;   pb7 : kybd out 7
;
;   pc0 : kybd in 0
;   pc1 : kybd in 1
;   pc2 : kybd in 2
;   pc3 : kybd in 3
;   pc4 : kybd in 4
;   pc5 : kybd in 5
;   pc6 : select for monitor high=ntsc  low=pal
;   pc7 : select for head high=built-in low=monitor
;
tpi2	= $df00
.page 'equate ieee lines'
; ieee line equates
;
dc	= $01           ;75160/75161 control line
te	= $02           ;75160/75161 control line
ren	= $04           ;remote enable
atn	= $08           ;attention
dav	= $10           ;data available
eoi	= $20           ;end or identify
ndac	= $40           ;not data accepted
nrfd	= $80           ;not ready for data
ifc	= $01           ;interface clear
srq	= $02           ;service request
;       
rddb	= nrfd+ndac+te+dc ;directions for receiver
tddb	= eoi+dav+atn+te+dc ;directions for transmitt
;
eoist	= $40           ;eoi status test
tlkr	= $40           ;device is talker
lstnr	= $20           ;device is listener
utlkr	= $5f           ;device untalk
ulstn	= $3f           ;device unlisten
;       
toout	= $01           ;timeout status on output
toin	= $02           ;timeout status on input
eoist	= $40           ;eoi on input
nodev	= $80           ;no device on bus.
sperr	= $10           ;verify error
;       
;        equates for c3p0 flag bits 6 and 7.
;       
slock	= $40           ;screen editor lock-out
dibf	= $80           ;data in output buffer
.end
; -------------------------------------------------------------
; ##### bwinit #####
.pag 'bwinit 05/01/83'
;****************************************
;
;  80 column cbm ii screen editor
;
;    with unlimited screen line wrap
;
;****************************************
.skip 3
scnram	= $d000         ;start of screen memory
sidreg	= $da00         ;sid registers
llen	= 80            ;screen length
nrows	= 25            ;scrren length
scxmax	= llen-1        ;max column number
scymax	= nrows-1       ;max line number
keymax	= 9             ;keyboard buffer size - 1
dblzer	= 89            ;key code for double zero
pgmkys	= 20            ;number of progam keys
alocat	= $ff81
ierror	= $0280         ;basic error indirect
cursor	= $60           ;init to full flashing cursor
romimg	= $00           ;init to normal image & char rom
.ski 3
	*=$e004
;************ jump table ****************
;
jcint	jmp cint
jlp2	jmp lp2
jloop5	jmp loop5
jprt	jmp prt
jscror	jmp scrorg
jkey	jmp key
jmvcur	jmp movcur      ;jmp prend code removed...mov cursor
jplot	jmp plot
jiobas	jmp iobase
jescrt	jmp escape
pgmkey	jmp keyfun
;
plot
	bcs rdplt
	stx tblx
	stx lsxp
	sty pntr
	sty lstp
; jsr sreset ;always reset the window
	jsr stupt       ;change pointer to this new line
	jsr movcur      ;move the cursor there
rdplt
	ldx tblx
	ldy pntr
	rts
;
iobase
	ldx #<cia
	ldy #>cia
	rts
;
scrorg
	ldx #llen
	ldy #nrows
	rts
;
.pag
cint
	lda #0
	ldx #zpend-keypnt-1 ;erase all but fkey allocation
cloop1	sta keypnt,x    ;clear page 0 variables
	dex
	bpl cloop1
	ldx #absend-rvs-1
cloop2	sta rvs,x       ;clear absolute variables but fkey allocations
	dex
	bpl cloop2
	lda #$c
	sta delay       ;init repeat ctr
	lda #cursor
	sta config      ;set full flashing cursor
	lda #<dokeyf
	sta funvec      ;set up indirecvct for function keys
	lda #>dokeyf
	sta funvec+1
	lda pkybuf      ;check if buffers are allocated
	ora pkybuf+1
	bne noroom      ;yes...just reset the screen
	lda hiadr       ;get end of key area
	sta pkyend
	lda hiadr+1
	sta pkyend+1
	lda #$40
	ldx #0
	ldy #2
	jsr alocat      ;get 512 bytes
	bcs noroom
	sta keyseg
	inx
	stx pkybuf
	bne room10
	iny
room10
	sty pkybuf+1    ;save start address
kyset
	ldy #keyend-keydef
	jsr pagst2
kyset1
	lda keydef-1,y
	dey
	sta (pkybuf),y
	bne kyset1
	jsr pagres
	ldy #keydef-keylen
kyset2
	lda keylen-1,y
	sta keysiz-1,y
	dey
	bne kyset2
noroom
	jsr sreset      ;set full screen window
	jsr txcrt       ;set text mode/char rom
	jsr crtint      ;initialize crt
;
clsr
	jsr nxtd        ;start at top of window
cls10
	jsr scrset
	jsr clrln       ;clear the line
	cpx scbot       ;done ?
	inx
	bcc cls10       ;no
;
nxtd
	ldx sctop       ;move to top
	stx tblx
	stx lsxp        ;for input after home or clear
stu10	ldy sclf        ;left of the screen window
	sty pntr
	sty lstp
stupt
	ldx tblx        ;reset ptr to line begin
;
scrset
	lda ldtb2,x
	sta pnt
	lda ldtb1,x
	sta pnt+1
	rts
;
; movcur - move the cursor routine
;   watch out .y is now zapped
;
movcur
	ldy #15
	clc
	lda pnt
	adc pntr
	sty vdc+adreg
	sta vdc+dareg   ;set low byte of cursor address
	dey
	sty vdc+adreg
	lda vdc+dareg   ;get old high byte of cursor address
	and #$f8        ;mask out 3 low order bits
	sta sedt1       ;save it
	lda pnt+1
	adc #0
	and #07         ;get new low order bits
	ora sedt1       ;add in masked bits
	sta vdc+dareg   ;set high byte of cursor address
	rts
.ski 2
; *** input routines ***
;
lp2	ldx kyndx       ;are there any pgm keys
	beq lp3         ;branch if not
	ldy keyidx      ;get index to current char
	jsr pagst2      ;make sure ram 0
	lda (keypnt)y   ;get current byt
	jsr pagres      ;restore ram page
	dec kyndx       ;1 byte down
	inc keyidx      ;bump index to next char
	cli
	rts
lp3	ldy keyd        ;get key from irq buffer
	ldx #0
lp1	lda keyd+1,x
	sta keyd,x
	inx
	cpx ndx
	bne lp1
	dec ndx
	tya
	cli
	rts
;
loop4	jsr prt         ;print the character
loop3
	ldy #10
	lda config
	sty vdc+adreg
	sta vdc+dareg   ;set cursor type
loop3a
	lda ndx
	ora kyndx
	beq loop3a      ;loop - wait for key input
	sei
; ldy #10  from loop3
	lda #$20
	sty vdc+adreg
	sta vdc+dareg   ;turn off cursor
lp21
	jsr lp2         ;get key input
	cmp #$d
	bne loop4
	sta crsw        ;flag - we pass chars now
	jsr fndend      ;check nxt line for cont
	stx lintmp      ;save last line number of sentence
	jsr fistrt      ;find begining of line
	lda #0
	sta qtsw        ;clear quote mode
	ldy sclf        ;retrieve from line start if left it
	lda lsxp        ;input started row
	bmi lp80        ;flag we left start line
	cmp tblx
	bcc lp80
	ldy lstp        ;input started column
	cmp lintmp      ;on start line
	bne lp70
	cpy indx        ;past start column
	beq lp75        ;ok if the same
lp70	bcs clp2        ;yes - null input
lp75
	sta tblx        ;start from here on input
lp80	sty pntr
	jmp lop5
;
loop5	tya
	pha
	txa
	pha
	lda crsw        ;passing chars to input
	beq loop3       ;no - buffer on screen
	bpl lop5        ;not done - get next char
clp2
	lda #0          ;input done clear flag
	sta crsw
	lda #$d         ;pass a return
	bne clp7
lop5
	jsr stupt       ;set pnt and user
	jsr get1ch      ;get a screen char
	sta data
	and #$3f
	asl data
	bit data
	bpl lop54
	ora #$80
lop54	bcc lop52
	ldx qtsw
	bne lop53
lop52	bvs lop53
	ora #$40
lop53	jsr qtswc
	ldy tblx        ;on input end line ?
	cpy lintmp
	bcc clp00       ;no
	ldy pntr        ;on input end column ?
	cpy indx
	bcc clp00       ;no
	ror crsw        ;c=1 minus flags last char sent
	bmi clp1        ;always
;
clp00
	jsr nxtchr      ;at next char
clp1
	cmp #$de        ;a pi ?
	bne clp7        ;no
	lda #$ff        ;translate
clp7
	sta data
	pla
	tax
	pla
	tay
	lda data
	rts
.skip 3
; *** test for quote mode ***
qtswc	cmp #$22
	bne qtswl
	lda insrt       ;if we are in insert mode...
	bne qtswi       ;don't mess with quote mode...
	lda qtsw
	eor #$1
	sta qtsw
qtswi	lda #$22
qtswl	rts
.skip 3
; *** output chars ***
nxt3
	bit rvs
	bpl nvs
nc3	ora #$80
nvs	ldx insrt
	beq nvsa
	dec insrt
nvsa	bit insflg      ;are we in auto insert mode?
	bpl nvs1        ;branch if not
	pha             ;save the char
	jsr insert      ;make room for this char
	ldx #0
	stx insrt       ;make sure we turn off insert mode.
	pla             ;restore char
nvs1
	jsr dspp        ;display the character
	cpy #69
	bne nvs2        ;do not ring bell
	jsr bell        ;ring end of line bell
nvs2
	jsr movchr      ;move to next char pos
;
; ********* exit from prt *********
;
loop2	lda data        ;copy last char
	sta lstchr
	jsr movcur      ;move the cursor
	pla
	tay
	lda insrt
	beq lop2
	lsr qtsw
lop2	pla
	tax
	pla
	rts
.end
; -------------------------------------------------------------
; ##### bwdisp #####
.pag 'bwdisp 01/17/83'
;********************************
;
; display a character
;
;********************************
;
doblnk
	lda #$20
;
dspp
	ldy pntr        ;get char index
	jsr pagset      ;make sure ram 0
	sta (pnt)y      ;put char on screen
	jsr pagres      ;restore ram page
	rts
.skip 3
;subroutine to clear one line
;                  x = line number
;         clrln :  blank entire line
;         clrprt:  y = starting column position
;
clrln
	ldy sclf
	jsr clrbit      ;make sure non-continued line
clrprt
	txa             ;save .x
	pha
	lda pntr
	pha
	dey
clr10
	iny
	sty pntr
	jsr doblnk      ;print a blank
	cpy scrt        ;line completely blank?
	bne clr10       ;branch if not
	pla
	sta pntr
	pla
	tax
	rts
.skip 3
; grab a character
;
get1ch
	ldy pntr        ;get char/color index
getych
	jsr pagset      ;make sure ram page 0
	lda (pnt)y      ;get the character
	jsr pagres      ;restore ram page
	rts
.skip 3
;*******************************************
;
;       set text/graphic mode
;
ctext
	ldy #$10
	bcs crtset      ;skip if graphic mode
txcrt
	ldy #0
crtset
	sty grmode      ;set text/graphic mode
	lda tpi1+creg
	and #$ef        ;mask out text/graphic bit
	ora grmode      ;add new text/graphic bit
	sta tpi1+creg
	rts
;
;  crtint  --  intialize crt
;
crtint
	ldy #17         ;18 byte table built in -1 for offset
	bit tpi2+pc     ;check for type
	bmi crt10       ;buit-in
	ldy #18+17      ;values for ntsc
	bvs crt10
	ldy #18+18+17   ;values for pal
crt10
	ldx #17
crt20
	lda atext,y
	stx vdc+adreg   ;index to reg.
	sta vdc+dareg
	dey
	dex
	bpl crt20
	rts
.ski 3
;**************************************************
;
;   handle ram paging
;
;**************************************************
pagset
	pha
	lda #$3f        ;for rom page
	bne pagsub
pagst2
	pha
	lda keyseg      ;for function key page
pagsub
	pha
	lda i6509       ;get current page number
	sta pagsav      ;- and save it
	pla
	sta i6509       ;set to ram page 0
	pla             ;restore a-reg
	rts
.ski 2
pagres	pha             ;save a-reg
	lda pagsav      ;get saved ram page number
	sta i6509       ;restore ram page number
	pla             ;restore a-reg
	rts
.ski
.end
; -------------------------------------------------------------
; ##### bwfun1 #####
.pag 'funcs1 05/02/83'
; *** print a char ***
;
;
prt	pha
	cmp #$ff
	bne prt10
	lda #$de        ;convert pi character
prt10
	sta data        ;save char
	txa             ;save regs.
	pha
	tya
	pha
	lda #0
	sta crsw
	ldy pntr        ;column we are in
	lda data
	and #$7f
	cmp #$20        ;test if control character
	bcc ntcn        ;yes
	ldx lstchr      ;was last char an esc
	cpx #$1b
	bne njt10       ;no
	jsr sequen      ;yes - do esc sequence
	jmp getout
njt10
	and #$3f        ;no - make a screen char
njt20
	bit data
	bpl njt30       ;skip ahead if normal set - 00 - 3f
	ora #$40        ; convert a0 - bf to 60 - 7f & c0 - df to 40 - 5f
njt30
	jsr qtswc       ;test for quote
	jmp nxt3        ;put on screen
.skip 3
; ********* control keys *********
;
ntcn
	cmp #$0d        ;test if a return
	beq ntcn20      ;no inverse if yes
	cmp #$14        ;test if insert or delete
	beq ntcn20      ;allow in insert or quote mode
	cmp #$1b        ;test if escape key
	bne ntcn1
	bit data
	bmi ntcn1       ;its a $9b
	lda qtsw        ;test if in quote mode...
	ora insrt       ;...or insert mode
	beq ntcn20      ;if not, go execute remaining code
	jsr toqm        ;else go turn off all modes
	sta data        ;and forget about this character
	beq ntcn20      ;always
ntcn1	cmp #$03        ;test if a run/load or stop
	beq ntcn20      ;no inverse if yes
	ldy insrt       ;test if in insert mode
	bne ntcn10      ;go reverse - if yes
	ldy qtsw        ;check for quote mode
	beq ntcn20      ;do not reverse if not
ntcn10
	ora #$80        ;make reverse
	bne njt20
.ski
ntcn20
	lda data
	asl a           ;set carry if shifted ctrl
	tax
	jsr ctdsp       ;indirect jsr
getout
	jmp loop2
;
ctdsp	lda ctable+1,x  ;hi byte
	pha
	lda ctable,x    ;low byte
	pha
	lda data
	rts             ;indirect jmp
.skip 3
;
cuser	jmp (ctlvec)
.skip 3
; cursor down/up
;
cdnup	bcs cup         ;cursor up
;
cdwn	jsr nxln        ;cursor down
cdn10	jsr getbit      ;a wrapped line ?
	bcs cdrts       ;skip if yes
	sec             ;flag we left line
	ror lsxp
cdrts
	clc
	rts
;
cup	ldx sctop       ;cursor up
	cpx tblx        ;at top of window ?
	bcs critgo      ; yes - do nothing
cup10	jsr cdn10       ;about to wrap to a new line ?
	dec tblx        ;up a line
	jmp stupt
.skip 3
; cursor right/left
;
crtlf	bcs cleft       ;cursor left
;
crit	jsr nxtchr      ;cursor right
	bcs cdn10       ;yes - test for wrap
critgo
	rts
;
cleft	jsr bakchr      ;move back
	bcs critgo      ;abort if at top left
	bne cdrts       ;no - exit
	inc tblx
	bne cup10       ;go set flag if needed
.skip 3
; rvs on/off
;
rvsf	eor #$80
	sta rvs
	rts
.skip 3
; home/clear
;
homclr	bcc homes       ;home
	jmp clsr        ;clear screen
;
homes	cmp lstchr      ;last char a home ?
	bne hm110       ;no
	jsr sreset      ;top=0,left=0,bot=nrows-1,rt=cols-1
hm110	jmp nxtd        ;set to top left
.skip 3
; tab function
;
tabit
	ldy pntr
	bcs tabtog      ; a tab toggle
tab1	cpy scrt        ;at right of window
	bcc tab2        ;no - tab to next
	lda scrt        ;set to screen right
	sta pntr
	rts
;
tab2	iny             ;find next tab stop
	jsr gettab
	beq tab1        ;not yet !
	sty pntr
	rts
.skip 2
tabtog
	jsr gettab      ;flip tab stop
	eor bitmsk
	sta tab,x
	rts
.skip 3
;
; skip to next line
; wrap to top if scroll disabled
;
nxln
	ldx tblx
	cpx scbot       ;of the bottom of window ?
	bcc nxln1       ;no
	bit scrdis      ;what if scrolling is disabled?
	bpl doscrl      ;branch if scroll is enabled
	lda sctop       ;wrap to top
	sta tblx
	bcs nowhop      ;always
;
doscrl
	jsr scrup       ;scroll it all
	clc             ;indicate scroll ok
nxln1	inc tblx
nowhop	jmp stupt       ;set line base adr
.skip 3
; a return or shift return
;
nxt1	jsr fndend      ;find the end of the current line
	inx
	jsr clrbit      ;set next line as non-continued
	ldy sclf        ;else point to start of next line
	sty pntr
	jsr nxln        ;set up next line
;**************************************
; turn off all modes
;   include sound if enabled
;   expected to return zero
;**************************************
toqm
	lda #0
	sta insrt
	sta rvs
	sta qtsw
	cmp bellmd      ;check for bell enabled
	bne toqmx       ;no...
	sta sidreg+volume ;turn off sid
toqmx	rts
.skip 3
; ****** scroll routines ******
;
.skip 2
; move one line
;
movlin
	lda ldtb2,x
	sta sedsal
	lda ldtb1,x
	sta sedsal+1
	jsr pagset      ;set to rom page
movl10
	lda (sedsal),y
	sta (pnt),y
	cpy scrt        ;done a whole line ?
	iny
	bcc movl10      ;no
	jmp pagres      ;restore ram page
.skip 3
; ****** scroll down ******
;
scrdwn
	ldx lsxp
	bmi scd30       ;skip if new line flag already set
	cpx tblx
	bcc scd30       ;skip if old line is below scroll area
	inc lsxp        ;else inc start line number
scd30
	ldx scbot       ;scroll down, start bottom
scd10
	jsr scrset      ;set pnt to line
	ldy sclf
	cpx tblx        ;test if at destination line
	beq scd20       ;done if yes
	dex             ;point to previous line as source
	jsr getbt1
	inx
	jsr putbt1      ;move continuation byte
	dex
	jsr movlin      ;move one line
	bcs scd10       ;always
scd20
	jsr clrln       ;set line to blanks
	jmp setbit      ;mark as continuation line
.skip 3
; ****** scroll up ******
;
scrup
	ldx sctop
scru00
	inx
	jsr getbt1      ;find first non-continued line
	bcc scru15
	cpx scbot       ;is entire screen 1 line?
	bcc scru00      ;do normal scroll if not
	ldx sctop
	inx
	jsr clrbit      ;clear to only scroll 1 line
scru15
	dec tblx
	bit lsxp
	bmi scru20      ;no change if already new line
	dec lsxp        ;move input up one
scru20
	ldx sctop
	cpx sedt2
	bcs scru30
	dec sedt2       ;in case doing insert
scru30
	jsr scr10       ;scroll
	ldx sctop
	jsr getbt1
	php
	jsr clrbit      ;make sure top line is not continuation
	plp
	bcc scru10      ;done if top line off
	bit logscr      ;logical scroll ?
	bmi scru15      ;yes - keep scrolling
scru10	rts
;
;
scr10
	jsr scrset      ;point to start of line
	ldy sclf
	cpx scbot       ;at last line ?
	bcs scr40       ;yes
	inx             ;point to next line
	jsr getbt1
	dex
	jsr putbt1      ;move continuation byte
	inx
	jsr movlin      ;move one line
	bcs scr10
;
scr40
	jsr clrln       ;make last line blank
	ldx #$ff
	ldy #$fe        ;allow only output line 0
	jsr getlin      ;get input
	and #$20        ;check if interrupt i5 = control
	bne scr80       ;if not skip ahead - not slow scroll
scr60
	nop             ;yes - waste time
	nop
	dex
	bne scr60
	dey
	bne scr60
scr70
	sty ndx
scr75
	jmp keyxt2      ;exit...setup lines for stop key check
;
scr80
	ldx #$f7        ;allow only output line 11
	ldy #$ff
	jsr getlin      ;get input lines key
	and #$10        ;check for the commodore key
	bne scr75       ;exit if not - no stop scroll
scr90
	jsr getlin      ;get input lines
	and #$10        ;check for the commodore key
	beq scr90       ;wait until com.key not depressed
scr95
	ldy #0
	ldx #0          ;allow all output lines
	jsr getlin      ;get inputs
	and #$3f        ;check for any input
	eor #$3f
	beq scr95       ;wait
	bne scr70       ;always
.ski 3
getlin
	php             ;preserve the irq flag
	sei
	stx tpi2+pa     ;set port-a output
	sty tpi2+pb     ;set port-b outputs
	jsr getkey      ;get port-c inputs
	plp
	rts
.ski  5
;ring the bell, if enabled
bell
     lda bellmd
     bne bellgo
     lda #$0f
     sta sidreg+24 ;turn up volume
     ldy #00
     sty sidreg+5 ;attack=0-decay=9
     lda #10
     sta sidreg+6 ;sustain=0-release=0
     lda #48
     sta sidreg+1 ;voice 1 freq.
     lda #96
     sta sidreg+15 ;voice 3 freq.
     ldx #$15
     stx sidreg+4
bell10
     nop
     nop ;wait to reach sustain level
     iny
     bne bell10
     dex
     stx sidreg+4 ;gate off
bellgo
     rts
;
; ce - clear entry
;   always deletes last character entered
;   will delete all <#>s. (0 1 2 3 4 5 6 7 8 9 .)
;   will delete if (<#>e<+/->)
;   cursor must be next posistion beyond entry being deleted.
;
ce	lda pntr        ;get index on line
	pha             ;save for final delete if necessary
cet0	ldy pntr
	dey
	jsr getych      ;get previous character
	cmp #43         ;(+)
	beq cet1
	cmp #45         ;(-)
	bne cet2
;
cet1	dey             ;try for an <#>e
	jsr getych
	cmp #5          ;(e)
	bne cet4        ;exit if not...it can only be an <#>e
;
cet2	cmp #5          ;(e)
	bne cet3
	dey
	jsr getych
;
cet3	cmp #46         ;try for a <#>
	bcc cet4        ;(.)
	cmp #47
	beq cet4
	cmp #58         ; (0-9)
	bcs cet4
;
	jsr deleet
	jmp cet0
;
cet4	pla             ;check if any deletes occured
	cmp pntr
	bne bellgo      ;yes...exit
	jmp deleet      ;else... go delete a character
.end
; -------------------------------------------------------------
; ##### bwsubs #####
.pag 'bwsubs 05/31/83'
;  wrap table subroutines
;
getbit
	ldx tblx
getbt1
	jsr bitpos      ;get byte & bit positions
	and bitabl,x
	cmp #1          ;make carry clear if zero
	jmp bitout
;
; putbit - set bit according to carry
;
putbit
	ldx tblx
putbt1
	bcs setbit      ;go if to mark as wrappped line
;
; clrbit - clear wrap bit
;
clrbit
	jsr bitpos      ;get byte & bit positions
	eor #$ff        ;invert bit position
	and bitabl,x    ;clear bit
bitsav
	sta bitabl,x
bitout
	ldx bitmsk
	rts
;
; setbit  -  set bit to mark as wrapped line
;
setbit
	bit scrdis      ;auto line link disable...
	bvs getbt1
	jsr bitpos      ;get byte & bit position
	ora bitabl,x    ;set wrap bit
	bne bitsav      ;always
;
; bitpos - get byte & bit position of wrap bit
;          input - x = row number
;          output - x = byte number
;                   a = bit mask
;
bitpos
	stx bitmsk
	txa
	and #$07        ;get bit position
	tax
	lda bits,x      ;get bit mask
	pha
	lda bitmsk
	lsr a
	lsr a           ;shift to get byte position
	lsr a
	tax
	pla
	rts
.ski 3
;**********************************
;  move to start of line
;
fndfst
	ldy sclf
	sty pntr        ;set to leftmost column
;
fistrt
	jsr getbit      ;find start of current line
	bcc fnd0        ;branch if found
	dec tblx        ;up a line
	bpl fistrt      ;always
	inc tblx        ;whoops went too far
fnd0
	jmp stupt       ;set line base adr
.skip 3
; ****** find last non-blank char of line
;
; pntr= column #
; tblx= line #
;
fndend	lda tblx        ;check if we are at the bottom
	cmp scbot
	bcs eloupp      ;yes...
	inc tblx
	jsr getbit      ;is this line continued
	bcs fndend      ;branch if so
eloup0	dec tblx        ;found it - compensate for inc tblx
eloupp	jsr stupt
	ldy scrt        ;get right margin
	sty pntr        ;point to right margin
	bpl eloup2      ;always
;
eloup1	jsr bakchr
	bcs endbye      ;if at top left get out
eloup2	jsr get1ch
	cmp #$20
	bne endbye      ;yes
	cpy sclf        ;are we at the left margin?
	bne eloup1      ;branch if not
	jsr getbit      ;if we're on a wraped line
	bcs eloup1      ; always scan the above line
;
endbye
	sty indx        ;remember this
	rts
.skip 3
; ****** move to next char
; scroll if enabled
; wrap to top if disabled
;
nxtchr
	pha
	ldy pntr
	cpy scrt        ;are we at the right margin?
	bcc bumpnt      ;branch if not
.ski
	jsr nxln        ;point to nextline
	ldy sclf        ;point to first char of 1st line
	dey
	sec             ;set to show moved to new line
bumpnt	iny             ;increment char index
	sty pntr
	pla
	rts
.skip 3
; ****** backup one char
; wrap up and stop a top left
;
bakchr
	ldy pntr
	dey
	bmi bakot1
	cpy sclf        ;are we at the left margin
	bcs bakout      ;no - past it
bakot1
	ldy sctop
	cpy tblx        ;are we at top line last character?
	bcs bakot2      ;leave with carry set
	dec tblx        ;else backup a line
	pha
	jsr stupt       ;set line base adr
	pla
	ldy scrt        ;move cursor to right side
bakout
	sty pntr
	cpy scrt        ;set z-flag if moved to new line
	clc             ;always clear
bakot2	rts
.ski 3
;  savpos - save row & column position
;
savpos
	ldy pntr
	sty sedt1
	ldx tblx
	stx sedt2
	rts
.pag
delins
	bcs insert
.ski
; delete a character
;
deleet
	jsr cleft       ;move back 1 position
	jsr savpos      ;save column & row positions
	bcs delout      ;abort if at top left corner
deloop
	cpy scrt        ;at right margin?
	bcc delop1      ;no - skip ahead
	ldx tblx
	inx
	jsr getbt1      ;is next line a wrapped line?
	bcs delop1      ;yes - continue with delete
	jsr doblnk      ;no - balnk last character
delout
	lda sedt1       ;restore column and row positions
	sta pntr
	lda sedt2
	sta tblx
	jmp stupt       ;restore pnt and exit
delop1
	jsr nxtchr
	jsr get1ch      ;get next character
	jsr bakchr
	jsr dspp        ;move it back 1 position
	jsr nxtchr      ;move up 1 position
	jmp deloop      ;loop until at end of line
.ski 3
; insert a character
;
insert
	jsr savpos      ;save column & row positions
	jsr fndend      ;move to last char on the line
	cpx sedt2       ;last row equal to starting row?
	bne ins10       ;no - skip ahead
	cpy sedt1       ;is last position before starting position?
ins10
	bcc ins50       ;yes - no need to move anything
	jsr movchr      ;move to next char position
	bcs insout      ;abort if scroll needed but disabled
ins30
	jsr bakchr
	jsr get1ch      ;move char forward 1 position
	jsr nxtchr
	jsr dspp
	jsr bakchr
	ldx tblx
	cpx sedt2       ;at original position
	bne ins30
	cpy sedt1
	bne ins30       ;no - loop till we are
	jsr doblnk      ;insert a blank
ins50
	inc insrt       ;inc insert count
	bne insout      ;only allow up to 255
	dec insrt
insout
	jmp delout      ;restore original position
.ski 3
;
;  stop/run
;
stprun
	bcc runrts      ;exit if a stop code
	sei             ;disable interrupts
	ldx #9
	stx ndx         ;set keyboard queue size
runlop
	lda runtb-1,x
	sta keyd-1,x    ;load run character sequence into kybd queue
	dex
	bne runlop
	cli             ;enable interrupts
runrts
	rts
.ski 3
;  movchr  -  move to next char position
;             insert blank line if at end of line
;             y = column position
;              on exit - carry set = abort - scroll disabled
;
movchr
	cpy scrt
	bcc movc10      ;easy if not at end of line
	ldx tblx
	cpx scbot
	bcc movc10      ;skip if not last line of screen
	bit scrdis
	bmi movc30      ;abort if scrolling disabled
movc10
	jsr stupt       ;set pnt address
	jsr nxtchr      ;move to next char position
	bcc movc30      ;done if not move to new line
	jsr getbit      ;check if on a continued line
	bcs movc20      ;skip ahead if not
	jsr patch1      ;patch in a check for single line screen
	sec             ;prep for abort...
	bvs movc30
	jsr scrdwn      ;else insert a blank line
movc20
	clc             ;for clean exit
movc30
	rts
.ski 2
.end
; -------------------------------------------------------------
; ##### bwfun2 #####
.pag 'funcs2 05/01/83'
sequen
	jmp (escvec)    ;escape indirect
.skip 3
;******************************
;
;  insert line
;
;*****************************
;
iline
	jsr scrdwn      ;insert a blank line
	jsr stu10       ;move to start of line
	inx
	jsr getbt1
	php
	jsr putbit      ;set continuation same as in previous line
	plp
	bcs linrts      ;skip if was wrapped
	sec
	ror lsxp        ;set flag - new line
linrts
	rts
.ski 3
;**************************
;
; delete line
;
;**************************
dline	jsr fistrt      ;find start of line
	lda sctop       ;save current of window
	pha
	lda tblx        ;make 1st display line top of window
	sta sctop
	lda logscr      ;make sure logical scrl is off
	pha
	lda #$80
	sta logscr
	jsr scru15      ;scroll the top line away
	pla
	sta logscr
	lda sctop       ;make old 1st line of this 1 current
	sta tblx
	pla
	sta sctop
	sec
	ror lsxp        ;set flag - new line
	jmp stu10       ;make this line the current one
.ski 3
;******************************
;
; erase to end of line
;
;******************************
.ski
etoeol	jsr savpos
etol	jsr clrprt      ;blank rest of line
	inc tblx        ;move to next line
	jsr stupt
	ldy sclf
	jsr getbit      ;check if next is wrapped line
	bcs etol        ;yes - blank next line
etout
	jmp delout      ;exit and restore original position
.ski 3
;*****************************
;
; erase to start of line
;
;*****************************
.ski
etosol	jsr savpos
etstol	jsr doblnk      ;do a blank
	cpy sclf        ;done a line ?
	bne ets100      ;no
	jsr getbit      ;at top of line
	bcc etout       ;yes - exit
ets100	jsr bakchr      ;back up
	bcc etstol      ;always
.ski 3
;*****************************
;
; scroll up
;
;*****************************
;
suup	jsr savpos
	txa
	pha
	jsr scrup
	pla
	sta sedt2
	jmp etout       ;always
.skip 3
;*****************************
;
; scroll down
;
;*****************************
;
sddn	jsr savpos
	jsr getbit
	bcs sddn2
	sec
	ror lsxp        ;set flag - left line
sddn2
	lda sctop
	sta tblx        ;scroll from screen top
	jsr scrdwn
	jsr clrbit      ;make first line non-continued
	jmp etout       ;always
.ski
;
; scrolling enable/disable
;           carry set = disable
scrsw0
	clc             ;enable scrolling
	.byte $24
scrsw1
	sec             ;disable scrolling
scrsw
	lda #0
	ror a
	sta scrdis
	rts
.ski
;
; logical scroll enable/disable
;              carry set = enable
logsw0
	clc             ;disable logical scroll (single line scroll)
	bcc logsw
logsw1
	sec             ;enable logical scroll (scroll a set of lines)
logsw
	lda #0
	ror a
	sta logscr
	rts
.ski 3
;******************************************
;
; programmable key functions
;
;******************************************
;
keyfun
	sei             ;prevent fight over variables with keyscan...
	dey
	bmi listky      ;do list if no parameters given
	jmp addkey      ;- else go add a new key definition
;
;   list key defintions
;
listky	ldy #0          ;initialize key counter
;
listlp
	iny
	sty sedt3
	dey             ;minus 1 for indexing
	lda keysiz,y    ;get key length
	beq nodefn      ;no listing if no defintion
	sta keyidx      ;save key length
	jsr findky      ;get buffer start addr for function key
	sta keypnt
	stx keypnt+1    ;save 2 byte address in temp loc
	ldx #3
;
preamb	lda keword,x    ;print 'key ' preamble
	jsr bsout
	dex
	bpl preamb
;
	ldx #$2f
	lda sedt3       ;get key number
	sec
ky2asc	inx             ;convert to 1 or 2 digit ascii
	sbc #10
	bcs ky2asc
	adc #$3a        ;add 10 & make ascii
	cpx #$30
	beq nosec       ;skip 2nd digit print
	pha             ;save first digit-10
	txa
	jsr bsout       ;print second digit
	pla             ;restore first digit-10
;
nosec
	jsr bsout       ;print first digit
	ldy #0          ;init string position counter
	lda #',         ;for comma print
lstk20	jsr bsout       ;print char - comma or plus-sign
	ldx #7          ;for chr$ printing - no plus-sign or quote to preceed
txtprt
	jsr pagst2      ;make sure function key ram page
	lda (keypnt),y  ;get byte
	jsr pagres
	cmp #13
	beq lstkcr      ;print chr$(13) for return
	cmp #141
	beq lstksc      ;print chr$(141) for return
	cmp #34
	beq lstkqt      ;print chr$(34) for quote
	cpx #9          ;was a normal char printed last time
	beq lstk10      ;yes - skip ahead
	pha             ;save char
	lda #'"
	jsr bsout       ;print a quote
	pla             ;restore the char
;
lstk10	jsr bsout       ;print the char
	ldx #9          ;for chr$ - print quote and plus next time
	iny
	cpy keyidx
	bne txtprt      ;loop to end of string
;
	lda #'"
	jsr bsout       ;print ending quote
;
lstk30
	lda #$0d
	jsr bsout       ;do a return
nodefn
	ldy sedt3       ;get key number
	cpy #pgmkys
	bne listlp      ;loop til all keys checked
	cli             ;all done...clear the keyscan holdoff
	clc             ;okay return always
	rts
;
lstkcr	ldx #qtword-cdword-1 ;index for return
	.byt $2c        ;skip 2
lstksc	ldx #addkey-cdword-1 ;index for shifted-return
	.byt $2c        ;skip 2
lstkqt	ldx #scword-cdword-1 ;index for quote
;
lstk	txa             ;save value index....
	pha             ;save .x
	ldx #crword-cdword-1 ;print chr$(
lstklp	lda cdword,x    ;print loop
	beq lstk40      ;zero is end...
	jsr bsout       ;
	dex
	bpl lstklp
	pla             ;move number and repeat
	tax
	bne lstklp
;
lstk40	iny
	cpy keyidx
	beq lstk30      ;exit if all string printed
	lda #'+         ;set to print plus sign
	bne lstk20      ;return to routine
;
;
keword	.byte ' yek'
cdword	.byte '($rhc+' ; HINTER DEM + NOCH "
crword	.byte 0,')31'
qtword	.byte 0,')43'
scword	.byte 0,')141'
.ski 3
;
;   insert a new key defintion
;
addkey
	pha             ;save zero page address of params
	tax
	sty sedt1       ;save key number in temp loc
	lda $0,x        ;get new string length
	sec
	sbc keysiz,y    ;subtract old length
	sta sedt2       ;save difference in temp location
	ror fktmp       ;save the carry
	iny
	jsr findky      ;find start addr of next function key
	sta sedsal
	stx sedsal+1    ;save 2 byte address in temp loc
	ldy #pgmkys
	jsr findky      ;find end of last function key
	sta sedeal
	stx sedeal+1    ;save next free byte addr in temp loc
	ldy fktmp       ;check if new string is longer or shorter
	bpl keysho      ;skip ahead if shorter
	clc
	sbc pkyend      ;subtract last available adress
	tay
	txa
	sbc pkyend+1
	tax
	tya
	clc
	adc sedt2       ;add difference
	txa
	adc #0
	bcs kyxit       ;skip if memory not full
;
; expand or contract key area to make room for new
;   key definition.
;
keysho
	jsr pagst2      ;set up function key ram page
kymove
	lda sedeal
	clc             ;check if entire area expanded or contracted
	sbc sedsal
	lda sedeal+1
	sbc sedsal+1
	bcc keyins      ;go insert new key defintion if yes
	ldy #0
	lda fktmp       ;check if expand or contract
	bpl kshort      ;skip if needs to be contracted
	lda sedeal
	bne newky4      ;dec 1 from source addr
	dec sedeal+1    ;sub 1 for borrow
newky4
	dec sedeal
	lda (sedeal),y  ;move 1 byte up to expand
	ldy sedt2       ;get offset = difference
	sta (sedeal),y  ;move byte up
	jmp kymove      ;loop until all bytes moved
kshort
	lda (sedsal),y  ;get source byte
	ldy sedt2       ;get offset = difference
	dec sedsal+1    ;sub 1 to move down
	sta (sedsal),y  ;move the byte down
	inc sedsal+1
	inc sedsal      ;move source up 1 byte
	bne kymove
	inc sedsal+1    ;add 1 for carry
	bne kymove      ;always
;
;  insert the new string defintion
;
keyins
	ldy sedt1       ;get the key index
	jsr findky      ;find buffer start address for this key
	sta sedsal
	stx sedsal+1    ;save 2 byte address in temp loc
	ldy sedt1
	pla
	pha
	tax             ;get zero page addr of params
	lda $0,x
	sta keysiz,y    ;save key length
	tay
	beq kyinok      ;equal to zero no keys...exit
	lda $1,x        ;get & save low byte of string address
	sta sedeal
	lda $2,x        ;get & save high byte of string address
	sta sedeal+1
kyinlp
	dey
	lda $3,x        ;get string ram page
	sta i6509
	lda (sedeal),y  ;get byte
	jsr pagres      ;restore original ram page
	jsr pagst2      ;set up function key ram page
	sta (sedsal),y  ;store into buffer
	tya             ;.y flags...end?
	bne kyinlp      ;no... loop
kyinok
	jsr pagres
	clc             ;for good exit carry clear
kyxit	pla             ;pop zero page address for params
	cli             ;all done...release keyscan
	rts             ; c-set is memory full error
.end
; -------------------------------------------------------------
; ##### bwkybd #####
.pag 'keybd  01/18/83'
;*******************************
;
; keyboard scanner
;
;*******************************
key
	ldy #$ff        ;say no keys pressed (real-time keyscan)
	sty modkey
	sty norkey
	iny             ;init base kybd index = 0
	sty tpi2+pb     ;allow all output lines
	sty tpi2+pa
	jsr getkey      ;get keybd input
	and #$3f        ;check if any inputs
	eor #$3f
	bne *+5         ;hop over long branch
	jmp nulxit      ;exit if none
	lda #$ff
	sta tpi2+pa     ;allow only output line 0
	asl a
	sta tpi2+pb
	jsr getkey      ;get input from line 0
	pha             ;save shift & control bits
	sta modkey      ;shift keys are down
	ora #$30        ;mask them by setting bits
	bne line01
linelp
	jsr getkey      ;get line inputs
line01
	ldx #5          ;loop for 6 input lines
kyloop
	lsr a           ;check line
	bcc havkey      ;skip ahead if have input
	iny             ;inc keyd code count
	dex
	bpl kyloop
	sec
	rol tpi2+pb     ;rotate to activate next
	rol tpi2+pa     ; - output line
	bcs linelp      ;loop until all lines done
	pla             ;clear shift/control byte
	bcc nulxit      ;exit if no key
;
;      get pet-ascii using keyboard index
;      and shift and control inputs
;
havkey
	sty norkey      ;have a normal keypress
	ldx normtb,y
	pla             ;get shift/control byte
	asl a
	asl a           ;move bits left
	asl a
	bcc doctl       ;skip ahead if control depressed
	bmi havasc      ;skip ahead if not shifted - have ascii
	ldx shfttb,y    ;assume shited textual
	lda grmode      ;test text or graphic mode
	beq havasc      ;have key if text mode
	ldx shftgr,y    ;get shifted graphic
	bne havasc      ;go process ascii key
;
doctl
     ldx ctltbl,y ;get pet-ascii char for this key
;
;     y-reg has keyboard index value
;     x-reg has pet-ascii value
;
havasc	cpx #$ff
	beq keyxit      ;exit if null pet-ascii
	cpx #$e0        ;check if function key
	bcc notfun      ;skip - not a function key
	tya
	pha
	jsr funjmp      ;do function key indirect
	pla
	tay
	bcs keyxit      ;done if carry flag set
notfun
	txa             ;get pet-ascii code
	cpy lstx        ;check if same key as last
;         time through
	beq dorpt       ;skip ahead if so
;
;     a new key input - check queue availability
;
	ldx #19
	stx delay       ;reset initial delay count
	ldx ndx         ;get key-in queue size
	cpx #keymax     ;check if queue full
	beq nulxit      ;exit if yes
	cpy #dblzer     ;check if keypad - 00
	bne savkey      ;go save key-in if not
	cpx #keymax-1   ;check if room for two
	beq nulxit      ;exit if not
	sta keyd,x      ;save first zero
	inx             ;update queue size
	bne savkey      ;always
;
nulxit	ldy #$ff
keyxit	sty lstx        ;save last key number
keyxt2	ldx #$7f
	stx tpi2+pa     ;reset output lines to allow
	ldx #$ff        ;- stop key input
	stx tpi2+pb
	rts
;
;     check repeat delays
;
dorpt
	dec delay       ;dec initial delay count
	bpl keyxt2      ;exit if was not zero - still on 1st delay
	inc delay       ; - else reset count to zero
;
;     check if secondary count down to zero
;
	dec rptcnt      ;dec repeat btwn keys
	bpl keyxt2      ;exit if was not zero - still on delay
	inc rptcnt      ;reset back to zero
;
;     time to repeat - check if key queue empty
;
	ldx ndx         ;get kybd queue size
	bne keyxt2      ;exit if kybd queue not empty
;
;     save pet-ascii into key buffer
;
savkey
	sta keyd,x      ;store pet-ascii in kybd buffer
	inx
	stx ndx
	ldx #3
	stx rptcnt      ;reset delay btwn keys
	bne keyxit
;
getkey
	lda tpi2+pc     ;debounce keyboard input
	cmp tpi2+pc
	bne getkey
	rts
;
funjmp
	jmp (funvec)    ;function key indirect
;
dokeyf	cpy lstx
	beq funrts      ;exit not allowed to repeat
	lda ndx
	ora kyndx
	bne funrts      ;exit - function queue not empty
	sta keyidx      ;init pointer index into function area
	txa
	and #$1f        ;mask out to get function key number
	tay
	lda keysiz,y    ;get function key size
	sta kyndx       ;- and store it for key scan
	jsr findky
	sta keypnt      ;get function start addr
	stx keypnt+1    ;- and save in keypnt
funrts
	sec
	rts
.ski 3
;
;   find address of function key given in y-reg
;
findky	lda pkybuf
	ldx pkybuf+1
;
findlp	clc
	dey             ;found key yet?
	bmi fndout      ;yes - done
	adc keysiz,y    ;add function key size
	bcc findlp      ;loop if no high byte carry-over
	inx
	bne findlp      ;loop - always
;
fndout
	rts
.ski 4
;
;tab set-up (tab positioner)
; y=column in question
;
gettab
	tya             ;get bit in question
	and #$07
	tax
	lda bits,x
	sta bitmsk
	tya             ;get 8 bit block
	lsr a
	lsr a
	lsr a
	tax
	lda tab,x
	bit bitmsk      ;set equal flag
	rts
.skip 3
.end
; -------------------------------------------------------------
; ##### escape #####
.pag 'escape - 05/02/83'
;************************************************************
;*
;*  routines involved in executing escape functions
;*
;************************************************************
.ski 2
;main escape sequence handler
;  entry: character following escape character in acc.
escape
     and #$7f
     sec
     sbc #'a  ;table begins at ascii a
     cmp #$1a   ;'z'-'a'+1
     bcc escgo ;valid char, go get address
escrts	rts             ;failed to find entry...ignore it!
.skip
escgo	;get address of escape routine, and go to it.
     asl a ;multiply index by 2
     tax
     lda escvct+1,x  ;get high byte
     pha
     lda escvct,x  ;and low
     pha
     rts  ;and go to that address
.ski 3
escvct
  .word auton-1  ;a auto insert
  .word sethtb-1 ;b set bottom
  .word autoff-1 ;c cancel auto insert
  .word dline-1  ;d delete line
  .word setcr4-1 ;e select non-flashing cursor
  .word setcr2-1 ;f flashing cursor
  .word bellon-1 ;g enable bell
  .word bellof-1 ;h disable bell
  .word iline-1  ;i insert line
  .word fndfst-1 ;j move to start of line
  .word fndend-1 ;k move to end of line
  .word scrsw0-1 ;l enable scrolling
  .word scrsw1-1 ;m disable scrolling
  .word nrmscr-1 ;n normal screen (not reverse)
  .word toqm-1   ;o cancel insert,quote, and reverse
  .word etosol-1 ;p erase to start of line
  .word etoeol-1 ;q erase to end of line
  .word revscr-1 ;r reverse screen
  .word setcr3-1 ;s solid cursor (not underscore)
  .word sethtt-1 ;t set top of page
  .word setcr1-1 ;u underscore cursor
  .word suup-1   ;v scroll up
  .word sddn-1   ;w scroll down
  .word escrts-1 ;x cancel escape sequence
  .word nrmset-1 ;y normal character set
  .word altset-1 ;z alternate character set
.skip
;set top or bottom
sethtt
    clc
    .byte $24
sethtb
    sec
window	ldx pntr
     lda tblx
     bcc settop
setbot
     sta scbot
     stx scrt
     rts
sreset
     lda #scymax ;max # of rows
     ldx #scxmax ;max # of columns
     jsr setbot
     lda #0
     tax
settop
     sta sctop
     stx sclf
     rts
.ski
; turn bell on or off
bellon
     lda #0
bellof
     sta bellmd
     rts
.skip 3
;alter screen or cursor
setcr1	;underscore cursor
	lda #$0b
	bit tpi2+pc     ;check machine type
	bmi setuns      ;buit-in display
	lda #$06        ;on others start cursor on line 6
     .byte $2c
setcr2	;flashing cursor
     lda #$60
setuns
     ora config
     bne setcr5 ;always
setcr3	;full cursor
     lda #$f0
     .byte $2c
setcr4	;steady cursor
     lda #$0f
     and config
setcr5	sta config
     rts ;wait untill cursor on to update
.skip
revscr	;reverse screen image
     lda #$20
     .byte $2c
altset	;alternate character set
     lda #$10
     ldx #14
     stx vdc+adreg
     ora vdc+dareg
     bne setscr ;always
nrmscr	;non-reverse screen
     lda #$df
     .byte $2c
nrmset	;normal character set
     lda #$ef
     ldx #14
     stx vdc+adreg
     and vdc+dareg
setscr
     sta vdc+dareg
     and #$30 ;use only bits 4 & 5 for starting address high
     ldx #12
ch6845
     stx vdc+adreg
     sta vdc+dareg
     rts
.skip 3
;auto insert on/off
autoff
     lda #0
     .byte $2c
auton
     lda #$ff
     sta insflg
     rts
.ski
.end
; -------------------------------------------------------------
; ##### bwtabs #####
.pag 'tables 05/31/83'
normtb
;
;     keyboard table - no control/no shift
;
;line 0: f1, escape, tab, null, shift, control
 .byte $e0,$1b,$09,$ff,$00,$01
;line 1: f2, 1, q, a, z, null
 .byte $e1,$31,$51,$41,$5a,$ff
;line 2: f3, 2, w, s, x, c
 .byte $e2,$32,$57,$53,$58,$43
;line 3: f4, 3, e, d, f, v
 .byte $e3,$33,$45,$44,$46,$56
;line 4: f5, 4, r, t, g, b
 .byte $e4,$34,$52,$54,$47,$42
;line 5: f6, 5, 6, y, h, n
 .byte $e5,$35,$36,$59,$48,$4e
;line 6: f7, 7, u, j, m, space
 .byte $e6,$37,$55,$4a,$4d,$20
;line 7: f8, 8, i, k, "," , .
 .byte $e7,$38,$49,$4b,$2c,$2e
;line 8: f9, 9, o, l, ;, /
 .byte $e8,$39,$4f,$4c,$3b,$2f
;line 9: f10, 0, -, p, [, '
 .byte $e9,$30,$2d,$50,$5b,$27
;line 10: down cursor, =, _, ], return, pi
 .byte $11,$3d,$5f,$5d,$0d,$de
;line 11: up cur, lt cur, rt cur, del, cmdr, null
 .byte $91,$9d,$1d,$14,$02,$ff
;line 12: home, ?, 7, 4, 1, 0
 .byte $13,$3f,$37,$34,$31,$30
;line 13: rvs on, cancel, 8, 5, 2, decimal point
 .byte $12,$04,$38,$35,$32,$2e
;line 14: graphic, mult, 9, 6, 3, 00
 .byte $8e,$2a,$39,$36,$33,$30
;line 15: stop, div, subtr, add, enter, null
 .byte $03,$2f,$2d,$2b,$0d,$ff
.ski 4
shfttb
;
;     keyboard table - shift only & text mode
;
;line 0: f11, sht esc, tab toggle, null, shift, ctl
 .byte $ea,$1b,$89,$ff,$00,$01
;line 1: f12, !, q, a, z, null
 .byte $eb,$21,$d1,$c1,$da,$ff
;line 2: f13, @, w, s, x, c
 .byte $ec,$40,$d7,$d3,$d8,$c3
;line 3: f14, #, e, d, f, v
 .byte $ed,$23,$c5,$c4,$c6,$d6
;line 4: f15, $, r, t, g, b
 .byte $ee,$24,$d2,$d4,$c7,$c2
;line 5: f16, %, ^, y, h, n
 .byte $ef,$25,$5e,$d9,$c8,$ce
;line 6: f17, &, u, j, m, shifted space
 .byte $f0,$26,$d5,$ca,$cd,$a0
;line 7: f18, *, i, k, <, >
 .byte $f1,$2a,$c9,$cb,$3c,$3e
;line 8: f19, (, o, l, :, ?
 .byte $f2,$28,$cf,$cc,$3a,$3f
;line 9: f20, ), -, p, [, "
 .byte $f3,$29,$2d,$d0,$5b,$22
;line 10: down cursor, +, pound sign, ], sht return, pi
 .byte $11,$2b,$5c,$5d,$8d,$de
;line 11: up cursor,left cursor,right cursor, ins, cmdr, null
 .byte $91,$9d,$1d,$94,$82,$ff
;line 12: clear/home, ?, 7, 4, 1, 0
 .byte $93,$3f,$37,$34,$31,$30
;line 13: rvs off, shft cancel, 8, 5, 2, decimal point
 .byte $92,$84,$38,$35,$32,$2e
;line 14: text, mult, 9, 6, 3, 00
 .byte $0e,$2a,$39,$36,$33,$30
;line 15: run, div, subtr, add, enter, null
 .byte $83,$2f,$2d,$2b,$8d,$ff
.ski 4
shftgr
;
;     keyboard table - shift only & graphic mode
;
;line 0: f11, sht esc, tab toggle, null, shift, ctl
 .byte $ea,$1b,$89,$ff,$00,$01
;line 1: f12, !, gr, gr, gr, null
 .byte $eb,$21,$d1,$c1,$da,$ff
;line 2: f13, @, gr, gr, gr, gr
 .byte $ec,$40,$d7,$d3,$d8,$c0
;line 3: f14, #, gr, gr, gr, gr
 .byte $ed,$23,$c5,$c4,$c6,$c3
;line 4: f15, $, gr, gr, gr, gr
 .byte $ee,$24,$d2,$d4,$c7,$c2
;line 5: f16, %, ^, gr, gr, gr
 .byte $ef,$25,$5e,$d9,$c8,$dd
;line 6: f17, &, gr, gr, gr, shifted space
 .byte $f0,$26,$d5,$ca,$cd,$a0
;line 7: f18, *, gr, gr, <, >
 .byte $f1,$2a,$c9,$cb,$3c,$3e
;line 8: f19, (, gr, gr, :, ?
 .byte $f2,$28,$cf,$d6,$3a,$3f
;line 9: f20, ), -, gr, [, "
 .byte $f3,$29,$2d,$d0,$5b,$22
;line 10: down cursor, +, pound, ], shifted return, pi
 .byte $11,$2b,$5c,$5d,$8d,$de
;line 11: up cursor,left cursor,right cursor, ins, cmdr, null
 .byte $91,$9d,$1a,$94,$82,$ff
;line 12: clear/home, ?, 7, 4, 1, 0
 .byte $93,$3f,$37,$34,$31,$30
;line 13: rvs off, shift cancel, 8, 5, 2, dp
 .byte $92,$04,$38,$35,$32,$2e
;line 14: text, mult, 9, 6, 3, 00
 .byte $0e,$2a,$39,$36,$33,$30
;line 15: run, div, subtr, add, enter, null
 .byte $83,$2f,$2d,$2b,$8d,$ff
.ski 4
ctltbl
;keyboard table... control characters, any mode
;line 0: null,null,null,null,null
 .byte $ff,$ff,$ff,$ff,$ff,$ff
;line 1: null,gr,q,a,z,null
 .byte $ff,$a1,$11,$01,$1a,$ff
;line 2: null,gr,w,s,x,c
 .byte $ff,$a2,$17,$13,$18,$03
;line 3: null,gr,e,d,f,v
 .byte $ff,$a3,$05,$04,$06,$16
;line 4: null,gr,r,t,g,b
 .byte $ff,$a4,$12,$14,$07,$02
;line 5: null,gr,gr,y,h,n
 .byte $ff,$a5,$a7,$19,$08,$0e
;line 6: null,gr,u,j,m,null
 .byte $ff,$be,$15,$0a,$0d,$ff
;line 7: null,gr,i,k,gr,null
 .byte $ff,$bb,$09,$0b,$ce,$ff
;line 8: null,gr,o,l,gr,null
 .byte $ff,$bf,$0f,$0c,$dc,$ff
;line 9: null,gr,gr,p,gr,gr
 .byte $ff,$ac,$bc,$10,$cc,$a8
;line 10: null,gr,gr,gr,null,gr
 .byte $ff,$a9,$df,$ba,$ff,$a6
;line 11: null,null,null,null,null,null
 .byte $ff,$ff,$ff,$ff,$ff,$ff
;line 12: null,gr,gr,gr,gr,gr
 .byte $ff,$b7,$b4,$b1,$b0,$ad
;line 13: null,gr,gr,gr,gr,gr
 .byte $ff,$b8,$b5,$b2,$ae,$bd
;line 14: null,gr,gr,gr,gr,null
 .byte $ff,$b9,$b6,$b3,$db,$ff
;line 15: null,gr,gr,gr,null,null
 .byte $ff,$af,$aa,$ab,$ff,$ff
.ski 3
runtb	.byt 'd',$cc,'*',$d,'run',$d	; VOR * NOCH "
.skip 3
;****** address of screen lines ******
;
linz0	= scnram
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
.ski 3
;****** screen lines lo byte table ******
;
ldtb2
	.byt <linz0
	.byt <linz1
	.byt <linz2
	.byt <linz3
	.byt <linz4
	.byt <linz5
	.byt <linz6
	.byt <linz7
	.byt <linz8
	.byt <linz9
	.byt <linz10
	.byt <linz11
	.byt <linz12
	.byt <linz13
	.byt <linz14
	.byt <linz15
	.byt <linz16
	.byt <linz17
	.byt <linz18
	.byt <linz19
	.byt <linz20
	.byt <linz21
	.byt <linz22
	.byt <linz23
	.byt <linz24
.ski 3
;****** screen lines hi byte table ******
;
ldtb1
	.byt >linz0
	.byt >linz1
	.byt >linz2
	.byt >linz3
	.byt >linz4
	.byt >linz5
	.byt >linz6
	.byt >linz7
	.byt >linz8
	.byt >linz9
	.byt >linz10
	.byt >linz11
	.byt >linz12
	.byt >linz13
	.byt >linz14
	.byt >linz15
	.byt >linz16
	.byt >linz17
	.byt >linz18
	.byt >linz19
	.byt >linz20
	.byt >linz21
	.byt >linz22
	.byt >linz23
	.byt >linz24
.skip 3
; dispatch table
;
ctable
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word stprun-1  ;stop/run
	.word ce-1      ;cancel
	.word cuser-1
	.word cuser-1
	.word bell-1    ;bell/-
	.word cuser-1
	.word tabit-1   ;tab/tab toggle
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word nxt1-1    ;return or shifted return
	.word ctext-1   ;text/graphic mode
	.word window-1  ;set top/bottom
	.word cuser-1
	.word cdnup-1   ;cursor down/up
	.word rvsf-1    ;rvs on/off
	.word homclr-1  ;home/clr
	.word delins-1  ;delete/insert character
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word cuser-1
	.word crtlf-1   ;cursor right/left
	.word cuser-1
	.word cuser-1
.skip 3
keylen	.byte key2-key1
	.byte key3-key2
	.byte key4-key3
	.byte key5-key4
	.byte key6-key5
	.byte key7-key6
	.byte key8-key7
	.byte key9-key8
	.byte key10-key9
	.byte keyend-key10
keydef
key1	.byte 'print'
key2	.byte 'list'
key3	.byte 'dload"'
key4	.byte 'dsave"'
key5	.byte 'dopen'
key6	.byte 'dclose'
key7	.byte 'copy'
key8	.byte 'directory'
key9	.byte 'scratch'
key10	.byte 'chr$('
keyend
.ski 3
;  bits  -  bit position table
;
bits
	.byte $80,$40,$20,$10,$08,$04,$02,$01
.pag
; ****** 6845 crtc text mode ******
.ski 2
atext	.byt $6c,$50,83,$0f ;phillps, hitachi buit-in monitor
	.byt $19,$03,$19,$19
	.byt $00,$0d,cursor,$0d
	.byt romimg,$00,romimg,$00,$00,$00
ntext	.byt 126,80,98,10,31,6,25,28,0,7,0,7 ;ntsc monitors
	.byt romimg,$00,romimg,$00,$00,$00
ptext	.byt 127,80,96,10,38,1,25,30,0,7,0,7 ;pal monitors
	.byt romimg,$00,romimg,$00,$00,$00
etext
.ski 2
;**************************************************
.ski 3
cksume	.byt $ff        ;e-page checksum
;**************************************************
; patch1 - checks for a single line window
;          aborts if so...
;**************************************************
;
patch1	ldx scbot       ;check
	cpx sctop
	bne patcha      ;no...pass through old code
	pla             ;abort
	pla
patcha	bit scrdis      ;restore patched area (test for scrolling mode)
	rts
.end
; -------------------------------------------------------------
; ##### monitor #####
.pag 'monitor 05/02/83'
;************************************************
;*                                              *
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
.pag 'monitor'
; reset entry
	* = $ee00
;
;*****warm start entry*******
;
monon	jsr ioinit      ;get i/o
	jsr restor      ;vectors
	jsr cint        ;screen editor
;
;*****cold start entry******
;
monoff
	jsr clrch       ;clear channels
	lda #winit      ;waste two bytes so timc=60950
	ldx #<monon     ;point reset vectors at monitor on
	ldy #>monon
	jsr vreset
	cli             ;release irq's
;
;*****call entry*****
;
timc	lda #$40+$80
	sta msgflg      ;error+messages on
	lda #ms34-ms1   ;call entry
	sta tmpc
	bne b3          ;branch always
;
;*****break entry*****
;
timb	jsr clrch       ;clr channels
	lda #ms36-ms1   ;break entry
	sta tmpc
	cld 
;
;save .y,.x,.a,flags, and pc
;
	ldx #5
b1	pla
	sta pch,x
	dex
	bpl b1
;
b3
	lda i6509       ;save indirection segment
	sta xi6509
	lda cinv
	sta invl        ;save irq low
	lda cinv+1
	sta invh        ;save irq high
;
	tsx
	stx sp          ;save original sp
	cli             ;clear ints
	lda #8          ;set disk default to 8
	sta ddisk
;
b5	ldy tmpc        ;message code
	jsr spmsg       ;print break/call
;
	lda #'r         ;display regs on entry
	bne s0          ;branch always
;
;*****error entry*****
;
erropr	jsr outqst
	pla
	pla
;
;*****command interpreter entry*****
;
strtm1=*-1
	lda #$40+$80
	sta msgflg      ;i/o messages to screen
	lda #<buf       ;put filename at bottom of basic buffer
	sta fnadr
	lda #>buf
	sta fnadr+1
	lda #irom
	sta fnadr+2
	jsr crlf
;
st1	jsr basin       ;read command
	cmp #'.'
	beq st1         ;skip prompt characters
	cmp #$20
	beq st1         ;span blanks
	jmp (usrcmd)    ;user indirect for monitor
;
;command interpreter
;
s0	ldx #0
	stx fnlen
	tay             ;save current command
;
;put return address for commands on stack
;
	lda #>strtm1
	pha
	lda #<strtm1
	pha
;
	tya             ;current command in .a
;
s1	cmp cmds,x      ;is it this one?
	bne s2          ;notit
;
	sta savx        ;save current command
;
;indirect jmp from table
;
	lda cmds+1,x
	sta tmp0
	lda cmds+2,x
	sta tmp0+1
	jmp (tmp0)
;
;each table entry is 3 long---skip to next
;
s2	inx
	inx
	inx
	cpx #cmdend-cmds
	bcc s1          ;loop for all commands
;
;command not in table...look on disk.
;command name can be any length and
;have parameters.
;
	ldx #0          ;length to zero
s3	cmp #$d         ;end of name?
	beq s4          ;yes...
	cmp #$20        ;blank?
	beq s4          ;yes
	sta buf,x
	jsr basin       ;get next
	inx             ;count char
	bne s3          ;and continue
;
s4	sta tmpc
	txa             ;count
	beq s6          ;is zero
;
	sta fnlen
	lda #$40
	sta msgflg      ;messages off
	lda ddisk       ;
	sta fa          ;will use default disk
	lda #irom       ;commands only load to rom segment !!!***
	sta i6509       ;turn indirect to rom segment
	ldx #$ff
	ldy #$ff
	jsr load        ;try to load command
	bcs s6          ;bad load...
;
	lda tmpc        ;pass last character
	jmp (stal)      ;go do it
;
s6	rts
.ski 3
cmds	.byt ':'        ;alter memory
	.wor altm
	.byt ';' ;alter registers
	.wor altr
	.byt 'r'        ;display registers
	.wor dsplyr
	.byt 'm'        ;display memory
	.wor dsplym
	.byt 'g'        ;start execution
	.wor go
	.byt 'l'        ;load memory
	.wor ld
	.byt 's'        ;save memory
	.wor ld
	.byt 'v'        ;view segment
	.wor view
	.byt '@'        ;disk command (alternate)
	.wor disk
	.byt 'z'        ;transfer to 2nd microprocessor
	.wor ipcgov     ;ipcgo vector
	.byt 'x'        ;warm start basic
	.wor xeit
	.byt 'u'        ;default disk unit set
	.wor unitd
cmdend
.ski 5
xeit	pla             ;remove command return from stack
	pla
	sei             ;disable interrupts...all warm start code expects
	jmp (evect)     ;go warmstart language
.ski 5
putp	lda tmp0        ;move tmp0 to pch,pcl
	sta pcl
	lda tmp0+1
	sta pch
	rts
.ski 5
setr	lda #<flgs      ;set to access regs
	sta tmp0
	lda #>flgs
	sta tmp0+1
	lda #irom       ;point indirect at roms
	sta i6509
	lda #5
	rts
.ski 5
;prints '.:' or '.;' before data to permit
;alter after 'm' or 'r' command
;
altrit	pha             ;preserve alter character
	jsr crlf
	pla
	jsr bsout
.ski 3
space	lda #$20        ;output a space
	.byt $2c        ;skip two bytes
outqst	lda #'?         ;output question
	jmp bsout       ;go print bytes
crlf	lda #$d         ;do carriage return
	jsr bsout
	lda #'.'        ;monitor prompt
	jmp bsout
.ski 5
;data for register display heading
;
regk	.byt cr,$20,$20 ;3 spaces
	.byt ' pc ',' irq ',' sr ac xr yr sp'
.ski 5
;display register function
;
dsplyr	ldx #0
d2	lda regk,x
	jsr bsout       ;print heading
	inx
	cpx #dsplyr-regk ;max length
	bne d2
	lda #';
	jsr altrit      ;allow alter after display
	ldx pch
	ldy pcl
	jsr wroa        ;print program counter
	jsr space
	ldx invh
	ldy invl
	jsr wroa        ;print irq vector
	jsr setr        ;set to print .p,.a,.x,.y,.s
;
;display memory subroutine
;
dm	sta tmpc        ;byte count
	ldy #0          ;indirect index
	sty fnlen       ;fnlen is zero-page crossing flag...
dm1	jsr space       ;space tween bytes
	lda (tmp0)y
	jsr wrob        ;write byte of memory
;
;increment indirect
;
	inc tmp0
	bne dm2
	inc tmp0+1
	bne dm2         ;no zero page crossing
	dec fnlen       ;fnlen<>0 is flag
;
dm2	dec tmpc        ;count bytes
	bne dm1         ;until zero
	rts
.ski 5
;display memory function
;
dsplym	jsr rdoae       ;read start adr...err if no sa
	jsr t2t2        ;sa to tmp2
;
;allow user to type just one address
;
	jsr rdoa        ;read end adr
	bcc dsp123      ;good...no default
;
	lda tmp2
	sta tmp0        ;default low byte
	lda tmp2+1
	sta tmp0+1      ;default hi byte
;
dsp123	jsr t2t2        ;sa to tmp0, ea to tmp2
dsp1	jsr stop        ;stop key?
	beq beqs1       ;yes...break list
;
	lda #':
	jsr altrit      ;allow alter
	ldx tmp0+1
	ldy tmp0
	jsr wroa        ;write start address
	.ifn system <
	lda #8          ;count of bytes
>
	.ife system <
	lda #16         ;count of bytes cbmii
>
	jsr dm          ;display bytes
;
;check for end of display
;
	lda fnlen       ;check for zero-crossing
	bne beqs1       ;yup....
	sec
	lda tmp2
	sbc tmp0
	lda tmp2+1
	sbc tmp0+1
	bcs dsp1        ;end >= start
;
beqs1	rts             ;a.o.k. exit
;
.ski 5
;alter register function
;
altr	jsr rdoae       ;read new pc...no address=error
;
	jsr putp        ;alter pc
;
	jsr rdoae       ;read new irq...no address=error
;
	lda tmp0
	sta invl        ;alter irq vector
	lda tmp0+1
	sta invh
;
	jsr setr        ;set to alter r's
	bne a4          ;branch always
.ski 2
;view a segment (point indirect)
;
view	jsr rdobe       ;get a byte...if none...error
	cmp #16         ;range 0-15
	bcs errl        ;to large no modulo
	sta i6509
	rts
.ski 2
;unit default for disk
;
unitd	jsr rdobe       ;get a byte...if none...error
	cmp #32         ;range 0-31
	bcs errl        ;to large no modulo
	sta ddisk
	rts
.ski 2
;alter memory - read adr and data
;
altm	jsr rdoae       ;read alter adr...if none...error
;
	.ifn system <
	lda #8          ;allow 8 bytes change
>
	.ife system <
	lda #16         ;allow 16 bytes change
>
;
;common code for ':' and ';'
;
a4	sta tmpc        ;number of bytes to change
;
a5	jsr rdob        ;read byte
	bcs a9          ;none...end of line
;
	ldy #0
	sta (tmp0)y     ;store it away
;
;increment store address
;
	inc tmp0
	bne a6
	inc tmp0+1
;
a6	dec tmpc        ;count byte
	bne a5          ;until zero
;
a9	rts
.ski 5
;start execution function
;
go	jsr rdoc        ;see if default
	beq g1          ;yes...pc is address
;
	jsr rdoae       ;no...get new addr...none=error
;
	jsr putp        ;move addr to p.c.
;
g1	ldx sp
	txs             ;orig or new sp value to sp
;
	sei             ;prevent disaster
;
	lda invh
	sta cinv+1      ;set up irq vector
	lda invl
	sta cinv
	lda xi6509      ;and indirection register
	sta i6509
;
;get flags,pch,pcl,.a,.x,.y
;
	ldx #0
g2	lda pch,x
	pha             ;everybody on stack
	inx
	cpx #6
	bne g2
;
;interrupt return sets everybody up
;from data on stack
;
	jmp prend
.ski 3
; rdobe - read a byte and error on line end..waste stack
;
rdobe	jsr rdob
	bcs errlpl
rdoxit	rts
;
; rdoae - read an address and error on line end...waste stack
;
rdoae	jsr rdoa
	bcc rdoxit
;
errlpl	pla             ;zap stack
	pla
errl	jmp erropr      ;syntax error jump
.ski 3
;load ram function
;  *note - load/save reset indirect to rom
;
ld	ldy #1
	sty fa          ;default device #1
	dey             ;.y=0 to count name length
	lda #$ff        ;default no move load
	sta tmp0
	sta tmp0+1
	lda i6509       ;save indirect for seg address
	sta t6509
	lda #irom       ;indirect to rom for filename
	sta i6509
;
l1	jsr rdoc        ;default?
	beq l5          ;yes...try load
;
	cmp #' 
	beq l1          ;span blanks
;
	cmp #'"         ;string next?
l2	bne errl        ;no file name...
;
l3	jsr rdoc        ;get character of name
	beq l5          ;end...asssume load
;
	cmp #'"         ;end of string?
	beq l8          ;yes...could still be 'l' or 's'
;
	sta (fnadr)y    ;store name
	inc fnlen
	iny
	cpy #16         ;max file name length
;
l4	beq errl        ;file name too long
	bne l3          ;branch always
;
;see if we got a load
;
l5	lda savx        ;get last command
	cmp #'l
	bne l2          ;no..not a load..error
;
	lda t6509       ;get segment to load to
	and #irom       ;mask off verify bit
	ldx tmp0
	ldy tmp0+1
	jmp load        ;yes...do load
;
l8	jsr rdoc        ;more stuff?
	beq l5          ;no...defualt load
;
	cmp #',         ;deleimeter?
l9	bne l2          ;no...bad syntax
;
	jsr rdobe       ;yes...get next parm...error if none
;
	sta fa
;
	jsr rdoc        ;more parms?
	beq l5          ;no...default load
;
	cmp #',         ;delimeter?
l12	bne l9          ;no...bad syntax
;
	jsr rdobe       ;segment byte ?...must have
	cmp #16         ;00-0f allowed
	bcs l15         ;too big...
	sta t6509
	sta stas        ;prep segment
	jsr rdoae       ;start address?...must have
;
;set up start save address
;
	lda tmp0
	sta stal
	lda tmp0+1
	sta stah
;
	jsr rdoc        ;delimeter?
	beq l5          ;cr, do load
	cmp #',
	bne l15         ;no delim
;
	jsr rdobe       ;get segment byte...must have
	cmp #16         ;allow only 00-0f
	bcs l15         ;too big...
	sta eas         ;prep segment
	jsr rdoae       ;try to read end address...must have
;
;set up end save address
;
	lda tmp0
	sta eal
	lda tmp0+1
	sta eah
;
l20	jsr basin
	cmp #$20
	beq l20         ;span blanks
;
	cmp #cr
l14	bne l12         ;missing cr at end
	lda savx        ;was command save?
	cmp #'s
	bne l14         ;no...load can't have parms
	ldx #stal       ;get params for save
	ldy #eal
	jmp save
;
l15	jmp erropr
.ski 5
;write adr from tmp0 stores
;
wroa	txa             ;hi-byte
	jsr wrob
	tya             ;low-byte
.ski 3
;write byte --- a = byte
;unpack byte data into two ascii
;characters. a=byte; x,a=chars
wrob	pha
	lsr a
	lsr a
	lsr a
	lsr a
	jsr ascii       ;convert to ascii
	tax
	pla
	and #$0f
.ski 3
;convert nybble in a to ascii and
;print it
;
ascii	clc
	adc #$f6
	bcc asc1
	adc #$06
asc1	adc #$3a
	jmp bsout
.ski 5
;exchange temporaries
;
t2t2	ldx #2
t2t21	lda tmp0-1,x
	pha
	lda tmp2-1,x
	sta tmp0-1,x 
	pla
	sta tmp2-1,x
	dex
	bne t2t21
	rts
.ski 5
;read hex adr,return hi in tmp0,
;lo in tmp0+1,and cy=1
;if sp cy=0
;
rdoa	jsr rdob        ;read 2-char byte
	bcs rdoa2       ;space
	sta tmp0+1
	jsr rdob
	sta tmp0
rdoa2	rts
;read hex byte and return in a
;and cy=0 if sp cy=1
rdob	lda #0          ;space
	sta bad         ;read next char
	jsr rdoc
	beq rdob4       ;fail on cr
	cmp #'          ;blank?
	beq rdob        ;span blanks...
;
	jsr hexit       ;convert to hex nybble
	asl a
	asl a
	asl a
	asl a
	sta bad
	jsr rdoc        ;2nd char assumed hex
	beq rdob4       ;fail on cr
	jsr hexit
	ora bad
;
rdob4	rts
.ski 5
;convert ascii char to hex nybble
;
hexit	cmp #$3a
	php             ;save flags
	and #$0f
	plp
	bcc hex09       ;0-9
	adc #8          ;alpha add 8+cy=9
hex09	rts
.ski 5
;get character and test for cr
;
rdoc	jsr basin
	cmp #$0d        ;is it a cr
	rts             ;return with flags
.ski 5
;send disk command or read status
;
disk	lda #0          ;clear status @ i/o begin
	sta status
	sta fnlen       ;filename length of zero...
;
	ldx ddisk       ;get default disk
	ldy #$0f        ;open command channel
	jsr setlfs      ;.a-0 temporary channel #
	clc
	jsr open        ;open a real channel
	bcs disk30      ;exit if bad return
;
	jsr rdoc        ;see if status check
	beq disk20      ;yes
;
	pha
	ldx #0
	jsr ckout       ;set up as output
	pla
	bcs disk30      ;bad status return
	bcc disk15      ;no...ok
;
disk10	jsr basin       ;get a character
disk15	cmp #$d         ;see if end
	php             ;save for later
	jsr bsout       ;out to floppy
	lda status
	bne disk28      ;bad status returned
	plp             ;end?
	bne disk10      ;no...continue
	beq disk30      ;yes...floppy done
;
disk20	jsr crlf
	ldx #0
	jsr chkin       ;tell floppy to speak
	bcs disk30      ;bad device
;
disk25	jsr rdoc        ;get a character
	php             ;save test for later
	jsr bsout       ;out to screen
	lda status      ;check for bad basin
	and #$ff-$40    ;remove eoi bit
	bne disk28      ;report bad status
	plp             ;end?
	bne disk25      ;no...
	beq disk30      ;yes...floppy done
;
disk28	pla             ;clean up...
disk29	jsr error5      ;report error #5 for bad device
disk30	jsr clrch       ;clean up
	lda #0
	clc             ;just remove from table
	jmp close
.end
; -------------------------------------------------------------
; ##### messages #####
.pag 'messages'
ms1	.byt $d,'i/o error ',$a3
ms5	.byt $d,'searching',$a0
ms6	.byt 'for',$a0
;ms7 .byt $d,'press play on tap',$c5
;ms8 .byt 'press record & play on tap',$c5
ms10	.byt $d,'loadin',$c7
ms11	.byt $d,'saving',$a0
ms21	.byt $d,'verifyin',$c7
ms17	.byt $d,'found',$a0
ms18	.byt $d,'ok',$8d
	.ife sysage <
ms34	.byt $d,'** monitor 1.0 **',$8d
ms36	.byt $d,'brea',$cb
>
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
; ##### ieee #####
.page 'ieee 04/29/83'
;        command ieee-488 device to talk
;       
ntalk	ora #tlkr       ;make a talk adr
	bne list1       ;always go to list1
.skip 4
;        command ieee-488 device to listen
;       
nlistn	ora #lstnr      ;make a listen adr
;       
list1	pha             ;save device and talk/listen
;       
	lda #tddb       ;set control for atn/data out
	sta tpi1+ddpa
;
	lda #$ff        ;set direction for transmitt *
	sta cia+pra     ;set data   *
	sta cia+ddra    ;set data direction out   *
	lda #$ff-dc-ren ;enable transmitt
	sta tpi1+pa
	lda c3po        ;get ieee flags
	bpl list2       ;if data in buffer
;       
	lda tpi1+pa     ;send eoi
	and #$ff-eoi
	sta tpi1+pa
;       
	lda bsour       ;get byte to send
	jsr tbyte       ;send last character
;       
	lda c3po        ;clear byte in buffer flag
	and #$ff-dibf
	sta c3po
;       
	lda tpi1+pa     ;clear eoi
	ora #eoi
	sta tpi1+pa
;       
list2	lda tpi1+pa     ;assert atn
	and #$ff-atn
	sta tpi1+pa
;       
	pla             ;get talk/listen address
	jmp tbyte
.skip 4
;        send secondary address after listen
;       
nsecnd	jsr tbyte       ;send it
;       
;        release attention after listen
;       
scat1
;
scatn	lda tpi1+pa     ;de-assert atn
	ora #atn
	sta tpi1+pa
	rts
.skip 4
;        talk second address
;       
ntksa	jsr tbyte       ;send secondary address
;
tkatn
	lda #$ff-nrfd-ndac-te-ren ;pull nrfd and ndac low
	and tpi1+pa
setlns	;exit entry for untalk/unlisten
	sta tpi1+pa
	lda #rddb       ;set control lines for input
	sta tpi1+ddpa
	lda #$00        ;set data lines for recieve
	sta cia+ddra
	beq scatn
.skip 4
;
;        buffered output to ieee-488
;
nciout	pha             ;save data
	lda c3po        ;get ieee flags
	bpl ci1         ;if no data in buffer
	lda bsour       ;get data in buffer
	jsr tbyte       ;transmit byte
	lda c3po        ;get ieee flags
;
ci1	ora #dibf       ;set data in buffer flag
	sta c3po
;
	pla             ;get new data
	sta bsour
	rts
.skip 4
;        send untalk command on ie
;       
nuntlk
	lda #utlkr      ;untalk command
	bne unls1       ;always
.skip 4
;        send unlisten command on ieee-488
;       
nunlsn	lda #ulstn      ;unlisten command
unls1	jsr list1       ;send it
	lda #$ff-te-ren ;set for recieve all lines high
	jmp setlns      ;go setup proper exit state
;
.skip 4
;        tbyte -- output byte onto ieee bus.
;       
;        entry a = data byte to be output.
;       
;        uses a register.
;        1 byte of stack space.
;       
tbyte
	eor #$ff        ;compliment data
	sta cia+pra
;
	lda tpi1+pa
	ora #dav+te     ;say data not valid, te=data out
	sta tpi1+pa
;       
	bit tpi1+pa     ;test nrfd & ndac in high state
	bvc tby2        ;either nrfd or ndac low => ok
	bpl tby2
;       
tby1	lda #nodev      ;set no-device bit in status
	jsr udst
	bne tby7        ;always exit
;       
tby2	lda tpi1+pa
	bpl tby2        ;if nrfd is high
;       
	and #$ff-dav
	sta tpi1+pa
;       
tby3	jsr timero      ;set timeout
	bcc tby4        ;c-clear means first time through
tby3t	sec             ;c-set is second time
;
tby4	bit tpi1+pa
	bvs tby6        ;if ndac hi
	lda cia+icr
	and #$02        ;timer b posistion (cia)
	beq tby4        ;if no timeout
	lda timout      ;timeout selection flag
	bmi tby3        ;no - loop
	bcc tby3t       ;wait full 64us
;       
tby5	lda #toout      ;set timeout on output in status
	jsr udst        ;update status
;       
tby6	lda tpi1+pa     ;release dav
	ora #dav
	sta tpi1+pa
;       
tby7	lda #$ff        ;release data bus
	sta cia+pra     ;bus failure exit
	rts
.skip 4
;        rbyte -- input byte from ieee bus.
;       
;        uses a register.
;        1 byte of stack space.
;       
;        exit a = input data byte.
;       
nacptr	;********************************
nrbyte
	lda tpi1+pa     ;set control lines
	and #$ff-te-ndac-ren ;pull ndac low, te=data in
	ora #nrfd+dc    ;say read for data
	sta tpi1+pa
;
rby1	jsr timero      ;return c-clear for cbmii
	bcc rby2        ;c-clear is first time through
rby1t	sec             ;c-set is second time through
;       
rby2	lda tpi1+pa     ;get ieee control lines
	and #dav
	beq rby4        ;if data available
	lda cia+icr
	and #$02        ;timer b (cia)
	beq rby2        ;if not timed out
	lda timout      ;get timeout flag
	bmi rby1        ;loop
	bcc rby1t       ;go through twice
;
rby3	lda #toin       ;set timeout on input in status
	jsr udst
	lda tpi1+pa
	and #$ff-nrfd-ndac-te ;nrfd & ndac lo on error
	sta tpi1+pa
	lda #cr         ;return null input
	rts
.skip 2
rby4
	lda tpi1+pa     ;say not read for data
	and #$ff-nrfd
	sta tpi1+pa
	and #eoi
	bne rby5        ;if not eoi
	lda #eoist      ;set eoi in status
	jsr udst
;       
rby5	lda cia+pra     ;get data
	eor #$ff
;       
rby6	pha             ;save data
	lda tpi1+pa     ;say data accepted
	ora #ndac
	sta tpi1+pa
;       
rby7	lda tpi1+pa     ;get ieee control lines
	and #dav
	beq rby7        ;if dav high
;       
	lda tpi1+pa     ;say dat not accpted
	and #$ff-ndac
	sta tpi1+pa
	pla             ;return data in a
	rts
;
; set up for timeout (6526)
;
	.ife system <
timero	lda #$ff        ;set timer for at least 32us
>
	.ifn system <
timero	lda #$80        ;set time for at least 32us
>
	sta cia+tbhi
	lda #$11        ;turn on timer continous in case of other irq's
	sta cia+crb
	lda cia+icr     ;clear interrupt
	clc
	rts
.end
; -------------------------------------------------------------
; ##### rs232 #####
.pag 'rs232 routines 11/20/81'
rs232	jmp error9      ;bad device number
.ski 5
;---------------------------------------------
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
;
;    actions:
;  1. clear  rs232 status:  rsstat
;  2. set 6551 contrl (ctr) register
;  3. set 6551 command (cdr) register
;       cdr bits (7-4) = filename byte 2 bits (7-4)
;                (3-2) = 00  (xmitter off)
;                (1)   = 1   (receiver off)
;                (0)   = 0   (dtr off)
;  4. do buffer allocation, if needed
;
;---------------------------------------------
opn232	jsr rst232      ;reset rs232 status
	ldy #0
;
opn020	cpy fnlen       ;filename all out ?
	beq opn030      ;yes...
;
	jsr fnadry
	sta m51ctr,y
	iny
	cpy #4          ;only four bytes in all
	bne opn020
;
opn030	lda m51ctr      ;set the register
	sta acia+ctr
	lda m51cdr      ;clear up conflicts
	and #$f2
	ora #$02
	sta acia+cdr    ;everything off
	clc
	lda sa          ;check for buffers needed
	and #$02
	beq opn045      ;no input
;
	lda ridbe       ;set up pointers
	sta ridbs
	lda ribuf+2     ;check for allocation
	and #$f0        ;$ff not allocated flag (see alloc error codes, too)
	beq opn045      ;already allocated
	jsr req256      ;request 256 bytes for storage
	sta ribuf+2     ;save starting
	stx ribuf
	sty ribuf+1
opn045	bcc opn050
	jmp errorx
opn050	rts             ;c-clr already allocated
.pag 'rs232 - conversions'
;----------------------------------------
; toasci - convert cbm text code to
;  ascii for valid ascii ranges.
; entry: .a - cbm text code
; exit : .a - ascii code
;----------------------------------------
toasci	cmp #'a'        ;convert $41 to $5a
	bcc toa020
	cmp #$5b
	bcs toa010
	ora #$20        ; to lower case ascii
toa010	cmp #$c1        ;convert $c1 to $da
	bcc toa020
	cmp #$db
	bcs toa020
	and #$7f        ; to upper case ascii
toa020	rts
.ski 3
;----------------------------------------
; tocbm - convert ascii code to cbm
;  text code for valid ascii ranges.
; entry: .a - ascii code
; exit : .a - cbm text code
;----------------------------------------
tocbm	cmp #'a'        ;convert upper case ascii
	bcc toc020
	cmp #$5b
	bcs toc010
	ora #$80        ; to $c1 to $da
toc010	cmp #$61        ;convert lower case ascii
	bcc toc020
	cmp #$7b
	bcs toc020
	and #$ff-$20    ;to $41 - $5a
toc020	rts
.ski 3
;---------------------------------------------------------------
;  xon232 - turn 6551 transmitter on, no transmit interrupts
;        cdr bits(3-2) = 10
;            bit(1)    = 1
;---------------------------------------------------------------
xon232	lda acia+cdr
	ora #$09
	and #$fb
	sta acia+cdr
	rts
.pag 'rs232 - allocate'
; req256 - request 256 bytes of space
;  (don't care where we get it...)
;
req256	; lda #$ff
	ldx #00
	ldy #01
.ski 3
;-----------------------------------------------------------------------
; alocat - allocate space
;  entry:
; *  .a- if .a=$ff then don't care what segment
; *  .a- if .a=$80 then we want bottom of memory
; *  .a- if .a=$40 then we want top of memory
; *  .a- if .a=$0x then we need segment x
;    .x- low # of bytes needed
;    .y- high # of bytes needed
;
;  exit :
;    c-clr  no problem allocating space
;     .a,.x,.y is start address of allocated space
;    c-set  problem with allocation
;     if .a =$ff then allocation refused (cannot cross segment boundrys)
; *   if .a =$8x then bottom of memory needs to be changed
;     if .a =$4x then top of memory needs to be changed
; *   if .a =$c0 then bottom>top  !! fatal error !!
;     return to language
;
; *=> not implemented yet  10/30/81 rsr (only top allocation)
;-----------------------------------------------------------------------
alocat
;
;
tttop	txa             ;calc new hiadr
	sec
	eor #$ff
	adc hiadr
	tax
	tya
	eor #$ff
	adc hiadr+1
	tay
	lda hiadr+2
	bcs top010
;
refuse	lda #$ff        ;allocation refused...crossed boundry
topbad	ora #$40        ;want top of memory changed
	sec
	rts
;
top010	cpy memsiz+1
	bcc topbad      ;below...
	bne topxit
	cpx memsiz
	bcc topbad      ;below...
topxit	stx hiadr
	sty hiadr+1
	clc
	rts
.ski 5
;----------------------------------------------------------------
; rst232 - reset rs232 and dcd/dsr status
;          note, the dcd and dsr bits of rsstat reflect whether a
;          dsr or dcd error occured since the last time the user
;          examined rsstat.
;          dcdsr has the dcd/dsr states prior to their last state
;          changes.
;-----------------------------------------------------------------
rst232	php
	sei             ;disable ints
	lda acia+srsn
	and #$60
	sta rsstat
	sta dcdsr
	plp
	rts
.end
; -------------------------------------------------------------
; ##### channelio #####
.pag 'channel i/o'
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
;
ngetin	lda dfltn       ;check device
	bne gn10        ;not keyboard
;
	lda ndx         ;queue index
	ora kyndx       ;check function key que
	beq gn20        ;nobody there...exit
;
	sei
	jsr lp2         ;go remove a character
	clc
	rts
;
gn10	cmp #2          ;is it rs-232
	beq gn232
	jmp basin       ;no...use basin
;
gn232	sty xsav        ;save .y...
	stx savx        ;..and .x
	ldy ridbs       ;get last byte address
	cpy ridbe       ;see if buffer emptyy
	bne gn15        ;rs232 buffer not empty...
;
	lda acia+cdr    ;make sure receiver is on
	and #$fd
	ora #$01        ;bits(10) = 01 now
	sta acia+cdr
	lda rsstat      ;set empty input buffer condition
	ora #$10
	sta rsstat
	lda #0          ;return a null byte
	beq gnexit      ;always
;
gn15	lda rsstat      ;clear empty buffer status
	and #$ef
	sta rsstat
	ldx i6509
	lda ribuf+2
	sta i6509       ; point at buffer
	lda (ribuf)y    ;get last char
	stx i6509       ; restore
	inc ridbs       ;inc to next posistion
	bit sa          ;check for ascii flag
	bpl gnexit      ;not on...
	jsr tocbm       ;convert to cbm code
gnexit	ldy xsav        ;restore .y
	ldx savx
gn20	clc             ;good return
	rts
.pag 'channel i/o'
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
	jmp bn15        ;blink cursor until return
;
bn10	cmp #3          ;is input from screen?
	bne bn20        ;no...
;
	sta crsw        ;fake a carriage return
	lda scrt        ;say we ended...
	sta indx        ;...up on this line
bn15	jsr loop5       ;pick up characters
	clc
	rts
;
bn20	bcs bn30        ;devices >3
	cmp #2          ;rs232?
	beq bn50
;
;input from cassette buffers
;
	.ifn sysage <
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
jtg37	rts             ;error return c-set from jtget
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
jtg10	jsr tapery      ;get char from buffer
	clc             ;good return
	rts
>
	.ife sysage <
	jsr xtape       ;go to tape indirect
>
.ski 3
;input from ieee   bus
;
bn30	lda status      ;status from last
	beq bn35        ;was good
bn31	lda #$d         ;bad...all done
bn32	clc             ;valid data
bn33	rts
;
bn35	jsr acptr       ;good...handshake
	clc
	rts
;
;input from rs232
;
bn50	jsr getin       ;get data
	bcs bn33        ;error return
	cmp #00         ;non-null means good data always
	bne bn32        ;have valid data
	lda rsstat      ;check for valid null byte
	and #$10
	beq bn32        ;ok
	lda rsstat      ;buffer empty, check for errors in dsr, dcd
	and #dsrerr+dcderr
	bne bn31        ;have error...send c/r's
	jsr stop        ;check for stop key depressed
	bne bn50        ;no, stay in loop 'til we get something
	sec             ;.a=0, stop key error
	rts
.pag 'channel output'
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
;
nbsout	pha             ;preserve .a
	lda dflto       ;check device
	cmp #3          ;is it the screen?
	bne bo10        ;no...
;
;print to crt
;
	pla             ;restore data
	jsr prt         ;print on crt
	clc
	rts
;
bo10
	bcc bo20        ;device 1 or 2
;
;print to ieee   bus
;
	pla
	jsr ciout
	clc
	rts
;
;print to cassette devices
;
bo20	cmp #2          ;rs232?
	beq bo50
;
	pla
	.ifn sysage <
casout	sta t1
;
;preserve registers
;
	pha
	txa
	pha
	tya
	pha
;
	jsr jtp20       ;check buffer pointer
	bne jtp10       ;has not reached end
	jsr wblk        ;write full buffer
	bcs rstor       ;abort on stop key
;
;put buffer type byte
;
	lda #bdf
	jsr tapzwy      ;write to buffer beginning
;
;reset buffer pointer
;
	iny             ;make .y=1
	sty bufpt       ;bufpt=1
;
jtp10	lda t1
	jsr tapewy      ;data to buffer
;
;restore .x and .y
;
	clc             ;good return
rstor	pla
	tay
	pla
	tax
>
	.ife sysage <
	jsr xtape       ;go to tape indirect
>
rstbo	pla             ;restore .a (error exit for 232)
	bcc rstor1      ;no error
	lda #00         ;stop error if c-set
rstor1	rts
;
;output to rs232
;
bo50	stx t1          ;put in a temp
	sty t2
;
bo55	lda rsstat      ;check for dsr,dcd errors
	and #$60
	bne bo90        ;bad....
;
bo70	pla             ;restore data
	bit sa          ;check for cbm to ascii conversion
	bpl bo80        ;none
	jsr toasci      ;convert cbm to ascii
bo80	sta acia+drsn   ;sending data
	pha
;
bo60	lda rsstat
	and #$60        ;dcd,dsr errors?
	bne bo90        ;yes...
bo64	lda acia+srsn
	and #$10        ;transmit buffer empty?
	bne bo90        ;yes, transmit done!
	jsr stop        ;check for stop key
	bne bo60        ;try again
bo66	sec             ;stop key/error return
	bcs rstbo       ;exit....
;
bo90	pla
	ldx t1          ;go restore
	ldy t2
	clc
	rts
.end
; -------------------------------------------------------------
; ##### openchannel #####
.pag 'open channel'
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
; rs232 channel
;
	lda sa
	and #02         ;check for input
	beq jx316       ;not input file
	and acia+cdr    ;check if running
	beq jx312       ;is...done ?? (rceiver on => yes)
	eor #$ff        ;flip all bits
	and acia+cdr    ;turn on...
	ora #$01        ;turn on dtr ;bits(10)=01
	pha
	jsr rst232      ;reset rs232 status
	pla
	sta acia+cdr    ;set command
jx312	lda #2          ;device
	bne jx320       ;bra...done
;
;some extra checks for tape
;
jx315
	.ifn sysage <
	ldx sa
	cpx #$60        ;is command a read?
	beq jx320       ;yes...o.k....done
>
	.ife sysage <
	jsr xtape       ;goto tape indirect
>
;
jx316	jmp error6      ;not input file
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
; rs232 output
;
	lda sa          ;check if output file
	lsr a
	bcc ck20        ;not so...
	jsr rst232      ;reset rs232 status
	jsr xon232      ;make sure transmit is on
	lda #2          ;device#
	bne ck30        ;bra...done
;
;special tape channel handling
;
	.ife sysage <
ck15	jsr xtape       ;goto system tape indirect
>
	.ifn sysage <
ck15	ldx sa
	cpx #$60        ;is command read?
	beq ck20        ;yes...error
>
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
.pag 'close  2/15/83'
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
;
nclose	php             ;save cy flag
	jsr jltlk       ;look file up
	beq jx110       ;was open...continue
	plp
	clc             ;was never open...no error
	rts
;
jx110	jsr jz100       ;extract table data
	plp             ;retrieve cy flag
	txa             ;save table index
	pha
	bcc jx150       ;close out table entries only
;
	lda fa          ;check device number
	beq jx150       ;is keyboard...done
	cmp #3
	beq jx150       ;is screen...done
	bcs jx120       ;is ieee...process
	cmp #2          ;rs232?
	bne jx115       ;no...
;
; close rs-232 file
;
cls232	lda #0
	sta acia+cdr    ;do a soft reset
	beq jx150       ;jmp...remove file
;
;
;close cassette file
;
	.ifn sysage <
jx115	lda sa          ;was it a tape read?
	and #$f
	beq jx150       ;yes
;
	jsr zzz         ;no. . .it is write
	lda #0          ;end of file character
	jsr casout      ;put in end of file
	jsr wblk        ;empty last buffer
	bcs jx200       ;stop key pressed
;
	lda sa
	cmp #$62        ;write end of tape block?
	bne jx150       ;no...
;
	lda #eot
	jsr tapeh       ;write end of tape block
	jmp jx150
>
	.ife sysage <
jx115	pla             ;cassette now closes the channel...
	jsr jx151       ;before transmitting out the final data
	jsr xtape       ;goto tape indirect
>
;
;close an ieee file
;
jx120	jsr clsei
;
;entry to remove a give logical file
;from table of logical, primary,
;and secondary addresses
;
jx150	pla             ;get table index off stack
jx151	tax             ;entry for cassette special
	dec ldtnd
	cpx ldtnd       ;is deleted file at end?
	beq jx160       ;yes...done
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
jx160	clc
jx170	rts             ;close exit
	.ifn sysage <
jx200	tax             ;stop key exit
	pla
	txa             ;restore error
	rts
>
.ski 5
;lookup tablized logical file data
;
lookup	lda #0
	sta status
	txa
jltlk	ldx ldtnd
jx600	dex
	bmi lkups4
	cmp lat,x
	bne jx600
	clc
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
.ski 5
;
;sa is passed in .y
;routine looks for match in tables
;carry set if not present
;carry clear:
;.a=la,.x=fa,.y=sa
;
lkupsa	tya
	ldx ldtnd
lkups2	dex
	bmi lkups4
	cmp sat,x
	bne lkups2
	clc
lkups3	jsr jz100       ;get table data
	tay
	lda la
	ldx fa
	rts
lkups4	sec
	rts             ;not found exit
.ski 5
;la is passed in .a
;routine looks for match in tables
;carry set if not found
;carry clear:
;.a=la,.x=fa,.y=sa
;
lkupla	tax
	jsr lookup
	bcc lkups3
	rts
.end
; -------------------------------------------------------------
; ##### clall #####
.pag 'clall 05/31/83'
;******************************************
;* nclall -- close all logical files      *
;*      deletes all table entries and     *
;* restores default i/o channels          *
;* and clears ieee port devices           *
;******************************************
;
;------------------------------------------
; new ncall
;  closes all files untill done or an
;  error occurs.
;  entry:
;    c-clr => close all files
;    c-set => .a = fa (device to be closed)
;------------------------------------------
nclall	ror xsav        ;save carry
	sta savx        ;save .a
ncl010	ldx ldtnd       ;scan index
ncl020	dex
	bmi nclrch      ;all done...clear channels (dclose patch 5/31/83)
	bit xsav        ;check for fixed fa
	bpl ncl030      ;none...
	lda savx
	cmp fat,x
	bne ncl020      ;no match...
ncl030	lda lat,x       ;close this la
	sec             ;c-set required to close
	jsr close
	bcc ncl010      ;
;
ncl040	lda #0          ;original entry for nclall
	sta ldtnd       ;forget all files
.ski 3
;********************************************
;* nclrch -- clear channels                 *
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
clall2	ldx #3
	stx dflto       ;output chan=3=screen
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
;
nopen
	bcc op000       ;do open
	jmp tranr       ;do transmit
.ski 4
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
;
op000	ldx la          ;check file #
;bne op98 ;is not the keyboard
;
;jmp error6 ;not input file...
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
	ora #$60        ;make sa an ieee command
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
	jsr openi       ;is on ieee...open it
	bcc op175       ;branch always...done
;
;perform tape open stuff
;
op150	cmp #2
	bne op152
;
	jmp opn232
;
	.ifn sysage <
op152	jsr zzz         ;see if tape buffer
	bcs op180       ;error returned
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
	bcs op180       ;exit if stop key pressed...
;
;finish open for tape read/write
;
op171
	lda #bufsz-1    ;assume force read
;
	ldy sa
	cpy #$60        ;open for read?
	beq op172
;
;set pointers for buffering data
;
	lda #bdf        ;type flag for block
	jsr tapzwy      ;to begin of buffer
	tya
;
op172	sta bufpt       ;point to data
>
	.ife sysage <
op152	jsr xtape       ;goto tape device indirect
>
op175	clc             ;flag good open
op180	rts             ;exit in peace
.ski 5
openi	lda sa
	bmi op50        ;no sa...done
;
	ldy fnlen
	beq op50        ;no file name...done
;
	lda fa
	jsr listn       ;device la to listen
;
	lda sa
	ora #$f0
openib	jsr secnd
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
;send file name over ieee
;
	ldy #0
op40	jsr fnadry
	jsr ciout
	iny
	cpy fnlen
	bne op40
;
op45	jsr unlsn
;
op50	clc             ;no  error
	rts
.ski 4
;*****************************************
;*  transmit command to device           *
;*                                       *
;*   fnlen,fnadr must be set up already  *
;*   to contain the command string.      *
;*   fa must be set for the device.      *
;*****************************************
tranr
	lda fa
	jsr listn
	lda #$6f
	sta sa
	jmp openib
.end
; -------------------------------------------------------------
; ##### load #####
.pag 'load function'
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
.ski 3
nload	stx relsal      ;save alt address
	sty relsah
	sta verck       ;set verify flag (n)
	sta relsas      ;save start address
	lda #0          ;clear status
	sta status
;
	lda fa          ;check device number
	bne ld20
;
ld10	jmp error9      ;bad device #-keyboard
;
ld20	cmp #3
	beq ld10        ;disallow screen load
	bcs *+5
	jmp ld100       ;handle tapes different
;
;load from cbm ieee device
;
	lda #$60        ;special load command
	sta sa
;
	ldy fnlen       ;must have file name
	bne ld25        ;yes...ok
;
	jmp error8      ;missing file name
;
ld25	jsr luking      ;tell user looking
	jsr openi       ;open the file
;
	lda fa
	jsr talk        ;establish the channel
	lda sa
	jsr tksa        ;tell it to load
;
	jsr acptr       ;get first byte
	sta eal
	sta stal
;
	lda status      ;test status for error
	lsr a
	lsr a
	bcc *+5         ;file  found...
;
	jmp error4      ;file not found error
;
	jsr acptr
	sta eah
	sta stah
;
	jsr loding      ;tell user loading
;
;
;test for fixed or moveable load
;
	lda relsas      ;no segment byte in storage ***
	sta eas
	sta stas
	lda relsal
	and relsah
	cmp #$ff
	beq ld40        ;fixed load
;
	lda relsal
	sta eal
	sta stal
	lda relsah
	sta eah
	sta stah
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
; change indirect pages
	ldx i6509
	ldy eas
	sty i6509
	ldy #0
	bit verck       ;performing verify?
	bpl ld50        ;no...load
	sta sal         ;use as a temp
	lda (eal)y
	cmp sal
	beq ld60        ;okay
	lda #sperr      ;no good...verify error
	jsr udst        ;update status
	.byt $ad        ;skip next store
;
ld50	sta (eal)y
ld60	stx i6509       ;restore indirect
	inc eal         ;increment store addr
	bne ld64
	inc eah
	bne ld64
	inc eas
	lda #2          ;skip $0000 $0001
	sta eal
ld64	bit status      ;eoi?
	bvc ld40        ;no...continue load
;
	jsr untlk       ;close channel
	jsr clsei       ;close the file
	jmp ld180       ;exit ieee load
;
ld90	jmp error4      ;file not found
;
;load from tape
;
	.ifn sysage <
ld100	cmp #2
	bne ld102
;
	jmp rs232
;
ld102	jsr zzz         ;set pointers at tape1
	bcs ld104
	jsr cste1       ;tell user about buttons
	bcc ld105
ld104	rts             ;stop key pressed
ld105	jsr luking      ;tell user searching
;
ld112	lda fnlen       ;is there a name?
	beq ld150       ;none...load anything
	jsr faf         ;find a file on tape
	bcc ld170       ;got it!
	beq ld190       ;stop key pressed
	bcs ld90        ;nope...end of tape
;
ld150	jsr fah         ;find any header
	bcc ld170
	beq ld190       ;stop key pressed
	bcs ld90        ;no header
;
ld170	cpx #blf        ;is it a program
	bne ld112       ;no...something else
;
	lda status
	and #sperr      ;must got header right
;carry set from last cpx
	bne ld112       ;is bad...retry
;
	ldy #1
	jsr tapery
	sta stal
	jsr tapiry
	sta stah
	jsr tapiry
	sta eal
	jsr tapiry
	sta eah
;
;determine fixed or moveable load
;
	lda relsas      ;set up indirect
	sta eas
	sta stas
	lda relsal
	and relsah
	cmp #$ff
	beq ld175       ;fixed load
;
	sec
	lda eal         ;compute length
	sbc stal
	sta eal
	lda eah
	sbc stah
	sta eah
	clc
	lda relsal      ;compute new end
	sta stal
	adc eal
	sta eal
	lda relsah
	sta stah
	adc eah
	sta eah
;
ld175	jsr loding      ;tell user loading
	jsr trd         ;do tape block load
	.byt $24        ;carry from trd
>
	.ife sysage <
ld100	jsr xtape       ;goto tape indirect
>
;
ld180	clc             ;good exit
;
;set up end load address
;
	lda eas
	ldx eal
	ldy eah
;
ld190	rts
.ski 5
;subroutine to print to console:
;
;searching [for name]
;
luking	bit msgflg      ;supposed to print?
	bpl ld115
	ldy #ms5-ms1    ;"searching"
	jsr spmsg
	lda fnlen
	beq ld115
	ldy #ms6-ms1    ;"for"
	jsr spmsg
.ski 3
;subroutine to output file name
;
outfn	ldy fnlen       ;is there a name?
	beq ld115       ;no...done
	ldy #0
ld110	jsr fnadry
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
	bpl ld410       ;are doing load
	ldy #ms21-ms1   ;are 'verifying'
ld410	jmp spmsg
.end
; rsr  fix segmentation 10/15/81
; rsr  6509 changes  10/15/81
; -------------------------------------------------------------
; ##### save #####
.pag 'save function'
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
.ski 3
nsave	lda 0,x         ;get start vector
	sta stal
	lda 1,x
	sta stah
	lda 2,x
	sta stas
	tya
	tax
	lda 0,x         ;get end vector
	sta eal
	lda 1,x
	sta eah
	lda 2,x
	sta eas
;
	lda fa
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
	ldx i6509       ;indirects switched by rd300
	jsr rd300
	lda sal
	jsr ciout
	lda sah
	jsr ciout
;
	ldy #0
sv30	jsr cmpste      ;compare start to end
	bcs sv50        ;have reached end
	lda (sal)y
	jsr ciout
	jsr incsal
	jsr stop
	bne sv30
;
	stx i6509       ;restore indirects
break	jsr clsei
	lda #0
	sec
	rts
;
sv50	stx i6509       ;restore indirects
	jsr unlsn
.ski 3
clsei	bit sa
	bmi clsei2
	lda fa
	jsr listn
	lda sa
	and #$ef
	ora #$e0
	jsr secnd
	jsr unlsn
;
clsei2
sv110	clc
sv115	rts
.ski 3
	.ifn sysage <
sv100	cmp #2
	bne sv102
;
	jmp rs232
;
sv102	jsr zzz         ;get addr of tape
	bcs sv115       ;buffer is deallocated...exit
	jsr cste2
	bcs sv115       ;stop key pressed
	jsr saving      ;tell user 'saving'
sv105	lda #blf
	jsr tapeh
	bcs sv115       ;stop key pressed
	jsr twrt
	bcs sv115       ;stop key pressed
	lda sa
	and #2          ;write end of tape?
	beq sv110       ;no...
;
	lda #eot
	jmp tapeh
>
	.ife sysage <
sv100	jsr xtape       ;goto tape device
>
.ski 3
;subroutine to output:
;'saving <file name>'
;
saving	lda msgflg
	bpl sv115       ;no print
;
	ldy #ms11-ms1   ;'saving'
	jsr spmsg
	jmp outfn       ;<file name>
.end
; -------------------------------------------------------------
; ##### time #####
.pag 'time 11/12/81'
;----------------------------------------
;
; time and alarm routines for 6526
;      rsr 11/12/81
;
;----------------------------------------
;----------------------------------------
; rdtim - read the time
;  .y = (bit7=pm,bit6/5=t8/t4,bits4-0 hrs)
;  .x = (bit7=t2,bits6-0 minutes)
;  .a = (bit7=t1,bits6-0 seconds)
;----------------------------------------
rdtim	lda cia+tod10
	pha             ;save for later
	pha
	asl a           ;shift to add to todhrs
	asl a
	asl a
	and #$60        ;bit posistions 5,6
	ora cia+todhr
	tay             ;return in .y
	pla
	ror a           ;shift to add to todsec
	ror a
	and #$80
	ora cia+todsec
	sta sal         ;save for later
	ror a           ;shit to add to todmin
	and #$80
	ora cia+todmin
	tax             ;return in .x
	pla
	cmp cia+tod10   ;watch out for rollover
	bne rdtim       ;...it changed do again...
	lda sal
	rts
.pag
;----------------------------------------
; settim - set tod and alarm
;  c-set => set alarm
;  c-clr => set tod
;  registers same as rdtim
;
;----------------------------------------
settim	pha             ;save for later
	pha
	ror a           ;set bit 8
	and #$80
	ora cia+crb
	sta cia+crb
	tya             ;get bits from todhrs
	rol a
	rol a
	rol sal         ;bit t8 (don't need to clear sal)
	rol a
	rol sal         ;bit t4
	txa             ;get bit from todmin
	rol a
	rol sal         ;bit t2
	pla             ;get bit from todsec
	rol a
	rol sal         ;bit t1
	sty cia+todhr
	stx cia+todmin
	pla
	sta cia+todsec
	lda sal
	sta cia+tod10
	rts
.end
; -------------------------------------------------------------
; ##### errorhandler #####
.pag 'error handler'
;************************************
;*                                  *
;* error handler                    *
;*  restores i/o channels to default*
;*  prints kernal error message if  *
;*  bit 6 of msgflg set.  returns   *
;*  with error # in .a and carry.   *
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
errorx	pha             ;error number on stack
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
	and #$01        ;check stop key position
	bne stop2       ;not down
	php
	jsr clrch       ;clear channels
	sta ndx         ;flush queue
	plp
stop2	rts
.ski 3
;---------------------------------------
; udtim - update the stop key location
;   expects keyboard outputs set to
;   default value. bit 0 of stkey =0
;   for stop key down.
;---------------------------------------
udtim	lda tpi2+pc     ;check keyboard
	lsr a
	bcs udexit      ;no  stop key
	lda #$fe        ;check for shift
	sta tpi2+pb
	lda #$10
	and tpi2+pc
	bne udttt       ;no shift key
	sec             ;shift key mark
udttt	lda #$ff        ;clear
	sta tpi2+pb
udexit	rol a           ;move bit 0 back
	sta stkey
	rts
.end
; -------------------------------------------------------------
;.lib tapefile
;.lib tapecontrol
;.lib read
;.lib write
; -------------------------------------------------------------
; ##### init #####
.pag 'init 05/02/83'
;------------------------------------------------
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
;
;------------------------------------------------
.ski 1
patall	.byt  $c2,$cd   ;$x004 rom pattern
.ski 1
start	ldx #$fe        ;do all normal junk...
	sei
	txs
	cld
;
; check for warm start
;
	lda #warm       ;load up bits that show warm
	cmp evect+2     ;check warm flag
	bne scold
	lda evect+3     ;check complete flag
	cmp #winit
	beq swarm       ;good...do warm start
;
; check for roms
;
scold	lda #6          ;set up indirect
	sta eal
	lda #0          ;clear upper
	sta eah
	sta evect+0     ;set low byte of vector
	ldx #$30        ;existance flag
sloop0	ldy #3          ;go around test loop
	lda eah
	bmi sloop2      ;no roms but this one...
	clc             ;calc new test point
	adc #$10        ;4k steps
	sta eah
	inx
	txa
	cmp (eal)y
	bne sloop0      ;didn't match 'x'...
	dey
sloop1	lda (eal)y
	dey
	bmi sloop3      ;all done...correctly
	cmp patall,y
	beq sloop1
	bne sloop0      ;no good...
;
; monitor (could be test for keydown ***)
;
sloop2	ldy #$e0        ;monitor vector
	.byte $2c       ;skip two bytes
sloop3	ldy eah
starhi	sty evect+1     ;set high byte of vector
;
	tax             ;set flags
	bpl swarm       ;don't use kernal initilization
;
; kernal cold start
;
skernl	jsr ioinit      ;initilize i/o
	lda #$f0        ;prevent damage to non-tested buffers
	sta pkybuf+1
	jsr cint        ; cinit call for non-cleared system
	jsr ramtas      ;ram test and set
	jsr restor      ;operationg system vectors
	jsr cint        ;screen editor initilization
	lda #warm       ;kernal initilize done flag
	sta evect+2
swarm	jmp (evect)     ;start exit
.page 'init - i/o'
;-----------------------------------------
; ioinit - initilize i/o system
;   6509/6525/6525/6526
;   must be entered with irq's disabled
;------------------------------------------
ioinit
;
; 6509 initilization code
;   see page 2 for assignments
;   done by reset
;
;
; 6525 tpi1 initilization code
;   see page 12 for assignments
;
	lda #%11110011  ;cb,ca=hi ie3,4=neg ip=1 mc=1
	sta tpi1+creg
	ldy #$ff        ;mask on all irq's
	sty tpi1+ddpc
;     pb4=output 1, to claim dbus
	lda #%01011100  ;wrt=lo unused netr=off
	sta tpi1+pb     ;netw=off ifc=lo (must turn off !!!)
	lda #%01111101  ;set directions
	sta tpi1+ddpb
;
	lda #%00111101  ;ieee controls off
	sta tpi1+pa
	lda #%00111111  ;ieee control to transmitt
	sta tpi1+ddpa   ;data to receive
;
; 6525 tpi2 initilization code
;   see page 13 for assignments
;
; .y = $ff from above
	sty tpi2+pa     ;set up keyboard outputs
	sty tpi1+pb
	sty tpi2+ddpa
	sty tpi2+ddpb
	lsr tpi2+pa     ;turn stop key line on ***
	.ifn system <
	lda #$c0        ;set up vic selects=out for p-series
>
	.ife system <
	iny             ;.y=0 set up vic selects=in for system jumpers
>
	sty tpi2+pc
	sty tpi2+ddpc   ; keyboard=in (0-5)
;
; 6526 cia initilization code
;   see page 10 for assignments
;
	lda #$7f        ;turn off all irq sources from 6526...
	sta cia+icr
; .y =$00 from above
	sty cia+ddra    ;all ieee in / triggers 14,24 also
	sty cia+ddrb    ;same for game inputs 10-13,20-23
	sty cia+crb     ;write tod   timer b=off
; activate tod
;
	sta cia+tod10
;
; 60/50 hz test code for tod
;
	sty tpi1+pc
io100	lda tpi1+pc     ;wait untill it happens again
	ror a
	bcc io100       ;pc0 = 1 -> 50/60hz irq
	sty tpi1+pc     ;clear it again
;
; start a timmer
;
	ldx #0          ;.y=$00 from above
io110	inx
	bne io110
	iny
	lda tpi1+pc
	ror a
	bcc io110       ;pc0 = 1 -> 50/60hz irq
;
	cpy #id55hz
	bcc io120       ;it was 60 hz
	lda #%10001000  ;set for 50hz
	.byt $2c        ;skip two bytes
io120	lda #%00001000
	sta cia+cra
;
; 6526  inter-process communication initialization
;       pra = data port
;       prb = ipc lines
;       irq's from 2nd processor via flag input
;
	lda ipcia+icr   ;clear icr
	lda #$90
	sta ipcia+icr   ;flag irqs on
	lda #$40
	sta ipcia+prb   ;no nmi to z80, sem6509 low
;.x =$00 from above
	stx ipcia+ddra  ;port a=input
	stx ipcia+crb   ;timer b off
	stx ipcia+cra   ;timer a off
	lda #%01001000  ;port b lines sem65,ennmi are outs
	sta ipcia+ddrb
;
;
; 6551 initilization code
;   see page 11 for assignments
;   handled by reset  10/19/81 rsr
;
; turn off ifc
;
	lda #ifc
	ora tpi1+pb
	sta tpi1+pb
	rts
.page 'init - ramtas'
;-----------------------------------------
; ramtas - initilize lower ram with $00
;  and test all system dynamic ram
;  set ram limits (64k bank min size)
;  allocate initial buffer space
;  turn off rs232 and cassette buffers
;  reset xtape vectors to non-cassette
;
;-----------------------------------------
ramtas
; clear $0002-$0101 and $0200-$03f7
;
	lda #0
	tax
px1	.byt $9d        ;sta $0002,x
	.wor $0002
	sta $200,x
	sta $300-8,x
	inx
	bne px1
.skip 3
;
;memory size check
;
	.ife system <
	lda #1          ;bottom of memory always segment 1
>
	.ifn system <
	lda #0          ;bottom of memory always segment 0
>
	sta i6509
	sta memstr+2    ;set bottom of memory
	sta lowadr+2
	lda #2
	sta memstr
	sta lowadr
	dec i6509       ;place back one segment for test
;
; memsiz,sal,lowadr are zeroed above
;
sizlop	inc i6509       ;claculate next ind seg
	lda i6509
	cmp #15         ;all slots full...exit
	beq size
	ldy #2          ;always start at $0002
siz100
	lda (sal)y
	tax
	lda #$55
	sta (sal)y
	lda (sal)y
	cmp #$55
	bne size
	asl a
	sta (sal)y
	lda (sal)y
	cmp #$aa
	bne size
	txa
	sta (sal)y
	iny
	bne siz100
	inc sal+1
	bne siz100
	beq sizlop
;
; set top of memory
;
size	ldx i6509       ;seg number of failure
	dex             ;back up one segment
	txa             ;.a= seg#
	ldx #$ff
	ldy #$fd        ;reserve top page for swapping system
	sta hiadr+2     ;set system top of memory
	sty hiadr+1
	stx hiadr
;
; allocate 3 pages (512funcs,256rs232)
;
	ldy #$fd-3
	clc
	jsr memtop      ;set user top of memory
;
; flag buffers as not assigned =>$ff
;
	dec ribuf+2
	dec tape1+2
	.ife sysage <
	lda #<nocass    ;set up cassette indirects
	sta itape
	lda #>nocass
	sta itape+1
>
	rts
.page 'init - kernal'
.ski 5
jmptab	.wor yirq       ;cinv
	.wor timb       ;cbinv....brk goes to monitor
	.wor panic      ;no.....nminv !!!!!
	.wor nopen      ;open file
	.wor nclose     ;close file
	.wor nchkin     ;open channel in
	.wor nckout     ;open channel out
	.wor nclrch     ;close channel
	.wor nbasin     ;input from channel
	.wor nbsout     ;output to channel
	.wor nstop      ;scan stop key
	.wor ngetin     ;scan keyboard
	.wor nclall     ;close all files
	.wor nload      ;load from file
	.wor nsave      ;save to file
	.wor s0         ;monitor command parser
	.wor escrts     ;esc key vector
	.wor escrts     ;user ctrl key vector
	.wor nsecnd     ;ieee listen secondary address
	.wor ntksa      ;ieee talk secondary address
	.wor nacptr     ;ieee character in
	.wor nciout     ;ieee character out
	.wor nuntlk     ;ieee untalk bus
	.wor nunlsn     ;ieee unlisten bus
	.wor nlistn     ;ieee listen a device
	.wor ntalk      ;ieee talk to a device
tabend
nmi	jmp (nminv)
.ski 5
; .a = filename length
; .x = zero page location of 3 byte address
;
setnam	sta fnlen
	lda $00,x
	sta fnadr
	lda $01,x
	sta fnadr+1
	lda $02,x
	sta fnadr+2
	rts
.ski 5
setlfs	sta la
	stx fa
	sty sa
	rts
.ski 5
;read/write status
;
;carry set -- read device status into .a
;
readst	bcc storst
	lda fa          ;see which devices' to read
	cmp #2
	bne readss      ;not rs-232
	lda rsstat      ;yes get it
	pha
	lda #00         ;clear status when read
	beq statxt      ;jump
;
setmsg	sta msgflg
readss	lda status
udst	ora status
	sta status
	rts
;
;carry clear -- set device status with .a
;
storst	pha
	lda fa
	cmp #2
	bne storss      ;not rs-232
statxt	pla
	sta rsstat
	rts
;
storss	pla
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
	lda memsiz+2
	ldx memsiz
	ldy memsiz+1
;
;carry clear--set top of memory
;
settop	stx memsiz
	sty memsiz+1
	sta memsiz+2
	rts
.ski 5
;manage bottom of memory
;
membot	bcc setbot
;
;carry set--read bottom of memory
;
	lda memstr+2
	ldx memstr
	ldy memstr+1
;
;carry clear--set bottom of memory
;
setbot	stx memstr
	sty memstr+1
	sta memstr+2
	rts
.ski 5
;restore ram i/o vectors
;
restor	ldx #<jmptab
	ldy #>jmptab
	lda #irom
	clc
;
;manage ram i/o vectors
;
vector	stx sal
	sty sah
	ldx i6509       ;save indirect
	sta i6509
;
	bcc vect50
;
;carry set--read vectors
;
	ldy #tabend-jmptab-1
vect20	lda cinv,y      ;from ram table
	sta (sal)y      ;into user area
	dey
	bpl vect20
;
;carry clear--set vectors
;
vect50	ldy #tabend-jmptab-1
vect60	lda (sal)y      ;from user area
	sta cinv,y      ;into ram table
	dey
	bpl vect60
;
	stx i6509       ;restore indirect
	rts
;
; vreset - reset vector flags and control
;   .x - low vector address  .y - high vector address
;
vreset	stx evect
	sty evect+1
	lda #winit
	sta evect+3
	rts
.end
; -------------------------------------------------------------
; ##### irq #####
.pag 'interrupt handler'
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
;*                                            *
;**********************************************
nirq	pha             ;save registers
	txa
	pha
	tya
	pha
	tsx             ;check for brk...
	lda $104,x
	and #$10
	bne brkirq      ;yes...
puls	jmp (cinv)
brkirq	jmp (cbinv)     ;yes...
;
yirq	lda i6509       ;save indirect segment #
	pha
; lda pass ;external break handler
; pha
; lda #0 ;clear for normal return
; sta pass
.ski 2
	cld             ;clear dec to prevent future problems
	lda tpi1+air
	bne irq000      ;handle priority irq's
;
; external irq (vic and others)
;  (no code!!!!!!!!!!)
;
	jmp prendn
.ski4
irq000	cmp #$10        ;find irq source
	beq irq002      ;not 6551...
	jmp irq100
;
; 6551 interrupt handler
;
irq002	lda acia+srsn   ;find irq source
	tax
	and #$60        ;dcd/dsr changes ??
	tay
	eor dcdsr
	beq irq004      ;no change...
	tya
	sta dcdsr       ;update old dsr/dcd status
	ora rsstat      ;update rs232 status
	sta rsstat
	jmp irq900      ;done!
;
irq004	txa
	and #$08        ;receiver ??
	beq irq010      ;no...
;
; receiver service
;
	ldy ridbe       ;check buffers
	iny
	cpy ridbs       ;have we passed start?
	bne irq005      ;no...
;
	lda #doverr     ;input buffer full error
	bne irq007      ;bra...set status
;
irq005	sty ridbe       ;move end foward
	dey
	ldx ribuf+2
	stx i6509
	ldx acia+srsn   ;get status register
	lda acia+drsn
	sta (ribuf)y    ;data to buffer
	txa             ;set status
	and #$07
irq007	ora rsstat      ;set status
	sta rsstat
.ski 2
irq010	lda acia+srsn   ;find irq source
	and #$10        ;transmitter ?
	beq irq090      ;no...
	lda acia+cdr    ;check for transmitter on
	and #$0c
	cmp #$04        ;bits(32)=01 => xmitter int enabled
	bne irq090      ;off...
;
; transmitter service (no interrrupt driven transmissions)
;
	lda #%11110011  ;turn of transmitter
	and acia+cdr
	sta acia+cdr
irq090	jmp irq900      ;exit..pop priority...
.ski 3
irq100
	cmp #$08        ;check if inter-process irq
	bne irq110      ;no...
	lda ipcia+icr   ;clear irq condition
	cli             ;this irq can be interrupted
	jsr ipserv      ;do the request
	jmp irq900      ;done!
.ski
irq110	cli             ;all other irq's may be interrupted, too
	cmp #$04        ;check if 6526
	bne irq200      ;no...
;
; 6526 interrupt reconized
;
	lda cia+icr     ;get active interrupts
	ora alarm       ;in case we lose something
	sta alarm
;
; nothing to do at present....need code ********
;
	jmp irq900      ;...dump interrupt
.ski 3
irq200	cmp #$02        ;check for ieee srq
	bne irq300
;
; need code ************
;
	jmp irq900      ;...dump interrupt
.ski 3
irq300	jsr key         ;scan the keyboard
	jsr udtim       ;set stopkey flag
;
; test for cassette switch
;
	lda tpi1+pb     ;get cass switch
	bpl irq310      ;switch is down...
	ldy #0          ;flag motor off...
	sty cas1
	ora #$40        ;turn motor off...
	bne irq320      ;jump
irq310	ldy cas1        ;test for flag on...
	bne irq900      ;yes computer control..leave alone
	and #$ff-$40    ;turn motor on...
irq320	sta tpi1+pb     ;store mods into port
.ski 3
irq900	sta tpi1+air    ;pop the interrupt...
prendn	;lda pass ;check for foriegn call
; bne segrti ;yes...return
; pla
; sta pass ;restore interrupted interrupt
	pla             ;restore registers
	sta i6509
prend	pla             ;entry point for register only
	tay
	pla
	tax
	pla
panic	rti             ;come here if no new nmi vector.
;
.end
; -------------------------------------------------------------
; ##### ipcom #####
.page 'interprocess communication'
;--------------------------------------------------------------
;
; send a request
;   enter:   ipb buffer is initialized to hold the
;            command
;            input parameter bytes
;
;   exit:    ipb buffer holds
;            output parameter bytes
;            all other bytes in ipb unchanged
;
;---------------------------------------------------------------
iprqst
	lda ipb+ipccmd
	and #$7f
	tay
	jsr getpar      ;get #ins,outs
	lda #sem88      ;check 8088 semaphore
	and ipcia+prb
	bne iprqst      ;locked out by other processor
	lda #sem65
	ora ipcia+prb   ;lock 6509 semaphore
	sta ipcia+prb
	nop             ;a pause
;
	lda ipcia+prb   ;collisions with 8088?
	tax
	and #sem88
	beq ipr100      ;ok...
	txa
	eor #sem65
	sta ipcia+prb   ;nope, clear 6509 semaphore
	txa             ;kill some time
	nop
	nop
	nop
	bne iprqst      ;try again (br always)
;
;     send cmd byte and cause irq
;
ipr100
	lda #$ff
	sta ipcia+ddra  ;port direction = out
	lda ipb+ipccmd
	sta ipcia+pra   ;write cmd byte to port
;; cause irq
	jsr frebus      ;give up bus
	lda ipcia+prb   ;pb6 := 0
	and #$bf
	sta ipcia+prb
	ora #$40        ;keep low for 4us (8 cycles)
	cli
	nop
	nop
	nop
	sta ipcia+prb   ;pb6 := high
;
	jsr waithi      ;sem8088 -> hi (cmd byte recvd)
	lda #$00
	sta ipcia+ddra  ;port direction = in
	jsr acklo       ;sem6509 -> lo (ack)
	jsr waitlo      ;sem8088 -> lo (ack ack)
;
;    send data bytes, if any
;
	ldy #0
	beq ipr250      ;always
ipr200
	lda #$ff
	sta ipcia+ddra  ;port direction = out
	lda ipb+ipcdat,y ;get next data byte
	sta ipcia+pra   ;write cmd out
	jsr ackhi       ;sem6509 -> hi (data ready)
	jsr waithi      ;sem8088 -> hi (data recvd)
	lda #$00
	sta ipcia+ddra  ;port direction = in
	jsr acklo       ;sem6509 -> lo (ack)
	jsr waitlo      ;sem8088 -> lo (ack ack)
	iny             ;bump index to next data byte
ipr250	cpy ipb+ipcin   ;any more ??
	bne ipr200      ;yes...
;
;    receive data bytes, if any
;
	ldy #0
	beq ipr350      ;always
ipr300
	jsr ackhi       ;sem6509 -> hi (rdy to receive)
	jsr waithi      ;sem8088 -> hi (data available)
	lda ipcia+pra   ;get data from port
	sta ipb+ipcdat,y ;stuff it away
	jsr acklo       ;sem6509 -> lo (data recvd)
	jsr waitlo      ;sem8088 -> lo (ack)
	iny
ipr350
	cpy ipb+ipcout  ;more?
	bne ipr300      ;yes...
	rts             ;done!!
.page
;-------------------------------------------------------------------
;
; service an 8088 request
;
;-------------------------------------------------------------------
ipserv
;; ldy #ipbsiz-1 ;copy ip buffer to stack
;;ips050 lda ipb,y
;; pha
;; dey
;; bpl ips050
;
	lda #0
	sta ipcia+ddra  ;port dir=in, just in case...
	lda ipcia+pra   ;read cmd from port
	sta ipb+ipccmd  ;store cmd and decode it
	and #$7f        ;mask off bus bit
	tay
	jsr getpar      ;get param counts
	tya             ;adjust offset for jump table
	asl a
	tay
	lda ipjtab,y    ;jump address(lo)
	sta ipb+ipcjmp
	iny
	lda ipjtab,y    ;jump address (hi)
	sta ipb+ipcjmp+1
	jsr ackhi       ;sem6509 -> hi (cmd recvd)
	jsr waitlo      ;sem8088 -> lo (ack)
;
;    receive input bytes, if any
;
	ldy #0
ips100
	cpy ipb+ipcin   ;any more?
	beq ips200      ;no...
	jsr acklo       ;sem6509 ->lo (ack ack)
	jsr waithi      ;sem8088 -> hi (data available)
	lda ipcia+pra   ;read data byte
	sta ipb+ipcdat,y ;store it
	jsr ackhi       ;sem6509 -> hi (data recvd)
	jsr waitlo      ;sem8088 -> lo (ack)
	iny
	bne ips100      ;always...
;
;    process cmd
;
ips200
	bit ipb+ipccmd  ;cmd requires bus?
	bmi ips500      ;yes...
	lda #>ipsret    ;push return
	pha
	lda #<ipsret
	pha
	jmp (ipb+ipcjmp) ;gone!!!
;
;    send return bytes, if any
;
ips300
ipsret=ips300-1
	jsr acklo       ;sem6509 -> lo
	ldy #0
	beq ips350      ;always
ips310
	jsr waithi      ;sem8088 -> hi (8088 rdy to recv)
	lda #$ff
	sta ipcia+ddra  ;port direction = out
	lda ipb+ipcdat,y
	sta ipcia+pra   ;write data to port
	jsr ackhi       ;sem6509 -> hi (data available)
	jsr waitlo      ;sem8088 -> lo (data recvd)
	lda #0
	sta ipcia+ddra  ;port direction = in
	jsr acklo       ;sem6509 -> lo (ack)
	iny
ips350	cpy ipb+ipcout  ;any more?
	bne ips310      ;yes, repeat...
;
ips400
;; ldy #0
;;ips450 pla ;restore ip buffer
;; sta ipb,y
;; iny
;; cpy #ipbsiz
;; bne ips450
	rts             ;done!
.ski 3
;      special,   for commands requiring the bus
ips500	lda #>buret
	pha
	lda #<buret
	pha             ;push return
	jsr getbus      ;grab bus
	jmp (ipb+ipcjmp) ;gone!
;
ips600
buret=ips600-1
	jsr frebus      ;give up bus
	lda ipb+ipcout  ;#bytes to return
	sta ipb+ipcin
	sta ipb+ipccmd  ;return op=#bytes to return
	lda #0
	sta ipb+ipcout  ;just send to 8088
	jsr iprqst
	jmp ips400      ;done!
.page
;
; waitlo - wait until sem88 goes low
;
waitlo
	lda ipcia+prb
	and #sem88
	bne waitlo
	rts
.ski 3
;
; waithi - wait until sem88 goes high
;
waithi
	lda ipcia+prb
	and #sem88
	beq waithi
	rts
.ski 3
;
; acklo - acknowlegde sem65 low
;
acklo
	lda ipcia+prb
	and #$ff-sem65
	sta ipcia+prb
	rts
.ski 3
;
; ackhi - acknowledge sem6509 hi
;
ackhi
	lda #sem65
	ora ipcia+prb
	sta ipcia+prb
	rts
.ski 3
;
; frebus - give up bus
; getbus - grab bus
;
frebus
	lda tpi1+pb     ;pb4 := 0
	and #$ef
	sta tpi1+pb
	rts
;
getbus
	lda ipcia+prb   ;check nbusy2
	and #$02
	beq getbus      ;2nd proc not off
;
	lda tpi1+pb     ;pb4 := 1
	ora #$10
	sta tpi1+pb
	rts
;
; getpar
;  enter - .y = table offset
;  exit:   .y = table offset
;          #ins,#outs put into ipb buffer
getpar
	lda ipptab,y    ;break apart nibbles
	pha
	and #$0f
	sta ipb+ipcin   ;#input bytes
	pla
	lsr a
	lsr a
	lsr a
	lsr a
	sta ipb+ipcout  ;#output bytes
	rts
;
; ipcgo - free bus, interrupt 2nd processor
;         go into a loop, waiting for requests.
;  * returns if bus error occurs
;
ipcgo	ldx #$ff
	stx i6509       ;indirects to bank f only
	lda tpi1+pb     ;tpi1 pb4:=0 frees dbus
	and #$ef
	sta tpi1+pb
	nop             ;a pause
	lda ipcia+prb   ;check nbusy1
	ror a
	bcs ipcgx
	rts             ;bus not free!, error...
;
ipcgx	lda #0          ;pb6 lo->hi in 4us...
	sei
	sta ipcia+prb   ;interrupt 2nd processeor
	lda #$40        ;2 cycles (4us=8cycles)
	nop
	nop
	nop
	nop             ;8 cycles of garb. 5us safer than 4!
	sta ipcia+prb   ;turn pb6 back on
	cli
iploop	jmp iploop      ;sit down
.end
; -------------------------------------------------------------
; ##### ktemp #####
.pag 'temporaries'
;equate screen editor temporarily
;
cint	=$e000+4
lp2	=$e003+4
loop5	=$e006+4
prt	=$e009+4
scnkey	=$e00f+4
key	=$e00f+4
;
; no routines in 8032 screen editor
;
scrorg	=$e00c+4
plot	=$e015+4
iobase	=$e018+4
escrts	=$e01b+4
funkey	=$e022
;
; no cassette routines avaliable
;
xtape	jmp (itape)     ;goto tape device indirect
nocass	pla             ;remove jsr xtape and return
	pla
	jmp error5      ;send back ?device not present
;
; some needed routines
;
rd300	lda stah
	sta sah
	lda stal
	sta sal
	lda stas
	sta sas
	sta i6509
	rts
;
cmpste	sec
	lda sal
	sbc eal
	lda sah
	sbc eah
	lda sas
	sbc eas
	rts
;
incsal	inc sal
	bne incr20
	inc sah
incr10	bne incr20
	inc sas
	lda sas
	sta i6509
	lda #$02        ;skip $0000 and $0001
	sta sal
incr20	rts
.ski 5
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
fnadry	ldx i6509
	lda fnadr+2
	sta i6509
	lda (fnadr)y
	stx i6509
	rts
.end
; -------------------------------------------------------------
; ##### transx #####
.pag 'transx 5/02/83'
; txjmp - transfer-of-execution jumper
;   entry - .a=seg # .x=low .y=high
;   caller must be a jsr txjmp
;   all registers and i6509 destroyed
;   returns directly to caller...
;
txjmp	;bp routine
 sta i6509
 txa
 clc
 adc #2
 bcc txjmp1
 iny
txjmp1	tax
 tya
 pha
 txa
 pha
 jsr ipinit ;go initilize ipoint
 lda #$fe
 sta (ipoint)y
;
; 04/14/83 bp
; transfer exec routines for cbm2
;
exsub	php             ;save status
	sei
	pha             ;.a
	txa
	pha             ;.x
	tya
	pha             ;.y
	jsr ipinit      ;init ipoint and load stack from xfer seg
	tay             ;.y is xfer seg stack pointer
	lda e6509       ;push return segment to user stack
	jsr putas       ;push .a to other stack
	lda #<excrt2    ;xfer seg rts routn
	ldx #>excrt2    ;xfer seg rts routn
	jsr putaxs      ;put .a.x to xfer seg stack
	tsx
	lda $0105,x     ;.sp +5 is actual routn addr lo
	sec
	sbc #03         ;-3 for jsr to this routn
	pha             ;save .a
	lda $0106,x     ;hi addr
	sbc #00
	tax             ;.x hi
	pla             ;restore .a lo
	jsr putaxs      ;save .a.x onto xfer seg stack
	tya             ;xfer seg stack pointer
excomm	sec
	sbc #04         ;4 bytes .y.x.a.p
	sta stackp      ;xfer seg new stack pointer temp storage
	tay             ;use this as new pointer also
	ldx #04         ;4 bytes .y.x.a.p
exsu10	pla
	iny
	sta (ipoint),y  ;push regs from this stack to xfer seg stack
	dex
	bne exsu10
	ldy stackp      ;restore .y as stack pointer for xfer seg
	lda #<expul2    ;pull regs and rts routn
	ldx #>expul2    ;.hi prendn routn in xfer seg
	jsr putaxs      ;put .a.x on xfer seg stack
	pla             ;fix stack
	pla             ;fix stack
exgbye	tsx
	stx stackp      ;save current stack pointer this seg
	tya             ;.y is stack pointer for xfer seg
	tax
	txs             ;new stack for xfer seg
	lda i6509       ;xfer seg #
	jmp gbye        ;good bye
;
	nop             ;returns here if rti
excrts	php             ;.p
	php             ;.p
      sei             ;dis ints
	pha             ;.a
	txa
	pha             ;.x
	tya
	pha             ;.y
	tsx
	lda $0106,x     ;.sp +7 is return seg
	sta i6509       ;restore i6509 to return seg
	jsr ipinit      ;init ipoint and load stack from xfer seg
	jmp excomm
;
ipinit	ldy #01
	sty ipoint+1
	dey
	sty ipoint      ;ipoint=$0100
	dey             ;.y =$ff
	lda (ipoint),y  ;load stack pointer from $001ff
	rts
putaxs	pha             ;save .a
	txa
	sta (ipoint),y  ;.x hi
	dey
	pla
putas	sta (ipoint),y  ;.a lo
	dey
	rts
;
expull	pla
	tay             ;.y
	pla
	tax             ;.x
	pla             ;.a
	plp             ;.p
	rts             ;.p
exnmi	php             ;.p
	jmp ($fffa)     ;do nmi proc
exbrk	brk
	nop
	rts
exirq	cli
	rts
exend
;
excrt2=excrts-1
expul2=expull-1
.end
; -------------------------------------------------------------
; ##### vectors #####
.pag 'jump table/vectors'
	* =$ff6c
	jmp txjmp       ;transfer-of-execution jumper
	jmp vreset      ;power-on/off vector reset
ipcgov	jmp ipcgo       ;loop for ipc system
	jmp funkey      ;function key vector
	jmp iprqst      ;send ipc request
	jmp ioinit      ;i/o initialization
	jmp cint        ;screen initialization
	jmp alocat      ;allocation routine
	jmp vector      ;read/set i/o vectors
	jmp restor      ;restore i/o vectors
	jmp lkupsa      ;match sa--return sa,fa
	jmp lkupla      ;match la--return sa,fa
	jmp setmsg      ;control o.s. messages
secnd	jmp (isecnd)    ;send sa after listen
tksa	jmp (itksa)     ;send sa after talk
	jmp memtop      ;set/read top of memory
	jmp membot      ;set/read bottom of memory
	jmp scnkey      ;scan keyboard
	jmp settmo      ;set timeout in ieee
acptr	jmp (iacptr)    ;handshake ieee byte in
ciout	jmp (iciout)    ;handshake ieee byte out
untlk	jmp (iuntlk)    ;send untalk out ieee
unlsn	jmp (iunlsn)    ;send unlisten out ieee
listn	jmp (ilistn)    ;send listen out ieee
talk	jmp (italk)     ;send talk out ieee
	jmp readst      ;read/write i/o status byte
	jmp setlfs      ;set la, fa, sa
	jmp setnam      ;set length and fn adr
open	jmp (iopen)     ;open logical file/transmit command
close	jmp (iclose)    ;close logical file
chkin	jmp (ichkin)    ;open channel in
ckout	jmp (ickout)    ;open channel out
clrch	jmp (iclrch)    ;close i/o channel
basin	jmp (ibasin)    ;input from channel
bsout	jmp (ibsout)    ;output to channel
load	jmp (iload)     ;load from file
save	jmp (isave)     ;save to file
	jmp settim      ;set internal clock
	jmp rdtim       ;read internal clock
stop	jmp (istop)     ;scan stop key
getin	jmp (igetin)    ;get char from q
clall	jmp (iclall)    ;close all files
	jmp udtim       ;increment clock
	jmp scrorg      ;screen org
	jmp plot        ;read/set x,y coord
	jmp iobase      ;return i/o base
.ski 5
gbye	sta e6509       ;goodbye...
	rts
.pag 'jump table/vectors'
	*=$fffa
	.wor nmi        ;program defineable
	.wor start      ;initialization code
	.wor nirq       ;interrupt handler
.end
