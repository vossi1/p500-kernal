; disassembled by DASM6502b v.3.1 by Marat Fayzullin
; modified by Vossi 02/2019
!cpu 6502
*= $e000
		jmp lee09
		nop
le004:	jmp le044
le007:	jmp le0fe
le00a:	jmp le179
le00d:	jmp le299
le010:	jmp le03f
le013:	jmp le865
		jmp le0da
le019:	jmp le025
le01c:	jmp le03a
le01f:	jmp le970
le022:	jmp le6f8
le025:	bcs le035
		stx $ca
		stx $cf
		sty $cb
		sty $ce
		jsr le0cd
		jsr le0da
le035:	ldx $ca
		ldy $cb
		rts
le03a:	ldx #$00
		ldy #$dc
		rts
le03f:	ldx #$50
		ldy #$19
		rts
le044:	lda #$00
		ldx #$23
le048:	sta $c2,x
		dex
		bpl le048
		ldx #$20
le04f:	sta $0397,x
		dex
		bpl le04f
		lda #$0c
		sta $d8
		lda #$60
		sta $d4
		lda #$2a
		sta $03b5
		lda #$e9
		sta $03b6
		lda $c0
		ora $c1
		bne le0aa
		lda $0355
		sta $0380
		lda $0356
		sta $0381
		lda #$40
		ldx #$00
		ldy #$02
		jsr lff81
		bcs le0aa
		sta $0382
		inx
		stx $c0
		bne le08d
		iny
le08d:	sty $c1
		ldy #$39
		jsr le282
le094:	lda lec2d,y
		dey
		sta ($c0),y
		bne le094
		jsr le291
		ldy #$0a
le0a1:	lda lec23,y
		sta $0382,y
		dey
		bne le0a1
le0aa:	jsr le9c7
		jsr le251
		jsr le260
le0b3:	jsr le0c1
le0b6:	jsr le0cf
		jsr le227
		cpx $dd
		inx
		bcc le0b6
le0c1:	ldx $dc
		stx $ca
		stx $cf
le0c7:	ldy $de
		sty $cb
		sty $ce
le0cd:	ldx $ca
le0cf:	lda lebb2,x
		sta $c8
		lda lebcb,x
		sta $c9
		rts
le0da:	ldy #$0f
		clc
		lda $c8
		adc $cb
		sty $d800
		sta $d801
		dey
		sty $d800
		lda $d801
		and #$f8
		sta $d9
		lda $c9
		adc #$00
		and #$07
		ora $d9
		sta $d801
		rts
le0fe:	ldx $d6
		beq le114
		ldy $039d
		jsr le282
		lda ($c2),y
		jsr le291
		dec $d6
		inc $039d
		cli
		rts
le114:	ldy $03ab
		ldx #$00
le119:	lda $03ac,x
		sta $03ab,x
		inx
		cpx $d1
		bne le119
		dec $d1
		tya
		cli
		rts
le129:	jsr le299
le12c:	ldy #$0a
		lda $d4
		sty $d800
		sta $d801
le136:	lda $d1
		ora $d6
		beq le136
		sei
		jsr le0fe
		cmp #$0d
		bne le129
		jsr lecdc
		nop
		nop
		nop
		nop
		nop
		sta $d0
		jsr le544
		stx $0398
		jsr lecb0
		sta $d3
		sta $d2
		ldy $de
		lda $cf
		bmi le174
		cmp $ca
		bcc le174
		ldy $ce
		cmp $0398
		bne le170
		cpy $d5
		beq le172
le170:	bcs le183
le172:	sta $ca
le174:	sty $cb
		jmp le18b
le179:	tya
		pha
		txa
		pha
		lda $d0
		beq le12c
		bpl le18b
le183:	lda #$00
		sta $d0
		lda #$0d
		bne le1c4
le18b:	jsr le0cd
		jsr le242
		sta $db
		and #$3f
		asl $db
		bit $db
		bpl le19d
		ora #$80
le19d:	bcc le1a3
		ldx $d2
		bne le1a7
le1a3:	bvs le1a7
		ora #$40
le1a7:	jsr le1cd
		ldy $ca
		cpy $0398
		bcc le1bb
		ldy $cb
		cpy $d5
		bcc le1bb
		ror $d0
		bmi le1be
le1bb:	jsr le574
le1be:	cmp #$de
		bne le1c4
		lda #$ff
le1c4:	sta $db
		pla
		tax
		pla
		tay
		lda $db
		rts
le1cd:	cmp #$22
		bne le1dd
		lda $d3
		bne le1db
		lda $d2
		eor #$01
		sta $d2
le1db:	lda #$22
le1dd:	rts
le1de:	bit $0397
		bpl le1e5
		ora #$80
le1e5:	ldx $d3
		beq le1eb
		dec $d3
le1eb:	bit $039a
		bpl le1f9
		pha
		jsr le5e4
		ldx #$00
		stx $d3
		pla
le1f9:	jsr le21c
		cpy #$45
		bne le203
		jsr le48d
le203:	jsr le62e
le206:	lda $db
		sta $0399
		jsr le0da
		pla
		tay
		lda $d3
		beq le216
		lsr $d2
le216:	pla
		tax
		pla
		rts
le21a:	lda #$20
le21c:	ldy $cb
		jsr le27d
		sta ($c8),y
		jsr le291
		rts
le227:	ldy $de
		jsr le505
le22c:	txa
		pha
		lda $cb
		pha
		dey
le232:	iny
		sty $cb
		jsr le21a
		cpy $df
		bne le232
		pla
		sta $cb
		pla
		tax
		rts
le242:	ldy $cb
le244:	jsr le27d
		lda ($c8),y
		jsr le291
		rts
		ldy #$10
		bcs le253
le251:	ldy #$00
le253:	sty $cc
		lda $de06
		and #$ef
		ora $cc
		sta $de06
		rts
le260:	ldy #$11
		bit $df02
		bmi le26d
		ldy #$23
		bvs le26d
		ldy #$35
le26d:	ldx #$11
le26f:	lda lec6f,y
		stx $d800
		sta $d801
		dey
		dex
		bpl le26f
		rts
le27d:	pha
		lda #$3f
		bne le286
le282:	pha
		lda $0382
le286:	pha
		lda $01
		sta $03a0
		pla
		sta $01
		pla
		rts
le291:	pha
		lda $03a0
		sta $01
		pla
		rts
le299:	pha
		cmp #$ff
		bne le2a0
		lda #$de
le2a0:	sta $db
		txa
		pha
		tya
		pha
		lda #$00
		sta $d0
		ldy $cb
		lda $db
		and #$7f
		cmp #$20
		bcc le2cf
		ldx $0399
		cpx #$1b
		bne le2c1
		jsr le655
		jmp le303
le2c1:	and #$3f
le2c3:	bit $db
		bpl le2c9
		ora #$40
le2c9:	jsr le1cd
		jmp le1de
le2cf:	cmp #$0d
		beq le2fc
		cmp #$14
		beq le2fc
		cmp #$1b
		bne le2ec
		bit $db
		bmi le2ec
		lda $d2
		ora $d3
		beq le2fc
		jsr le3a2
		sta $db
		beq le2fc
le2ec:	cmp #$03
		beq le2fc
		ldy $d3
		bne le2f8
		ldy $d2
		beq le2fc
le2f8:	ora #$80
		bne le2c3
le2fc:	lda $db
		asl
		tax
		jsr le306
le303:	jmp le206
le306:	lda lebe5,x
		pha
		lda lebe4,x
		pha
		lda $db
		rts
		jmp ($0322)
		bcs le323
		jsr le37a
le319:	jsr le4f5
		bcs le321
		sec
		ror $cf
le321:	clc
		rts
le323:	ldx $dc
		cpx $ca
		bcs le338
le329:	jsr le319
		dec $ca
		jmp le0cd
		bcs le339
		jsr le574
		bcs le319
le338:	rts
le339:	jsr le587
		bcs le338
		bne le321
		inc $ca
		bne le329
		eor #$80
		sta $0397
		rts
		bcc le34f
		jmp le0b3
le34f:	cmp $0399
		bne le357
		jsr le9c7
le357:	jmp le0c1
		ldy $cb
		bcs le370
le35e:	cpy $df
		bcc le367
		lda $df
		sta $cb
		rts
le367:	iny
		jsr le95a
		beq le35e
		sty $cb
		rts
le370:	jsr le95a
		eor $039c
		sta $03a1,x
		rts
le37a:	ldx $ca
		cpx $dd
		bcc le38f
		bit $039b
		bpl le38b
		lda $dc
		sta $ca
		bcs le391
le38b:	jsr le3f6
		clc
le38f:	inc $ca
le391:	jmp le0cd
		jsr le544
		inx
		jsr le505
		ldy $de
		sty $cb
		jsr le37a
le3a2:	lda #$00
		sta $d3
		sta $0397
		sta $d2
		cmp $039f
		bne le3b3
		sta $da18
le3b3:	rts
le3b4:	lda lebb2,x
		sta $c4
		lda lebcb,x
		sta $c5
		jsr le27d
le3c1:	lda ($c4),y
		sta ($c8),y
		cpy $df
		iny
		bcc le3c1
		jmp le291
le3cd:	ldx $cf
		bmi le3d7
		cpx $ca
		bcc le3d7
		inc $cf
