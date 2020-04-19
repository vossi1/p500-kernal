; Commodore P500 Kernal 901234-02 with Fastboot Patch
; disassembled with DA65 18.4.2020
; modified for ACME assembling by Vossi 19.4.2020

!cpu 6502
!ct scr         ; standard text/char conversion table -> Screencode (pet = PETSCII, raw)
!to "kernal.bin", plain 

; ----------------------------------------------------------------------------
e6509           = $00                        ; 6509 execution bank
i6509           = $01                        ; 6509 indirect bank
fnadr           = $90                        ; Far address of file name
sal             = $93                        ; Start address low
sah             = $94                        ; Start address high
sas             = $95                        ; Start address seg
eal             = $96                        ; End address low
eah             = $97                        ; End address high
eas             = $98                        ; End address seg
stal            = $99
stah            = $9A
stas            = $9B
status          = $9C                        ; Status byte
fnlen           = $9D                        ; Length of file name
la              = $9E                        ; Logical file number
fa              = $9F                        ; Device address
sa              = $A0                        ; Secondary address
dfltn           = $A1                        ; Current input device
dflto           = $A2                        ; Current output device
tape1           = $A3                        ; Address of tape buffer
ribuf           = $A6                        ; Address of rs232 buffer
stkey           = $A9                        ; Stop key flag
c3po            = $AA                        ; IEC buffer flag
bsour           = $AB                        ; IEC output buffer
ipoint          = $AC                        ; RAM indirect pointer
pch             = $AE                        ; Monitor: PC low
pcl             = $AF                        ; Monitor: PC high
sp              = $B4                        ; Monitor: stack pointer
xi6509          = $B5                        ; Monitor: indirect bank
invh            = $B7                        ; Monitor: user irq low
invl            = $B8                        ; Monitor: user irq high
tmp1            = $B9                        ; Monitor: temp ptr 1
tmp2            = $BB                        ; Monitor: temp ptr 2
tmpc            = $BD                        ; Monitor: last command
t6509           = $BE                        ; Monitor: current indirect bank
ddisk           = $BF                        ; Monitor: disk device number
pkybuf          = $C0                        ; Start of function keys
keypnt          = $C2
sedsal          = $C4
sedeal          = $C6
pnt             = $C8                        ; Current position in video RAM
tblx            = $CA                        ; Cursor position: line
pntr            = $CB                        ; Cursor position: column
grmode          = $CC                        ; Flag for text/graph mode
lstx            = $CD                        ; Scancode of last key pressed
lstp            = $CE
lsxp            = $CF
crsw            = $D0
ndx             = $D1
qtsw            = $D2                        ; Quote mode flag
insrt           = $D3                        ; Insert mode flag
config          = $D4                        ; Cursor type
indx            = $D5
kyndx           = $D6
rptcnt          = $D7                        ; Keyboard repeat counter
delay           = $D8                        ; Kbd repeat delay counter
sedt1           = $D9                        ; Screen editor temp storage #1
sedt2           = $DA                        ; Screen editor temp storage #2
data            = $DB                        ; Current output character
sctop           = $DC                        ; Top line of current window
scbot           = $DD                        ; Bottom line of current window
sclf            = $DE                        ; Left border of current window
scrt            = $DF                        ; Right border of current window
modkey          = $E0                        ; Flag for shift/control keys
norkey          = $E1
bitabl          = $E2
blnon           = $E6                        ; Blinking cursor on
blncnt          = $E7                        ; Blink counter
user            = $E8                        ; Ptr to color ram
tcolor          = $EA                        ; Temporary color
blnsw           = $EB                        ; Blink switch
color           = $EC                        ; Character color
gdcol           = $ED                        ; Color behind cursor
saver           = $EE                        ; Temp store for output char
scrseg          = $EF                        ; Segment of video ram
stack           = $0100
stackp          = $01FF
cinv            = $0300                        ; IRQ indirect vector
cbinv           = $0302                        ; BRK indirect vector
nminv           = $0304                        ; NMI indirect vector
iopen           = $0306                        ; Open file vector
iclose          = $0308                        ; Close file vector
ichkin          = $030A
ickout          = $030C
iclrch          = $030E
ibasin          = $0310
ibsout          = $0312
istop           = $0314
igetin          = $0316
iclall          = $0318
iload           = $031A
isave           = $031C
usrcmd          = $031E                        ; Vector for monitor command extensions
escvec          = $0320
ctlvec          = $0322
isecnd          = $0324
itksa           = $0326
iacptr          = $0328
iciout          = $032A
iuntlk          = $032C
iunlsn          = $032E
ilistn          = $0330
italk           = $0332
lat             = $0334                        ; Logical file number table
fat             = $033E                        ; Device number table
sat             = $0348                        ; Secondary address table
lowadr          = $0352                        ; Start of system memory
hiadr           = $0355                        ; End of system memory
memstr          = $0358                        ; Start of user memory
memsiz          = $035B                        ; End of user memory
timout          = $035E                        ; IEEE timeout enable
verck           = $035F                        ; Load/verify flag
ldtnd           = $0360                        ; Device table index
msgflg          = $0361                        ; Message flag
bufpt           = $0362                        ; Cassette buffer index
t1              = $0363
t2              = $0364
xsav            = $0365
savx            = $0366
svxt            = $0367
temp            = $0368
alarm           = $0369
itape           = $036A                        ; Vector: Tape routines
cassvo          = $036C
aservo          = $036D
caston          = $036E
relsal          = $036F
relsah          = $0370
relsas          = $0371
oldinv          = $0372
cas1            = $0375
m51ctr          = $0376
m51cdr          = $0377
rsstat          = $037A                        ; rs232 status byte
dcdsr           = $037B
ridbs           = $037C
ridbe           = $037D
pkyend          = $0380
keyseg          = $0382                        ; Segment of function key texts
rvs             = $0383                        ; Reverse mode flag
lintmp          = $0384
lstchr          = $0385
insflg          = $0386                        ; Insert mode flag
scrdis          = $0387
bitmsk          = $0388
keyidx          = $0389
logscr          = $038A
bellmd          = $038B                        ; Bell on/off flag
pagsav          = $038C
keysiz          = $038D                        ; Sizes of function key texts
tab             = $03A1
keyd            = $03AB                        ; Keyboard buffer
funvec          = $03B5                        ; Vector: funktion key handler
iwrtvrm         = $03B7                        ; Vector: video ram write routine
iwrtcrm         = $03B9                        ; Vector: color ram write routine
iunkwn1         = $03BB
iunkwn2         = $03BD
evect           = $03F8                        ; Warm start vector and flags
ramloc          = $0400                        ; First free ram location
ipb             = $0800
ijtab           = $0810
ipptab          = $0910
basic           = $8000
charrom         = $C000
vidram          = $D000
clrram          = $D400
vic             = $D800
vic_addr        = $D818
sid_s1freq      = $DA00
sid_s1pw        = $DA02
sid_s1ctl       = $DA04
sid_s1ad        = $DA05
sid_s1sr        = $DA06
sid_s2freq      = $DA07
sid_s2pw        = $DA09
sid_s2ctl       = $DA0B
sid_s2ad        = $DA0C
sid_s2sr        = $DA0D
sid_s3freq      = $DA0E
sid_s3pw        = $DA10
sid_s3ctl       = $DA12
sid_s3ad        = $DA13
sid_s3sr        = $DA14
sid_filter      = $DA15
sid_fltctl      = $DA17
sid_volume      = $DA18
sid_potx        = $DA19
sid_poty        = $DA1A
sid_random      = $DA1B
sid_env3        = $DA1C
cia1_pra        = $DB00
cia1_prb        = $DB01
cia1_ddra       = $DB02
cia1_ddrb       = $DB03
cia1_talo       = $DB04
cia1_tahi       = $DB05
cia1_tblo       = $DB06
cia1_tbhi       = $DB07
cia1_tod10      = $DB08
cia1_todsec     = $DB09
cia1_todmin     = $DB0A
cia1_todhr      = $DB0B
cia1_sdr        = $DB0C
cia1_icr        = $DB0D
cia1_cra        = $DB0E
cia1_crb        = $DB0F
cia2_pra        = $DC00
cia2_prb        = $DC01
cia2_ddra       = $DC02
cia2_ddrb       = $DC03
cia2_talo       = $DC04
cia2_tahi       = $DC05
cia2_tblo       = $DC06
cia2_tbhi       = $DC07
cia2_tod10      = $DC08
cia2_todsec     = $DC09
cia2_todmin     = $DC0A
cia2_todhr      = $DC0B
cia2_sdr        = $DC0C
cia2_icr        = $DC0D
cia2_cra        = $DC0E
cia2_crb        = $DC0F
acia_data       = $DD00
acia_status     = $DD01
acia_cmd        = $DD02
acia_ctrl       = $DD03
tpi1_pa         = $DE00
tpi1_pb         = $DE01
tpi1_pc         = $DE02
tpi1_ddra       = $DE03
tpi1_ddrb       = $DE04
tpi1_ddrc       = $DE05
tpi1_ctrl       = $DE06
tpi1_air        = $DE07
tpi2_pa         = $DF00
tpi2_pb         = $DF01
tpi2_pc         = $DF02
tpi2_ddra       = $DF03
tpi2_ddrb       = $DF04
tpi2_ddrc       = $DF05
tpi2_ctrl       = $DF06
tpi2_air        = $DF07

*= $e000
; ----------------------------------------------------------------------------
; Jump vector: Monitor cold start
jmoncld:jmp     moncold                         ; E000 4C 09 EE                 L..

; ----------------------------------------------------------------------------
        nop                                     ; E003 EA                       .
; Jump vector: Screen editor init
jcint:  jmp     cint                            ; E004 4C 44 E0                 LD.

; ----------------------------------------------------------------------------
; Jump vector: Read a key from the keyboard
jrdkey: jmp     rdkey                           ; E007 4C F4 E0                 L..

; ----------------------------------------------------------------------------
; Jump vector: Read key from screen
jscrget:jmp     scrget                          ; E00A 4C 74 E1                 Lt.

; ----------------------------------------------------------------------------
; Jump vector: Print character on screen
jprint: jmp     print                           ; E00D 4C 84 E2                 L..

; ----------------------------------------------------------------------------
; Jump vecror: Return screen dimensions
jscrorg:jmp     scrorg                          ; E010 4C 3F E0                 L?.

; ----------------------------------------------------------------------------
; Jump vector: keyboard scan
jscnkey:jmp     scnkey                          ; E013 4C 0C E9                 L..

; ----------------------------------------------------------------------------
; Jump vector: Set screen pointers to cursor position
jmovcur:jmp     nofunc                          ; E016 4C 39 E0                 L9.

; ----------------------------------------------------------------------------
; Jump vector: Get/set the cursor position
jplot:  jmp     plot                            ; E019 4C 25 E0                 L%.

; ----------------------------------------------------------------------------
; Jump vector: Return CIA base address
jiobase:jmp     iobase                          ; E01C 4C 3A E0                 L:.

; ----------------------------------------------------------------------------
; Jump vector: Handle an escape sequence
jescape:jmp     escape                          ; E01F 4C 3C EA                 L<.

; ----------------------------------------------------------------------------
; Jump vector: Get/set/list function keys
jfunkey:jmp     keyfun                          ; E022 4C A9 E7                 L..

; ----------------------------------------------------------------------------
; Get/set the cursor position depending on the carry flag
plot:   bcs     rdplt                           ; E025 B0 0E                    ..
        stx     tblx                            ; E027 86 CA                    ..
        stx     lsxp                            ; E029 86 CF                    ..
        sty     pntr                            ; E02B 84 CB                    ..
        sty     lstp                            ; E02D 84 CE                    ..
        jsr     sreset                          ; E02F 20 93 EA                  ..
        jsr     movcur                          ; E032 20 DF E0                  ..
rdplt:  ldx     tblx                            ; E035 A6 CA                    ..
        ldy     pntr                            ; E037 A4 CB                    ..
nofunc: rts                                     ; E039 60                       `

; ----------------------------------------------------------------------------
; Return CIA base address
iobase: ldx     #$00                            ; E03A A2 00                    ..
        ldy     #$DC                            ; E03C A0 DC                    ..
        rts                                     ; E03E 60                       `

; ----------------------------------------------------------------------------
; Return screen dimensions
scrorg: ldx     #$28                            ; E03F A2 28                    .(
        ldy     #$19                            ; E041 A0 19                    ..
        rts                                     ; E043 60                       `

; ----------------------------------------------------------------------------
; Screen editor init
cint:   lda     #$00                            ; E044 A9 00                    ..
        ldx     #$2D                            ; E046 A2 2D                    .-
LE048:  sta     keypnt,x                        ; E048 95 C2                    ..
        dex                                     ; E04A CA                       .
        bpl     LE048                           ; E04B 10 FB                    ..
        ldx     #$3C                            ; E04D A2 3C                    .<
LE04F:  sta     keysiz,x                        ; E04F 9D 8D 03                 ...
        dex                                     ; E052 CA                       .
        bpl     LE04F                           ; E053 10 FA                    ..
        lda     #$0F                            ; E055 A9 0F                    ..
        sta     scrseg                          ; E057 85 EF                    ..
        lda     #$0C                            ; E059 A9 0C                    ..
        sta     blncnt                          ; E05B 85 E7                    ..
        sta     blnon                           ; E05D 85 E6                    ..
        lda     pkybuf                          ; E05F A5 C0                    ..
        ora     pkybuf+1                        ; E061 05 C1                    ..
        bne     LE087                           ; E063 D0 22                    ."
        lda     hiadr                           ; E065 AD 55 03                 .U.
        sta     pkyend                          ; E068 8D 80 03                 ...
        lda     hiadr+1                         ; E06B AD 56 03                 .V.
        sta     pkyend+1                        ; E06E 8D 81 03                 ...
        lda     #$40                            ; E071 A9 40                    .@
        ldx     #$00                            ; E073 A2 00                    ..
        ldy     #$02                            ; E075 A0 02                    ..
        jsr     kalloc                          ; E077 20 81 FF                  ..
        bcs     LE0A2                           ; E07A B0 26                    .&
        sta     keyseg                          ; E07C 8D 82 03                 ...
        inx                                     ; E07F E8                       .
        stx     pkybuf                          ; E080 86 C0                    ..
        bne     LE085                           ; E082 D0 01                    ..
        iny                                     ; E084 C8                       .
LE085:  sty     pkybuf+1                        ; E085 84 C1                    ..
LE087:  ldy     #$39                            ; E087 A0 39                    .9
        jsr     pagkey                          ; E089 20 67 E2                  g.
LE08C:  lda     keylen+9,y                      ; E08C B9 B5 EC                 ...
        dey                                     ; E08F 88                       .
        sta     (pkybuf),y                      ; E090 91 C0                    ..
        bne     LE08C                           ; E092 D0 F8                    ..
        jsr     pagres                          ; E094 20 7C E2                  |.
        ldy     #$0A                            ; E097 A0 0A                    ..
LE099:  lda     ctlvect+63,y                    ; E099 B9 AB EC                 ...
        sta     pagsav,y                        ; E09C 99 8C 03                 ...
        dey                                     ; E09F 88                       .
        bne     LE099                           ; E0A0 D0 F7                    ..
LE0A2:  jsr     sreset                          ; E0A2 20 93 EA                  ..
        ldx     #$11                            ; E0A5 A2 11                    ..
        ldy     #$21                            ; E0A7 A0 21                    .!
LE0A9:  lda     bits+7,x                        ; E0A9 BD F6 EC                 ...
        jsr     wrtvic                          ; E0AC 20 12 E6                  ..
        dey                                     ; E0AF 88                       .
        dex                                     ; E0B0 CA                       .
        bne     LE0A9                           ; E0B1 D0 F6                    ..
        jsr     grcrt                           ; E0B3 20 53 E2                  S.
        ldx     #$0A                            ; E0B6 A2 0A                    ..
LE0B8:  lda     vicinit+16,x                    ; E0B8 BD 07 ED                 ...
        sta     keyd+9,x                        ; E0BB 9D B4 03                 ...
        dex                                     ; E0BE CA                       .
        bne     LE0B8                           ; E0BF D0 F7                    ..
        lda     #$06                            ; E0C1 A9 06                    ..
        sta     color                           ; E0C3 85 EC                    ..
; Clear the screen, cursor home
clrscr: jsr     home                            ; E0C5 20 D3 E0                  ..
LE0C8:  jsr     scrset                          ; E0C8 20 E1 E0                  ..
        jsr     clrlin                          ; E0CB 20 24 E2                  $.
        cpx     scbot                           ; E0CE E4 DD                    ..
        inx                                     ; E0D0 E8                       .
        bcc     LE0C8                           ; E0D1 90 F5                    ..
; Cursor home
home:   ldx     sctop                           ; E0D3 A6 DC                    ..
        stx     tblx                            ; E0D5 86 CA                    ..
        stx     lsxp                            ; E0D7 86 CF                    ..
stu10:  ldy     sclf                            ; E0D9 A4 DE                    ..
        sty     pntr                            ; E0DB 84 CB                    ..
        sty     lstp                            ; E0DD 84 CE                    ..
; Set screen pointers to cursor position
movcur: ldx     tblx                            ; E0DF A6 CA                    ..
scrset: lda     ldtab2,x                        ; E0E1 BD 3A EC                 .:.
        sta     pnt                             ; E0E4 85 C8                    ..
        sta     user                            ; E0E6 85 E8                    ..
        lda     ldtab1,x                        ; E0E8 BD 53 EC                 .S.
        sta     pnt+1                           ; E0EB 85 C9                    ..
        and     #$03                            ; E0ED 29 03                    ).
        ora     #$D4                            ; E0EF 09 D4                    ..
        sta     user+1                          ; E0F1 85 E9                    ..
        rts                                     ; E0F3 60                       `

; ----------------------------------------------------------------------------
; Read a key from kbd and return it in A
rdkey:  ldx     kyndx                           ; E0F4 A6 D6                    ..
        beq     rdkbuf                          ; E0F6 F0 12                    ..
        ldy     keyidx                          ; E0F8 AC 89 03                 ...
        jsr     pagkey                          ; E0FB 20 67 E2                  g.
        lda     (keypnt),y                      ; E0FE B1 C2                    ..
        jsr     pagres                          ; E100 20 7C E2                  |.
        dec     kyndx                           ; E103 C6 D6                    ..
        inc     keyidx                          ; E105 EE 89 03                 ...
        cli                                     ; E108 58                       X
        rts                                     ; E109 60                       `

; ----------------------------------------------------------------------------
; Remove key from kbd buffer and return it in A
rdkbuf: ldy     keyd                            ; E10A AC AB 03                 ...
        ldx     #$00                            ; E10D A2 00                    ..
LE10F:  lda     keyd+1,x                        ; E10F BD AC 03                 ...
        sta     keyd,x                          ; E112 9D AB 03                 ...
        inx                                     ; E115 E8                       .
        cpx     ndx                             ; E116 E4 D1                    ..
        bne     LE10F                           ; E118 D0 F5                    ..
        dec     ndx                             ; E11A C6 D1                    ..
        tya                                     ; E11C 98                       .
        cli                                     ; E11D 58                       X
        rts                                     ; E11E 60                       `

; ----------------------------------------------------------------------------
; Screen input
scrinp: jsr     print                           ; E11F 20 84 E2                  ..
        asl     $03BF                           ; E122 0E BF 03                 ...
        lsr     $03BF                           ; E125 4E BF 03                 N..
LE128:  lda     ndx                             ; E128 A5 D1                    ..
        ora     kyndx                           ; E12A 05 D6                    ..
        sta     blnon                           ; E12C 85 E6                    ..
        beq     LE128                           ; E12E F0 F8                    ..
        sei                                     ; E130 78                       x
        lda     blnsw                           ; E131 A5 EB                    ..
        beq     LE140                           ; E133 F0 0B                    ..
        lda     config                          ; E135 A5 D4                    ..
        ldy     #$00                            ; E137 A0 00                    ..
        sty     blnsw                           ; E139 84 EB                    ..
        ldx     gdcol                           ; E13B A6 ED                    ..
        jsr     LE20F                           ; E13D 20 0F E2                  ..
LE140:  jsr     rdkey                           ; E140 20 F4 E0                  ..
        cmp     #$0D                            ; E143 C9 0D                    ..
        bne     scrinp                          ; E145 D0 D8                    ..
        sta     crsw                            ; E147 85 D0                    ..
        jsr     fndend                          ; E149 20 F7 E4                  ..
        stx     lintmp                          ; E14C 8E 84 03                 ...
        jsr     fistrt                          ; E14F 20 E9 E4                  ..
        lda     #$00                            ; E152 A9 00                    ..
        sta     qtsw                            ; E154 85 D2                    ..
        ldy     sclf                            ; E156 A4 DE                    ..
        lda     lsxp                            ; E158 A5 CF                    ..
        bmi     LE16F                           ; E15A 30 13                    0.
        cmp     tblx                            ; E15C C5 CA                    ..
        bcc     LE16F                           ; E15E 90 0F                    ..
        ldy     lstp                            ; E160 A4 CE                    ..
        cmp     lintmp                          ; E162 CD 84 03                 ...
        bne     LE16B                           ; E165 D0 04                    ..
        cpy     indx                            ; E167 C4 D5                    ..
        beq     LE16D                           ; E169 F0 02                    ..
LE16B:  bcs     LE17E                           ; E16B B0 11                    ..
LE16D:  sta     tblx                            ; E16D 85 CA                    ..
LE16F:  sty     pntr                            ; E16F 84 CB                    ..
        jmp     LE186                           ; E171 4C 86 E1                 L..

; ----------------------------------------------------------------------------
; Read char from screen
scrget: tya                                     ; E174 98                       .
        pha                                     ; E175 48                       H
        txa                                     ; E176 8A                       .
        pha                                     ; E177 48                       H
        lda     crsw                            ; E178 A5 D0                    ..
        beq     LE128                           ; E17A F0 AC                    ..
        bpl     LE186                           ; E17C 10 08                    ..
LE17E:  lda     #$00                            ; E17E A9 00                    ..
        sta     crsw                            ; E180 85 D0                    ..
        lda     #$0D                            ; E182 A9 0D                    ..
        bne     LE1BF                           ; E184 D0 39                    .9
LE186:  jsr     movcur                          ; E186 20 DF E0                  ..
        jsr     get1ch                          ; E189 20 3F E2                  ?.
        sta     data                            ; E18C 85 DB                    ..
        and     #$3F                            ; E18E 29 3F                    )?
        asl     data                            ; E190 06 DB                    ..
        bit     data                            ; E192 24 DB                    $.
        bpl     LE198                           ; E194 10 02                    ..
        ora     #$80                            ; E196 09 80                    ..
LE198:  bcc     LE19E                           ; E198 90 04                    ..
        ldx     qtsw                            ; E19A A6 D2                    ..
        bne     LE1A2                           ; E19C D0 04                    ..
LE19E:  bvs     LE1A2                           ; E19E 70 02                    p.
        ora     #$40                            ; E1A0 09 40                    .@
LE1A2:  jsr     qtswc                           ; E1A2 20 C8 E1                  ..
        ldy     tblx                            ; E1A5 A4 CA                    ..
        cpy     lintmp                          ; E1A7 CC 84 03                 ...
        bcc     LE1B6                           ; E1AA 90 0A                    ..
        ldy     pntr                            ; E1AC A4 CB                    ..
        cpy     indx                            ; E1AE C4 D5                    ..
        bcc     LE1B6                           ; E1B0 90 04                    ..
        ror     crsw                            ; E1B2 66 D0                    f.
        bmi     LE1B9                           ; E1B4 30 03                    0.
LE1B6:  jsr     nextchr                         ; E1B6 20 21 E5                  !.
LE1B9:  cmp     #$DE                            ; E1B9 C9 DE                    ..
        bne     LE1BF                           ; E1BB D0 02                    ..
        lda     #$FF                            ; E1BD A9 FF                    ..
LE1BF:  sta     data                            ; E1BF 85 DB                    ..
        pla                                     ; E1C1 68                       h
        tax                                     ; E1C2 AA                       .
        pla                                     ; E1C3 68                       h
        tay                                     ; E1C4 A8                       .
        lda     data                            ; E1C5 A5 DB                    ..
        rts                                     ; E1C7 60                       `

; ----------------------------------------------------------------------------
; Switch quote mode depending on char in A
qtswc:  cmp     #$22                            ; E1C8 C9 22                    ."
        bne     LE1D4                           ; E1CA D0 08                    ..
        lda     qtsw                            ; E1CC A5 D2                    ..
        eor     #$01                            ; E1CE 49 01                    I.
        sta     qtsw                            ; E1D0 85 D2                    ..
        lda     #$22                            ; E1D2 A9 22                    ."
LE1D4:  rts                                     ; E1D4 60                       `

; ----------------------------------------------------------------------------
LE1D5:  bit     rvs                             ; E1D5 2C 83 03                 ,..
        bpl     LE1DC                           ; E1D8 10 02                    ..
        ora     #$80                            ; E1DA 09 80                    ..
LE1DC:  ldx     insrt                           ; E1DC A6 D3                    ..
        beq     LE1E2                           ; E1DE F0 02                    ..
        dec     insrt                           ; E1E0 C6 D3                    ..
LE1E2:  bit     insflg                          ; E1E2 2C 86 03                 ,..
        bpl     LE1F0                           ; E1E5 10 09                    ..
        pha                                     ; E1E7 48                       H
        jsr     insert                          ; E1E8 20 91 E5                  ..
        ldx     #$00                            ; E1EB A2 00                    ..
        stx     insrt                           ; E1ED 86 D3                    ..
        pla                                     ; E1EF 68                       h
LE1F0:  jsr     LE209                           ; E1F0 20 09 E2                  ..
        jsr     movchr                          ; E1F3 20 DB E5                  ..