le3d7:	ldx $dd
le3d9:	jsr le0cf
		ldy $de
		cpx $ca
		beq le3f0
		dex
		jsr le4f7
		inx
		jsr le503
		dex
		jsr le3b4
		bcs le3d9
le3f0:	jsr le227
		jmp le512
le3f6:	ldx $dc
le3f8:	inx
		jsr le4f7
		bcc le408
		cpx $dd
		bcc le3f8
		ldx $dc
		inx
		jsr le505
le408:	dec $ca
		bit $cf
		bmi le410
		dec $cf
le410:	ldx $dc
		cpx $da
		bcs le418
		dec $da
le418:	jsr le42d
		ldx $dc
		jsr le4f7
		php
		jsr le505
		plp
		bcc le42c
		bit $039e
		bmi le408
le42c:	rts
le42d:	jsr le0cf
		ldy $de
		cpx $dd
		bcs le444
		inx
		jsr le4f7
		dex
		jsr le503
		inx
		jsr le3b4
		bcs le42d
le444:	jsr le227
		ldx #$ff
		ldy #$fe
		jsr le480
		and #$20
		bne le45f
le452:	nop
		nop
		dex
		bne le452
		dey
		bne le452
le45a:	sty $d1
le45c:	jmp le8f7
le45f:	ldx #$f7
		ldy #$ff
		jsr le480
		and #$10
		bne le45c
le46a:	jsr le480
		and #$10
		beq le46a
le471:	ldy #$00
		ldx #$00
		jsr le480
		and #$3f
		eor #$3f
		beq le471
		bne le45a
le480:	php
		sei
		stx $df00
		sty $df01
		jsr le91e
		plp
		rts
le48d:	lda $039f
		bne le4b9
		lda #$0f
		sta $da18
		ldy #$00
		sty $da05
		lda #$0a
		sta $da06
		lda #$30
		sta $da01
		lda #$60
		sta $da0f
		ldx #$15
		stx $da04
le4b0:	nop
		nop
		iny
		bne le4b0
		dex
		stx $da04
le4b9:	rts
		lda $cb
		pha
le4bd:	ldy $cb
		dey
		jsr le244
		cmp #$2b
		beq le4cb
		cmp #$2d
		bne le4d3
le4cb:	dey
		jsr le244
		cmp #$05
		bne le4ed
le4d3:	cmp #$05
		bne le4db
		dey
		jsr le244
le4db:	cmp #$2e
		bcc le4ed
		cmp #$2f
		beq le4ed
		cmp #$3a
		bcs le4ed
		jsr le5b0
		jmp le4bd
le4ed:	pla
		cmp $cb
		bne le4b9
		jmp le5b0
le4f5:	ldx $ca
le4f7:	jsr le51e
		and $e2,x
		cmp #$01
		jmp le50e
le501:	ldx $ca
le503:	bcs le512
le505:	jsr le51e
		eor #$ff
		and $e2,x
le50c:	sta $e2,x
le50e:	ldx $039c
		rts
le512:	bit $039b
		bvs le4f7
		jsr le51e
		ora $e2,x
		bne le50c
le51e:	stx $039c
		txa
		and #$07
		tax
		lda lec67,x
		pha
		lda $039c
		lsr
		lsr
		lsr
		tax
		pla
		rts
		ldy $de
		sty $cb
le536:	jsr le4f5
		bcc le541
		dec $ca
		bpl le536
		inc $ca
le541:	jmp le0cd
le544:	lda $ca
		cmp $dd
		bcs le553
		inc $ca
		jsr le4f5
		bcs le544
		dec $ca
le553:	jsr le0cd
		ldy $df
		sty $cb
		bpl le561
le55c:	jsr le587
		bcs le571
le561:	jsr le242
		cmp #$20
		bne le571
		cpy $de
		bne le55c
		jsr le4f5
		bcs le55c
le571:	sty $d5
		rts
le574:	pha
		ldy $cb
		cpy $df
		bcc le582
		jsr le37a
		ldy $de
		dey
		sec
le582:	iny
		sty $cb
		pla
		rts
le587:	ldy $cb
		dey
		bmi le590
		cpy $de
		bcs le59f
le590:	ldy $dc
		cpy $ca
		bcs le5a4
		dec $ca
		pha
		jsr le0cd
		pla
		ldy $df
le59f:	sty $cb
		cpy $df
		clc
le5a4:	rts
le5a5:	ldy $cb
		sty $d9
		ldx $ca
		stx $da
		rts
		bcs le5e4
le5b0:	jsr le339
		jsr le5a5
		bcs le5c7
le5b8:	cpy $df
		bcc le5d2
		ldx $ca
		inx
		jsr le4f7
		bcs le5d2
		jsr le21a
le5c7:	lda $d9
		sta $cb
		lda $da
		sta $ca
		jmp le0cd
le5d2:	jsr le574
		jsr le242
		jsr le587
		jsr le21c
		jsr le574
		jmp le5b8
le5e4:	jsr le5a5
		jsr le544
		cpx $da
		bne le5f0
		cpy $d9
le5f0:	bcc le613
		jsr le62e
		bcs le619
le5f7:	jsr le587
		jsr le242
		jsr le574
		jsr le21c
		jsr le587
		ldx $ca
		cpx $da
		bne le5f7
		cpy $d9
		bne le5f7
		jsr le21a
le613:	inc $d3
		bne le619
		dec $d3
le619:	jmp le5c7
		bcc le62d
		sei
		ldx #$09
		stx $d1
le623:	lda leba8,x
		sta $03aa,x
		dex
		bne le623
		cli
le62d:	rts
le62e:	cpy $df
		bcc le63d
		ldx $ca
		cpx $dd
		bcc le63d
		bit $039b
		bmi le654
le63d:	jsr le0cd
		jsr le574
		bcc le654
		jsr le4f5
		bcs le653
		jsr led00
		sec
		bvs le654
		jsr le3cd
le653:	clc
le654:	rts
le655:	jmp ($0320)
		jsr le3cd
		jsr le0c7
		inx
		jsr le4f7
		php
		jsr le501
		plp
		bcs le66c
		sec
		ror $cf
le66c:	rts
		jsr le536
		lda $dc
		pha
		lda $ca
		sta $dc
		lda $039e
		pha
		lda #$80
		sta $039e
		jsr le408
		pla
		sta $039e
		lda $dc
		sta $ca
		pla
		sta $dc
		sec
		ror $cf
		jmp le0c7
		jsr le5a5
le697:	jsr le22c
		inc $ca
		jsr le0cd
		ldy $de
		jsr le4f5
		bcs le697
le6a6:	jmp le5c7
		jsr le5a5
le6ac:	jsr le21a
		cpy $de
		bne le6b8
		jsr le4f5
		bcc le6a6
le6b8:	jsr le587
		bcc le6ac
		jsr le5a5
		txa
		pha
		jsr le3f6
		pla
		sta $da
		jmp le6a6
		jsr le5a5
		jsr le4f5
		bcs le6d6
		sec
		ror $cf
le6d6:	lda $dc
		sta $ca
		jsr le3cd
		jsr le505
		jmp le6a6
		clc
		bit $38
		lda #$00
		ror
		sta $039b
		rts
		clc
		bcc le6f1
		sec
le6f1:	lda #$00
		ror
		sta $039e
		rts
le6f8:	sei
		dey
		bmi le6ff
		jmp le7be
le6ff:	ldy #$00
le701:	iny
		sty $03b7
		dey
		lda $0383,y
		beq le777
		sta $039d
		jsr le949
		sta $c2
		stx $c3
		ldx #$03
le717:	lda le7a6,x
		jsr lffd2
		dex
		bpl le717
le720:	ldx #$2f
		lda $03b7
		sec
le726:	inx
		sbc #$0a
		bcs le726
		adc #$3a
		cpx #$30
		beq le737
		pha
		txa
		jsr lffd2
		pla
le737:	jsr lffd2
		ldy #$00
		lda #$2c
le73e:	jsr lffd2
		ldx #$07
le743:	jsr le282
		lda ($c2),y
		jsr le291
		cmp #$0d
		beq le781
		cmp #$8d
		beq le784
		cmp #$22
		beq le787
		cpx #$09
		beq le762
		pha
		lda #$22
		jsr lffd2
		pla
le762:	jsr lffd2
		ldx #$09
		iny
		cpy $039d
		bne le743
		lda #$22
		jsr lffd2
le772:	lda #$0d
		jsr lffd2
le777:	ldy $03b7
		cpy #$14
		bne le701
		cli
		clc
		rts
le781:	ldx #$0a
		bit $13a2
		bit $0ea2
		txa
		pha
		ldx #$06
le78d:	lda le7aa,x
		beq le79c
		jsr lffd2
		dex
		bpl le78d
		pla
		tax
		bne le78d
le79c:	iny
		cpy $039d
		beq le772
		lda #$2b
		bne le73e
le7a6:	jsr $4559
		!byte $4b
le7aa:	plp
		bit $52
		pha
		!byte $43
		!byte $2b
		!byte $22
		brk
		and #$33
		and ($00),y
		and #$34
		!byte $33
		brk
		and #$31
		!byte $34
		and ($48),y
		tax
		sty $d9
		lda $00,x
		sec
		sbc $0383,y
		sta $da
		ror $039c
		iny
		jsr le949
		sta $c4
		stx $c5
		ldy #$14
		jsr le949
		sta $c6
		stx $c7
		ldy $039c
		bpl le7f6
		clc
		sbc $0380
		tay
		txa
		sbc $0381
		tax
		tya
		clc
		adc $da
		txa
		adc #$00
		bcs le862
le7f6:	jsr le282
le7f9:	lda $c6
		clc
		sbc $c4
		lda $c7
		sbc $c5
		bcc le82e
		ldy #$00
		lda $039c
		bpl le81c
		lda $c6
		bne le811
		dec $c7
le811:	dec $c6
		lda ($c6),y
		ldy $da
		sta ($c6),y
		jmp le7f9
le81c:	lda ($c4),y
		ldy $da
		dec $c5
		sta ($c4),y
		inc $c5
		inc $c4
		bne le7f9
		inc $c5
		bne le7f9
le82e:	ldy $d9
		jsr le949
		sta $c4
		stx $c5
		ldy $d9
		pla
		pha
		tax
		lda $00,x
		sta $0383,y
		tay
		beq le85e
		lda $01,x
		sta $c6
		lda $02,x
		sta $c7
le84c:	dey
		lda $03,x
		sta $01
		lda ($c6),y
		jsr le291
		jsr le282
		sta ($c4),y
		tya
		bne le84c
le85e:	jsr le291
		clc
le862:	pla
		cli
		rts
le865:	ldy #$ff
		sty $e0
		sty $e1
		iny
		sty $df01
		sty $df00
		jsr le91e
		and #$3f
		eor #$3f
		bne le87e
		jmp le8f3
le87e:	lda #$ff
		sta $df00
		asl
		sta $df01
		jsr le91e
		pha
		sta $e0
		ora #$30
		bne le894
le891:	jsr le91e
le894:	ldx #$05
le896:	lsr
		bcc le8a9
		iny
		dex
		bpl le896
		sec
		rol $df01
		rol $df00
		bcs le891
		pla
		bcc le8f3
le8a9:	sty $e1
		ldx lea29,y
		pla
		asl
		asl
		asl
		bcc le8c2
		bmi le8c5
		ldx lea89,y
		lda $cc
		beq le8c5
		ldx leae9,y
		bne le8c5
le8c2:	ldx leb49,y
le8c5:	cpx #$ff
		beq le8f5
		cpx #$e0
		bcc le8d6
		tya
		pha
		jsr le927
		pla
		tay
		bcs le8f5
le8d6:	txa
		cpy $cd
		beq le902
		ldx #$13
		stx $d8
		ldx $d1
		cpx #$09
		beq le8f3
		cpy #$59
		bne le912
		cpx #$08
		beq le8f3
		sta $03ab,x
		inx
		bne le912
le8f3:	ldy #$ff
le8f5:	sty $cd
le8f7:	ldx #$7f
		stx $df00
		ldx #$ff
		stx $df01
		rts
le902:	dec $d8
		bpl le8f7
		inc $d8
		dec $d7
		bpl le8f7
		inc $d7
		ldx $d1
		bne le8f7
le912:	sta $03ab,x
		inx
		stx $d1
		ldx #$03
		stx $d7
		bne le8f5
le91e:	lda $df02
		cmp $df02
		bne le91e
		rts
le927:	jmp ($03b5)
		cpy $cd
		beq le947
		lda $d1
		ora $d6
		bne le947
		sta $039d
		txa
		and #$1f
		tay
		lda $0383,y
		sta $d6
		jsr le949
		sta $c2
		stx $c3
le947:	sec
		rts
le949:	lda $c0
		ldx $c1
le94d:	clc
		dey
		bmi le959
		adc $0383,y
		bcc le94d
		inx
		bne le94d
le959:	rts
le95a:	tya
		and #$07
		tax
		lda lec67,x
		sta $039c
		tya
		lsr
		lsr
		lsr
		tax
		lda $03a1,x
		bit $039c
		rts
le970:	and #$7f
		sec
		sbc #$41
		cmp #$1a
		bcc le97a
		rts
le97a:	asl
		tax
		lda le986,x
		pha
		lda le985,x
		pha
		rts
le985:	!byte $22
le986:	nop
		tsx
		sbc #$1f
		nop
		jmp (leee6)
		sbc #$e5
		sbc #$d5
		sbc #$d7
		sbc #$57
		inc $31
		sbc $43
		sbc $e2
		inc $e4
		inc $04
		nop
		lda ($e3,x)
		tay
		inc $93
		inc $f5
		sbc #$eb
		sbc #$b8
		sbc #$db
		sbc #$bc
		inc $ca
		inc $78
		sbc #$07
		nop
		sed
		sbc #$18
		bit $38
		ldx $cb
		lda $ca
		bcc le9d1
le9c2:	sta $dd
		stx $df
		rts
le9c7:	lda #$18
		ldx #$4f
		jsr le9c2
		lda #$00
		tax
le9d1:	sta $dc
		stx $de
		rts
		lda #$00
		sta $039f
		rts
		lda #$0b
		bit $df02
		bmi le9e8
		lda #$06
		bit $60a9
le9e8:	ora $d4
		bne le9f3
		lda #$f0
		bit $0fa9
		and $d4
le9f3:	sta $d4
		rts
		lda #$20
		bit $10a9
		ldx #$0e
		stx $d800
		ora $d801
		bne lea12
		lda #$df
		bit lefa9
		ldx #$0e
		stx $d800
		and $d801
lea12:	sta $d801
		and #$30
		ldx #$0c
		stx $d800
		sta $d801
		rts
		lda #$00
		bit lffa9
		sta $039a
		rts
lea29:	cpx #$1b
		ora #$ff
		brk
		ora ($e1,x)
		and ($51),y
		eor ($5a,x)
		!byte $ff
		!byte $e2
		!byte $32
		!byte $57
		!byte $53
		cli
		!byte $43
		!byte $e3
		!byte $33
		eor $44
		lsr $56
		cpx $34
		!byte $52
		!byte $54
		!byte $47
		!byte $42
		sbc $35
		rol $59,x
		pha
		lsr $37e6
		eor $4a,x
		eor le720
		sec
		eor #$4b
		bit le82e
		and $4c4f,y
		!byte $3b
		!byte $2f
		sbc #$30
		and $5b50
		!byte $27
		ora ($3d),y
lea67:	!byte $5f
		eor $de0d,x
		sta ($9d),y
		ora $0214,x
		!byte $ff
		!byte $13
		!byte $3f
		!byte $37
		!byte $34
		and ($30),y
		!byte $12
		!byte $04
		sec
		and $32,x
		rol $2a8e
		and $3336,y
		bmi lea87
		!byte $2f
		and $0d2b
		!byte $ff
lea89:	nop
		!byte $1b
		!byte $89
		!byte $ff
		brk
		ora ($eb,x)
		and ($d1,x)
		cmp ($da,x)
		!byte $ff
		cpx $d740
		!byte $d3
		cld
		!byte $c3
		sbc $c523
		cpy $c6
		dec $ee,x
		bit $d2
		!byte $d4
		!byte $c7
		!byte $c2
		!byte $ef
		and $5e
		cmp $cec8,y
		beq lead5
		cmp $ca,x
		cmp lf1a0
		rol
		cmp #$cb
		!byte $3c
		rol $28f2,x
		!byte $cf
		cpy $3f3a
		!byte $f3
		and #$2d
		bne leb1f
		!byte $22
		ora ($2b),y
leac7:	!byte $5c
		eor $de8d,x
		sta ($9d),y
		ora $8294,x
		!byte $ff
		!byte $93
		!byte $3f
		!byte $37
		!byte $34
lead5:	and ($30),y
		!byte $92
		sty $38
		and $32,x
		rol $2a0e
		and $3336,y
		bmi lea67
		!byte $2f
		and $8d2b
		!byte $ff
leae9:	nop
		!byte $1b
		!byte $89
		!byte $ff
		brk
		ora ($eb,x)
		and ($d1,x)
		cmp ($da,x)
		!byte $ff
		cpx $d740
		!byte $d3
		cld
		cpy #$ed
		!byte $23
		cmp $c4
		dec $c3
		inc $d224
		!byte $d4
		!byte $c7
		!byte $c2
		!byte $ef
		and $5e
		cmp $ddc8,y
		beq leb35
		cmp $ca,x
		cmp lf1a0
		rol
		cmp #$cb
		!byte $3c
		rol $28f2,x
		!byte $cf
		dec $3a,x
		!byte $3f
leb1f:	!byte $f3
		and #$2d
		bne leb7f
		!byte $22
		ora ($2b),y
		!byte $5c
		eor $de8d,x
		sta ($9d),y
		!byte $1a
		sty $82,x
		!byte $ff
		!byte $93
		!byte $3f
		!byte $37
		!byte $34
leb35:	and ($30),y
		!byte $92
		!byte $04
		sec
		and $32,x
		rol $2a0e
		and $3336,y
		bmi leac7
leb44:	!byte $2f
		and $8d2b
		!byte $ff
leb49:	!byte $ff
		!byte $ff
leb4b:	!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		lda ($11,x)
		ora ($1a,x)
		!byte $ff
leb55:	!byte $ff
		ldx #$17
		!byte $13
		clc
		!byte $03
		!byte $ff
		!byte $a3
		ora $04
		asl $16
		!byte $ff
		ldy $12
		!byte $14
leb65:	!byte $07
		!byte $02
		!byte $ff
		lda $a7
		ora $0e08,y
		!byte $ff
		ldx $0a15,y
		ora lffff
		!byte $bb
		ora #$0b
		dec lffff
		!byte $bf
		!byte $0f
		!byte $0c
		!byte $dc
		!byte $ff