LE1F6:  lda     data                            ; E1F6 A5 DB                    ..
        sta     lstchr                          ; E1F8 8D 85 03                 ...
        pla                                     ; E1FB 68                       h
        tay                                     ; E1FC A8                       .
        lda     insrt                           ; E1FD A5 D3                    ..
        beq     LE203                           ; E1FF F0 02                    ..
        lsr     qtsw                            ; E201 46 D2                    F.
LE203:  pla                                     ; E203 68                       h
        tax                                     ; E204 AA                       .
        pla                                     ; E205 68                       h
        rts                                     ; E206 60                       `

; ----------------------------------------------------------------------------
doblnk: lda     #$20                            ; E207 A9 20                    . 
LE209:  ldx     color                           ; E209 A6 EC                    ..
        bpl     LE20F                           ; E20B 10 02                    ..
LE20D:  ldx     tcolor                          ; E20D A6 EA                    ..
LE20F:  ldy     #$02                            ; E20F A0 02                    ..
        sty     blncnt                          ; E211 84 E7                    ..
dspp:   ldy     pntr                            ; E213 A4 CB                    ..
        jsr     pagscr                          ; E215 20 6E E2                  n.
        jsr     jwrtvrm                         ; E218 20 6F E6                  o.
        pha                                     ; E21B 48                       H
        txa                                     ; E21C 8A                       .
        jsr     jwrtcrm                         ; E21D 20 72 E6                  r.
        pla                                     ; E220 68                       h
        jmp     pagres                          ; E221 4C 7C E2                 L|.

; ----------------------------------------------------------------------------
clrlin: ldy     sclf                            ; E224 A4 DE                    ..
        jsr     clrbit                          ; E226 20 B6 E4                  ..
clrprt: txa                                     ; E229 8A                       .
        pha                                     ; E22A 48                       H
        lda     pntr                            ; E22B A5 CB                    ..
        pha                                     ; E22D 48                       H
        dey                                     ; E22E 88                       .
LE22F:  iny                                     ; E22F C8                       .
        sty     pntr                            ; E230 84 CB                    ..
        jsr     doblnk                          ; E232 20 07 E2                  ..
        cpy     scrt                            ; E235 C4 DF                    ..
        bne     LE22F                           ; E237 D0 F6                    ..
        pla                                     ; E239 68                       h
        sta     pntr                            ; E23A 85 CB                    ..
        pla                                     ; E23C 68                       h
        tax                                     ; E23D AA                       .
        rts                                     ; E23E 60                       `

; ----------------------------------------------------------------------------
; Get a character from the screen
get1ch: ldy     pntr                            ; E23F A4 CB                    ..
getych: jsr     pagscr                          ; E241 20 6E E2                  n.
        lda     (pnt),y                         ; E244 B1 C8                    ..
        pha                                     ; E246 48                       H
        lda     #$00                            ; E247 A9 00                    ..
        ora     (user),y                        ; E249 11 E8                    ..
        sta     tcolor                          ; E24B 85 EA                    ..
        pla                                     ; E24D 68                       h
        jmp     pagres                          ; E24E 4C 7C E2                 L|.

; ----------------------------------------------------------------------------
; Switch the VIC to normal or graphics character set
crtmode:bcs     txtcrt                          ; E251 B0 04                    ..
grcrt:  ldy     #$02                            ; E253 A0 02                    ..
        bne     LE259                           ; E255 D0 02                    ..
txtcrt: ldy     #$00                            ; E257 A0 00                    ..
LE259:  sty     grmode                          ; E259 84 CC                    ..
        lda     vic_addr                        ; E25B AD 18 D8                 ...
        and     #$FD                            ; E25E 29 FD                    ).
        ora     grmode                          ; E260 05 CC                    ..
        ldy     #$18                            ; E262 A0 18                    ..
        jmp     wrtvic                          ; E264 4C 12 E6                 L..

; ----------------------------------------------------------------------------
; Switch to the indirect segment containing the key buffer
pagkey: pha                                     ; E267 48                       H
        lda     keyseg                          ; E268 AD 82 03                 ...
        jmp     pagsub                          ; E26B 4C 71 E2                 Lq.

; ----------------------------------------------------------------------------
; Switch to the indirect segment containing the video screen
pagscr: pha                                     ; E26E 48                       H
        lda     scrseg                          ; E26F A5 EF                    ..
; Switch to the indirect segment in A
pagsub: pha                                     ; E271 48                       H
        lda     i6509                           ; E272 A5 01                    ..
        sta     pagsav                          ; E274 8D 8C 03                 ...
        pla                                     ; E277 68                       h
        sta     i6509                           ; E278 85 01                    ..
        pla                                     ; E27A 68                       h
        rts                                     ; E27B 60                       `

; ----------------------------------------------------------------------------
; Restore the indirect segment
pagres: pha                                     ; E27C 48                       H
        lda     pagsav                          ; E27D AD 8C 03                 ...
        sta     i6509                           ; E280 85 01                    ..
        pla                                     ; E282 68                       h
        rts                                     ; E283 60                       `

; ----------------------------------------------------------------------------
; Print character on screen
print:  pha                                     ; E284 48                       H
        cmp     #$FF                            ; E285 C9 FF                    ..
        bne     LE28B                           ; E287 D0 02                    ..
        lda     #$DE                            ; E289 A9 DE                    ..
LE28B:  sta     data                            ; E28B 85 DB                    ..
        txa                                     ; E28D 8A                       .
        pha                                     ; E28E 48                       H
        tya                                     ; E28F 98                       .
        pha                                     ; E290 48                       H
        lda     #$00                            ; E291 A9 00                    ..
        sta     crsw                            ; E293 85 D0                    ..
        ldy     pntr                            ; E295 A4 CB                    ..
        lda     data                            ; E297 A5 DB                    ..
        and     #$7F                            ; E299 29 7F                    ).
        cmp     #$20                            ; E29B C9 20                    . 
        bcc     ntcn                            ; E29D 90 41                    .A
        ldx     qtsw                            ; E29F A6 D2                    ..
        beq     LE2B0                           ; E2A1 F0 0D                    ..
        ldx     $03BF                           ; E2A3 AE BF 03                 ...
        beq     LE2C5                           ; E2A6 F0 1D                    ..
        jsr     junkwn1                         ; E2A8 20 69 E6                  i.
        lda     data                            ; E2AB A5 DB                    ..
        jmp     LE2C5                           ; E2AD 4C C5 E2                 L..

; ----------------------------------------------------------------------------
LE2B0:  ldx     insrt                           ; E2B0 A6 D3                    ..
        bne     LE2C5                           ; E2B2 D0 11                    ..
        bit     $03BF                           ; E2B4 2C BF 03                 ,..
        bpl     LE2C5                           ; E2B7 10 0C                    ..
        jsr     junkwn1                         ; E2B9 20 69 E6                  i.
        lda     data                            ; E2BC A5 DB                    ..
        cmp     #$22                            ; E2BE C9 22                    ."
        beq     LE2D2                           ; E2C0 F0 10                    ..
        jmp     LE1F6                           ; E2C2 4C F6 E1                 L..

; ----------------------------------------------------------------------------
LE2C5:  ldx     lstchr                          ; E2C5 AE 85 03                 ...
        cpx     #$1B                            ; E2C8 E0 1B                    ..
        bne     LE2D2                           ; E2CA D0 06                    ..
        jsr     escseq                          ; E2CC 20 DE E6                  ..
        jmp     LE1F6                           ; E2CF 4C F6 E1                 L..

; ----------------------------------------------------------------------------
LE2D2:  and     #$3F                            ; E2D2 29 3F                    )?
LE2D4:  bit     data                            ; E2D4 24 DB                    $.
        bpl     LE2DA                           ; E2D6 10 02                    ..
        ora     #$40                            ; E2D8 09 40                    .@
LE2DA:  jsr     qtswc                           ; E2DA 20 C8 E1                  ..
        jmp     LE1D5                           ; E2DD 4C D5 E1                 L..

; ----------------------------------------------------------------------------
ntcn:   cmp     #$0D                            ; E2E0 C9 0D                    ..
        beq     LE30D                           ; E2E2 F0 29                    .)
        cmp     #$1B                            ; E2E4 C9 1B                    ..
        bne     LE2F9                           ; E2E6 D0 11                    ..
        bit     data                            ; E2E8 24 DB                    $.
        bmi     LE2F9                           ; E2EA 30 0D                    0.
        lda     qtsw                            ; E2EC A5 D2                    ..
        ora     insrt                           ; E2EE 05 D3                    ..
        beq     LE30D                           ; E2F0 F0 1B                    ..
        jsr     rstmode                         ; E2F2 20 72 E7                  r.
        sta     data                            ; E2F5 85 DB                    ..
        beq     LE30D                           ; E2F7 F0 14                    ..
LE2F9:  cmp     #$03                            ; E2F9 C9 03                    ..
        beq     LE30D                           ; E2FB F0 10                    ..
        cmp     #$14                            ; E2FD C9 14                    ..
        beq     LE30D                           ; E2FF F0 0C                    ..
        ldy     insrt                           ; E301 A4 D3                    ..
        bne     LE309                           ; E303 D0 04                    ..
        ldy     qtsw                            ; E305 A4 D2                    ..
        beq     LE30D                           ; E307 F0 04                    ..
LE309:  ora     #$80                            ; E309 09 80                    ..
        bne     LE2D4                           ; E30B D0 C7                    ..
LE30D:  lda     data                            ; E30D A5 DB                    ..
        asl                                     ; E30F 0A                       .
        tax                                     ; E310 AA                       .
        jsr     ctldisp                         ; E311 20 17 E3                  ..
        jmp     LE1F6                           ; E314 4C F6 E1                 L..

; ----------------------------------------------------------------------------
; Control code dispatcher
ctldisp:lda     ctlvect+1,x                     ; E317 BD 6D EC                 .m.
        pha                                     ; E31A 48                       H
        lda     ctlvect,x                       ; E31B BD 6C EC                 .l.
        pha                                     ; E31E 48                       H
        lda     data                            ; E31F A5 DB                    ..
        rts                                     ; E321 60                       `

; ----------------------------------------------------------------------------
; User control code jump vector
ctluser:jmp     (ctlvec)                        ; E322 6C 22 03                 l".

; ----------------------------------------------------------------------------
; Handle cursor up/down
cdnup:  bcs     cursup                          ; E325 B0 0D                    ..
        jsr     nxln                            ; E327 20 8B E3                  ..
cursdn1:jsr     getbit                          ; E32A 20 A6 E4                  ..
        bcs     cdrts                           ; E32D B0 03                    ..
        sec                                     ; E32F 38                       8
        ror     lsxp                            ; E330 66 CF                    f.
cdrts:  clc                                     ; E332 18                       .
        rts                                     ; E333 60                       `

; ----------------------------------------------------------------------------
; Cursor up
cursup: ldx     sctop                           ; E334 A6 DC                    ..
        cpx     tblx                            ; E336 E4 CA                    ..
        bcs     critgo                          ; E338 B0 0F                    ..
cursup1:jsr     cursdn1                         ; E33A 20 2A E3                  *.
        dec     tblx                            ; E33D C6 CA                    ..
        jmp     movcur                          ; E33F 4C DF E0                 L..

; ----------------------------------------------------------------------------
; Handle cursor right/left
crtlf:  bcs     cleft                           ; E342 B0 06                    ..
        jsr     nextchr                         ; E344 20 21 E5                  !.
        bcs     cursdn1                         ; E347 B0 E1                    ..
critgo: rts                                     ; E349 60                       `

; ----------------------------------------------------------------------------
; Cursor left
cleft:  jsr     bakchr                          ; E34A 20 34 E5                  4.
        bcs     critgo                          ; E34D B0 FA                    ..
        bne     cdrts                           ; E34F D0 E1                    ..
        inc     tblx                            ; E351 E6 CA                    ..
        bne     cursup1                         ; E353 D0 E5                    ..
; RVS on/off
rvsf:   eor     #$80                            ; E355 49 80                    I.
        sta     rvs                             ; E357 8D 83 03                 ...
        rts                                     ; E35A 60                       `

; ----------------------------------------------------------------------------
; Handle home/clear
homeclr:bcc     curhome                         ; E35B 90 03                    ..
        jmp     clrscr                          ; E35D 4C C5 E0                 L..

; ----------------------------------------------------------------------------
; Cursor home
curhome:cmp     lstchr                          ; E360 CD 85 03                 ...
        bne     hm110                           ; E363 D0 03                    ..
        jsr     sreset                          ; E365 20 93 EA                  ..
hm110:  jmp     home                            ; E368 4C D3 E0                 L..

; ----------------------------------------------------------------------------
; Set/reset a tabulator
tabit:  ldy     pntr                            ; E36B A4 CB                    ..
        bcs     tabtog                          ; E36D B0 12                    ..
tab1:   cpy     scrt                            ; E36F C4 DF                    ..
        bcc     tab2                            ; E371 90 05                    ..
        lda     scrt                            ; E373 A5 DF                    ..
        sta     pntr                            ; E375 85 CB                    ..
        rts                                     ; E377 60                       `

; ----------------------------------------------------------------------------
tab2:   iny                                     ; E378 C8                       .
        jsr     gettab                          ; E379 20 26 EA                  &.
        beq     tab1                            ; E37C F0 F1                    ..
        sty     pntr                            ; E37E 84 CB                    ..
        rts                                     ; E380 60                       `

; ----------------------------------------------------------------------------
; Toggle a tabulator at the current position
tabtog: jsr     gettab                          ; E381 20 26 EA                  &.
        eor     bitmsk                          ; E384 4D 88 03                 M..
        sta     tab,x                           ; E387 9D A1 03                 ...
        rts                                     ; E38A 60                       `

; ----------------------------------------------------------------------------
nxln:   ldx     tblx                            ; E38B A6 CA                    ..
        cpx     scbot                           ; E38D E4 DD                    ..
        bcc     nxln1                           ; E38F 90 0F                    ..
        bit     scrdis                          ; E391 2C 87 03                 ,..
        bpl     doscrl                          ; E394 10 06                    ..
        lda     sctop                           ; E396 A5 DC                    ..
        sta     tblx                            ; E398 85 CA                    ..
        bcs     nowhop                          ; E39A B0 06                    ..
doscrl: jsr     scrup                           ; E39C 20 08 E4                  ..
        clc                                     ; E39F 18                       .
nxln1:  inc     tblx                            ; E3A0 E6 CA                    ..
nowhop: jmp     movcur                          ; E3A2 4C DF E0                 L..

; ----------------------------------------------------------------------------
nxt1:   jsr     fndend                          ; E3A5 20 F7 E4                  ..
        inx                                     ; E3A8 E8                       .
        jsr     clrbit                          ; E3A9 20 B6 E4                  ..
        ldy     sclf                            ; E3AC A4 DE                    ..
        sty     pntr                            ; E3AE 84 CB                    ..
        jsr     nxln                            ; E3B0 20 8B E3                  ..
        jmp     rstmode                         ; E3B3 4C 72 E7                 Lr.

; ----------------------------------------------------------------------------
movlin: lda     ldtab2,x                        ; E3B6 BD 3A EC                 .:.
        sta     sedeal                          ; E3B9 85 C6                    ..
        sta     sedsal                          ; E3BB 85 C4                    ..
        lda     ldtab1,x                        ; E3BD BD 53 EC                 .S.
        sta     sedsal+1                        ; E3C0 85 C5                    ..
        and     #$03                            ; E3C2 29 03                    ).
        ora     #$D4                            ; E3C4 09 D4                    ..
        sta     sedeal+1                        ; E3C6 85 C7                    ..
        jsr     pagscr                          ; E3C8 20 6E E2                  n.
movl10: lda     (sedsal),y                      ; E3CB B1 C4                    ..
        jsr     jwrtvrm                         ; E3CD 20 6F E6                  o.
        lda     #$00                            ; E3D0 A9 00                    ..
        ora     (sedeal),y                      ; E3D2 11 C6                    ..
        jsr     jwrtcrm                         ; E3D4 20 72 E6                  r.
        cpy     scrt                            ; E3D7 C4 DF                    ..
        iny                                     ; E3D9 C8                       .
        bcc     movl10                          ; E3DA 90 EF                    ..
        jmp     pagres                          ; E3DC 4C 7C E2                 L|.

; ----------------------------------------------------------------------------
; Scroll down
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
scd20:  jsr     clrlin                          ; E402 20 24 E2                  $.
        jmp     setbit                          ; E405 4C C3 E4                 L..

; ----------------------------------------------------------------------------
; Scroll up
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

; ----------------------------------------------------------------------------
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
; Test for slow scroll
scr40:  jsr     clrlin                          ; E456 20 24 E2                  $.
        ldx     #$FF                            ; E459 A2 FF                    ..
        ldy     #$FE                            ; E45B A0 FE                    ..
        jsr     getlin                          ; E45D 20 9A E4                  ..
        and     #$20                            ; E460 29 20                    ) 
        bne     scr80                           ; E462 D0 15                    ..
; Slow scroll delay loop
scr60:  nop                                     ; E464 EA                       .
        nop                                     ; E465 EA                       .
        dex                                     ; E466 CA                       .
        bne     scr60                           ; E467 D0 FB                    ..
        dey                                     ; E469 88                       .
        bne     scr60                           ; E46A D0 F8                    ..
scr70:  sty     ndx                             ; E46C 84 D1                    ..
scr75:  ldx     #$7F                            ; E46E A2 7F                    ..
        stx     tpi2_pa                         ; E470 8E 00 DF                 ...
        ldx     #$FF                            ; E473 A2 FF                    ..
        stx     tpi2_pb                         ; E475 8E 01 DF                 ...
        rts                                     ; E478 60                       `

; ----------------------------------------------------------------------------
; Scroll stop
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
; Keyboard check for slow scroll
getlin: sei                                     ; E49A 78                       x
        stx     tpi2_pa                         ; E49B 8E 00 DF                 ...
        sty     tpi2_pb                         ; E49E 8C 01 DF                 ...
        jsr     getkey                          ; E4A1 20 EA E9                  ..
        cli                                     ; E4A4 58                       X
        rts                                     ; E4A5 60                       `

; ----------------------------------------------------------------------------
; Check for a double length line
getbit: ldx     tblx                            ; E4A6 A6 CA                    ..
getbt1: jsr     bitpos                          ; E4A8 20 CF E4                  ..
        and     bitabl,x                        ; E4AB 35 E2                    5.
        cmp     #$01                            ; E4AD C9 01                    ..
        jmp     bitout                          ; E4AF 4C BF E4                 L..

; ----------------------------------------------------------------------------
; Mark current line as double length line
putbit: ldx     tblx                            ; E4B2 A6 CA                    ..
putbt1: bcs     setbit                          ; E4B4 B0 0D                    ..
clrbit: jsr     bitpos                          ; E4B6 20 CF E4                  ..
        eor     #$FF                            ; E4B9 49 FF                    I.
        and     bitabl,x                        ; E4BB 35 E2                    5.
bitsav: sta     bitabl,x                        ; E4BD 95 E2                    ..
bitout: ldx     bitmsk                          ; E4BF AE 88 03                 ...
        rts                                     ; E4C2 60                       `

; ----------------------------------------------------------------------------
; Mark a double length line
setbit: bit     scrdis                          ; E4C3 2C 87 03                 ,..
        bvs     getbt1                          ; E4C6 70 E0                    p.
        jsr     bitpos                          ; E4C8 20 CF E4                  ..
        ora     bitabl,x                        ; E4CB 15 E2                    ..
        bne     bitsav                          ; E4CD D0 EE                    ..
bitpos: stx     bitmsk                          ; E4CF 8E 88 03                 ...
        txa                                     ; E4D2 8A                       .
        and     #$07                            ; E4D3 29 07                    ).
        tax                                     ; E4D5 AA                       .
        lda     bits,x                          ; E4D6 BD EF EC                 ...
        pha                                     ; E4D9 48                       H
        lda     bitmsk                          ; E4DA AD 88 03                 ...
        lsr                                     ; E4DD 4A                       J
        lsr                                     ; E4DE 4A                       J
        lsr                                     ; E4DF 4A                       J
        tax                                     ; E4E0 AA                       .
        pla                                     ; E4E1 68                       h
        rts                                     ; E4E2 60                       `

; ----------------------------------------------------------------------------
        bcc     fndend                          ; E4E3 90 12                    ..
fndfst: ldy     sclf                            ; E4E5 A4 DE                    ..
        sty     pntr                            ; E4E7 84 CB                    ..
fistrt: jsr     getbit                          ; E4E9 20 A6 E4                  ..
        bcc     fnd0                            ; E4EC 90 06                    ..
        dec     tblx                            ; E4EE C6 CA                    ..
        bpl     fistrt                          ; E4F0 10 F7                    ..
        inc     tblx                            ; E4F2 E6 CA                    ..
fnd0:   jmp     movcur                          ; E4F4 4C DF E0                 L..

; ----------------------------------------------------------------------------
fndend: inc     tblx                            ; E4F7 E6 CA                    ..
        jsr     getbit                          ; E4F9 20 A6 E4                  ..
        bcs     fndend                          ; E4FC B0 F9                    ..
        dec     tblx                            ; E4FE C6 CA                    ..
        jsr     movcur                          ; E500 20 DF E0                  ..
        ldy     scrt                            ; E503 A4 DF                    ..
        sty     pntr                            ; E505 84 CB                    ..
        bpl     eloup2                          ; E507 10 05                    ..
eloup1: jsr     bakchr                          ; E509 20 34 E5                  4.
        bcs     endbye                          ; E50C B0 10                    ..
eloup2: jsr     get1ch                          ; E50E 20 3F E2                  ?.
        cmp     #$20                            ; E511 C9 20                    . 
        bne     endbye                          ; E513 D0 09                    ..
        cpy     sclf                            ; E515 C4 DE                    ..
        bne     eloup1                          ; E517 D0 F0                    ..
        jsr     getbit                          ; E519 20 A6 E4                  ..
        bcs     eloup1                          ; E51C B0 EB                    ..
endbye: sty     indx                            ; E51E 84 D5                    ..
        rts                                     ; E520 60                       `

; ----------------------------------------------------------------------------
nextchr:pha                                     ; E521 48                       H
        ldy     pntr                            ; E522 A4 CB                    ..
        cpy     scrt                            ; E524 C4 DF                    ..
        bcc     bumpnt                          ; E526 90 07                    ..
        jsr     nxln                            ; E528 20 8B E3                  ..
        ldy     sclf                            ; E52B A4 DE                    ..
        dey                                     ; E52D 88                       .
        sec                                     ; E52E 38                       8
bumpnt: iny                                     ; E52F C8                       .
        sty     pntr                            ; E530 84 CB                    ..
        pla                                     ; E532 68                       h
        rts                                     ; E533 60                       `

; ----------------------------------------------------------------------------
bakchr: ldy     pntr                            ; E534 A4 CB                    ..
        dey                                     ; E536 88                       .
        bmi     bakot1                          ; E537 30 04                    0.
        cpy     sclf                            ; E539 C4 DE                    ..
        bcs     bakout                          ; E53B B0 0F                    ..
bakot1: ldy     sctop                           ; E53D A4 DC                    ..
        cpy     tblx                            ; E53F C4 CA                    ..
        bcs     bakot2                          ; E541 B0 0E                    ..
        dec     tblx                            ; E543 C6 CA                    ..
        pha                                     ; E545 48                       H
        jsr     movcur                          ; E546 20 DF E0                  ..
        pla                                     ; E549 68                       h
        ldy     scrt                            ; E54A A4 DF                    ..
bakout: sty     pntr                            ; E54C 84 CB                    ..
        cpy     scrt                            ; E54E C4 DF                    ..
        clc                                     ; E550 18                       .
bakot2: rts                                     ; E551 60                       `

; ----------------------------------------------------------------------------
savpos: ldy     pntr                            ; E552 A4 CB                    ..
        sty     sedt1                           ; E554 84 D9                    ..
        ldx     tblx                            ; E556 A6 CA                    ..
        stx     sedt2                           ; E558 86 DA                    ..
        rts                                     ; E55A 60                       `

; ----------------------------------------------------------------------------
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
        jmp     movcur                          ; E57C 4C DF E0                 L..

; ----------------------------------------------------------------------------
delop1: jsr     nextchr                         ; E57F 20 21 E5                  !.
        jsr     get1ch                          ; E582 20 3F E2                  ?.
        jsr     bakchr                          ; E585 20 34 E5                  4.
        jsr     LE20D                           ; E588 20 0D E2                  ..
        jsr     nextchr                         ; E58B 20 21 E5                  !.
        jmp     deloop                          ; E58E 4C 65 E5                 Le.

; ----------------------------------------------------------------------------
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
        jsr     nextchr                         ; E5AA 20 21 E5                  !.
        jsr     LE20D                           ; E5AD 20 0D E2                  ..
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

; ----------------------------------------------------------------------------
stprun: bcc     runrts                          ; E5C9 90 0F                    ..
        sei                                     ; E5CB 78                       x
        ldx     #$09                            ; E5CC A2 09                    ..
        stx     ndx                             ; E5CE 86 D1                    ..
runlop: lda     LEC30,x                         ; E5D0 BD 30 EC                 .0.
        sta     tab+9,x                         ; E5D3 9D AA 03                 ...
        dex                                     ; E5D6 CA                       .
        bne     runlop                          ; E5D7 D0 F7                    ..
        cli                                     ; E5D9 58                       X
runrts: rts                                     ; E5DA 60                       `

; ----------------------------------------------------------------------------
movchr: cpy     scrt                            ; E5DB C4 DF                    ..
        bcc     movc10                          ; E5DD 90 0B                    ..
        ldx     tblx                            ; E5DF A6 CA                    ..
        cpx     scbot                           ; E5E1 E4 DD                    ..
        bcc     movc10                          ; E5E3 90 05                    ..
        bit     scrdis                          ; E5E5 2C 87 03                 ,..
        bmi     movc30                          ; E5E8 30 17                    0.