leb7f:	!byte $ff
		ldy $10bc
		cpy lffa8
		lda #$df
		tsx
		!byte $ff
		ldx $ff
		!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		!byte $b7
		ldy $b1,x
		bcs leb44
		!byte $ff
		clv
leb99:	lda $b2,x
		ldx lffbd
		lda $b3b6,y
		!byte $db
		!byte $ff
		!byte $ff
		!byte $af
		tax
		!byte $ab
		!byte $ff
leba8:	!byte $ff
leba9:	!byte $44
		cpy $2a22
		ora $5552
		lsr $000d
		bvc leb55
		beq lebf7
		bcc leb99
		bmi leb3b
		bne lebdd
		bvs leb7f
		bpl lec21
		bcs lebc3
lebc3:	bvc leb65
		beq lec07
		bcc leba9
lebc9:	bmi leb4b
lebcb:	bne leb9d
lebcd:	bne leb9f
		cmp ($d1),y
		cmp ($d2),y
		!byte $d2
		!byte $d2
lebd5:	!byte $d3
		!byte $d3
		!byte $d3
		!byte $d4
		!byte $d4
		!byte $d4
		cmp $d5,x
lebdd:	cmp $d5,x
lebdf:	dec $d6,x
lebe1:	dec $d7,x
		!byte $d7
lebe4:	bpl lebc9
		bpl lebcb
		bpl lebcd
		!byte $1b
		inc $b9
		cpx $10
		!byte $e3
		bpl lebd5
		sty $10e4
lebf5:	!byte $e3
		eor $10e3,y
lebf9:	!byte $e3
		bpl lebdf
		bpl lebe1
		!byte $93
lebff:	!byte $e3
		jmp $bbe2
lec03:	sbc #$10
lec05:	!byte $e3
		!byte $13
lec07:	!byte $e3
		!byte $43
		!byte $e3
		eor #$e3
		lda $10e5
		!byte $e3
		bpl lebf5
		bpl lebf7
		bpl lebf9
		bpl lebfb
		bpl lebfd
		bpl lebff
		bpl lec01
		bmi lec03
		bpl lec05
		bpl lec07
		ora $04
		asl $06
		ora $06
		!byte $04
		ora #$07
lec2d:	ora $50
		!byte $52
		eor #$4e
		!byte $54
		jmp $5349
		!byte $54
		!byte $44
		jmp $414f
		!byte $44
		!byte $22
		!byte $44
		!byte $53
		eor ($56,x)
		eor $22
		!byte $44
		!byte $4f
		bvc lec8c
		lsr $4344
		jmp $534f
		eor $43
		!byte $4f
		bvc lecab
		!byte $44
		eor #$52
		eor $43
		!byte $54
		!byte $4f
		!byte $52
		eor $4353,y
		!byte $52
		eor ($54,x)
		!byte $43
		pha
		!byte $43
		pha
		!byte $52
		bit $28
lec67:	!byte $80
		rti
		jsr $0810
		!byte $04
		!byte $02
		ora ($6b,x)
		bvc lecc5
		!byte $0f
		ora $1903,y
		ora $0d00,y
		rts
		ora $0000
		brk
		brk
		brk
		brk
		ror $6250,x
		asl
		!byte $1f
		asl $19
		!byte $1c
		brk
		!byte $07
		brk
lec8c:	!byte $07
		brk
		brk
		brk
		brk
		brk
		brk
		!byte $7f
		bvc lecf6
		asl
		rol $01
		ora $001e,y
		!byte $07
		brk
		!byte $07
		brk
		brk
		brk
		brk
		brk
		brk
		rol $aaaa
		tax
		tax
		tax
lecab:	tax
		tax
		tax
		tax
		tax
lecb0:	jsr le536
		lda #$00
		rts
lecb6:	ora $d0
		sta $d0
		lda $dd
		sta $0398
		lda $df
		rts
lecc2:	bcc lecc7
		jmp lf953
lecc7:	php
		pha
		lda $a0
		and #$01
		beq lecd9
		ldx $9e
		jsr lffc9
		jsr lffcc
		ldx $a6
lecd9:	pla
		plp
		rts
lecdc:	pha
		lda #$0a
		sta $d800
		lda #$20
		sta $d801
		pla
		rts
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
lecf6:	tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
led00:	ldx $dd
		cpx $dc
		bne led08
		pla
		pla
led08:	bit $039b
		rts
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		jsr lf9fb
		jsr lfba2
		jsr le004
lee09:	jsr lffcc
		lda #$5a
		ldx #$00
		ldy #$ee
		jsr lfbca
		cli
		lda #$c0
		sta $0361
		lda #$40
		sta $bd
		bne lee31
		jsr lffcc
		lda #$53
		sta $bd
		cld
		ldx #$05
lee2b:	pla
		sta $ae,x
		dex
		bpl lee2b
lee31:	lda $01
		sta $b5
		lda $0300
		sta $b8
		lda $0301
		sta $b7
		tsx
		stx $b4
		cli
		lda #$08
		sta $bf
		ldy $bd
		jsr lf21c
		lda #$52
		bne lee77
lee50:	jsr lef22
		pla
		pla
		lda #$c0
		sta $0361
		lda #$00
		sta $90
		lda #$02
		sta $91
		lda #$0f
		sta $92
		jsr lef27
lee69:	jsr lffcf
		cmp #$2e
		beq lee69
		cmp #$20
		beq lee69
		jmp ($031e)
lee77:	ldx #$00
		stx $9d
		tay
		lda #$ee
		pha
		lda #$54
		pha
		tya
lee83:	cmp leed5,x
		bne lee98
		sta $0366
		lda leed6,x
		sta $b9
		lda leed7,x
		sta $ba
		jmp ($00b9)
lee98:	inx
		inx
		inx
		cpx #$24
		bcc lee83
		ldx #$00
leea1:	cmp #$0d
		beq leeb2
		cmp #$20
		beq leeb2
		sta $0200,x
		jsr lffcf
		inx
		bne leea1
leeb2:	sta $bd
		txa
		beq leed4
		sta $9d
		lda #$40
		sta $0361
		lda $bf
		sta $9f
		lda #$0f
		sta $01
		ldx #$ff
		ldy #$ff
		jsr lffd5
		bcs leed4
		lda $bd
		jmp ($0099)
leed4:	rts
leed5:	!byte $3a
leed6:	sbc $ef,x
		!byte $3b
		!byte $cb
		!byte $ef
		!byte $52
		jmp $4def
		!byte $8f
		!byte $ef
		!byte $47
		bpl leed4
		jmp lf04a
		!byte $53
		lsr
		beq lef41
		sbc ($ef,x)
		rti
		adc $f1
		!byte $5a
		!byte $72
		!byte $ff
		cli
		sbc $55ee,y
		!byte $eb
		!byte $ef
		pla
		pla
		sei
		jmp ($03f8)
leeff:	lda $b9
		sta $af
		lda $ba
		sta $ae
		rts
lef08:	lda #$b0
		sta $b9
		lda #$00
		sta $ba
		lda #$0f
		sta $01
		lda #$05
		rts
lef17:	pha
		jsr lef27
		pla
		jsr lffd2
lef1f:	lda #$20
		bit $3fa9
		jmp lffd2
lef27:	lda #$0d
		jsr lffd2
		lda #$2e
		jmp lffd2
lef31:	ora $2020
		jsr $4350
		jsr $4920
		!byte $52
		eor ($20),y
		jsr $5253
		jsr $4341
		jsr $5258
		jsr $5259
		jsr $5053
		ldx #$00
lef4e:	lda lef31,x
		jsr lffd2
		inx
		cpx #$1b
		bne lef4e
		lda #$3b
		jsr lef17
		ldx $ae
		ldy $af
		jsr lf0f6
		jsr lef1f
		ldx $b7
		ldy $b8
		jsr lf0f6
		jsr lef08
lef72:	sta $bd
		ldy #$00
		sty $9d
lef78:	jsr lef1f
		lda ($b9),y
		jsr lf0fb
		inc $b9
		bne lef8a
		inc $ba
		bne lef8a
		dec $9d
lef8a:	dec $bd
		bne lef78
		rts
		jsr lf040
		jsr lf113
		jsr lf123
		bcc lefa2
		lda $bb
		sta $b9
		lda $bc
		sta $ba
lefa2:	jsr lf113
lefa5:	jsr lffe1
		beq lefca
		lda #$3a
		jsr lef17
		ldx $ba
		ldy $b9
		jsr lf0f6
		lda #$10
		jsr lef72
		lda $9d
		bne lefca
		sec
		lda $bb
		sbc $b9
		lda $bc
		sbc $ba
		bcs lefa5
lefca:	rts
		jsr lf040
		jsr leeff
		jsr lf040
		lda $b9
		sta $b8
		lda $ba
		sta $b7
		jsr lef08
		bne leffa
		jsr lf03a
		cmp #$10
		bcs lf047
		sta $01
		rts
		jsr lf03a
		cmp #$20
		bcs lf047
		sta $bf
		rts
		jsr lf040
		lda #$10
leffa:	sta $bd
leffc:	jsr lf130
		bcs lf00f
		ldy #$00
		sta ($b9),y
		inc $b9
		bne lf00b
		inc $ba
lf00b:	dec $bd
		bne leffc
lf00f:	rts
		jsr lf15f
		beq lf01b
		jsr lf040
		jsr leeff
lf01b:	ldx $b4
		txs
		sei
		lda $b7
		sta $0301
		lda $b8
		sta $0300
		lda $b5
		sta $01
		ldx #$00
lf02f:	lda $ae,x
		pha
		inx
		cpx #$06
		bne lf02f
		jmp lfca5
lf03a:	jsr lf130
		bcs lf045
lf03f:	rts
lf040:	jsr lf123
		bcc lf03f
lf045:	pla
		pla
lf047:	jmp lee50
lf04a:	ldy #$01
		sty $9f
		dey
		lda #$ff
		sta $b9
		sta $ba
		lda $01
		sta $be
		lda #$0f
		sta $01
lf05d:	jsr lf15f
		beq lf07e
		cmp #$20
		beq lf05d
		cmp #$22
lf068:	bne lf047
lf06a:	jsr lf15f
		beq lf07e
		cmp #$22
		beq lf090
		sta ($90),y
		inc $9d
		iny
		cpy #$10
		beq lf047
		bne lf06a
lf07e:	lda $0366
		cmp #$4c
		bne lf068
		lda $be
		and #$0f
		ldx $b9
		ldy $ba
		jmp lffd5
lf090:	jsr lf15f
		beq lf07e
		cmp #$2c
lf097:	bne lf068
		jsr lf03a
		sta $9f
		jsr lf15f
		beq lf07e
		cmp #$2c
lf0a5:	bne lf097
		jsr lf03a
		cmp #$10
		bcs lf0f3
		sta $be
		sta $9b
		jsr lf040
		lda $b9
		sta $99
		lda $ba
		sta $9a
		jsr lf15f
		beq lf07e
		cmp #$2c
		bne lf0f3
		jsr lf03a
		cmp #$10
		bcs lf0f3
		sta $98
		jsr lf040
		lda $b9
		sta $96
		lda $ba
		sta $97
lf0da:	jsr lffcf
		cmp #$20
		beq lf0da
		cmp #$0d
lf0e3:	bne lf0a5
		lda $0366
		cmp #$53
		bne lf0e3
		ldx #$99
		ldy #$96
		jmp lffd8
lf0f3:	jmp lee50
lf0f6:	txa
		jsr lf0fb
		tya
lf0fb:	pha
		lsr
		lsr
		lsr
		lsr
		jsr lf107
		tax
		pla
		and #$0f
lf107:	clc
		adc #$f6
		bcc lf10e
		adc #$06
lf10e:	adc #$3a
		jmp lffd2
lf113:	ldx #$02
lf115:	lda $b8,x
		pha
		lda $ba,x
		sta $b8,x
		pla
		sta $ba,x
		dex
		bne lf115
		rts
lf123:	jsr lf130
		bcs lf12f
		sta $ba
		jsr lf130
		sta $b9
lf12f:	rts
lf130:	lda #$00
		sta $0100
		jsr lf15f
		beq lf153
		cmp #$20
		beq lf130
		jsr lf154
		asl
		asl
		asl
		asl
		sta $0100
		jsr lf15f
		beq lf153
		jsr lf154
		ora $0100
lf153:	rts
lf154:	cmp #$3a
		php
		and #$0f
		plp
		bcc lf15e
		adc #$08
lf15e:	rts
lf15f:	jsr lffcf
		cmp #$0d
		rts
		lda #$00
		sta $9c
		sta $9d
		ldx $bf
		ldy #$0f
		jsr lfb43
		clc
		jsr lffc0
		bcs lf1ba
		jsr lf15f
		beq lf19a
		pha
		ldx #$00
		jsr lffc9
		pla
		bcs lf1ba
		bcc lf18b
lf188:	jsr lffcf
lf18b:	cmp #$0d
		php
		jsr lffd2
		lda $9c
		bne lf1b6
		plp
		bne lf188
		beq lf1ba
lf19a:	jsr lef27
		ldx #$00
		jsr lffc6
		bcs lf1ba
lf1a4:	jsr lf15f
		php
		jsr lffd2
		lda $9c
		and #$bf
		bne lf1b6
		plp
		bne lf1a4
		beq lf1ba
lf1b6:	pla
		jsr lf945
lf1ba:	jsr lffcc
		lda #$00
		clc
		jmp lffc3
lf1c3:	ora $2f49
		!byte $4f
		jsr $5245
		!byte $52
		!byte $4f
		!byte $52
		jsr $0da3
		!byte $53
		eor $41
		!byte $52
		!byte $43
		pha
		eor #$4e
		!byte $47
		ldy #$46
		!byte $4f
		!byte $52
		ldy #$0d
		jmp $414f
		!byte $44
		eor #$4e
		!byte $c7
		ora $4153
		lsr $49,x
		lsr $a047
		ora $4556
		!byte $52
		eor #$46
		eor $4e49,y
		!byte $c7
		ora $4f46
		eor $4e,x
		!byte $44
		ldy #$0d
		!byte $4f
		!byte $4b
		sta $2a0d
		rol
		jsr $4f4d
		lsr $5449
		!byte $4f
		!byte $52
		jsr $2e31
		bmi lf233
		rol
		rol
		sta $420d
		!byte $52
		eor $41
		!byte $cb
lf21c:	bit $0361
		bpl lf22e
lf221:	lda lf1c3,y
		php
		and #$7f
		jsr lffd2
		iny
		plp
		bpl lf221
lf22e:	clc
		rts
		ora #$40
		bne lf236
		ora #$20
lf236:	pha
		lda #$3f
		sta $de03
		lda #$ff
		sta $dc00
		sta $dc02
		lda #$fa
		sta $de00
		lda $aa
		bpl lf268
		lda $de00
		and #$df
		sta $de00
		lda $ab
		jsr lf2b9
		lda $aa
		and #$7f
		sta $aa
		lda $de00
		ora #$20
		sta $de00
lf268:	lda $de00
		and #$f7
		sta $de00
		pla
		jmp lf2b9
		jsr lf2b9
lf277:	lda $de00
		ora #$08
		sta $de00
		rts
		jsr lf2b9
lf283:	lda #$39
		and $de00
lf288:	sta $de00
		lda #$c7
		sta $de03
		lda #$00
		sta $dc02
		beq lf277
		pha
		lda $aa
		bpl lf2a3
		lda $ab
		jsr lf2b9
		lda $aa
lf2a3:	ora #$80
		sta $aa
		pla
		sta $ab
		rts
		lda #$5f
		bne lf2b1
		lda #$3f
lf2b1:	jsr lf236
		lda #$f8
		jmp lf288
lf2b9:	eor #$ff
		sta $dc00
		lda $de00
		ora #$12
		sta $de00
		bit $de00
		bvc lf2d4
		bpl lf2d4
		lda #$80
		jsr lfb5f
		bne lf304
lf2d4:	lda $de00
		bpl lf2d4
		and #$ef
		sta $de00
lf2de:	jsr lf36f
		bcc lf2e4
lf2e3:	sec
lf2e4:	bit $de00
		bvs lf2fc
		lda $dc0d
		and #$02
		beq lf2e4
		lda $035e
		bmi lf2de
		bcc lf2e3
		lda #$01
		jsr lfb5f
lf2fc:	lda $de00
		ora #$10
		sta $de00
lf304:	lda #$ff
		sta $dc00
		rts
		lda $de00
		and #$b9
		ora #$80
		sta $de00
lf314:	jsr lf36f
		bcc lf31a
lf319:	sec
lf31a:	lda $de00
		and #$10
		beq lf33f
		lda $dc0d
		and #$02
		beq lf31a
		lda $035e
		bmi lf314
		bcc lf319
		lda #$02
		jsr lfb5f
		lda $de00
		and #$3d
		sta $de00
		lda #$0d
		rts
lf33f:	lda $de00
		and #$7f
		sta $de00
		and #$20
		bne lf350
		lda #$40
		jsr lfb5f
lf350:	lda $dc00
		eor #$ff
		pha
		lda $de00
		ora #$40
		sta $de00
lf35e:	lda $de00
		and #$10
		beq lf35e
		lda $de00
		and #$bf
		sta $de00
		pla
		rts
lf36f:	lda #$ff
		sta $dc07
		lda #$11
		sta $dc0f
		lda $dc0d
		clc
		rts
		jmp lf951
lf381:	jsr lf42e
		ldy #$00
lf386:	cpy $9d
		beq lf395
		jsr lfe92
		sta $0376,y
		iny
		cpy #$04
		bne lf386
lf395:	lda $0376
		sta $dd03
		lda $0377
		and #$f2
		ora #$02
		sta $dd02
		clc
		lda $a0
		and #$02
		beq lf3c1
		lda $037d
		sta $037c
		lda $a8
		and #$f0
		beq lf3c1
		jsr lf3fc
		sta $a8
		stx $a6
		sty $a7
lf3c1:	jmp lecc2
		nop
		nop
		rts
lf3c7:	cmp #$41
		bcc lf3db
		cmp #$5b
		bcs lf3d1
		ora #$20
lf3d1:	cmp #$c1
		bcc lf3db
		cmp #$db
		bcs lf3db
		and #$7f
lf3db:	rts
lf3dc:	cmp #$41
		bcc lf3f0
		cmp #$5b
		bcs lf3e6
		ora #$80