movc10: jsr     movcur                          ; E5EA 20 DF E0                  ..
        jsr     nextchr                         ; E5ED 20 21 E5                  !.
        bcc     movc30                          ; E5F0 90 0F                    ..
        jsr     getbit                          ; E5F2 20 A6 E4                  ..
        bcs     movc20                          ; E5F5 B0 09                    ..
        sec                                     ; E5F7 38                       8
        bit     scrdis                          ; E5F8 2C 87 03                 ,..
        bvs     movc30                          ; E5FB 70 04                    p.
        jsr     scrdwn                          ; E5FD 20 DF E3                  ..
movc20: clc                                     ; E600 18                       .
movc30: rts                                     ; E601 60                       `

; ----------------------------------------------------------------------------
colorky:ldy     #$10                            ; E602 A0 10                    ..
LE604:  dey                                     ; E604 88                       .
        bmi     LE60F                           ; E605 30 08                    0.
        cmp     colortb,y                       ; E607 D9 12 ED                 ...
        bne     LE604                           ; E60A D0 F8                    ..
        sty     color                           ; E60C 84 EC                    ..
        rts                                     ; E60E 60                       `

; ----------------------------------------------------------------------------
LE60F:  jmp     ctluser                         ; E60F 4C 22 E3                 L".

; ----------------------------------------------------------------------------
; Write a byte to the VIC chip
wrtvic: sta     saver                           ; E612 85 EE                    ..
LE614:  lda     saver                           ; E614 A5 EE                    ..
        sta     vic,y                           ; E616 99 00 D8                 ...
        eor     vic,y                           ; E619 59 00 D8                 Y..
        beq     LE62F                           ; E61C F0 11                    ..
        cpy     #$20                            ; E61E C0 20                    . 
LE621           = * + 1
        bcs     LE62B                           ; E620 B0 09                    ..
        cpy     #$11                            ; E622 C0 11                    ..
        bcc     LE614                           ; E624 90 EE                    ..
        and     LE621,y                         ; E626 39 21 E6                 9!.
        bne     LE614                           ; E629 D0 E9                    ..
LE62B:  and     #$0F                            ; E62B 29 0F                    ).
        bne     LE614                           ; E62D D0 E5                    ..
LE62F:  lda     saver                           ; E62F A5 EE                    ..
        rts                                     ; E631 60                       `

; ----------------------------------------------------------------------------
!byte   $7F,$00,$00,$00,$FF,$3F,$FF,$FE ; E632 7F 00 00 00 FF 3F FF FE  .....?..
!byte   $00,$0F,$FF,$FF,$FF,$FF,$FF     ; E63A 00 0F FF FF FF FF FF     .......
; ----------------------------------------------------------------------------
; Write a byte to the video RAM
wrtvram:sta     saver                           ; E641 85 EE                    ..
;LE643:
        lda     saver                           ; E643 A5 EE                    ..
        sta     (pnt),y                         ; E645 91 C8                    ..
;        lda     (pnt),y                         ; E647 B1 C8                    ..
;        eor     saver                           ; E649 45 EE                    E.
;        bne     LE643                           ; E64B D0 F6                    ..
;        lda     saver                           ; E64D A5 EE                    ..
        rts                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        rts                                     ; E64F 60                       `

; ----------------------------------------------------------------------------
; Write a byte to the color RAM
wrtcram:sta     saver                           ; E650 85 EE                    ..
        lda     i6509                           ; E652 A5 01                    ..
        pha                                     ; E654 48                       H
        lda     #$0F                            ; E655 A9 0F                    ..
        sta     i6509                           ; E657 85 01                    ..
;LE659:
        lda     saver                           ; E659 A5 EE                    ..
        sta     (user),y                        ; E65B 91 E8                    ..
;        eor     (user),y                        ; E65D 51 E8                    Q.
;        and     #$0F                            ; E65F 29 0F                    ).
;        bne     LE659                           ; E661 D0 F6                    ..
        pla                                     ; E663 68                       h
        sta     i6509                           ; E664 85 01                    ..
        lda     saver                           ; E666 A5 EE                    ..
        rts                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        rts                                     ; E668 60                       `

; ----------------------------------------------------------------------------
junkwn1:jmp     (iunkwn1)                       ; E669 6C BB 03                 l..

; ----------------------------------------------------------------------------
junkwn2:jmp     (iunkwn2)                       ; E66C 6C BD 03                 l..

; ----------------------------------------------------------------------------
; Jump vector: Write a byte to video RAM
jwrtvrm:jmp     (iwrtvrm)                       ; E66F 6C B7 03                 l..

; ----------------------------------------------------------------------------
; Jump vector: Write a byte to color RAM
jwrtcrm:jmp     (iwrtcrm)                       ; E672 6C B9 03                 l..

; ----------------------------------------------------------------------------
; Ring the bell
bell:   lda     bellmd                          ; E675 AD 8B 03                 ...
        bne     LE6A2                           ; E678 D0 28                    .(
        lda     #$0F                            ; E67A A9 0F                    ..
        sta     sid_volume                      ; E67C 8D 18 DA                 ...
        lda     #$00                            ; E67F A9 00                    ..
        sta     sid_s1ad                        ; E681 8D 05 DA                 ...
        lda     #$F8                            ; E684 A9 F8                    ..
        sta     sid_s1sr                        ; E686 8D 06 DA                 ...
        lda     #$40                            ; E689 A9 40                    .@
        sta     sid_s1freq+1                    ; E68B 8D 01 DA                 ...
        lda     #$80                            ; E68E A9 80                    ..
        sta     sid_s3freq+1                    ; E690 8D 0F DA                 ...
        ldx     #$15                            ; E693 A2 15                    ..
        stx     sid_s1ctl                       ; E695 8E 04 DA                 ...
        ldy     #$00                            ; E698 A0 00                    ..
LE69A:  iny                                     ; E69A C8                       .
        nop                                     ; E69B EA                       .
        bne     LE69A                           ; E69C D0 FC                    ..
        dex                                     ; E69E CA                       .
        stx     sid_s1ctl                       ; E69F 8E 04 DA                 ...
LE6A2:  rts                                     ; E6A2 60                       `

; ----------------------------------------------------------------------------
; Clear last input number
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

; ----------------------------------------------------------------------------
LE6D6:  pla                                     ; E6D6 68                       h
        cmp     pntr                            ; E6D7 C5 CB                    ..
        bne     LE6A2                           ; E6D9 D0 C7                    ..
        jmp     delete                          ; E6DB 4C 5D E5                 L].

; ----------------------------------------------------------------------------
; Handle an escape sequence
escseq: jmp     (escvec)                        ; E6DE 6C 20 03                 l .