lf3e6:	cmp #$61
		bcc lf3f0
		cmp #$7b
		bcs lf3f0
		and #$df
lf3f0:	rts
lf3f1:	lda $dd02
		ora #$09
		and #$fb
		sta $dd02
		rts
lf3fc:	ldx #$00
		ldy #$01
lf400:	txa
		sec
		eor #$ff
		adc $0355
		tax
		tya
		eor #$ff
		adc $0356
		tay
		lda $0357
		bcs lf41a
		lda #$ff
lf416:	ora #$40
		sec
		rts
lf41a:	cpy $035c
		bcc lf416
		bne lf426
		cpx $035b
		bcc lf416
lf426:	stx $0355
		sty $0356
		clc
		rts
lf42e:	php
		sei
		lda $dd01
		and #$60
		sta $037a
		sta $037b
		plp
		rts
lf43d:	lda $a1
		bne lf44d
		lda $d1
		ora $d6
		beq lf49a
		sei
		jsr le007
		clc
		rts
lf44d:	cmp #$02
		beq lf454
		jmp lffcf
lf454:	sty $0365
		stx $0366
		ldy $037c
		cpy $037d
		bne lf478
		lda $dd02
		and #$fd
		ora #$01
		sta $dd02
		lda $037a
		ora #$10
		sta $037a
		lda #$00
		beq lf494
lf478:	lda $037a
		and #$ef
		sta $037a
		ldx $01
		lda $a8
		sta $01
		lda ($a6),y
		stx $01
		inc $037c
		bit $a0
		bpl lf494
		jsr lf3dc
lf494:	ldy $0365
		ldx $0366
lf49a:	clc
		rts
		lda $a1
		bne lf4ab
		lda $cb
		sta $ce
		lda $ca
		sta $cf
		jmp lf4b5
lf4ab:	cmp #$03
		bne lf4ba
		jsr lecb6
		nop
		sta $d5
lf4b5:	jsr le00a
		clc
		rts
lf4ba:	bcs lf4c3
		cmp #$02
		beq lf4d0
		jsr lfe5a
lf4c3:	lda $9c
		beq lf4cb
lf4c7:	lda #$0d
lf4c9:	clc
lf4ca:	rts
lf4cb:	jsr lffa5
		clc
		rts
lf4d0:	jsr lffe4
		bcs lf4ca
		cmp #$00
		bne lf4c9
		lda $037a
		and #$10
		beq lf4c9
		lda $037a
		and #$60
		bne lf4c7
		jsr lffe1
		bne lf4d0
		sec
		rts
		pha
		lda $a2
		cmp #$03
		bne lf4fb
		pla
		jsr le00d
		clc
		rts
lf4fb:	bcc lf503
		pla
		jsr lffa8
		clc
		rts
lf503:	cmp #$02
		beq lf511
		pla
		jsr lfe5a
lf50b:	pla
		bcc lf510
		lda #$00
lf510:	rts
lf511:	stx $0363
		sty $0364
		lda $037a
		and #$60
		bne lf540
		pla
		bit $a0
		bpl lf526
		jsr lf3c7
lf526:	sta $dd00
		pha
lf52a:	lda $037a
		and #$60
		bne lf540
		lda $dd01
		and #$10
		bne lf540
		jsr lffe1
		bne lf52a
		sec
		bcs lf50b
lf540:	pla
		ldx $0363
		ldy $0364
		clc
		rts
		jsr lf63e
		beq lf551
		jmp lf93f
lf551:	jsr lf650
		lda $9f
		beq lf586
		cmp #$03
		beq lf586
		bcs lf58a
		cmp #$02
		bne lf580
		lda $a0
		and #$02
		beq lf583
		and $dd02
		beq lf57c
		eor #$ff
		and $dd02
		ora #$01
		pha
		jsr lf42e
		pla
		sta $dd02
lf57c:	lda #$02
		bne lf586
lf580:	jsr lfe5a
lf583:	jmp lf948
lf586:	sta $a1
		clc
		rts
lf58a:	tax
		jsr lffb4
		lda $a0
		bpl lf598
		jsr lf283
		jmp lf59b
lf598:	jsr lff96
lf59b:	txa
		bit $9c
		bpl lf586
		jmp lf945
		jsr lf63e
		beq lf5ab
		jmp lf93f
lf5ab:	jsr lf650
		lda $9f
		bne lf5b5
lf5b2:	jmp lf94b
lf5b5:	cmp #$03
		beq lf5d1
		bcs lf5d5
		cmp #$02
		bne lf5ce
		lda $a0
		lsr
		bcc lf5b2
		jsr lf42e
		jsr lf3f1
		lda #$02
		bne lf5d1
lf5ce:	jsr lfe5a
lf5d1:	sta $a2
		clc
		rts
lf5d5:	tax
		jsr lffb1
		lda $a0
		bpl lf5e2
		jsr lf277
		bne lf5e5
lf5e2:	jsr lff93
lf5e5:	txa
		bit $9c
		bpl lf5d1
		jmp lf945
		php
		jsr lf643
		beq lf5f6
		plp
		clc
		rts
lf5f6:	jsr lf650
		plp
		txa
		pha
		bcc lf61d
		lda $9f
		beq lf61d
		cmp #$03
		beq lf61d
		bcs lf61a
		cmp #$02
		bne lf613
		lda #$00
		sta $dd02
		beq lf61d
lf613:	pla
		jsr lf61e
		jsr lfe5a
lf61a:	jsr lf8bf
lf61d:	pla
lf61e:	tax
		dec $0360
		cpx $0360
		beq lf63c
		ldy $0360
		lda $0334,y
		sta $0334,x
		lda $033e,y
		sta $033e,x
		lda $0348,y
		sta $0348,x
lf63c:	clc
		rts
lf63e:	lda #$00
		sta $9c
		txa
lf643:	ldx $0360
lf646:	dex
		bmi lf676
		cmp $0334,x
		bne lf646
		clc
		rts
lf650:	lda $0334,x
		sta $9e
		lda $033e,x
		sta $9f
		lda $0348,x
		sta $a0
		rts
lf660:	tya
		ldx $0360
lf664:	dex
		bmi lf676
		cmp $0348,x
		bne lf664
		clc
lf66d:	jsr lf650
		tay
		lda $9e
		ldx $9f
		rts
lf676:	sec
		rts
lf678:	tax
		jsr lf63e
		bcc lf66d
		rts
		ror $0365
		sta $0366
lf685:	ldx $0360
lf688:	dex
		bmi lf6a6
		bit $0365
		bpl lf698
		lda $0366
		cmp $033e,x
		bne lf688
lf698:	lda $0334,x
		sec
		jsr lffc3
		bcc lf685
		lda #$00
		sta $0360
lf6a6:	ldx #$03
		cpx $a2
		bcs lf6af
		jsr lffae
lf6af:	cpx $a1
		bcs lf6b6
		jsr lffab
lf6b6:	ldx #$03
		stx $a2
		lda #$00
		sta $a1
		rts
		bcc lf6c4
		jmp lf73a
lf6c4:	ldx $9e
		jsr lf63e
		bne lf6ce
		jmp lf93c
lf6ce:	ldx $0360
		cpx #$0a
		bcc lf6d8
		jmp lf939
lf6d8:	inc $0360
		lda $9e
		sta $0334,x
		lda $a0
		ora #$60
		sta $a0
		sta $0348,x
		lda $9f
		sta $033e,x
		beq lf705
		cmp #$03
		beq lf705
		bcc lf6fb
		jsr lf707
		bcc lf705
lf6fb:	cmp #$02
		bne lf702
		jmp lf381
lf702:	jsr lfe5a
lf705:	clc
		rts
lf707:	lda $a0
		bmi lf738
		ldy $9d
		beq lf738
		lda $9f
		jsr lffb1
		lda $a0
		ora #$f0
lf718:	jsr lff93
		lda $9c
		bpl lf724
		pla
		pla
		jmp lf945
lf724:	lda $9d
		beq lf735
		ldy #$00
lf72a:	jsr lfe92
		jsr lffa8
		iny
		cpy $9d
		bne lf72a
lf735:	jsr lffae
lf738:	clc
		rts
lf73a:	lda $9f
		jsr lffb1
		lda #$6f
		sta $a0
		jmp lf718
		stx $036f
		sty $0370
		sta $035f
		sta $0371
		lda #$00
		sta $9c
		lda $9f
		bne lf75d
lf75a:	jmp lf951
lf75d:	cmp #$03
		beq lf75a
		bcs lf766
		jmp lf810
lf766:	lda #$60
		sta $a0
		ldy $9d
		bne lf771
		jmp lf94e
lf771:	jsr lf81b
		jsr lf707
		lda $9f
		jsr lffb4
		lda $a0
		jsr lff96
		jsr lffa5
		sta $96
		sta $99
		lda $9c
		lsr
		lsr
		bcc lf791
		jmp lf942
lf791:	jsr lffa5
		sta $97
		sta $9a
		jsr lf840
		lda $0371
		sta $98
		sta $9b
		lda $036f
		and $0370
		cmp #$ff
		beq lf7ba
		lda $036f
		sta $96
		sta $99
		lda $0370
		sta $97
		sta $9a
lf7ba:	lda #$fd
		and $9c
		sta $9c
		jsr lffe1
		bne lf7c8
		jmp lf8b3
lf7c8:	jsr lffa5
		tax
		lda $9c
		lsr
		lsr
		bcs lf7ba
		txa
		ldx $01
		ldy $98
		sty $01
		ldy #$00
		bit $035f
		bpl lf7ee
		sta $93
		lda ($96),y
		cmp $93
		beq lf7f0
		lda #$10
		jsr lfb5f
		lda $9691
lf7f0:	stx $01
		inc $96
		bne lf800
		inc $97
		bne lf800
		inc $98
		lda #$02
		sta $96
lf800:	bit $9c
		bvc lf7ba
		jsr lffab
		jsr lf8bf
		jmp lf813
		jmp lf942
lf810:	jsr lfe5a
lf813:	clc
		lda $98
		ldx $96
		ldy $97
		rts
lf81b:	bit $0361
		bpl lf83f
		ldy #$0c
		jsr lf21c
		lda $9d
		beq lf83f
		ldy #$17
		jsr lf21c
lf82e:	ldy $9d
		beq lf83f
		ldy #$00
lf834:	jsr lfe92
		jsr lffd2
		iny
		cpy $9d
		bne lf834
lf83f:	rts
lf840:	ldy #$1b
		lda $035f
		bpl lf849
		ldy #$2b
lf849:	jmp lf21c
		lda $00,x
		sta $99
		lda $01,x
		sta $9a
		lda $02,x
		sta $9b
		tya
		tax
		lda $00,x
		sta $96
		lda $01,x
		sta $97
		lda $02,x
		sta $98
		lda $9f
		bne lf86d
lf86a:	jmp lf951
lf86d:	cmp #$03
		beq lf86a
		bcc lf8d6
		lda #$61
		sta $a0
		ldy $9d
		bne lf87e
		jmp lf94e
lf87e:	jsr lf707
		jsr lf8d9
		lda $9f
		jsr lffb1
		lda $a0
		jsr lff93
		ldx $01
		jsr lfe62
		lda $93
		jsr lffa8
		lda $94
		jsr lffa8
		ldy #$00
lf89f:	jsr lfe71
		bcs lf8ba
		lda ($93),y
		jsr lffa8
		jsr lfe7f
		jsr lffe1
		bne lf89f
		stx $01
lf8b3:	jsr lf8bf
		lda #$00
		sec
		rts
lf8ba:	stx $01
		jsr lffae
lf8bf:	bit $a0
		bmi lf8d4
		lda $9f
		jsr lffb1
		lda $a0
		and #$ef
		ora #$e0
		jsr lff93
		jsr lffae
lf8d4:	clc
lf8d5:	rts
lf8d6:	jsr lfe5a
lf8d9:	lda $0361
		bpl lf8d5
		ldy #$23
		jsr lf21c
		jmp lf82e
lf8e6:	lda $dc08
		pha
		pha
		asl
		asl
		asl
		and #$60
		ora $dc0b
		tay
		pla
		ror
		ror
		and #$80
		ora $dc09
		sta $93
		ror
		and #$80
		ora $dc0a
		tax
		pla
		cmp $dc08
		bne lf8e6
		lda $93
		rts
lf90e:	pha
		pha
		ror
		and #$80
		ora $dc0f
		sta $dc0f
		tya
		rol
		rol
		rol $93
		rol
		rol $93
		txa
		rol
		rol $93
		pla
		rol
		rol $93
		sty $dc0b
		stx $dc0a
		pla
		sta $dc09
		lda $93
		sta $dc08
		rts
lf939:	lda #$01
		bit $02a9
		bit $03a9
		bit $04a9
		bit $05a9
		bit $06a9
		bit $07a9
		bit $08a9
		bit $09a9
lf953:	pha
		jsr lffcc
		ldy #$00
		bit $0361
		bvc lf968
		jsr lf221
		pla
		pha
		ora #$30
		jsr lffd2
lf968:	pla
		sec
		rts
		lda $a9
		and #$01
		bne lf978
		php
		jsr lffcc
		sta $d1
		plp
lf978:	rts
lf979:	lda $df02
		lsr
		bcs lf991
		lda #$fe
		sta $df01
		lda #$10
		and $df02
		bne lf98c
		sec
lf98c:	lda #$ff
		sta $df01
lf991:	rol
		sta $a9
		rts
lf995:	!byte $c2
		cmp lfea2
		sei
		txs
		cld
		lda #$a5
		cmp $03fa
		bne lf9aa
		lda $03fb
		cmp #$5a
		beq lf9f8
lf9aa:	lda #$06
		sta $96
		lda #$00
		sta $97
		sta $03f8
		ldx #$30
lf9b7:	ldy #$03
		lda $97
		bmi lf9d5
		clc
		adc #$10
		sta $97
		inx
		txa
		cmp ($96),y
		bne lf9b7
		dey
lf9c9:	lda ($96),y
		dey
		bmi lf9d8
		cmp lf995,y
		beq lf9c9
		bne lf9b7
lf9d5:	ldy #$e0
		bit $97a4
		sty $03f9
		tax
		bpl lf9f8
		jsr lf9fb
		lda #$f0
		sta $c1
		jsr le004
		jsr lfa88
		jsr lfba2
		jsr le004
		lda #$a5
		sta $03fa
lf9f8:	jmp ($03f8)
lf9fb:	lda #$f3
		sta $de06
		ldy #$ff
		sty $de05
		lda #$5c
		sta $de01
		lda #$7d
		sta $de04
		lda #$38
		sta $de00
		lda #$3f
		sta $de03
		sty $df00
		sty $de01
		sty $df03
		sty $df04
		lsr $df00
		iny
		sty $df02
		sty $df05
		lda #$7f
		sta $dc0d
		sty $dc02
		sty $dc03
		sty $dc0f
		sta $dc08
		sty $de02
lfa43:	lda $de02
		ror
		bcc lfa43
		sty $de02
		ldx #$00
lfa4e:	inx
		bne lfa4e
		iny
		lda $de02
		ror
		bcc lfa4e
		cpy #$1b
		bcc lfa5f
		lda #$88
		bit $08a9
		sta $dc0e
		lda $db0d
		lda #$90
		sta $db0d
		lda #$40
		sta $db01
		stx $db02
		stx $db0f
		stx $db0e
		lda #$48
		sta $db03
		lda #$01
		ora $de01
		sta $de01
		rts
lfa88:	lda #$00
		tax
lfa8b:	sta $0002,x
		sta $0200,x
		sta $02f8,x
		inx
		bne lfa8b
		lda #$01
		sta $01
		sta $035a
		sta $0354
		lda #$02
		sta $0358
		sta $0352
		dec $01
lfaab:	inc $01
		lda $01
		cmp #$0f
		beq lfad7
		ldy #$02
lfab5:	lda ($93),y
		tax
		lda #$55
		sta ($93),y
		lda ($93),y
		cmp #$55
		bne lfad7
		asl
		sta ($93),y
		lda ($93),y
		cmp #$aa
		bne lfad7
		txa
		sta ($93),y
		iny
		bne lfab5
		inc $94
		bne lfab5
		beq lfaab
lfad7:	ldx $01
		dex
		txa
		ldx #$ff
		ldy #$fd
		sta $0357
		sty $0356
		stx $0355
		ldy #$fa
		clc
		jsr lfb78
		dec $a8
		dec $a5
		lda #$5d
		sta $036a
		lda #$fe
		sta $036b
		rts
		sbc #$fb
		and ($ee,x)
		tax
		!byte $fc
		!byte $bf
		inc $ed,x
		sbc $49,x
		sbc $a3,x
		sbc $a6,x
		inc $9c,x
		!byte $f4
		inc $6bf4
		sbc lf43d,y
		!byte $7f
		inc $46,x
		!byte $f7
		jmp $77f8
		inc le01f
		!byte $1f
		cpx #$74
		!byte $f2
lfb23:	!byte $80
		!byte $f2
		asl
		!byte $f3
		!byte $97
		!byte $f2
		!byte $ab
		!byte $f2
		!byte $af
		!byte $f2
		!byte $34
		!byte $f2
		bmi lfb23
		jmp ($0304)
lfb34:	sta $9d
		lda $00,x
		sta $90
		lda $01,x
		sta $91
		lda $02,x
		sta $92
		rts
lfb43:	sta $9e
		stx $9f
		sty $a0
		rts
lfb4a:	bcc lfb64
		lda $9f
		cmp #$02
		bne lfb5d
		lda $037a
		pha
		lda #$00
		beq lfb6b
lfb5a:	sta $0361
lfb5d:	lda $9c
lfb5f:	ora $9c
		sta $9c
		rts
lfb64:	pha
		lda $9f
		cmp #$02
		bne lfb70
lfb6b:	pla
		sta $037a
		rts
lfb70:	pla
		sta $9c
		rts
lfb74:	sta $035e
		rts
lfb78:	bcc lfb83
		lda $035d
		ldx $035b
		ldy $035c
lfb83:	stx $035b
		sty $035c
		sta $035d
		rts
lfb8d:	bcc lfb98
		lda $035a
		ldx $0358
		ldy $0359
lfb98:	stx $0358
		sty $0359
		sta $035a
		rts
lfba2:	ldx #$fd
		ldy #$fa
		lda #$0f
		clc
lfba9:	stx $93
		sty $94
		ldx $01
		sta $01
		bcc lfbbd
		ldy #$33
lfbb5:	lda $0300,y
		sta ($93),y
		dey
		bpl lfbb5