; ----------------------------------------------------------------------------
; Insert a line
iline:  jsr     scrdwn                          ; E6E1 20 DF E3                  ..
        jsr     stu10                           ; E6E4 20 D9 E0                  ..
        inx                                     ; E6E7 E8                       .
        jsr     getbt1                          ; E6E8 20 A8 E4                  ..
        php                                     ; E6EB 08                       .
        jsr     putbit                          ; E6EC 20 B2 E4                  ..
        plp                                     ; E6EF 28                       (
        bcs     linrts                          ; E6F0 B0 03                    ..
        sec                                     ; E6F2 38                       8
        ror     lsxp                            ; E6F3 66 CF                    f.
linrts: rts                                     ; E6F5 60                       `

; ----------------------------------------------------------------------------
        bcs     iline                           ; E6F6 B0 E9                    ..
; Delete a line (esc-d)
dline:  jsr     fistrt                          ; E6F8 20 E9 E4                  ..
        lda     sctop                           ; E6FB A5 DC                    ..
        pha                                     ; E6FD 48                       H
        lda     tblx                            ; E6FE A5 CA                    ..
        sta     sctop                           ; E700 85 DC                    ..
        lda     logscr                          ; E702 AD 8A 03                 ...
        pha                                     ; E705 48                       H
        lda     #$80                            ; E706 A9 80                    ..
        sta     logscr                          ; E708 8D 8A 03                 ...
        jsr     scru15                          ; E70B 20 1A E4                  ..
        pla                                     ; E70E 68                       h
        sta     logscr                          ; E70F 8D 8A 03                 ...
        lda     sctop                           ; E712 A5 DC                    ..
        sta     tblx                            ; E714 85 CA                    ..
        pla                                     ; E716 68                       h
        sta     sctop                           ; E717 85 DC                    ..
        sec                                     ; E719 38                       8
        ror     lsxp                            ; E71A 66 CF                    f.
        jmp     stu10                           ; E71C 4C D9 E0                 L..

; ----------------------------------------------------------------------------
; Erase to end of line (esc-q)
eraeol: clc                                     ; E71F 18                       .
!byte   $24                             ; E720 24                       $
; Erase to start of line (esc-p)
erasol: sec                                     ; E721 38                       8
        jsr     savpos                          ; E722 20 52 E5                  R.
        bcs     LE739                           ; E725 B0 12                    ..
LE727:  jsr     clrprt                          ; E727 20 29 E2                  ).
        inc     tblx                            ; E72A E6 CA                    ..
        jsr     movcur                          ; E72C 20 DF E0                  ..
        ldy     sclf                            ; E72F A4 DE                    ..
        jsr     getbit                          ; E731 20 A6 E4                  ..
        bcs     LE727                           ; E734 B0 F1                    ..
etout:  jmp     delout                          ; E736 4C 74 E5                 Lt.

; ----------------------------------------------------------------------------
LE739:  jsr     doblnk                          ; E739 20 07 E2                  ..
        cpy     sclf                            ; E73C C4 DE                    ..
        bne     LE745                           ; E73E D0 05                    ..
        jsr     getbit                          ; E740 20 A6 E4                  ..
        bcc     etout                           ; E743 90 F1                    ..
LE745:  jsr     bakchr                          ; E745 20 34 E5                  4.
        bcc     LE739                           ; E748 90 EF                    ..
; Scroll upwards (esc-v)
scrlup: clc                                     ; E74A 18                       .
!byte   $24                             ; E74B 24                       $
; Scroll downwards (esc-w)
scrldwn:sec                                     ; E74C 38                       8
; Scroll screen depending on carry
scroll: jsr     savpos                          ; E74D 20 52 E5                  R.
        bcs     sddn                            ; E750 B0 0B                    ..
        txa                                     ; E752 8A                       .
        pha                                     ; E753 48                       H
        jsr     scrup                           ; E754 20 08 E4                  ..
        pla                                     ; E757 68                       h
        sta     sedt2                           ; E758 85 DA                    ..
        jmp     etout                           ; E75A 4C 36 E7                 L6.

; ----------------------------------------------------------------------------
sddn:   jsr     getbit                          ; E75D 20 A6 E4                  ..
        bcs     sddn2                           ; E760 B0 03                    ..
        sec                                     ; E762 38                       8
        ror     lsxp                            ; E763 66 CF                    f.
sddn2:  lda     sctop                           ; E765 A5 DC                    ..
        sta     tblx                            ; E767 85 CA                    ..
        jsr     scrdwn                          ; E769 20 DF E3                  ..
        jsr     clrbit                          ; E76C 20 B6 E4                  ..
        jmp     etout                           ; E76F 4C 36 E7                 L6.

; ----------------------------------------------------------------------------
rstmode:lda     #$00                            ; E772 A9 00                    ..
        sta     insrt                           ; E774 85 D3                    ..
        sta     rvs                             ; E776 8D 83 03                 ...
        sta     qtsw                            ; E779 85 D2                    ..
        sta     $03BF                           ; E77B 8D BF 03                 ...
        rts                                     ; E77E 60                       `

; ----------------------------------------------------------------------------
; Allow scrolling (esc-l)
scrlon: clc                                     ; E77F 18                       .
        bcc     scrsw                           ; E780 90 01                    ..
; Disallow scrolling (esc-m)
scrloff:sec                                     ; E782 38                       8
scrsw:  lda     #$00                            ; E783 A9 00                    ..
        ror                                     ; E785 6A                       j
        sta     scrdis                          ; E786 8D 87 03                 ...
        rts                                     ; E789 60                       `

; ----------------------------------------------------------------------------
; Insert mode off
insoff: clc                                     ; E78A 18                       .
        bcc     inssw                           ; E78B 90 01                    ..
; Insert mode on
inson:  sec                                     ; E78D 38                       8
inssw:  lda     #$00                            ; E78E A9 00                    ..
        ror                                     ; E790 6A                       j
        sta     insflg                          ; E791 8D 86 03                 ...
        rts                                     ; E794 60                       `

; ----------------------------------------------------------------------------
logoff: clc                                     ; E795 18                       .
        bcc     logsw                           ; E796 90 01                    ..
logon:  sec                                     ; E798 38                       8
logsw:  lda     #$00                            ; E799 A9 00                    ..
        ror                                     ; E79B 6A                       j
        sta     logscr                          ; E79C 8D 8A 03                 ...
        rts                                     ; E79F 60                       `

; ----------------------------------------------------------------------------
LE7A0:  lda     $03BF                           ; E7A0 AD BF 03                 ...
        eor     #$C0                            ; E7A3 49 C0                    I.
        sta     $03BF                           ; E7A5 8D BF 03                 ...
        rts                                     ; E7A8 60                       `

; ----------------------------------------------------------------------------
; Get/set/list function keys
keyfun: dey                                     ; E7A9 88                       .
        bmi     listkey                         ; E7AA 30 03                    0.
        jmp     addkey                          ; E7AC 4C 6C E8                 Ll.

; ----------------------------------------------------------------------------
; List function keys
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
        jsr     pagkey                          ; E7F6 20 67 E2                  g.
        lda     (keypnt),y                      ; E7F9 B1 C2                    ..
        jsr     pagres                          ; E7FB 20 7C E2                  |.
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

; ----------------------------------------------------------------------------
LE83A:  clc                                     ; E83A 18                       .
        rts                                     ; E83B 60                       `

; ----------------------------------------------------------------------------
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

; ----------------------------------------------------------------------------
keword: !scr   " YEK"                          ; E856 20 59 45 4B               YEK
crword: !scr   "31($RHC+"                      ; E85A 33 31 28 24 52 48 43 2B  31($RHC+
!byte   $22                             ; E862 22                       "
qtword: !scr   "43($RHC+"                      ; E863 34 33 28 24 52 48 43 2B  43($RHC+
!byte   $22                             ; E86B 22                       "
; ----------------------------------------------------------------------------
; Get/set a function key
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

; ----------------------------------------------------------------------------
keysho: jsr     pagkey                          ; E8A2 20 67 E2                  g.
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
        jsr     pagres                          ; E8FC 20 7C E2                  |.
        jsr     pagkey                          ; E8FF 20 67 E2                  g.
        sta     (sedsal),y                      ; E902 91 C4                    ..
        jmp     kyinlp                          ; E904 4C F3 E8                 L..

; ----------------------------------------------------------------------------
kyinok: jsr     pagres                          ; E907 20 7C E2                  |.
        clc                                     ; E90A 18                       .
        rts                                     ; E90B 60                       `

; ----------------------------------------------------------------------------
; Keyboard scan
scnkey: jsr     junkwn2                         ; E90C 20 6C E6                  l.
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
; Poll the keyboard and place the result into the kbd buffer
key:    ldy     #$FF                            ; E933 A0 FF                    ..
        sty     modkey                          ; E935 84 E0                    ..
        sty     norkey                          ; E937 84 E1                    ..
        iny                                     ; E939 C8                       .
        sty     tpi2_pb                         ; E93A 8C 01 DF                 ...
        sty     tpi2_pa                         ; E93D 8C 00 DF                 ...
        jsr     getkey                          ; E940 20 EA E9                  ..
        and     #$3F                            ; E943 29 3F                    )?
        eor     #$3F                            ; E945 49 3F                    I?
        beq     nulxit                          ; E947 F0 76                    .v
        lda     #$FF                            ; E949 A9 FF                    ..
        sta     tpi2_pa                         ; E94B 8D 00 DF                 ...
        asl                                     ; E94E 0A                       .
        sta     tpi2_pb                         ; E94F 8D 01 DF                 ...
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
        rol     tpi2_pb                         ; E969 2E 01 DF                 ...
        rol     tpi2_pa                         ; E96C 2E 00 DF                 ...
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
doctl:  ldx     ctrltb,y                        ; E98D BE D1 EB                 ...
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
; Not a function key
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
        stx     tpi2_pa                         ; E9C5 8E 00 DF                 ...
        ldx     #$FF                            ; E9C8 A2 FF                    ..
        stx     tpi2_pb                         ; E9CA 8E 01 DF                 ...
        rts                                     ; E9CD 60                       `

; ----------------------------------------------------------------------------
; Handle key repeat
dorpt:  dec     delay                           ; E9CE C6 D8                    ..
        bpl     keyxt2                          ; E9D0 10 F1                    ..
        inc     delay                           ; E9D2 E6 D8                    ..
        dec     rptcnt                          ; E9D4 C6 D7                    ..
        bpl     keyxt2                          ; E9D6 10 EB                    ..
        inc     rptcnt                          ; E9D8 E6 D7                    ..
        ldx     ndx                             ; E9DA A6 D1                    ..
        bne     keyxt2                          ; E9DC D0 E5                    ..
; Store key in keyboard buffer
savkey: sta     keyd,x                          ; E9DE 9D AB 03                 ...
        inx                                     ; E9E1 E8                       .
        stx     ndx                             ; E9E2 86 D1                    ..
        ldx     #$03                            ; E9E4 A2 03                    ..
        stx     rptcnt                          ; E9E6 86 D7                    ..
        bne     keyxit                          ; E9E8 D0 D7                    ..
; Read keyboard matrix and debounce
getkey: lda     tpi2_pc                         ; E9EA AD 02 DF                 ...
        cmp     tpi2_pc                         ; E9ED CD 02 DF                 ...
        bne     getkey                          ; E9F0 D0 F8                    ..
        rts                                     ; E9F2 60                       `

; ----------------------------------------------------------------------------
; Jump vector: Called when a function key has been pressed
funjmp: jmp     (funvec)                        ; E9F3 6C B5 03                 l..

; ----------------------------------------------------------------------------
LE9F6:  cpy     lstx                            ; E9F6 C4 CD                    ..
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
; Default function key handler
funrts: sec                                     ; EA13 38                       8
        rts                                     ; EA14 60                       `

; ----------------------------------------------------------------------------
; Find a function key definition
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

; ----------------------------------------------------------------------------
; Calculate tabulator position
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

; ----------------------------------------------------------------------------
; Handle an escape sequence
escape: and     #$7F                            ; EA3C 29 7F                    ).
        sec                                     ; EA3E 38                       8
        sbc     #$41                            ; EA3F E9 41                    .A
        cmp     #$1A                            ; EA41 C9 1A                    ..
        bcc     escgo                           ; EA43 90 01                    ..
escrts: rts                                     ; EA45 60                       `

; ----------------------------------------------------------------------------
; Call an escape sequence routine
escgo:  asl                                     ; EA46 0A                       .
        tax                                     ; EA47 AA                       .
        lda     escvect+1,x                     ; EA48 BD 52 EA                 .R.
        pha                                     ; EA4B 48                       H
        lda     escvect,x                       ; EA4C BD 51 EA                 .Q.
        pha                                     ; EA4F 48                       H
        rts                                     ; EA50 60                       `

; ----------------------------------------------------------------------------
; Alphabetical table of escape sequence handlers
escvect:!word   auton-1                         ; EA51 AA EA                    ..
        !word   sethtb-1                        ; EA53 86 EA                    ..
        !word   autoff-1                        ; EA55 A7 EA                    ..
        !word   dline-1                         ; EA57 F7 E6                    ..
        !word   notimp-1                        ; EA59 A6 EA                    ..
        !word   notimp-1                        ; EA5B A6 EA                    ..
        !word   bellon-1                        ; EA5D A1 EA                    ..
        !word   belloff-1                       ; EA5F A3 EA                    ..
        !word   iline-1                         ; EA61 E0 E6                    ..
        !word   fndfst-1                        ; EA63 E4 E4                    ..
        !word   fndend-1                        ; EA65 F6 E4                    ..
        !word   scrlon-1                        ; EA67 7E E7                    ~.
        !word   scrloff-1                       ; EA69 81 E7                    ..
        !word   notimp-1                        ; EA6B A6 EA                    ..
        !word   rstmode-1                       ; EA6D 71 E7                    q.
        !word   erasol-1                        ; EA6F 20 E7                     .
        !word   eraeol-1                        ; EA71 1E E7                    ..
        !word   notimp-1                        ; EA73 A6 EA                    ..
        !word   notimp-1                        ; EA75 A6 EA                    ..
        !word   sethtt-1                        ; EA77 84 EA                    ..
        !word   notimp-1                        ; EA79 A6 EA                    ..
        !word   scrlup-1                        ; EA7B 49 E7                    I.
        !word   scrldwn-1                       ; EA7D 4B E7                    K.
        !word   escrts-1                        ; EA7F 44 EA                    D.
        !word   notimp-1                        ; EA81 A6 EA                    ..
        !word   notimp-1                        ; EA83 A6 EA                    ..
; ----------------------------------------------------------------------------
; Set top left window corner
sethtt: clc                                     ; EA85 18                       .
!byte   $24                             ; EA86 24                       $
; Set bottom right window corner
sethtb: sec                                     ; EA87 38                       8
window: ldx     pntr                            ; EA88 A6 CB                    ..
        lda     tblx                            ; EA8A A5 CA                    ..
        bcc     settps                          ; EA8C 90 0F                    ..
setbts: sta     scbot                           ; EA8E 85 DD                    ..
        stx     scrt                            ; EA90 86 DF                    ..
        rts                                     ; EA92 60                       `

; ----------------------------------------------------------------------------
; Window to full screen (off)
sreset: lda     #$18                            ; EA93 A9 18                    ..
        ldx     #$27                            ; EA95 A2 27                    .'
        jsr     setbts                          ; EA97 20 8E EA                  ..
        lda     #$00                            ; EA9A A9 00                    ..
        tax                                     ; EA9C AA                       .
settps: sta     sctop                           ; EA9D 85 DC                    ..
        stx     sclf                            ; EA9F 86 DE                    ..
        rts                                     ; EAA1 60                       `

; ----------------------------------------------------------------------------
; Bell on (esc-g)
bellon: lda     #$00                            ; EAA2 A9 00                    ..
; Bell off (esc-h)
belloff:sta     bellmd                          ; EAA4 8D 8B 03                 ...
; Not implemented escape sequences jump here
notimp: rts                                     ; EAA7 60                       `

; ----------------------------------------------------------------------------
; Auto insert mode off
autoff: lda     #$00                            ; EAA8 A9 00                    ..
!byte   $2C                             ; EAAA 2C                       ,
; ----------------------------------------------------------------------------
; Auto insert mode on
auton:  lda     #$FF                            ; EAAB A9 FF                    ..
        sta     insflg                          ; EAAD 8D 86 03                 ...
        rts                                     ; EAB0 60                       `

; ----------------------------------------------------------------------------
; Keyboard table, no modifiers
normtb:
!byte   $E0,$1B,$09,$FF,$00,$01,$E1,$31 ; EAB1 E0 1B 09 FF 00 01 E1 31  .......1
!byte   $51,$41,$5A,$FF,$E2,$32,$57,$53 ; EAB9 51 41 5A FF E2 32 57 53  QAZ..2WS
!byte   $58,$43,$E3,$33,$45,$44,$46,$56 ; EAC1 58 43 E3 33 45 44 46 56  XC.3EDFV
!byte   $E4,$34,$52,$54,$47,$42,$E5,$35 ; EAC9 E4 34 52 54 47 42 E5 35  .4RTGB.5
!byte   $36,$59,$48,$4E,$E6,$37,$55,$4A ; EAD1 36 59 48 4E E6 37 55 4A  6YHN.7UJ
!byte   $4D,$20,$E7,$38,$49,$4B,$2C,$2E ; EAD9 4D 20 E7 38 49 4B 2C 2E  M .8IK,.
!byte   $E8,$39,$4F,$4C,$3B,$2F,$E9,$30 ; EAE1 E8 39 4F 4C 3B 2F E9 30  .9OL;/.0
!byte   $2D,$50,$5B,$27,$11,$3D,$5F,$5D ; EAE9 2D 50 5B 27 11 3D 5F 5D  -P['.=_]
!byte   $0D,$DE,$91,$9D,$1D,$14,$02,$FF ; EAF1 0D DE 91 9D 1D 14 02 FF  ........
!byte   $13,$3F,$37,$34,$31,$30,$12,$04 ; EAF9 13 3F 37 34 31 30 12 04  .?7410..
!byte   $38,$35,$32,$2E,$8E,$2A,$39,$36 ; EB01 38 35 32 2E 8E 2A 39 36  852..*96
!byte   $33,$30,$03,$2F,$2D,$2B,$0D,$FF ; EB09 33 30 03 2F 2D 2B 0D FF  30./-+..
; Keyboard table with shift modifier
shfttb:
!byte   $EA,$1B,$89,$FF,$00,$01,$EB,$21 ; EB11 EA 1B 89 FF 00 01 EB 21  .......!
!byte   $D1,$C1,$DA,$FF,$EC,$40,$D7,$D3 ; EB19 D1 C1 DA FF EC 40 D7 D3  .....@..
!byte   $D8,$C3,$ED,$23,$C5,$C4,$C6,$D6 ; EB21 D8 C3 ED 23 C5 C4 C6 D6  ...#....
!byte   $EE,$24,$D2,$D4,$C7,$C2,$EF,$25 ; EB29 EE 24 D2 D4 C7 C2 EF 25  .$.....%
!byte   $5E,$D9,$C8,$CE,$F0,$26,$D5,$CA ; EB31 5E D9 C8 CE F0 26 D5 CA  ^....&..
!byte   $CD,$A0,$F1,$2A,$C9,$CB,$3C,$3E ; EB39 CD A0 F1 2A C9 CB 3C 3E  ...*..<>
!byte   $F2,$28,$CF,$CC,$3A,$3F,$F3,$29 ; EB41 F2 28 CF CC 3A 3F F3 29  .(..:?.)
!byte   $2D,$D0,$5B,$22,$11,$2B,$5C,$5D ; EB49 2D D0 5B 22 11 2B 5C 5D  -.[".+\]
!byte   $8D,$DE,$91,$9D,$1D,$94,$82,$FF ; EB51 8D DE 91 9D 1D 94 82 FF  ........
!byte   $93,$3F,$37,$34,$31,$30,$92,$84 ; EB59 93 3F 37 34 31 30 92 84  .?7410..
!byte   $38,$35,$32,$2E,$0E,$2A,$39,$36 ; EB61 38 35 32 2E 0E 2A 39 36  852..*96
!byte   $33,$30,$83,$2F,$2D,$2B,$8D,$FF ; EB69 33 30 83 2F 2D 2B 8D FF  30./-+..
; Keyboard table with shift and graph
shftgr:
!byte   $EA,$1B,$89,$FF,$00,$01,$EB,$21 ; EB71 EA 1B 89 FF 00 01 EB 21  .......!
!byte   $D1,$C1,$DA,$FF,$EC,$40,$D7,$D3 ; EB79 D1 C1 DA FF EC 40 D7 D3  .....@..
!byte   $D8,$C0,$ED,$23,$C5,$C4,$C6,$C3 ; EB81 D8 C0 ED 23 C5 C4 C6 C3  ...#....
!byte   $EE,$24,$D2,$D4,$C7,$C2,$EF,$25 ; EB89 EE 24 D2 D4 C7 C2 EF 25  .$.....%
!byte   $5E,$D9,$C8,$DD,$F0,$26,$D5,$CA ; EB91 5E D9 C8 DD F0 26 D5 CA  ^....&..
!byte   $CD,$A0,$F1,$2A,$C9,$CB,$3C,$3E ; EB99 CD A0 F1 2A C9 CB 3C 3E  ...*..<>
!byte   $F2,$28,$CF,$D6,$3A,$3F,$F3,$29 ; EBA1 F2 28 CF D6 3A 3F F3 29  .(..:?.)
!byte   $2D,$D0,$5B,$22,$11,$2B,$5C,$5D ; EBA9 2D D0 5B 22 11 2B 5C 5D  -.[".+\]
!byte   $8D,$DE,$91,$9D,$1D,$94,$82,$FF ; EBB1 8D DE 91 9D 1D 94 82 FF  ........
!byte   $93,$B7,$B4,$B1,$B0,$AD,$92,$B8 ; EBB9 93 B7 B4 B1 B0 AD 92 B8  ........
!byte   $B5,$B2,$AE,$BD,$0E,$B9,$B6,$B3 ; EBC1 B5 B2 AE BD 0E B9 B6 B3  ........
!byte   $DB,$30,$83,$AF,$AA,$AB,$8D,$FF ; EBC9 DB 30 83 AF AA AB 8D FF  .0......
; Keyboard table with control
ctrltb:
!byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$A1 ; EBD1 FF FF FF FF FF FF FF A1  ........
!byte   $11,$01,$1A,$FF,$FF,$A2,$17,$13 ; EBD9 11 01 1A FF FF A2 17 13  ........
!byte   $18,$03,$FF,$A3,$05,$04,$06,$16 ; EBE1 18 03 FF A3 05 04 06 16  ........
!byte   $FF,$A4,$12,$14,$07,$02,$FF,$A5 ; EBE9 FF A4 12 14 07 02 FF A5  ........
!byte   $A7,$19,$08,$0E,$FF,$BE,$15,$0A ; EBF1 A7 19 08 0E FF BE 15 0A  ........
!byte   $0D,$FF,$FF,$BB,$09,$0B,$CE,$FF ; EBF9 0D FF FF BB 09 0B CE FF  ........
!byte   $FF,$BF,$0F,$0C,$DC,$FF,$FF,$AC ; EC01 FF BF 0F 0C DC FF FF AC  ........
!byte   $BC,$10,$CC,$A8,$FF,$A9,$DF,$BA ; EC09 BC 10 CC A8 FF A9 DF BA  ........
!byte   $FF,$A6,$FF,$FF,$FF,$FF,$FF,$FF ; EC11 FF A6 FF FF FF FF FF FF  ........
!byte   $FF,$96,$9E,$9C,$05,$90,$FF,$99 ; EC19 FF 96 9E 9C 05 90 FF 99  ........
!byte   $81,$1E,$1C,$FF,$FF,$9A,$95,$1F ; EC21 81 1E 1C FF FF 9A 95 1F  ........
!byte   $9F,$FF,$FF,$97,$98,$9B,$FF     ; EC29 9F FF FF 97 98 9B FF     .......
LEC30:
!byte   $FF                             ; EC30 FF                       .
; ----------------------------------------------------------------------------
; DLOAD "*" + RUN
runtab:
!scr   "D"                             ; EC31 44                       D
!byte   $CC,$22                         ; EC32 CC 22                    ."
!scr   "*"                             ; EC34 2A                       *
!byte   $0D                             ; EC35 0D                       .
!scr   "RUN"                           ; EC36 52 55 4E                 RUN
!byte   $0D                             ; EC39 0D                       .
; ----------------------------------------------------------------------------
; Start of screen lines, low bytes
ldtab2:
!byte   $00,$28,$50,$78,$A0,$C8,$F0,$18 ; EC3A 00 28 50 78 A0 C8 F0 18  .(Px....
!byte   $40,$68,$90,$B8,$E0,$08,$30,$58 ; EC42 40 68 90 B8 E0 08 30 58  @h....0X
!byte   $80,$A8,$D0,$F8,$20,$48,$70,$98 ; EC4A 80 A8 D0 F8 20 48 70 98  .... Hp.
!byte   $C0                             ; EC52 C0                       .
; Start of screen lines, high bytes
ldtab1:
!byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D1 ; EC53 D0 D0 D0 D0 D0 D0 D0 D1  ........
!byte   $D1,$D1,$D1,$D1,$D1,$D2,$D2,$D2 ; EC5B D1 D1 D1 D1 D1 D2 D2 D2  ........
!byte   $D2,$D2,$D2,$D2,$D3,$D3,$D3,$D3 ; EC63 D2 D2 D2 D2 D3 D3 D3 D3  ........
!byte   $D3                             ; EC6B D3                       .
; ----------------------------------------------------------------------------
; Control key handler table
ctlvect:!word   ctluser-1                       ; EC6C 21 E3                    !.
        !word   colorky-1                       ; EC6E 01 E6                    ..
        !word   ctluser-1                       ; EC70 21 E3                    !.
        !word   stprun-1                        ; EC72 C8 E5                    ..
        !word   ce-1                            ; EC74 A2 E6                    ..
        !word   colorky-1                       ; EC76 01 E6                    ..
        !word   LE7A0-1                         ; EC78 9F E7                    ..
        !word   bell-1                          ; EC7A 74 E6                    t.
        !word   ctluser-1                       ; EC7C 21 E3                    !.
        !word   tabit-1                         ; EC7E 6A E3                    j.
        !word   ctluser-1                       ; EC80 21 E3                    !.
        !word   ctluser-1                       ; EC82 21 E3                    !.
        !word   ctluser-1                       ; EC84 21 E3                    !.
        !word   nxt1-1                          ; EC86 A4 E3                    ..
        !word   crtmode-1                       ; EC88 50 E2                    P.
        !word   window-1                        ; EC8A 87 EA                    ..
        !word   colorky-1                       ; EC8C 01 E6                    ..
        !word   cdnup-1                         ; EC8E 24 E3                    $.
        !word   rvsf-1                          ; EC90 54 E3                    T.
        !word   homeclr-1                       ; EC92 5A E3                    Z.
        !word   delins-1                        ; EC94 5A E5                    Z.
        !word   colorky-1                       ; EC96 01 E6                    ..
        !word   colorky-1                       ; EC98 01 E6                    ..
        !word   colorky-1                       ; EC9A 01 E6                    ..
        !word   colorky-1                       ; EC9C 01 E6                    ..
        !word   colorky-1                       ; EC9E 01 E6                    ..
        !word   colorky-1                       ; ECA0 01 E6                    ..
        !word   colorky-1                       ; ECA2 01 E6                    ..
        !word   colorky-1                       ; ECA4 01 E6                    ..
        !word   crtlf-1                         ; ECA6 41 E3                    A.
        !word   colorky-1                       ; ECA8 01 E6                    ..
        !word   colorky-1                       ; ECAA 01 E6                    ..
; ----------------------------------------------------------------------------
; Length of function key texts
keylen:
!byte   $05,$04,$06,$06,$05,$06,$04,$09 ; ECAC 05 04 06 06 05 06 04 09  ........
!byte   $07,$05                         ; ECB4 07 05                    ..
; ----------------------------------------------------------------------------
; Function key definitions
keydef1:!scr   "PRINT"                         ; ECB6 50 52 49 4E 54           PRINT
; Text for function key F2
keydef2:!scr   "LIST"                          ; ECBB 4C 49 53 54              LIST
; Text for function key F3
keydef3:!scr   "DLOAD"                         ; ECBF 44 4C 4F 41 44           DLOAD
!byte   $22                             ; ECC4 22                       "
; Text for function key F4
keydef4:!scr   "DSAVE"                         ; ECC5 44 53 41 56 45           DSAVE
!byte   $22                             ; ECCA 22                       "
; Text for function key F5
keydef5:!scr   "DOPEN"                         ; ECCB 44 4F 50 45 4E           DOPEN
; Text for function key F6
keydef6:!scr   "DCLOSE"                        ; ECD0 44 43 4C 4F 53 45        DCLOSE
; Text for function key F7
keydef7:!scr   "COPY"                          ; ECD6 43 4F 50 59              COPY
; Text for function key F8
keydef8:!scr   "DIRECTORY"                     ; ECDA 44 49 52 45 43 54 4F 52  DIRECTOR
                                                ; ECE2 59                       Y
; Text for function key F9
keydef9:!scr   "SCRATCH"                       ; ECE3 53 43 52 41 54 43 48     SCRATCH
; Text for function key F10
keydef10:!scr   "CHR$("                         ; ECEA 43 48 52 24 28           CHR$(
; ----------------------------------------------------------------------------
; Generic bit mask table
bits:
!byte   $80,$40,$20,$10,$08,$04,$02,$01 ; ECEF 80 40 20 10 08 04 02 01  .@ .....
; Register values for VIC initialization
vicinit:
!byte   $1B,$00,$00,$00,$00,$08,$00,$40 ; ECF7 1B 00 00 00 00 08 00 40  .......@
!byte   $8F,$00,$00,$00,$00,$00,$00,$03 ; ECFF 8F 00 00 00 00 00 00 03  ........
!byte   $01                             ; ED07 01                       .
; ----------------------------------------------------------------------------
; Extended editor vector table (copied to $3B5)
edvect: !word   LE9F6                           ; ED08 F6 E9                    ..
        !word   wrtvram                         ; ED0A 41 E6                    A.
        !word   wrtcram                         ; ED0C 50 E6                    P.
        !word   nofunc                          ; ED0E 39 E0                    9.
        !word   nofunc                          ; ED10 39 E0                    9.
; ----------------------------------------------------------------------------
; Table with color values
colortb:
!byte   $90,$05,$1C,$9F,$9C,$1E,$1F,$9E ; ED12 90 05 1C 9F 9C 1E 1F 9E  ........
!byte   $81,$95,$96,$97,$98,$99,$9A,$9B ; ED1A 81 95 96 97 98 99 9A 9B  ........
; Unused space
unused1:
!byte   $00,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED22 00 AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED2A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED32 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED3A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED42 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED4A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED52 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED5A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED62 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED6A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED72 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED7A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED82 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED8A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED92 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; ED9A AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDA2 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDAA AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDB2 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDBA AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDC2 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDCA AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDD2 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDDA AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDE2 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDEA AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; EDF2 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA         ; EDFA AA AA AA AA AA AA        ......
; ----------------------------------------------------------------------------
; Monitor entry after boot (no basic)
monitor:jsr     ioinit                          ; EE00 20 FE F9                  ..
        jsr     restor                          ; EE03 20 B1 FB                  ..
        jsr     jcint                           ; EE06 20 04 E0                  ..
; Monitor cold start
moncold:jsr     kclrch                          ; EE09 20 CC FF                  ..
        lda     #$5A                            ; EE0C A9 5A                    .Z
        ldx     #$00                            ; EE0E A2 00                    ..
        ldy     #$EE                            ; EE10 A0 EE                    ..
        jsr     vreset                          ; EE12 20 D9 FB                  ..
        cli                                     ; EE15 58                       X
; Monitor entry using SYS
timc:   lda     #$C0                            ; EE16 A9 C0                    ..
        sta     msgflg                          ; EE18 8D 61 03                 .a.
        lda     #$40                            ; EE1B A9 40                    .@
        sta     tmpc                            ; EE1D 85 BD                    ..
        bne     b3                              ; EE1F D0 10                    ..
; Monitor entry via BRK
timb:   jsr     kclrch                          ; EE21 20 CC FF                  ..
        lda     #$53                            ; EE24 A9 53                    .S
        sta     tmpc                            ; EE26 85 BD                    ..
        cld                                     ; EE28 D8                       .
        ldx     #$05                            ; EE29 A2 05                    ..
; Pop registers from stack and save them
b2:     pla                                     ; EE2B 68                       h
        sta     pch,x                           ; EE2C 95 AE                    ..
        dex                                     ; EE2E CA                       .
        bpl     b2                              ; EE2F 10 FA                    ..
; Save indirect segment and other stuff
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
; Invalid monitor input, print "?" + CR + "."
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
st1:    jsr     kbasin                          ; EE69 20 CF FF                  ..
        cmp     #$20                            ; EE6C C9 20                    . 
        beq     st1                             ; EE6E F0 F9                    ..
        jmp     (usrcmd)                        ; EE70 6C 1E 03                 l..

; ----------------------------------------------------------------------------
; Search for a monitor command in the table
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
        sta     tmp1                            ; EE8A 85 B9                    ..
        lda     cmds+2,x                        ; EE8C BD D3 EE                 ...
        sta     tmp1+1                          ; EE8F 85 BA                    ..
        jmp     (tmp1)                          ; EE91 6C B9 00                 l..

; ----------------------------------------------------------------------------
; Increment X to point to next command in table
s2:     inx                                     ; EE94 E8                       .
        inx                                     ; EE95 E8                       .
        inx                                     ; EE96 E8                       .
        cpx     #$24                            ; EE97 E0 24                    .$
        bcc     s1                              ; EE99 90 E4                    ..
        ldx     #$00                            ; EE9B A2 00                    ..
; Check for a disk command
s3:     cmp     #$0D                            ; EE9D C9 0D                    ..
        beq     s4                              ; EE9F F0 0D                    ..
        cmp     #$20                            ; EEA1 C9 20                    . 
        beq     s4                              ; EEA3 F0 09                    ..
        sta     $0200,x                         ; EEA5 9D 00 02                 ...
        jsr     kbasin                          ; EEA8 20 CF FF                  ..
        inx                                     ; EEAB E8                       .
        bne     s3                              ; EEAC D0 EF                    ..
; Handle a disk command
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
        jsr     kload                           ; EEC6 20 D5 FF                  ..
        bcs     s5                              ; EEC9 B0 05                    ..
        lda     tmpc                            ; EECB A5 BD                    ..
        jmp     (stal)                          ; EECD 6C 99 00                 l..

; ----------------------------------------------------------------------------
s5:     rts                                     ; EED0 60                       `

; ----------------------------------------------------------------------------
; Table with monitor commands. One letter command followed by address.
cmds:
!scr         ":"                             ; EED1 3A                       :
; ----------------------------------------------------------------------------
        !word   msetmem                         ; EED2 F7 EF                    ..
; ----------------------------------------------------------------------------
!scr         ";"                             ; EED4 3B                       ;
; ----------------------------------------------------------------------------
        !word   msetreg                         ; EED5 C5 EF                    ..
; ----------------------------------------------------------------------------
!scr         "R"                             ; EED7 52                       R
; ----------------------------------------------------------------------------
        !word   mregs                           ; EED8 41 EF                    A.
; ----------------------------------------------------------------------------
!scr         "M"                             ; EEDA 4D                       M
; ----------------------------------------------------------------------------
        !word   mdump                           ; EEDB 84 EF                    ..
; ----------------------------------------------------------------------------
!scr         "G"                             ; EEDD 47                       G
; ----------------------------------------------------------------------------
        !word   mgo                             ; EEDE 14 F0                    ..
; ----------------------------------------------------------------------------
!scr         "L"                             ; EEE0 4C                       L
; ----------------------------------------------------------------------------
        !word   mload                           ; EEE1 43 F0                    C.
; ----------------------------------------------------------------------------
!scr         "S"                             ; EEE3 53                       S
; ----------------------------------------------------------------------------
        !word   mload                           ; EEE4 43 F0                    C.
; ----------------------------------------------------------------------------
!scr         "V"                             ; EEE6 56                       V
; ----------------------------------------------------------------------------
        !word   mbank                           ; EEE7 DF EF                    ..
; ----------------------------------------------------------------------------
!pet   "@"                             ; EEE9 40                       @
; ----------------------------------------------------------------------------
        !word   mdisk                           ; EEEA 68 F1                    h.
; ----------------------------------------------------------------------------
!scr         "Z"                             ; EEEC 5A                       Z
; ----------------------------------------------------------------------------
        !word   kipcgo                          ; EEED 72 FF                    r.
; ----------------------------------------------------------------------------
!scr         "X"                             ; EEEF 58                       X
; ----------------------------------------------------------------------------
        !word   mexit                           ; EEF0 F5 EE                    ..
; ----------------------------------------------------------------------------
!scr         "U"                             ; EEF2 55                       U
; ----------------------------------------------------------------------------
        !word   mdunit                          ; EEF3 EB EF                    ..
; ----------------------------------------------------------------------------
; Monitor command 'x' (exit)
mexit:  pla                                     ; EEF5 68                       h
        pla                                     ; EEF6 68                       h
        sei                                     ; EEF7 78                       x
        jmp     (evect)                         ; EEF8 6C F8 03                 l..

; ----------------------------------------------------------------------------
; Move tmp1/tmp1+1 to PC memory location
putpc:  lda     tmp1                            ; EEFB A5 B9                    ..
        sta     pcl                             ; EEFD 85 AF                    ..
        lda     tmp1+1                          ; EEFF A5 BA                    ..
        sta     pch                             ; EF01 85 AE                    ..
        rts                                     ; EF03 60                       `

; ----------------------------------------------------------------------------
; Set tmp1 to point to the saved regs in zero page
setr:   lda     #$B0                            ; EF04 A9 B0                    ..
        sta     tmp1                            ; EF06 85 B9                    ..
        lda     #$00                            ; EF08 A9 00                    ..
        sta     tmp1+1                          ; EF0A 85 BA                    ..
        lda     #$0F                            ; EF0C A9 0F                    ..
        sta     i6509                           ; EF0E 85 01                    ..
        lda     #$05                            ; EF10 A9 05                    ..
        rts                                     ; EF12 60                       `

; ----------------------------------------------------------------------------
; Print CR + '.' + A + ' '
altrit: pha                                     ; EF13 48                       H
        jsr     crlf                            ; EF14 20 21 EF                  !.
        pla                                     ; EF17 68                       h
        jsr     kbsout                          ; EF18 20 D2 FF                  ..
; Print ' '
space:  lda     #$20                            ; EF1B A9 20                    . 
!byte   $2C                             ; EF1D 2C                       ,
; Print '?'
outqst: lda     #$3F                            ; EF1E A9 3F                    .?
!byte   $2C                             ; EF20 2C                       ,
; Print CR + '.'
crlf:   lda     #$0D                            ; EF21 A9 0D                    ..
        jmp     kbsout                          ; EF23 4C D2 FF                 L..

; ----------------------------------------------------------------------------
; Header for 'r' command
reghead:
!byte   $0D                             ; EF26 0D                       .
!scr   "   PC  IRQ  SR AC XR YR SP"    ; EF27 20 20 20 50 43 20 20 49     PC  I
                                                ; EF2F 52 51 20 20 53 52 20 41  RQ  SR A
                                                ; EF37 43 20 58 52 20 59 52 20  C XR YR 
                                                ; EF3F 53 50                    SP
; ----------------------------------------------------------------------------
; Monitor command 'r' (regs)
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
        lda     (tmp1),y                        ; EF70 B1 B9                    ..
        jsr     hex2                            ; EF72 20 FE F0                  ..
        inc     tmp1                            ; EF75 E6 B9                    ..
        bne     LEF7F                           ; EF77 D0 06                    ..
        inc     tmp1+1                          ; EF79 E6 BA                    ..
        bne     LEF7F                           ; EF7B D0 02                    ..
        dec     fnlen                           ; EF7D C6 9D                    ..
LEF7F:  dec     tmpc                            ; EF7F C6 BD                    ..
        bne     LEF6D                           ; EF81 D0 EA                    ..
        rts                                     ; EF83 60                       `

; ----------------------------------------------------------------------------
; Monitor command 'm' (memory dump)
mdump:  jsr     rdfour                          ; EF84 20 26 F1                  &.
        bcs     LEFC2                           ; EF87 B0 39                    .9
        jsr     xchgtmp                         ; EF89 20 16 F1                  ..
        jsr     rdfour                          ; EF8C 20 26 F1                  &.
        bcc     LEF99                           ; EF8F 90 08                    ..
        lda     tmp2                            ; EF91 A5 BB                    ..
        sta     tmp1                            ; EF93 85 B9                    ..
        lda     tmp2+1                          ; EF95 A5 BC                    ..
        sta     tmp1+1                          ; EF97 85 BA                    ..
LEF99:  jsr     xchgtmp                         ; EF99 20 16 F1                  ..
LEF9C:  jsr     kstop                           ; EF9C 20 E1 FF                  ..
        beq     LEFC1                           ; EF9F F0 20                    . 
        lda     #$3A                            ; EFA1 A9 3A                    .:
        jsr     altrit                          ; EFA3 20 13 EF                  ..
        ldx     tmp1+1                          ; EFA6 A6 BA                    ..
        ldy     tmp1                            ; EFA8 A4 B9                    ..
        jsr     hex4                            ; EFAA 20 F9 F0                  ..
        lda     #$08                            ; EFAD A9 08                    ..
        jsr     LEF67                           ; EFAF 20 67 EF                  g.
        lda     fnlen                           ; EFB2 A5 9D                    ..
        bne     LEFC1                           ; EFB4 D0 0B                    ..
        sec                                     ; EFB6 38                       8
        lda     tmp2                            ; EFB7 A5 BB                    ..
        sbc     tmp1                            ; EFB9 E5 B9                    ..
        lda     tmp2+1                          ; EFBB A5 BC                    ..
        sbc     tmp1+1                          ; EFBD E5 BA                    ..
        bcs     LEF9C                           ; EFBF B0 DB                    ..
LEFC1:  rts                                     ; EFC1 60                       `

; ----------------------------------------------------------------------------
LEFC2:  jmp     erropr                          ; EFC2 4C 50 EE                 LP.

; ----------------------------------------------------------------------------
; Monitor command ';' (set registers)
msetreg:jsr     rdfour                          ; EFC5 20 26 F1                  &.
        bcs     LEFC2                           ; EFC8 B0 F8                    ..
        jsr     putpc                           ; EFCA 20 FB EE                  ..
        jsr     rdfour                          ; EFCD 20 26 F1                  &.
        bcs     LEFC2                           ; EFD0 B0 F0                    ..
        lda     tmp1                            ; EFD2 A5 B9                    ..
        sta     invl                            ; EFD4 85 B8                    ..
        lda     tmp1+1                          ; EFD6 A5 BA                    ..
        sta     invh                            ; EFD8 85 B7                    ..
        jsr     setr                            ; EFDA 20 04 EF                  ..
        bne     LEFFE                           ; EFDD D0 1F                    ..
; Monitor command 'v' (set bank)
mbank:  jsr     rdtwo                           ; EFDF 20 33 F1                  3.
        bcs     LEFC2                           ; EFE2 B0 DE                    ..
        cmp     #$10                            ; EFE4 C9 10                    ..
        bcs     LEFC2                           ; EFE6 B0 DA                    ..
        sta     i6509                           ; EFE8 85 01                    ..
        rts                                     ; EFEA 60                       `

; ----------------------------------------------------------------------------
; Monitor command 'u' (unit)
mdunit: jsr     rdtwo                           ; EFEB 20 33 F1                  3.
        bcs     LEFC2                           ; EFEE B0 D2                    ..
        cmp     #$20                            ; EFF0 C9 20                    . 
        bcs     LEFC2                           ; EFF2 B0 CE                    ..
        sta     ddisk                           ; EFF4 85 BF                    ..
        rts                                     ; EFF6 60                       `

; ----------------------------------------------------------------------------
; Monitor command ':' (set memory)
msetmem:jsr     rdfour                          ; EFF7 20 26 F1                  &.
        bcs     LEFC2                           ; EFFA B0 C6                    ..
        lda     #$08                            ; EFFC A9 08                    ..
LEFFE:  sta     tmpc                            ; EFFE 85 BD                    ..
-       jsr     rdtwo                           ; F000 20 33 F1                  3.
        bcs     ++                              ; F003 B0 0E                    ..
        ldy     #$00                            ; F005 A0 00                    ..
        sta     (tmp1),y                        ; F007 91 B9                    ..
        inc     tmp1                            ; F009 E6 B9                    ..
        bne     +                               ; F00B D0 02                    ..
        inc     tmp1+1                          ; F00D E6 BA                    ..
+       dec     tmpc                            ; F00F C6 BD                    ..
        bne     -                               ; F011 D0 ED                    ..
++      rts                                     ; F013 60                       `

; ----------------------------------------------------------------------------
; Monitor command 'g' (go)
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

; ----------------------------------------------------------------------------
LF040:  jmp     erropr                          ; F040 4C 50 EE                 LP.

; ----------------------------------------------------------------------------
; Monitor commands 'l' and 's' (load & save)
mload:  ldy     #$01                            ; F043 A0 01                    ..
        sty     fa                              ; F045 84 9F                    ..
        dey                                     ; F047 88                       .
        lda     #$FF                            ; F048 A9 FF                    ..
        sta     tmp1                            ; F04A 85 B9                    ..
        sta     tmp1+1                          ; F04C 85 BA                    ..
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
        ldx     tmp1                            ; F082 A6 B9                    ..
        ldy     tmp1+1                          ; F084 A4 BA                    ..
        jmp     kload                           ; F086 4C D5 FF                 L..

; ----------------------------------------------------------------------------
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
        lda     tmp1                            ; F0B4 A5 B9                    ..
        sta     stal                            ; F0B6 85 99                    ..
        lda     tmp1+1                          ; F0B8 A5 BA                    ..
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
        lda     tmp1                            ; F0D5 A5 B9                    ..
        sta     eal                             ; F0D7 85 96                    ..
        lda     tmp1+1                          ; F0D9 A5 BA                    ..
        sta     eah                             ; F0DB 85 97                    ..
LF0DD:  jsr     kbasin                          ; F0DD 20 CF FF                  ..
        cmp     #$20                            ; F0E0 C9 20                    . 
        beq     LF0DD                           ; F0E2 F0 F9                    ..
        cmp     #$0D                            ; F0E4 C9 0D                    ..
LF0E6:  bne     LF0A0                           ; F0E6 D0 B8                    ..
        lda     savx                            ; F0E8 AD 66 03                 .f.
        cmp     #$53                            ; F0EB C9 53                    .S
        bne     LF0E6                           ; F0ED D0 F7                    ..
        ldx     #$99                            ; F0EF A2 99                    ..
        ldy     #$96                            ; F0F1 A0 96                    ..
        jmp     ksave                           ; F0F3 4C D8 FF                 L..

; ----------------------------------------------------------------------------
LF0F6:  jmp     erropr                          ; F0F6 4C 50 EE                 LP.

; ----------------------------------------------------------------------------
; Output X/Y as 4 hex bytes
hex4:   txa                                     ; F0F9 8A                       .
        jsr     hex2                            ; F0FA 20 FE F0                  ..
        tya                                     ; F0FD 98                       .
; Output A as two hex bytes
hex2:   pha                                     ; F0FE 48                       H
        lsr                                     ; F0FF 4A                       J
        lsr                                     ; F100 4A                       J
        lsr                                     ; F101 4A                       J
        lsr                                     ; F102 4A                       J
        jsr     hex1                            ; F103 20 0A F1                  ..
        tax                                     ; F106 AA                       .
        pla                                     ; F107 68                       h
        and     #$0F                            ; F108 29 0F                    ).
; Output low nibble of A as one hex byte
hex1:   clc                                     ; F10A 18                       .
        adc     #$F6                            ; F10B 69 F6                    i.
        bcc     LF111                           ; F10D 90 02                    ..
        adc     #$06                            ; F10F 69 06                    i.
LF111:  adc     #$3A                            ; F111 69 3A                    i:
        jmp     kbsout                          ; F113 4C D2 FF                 L..

; ----------------------------------------------------------------------------
; Exchange tmp1 and invl
xchgtmp:ldx     #$02                            ; F116 A2 02                    ..
-       lda     invl,x                          ; F118 B5 B8                    ..
        pha                                     ; F11A 48                       H
        lda     tmp1+1,x                        ; F11B B5 BA                    ..
        sta     invl,x                          ; F11D 95 B8                    ..
        pla                                     ; F11F 68                       h
        sta     tmp1+1,x                        ; F120 95 BA                    ..
        dex                                     ; F122 CA                       .
        bne     -                               ; F123 D0 F3                    ..
        rts                                     ; F125 60                       `

; ----------------------------------------------------------------------------
; Read 4 chars from input into tmp1/tmp1+1
rdfour: jsr     rdtwo                           ; F126 20 33 F1                  3.
        bcs     +                               ; F129 B0 07                    ..
        sta     tmp1+1                          ; F12B 85 BA                    ..
        jsr     rdtwo                           ; F12D 20 33 F1                  3.
        sta     tmp1                            ; F130 85 B9                    ..
+       rts                                     ; F132 60                       `

; ----------------------------------------------------------------------------
; Read 2 chars from input into A
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

; ----------------------------------------------------------------------------
; Convert char in A into hex value
hexit:  cmp     #$3A                            ; F157 C9 3A                    .:
        php                                     ; F159 08                       .
        and     #$0F                            ; F15A 29 0F                    ).
        plp                                     ; F15C 28                       (
        bcc     +                               ; F15D 90 02                    ..
        adc     #$08                            ; F15F 69 08                    i.
+       rts                                     ; F161 60                       `

; ----------------------------------------------------------------------------
; Input one char, check for CR
rdone:  jsr     kbasin                          ; F162 20 CF FF                  ..
        cmp     #$0D                            ; F165 C9 0D                    ..
        rts                                     ; F167 60                       `

; ----------------------------------------------------------------------------
; Monitor command '@' (disk commands)
mdisk:  lda     #$00                            ; F168 A9 00                    ..
        sta     status                          ; F16A 85 9C                    ..
        sta     fnlen                           ; F16C 85 9D                    ..
        ldx     ddisk                           ; F16E A6 BF                    ..
        ldy     #$0F                            ; F170 A0 0F                    ..
        jsr     setlfs                          ; F172 20 4F FB                  O.
        clc                                     ; F175 18                       .
        jsr     kopen                           ; F176 20 C0 FF                  ..
        bcs     LF1BF                           ; F179 B0 44                    .D
        jsr     rdone                           ; F17B 20 62 F1                  b.
        beq     LF19D                           ; F17E F0 1D                    ..
        pha                                     ; F180 48                       H
        ldx     #$00                            ; F181 A2 00                    ..
        jsr     kckout                          ; F183 20 C9 FF                  ..
        pla                                     ; F186 68                       h
        bcs     LF1BF                           ; F187 B0 36                    .6
        bcc     LF18E                           ; F189 90 03                    ..
LF18B:  jsr     kbasin                          ; F18B 20 CF FF                  ..
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
        jsr     kchkin                          ; F1A2 20 C6 FF                  ..
        bcs     LF1BF                           ; F1A5 B0 18                    ..
LF1A7:  jsr     kbasin                          ; F1A7 20 CF FF                  ..
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
LF1BF:  jsr     kclrch                          ; F1BF 20 CC FF                  ..
        lda     #$00                            ; F1C2 A9 00                    ..
        clc                                     ; F1C4 18                       .
        jmp     kclose                          ; F1C5 4C C3 FF                 L..

; ----------------------------------------------------------------------------
!byte   $EA,$EA                         ; F1C8 EA EA                    ..
; ----------------------------------------------------------------------------
; Table with kernal messages
kmsgtab:
!byte   $0D                             ; F1CA 0D                       .
!scr   "I/O ERROR "                    ; F1CB 49 2F 4F 20 45 52 52 4F  I/O ERRO
                                                ; F1D3 52 20                    R 
!byte   $A3,$0D                         ; F1D5 A3 0D                    ..
!scr   "SEARCHING"                     ; F1D7 53 45 41 52 43 48 49 4E  SEARCHIN
                                                ; F1DF 47                       G
!byte   $A0                             ; F1E0 A0                       .
!scr   "FOR"                           ; F1E1 46 4F 52                 FOR
!byte   $A0,$0D                         ; F1E4 A0 0D                    ..
!scr   "LOADIN"                        ; F1E6 4C 4F 41 44 49 4E        LOADIN
!byte   $C7,$0D                         ; F1EC C7 0D                    ..
!scr   "SAVING"                        ; F1EE 53 41 56 49 4E 47        SAVING
!byte   $A0,$0D                         ; F1F4 A0 0D                    ..
!scr   "VERIFYIN"                      ; F1F6 56 45 52 49 46 59 49 4E  VERIFYIN
!byte   $C7,$0D                         ; F1FE C7 0D                    ..
!scr   "FOUND"                         ; F200 46 4F 55 4E 44           FOUND
!byte   $A0,$0D                         ; F205 A0 0D                    ..
!scr   "OK"                            ; F207 4F 4B                    OK
!byte   $8D,$0D                         ; F209 8D 0D                    ..
!scr   "** MONITOR 1.0 **"             ; F20B 2A 2A 20 4D 4F 4E 49 54  ** MONIT
                                                ; F213 4F 52 20 31 2E 30 20 2A  OR 1.0 *
                                                ; F21B 2A                       *
!byte   $8D,$0D                         ; F21C 8D 0D                    ..
!scr   "BREA"                          ; F21E 42 52 45 41              BREA
!byte   $CB                             ; F222 CB                       .
; ----------------------------------------------------------------------------
; Test error flag, print system message
spmsg:  bit     msgflg                          ; F223 2C 61 03                 ,a.
        bpl     LF235                           ; F226 10 0D                    ..
; Print system message, offset in Y
msg:    lda     kmsgtab,y                       ; F228 B9 CA F1                 ...
        php                                     ; F22B 08                       .
        and     #$7F                            ; F22C 29 7F                    ).
        jsr     kbsout                          ; F22E 20 D2 FF                  ..
        iny                                     ; F231 C8                       .
        plp                                     ; F232 28                       (
        bpl     msg                             ; F233 10 F3                    ..
LF235:  clc                                     ; F235 18                       .
        rts                                     ; F236 60                       `

; ----------------------------------------------------------------------------
; Output talk on IEC bus
talk:   ora     #$40                            ; F237 09 40                    .@
        bne     LF23D                           ; F239 D0 02                    ..
; Output listen on IEC bus
listn:  ora     #$20                            ; F23B 09 20                    . 
LF23D:  pha                                     ; F23D 48                       H
        lda     #$3B                            ; F23E A9 3B                    .;
        sta     tpi1_ddra                       ; F240 8D 03 DE                 ...
        lda     #$FF                            ; F243 A9 FF                    ..
        sta     cia2_pra                        ; F245 8D 00 DC                 ...
        sta     cia2_ddra                       ; F248 8D 02 DC                 ...
        lda     #$FE                            ; F24B A9 FE                    ..
        sta     tpi1_pa                         ; F24D 8D 00 DE                 ...
        lda     c3po                            ; F250 A5 AA                    ..
        bpl     LF26F                           ; F252 10 1B                    ..
        lda     tpi1_pa                         ; F254 AD 00 DE                 ...
        and     #$DF                            ; F257 29 DF                    ).
        sta     tpi1_pa                         ; F259 8D 00 DE                 ...
        lda     bsour                           ; F25C A5 AB                    ..
        jsr     txbyte                          ; F25E 20 C0 F2                  ..
        lda     c3po                            ; F261 A5 AA                    ..
        and     #$7F                            ; F263 29 7F                    ).
        sta     c3po                            ; F265 85 AA                    ..
        lda     tpi1_pa                         ; F267 AD 00 DE                 ...
        ora     #$20                            ; F26A 09 20                    . 
        sta     tpi1_pa                         ; F26C 8D 00 DE                 ...
LF26F:  lda     tpi1_pa                         ; F26F AD 00 DE                 ...
        and     #$F7                            ; F272 29 F7                    ).
        sta     tpi1_pa                         ; F274 8D 00 DE                 ...
        pla                                     ; F277 68                       h
        jmp     txbyte                          ; F278 4C C0 F2                 L..

; ----------------------------------------------------------------------------
; Output secondary address after listen on IEC bus
secnd:  jsr     txbyte                          ; F27B 20 C0 F2                  ..
; NOT ATN high after secnd
secatn: lda     tpi1_pa                         ; F27E AD 00 DE                 ...
        ora     #$08                            ; F281 09 08                    ..
        sta     tpi1_pa                         ; F283 8D 00 DE                 ...
        rts                                     ; F286 60                       `

; ----------------------------------------------------------------------------
; Output secondary address on IEC bus
tksa:   jsr     txbyte                          ; F287 20 C0 F2                  ..
tkatn:  lda     #$3D                            ; F28A A9 3D                    .=
        and     tpi1_pa                         ; F28C 2D 00 DE                 -..
; Output A on IEC, switch data to input
setlns: sta     tpi1_pa                         ; F28F 8D 00 DE                 ...
        lda     #$C3                            ; F292 A9 C3                    ..
        sta     tpi1_ddra                       ; F294 8D 03 DE                 ...
        lda     #$00                            ; F297 A9 00                    ..
        sta     cia2_ddra                       ; F299 8D 02 DC                 ...
        beq     secatn                          ; F29C F0 E0                    ..
; Output A on IEC with EOF flag
ciout:  pha                                     ; F29E 48                       H
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

; ----------------------------------------------------------------------------
; Output untalk on IEC
untalk: lda     #$5F                            ; F2B2 A9 5F                    ._
        bne     LF2B8                           ; F2B4 D0 02                    ..
; Output unlisten on IEC
unlsn:  lda     #$3F                            ; F2B6 A9 3F                    .?
LF2B8:  jsr     LF23D                           ; F2B8 20 3D F2                  =.
        lda     #$FD                            ; F2BB A9 FD                    ..
        jmp     setlns                          ; F2BD 4C 8F F2                 L..

; ----------------------------------------------------------------------------
; Output A on IEC without EOF flag
txbyte: eor     #$FF                            ; F2C0 49 FF                    I.
        sta     cia2_pra                        ; F2C2 8D 00 DC                 ...
        lda     tpi1_pa                         ; F2C5 AD 00 DE                 ...
        ora     #$12                            ; F2C8 09 12                    ..
        sta     tpi1_pa                         ; F2CA 8D 00 DE                 ...
        bit     tpi1_pa                         ; F2CD 2C 00 DE                 ,..
        bvc     txbyt1                          ; F2D0 50 09                    P.
        bpl     txbyt1                          ; F2D2 10 07                    ..
        lda     #$80                            ; F2D4 A9 80                    ..
        jsr     udst                            ; F2D6 20 6E FB                  n.
        bne     txbyt6                          ; F2D9 D0 30                    .0
txbyt1: lda     tpi1_pa                         ; F2DB AD 00 DE                 ...
        bpl     txbyt1                          ; F2DE 10 FB                    ..
        and     #$EF                            ; F2E0 29 EF                    ).
        sta     tpi1_pa                         ; F2E2 8D 00 DE                 ...
txbyt2: jsr     timeron                         ; F2E5 20 76 F3                  v.
        bcc     txbyt4                          ; F2E8 90 01                    ..
txbyt3: sec                                     ; F2EA 38                       8
txbyt4: bit     tpi1_pa                         ; F2EB 2C 00 DE                 ,..
        bvs     txbyt5                          ; F2EE 70 13                    p.
        lda     cia2_icr                        ; F2F0 AD 0D DC                 ...
        and     #$02                            ; F2F3 29 02                    ).
        beq     txbyt4                          ; F2F5 F0 F4                    ..
        lda     timout                          ; F2F7 AD 5E 03                 .^.
        bmi     txbyt2                          ; F2FA 30 E9                    0.
        bcc     txbyt3                          ; F2FC 90 EC                    ..
        lda     #$01                            ; F2FE A9 01                    ..
        jsr     udst                            ; F300 20 6E FB                  n.
txbyt5: lda     tpi1_pa                         ; F303 AD 00 DE                 ...
        ora     #$10                            ; F306 09 10                    ..
        sta     tpi1_pa                         ; F308 8D 00 DE                 ...
txbyt6: lda     #$FF                            ; F30B A9 FF                    ..
        sta     cia2_pra                        ; F30D 8D 00 DC                 ...
        rts                                     ; F310 60                       `

; ----------------------------------------------------------------------------
; Read char from IEC bus into A
acptr:  lda     tpi1_pa                         ; F311 AD 00 DE                 ...
        and     #$BD                            ; F314 29 BD                    ).
        ora     #$81                            ; F316 09 81                    ..
        sta     tpi1_pa                         ; F318 8D 00 DE                 ...
LF31B:  jsr     timeron                         ; F31B 20 76 F3                  v.
        bcc     LF321                           ; F31E 90 01                    ..
LF320:  sec                                     ; F320 38                       8
LF321:  lda     tpi1_pa                         ; F321 AD 00 DE                 ...
        and     #$10                            ; F324 29 10                    ).
        beq     LF346                           ; F326 F0 1E                    ..
        lda     cia2_icr                        ; F328 AD 0D DC                 ...
        and     #$02                            ; F32B 29 02                    ).
        beq     LF321                           ; F32D F0 F2                    ..
        lda     timout                          ; F32F AD 5E 03                 .^.
        bmi     LF31B                           ; F332 30 E7                    0.
        bcc     LF320                           ; F334 90 EA                    ..
        lda     #$02                            ; F336 A9 02                    ..
        jsr     udst                            ; F338 20 6E FB                  n.
        lda     tpi1_pa                         ; F33B AD 00 DE                 ...
        and     #$3D                            ; F33E 29 3D                    )=
        sta     tpi1_pa                         ; F340 8D 00 DE                 ...
        lda     #$0D                            ; F343 A9 0D                    ..
        rts                                     ; F345 60                       `

; ----------------------------------------------------------------------------
LF346:  lda     tpi1_pa                         ; F346 AD 00 DE                 ...
        and     #$7F                            ; F349 29 7F                    ).
        sta     tpi1_pa                         ; F34B 8D 00 DE                 ...
        and     #$20                            ; F34E 29 20                    ) 
        bne     LF357                           ; F350 D0 05                    ..
        lda     #$40                            ; F352 A9 40                    .@
        jsr     udst                            ; F354 20 6E FB                  n.
LF357:  lda     cia2_pra                        ; F357 AD 00 DC                 ...
        eor     #$FF                            ; F35A 49 FF                    I.
        pha                                     ; F35C 48                       H
        lda     tpi1_pa                         ; F35D AD 00 DE                 ...
        ora     #$40                            ; F360 09 40                    .@
        sta     tpi1_pa                         ; F362 8D 00 DE                 ...
LF365:  lda     tpi1_pa                         ; F365 AD 00 DE                 ...
        and     #$10                            ; F368 29 10                    ).
        beq     LF365                           ; F36A F0 F9                    ..
        lda     tpi1_pa                         ; F36C AD 00 DE                 ...
        and     #$BF                            ; F36F 29 BF                    ).
        sta     tpi1_pa                         ; F371 8D 00 DE                 ...
        pla                                     ; F374 68                       h
        rts                                     ; F375 60                       `

; ----------------------------------------------------------------------------
; Set timer for timeout on IEC
timeron:lda     #$80                            ; F376 A9 80                    ..
        sta     cia2_tbhi                       ; F378 8D 07 DC                 ...
        lda     #$11                            ; F37B A9 11                    ..
        sta     cia2_crb                        ; F37D 8D 0F DC                 ...
        lda     cia2_icr                        ; F380 AD 0D DC                 ...
        clc                                     ; F383 18                       .
        rts                                     ; F384 60                       `

; ----------------------------------------------------------------------------
        jmp     error9                          ; F385 4C 58 F9                 LX.

; ----------------------------------------------------------------------------
; Open the RS232 port
open232:jsr     rdst232                         ; F388 20 35 F4                  5.
        ldy     #$00                            ; F38B A0 00                    ..
LF38D:  cpy     fnlen                           ; F38D C4 9D                    ..
        beq     LF39C                           ; F38F F0 0B                    ..
        jsr     fnadry                          ; F391 20 A0 FE                  ..
        sta     m51ctr,y                        ; F394 99 76 03                 .v.
        iny                                     ; F397 C8                       .
        cpy     #$04                            ; F398 C0 04                    ..
        bne     LF38D                           ; F39A D0 F1                    ..
LF39C:  lda     m51ctr                          ; F39C AD 76 03                 .v.
        sta     acia_ctrl                       ; F39F 8D 03 DD                 ...
        lda     m51cdr                          ; F3A2 AD 77 03                 .w.
        and     #$F2                            ; F3A5 29 F2                    ).
        ora     #$02                            ; F3A7 09 02                    ..
        sta     acia_cmd                        ; F3A9 8D 02 DD                 ...
        clc                                     ; F3AC 18                       .
        lda     sa                              ; F3AD A5 A0                    ..
        and     #$02                            ; F3AF 29 02                    ).
        beq     LF3C8                           ; F3B1 F0 15                    ..
        lda     ridbe                           ; F3B3 AD 7D 03                 .}.
        sta     ridbs                           ; F3B6 8D 7C 03                 .|.
        lda     ribuf+2                         ; F3B9 A5 A8                    ..
        and     #$F0                            ; F3BB 29 F0                    ).
        beq     LF3C8                           ; F3BD F0 09                    ..
        jsr     aloc256                         ; F3BF 20 03 F4                  ..
        sta     ribuf+2                         ; F3C2 85 A8                    ..
        stx     ribuf                           ; F3C4 86 A6                    ..
        sty     ribuf+1                         ; F3C6 84 A7                    ..
LF3C8:  bcc     LF3CD                           ; F3C8 90 03                    ..
        jmp     errorx                          ; F3CA 4C 5A F9                 LZ.

; ----------------------------------------------------------------------------
LF3CD:  rts                                     ; F3CD 60                       `

; ----------------------------------------------------------------------------
; Convert PETSCII into ASCII for RS232
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

; ----------------------------------------------------------------------------
; Convert ASCII to PETSCII for RS232
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

; ----------------------------------------------------------------------------
; Allow RS232 interrupts
xon232: lda     acia_cmd                        ; F3F8 AD 02 DD                 ...
        ora     #$09                            ; F3FB 09 09                    ..
        and     #$FB                            ; F3FD 29 FB                    ).
        sta     acia_cmd                        ; F3FF 8D 02 DD                 ...
        rts                                     ; F402 60                       `

; ----------------------------------------------------------------------------
; Allocate 256 bytes as RS232 buffer
aloc256:ldx     #$00                            ; F403 A2 00                    ..
        ldy     #$01                            ; F405 A0 01                    ..
; Allocate buffer space
alloc:  txa                                     ; F407 8A                       .
        sec                                     ; F408 38                       8
        eor     #$FF                            ; F409 49 FF                    I.
        adc     hiadr                           ; F40B 6D 55 03                 mU.
        tax                                     ; F40E AA                       .
        tya                                     ; F40F 98                       .
        eor     #$FF                            ; F410 49 FF                    I.
        adc     hiadr+1                         ; F412 6D 56 03                 mV.
        tay                                     ; F415 A8                       .
        lda     hiadr+2                         ; F416 AD 57 03                 .W.
        bcs     LF421                           ; F419 B0 06                    ..
        lda     #$FF                            ; F41B A9 FF                    ..
LF41D:  ora     #$40                            ; F41D 09 40                    .@
        sec                                     ; F41F 38                       8
        rts                                     ; F420 60                       `

; ----------------------------------------------------------------------------
LF421:  cpy     memsiz+1                        ; F421 CC 5C 03                 .\.
        bcc     LF41D                           ; F424 90 F7                    ..
        bne     LF42D                           ; F426 D0 05                    ..
        cpx     memsiz                          ; F428 EC 5B 03                 .[.
        bcc     LF41D                           ; F42B 90 F0                    ..
LF42D:  stx     hiadr                           ; F42D 8E 55 03                 .U.
        sty     hiadr+1                         ; F430 8C 56 03                 .V.
        clc                                     ; F433 18                       .
        rts                                     ; F434 60                       `

; ----------------------------------------------------------------------------
; Read the RS232 status
rdst232:php                                     ; F435 08                       .
        sei                                     ; F436 78                       x
        lda     acia_status                     ; F437 AD 01 DD                 ...
        and     #$60                            ; F43A 29 60                    )`
        sta     rsstat                          ; F43C 8D 7A 03                 .z.
        sta     dcdsr                           ; F43F 8D 7B 03                 .{.
        plp                                     ; F442 28                       (
        rts                                     ; F443 60                       `

; ----------------------------------------------------------------------------
; GETIN: Input 1 byte from the current input device
getin:  lda     dfltn                           ; F444 A5 A1                    ..
        bne     getinc2                         ; F446 D0 0C                    ..
        lda     ndx                             ; F448 A5 D1                    ..
        ora     kyndx                           ; F44A 05 D6                    ..
        beq     LF4A1                           ; F44C F0 53                    .S
        sei                                     ; F44E 78                       x
        jsr     jrdkey                          ; F44F 20 07 E0                  ..
        clc                                     ; F452 18                       .
        rts                                     ; F453 60                       `

; ----------------------------------------------------------------------------
; Check for input from device 2 (RS232)
getinc2:cmp     #$02                            ; F454 C9 02                    ..
        beq     getin2                          ; F456 F0 03                    ..
        jmp     kbasin                          ; F458 4C CF FF                 L..

; ----------------------------------------------------------------------------
; GETIN routine for device 2 (RS232)
getin2: sty     xsav                            ; F45B 8C 65 03                 .e.
        stx     savx                            ; F45E 8E 66 03                 .f.
        ldy     ridbs                           ; F461 AC 7C 03                 .|.
        cpy     ridbe                           ; F464 CC 7D 03                 .}.
        bne     gn232a                          ; F467 D0 16                    ..
        lda     acia_cmd                        ; F469 AD 02 DD                 ...
        and     #$FD                            ; F46C 29 FD                    ).
        ora     #$01                            ; F46E 09 01                    ..
        sta     acia_cmd                        ; F470 8D 02 DD                 ...
        lda     rsstat                          ; F473 AD 7A 03                 .z.
        ora     #$10                            ; F476 09 10                    ..
        sta     rsstat                          ; F478 8D 7A 03                 .z.
        lda     #$00                            ; F47B A9 00                    ..
        beq     LF49B                           ; F47D F0 1C                    ..
; Get one byte from RS232 input buffer
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

; ----------------------------------------------------------------------------
; BASIN: Input 1 byte from the current input device
basin:  lda     dfltn                           ; F4A3 A5 A1                    ..
        bne     basinc3                         ; F4A5 D0 0B                    ..
        lda     pntr                            ; F4A7 A5 CB                    ..
        sta     lstp                            ; F4A9 85 CE                    ..
        lda     tblx                            ; F4AB A5 CA                    ..
        sta     lsxp                            ; F4AD 85 CF                    ..
        jmp     basin3                          ; F4AF 4C BC F4                 L..

; ----------------------------------------------------------------------------
; Check for input from device 3 (screen)
basinc3:cmp     #$03                            ; F4B2 C9 03                    ..
        bne     LF4C1                           ; F4B4 D0 0B                    ..
        sta     crsw                            ; F4B6 85 D0                    ..
        lda     scrt                            ; F4B8 A5 DF                    ..
        sta     indx                            ; F4BA 85 D5                    ..
; BASIN: input from device 3 (screen)
basin3: jsr     jscrget                         ; F4BC 20 0A E0                  ..
        clc                                     ; F4BF 18                       .
        rts                                     ; F4C0 60                       `

; ----------------------------------------------------------------------------
; BASIN dispatcher, check inut devices
LF4C1:  bcs     LF4CA                           ; F4C1 B0 07                    ..
        cmp     #$02                            ; F4C3 C9 02                    ..
        beq     basin2                          ; F4C5 F0 10                    ..
        jsr     tape                            ; F4C7 20 68 FE                  h.
LF4CA:  lda     status                          ; F4CA A5 9C                    ..
        beq     basind                          ; F4CC F0 04                    ..
LF4CE:  lda     #$0D                            ; F4CE A9 0D                    ..
LF4D0:  clc                                     ; F4D0 18                       .
LF4D1:  rts                                     ; F4D1 60                       `

; ----------------------------------------------------------------------------
; BASIN entry for IEC devices
basind: jsr     kacptr                          ; F4D2 20 A5 FF                  ..
        clc                                     ; F4D5 18                       .
        rts                                     ; F4D6 60                       `

; ----------------------------------------------------------------------------
; BASIN routine for device 2 (RS232)
basin2: jsr     kgetin                          ; F4D7 20 E4 FF                  ..
        bcs     LF4D1                           ; F4DA B0 F5                    ..
        cmp     #$00                            ; F4DC C9 00                    ..
        bne     LF4D0                           ; F4DE D0 F0                    ..
        lda     rsstat                          ; F4E0 AD 7A 03                 .z.
        and     #$10                            ; F4E3 29 10                    ).
        beq     LF4D0                           ; F4E5 F0 E9                    ..
        lda     rsstat                          ; F4E7 AD 7A 03                 .z.
        and     #$60                            ; F4EA 29 60                    )`
        bne     LF4CE                           ; F4EC D0 E0                    ..
        jsr     kstop                           ; F4EE 20 E1 FF                  ..
        bne     basin2                          ; F4F1 D0 E4                    ..
        sec                                     ; F4F3 38                       8
        rts                                     ; F4F4 60                       `

; ----------------------------------------------------------------------------
; Output 1 byte on current output device
bsout:  pha                                     ; F4F5 48                       H
        lda     dflto                           ; F4F6 A5 A2                    ..
        cmp     #$03                            ; F4F8 C9 03                    ..
        bne     LF502                           ; F4FA D0 06                    ..
        pla                                     ; F4FC 68                       h
        jsr     jprint                          ; F4FD 20 0D E0                  ..
        clc                                     ; F500 18                       .
        rts                                     ; F501 60                       `

; ----------------------------------------------------------------------------
LF502:  bcc     LF50A                           ; F502 90 06                    ..
        pla                                     ; F504 68                       h
        jsr     kciout                          ; F505 20 A8 FF                  ..
        clc                                     ; F508 18                       .
        rts                                     ; F509 60                       `

; ----------------------------------------------------------------------------
LF50A:  cmp     #$02                            ; F50A C9 02                    ..
        beq     LF518                           ; F50C F0 0A                    ..
        pla                                     ; F50E 68                       h
        jsr     tape                            ; F50F 20 68 FE                  h.
LF512:  pla                                     ; F512 68                       h
        bcc     LF517                           ; F513 90 02                    ..
        lda     #$00                            ; F515 A9 00                    ..
LF517:  rts                                     ; F517 60                       `

; ----------------------------------------------------------------------------
LF518:  stx     t1                              ; F518 8E 63 03                 .c.
        sty     t2                              ; F51B 8C 64 03                 .d.
        lda     rsstat                          ; F51E AD 7A 03                 .z.
        and     #$60                            ; F521 29 60                    )`
        bne     LF547                           ; F523 D0 22                    ."
        pla                                     ; F525 68                       h
        bit     sa                              ; F526 24 A0                    $.
        bpl     LF52D                           ; F528 10 03                    ..
        jsr     toascii                         ; F52A 20 CE F3                  ..
LF52D:  sta     acia_data                       ; F52D 8D 00 DD                 ...
        pha                                     ; F530 48                       H
LF531:  lda     rsstat                          ; F531 AD 7A 03                 .z.
        and     #$60                            ; F534 29 60                    )`
        bne     LF547                           ; F536 D0 0F                    ..
        lda     acia_status                     ; F538 AD 01 DD                 ...
        and     #$10                            ; F53B 29 10                    ).
        bne     LF547                           ; F53D D0 08                    ..
        jsr     kstop                           ; F53F 20 E1 FF                  ..
        bne     LF531                           ; F542 D0 ED                    ..
        sec                                     ; F544 38                       8
        bcs     LF512                           ; F545 B0 CB                    ..
LF547:  pla                                     ; F547 68                       h
        ldx     t1                              ; F548 AE 63 03                 .c.
        ldy     t2                              ; F54B AC 64 03                 .d.
        clc                                     ; F54E 18                       .
        rts                                     ; F54F 60                       `

; ----------------------------------------------------------------------------
; Open an input channel (la in X)
chkin:  jsr     lookup                          ; F550 20 45 F6                  E.
        beq     LF558                           ; F553 F0 03                    ..
        jmp     error3                          ; F555 4C 46 F9                 LF.

; ----------------------------------------------------------------------------
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
        and     acia_cmd                        ; F56F 2D 02 DD                 -..
        beq     LF583                           ; F572 F0 0F                    ..
        eor     #$FF                            ; F574 49 FF                    I.
        and     acia_cmd                        ; F576 2D 02 DD                 -..
        ora     #$01                            ; F579 09 01                    ..
        pha                                     ; F57B 48                       H
        jsr     rdst232                         ; F57C 20 35 F4                  5.
        pla                                     ; F57F 68                       h
        sta     acia_cmd                        ; F580 8D 02 DD                 ...
LF583:  lda     #$02                            ; F583 A9 02                    ..
        bne     LF58D                           ; F585 D0 06                    ..
LF587:  jsr     tape                            ; F587 20 68 FE                  h.
LF58A:  jmp     error6                          ; F58A 4C 4F F9                 LO.

; ----------------------------------------------------------------------------
LF58D:  sta     dfltn                           ; F58D 85 A1                    ..
        clc                                     ; F58F 18                       .
        rts                                     ; F590 60                       `

; ----------------------------------------------------------------------------
LF591:  tax                                     ; F591 AA                       .
        jsr     ktalk                           ; F592 20 B4 FF                  ..
        lda     sa                              ; F595 A5 A0                    ..
        bpl     LF59F                           ; F597 10 06                    ..
        jsr     tkatn                           ; F599 20 8A F2                  ..
        jmp     LF5A2                           ; F59C 4C A2 F5                 L..

; ----------------------------------------------------------------------------
LF59F:  jsr     ktksa                           ; F59F 20 96 FF                  ..
LF5A2:  txa                                     ; F5A2 8A                       .
        bit     status                          ; F5A3 24 9C                    $.
        bpl     LF58D                           ; F5A5 10 E6                    ..
        jmp     error5                          ; F5A7 4C 4C F9                 LL.

; ----------------------------------------------------------------------------
; Open an output channel (la in X)
ckout:  jsr     lookup                          ; F5AA 20 45 F6                  E.
        beq     LF5B2                           ; F5AD F0 03                    ..
        jmp     error3                          ; F5AF 4C 46 F9                 LF.

; ----------------------------------------------------------------------------
LF5B2:  jsr     fz100                           ; F5B2 20 57 F6                  W.
        lda     fa                              ; F5B5 A5 9F                    ..
        bne     LF5BC                           ; F5B7 D0 03                    ..
LF5B9:  jmp     error7                          ; F5B9 4C 52 F9                 LR.

; ----------------------------------------------------------------------------
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
LF5D5:  jsr     tape                            ; F5D5 20 68 FE                  h.
LF5D8:  sta     dflto                           ; F5D8 85 A2                    ..
        clc                                     ; F5DA 18                       .
        rts                                     ; F5DB 60                       `

; ----------------------------------------------------------------------------
LF5DC:  tax                                     ; F5DC AA                       .
        jsr     klisten                         ; F5DD 20 B1 FF                  ..
        lda     sa                              ; F5E0 A5 A0                    ..
        bpl     LF5E9                           ; F5E2 10 05                    ..
        jsr     secatn                          ; F5E4 20 7E F2                  ~.
        bne     LF5EC                           ; F5E7 D0 03                    ..
LF5E9:  jsr     ksecnd                          ; F5E9 20 93 FF                  ..
LF5EC:  txa                                     ; F5EC 8A                       .
        bit     status                          ; F5ED 24 9C                    $.
        bpl     LF5D8                           ; F5EF 10 E7                    ..
        jmp     error5                          ; F5F1 4C 4C F9                 LL.

; ----------------------------------------------------------------------------
; Close a logical file
close:  php                                     ; F5F4 08                       .
        jsr     LF64A                           ; F5F5 20 4A F6                  J.
        beq     LF5FD                           ; F5F8 F0 03                    ..
        plp                                     ; F5FA 28                       (
        clc                                     ; F5FB 18                       .
        rts                                     ; F5FC 60                       `

; ----------------------------------------------------------------------------
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
        sta     acia_cmd                        ; F615 8D 02 DD                 ...
        beq     LF624                           ; F618 F0 0A                    ..
LF61A:  pla                                     ; F61A 68                       h
        jsr     LF625                           ; F61B 20 25 F6                  %.
        jsr     tape                            ; F61E 20 68 FE                  h.
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

; ----------------------------------------------------------------------------
lookup: lda     #$00                            ; F645 A9 00                    ..
;        sta     status                          ; F647 85 9C                    ..
        adc     status          ; ********** FASTBOOT PATCH **********
        txa                                     ; F649 8A                       .
LF64A:  ldx     ldtnd                           ; F64A AE 60 03                 .`.
LF64D:  dex                                     ; F64D CA                       .
        bmi     LF67D                           ; F64E 30 2D                    0-
        cmp     lat,x                           ; F650 DD 34 03                 .4.
        bne     LF64D                           ; F653 D0 F8                    ..
        clc                                     ; F655 18                       .
        rts                                     ; F656 60                       `

; ----------------------------------------------------------------------------
fz100:  lda     lat,x                           ; F657 BD 34 03                 .4.
        sta     la                              ; F65A 85 9E                    ..
        lda     fat,x                           ; F65C BD 3E 03                 .>.
        sta     fa                              ; F65F 85 9F                    ..
        lda     sat,x                           ; F661 BD 48 03                 .H.
        sta     sa                              ; F664 85 A0                    ..
        rts                                     ; F666 60                       `

; ----------------------------------------------------------------------------
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

; ----------------------------------------------------------------------------
LF67D:  sec                                     ; F67D 38                       8
        rts                                     ; F67E 60                       `

; ----------------------------------------------------------------------------
lkupla: tax                                     ; F67F AA                       .
        jsr     lookup                          ; F680 20 45 F6                  E.
        bcc     LF674                           ; F683 90 EF                    ..
        rts                                     ; F685 60                       `

; ----------------------------------------------------------------------------
; Close all logical files
clrall: ror     xsav                            ; F686 6E 65 03                 ne.
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
        jsr     kclose                          ; F6A3 20 C3 FF                  ..
        bcc     LF68C                           ; F6A6 90 E4                    ..
LF6A8:  lda     #$00                            ; F6A8 A9 00                    ..
        sta     ldtnd                           ; F6AA 8D 60 03                 .`.
; Unlisten/untalk on IEC
clrch:  ldx     #$03                            ; F6AD A2 03                    ..
        cpx     dflto                           ; F6AF E4 A2                    ..
        bcs     LF6B6                           ; F6B1 B0 03                    ..
        jsr     kunlsn                          ; F6B3 20 AE FF                  ..
LF6B6:  cpx     dfltn                           ; F6B6 E4 A1                    ..
        bcs     LF6BD                           ; F6B8 B0 03                    ..
        jsr     kuntalk                         ; F6BA 20 AB FF                  ..
LF6BD:  ldx     #$03                            ; F6BD A2 03                    ..
        stx     dflto                           ; F6BF 86 A2                    ..
        lda     #$00                            ; F6C1 A9 00                    ..
        sta     dfltn                           ; F6C3 85 A1                    ..
        rts                                     ; F6C5 60                       `

; ----------------------------------------------------------------------------
; Open a logical file, output the filename
open:   bcc     LF6CB                           ; F6C6 90 03                    ..
        jmp     tranr                           ; F6C8 4C 41 F7                 LA.

; ----------------------------------------------------------------------------
LF6CB:  ldx     la                              ; F6CB A6 9E                    ..
        jsr     lookup                          ; F6CD 20 45 F6                  E.
        bne     LF6D5                           ; F6D0 D0 03                    ..
        jmp     error2                          ; F6D2 4C 43 F9                 LC.

; ----------------------------------------------------------------------------
LF6D5:  ldx     ldtnd                           ; F6D5 AE 60 03                 .`.
        cpx     #$0A                            ; F6D8 E0 0A                    ..
        bcc     LF6DF                           ; F6DA 90 03                    ..
        jmp     error1                          ; F6DC 4C 40 F9                 L@.

; ----------------------------------------------------------------------------
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
        jmp     open232                         ; F706 4C 88 F3                 L..

; ----------------------------------------------------------------------------
LF709:  jsr     tape                            ; F709 20 68 FE                  h.
LF70C:  clc                                     ; F70C 18                       .
        rts                                     ; F70D 60                       `

; ----------------------------------------------------------------------------
; Open on IEC
openi:  lda     sa                              ; F70E A5 A0                    ..
        bmi     LF73F                           ; F710 30 2D                    0-
        ldy     fnlen                           ; F712 A4 9D                    ..
        beq     LF73F                           ; F714 F0 29                    .)
        lda     fa                              ; F716 A5 9F                    ..
        jsr     klisten                         ; F718 20 B1 FF                  ..
        lda     sa                              ; F71B A5 A0                    ..
        ora     #$F0                            ; F71D 09 F0                    ..
; Output sa and filename on IEC
openib: jsr     ksecnd                          ; F71F 20 93 FF                  ..
        lda     status                          ; F722 A5 9C                    ..
        bpl     LF72B                           ; F724 10 05                    ..
        pla                                     ; F726 68                       h
        pla                                     ; F727 68                       h
        jmp     error5                          ; F728 4C 4C F9                 LL.

; ----------------------------------------------------------------------------
LF72B:  lda     fnlen                           ; F72B A5 9D                    ..
        beq     LF73C                           ; F72D F0 0D                    ..
; Output filename on IEC
openfn: ldy     #$00                            ; F72F A0 00                    ..
LF731:  jsr     fnadry                          ; F731 20 A0 FE                  ..
        jsr     kciout                          ; F734 20 A8 FF                  ..
        iny                                     ; F737 C8                       .
        cpy     fnlen                           ; F738 C4 9D                    ..
        bne     LF731                           ; F73A D0 F5                    ..
LF73C:  jsr     kunlsn                          ; F73C 20 AE FF                  ..
LF73F:  clc                                     ; F73F 18                       .
        rts                                     ; F740 60                       `

; ----------------------------------------------------------------------------
; Output sa 15 + name on IEC
tranr:  lda     fa                              ; F741 A5 9F                    ..
        jsr     klisten                         ; F743 20 B1 FF                  ..
        lda     #$6F                            ; F746 A9 6F                    .o
        sta     sa                              ; F748 85 A0                    ..
        jmp     openib                          ; F74A 4C 1F F7                 L..

; ----------------------------------------------------------------------------
; Load from logical file
load:   stx     relsal                          ; F74D 8E 6F 03                 .o.
        sty     relsah                          ; F750 8C 70 03                 .p.
        sta     verck                           ; F753 8D 5F 03                 ._.
        sta     relsas                          ; F756 8D 71 03                 .q.
        lda     #$00                            ; F759 A9 00                    ..
        sta     status                          ; F75B 85 9C                    ..
        lda     fa                              ; F75D A5 9F                    ..
        bne     load2                           ; F75F D0 03                    ..
load1:  jmp     error9                          ; F761 4C 58 F9                 LX.

; ----------------------------------------------------------------------------
; Dispatch based on load device
load2:  cmp     #$03                            ; F764 C9 03                    ..
        beq     load1                           ; F766 F0 F9                    ..
        bcs     load3                           ; F768 B0 03                    ..
        jmp     load11                          ; F76A 4C 17 F8                 L..

; ----------------------------------------------------------------------------
; Load from IEC
load3:  lda     #$60                            ; F76D A9 60                    .`
        sta     sa                              ; F76F 85 A0                    ..
        ldy     fnlen                           ; F771 A4 9D                    ..
        bne     load4                           ; F773 D0 03                    ..
        jmp     error8                          ; F775 4C 55 F9                 LU.

; ----------------------------------------------------------------------------
load4:  jsr     srching                         ; F778 20 22 F8                  ".
        jsr     openi                           ; F77B 20 0E F7                  ..
        lda     fa                              ; F77E A5 9F                    ..
        jsr     ktalk                           ; F780 20 B4 FF                  ..
        lda     sa                              ; F783 A5 A0                    ..
        jsr     ktksa                           ; F785 20 96 FF                  ..
        jsr     kacptr                          ; F788 20 A5 FF                  ..
        sta     eal                             ; F78B 85 96                    ..
        sta     stal                            ; F78D 85 99                    ..
        lda     status                          ; F78F A5 9C                    ..
        lsr                                     ; F791 4A                       J
        lsr                                     ; F792 4A                       J
        bcc     load5                           ; F793 90 03                    ..
        jmp     error4                          ; F795 4C 49 F9                 LI.

; ----------------------------------------------------------------------------
load5:  jsr     kacptr                          ; F798 20 A5 FF                  ..
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
; Wait if IEC timeout
load6:  lda     #$FD                            ; F7C1 A9 FD                    ..
        and     status                          ; F7C3 25 9C                    %.
        sta     status                          ; F7C5 85 9C                    ..
        jsr     kstop                           ; F7C7 20 E1 FF                  ..
        bne     load7                           ; F7CA D0 03                    ..
        jmp     break                           ; F7CC 4C BA F8                 L..

; ----------------------------------------------------------------------------
load7:  jsr     kacptr                          ; F7CF 20 A5 FF                  ..
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
!byte   $AD                             ; F7F4 AD                       .
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
        jsr     kuntalk                         ; F80B 20 AB FF                  ..
        jsr     clsei                           ; F80E 20 C6 F8                  ..
        jmp     load12                          ; F811 4C 1A F8                 L..

; ----------------------------------------------------------------------------
        jmp     error4                          ; F814 4C 49 F9                 LI.

; ----------------------------------------------------------------------------
; Load from cassette
load11: jsr     tape                            ; F817 20 68 FE                  h.
load12: clc                                     ; F81A 18                       .
        lda     eas                             ; F81B A5 98                    ..
        ldx     eal                             ; F81D A6 96                    ..
        ldy     eah                             ; F81F A4 97                    ..
        rts                                     ; F821 60                       `

; ----------------------------------------------------------------------------
; In direct mode, print "searching ..."
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

; ----------------------------------------------------------------------------
; In direct mode, print "loading ..."
loading:ldy     #$1B                            ; F847 A0 1B                    ..
        lda     verck                           ; F849 AD 5F 03                 ._.
        bpl     LF850                           ; F84C 10 02                    ..
        ldy     #$2B                            ; F84E A0 2B                    .+
LF850:  jmp     spmsg                           ; F850 4C 23 F2                 L#.

; ----------------------------------------------------------------------------
; Save to logical file
save:   lda     e6509,x                         ; F853 B5 00                    ..
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

; ----------------------------------------------------------------------------
save2:  cmp     #$03                            ; F874 C9 03                    ..
        beq     save1                           ; F876 F0 F9                    ..
        bcc     save8                           ; F878 90 63                    .c
        lda     #$61                            ; F87A A9 61                    .a
        sta     sa                              ; F87C 85 A0                    ..
        ldy     fnlen                           ; F87E A4 9D                    ..
        bne     save3                           ; F880 D0 03                    ..
        jmp     error8                          ; F882 4C 55 F9                 LU.

; ----------------------------------------------------------------------------
; Open file on IEC for writing
save3:  jsr     openi                           ; F885 20 0E F7                  ..
        jsr     saving                          ; F888 20 E0 F8                  ..
        lda     fa                              ; F88B A5 9F                    ..
        jsr     klisten                         ; F88D 20 B1 FF                  ..
        lda     sa                              ; F890 A5 A0                    ..
        jsr     ksecnd                          ; F892 20 93 FF                  ..
        ldx     i6509                           ; F895 A6 01                    ..
        jsr     LFE70                           ; F897 20 70 FE                  p.
        lda     sal                             ; F89A A5 93                    ..
        jsr     kciout                          ; F89C 20 A8 FF                  ..
        lda     sah                             ; F89F A5 94                    ..
        jsr     kciout                          ; F8A1 20 A8 FF                  ..
        ldy     #$00                            ; F8A4 A0 00                    ..
save4:  jsr     cmpste                          ; F8A6 20 7F FE                  ..
        bcs     save5                           ; F8A9 B0 16                    ..
        lda     (sal),y                         ; F8AB B1 93                    ..
        jsr     kciout                          ; F8AD 20 A8 FF                  ..
        jsr     incsal                          ; F8B0 20 8D FE                  ..
        jsr     kstop                           ; F8B3 20 E1 FF                  ..
        bne     save4                           ; F8B6 D0 EE                    ..
        stx     i6509                           ; F8B8 86 01                    ..
break:  jsr     clsei                           ; F8BA 20 C6 F8                  ..
        lda     #$00                            ; F8BD A9 00                    ..
        sec                                     ; F8BF 38                       8
        rts                                     ; F8C0 60                       `

; ----------------------------------------------------------------------------
save5:  stx     i6509                           ; F8C1 86 01                    ..
        jsr     kunlsn                          ; F8C3 20 AE FF                  ..
; Close IEC program file
clsei:  bit     sa                              ; F8C6 24 A0                    $.
        bmi     save6                           ; F8C8 30 11                    0.
        lda     fa                              ; F8CA A5 9F                    ..
        jsr     klisten                         ; F8CC 20 B1 FF                  ..
        lda     sa                              ; F8CF A5 A0                    ..
        and     #$EF                            ; F8D1 29 EF                    ).
        ora     #$E0                            ; F8D3 09 E0                    ..
        jsr     ksecnd                          ; F8D5 20 93 FF                  ..
        jsr     kunlsn                          ; F8D8 20 AE FF                  ..
save6:  clc                                     ; F8DB 18                       .
save7:  rts                                     ; F8DC 60                       `

; ----------------------------------------------------------------------------
; Open device number < 3 for writing
save8:  jsr     tape                            ; F8DD 20 68 FE                  h.
; In direct mode, print "saving ..."
saving: lda     msgflg                          ; F8E0 AD 61 03                 .a.
        bpl     save7                           ; F8E3 10 F7                    ..
        ldy     #$23                            ; F8E5 A0 23                    .#
        jsr     spmsg                           ; F8E7 20 23 F2                  #.
        jmp     outfn                           ; F8EA 4C 35 F8                 L5.

; ----------------------------------------------------------------------------
; Read the time from the TOD clock
rdtim:  lda     cia2_tod10                      ; F8ED AD 08 DC                 ...
        pha                                     ; F8F0 48                       H
        pha                                     ; F8F1 48                       H
        asl                                     ; F8F2 0A                       .
        asl                                     ; F8F3 0A                       .
        asl                                     ; F8F4 0A                       .
        and     #$60                            ; F8F5 29 60                    )`
        ora     cia2_todhr                      ; F8F7 0D 0B DC                 ...
        tay                                     ; F8FA A8                       .
        pla                                     ; F8FB 68                       h
        ror                                     ; F8FC 6A                       j
        ror                                     ; F8FD 6A                       j
        and     #$80                            ; F8FE 29 80                    ).
        ora     cia2_todsec                     ; F900 0D 09 DC                 ...
        sta     sal                             ; F903 85 93                    ..
        ror                                     ; F905 6A                       j
        and     #$80                            ; F906 29 80                    ).
        ora     cia2_todmin                     ; F908 0D 0A DC                 ...
        tax                                     ; F90B AA                       .
        pla                                     ; F90C 68                       h
        cmp     cia2_tod10                      ; F90D CD 08 DC                 ...
        bne     rdtim                           ; F910 D0 DB                    ..
        lda     sal                             ; F912 A5 93                    ..
        rts                                     ; F914 60                       `

; ----------------------------------------------------------------------------
; Set the time
settim: pha                                     ; F915 48                       H
        pha                                     ; F916 48                       H
        ror                                     ; F917 6A                       j
        and     #$80                            ; F918 29 80                    ).
        ora     cia2_crb                        ; F91A 0D 0F DC                 ...
        sta     cia2_crb                        ; F91D 8D 0F DC                 ...
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
        sty     cia2_todhr                      ; F930 8C 0B DC                 ...
        stx     cia2_todmin                     ; F933 8E 0A DC                 ...
        pla                                     ; F936 68                       h
        sta     cia2_todsec                     ; F937 8D 09 DC                 ...
        lda     sal                             ; F93A A5 93                    ..
        sta     cia2_tod10                      ; F93C 8D 08 DC                 ...
        rts                                     ; F93F 60                       `

; ----------------------------------------------------------------------------
; Output "i/o error: 1" (too many files)
error1: lda     #$01                            ; F940 A9 01                    ..
!byte   $2C                             ; F942 2C                       ,
; Output "i/o error: 2" (file open)
error2: lda     #$02                            ; F943 A9 02                    ..
!byte   $2C                             ; F945 2C                       ,
; Output "i/o error: 3" (file not open)
error3: lda     #$03                            ; F946 A9 03                    ..
!byte   $2C                             ; F948 2C                       ,
; Output "i/o error: 4" (file not found)
error4: lda     #$04                            ; F949 A9 04                    ..
!byte   $2C                             ; F94B 2C                       ,
; Output "i/o error: 5" (device not present)
error5: lda     #$05                            ; F94C A9 05                    ..
!byte   $2C                             ; F94E 2C                       ,
; Output "i/o error: 6" (not input file)
error6: lda     #$06                            ; F94F A9 06                    ..
!byte   $2C                             ; F951 2C                       ,
; Output "i/o error: 7" (not output file)
error7: lda     #$07                            ; F952 A9 07                    ..
!byte   $2C                             ; F954 2C                       ,
; Output "i/o error: 8" (missing file name)
error8: lda     #$08                            ; F955 A9 08                    ..
!byte   $2C                             ; F957 2C                       ,
; Output "i/o error: 9" (illegal device number)
error9: lda     #$09                            ; F958 A9 09                    ..
; Error output routine
errorx: pha                                     ; F95A 48                       H
        jsr     kclrch                          ; F95B 20 CC FF                  ..
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

; ----------------------------------------------------------------------------
; Check the stop key
stop:   lda     stkey                           ; F972 A5 A9                    ..
        and     #$01                            ; F974 29 01                    ).
        bne     LF97F                           ; F976 D0 07                    ..
        php                                     ; F978 08                       .
        jsr     kclrch                          ; F979 20 CC FF                  ..
        sta     ndx                             ; F97C 85 D1                    ..
        plp                                     ; F97E 28                       (
LF97F:  rts                                     ; F97F 60                       `

; ----------------------------------------------------------------------------
udtim:  lda     tpi2_pc                         ; F980 AD 02 DF                 ...
        lsr                                     ; F983 4A                       J
        bcs     LF998                           ; F984 B0 12                    ..
        lda     #$FE                            ; F986 A9 FE                    ..
        sta     tpi2_pb                         ; F988 8D 01 DF                 ...
        lda     #$10                            ; F98B A9 10                    ..
        and     tpi2_pc                         ; F98D 2D 02 DF                 -..
        bne     LF993                           ; F990 D0 01                    ..
        sec                                     ; F992 38                       8
LF993:  lda     #$FF                            ; F993 A9 FF                    ..
        sta     tpi2_pb                         ; F995 8D 01 DF                 ...
LF998:  rol                                     ; F998 2A                       *
        sta     stkey                           ; F999 85 A9                    ..
        rts                                     ; F99B 60                       `

; ----------------------------------------------------------------------------
; Test bytes for ROMs
patall:
!byte   $C2,$CD                         ; F99C C2 CD                    ..
; ----------------------------------------------------------------------------
; System reset routine
cold:   ldx     #$FE                            ; F99E A2 FE                    ..
        sei                                     ; F9A0 78                       x
        txs                                     ; F9A1 9A                       .
        cld                                     ; F9A2 D8                       .
        lda     #$FF                            ; F9A3 A9 FF                    ..
        eor     evect+2                         ; F9A5 4D FA 03                 M..
        eor     evect+3                         ; F9A8 4D FB 03                 M..
        beq     warm                            ; F9AB F0 4E                    .N
        lda     #$06                            ; F9AD A9 06                    ..
        sta     eal                             ; F9AF 85 96                    ..
        lda     #$00                            ; F9B1 A9 00                    ..
        sta     eah                             ; F9B3 85 97                    ..
        sta     evect                           ; F9B5 8D F8 03                 ...
        ldx     #$30                            ; F9B8 A2 30                    .0
LF9BA:  ldy     #$03                            ; F9BA A0 03                    ..
        lda     eah                             ; F9BC A5 97                    ..
        bmi     LF9D8                           ; F9BE 30 18                    0.
        clc                                     ; F9C0 18                       .
        adc     #$10                            ; F9C1 69 10                    i.
        sta     eah                             ; F9C3 85 97                    ..
        inx                                     ; F9C5 E8                       .
        txa                                     ; F9C6 8A                       .
        cmp     (eal),y                         ; F9C7 D1 96                    ..
        bne     LF9BA                           ; F9C9 D0 EF                    ..
        dey                                     ; F9CB 88                       .
LF9CC:  lda     (eal),y                         ; F9CC B1 96                    ..
        dey                                     ; F9CE 88                       .
        bmi     LF9DB                           ; F9CF 30 0A                    0.
        cmp     patall,y                        ; F9D1 D9 9C F9                 ...
        beq     LF9CC                           ; F9D4 F0 F6                    ..
        bne     LF9BA                           ; F9D6 D0 E2                    ..
LF9D8:  ldy     #$E0                            ; F9D8 A0 E0                    ..
!byte   $2C                             ; F9DA 2C                       ,
LF9DB:  ldy     eah                             ; F9DB A4 97                    ..
        sty     evect+1                         ; F9DD 8C F9 03                 ...
        tax                                     ; F9E0 AA                       .
        bpl     warm                            ; F9E1 10 18                    ..
        jsr     ioinit                          ; F9E3 20 FE F9                  ..
        lda     #$F0                            ; F9E6 A9 F0                    ..
        sta     pkybuf+1                        ; F9E8 85 C1                    ..
        jsr     jcint                           ; F9EA 20 04 E0                  ..
        jsr     ramtas                          ; F9ED 20 94 FA                  ..
        jsr     restor                          ; F9F0 20 B1 FB                  ..
        jsr     jcint                           ; F9F3 20 04 E0                  ..
        lda     #$A5                            ; F9F6 A9 A5                    ..
        sta     evect+2                         ; F9F8 8D FA 03                 ...
; Warm start entry
warm:   jmp     (evect)                         ; F9FB 6C F8 03                 l..

; ----------------------------------------------------------------------------
; I/O register init
ioinit: lda     #$F3                            ; F9FE A9 F3                    ..
        sta     tpi1_ctrl                       ; FA00 8D 06 DE                 ...
        lda     #$FF                            ; FA03 A9 FF                    ..
        sta     tpi1_ddrc                       ; FA05 8D 05 DE                 ...
        lda     #$5C                            ; FA08 A9 5C                    .\
        sta     tpi1_pb                         ; FA0A 8D 01 DE                 ...
        lda     #$7D                            ; FA0D A9 7D                    .}
        sta     tpi1_ddrb                       ; FA0F 8D 04 DE                 ...
        lda     #$3D                            ; FA12 A9 3D                    .=
        sta     tpi1_pa                         ; FA14 8D 00 DE                 ...
        lda     #$3F                            ; FA17 A9 3F                    .?
        sta     tpi1_ddra                       ; FA19 8D 03 DE                 ...
        lda     #$FF                            ; FA1C A9 FF                    ..
        sta     tpi2_pa                         ; FA1E 8D 00 DF                 ...
        sta     tpi1_pb                         ; FA21 8D 01 DE                 ...
        sta     tpi2_ddra                       ; FA24 8D 03 DF                 ...
        sta     tpi2_ddrb                       ; FA27 8D 04 DF                 ...
        lsr     tpi2_pa                         ; FA2A 4E 00 DF                 N..
        lda     #$C0                            ; FA2D A9 C0                    ..
        sta     tpi2_pc                         ; FA2F 8D 02 DF                 ...
        sta     tpi2_ddrc                       ; FA32 8D 05 DF                 ...
        lda     #$84                            ; FA35 A9 84                    ..
        sta     cia2_icr                        ; FA37 8D 0D DC                 ...
        ldy     #$00                            ; FA3A A0 00                    ..
        sty     cia2_ddra                       ; FA3C 8C 02 DC                 ...
        sty     cia2_ddrb                       ; FA3F 8C 03 DC                 ...
        sty     cia2_crb                        ; FA42 8C 0F DC                 ...
        sta     cia2_tod10                      ; FA45 8D 08 DC                 ...
        sty     tpi1_pc                         ; FA48 8C 02 DE                 ...
LFA4B:  lda     tpi1_pc                         ; FA4B AD 02 DE                 ...
        ror                                     ; FA4E 6A                       j
        bcc     LFA4B                           ; FA4F 90 FA                    ..
        sty     tpi1_pc                         ; FA51 8C 02 DE                 ...
        ldx     #$00                            ; FA54 A2 00                    ..
        ldy     #$00                            ; FA56 A0 00                    ..
LFA58:  inx                                     ; FA58 E8                       .
        bne     LFA58                           ; FA59 D0 FD                    ..
        iny                                     ; FA5B C8                       .
        lda     tpi1_pc                         ; FA5C AD 02 DE                 ...
        ror                                     ; FA5F 6A                       j
        bcc     LFA58                           ; FA60 90 F6                    ..
        cpy     #$0E                            ; FA62 C0 0E                    ..
        bcc     LFA69                           ; FA64 90 03                    ..
        lda     #$88                            ; FA66 A9 88                    ..
!byte   $2C                             ; FA68 2C                       ,
LFA69:  lda     #$08                            ; FA69 A9 08                    ..
        sta     cia2_cra                        ; FA6B 8D 0E DC                 ...
        lda     cia1_icr                        ; FA6E AD 0D DB                 ...
        lda     #$90                            ; FA71 A9 90                    ..
        sta     cia1_icr                        ; FA73 8D 0D DB                 ...
        lda     #$40                            ; FA76 A9 40                    .@
        sta     cia1_prb                        ; FA78 8D 01 DB                 ...
        lda     #$00                            ; FA7B A9 00                    ..
        sta     cia1_ddra                       ; FA7D 8D 02 DB                 ...
        sta     cia1_crb                        ; FA80 8D 0F DB                 ...
        sta     cia1_cra                        ; FA83 8D 0E DB                 ...
        lda     #$48                            ; FA86 A9 48                    .H
        sta     cia1_ddrb                       ; FA88 8D 03 DB                 ...
        lda     #$01                            ; FA8B A9 01                    ..
        ora     tpi1_pb                         ; FA8D 0D 01 DE                 ...
        sta     tpi1_pb                         ; FA90 8D 01 DE                 ...
        rts                                     ; FA93 60                       `

; ----------------------------------------------------------------------------
; RAM test
ramtas: lda     #$00                            ; FA94 A9 00                    ..
        tax                                     ; FA96 AA                       .
LFA97:  sta     $0002,x                         ; FA97 9D 02 00                 ...
        sta     $0200,x                         ; FA9A 9D 00 02                 ...
        sta     $02F8,x                         ; FA9D 9D F8 02                 ...
        inx                                     ; FAA0 E8                       .
        bne     LFA97                           ; FAA1 D0 F4                    ..
        lda     #$00                            ; FAA3 A9 00                    ..
        sta     i6509                           ; FAA5 85 01                    ..
        sta     memstr+2                        ; FAA7 8D 5A 03                 .Z.
        sta     lowadr+2                        ; FAAA 8D 54 03                 .T.
        lda     #$02                            ; FAAD A9 02                    ..
        sta     memstr                          ; FAAF 8D 58 03                 .X.
        sta     lowadr                          ; FAB2 8D 52 03                 .R.
        dec     i6509                           ; FAB5 C6 01                    ..
LFAB7:  inc     i6509                           ; FAB7 E6 01                    ..
        lda     i6509                           ; FAB9 A5 01                    ..
        cmp     #$0F                            ; FABB C9 0F                    ..
        beq     size                            ; FABD F0 24                    .$
        ldy     #$02                            ; FABF A0 02                    ..
LFAC1:  lda     (sal),y                         ; FAC1 B1 93                    ..
        tax                                     ; FAC3 AA                       .
        lda     #$55                            ; FAC4 A9 55                    .U
        sta     (sal),y                         ; FAC6 91 93                    ..
        lda     (sal),y                         ; FAC8 B1 93                    ..
        cmp     #$55                            ; FACA C9 55                    .U
        bne     size                            ; FACC D0 15                    ..
        asl                                     ; FACE 0A                       .
        sta     (sal),y                         ; FACF 91 93                    ..
        lda     (sal),y                         ; FAD1 B1 93                    ..
        cmp     #$AA                            ; FAD3 C9 AA                    ..
        bne     size                            ; FAD5 D0 0C                    ..
        txa                                     ; FAD7 8A                       .
        sta     (sal),y                         ; FAD8 91 93                    ..
;        iny                                     ; FADA C8                       .
;        bne     LFAC1                           ; FADB D0 E4                    ..
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        nop                     ; ********** FASTBOOT PATCH **********
        inc     sah                             ; FADD E6 94                    ..
        bne     LFAC1                           ; FADF D0 E0                    ..
        beq     LFAB7                           ; FAE1 F0 D4                    ..
; Remember the available memory
size:   ldx     i6509                           ; FAE3 A6 01                    ..
        dex                                     ; FAE5 CA                       .
        txa                                     ; FAE6 8A                       .
        ldx     #$FF                            ; FAE7 A2 FF                    ..
        ldy     #$FE                            ; FAE9 A0 FE                    ..
        sta     hiadr+2                         ; FAEB 8D 57 03                 .W.
        sty     hiadr+1                         ; FAEE 8C 56 03                 .V.
        stx     hiadr                           ; FAF1 8E 55 03                 .U.
        ldy     #$FB                            ; FAF4 A0 FB                    ..
        clc                                     ; FAF6 18                       .
        jsr     memtop                          ; FAF7 20 87 FB                  ..
        dec     ribuf+2                         ; FAFA C6 A8                    ..
        dec     tape1+2                         ; FAFC C6 A5                    ..
        lda     #$6B                            ; FAFE A9 6B                    .k
        sta     itape                           ; FB00 8D 6A 03                 .j.
        lda     #$FE                            ; FB03 A9 FE                    ..
        sta     itape+1                         ; FB05 8D 6B 03                 .k.
        rts                                     ; FB08 60                       `

; ----------------------------------------------------------------------------
; Table with standard vectors
jmptab: !word   kirq                            ; FB09 F8 FB                    ..
        !word   timb                            ; FB0B 21 EE                    !.
        !word   panic                           ; FB0D B8 FC                    ..
        !word   open                            ; FB0F C6 F6                    ..
        !word   close                           ; FB11 F4 F5                    ..
        !word   chkin                           ; FB13 50 F5                    P.
        !word   ckout                           ; FB15 AA F5                    ..
        !word   clrch                           ; FB17 AD F6                    ..
        !word   basin                           ; FB19 A3 F4                    ..
        !word   bsout                           ; FB1B F5 F4                    ..
        !word   stop                            ; FB1D 72 F9                    r.
        !word   getin                           ; FB1F 44 F4                    D.
        !word   clrall                          ; FB21 86 F6                    ..
        !word   load                            ; FB23 4D F7                    M.
        !word   save                            ; FB25 53 F8                    S.
        !word   mcmd                            ; FB27 73 EE                    s.
        !word   jescape                         ; FB29 1F E0                    ..
        !word   jescape                         ; FB2B 1F E0                    ..
        !word   secnd                           ; FB2D 7B F2                    {.
        !word   tksa                            ; FB2F 87 F2                    ..
        !word   acptr                           ; FB31 11 F3                    ..
        !word   ciout                           ; FB33 9E F2                    ..
        !word   untalk                          ; FB35 B2 F2                    ..
        !word   unlsn                           ; FB37 B6 F2                    ..
        !word   listn                           ; FB39 3B F2                    ;.
        !word   talk                            ; FB3B 37 F2                    7.
; ----------------------------------------------------------------------------
; NMI entry, jumps indirect to NMI routine
nmi:    jmp     (nminv)                         ; FB3D 6C 04 03                 l..

; ----------------------------------------------------------------------------
; Set the file name address
setnam: sta     fnlen                           ; FB40 85 9D                    ..
        lda     e6509,x                         ; FB42 B5 00                    ..
        sta     fnadr                           ; FB44 85 90                    ..
        lda     i6509,x                         ; FB46 B5 01                    ..
        sta     fnadr+1                         ; FB48 85 91                    ..
        lda     $02,x                           ; FB4A B5 02                    ..
        sta     fnadr+2                         ; FB4C 85 92                    ..
        rts                                     ; FB4E 60                       `

; ----------------------------------------------------------------------------
; Set logical file number
setlfs: sta     la                              ; FB4F 85 9E                    ..
        stx     fa                              ; FB51 86 9F                    ..
        sty     sa                              ; FB53 84 A0                    ..
        rts                                     ; FB55 60                       `

; ----------------------------------------------------------------------------
; Read/write the system status byte
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

; ----------------------------------------------------------------------------
; Set the system message flag
setmsg: sta     msgflg                          ; FB69 8D 61 03                 .a.
readss: lda     status                          ; FB6C A5 9C                    ..
; ORA A in status
udst:   ora     status                          ; FB6E 05 9C                    ..
        sta     status                          ; FB70 85 9C                    ..
        rts                                     ; FB72 60                       `

; ----------------------------------------------------------------------------
; Write the status byte
storst: pha                                     ; FB73 48                       H
        lda     fa                              ; FB74 A5 9F                    ..
        cmp     #$02                            ; FB76 C9 02                    ..
        bne     storss                          ; FB78 D0 05                    ..
        pla                                     ; FB7A 68                       h
        sta     rsstat                          ; FB7B 8D 7A 03                 .z.
        rts                                     ; FB7E 60                       `

; ----------------------------------------------------------------------------
storss: pla                                     ; FB7F 68                       h
        sta     status                          ; FB80 85 9C                    ..
        rts                                     ; FB82 60                       `

; ----------------------------------------------------------------------------
; IEC timeout on/off
settmo: sta     timout                          ; FB83 8D 5E 03                 .^.
        rts                                     ; FB86 60                       `

; ----------------------------------------------------------------------------
; Get/set top of available memory
memtop: bcc     settop                          ; FB87 90 09                    ..
        lda     memsiz+2                        ; FB89 AD 5D 03                 .].
        ldx     memsiz                          ; FB8C AE 5B 03                 .[.
        ldy     memsiz+1                        ; FB8F AC 5C 03                 .\.
settop: stx     memsiz                          ; FB92 8E 5B 03                 .[.
        sty     memsiz+1                        ; FB95 8C 5C 03                 .\.
        sta     memsiz+2                        ; FB98 8D 5D 03                 .].
        rts                                     ; FB9B 60                       `

; ----------------------------------------------------------------------------
; Get/set bottom of available memory
membot: bcc     setbot                          ; FB9C 90 09                    ..
        lda     memstr+2                        ; FB9E AD 5A 03                 .Z.
        ldx     memstr                          ; FBA1 AE 58 03                 .X.
        ldy     memstr+1                        ; FBA4 AC 59 03                 .Y.
setbot: stx     memstr                          ; FBA7 8E 58 03                 .X.
        sty     memstr+1                        ; FBAA 8C 59 03                 .Y.
        sta     memstr+2                        ; FBAD 8D 5A 03                 .Z.
        rts                                     ; FBB0 60                       `

; ----------------------------------------------------------------------------
; Restore the system vector table
restor: ldx     #$09                            ; FBB1 A2 09                    ..
        ldy     #$FB                            ; FBB3 A0 FB                    ..
        lda     #$0F                            ; FBB5 A9 0F                    ..
        clc                                     ; FBB7 18                       .
; Get/set the system vector table
vector: stx     sal                             ; FBB8 86 93                    ..
        sty     sah                             ; FBBA 84 94                    ..
        ldx     i6509                           ; FBBC A6 01                    ..
        sta     i6509                           ; FBBE 85 01                    ..
        bcc     LFBCC                           ; FBC0 90 0A                    ..
        ldy     #$33                            ; FBC2 A0 33                    .3
LFBC4:  lda     cinv,y                          ; FBC4 B9 00 03                 ...
        sta     (sal),y                         ; FBC7 91 93                    ..
        dey                                     ; FBC9 88                       .
        bpl     LFBC4                           ; FBCA 10 F8                    ..
LFBCC:  ldy     #$33                            ; FBCC A0 33                    .3
LFBCE:  lda     (sal),y                         ; FBCE B1 93                    ..
        sta     cinv,y                          ; FBD0 99 00 03                 ...
        dey                                     ; FBD3 88                       .
        bpl     LFBCE                           ; FBD4 10 F8                    ..
        stx     i6509                           ; FBD6 86 01                    ..
        rts                                     ; FBD8 60                       `

; ----------------------------------------------------------------------------
vreset: stx     evect                           ; FBD9 8E F8 03                 ...
        sty     evect+1                         ; FBDC 8C F9 03                 ...
        lda     #$5A                            ; FBDF A9 5A                    .Z
        sta     evect+3                         ; FBE1 8D FB 03                 ...
        rts                                     ; FBE4 60                       `

; ----------------------------------------------------------------------------
; IRQ routine
irq:    pha                                     ; FBE5 48                       H
        txa                                     ; FBE6 8A                       .
        pha                                     ; FBE7 48                       H
        tya                                     ; FBE8 98                       .
        pha                                     ; FBE9 48                       H
        tsx                                     ; FBEA BA                       .
        lda     stack+4,x                       ; FBEB BD 04 01                 ...
        and     #$10                            ; FBEE 29 10                    ).
        bne     brkirq                          ; FBF0 D0 03                    ..
        jmp     (cinv)                          ; FBF2 6C 00 03                 l..

; ----------------------------------------------------------------------------
brkirq: jmp     (cbinv)                         ; FBF5 6C 02 03                 l..

; ----------------------------------------------------------------------------
; Standard IRQ routine via indirect vector cinv
kirq:   lda     i6509                           ; FBF8 A5 01                    ..
        pha                                     ; FBFA 48                       H
        cld                                     ; FBFB D8                       .
        lda     tpi1_air                        ; FBFC AD 07 DE                 ...
        bne     kirq1                           ; FBFF D0 03                    ..
        jmp     prendn                          ; FC01 4C B0 FC                 L..

; ----------------------------------------------------------------------------
; Check for ACIA IRQ
kirq1:  cmp     #$10                            ; FC04 C9 10                    ..
        beq     kirq2                           ; FC06 F0 03                    ..
        jmp     kirq8                           ; FC08 4C 69 FC                 Li.

; ----------------------------------------------------------------------------
; Handle ACIA IRQ
kirq2:  lda     acia_status                     ; FC0B AD 01 DD                 ...
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

; ----------------------------------------------------------------------------
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
        lda     acia_data                       ; FC3E AD 00 DD                 ...
        sta     (ribuf),y                       ; FC41 91 A6                    ..
        lda     acia_status                     ; FC43 AD 01 DD                 ...
        and     #$07                            ; FC46 29 07                    ).
LFC48:  ora     rsstat                          ; FC48 0D 7A 03                 .z.
        sta     rsstat                          ; FC4B 8D 7A 03                 .z.
LFC4E:  lda     acia_status                     ; FC4E AD 01 DD                 ...
        and     #$10                            ; FC51 29 10                    ).
        beq     LFC66                           ; FC53 F0 11                    ..
        lda     acia_cmd                        ; FC55 AD 02 DD                 ...
        and     #$0C                            ; FC58 29 0C                    ).
        cmp     #$04                            ; FC5A C9 04                    ..
        bne     LFC66                           ; FC5C D0 08                    ..
        lda     #$F3                            ; FC5E A9 F3                    ..
        and     acia_cmd                        ; FC60 2D 02 DD                 -..
        sta     acia_cmd                        ; FC63 8D 02 DD                 ...
LFC66:  jmp     LFCAD                           ; FC66 4C AD FC                 L..

; ----------------------------------------------------------------------------
; Check for coprozessor IRQ
kirq8:  cmp     #$08                            ; FC69 C9 08                    ..
        bne     kirq9                           ; FC6B D0 0A                    ..
        lda     cia1_icr                        ; FC6D AD 0D DB                 ...
        cli                                     ; FC70 58                       X
        jsr     ipserv                          ; FC71 20 56 FD                  V.
        jmp     LFCAD                           ; FC74 4C AD FC                 L..

; ----------------------------------------------------------------------------
; Check for CIA IRQ
kirq9:  cli                                     ; FC77 58                       X
        cmp     #$04                            ; FC78 C9 04                    ..
        bne     kirq10                          ; FC7A D0 0C                    ..
        lda     cia2_icr                        ; FC7C AD 0D DC                 ...
        ora     alarm                           ; FC7F 0D 69 03                 .i.
        sta     alarm                           ; FC82 8D 69 03                 .i.
        jmp     LFCAD                           ; FC85 4C AD FC                 L..

; ----------------------------------------------------------------------------
; Check for IEC bus IRQ (and ignore it)
kirq10: cmp     #$02                            ; FC88 C9 02                    ..
        bne     kirq11                          ; FC8A D0 03                    ..
        jmp     LFCAD                           ; FC8C 4C AD FC                 L..

; ----------------------------------------------------------------------------
; Must be a 50/60Hz IRQ - poll keyboard, update time
kirq11: jsr     jscnkey                         ; FC8F 20 13 E0                  ..
        jsr     udtim                           ; FC92 20 80 F9                  ..
        lda     tpi1_pb                         ; FC95 AD 01 DE                 ...
        bpl     LFCA3                           ; FC98 10 09                    ..
        ldy     #$00                            ; FC9A A0 00                    ..
        sty     cas1                            ; FC9C 8C 75 03                 .u.
        ora     #$40                            ; FC9F 09 40                    .@
        bne     LFCAA                           ; FCA1 D0 07                    ..
LFCA3:  ldy     cas1                            ; FCA3 AC 75 03                 .u.
        bne     LFCAD                           ; FCA6 D0 05                    ..
        and     #$BF                            ; FCA8 29 BF                    ).
LFCAA:  sta     tpi1_pb                         ; FCAA 8D 01 DE                 ...
LFCAD:  sta     tpi1_air                        ; FCAD 8D 07 DE                 ...
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

; ----------------------------------------------------------------------------
; Coprocessor request
ipcrq:  lda     ipb                             ; FCB9 AD 00 08                 ...
        and     #$7F                            ; FCBC 29 7F                    ).
        tay                                     ; FCBE A8                       .
        jsr     getpar                          ; FCBF 20 2F FE                  /.
        lda     #$04                            ; FCC2 A9 04                    ..
        and     cia1_prb                        ; FCC4 2D 01 DB                 -..
        bne     ipcrq                           ; FCC7 D0 F0                    ..
        lda     #$08                            ; FCC9 A9 08                    ..
        ora     cia1_prb                        ; FCCB 0D 01 DB                 ...
        sta     cia1_prb                        ; FCCE 8D 01 DB                 ...
        nop                                     ; FCD1 EA                       .
        lda     cia1_prb                        ; FCD2 AD 01 DB                 ...
        tax                                     ; FCD5 AA                       .
        and     #$04                            ; FCD6 29 04                    ).
        beq     LFCE6                           ; FCD8 F0 0C                    ..
        txa                                     ; FCDA 8A                       .
        eor     #$08                            ; FCDB 49 08                    I.
        sta     cia1_prb                        ; FCDD 8D 01 DB                 ...
        txa                                     ; FCE0 8A                       .
        nop                                     ; FCE1 EA                       .
        nop                                     ; FCE2 EA                       .
        nop                                     ; FCE3 EA                       .
        bne     ipcrq                           ; FCE4 D0 D3                    ..
LFCE6:  lda     #$FF                            ; FCE6 A9 FF                    ..
        sta     cia1_ddra                       ; FCE8 8D 02 DB                 ...
        lda     ipb                             ; FCEB AD 00 08                 ...
        sta     cia1_pra                        ; FCEE 8D 00 DB                 ...
        jsr     frebus                          ; FCF1 20 16 FE                  ..
        lda     cia1_prb                        ; FCF4 AD 01 DB                 ...
        and     #$BF                            ; FCF7 29 BF                    ).
        sta     cia1_prb                        ; FCF9 8D 01 DB                 ...
        ora     #$40                            ; FCFC 09 40                    .@
        cli                                     ; FCFE 58                       X
        nop                                     ; FCFF EA                       .
        nop                                     ; FD00 EA                       .
        nop                                     ; FD01 EA                       .
        sta     cia1_prb                        ; FD02 8D 01 DB                 ...
        jsr     waithi                          ; FD05 20 FC FD                  ..
        lda     #$00                            ; FD08 A9 00                    ..
        sta     cia1_ddra                       ; FD0A 8D 02 DB                 ...
        jsr     acklo                           ; FD0D 20 04 FE                  ..
        jsr     waitlo                          ; FD10 20 F4 FD                  ..
        ldy     #$00                            ; FD13 A0 00                    ..
        beq     LFD34                           ; FD15 F0 1D                    ..
LFD17:  lda     #$FF                            ; FD17 A9 FF                    ..
        sta     cia1_ddra                       ; FD19 8D 02 DB                 ...
        lda     ipb+5,y                         ; FD1C B9 05 08                 ...
        sta     cia1_pra                        ; FD1F 8D 00 DB                 ...
        jsr     ackhi                           ; FD22 20 0D FE                  ..
        jsr     waithi                          ; FD25 20 FC FD                  ..
        lda     #$00                            ; FD28 A9 00                    ..
        sta     cia1_ddra                       ; FD2A 8D 02 DB                 ...
        jsr     acklo                           ; FD2D 20 04 FE                  ..
        jsr     waitlo                          ; FD30 20 F4 FD                  ..
        iny                                     ; FD33 C8                       .
LFD34:  cpy     ipb+3                           ; FD34 CC 03 08                 ...
        bne     LFD17                           ; FD37 D0 DE                    ..
        ldy     #$00                            ; FD39 A0 00                    ..
        beq     LFD50                           ; FD3B F0 13                    ..
LFD3D:  jsr     ackhi                           ; FD3D 20 0D FE                  ..
        jsr     waithi                          ; FD40 20 FC FD                  ..
        lda     cia1_pra                        ; FD43 AD 00 DB                 ...
        sta     ipb+5,y                         ; FD46 99 05 08                 ...
        jsr     acklo                           ; FD49 20 04 FE                  ..
        jsr     waitlo                          ; FD4C 20 F4 FD                  ..
        iny                                     ; FD4F C8                       .
LFD50:  cpy     ipb+4                           ; FD50 CC 04 08                 ...
        bne     LFD3D                           ; FD53 D0 E8                    ..
        rts                                     ; FD55 60                       `

; ----------------------------------------------------------------------------
; Coprocessor irq handler
ipserv: lda     #$00                            ; FD56 A9 00                    ..
        sta     cia1_ddra                       ; FD58 8D 02 DB                 ...
        lda     cia1_pra                        ; FD5B AD 00 DB                 ...
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
        lda     cia1_pra                        ; FD8A AD 00 DB                 ...
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

; ----------------------------------------------------------------------------
        jsr     acklo                           ; FDA7 20 04 FE                  ..
        ldy     #$00                            ; FDAA A0 00                    ..
        beq     LFDCB                           ; FDAC F0 1D                    ..
LFDAE:  jsr     waithi                          ; FDAE 20 FC FD                  ..
        lda     #$FF                            ; FDB1 A9 FF                    ..
        sta     cia1_ddra                       ; FDB3 8D 02 DB                 ...
        lda     ipb+5,y                         ; FDB6 B9 05 08                 ...
        sta     cia1_pra                        ; FDB9 8D 00 DB                 ...
        jsr     ackhi                           ; FDBC 20 0D FE                  ..
        jsr     waitlo                          ; FDBF 20 F4 FD                  ..
        lda     #$00                            ; FDC2 A9 00                    ..
        sta     cia1_ddra                       ; FDC4 8D 02 DB                 ...
        jsr     acklo                           ; FDC7 20 04 FE                  ..
        iny                                     ; FDCA C8                       .
LFDCB:  cpy     ipb+4                           ; FDCB CC 04 08                 ...
        bne     LFDAE                           ; FDCE D0 DE                    ..
LFDD0:  rts                                     ; FDD0 60                       `

; ----------------------------------------------------------------------------
LFDD1:  lda     #$FD                            ; FDD1 A9 FD                    ..
        pha                                     ; FDD3 48                       H
        lda     #$DC                            ; FDD4 A9 DC                    ..
        pha                                     ; FDD6 48                       H
        jsr     getbus                          ; FDD7 20 1F FE                  ..
        jmp     (ipb+1)                         ; FDDA 6C 01 08                 l..

; ----------------------------------------------------------------------------
        jsr     frebus                          ; FDDD 20 16 FE                  ..
        lda     ipb+4                           ; FDE0 AD 04 08                 ...
        sta     ipb+3                           ; FDE3 8D 03 08                 ...
        sta     ipb                             ; FDE6 8D 00 08                 ...
        lda     #$00                            ; FDE9 A9 00                    ..
        sta     ipb+4                           ; FDEB 8D 04 08                 ...
        jsr     ipcrq                           ; FDEE 20 B9 FC                  ..
        jmp     LFDD0                           ; FDF1 4C D0 FD                 L..

; ----------------------------------------------------------------------------
waitlo: lda     cia1_prb                        ; FDF4 AD 01 DB                 ...
        and     #$04                            ; FDF7 29 04                    ).
        bne     waitlo                          ; FDF9 D0 F9                    ..
        rts                                     ; FDFB 60                       `

; ----------------------------------------------------------------------------
waithi: lda     cia1_prb                        ; FDFC AD 01 DB                 ...
        and     #$04                            ; FDFF 29 04                    ).
        beq     waithi                          ; FE01 F0 F9                    ..
        rts                                     ; FE03 60                       `

; ----------------------------------------------------------------------------
acklo:  lda     cia1_prb                        ; FE04 AD 01 DB                 ...
        and     #$F7                            ; FE07 29 F7                    ).
        sta     cia1_prb                        ; FE09 8D 01 DB                 ...
        rts                                     ; FE0C 60                       `

; ----------------------------------------------------------------------------
ackhi:  lda     #$08                            ; FE0D A9 08                    ..
        ora     cia1_prb                        ; FE0F 0D 01 DB                 ...
        sta     cia1_prb                        ; FE12 8D 01 DB                 ...
        rts                                     ; FE15 60                       `

; ----------------------------------------------------------------------------
; Free the bus for the coprocessor
frebus: lda     tpi1_pb                         ; FE16 AD 01 DE                 ...
        and     #$EF                            ; FE19 29 EF                    ).
        sta     tpi1_pb                         ; FE1B 8D 01 DE                 ...
        rts                                     ; FE1E 60                       `

; ----------------------------------------------------------------------------
; Wait until we own the bus
getbus: lda     cia1_prb                        ; FE1F AD 01 DB                 ...
        and     #$02                            ; FE22 29 02                    ).
        beq     getbus                          ; FE24 F0 F9                    ..
        lda     tpi1_pb                         ; FE26 AD 01 DE                 ...
        ora     #$10                            ; FE29 09 10                    ..
        sta     tpi1_pb                         ; FE2B 8D 01 DE                 ...
        rts                                     ; FE2E 60                       `

; ----------------------------------------------------------------------------
; Place coprocessor parameters into buffer
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

; ----------------------------------------------------------------------------
; End of coprocessor irq handler
ipcgo:  ldx     #$FF                            ; FE41 A2 FF                    ..
        stx     i6509                           ; FE43 86 01                    ..
        lda     tpi1_pb                         ; FE45 AD 01 DE                 ...
        and     #$EF                            ; FE48 29 EF                    ).
        sta     tpi1_pb                         ; FE4A 8D 01 DE                 ...
        nop                                     ; FE4D EA                       .
        lda     cia1_prb                        ; FE4E AD 01 DB                 ...
        ror                                     ; FE51 6A                       j
        bcs     ipcgx                           ; FE52 B0 01                    ..
        rts                                     ; FE54 60                       `

; ----------------------------------------------------------------------------
; Prepare for coprocessor takeover
ipcgx:  lda     #$00                            ; FE55 A9 00                    ..
        sei                                     ; FE57 78                       x
        sta     cia1_prb                        ; FE58 8D 01 DB                 ...
        lda     #$40                            ; FE5B A9 40                    .@
        nop                                     ; FE5D EA                       .
        nop                                     ; FE5E EA                       .
        nop                                     ; FE5F EA                       .
        nop                                     ; FE60 EA                       .
        sta     cia1_prb                        ; FE61 8D 01 DB                 ...
        cli                                     ; FE64 58                       X
; Wait while the coprocessor has the bus
iploop: jmp     iploop                          ; FE65 4C 65 FE                 Le.

; ----------------------------------------------------------------------------
; Cassette entry. Standard value for itape is notape (below).
tape:   jmp     (itape)                         ; FE68 6C 6A 03                 lj.

; ----------------------------------------------------------------------------
; Default cassette routines (device not present)
notape: pla                                     ; FE6B 68                       h
        pla                                     ; FE6C 68                       h
        jmp     error5                          ; FE6D 4C 4C F9                 LL.

; ----------------------------------------------------------------------------
LFE70:  lda     stah                            ; FE70 A5 9A                    ..
        sta     sah                             ; FE72 85 94                    ..
        lda     stal                            ; FE74 A5 99                    ..
        sta     sal                             ; FE76 85 93                    ..
        lda     stas                            ; FE78 A5 9B                    ..
        sta     sas                             ; FE7A 85 95                    ..
        sta     i6509                           ; FE7C 85 01                    ..
        rts                                     ; FE7E 60                       `

; ----------------------------------------------------------------------------
cmpste: sec                                     ; FE7F 38                       8
        lda     sal                             ; FE80 A5 93                    ..
        sbc     eal                             ; FE82 E5 96                    ..
        lda     sah                             ; FE84 A5 94                    ..
        sbc     eah                             ; FE86 E5 97                    ..
        lda     sas                             ; FE88 A5 95                    ..
        sbc     eas                             ; FE8A E5 98                    ..
        rts                                     ; FE8C 60                       `

; ----------------------------------------------------------------------------
incsal: inc     sal                             ; FE8D E6 93                    ..
        bne     LFE9F                           ; FE8F D0 0E                    ..
        inc     sah                             ; FE91 E6 94                    ..
        bne     LFE9F                           ; FE93 D0 0A                    ..
        inc     sas                             ; FE95 E6 95                    ..
        lda     sas                             ; FE97 A5 95                    ..
        sta     i6509                           ; FE99 85 01                    ..
        lda     #$02                            ; FE9B A9 02                    ..
        sta     sal                             ; FE9D 85 93                    ..
LFE9F:  rts                                     ; FE9F 60                       `

; ----------------------------------------------------------------------------
; Load a byte from the file name
fnadry: ldx     i6509                           ; FEA0 A6 01                    ..
        lda     fnadr+2                         ; FEA2 A5 92                    ..
        sta     i6509                           ; FEA4 85 01                    ..
        lda     (fnadr),y                       ; FEA6 B1 90                    ..
        stx     i6509                           ; FEA8 86 01                    ..
        rts                                     ; FEAA 60                       `

; ----------------------------------------------------------------------------
; Support routine for cross bank calls
farcall:php                                     ; FEAB 08                       .
        sei                                     ; FEAC 78                       x
        pha                                     ; FEAD 48                       H
        txa                                     ; FEAE 8A                       .
        pha                                     ; FEAF 48                       H
        tya                                     ; FEB0 98                       .
        pha                                     ; FEB1 48                       H
        jsr     ipinit                          ; FEB2 20 11 FF                  ..
        tay                                     ; FEB5 A8                       .
        lda     e6509                           ; FEB6 A5 00                    ..
        jsr     putag                           ; FEB8 20 22 FF                  ".
        lda     #$FD                            ; FEBB A9 FD                    ..
        ldx     #$FE                            ; FEBD A2 FE                    ..
        jsr     putaxs                          ; FEBF 20 1C FF                  ..
        tsx                                     ; FEC2 BA                       .
        lda     stack+5,x                       ; FEC3 BD 05 01                 ...
        sec                                     ; FEC6 38                       8
        sbc     #$03                            ; FEC7 E9 03                    ..
        pha                                     ; FEC9 48                       H
        lda     stack+6,x                       ; FECA BD 06 01                 ...
        sbc     #$00                            ; FECD E9 00                    ..
        tax                                     ; FECF AA                       .
        pla                                     ; FED0 68                       h
        jsr     putaxs                          ; FED1 20 1C FF                  ..
        tya                                     ; FED4 98                       .
excomm: sec                                     ; FED5 38                       8
        sbc     #$04                            ; FED6 E9 04                    ..
        sta     stackp                          ; FED8 8D FF 01                 ...
        tay                                     ; FEDB A8                       .
        ldx     #$04                            ; FEDC A2 04                    ..
LFEDE:  pla                                     ; FEDE 68                       h
        iny                                     ; FEDF C8                       .
        sta     (ipoint),y                      ; FEE0 91 AC                    ..
        dex                                     ; FEE2 CA                       .
        bne     LFEDE                           ; FEE3 D0 F9                    ..
        ldy     stackp                          ; FEE5 AC FF 01                 ...
        lda     #$25                            ; FEE8 A9 25                    .%
        ldx     #$FF                            ; FEEA A2 FF                    ..
        jsr     putaxs                          ; FEEC 20 1C FF                  ..
        pla                                     ; FEEF 68                       h
        pla                                     ; FEF0 68                       h
        tsx                                     ; FEF1 BA                       .
        stx     stackp                          ; FEF2 8E FF 01                 ...
        tya                                     ; FEF5 98                       .
        tax                                     ; FEF6 AA                       .
        txs                                     ; FEF7 9A                       .
        lda     i6509                           ; FEF8 A5 01                    ..
        jmp     kgbye                           ; FEFA 4C F6 FF                 L..

; ----------------------------------------------------------------------------
        nop                                     ; FEFD EA                       .
; Return from call to foreign bank
excrts: php                                     ; FEFE 08                       .
        php                                     ; FEFF 08                       .
        pha                                     ; FF00 48                       H
        txa                                     ; FF01 8A                       .
        pha                                     ; FF02 48                       H
        tya                                     ; FF03 98                       .
        pha                                     ; FF04 48                       H
        tsx                                     ; FF05 BA                       .
        lda     stack+6,x                       ; FF06 BD 06 01                 ...
        sta     i6509                           ; FF09 85 01                    ..
        jsr     ipinit                          ; FF0B 20 11 FF                  ..
        jmp     excomm                          ; FF0E 4C D5 FE                 L..

; ----------------------------------------------------------------------------
; ipoint = $100, Y = $FF (stack)
ipinit: ldy     #$01                            ; FF11 A0 01                    ..
        sty     ipoint+1                        ; FF13 84 AD                    ..
        dey                                     ; FF15 88                       .
        sty     ipoint                          ; FF16 84 AC                    ..
        dey                                     ; FF18 88                       .
        lda     (ipoint),y                      ; FF19 B1 AC                    ..
        rts                                     ; FF1B 60                       `

; ----------------------------------------------------------------------------
; Place X/A to ipoint (build stack in foreign bank)
putaxs: pha                                     ; FF1C 48                       H
        txa                                     ; FF1D 8A                       .
        sta     (ipoint),y                      ; FF1E 91 AC                    ..
        dey                                     ; FF20 88                       .
        pla                                     ; FF21 68                       h
; Place A to ipoint (build stack in foreign bank)
putag:  sta     (ipoint),y                      ; FF22 91 AC                    ..
        dey                                     ; FF24 88                       .
        rts                                     ; FF25 60                       `

; ----------------------------------------------------------------------------
; Pull registers after calling subroutine in foreign bank
expull: pla                                     ; FF26 68                       h
        tay                                     ; FF27 A8                       .
        pla                                     ; FF28 68                       h
        tax                                     ; FF29 AA                       .
        pla                                     ; FF2A 68                       h
        plp                                     ; FF2B 28                       (
        rts                                     ; FF2C 60                       `

; ----------------------------------------------------------------------------
; Helper routine to route interrupts from foreign to system bank
exnmi:  php                                     ; FF2D 08                       .
        jmp     (hanmi)                         ; FF2E 6C FA FF                 l..

; ----------------------------------------------------------------------------
; Helper routine to route BRK insns from foreign to system bank
exbrk:  brk                                     ; FF31 00                       .
        nop                                     ; FF32 EA                       .
        rts                                     ; FF33 60                       `

; ----------------------------------------------------------------------------
; Helper routine to route interrupts from foreign to system bank
exirq:  cli                                     ; FF34 58                       X
        rts                                     ; FF35 60                       `

; ----------------------------------------------------------------------------
; Unused space
unused2:
!byte   $AC,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF36 AC AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF3E AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF46 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF4E AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF56 AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF5E AA AA AA AA AA AA AA AA  ........
!byte   $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA ; FF66 AA AA AA AA AA AA AA AA  ........
!byte   $AA                             ; FF6E AA                       .
; ----------------------------------------------------------------------------
kvreset:jmp     vreset                          ; FF6F 4C D9 FB                 L..

; ----------------------------------------------------------------------------
kipcgo: jmp     ipcgo                           ; FF72 4C 41 FE                 LA.

; ----------------------------------------------------------------------------
kfunkey:jmp     jfunkey                         ; FF75 4C 22 E0                 L".

; ----------------------------------------------------------------------------
kipcrq: jmp     ipcrq                           ; FF78 4C B9 FC                 L..

; ----------------------------------------------------------------------------
kioinit:jmp     ioinit                          ; FF7B 4C FE F9                 L..

; ----------------------------------------------------------------------------
kcint:  jmp     jcint                           ; FF7E 4C 04 E0                 L..

; ----------------------------------------------------------------------------
kalloc: jmp     alloc                           ; FF81 4C 07 F4                 L..

; ----------------------------------------------------------------------------
kvector:jmp     vector                          ; FF84 4C B8 FB                 L..

; ----------------------------------------------------------------------------
krestor:jmp     restor                          ; FF87 4C B1 FB                 L..

; ----------------------------------------------------------------------------
klkupsa:jmp     lkupsa                          ; FF8A 4C 67 F6                 Lg.

; ----------------------------------------------------------------------------
klkupla:jmp     lkupla                          ; FF8D 4C 7F F6                 L..

; ----------------------------------------------------------------------------
ksetmsg:jmp     setmsg                          ; FF90 4C 69 FB                 Li.

; ----------------------------------------------------------------------------
ksecnd: jmp     (isecnd)                        ; FF93 6C 24 03                 l$.

; ----------------------------------------------------------------------------
ktksa:  jmp     (itksa)                         ; FF96 6C 26 03                 l&.

; ----------------------------------------------------------------------------
kmemtop:jmp     memtop                          ; FF99 4C 87 FB                 L..

; ----------------------------------------------------------------------------
kmembot:jmp     membot                          ; FF9C 4C 9C FB                 L..

; ----------------------------------------------------------------------------
kscnkey:jmp     jscnkey                         ; FF9F 4C 13 E0                 L..

; ----------------------------------------------------------------------------
ksettmo:jmp     settmo                          ; FFA2 4C 83 FB                 L..

; ----------------------------------------------------------------------------
kacptr: jmp     (iacptr)                        ; FFA5 6C 28 03                 l(.

; ----------------------------------------------------------------------------
kciout: jmp     (iciout)                        ; FFA8 6C 2A 03                 l*.

; ----------------------------------------------------------------------------
kuntalk:jmp     (iuntlk)                        ; FFAB 6C 2C 03                 l,.

; ----------------------------------------------------------------------------
kunlsn: jmp     (iunlsn)                        ; FFAE 6C 2E 03                 l..

; ----------------------------------------------------------------------------
klisten:jmp     (ilistn)                        ; FFB1 6C 30 03                 l0.

; ----------------------------------------------------------------------------
ktalk:  jmp     (italk)                         ; FFB4 6C 32 03                 l2.

; ----------------------------------------------------------------------------
kreadst:jmp     readst                          ; FFB7 4C 56 FB                 LV.

; ----------------------------------------------------------------------------
ksetlfs:jmp     setlfs                          ; FFBA 4C 4F FB                 LO.

; ----------------------------------------------------------------------------
ksetnam:jmp     setnam                          ; FFBD 4C 40 FB                 L@.

; ----------------------------------------------------------------------------
kopen:  jmp     (iopen)                         ; FFC0 6C 06 03                 l..

; ----------------------------------------------------------------------------
kclose: jmp     (iclose)                        ; FFC3 6C 08 03                 l..

; ----------------------------------------------------------------------------
kchkin: jmp     (ichkin)                        ; FFC6 6C 0A 03                 l..

; ----------------------------------------------------------------------------
kckout: jmp     (ickout)                        ; FFC9 6C 0C 03                 l..

; ----------------------------------------------------------------------------
kclrch: jmp     (iclrch)                        ; FFCC 6C 0E 03                 l..

; ----------------------------------------------------------------------------
kbasin: jmp     (ibasin)                        ; FFCF 6C 10 03                 l..

; ----------------------------------------------------------------------------
kbsout: jmp     (ibsout)                        ; FFD2 6C 12 03                 l..

; ----------------------------------------------------------------------------
kload:  jmp     (iload)                         ; FFD5 6C 1A 03                 l..

; ----------------------------------------------------------------------------
ksave:  jmp     (isave)                         ; FFD8 6C 1C 03                 l..

; ----------------------------------------------------------------------------
ksettim:jmp     settim                          ; FFDB 4C 15 F9                 L..

; ----------------------------------------------------------------------------
krdtim: jmp     rdtim                           ; FFDE 4C ED F8                 L..

; ----------------------------------------------------------------------------
kstop:  jmp     (istop)                         ; FFE1 6C 14 03                 l..

; ----------------------------------------------------------------------------
kgetin: jmp     (igetin)                        ; FFE4 6C 16 03                 l..

; ----------------------------------------------------------------------------
kclrall:jmp     (iclall)                        ; FFE7 6C 18 03                 l..

; ----------------------------------------------------------------------------
kudtim: jmp     udtim                           ; FFEA 4C 80 F9                 L..

; ----------------------------------------------------------------------------
kscrorg:jmp     jscrorg                         ; FFED 4C 10 E0                 L..

; ----------------------------------------------------------------------------
kplot:  jmp     jplot                           ; FFF0 4C 19 E0                 L..

; ----------------------------------------------------------------------------
kiobase:jmp     jiobase                         ; FFF3 4C 1C E0                 L..

; ----------------------------------------------------------------------------
; Actual execution segment switch routine
kgbye:  sta     e6509                           ; FFF6 85 00                    ..
        rts                                     ; FFF8 60                       `

; ----------------------------------------------------------------------------
!byte   $80                             ; FFF9 80                       .
; Hardware NMI vector
hanmi:  !word   nmi                             ; FFFA 3D FB                    =.
; Hardware reset vector
hares:  !word   cold                            ; FFFC 9E F9                    ..
; Hardware IRQ vector
hairq:  !word   irq                             ; FFFE E5 FB                    ..