lfbbd:	ldy #$33
lfbbf:	lda ($93),y
		sta $0300,y
		dey
		bpl lfbbf
		stx $01
		rts
lfbca:	stx $03f8
		sty $03f9
		lda #$5a
		sta $03fb
		rts
lfbd6:	pha
		txa
		pha
		tya
		pha
		tsx
		lda $0104,x
		and #$10
		bne lfbe6
		jmp ($0300)
lfbe6:	jmp ($0302)
		lda $01
		pha
		cld
		lda $de07
		bne lfbf5
		jmp lfca2
lfbf5:	cmp #$10
		beq lfbfc
		jmp lfc5b
lfbfc:	lda $dd01
		tax
		and #$60
		tay
		eor $037b
		beq lfc15
		tya
		sta $037b
		ora $037a
		sta $037a
		jmp lfc9f
lfc15:	txa
		and #$08
		beq lfc40
		ldy $037d
		iny
		cpy $037c
		bne lfc27
		lda #$08
		bne lfc3a
lfc27:	sty $037d
		dey
		ldx $a8
		stx $01
		ldx $dd01
		lda $dd00
		sta ($a6),y
		txa
		and #$07
lfc3a:	ora $037a
		sta $037a
lfc40:	lda $dd01
		and #$10
		beq lfc58
		lda $dd02
		and #$0c
		cmp #$04
		bne lfc58
		lda #$f3
		and $dd02
		sta $dd02
lfc58:	jmp lfc9f
lfc5b:	cmp #$08
		bne lfc69
		lda $db0d
		cli
		jsr lfd48
		jmp lfc9f
lfc69:	cli
		cmp #$04
		bne lfc7a
		lda $dc0d
		ora $0369
		sta $0369
		jmp lfc9f
lfc7a:	cmp #$02
		bne lfc81
		jmp lfc9f
lfc81:	jsr le013
		jsr lf979
		lda $de01
		bpl lfc95
		ldy #$00
		sty $0375
		ora #$40
		bne lfc9c
lfc95:	ldy $0375
		bne lfc9f
		and #$bf
lfc9c:	sta $de01
lfc9f:	sta $de07
lfca2:	pla
		sta $01
lfca5:	pla
		tay
		pla
		tax
		pla
		rti
lfcab:	lda $0800
		and #$7f
		tay
		jsr lfe21
		lda #$04
		and $db01
		bne lfcab
		lda #$08
		ora $db01
		sta $db01
		nop
		lda $db01
		tax
		and #$04
		beq lfcd8
		txa
		eor #$08
		sta $db01
		txa
		nop
		nop
		nop
		bne lfcab
lfcd8:	lda #$ff
		sta $db02
		lda $0800
		sta $db00
		jsr lfe08
		lda $db01
		and #$bf
		sta $db01
		ora #$40
		cli
		nop
		nop
		nop
		sta $db01
		jsr lfdee
		lda #$00
		sta $db02
		jsr lfdf6
		jsr lfde6
		ldy #$00
		beq lfd26
lfd09:	lda #$ff
		sta $db02
		lda $0805,y
		sta $db00
		jsr lfdff
		jsr lfdee
		lda #$00
		sta $db02
		jsr lfdf6
		jsr lfde6
		iny
lfd26:	cpy $0803
		bne lfd09
		ldy #$00
		beq lfd42
lfd2f:	jsr lfdff
		jsr lfdee
		lda $db00
		sta $0805,y
		jsr lfdf6
		jsr lfde6
		iny
lfd42:	cpy $0804
		bne lfd2f
		rts
lfd48:	lda #$00
		sta $db02
		lda $db00
		sta $0800
		and #$7f
		tay
		jsr lfe21
		tya
		asl
		tay
		lda $0810,y
		sta $0801
		iny
		lda $0810,y
		sta $0802
		jsr lfdff
		jsr lfde6
		ldy #$00
lfd71:	cpy $0803
		beq lfd8b
		jsr lfdf6
		jsr lfdee
		lda $db00
		sta $0805,y
		jsr lfdff
		jsr lfde6
		iny
		bne lfd71
lfd8b:	bit $0800
		bmi lfdc3
		lda #$fd
		pha
		lda #$98
		pha
		jmp ($0801)
		jsr lfdf6
		ldy #$00
		beq lfdbd
lfda0:	jsr lfdee
		lda #$ff
		sta $db02
		lda $0805,y
		sta $db00
		jsr lfdff
		jsr lfde6
		lda #$00
		sta $db02
		jsr lfdf6
		iny
lfdbd:	cpy $0804
		bne lfda0
lfdc2:	rts
lfdc3:	lda #$fd
		pha
		lda #$ce
		pha
		jsr lfe11
		jmp ($0801)
		jsr lfe08
		lda $0804
		sta $0803
		sta $0800
		lda #$00
		sta $0804
		jsr lfcab
		jmp lfdc2
lfde6:	lda $db01
		and #$04
		bne lfde6
		rts
lfdee:	lda $db01
		and #$04
		beq lfdee
		rts
lfdf6:	lda $db01
		and #$f7
		sta $db01
		rts
lfdff:	lda #$08
		ora $db01
		sta $db01
		rts
lfe08:	lda $de01
		and #$ef
		sta $de01
		rts
lfe11:	lda $db01
		and #$02
		beq lfe11
		lda $de01
		ora #$10
		sta $de01
		rts
lfe21:	lda $0910,y
		pha
		and #$0f
		sta $0803
		pla
		lsr
		lsr
		lsr
		lsr
		sta $0804
		rts
lfe33:	ldx #$ff
		stx $01
		lda $de01
		and #$ef
		sta $de01
		nop
		lda $db01
		ror
		bcs lfe47
		rts
lfe47:	lda #$00
		sei
		sta $db01
		lda #$40
		nop
		nop
		nop
		nop
		sta $db01
		cli
lfe57:	jmp lfe57
lfe5a:	jmp ($036a)
		pla
		pla
		jmp lf945
lfe62:	lda $9a
		sta $94
		lda $99
		sta $93
		lda $9b
		sta $95
		sta $01
		rts
lfe71:	sec
		lda $93
		sbc $96
		lda $94
		sbc $97
		lda $95
		sbc $98
		rts
lfe7f:	inc $93
		bne lfe91
		inc $94
		bne lfe91
		inc $95
		lda $95
		sta $01
		lda #$02
		sta $93
lfe91:	rts
lfe92:	ldx $01
		lda $92
		sta $01
		lda ($90),y
		stx $01
		rts
lfe9d:	sta $01
		txa
		clc
		adc #$02
		bcc lfea6
		iny
lfea6:	tax
		tya
		pha
		txa
		pha
		jsr lff19
		lda #$fe
		sta ($ac),y
		php
		sei
		pha
		txa
		pha
		tya
		pha
		jsr lff19
		tay
		lda $00
		jsr lff2a
		lda #$04
		ldx #$ff
		jsr lff24
		tsx
		lda $0105,x
		sec
		sbc #$03
		pha
		lda $0106,x
		sbc #$00
		tax
		pla
		jsr lff24
		tya
lfedc:	sec
		sbc #$04
		sta $01ff
		tay
		ldx #$04
lfee5:	pla
		iny
		sta ($ac),y
		dex
		bne lfee5
		ldy $01ff
		lda #$2d
		ldx #$ff
		jsr lff24
		pla
		pla
		tsx
		stx $01ff
		tya
		tax
		txs
		lda $01
		jmp lfff6
		nop
		php
		php
		sei
		pha
		txa
		pha
		tya
		pha
		tsx
		lda $0106,x
		sta $01
		jsr lff19
		jmp lfedc
lff19:	ldy #$01
		sty $ad
		dey
		sty $ac
		dey
		lda ($ac),y
		rts
lff24:	pha
		txa
		sta ($ac),y
		dey
		pla
lff2a:	sta ($ac),y
		dey
		rts
		pla
		tay
		pla
		tax
		pla
		plp
		rts
		php
		jmp (lfffa)
		brk
		nop
		rts
		cli
		rts
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		jmp lfe9d
		jmp lfbca
		jmp lfe33
		jmp le022
		jmp lfcab
		jmp lf9fb
		jmp le004
lff81:	jmp lf400
		jmp lfba9
		jmp lfba2
		jmp lf660
		jmp lf678
		jmp lfb5a
lff93:	jmp ($0324)
lff96:	jmp ($0326)
		jmp lfb78
		jmp lfb8d
		jmp le013
		jmp lfb74
lffa5:	jmp ($0328)
lffa8:	jmp ($032a)
lffab:	jmp ($032c)
lffae:	jmp ($032e)
lffb1:	jmp ($0330)
lffb4:	jmp ($0332)
		jmp lfb4a
		jmp lfb43
lffbd:	jmp lfb34
lffc0:	jmp ($0306)
lffc3:	jmp ($0308)
lffc6:	jmp ($030a)
lffc9:	jmp ($030c)
lffcc:	jmp ($030e)
lffcf:	jmp ($0310)
lffd2:	jmp ($0312)
lffd5:	jmp ($031a)
lffd8:	jmp ($031c)
		jmp lf90e
		jmp lf8e6
lffe1:	jmp ($0314)
lffe4:	jmp ($0316)
		jmp ($0318)
		jmp lf979
		jmp le010
		jmp le019
		jmp le01c
lfff6:	sta $00
		rts
		ora ($31,x)
		!byte $fb
		!byte $97
		sbc lfbd6,y
