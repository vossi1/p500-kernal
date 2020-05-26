; disassembled by DASM6502b v.3.1 by Marat Fayzullin
; modified by Vossi 02/2019
!cpu 6502
*= $e000
		jmp lee00
		nop
le004:	jmp le044
le007:	jmp le0da
le00a:	jmp le17b
le00d:	jmp le295
le010:	jmp le03f
le013:	jmp le81a
		jmp le814
le019:	jmp le025
le01c:	jmp le03a
le01f:	jmp le91c
le022:	jmp le6b5
le025:	bcs le035
		stx $ca
		stx $cf
		sty $cb
		sty $ce
		jsr le973
		jsr le0cd
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
		ldx #$1d
le048:	sta $c2,x
		dex
		bpl le048
		ldx #$2e
le04f:	sta $0383,x
		dex
		bpl le04f
		lda #$0c
		sta $d8
		lda #$60
		sta $d4
		lda #$d6
		sta $0391
		lda #$e8
		sta $0392
		lda $c0
		ora $c1
		bne le08f
		lda $0321
		sta $0380
		lda $0322
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
le08f:	ldy #$33
		jsr le27e
le094:	lda lebd4,y
		dey
		sta ($c0),y
		bne le094
		jsr le28d
		ldy #$0a
le0a1:	lda lebca,y
		sta $0392,y
		dey
		bne le0a1
le0aa:	jsr le973
		jsr le24d
		jsr le25c
le0b3:	jsr le0c1
le0b6:	jsr le0cf
		jsr le223
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
le0cf:	lda leb59,x
		sta $c8
		lda leb72,x
		sta $c9
		rts
le0da:	ldx $d6
		beq le0f0
		ldy $038d
		jsr le27e
		lda ($c2),y
		jsr le28d
		dec $d6
		inc $038d
		cli
		rts
le0f0:	ldy $03b1
		ldx #$00
le0f5:	lda $03b2,x
		sta $03b1,x
		inx
		cpx $d1
		bne le0f5
		dec $d1
		tya
		cli
		rts
le105:	jsr le295
le108:	ldy #$0f
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
		ldy #$0a
		lda $d4
		sty $d800
		sta $d801
le135:	lda $d1
		ora $d6
		beq le135
		sei
		ldy #$0a
		lda #$20
		sty $d800
		sta $d801
		jsr le0da
		cmp #$0d
		bne le105
		sta $d0
		jsr le502
		stx $0384
		jsr le4f4
		lda #$00
		sta $d2
		ldy $de
		lda $cf
		bmi le176
		cmp $ca
		bcc le176
		ldy $ce
		cmp $0384
		bne le172
		cpy $038f
		beq le174
le172:	bcs le185
le174:	sta $ca
le176:	sty $cb
		jmp le18d
le17b:	tya
		pha
		txa
		pha
		lda $d0
		beq le108
		bpl le18d
le185:	lda #$00
		sta $d0
		lda #$0d
		bne le1c7
le18d:	jsr le0cd
		jsr le23e
		sta $db
		and #$3f
		asl $db
		bit $db
		bpl le19f
		ora #$80
le19f:	bcc le1a5
		ldx $d2
		bne le1a9
le1a5:	bvs le1a9
		ora #$40
le1a9:	jsr le1d0
		ldy $ca
		cpy $0384
		bcc le1be
		ldy $cb
		cpy $038f
		bcc le1be
		ror $d0
		bmi le1c1
le1be:	jsr le52d
le1c1:	cmp #$de
		bne le1c7
		lda #$ff
le1c7:	sta $db
		pla
		tax
		pla
		tay
		lda $db
		rts
le1d0:	cmp #$22
		bne le1dc
		lda $d2
		eor #$01
		sta $d2
		lda #$22
le1dc:	rts
le1dd:	bit $0383
		bpl le1e4
		ora #$80
le1e4:	ldx $d3
		beq le1ea
		dec $d3
le1ea:	bit $0386
		bpl le1f8
		pha
		jsr le59d
		ldx #$00
		stx $d3
		pla
le1f8:	jsr le218
		cpy #$45
		bne le202
		jsr le488
le202:	jsr le5e7
le205:	lda $db
		sta $0385
		pla
		tay
		lda $d3
		beq le212
		lsr $d2
le212:	pla
		tax
		pla
		rts
le216:	lda #$20
le218:	ldy $cb
		jsr le279
		sta ($c8),y
		jsr le28d
		rts
le223:	ldy $de
		jsr le4c5
le228:	txa
		pha
		lda $cb
		pha
		dey
le22e:	iny
		sty $cb
		jsr le216
		cpy $df
		bne le22e
		pla
		sta $cb
		pla
		tax
		rts
le23e:	ldy $cb
		jsr le279
		lda ($c8),y
		jsr le28d
		rts
		ldy #$10
		bcs le24f
le24d:	ldy #$00
le24f:	sty $cc
		lda $de06
		and #$ef
		ora $cc
		sta $de06
		rts
le25c:	ldy #$11
		bit $df02
		bmi le269
		ldy #$23
		bvs le269
		ldy #$35
le269:	ldx #$11
le26b:	lda lec10,y
		stx $d800
		sta $d801
		dey
		dex
		bpl le26b
		rts
le279:	pha
		lda #$3f
		bne le282
le27e:	pha
		lda $0382
le282:	pha
		lda $01
		sta $0390
		pla
		sta $01
		pla
		rts
le28d:	pha
		lda $0390
		sta $01
		pla
		rts
le295:	pha
		cmp #$ff
		bne le29c
		lda #$de
le29c:	sta $db
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
		bcc le2cb
		ldx $0385
		cpx #$1b
		bne le2bd
		jsr le608
		jmp le2fd
le2bd:	and #$3f
le2bf:	bit $db
		bpl le2c5
		ora #$40
le2c5:	jsr le1d0
		jmp le1dd
le2cb:	cmp #$0d
		beq le2f6
		cmp #$14
		beq le2f6
		cmp #$1b
		bne le2e6
		bit $db
		bmi le2e6
		lda $d2
		beq le2f6
		jsr le696
		sta $db
		beq le2f6
le2e6:	cmp #$03
		beq le2f6
		ldy $d3
		bne le2f2
		ldy $d2
		beq le2f6
le2f2:	ora #$80
		bne le2bf
le2f6:	lda $db
		asl
		tax
		jsr le300
le2fd:	jmp le205
le300:	lda leb8c,x
		pha
		lda leb8b,x
		pha
		lda $db
		rts
		jmp ($0373)
		bcs le31d
		jsr le374
le313:	jsr le4b4
		bcs le31b
		sec
		ror $cf
le31b:	clc
		rts
le31d:	ldx $dc
		cpx $ca
		bcs le332
le323:	jsr le313
		dec $ca
		jmp le0cd
		bcs le333
		jsr le52d
		bcs le313
le332:	rts
le333:	jsr le540
		bcs le332
		bne le31b
		inc $ca
		bne le323
		eor #$80
		sta $0383
		rts
		bcc le349
		jmp le0b3
le349:	cmp $0385
		bne le351
		jsr le973
le351:	jmp le0c1
		ldy $cb
		bcs le36a
le358:	cpy $df
		bcc le361
		lda $df
		sta $cb
		rts
le361:	iny
		jsr le906
		beq le358
		sty $cb
		rts
le36a:	jsr le906
		eor $0388
		sta $03a7,x
		rts
le374:	ldx $ca
		cpx $dd
		bcc le389
		bit $0387
		bpl le385
		lda $dc
		sta $ca
		bcs le38b
le385:	jsr le3ea
		clc
le389:	inc $ca
le38b:	jmp le0cd
		jsr le502
		inx
		jsr le4c5
		ldy $de
		sty $cb
		jsr le374
		lda #$00
		sta $d3
		sta $0383
		sta $d2
		rts
le3a6:	lda leb59,x
		sta $c4
		lda leb72,x
		sta $c5
		jsr le279
le3b3:	lda ($c4),y
		sta ($c8),y
		cpy $df
		iny
		bcc le3b3
		jsr le28d
		rts
le3c0:	ldx $cf
		bmi le3ca
		cpx $ca
		bcc le3ca
		inc $cf
le3ca:	ldx $dd
le3cc:	jsr le0cf
		ldy $de
		cpx $ca
		beq le3e3
		dex
		jsr le4b6
		inx
		jsr le4c3
		dex
		jsr le3a6
		bcs le3cc
le3e3:	jsr le223
		jsr le4d4
		rts
le3ea:	ldx $dc
le3ec:	inx
		jsr le4b6
		bcc le3fc
		cpx $dd
		bcc le3ec
		ldx $dc
		inx
		jsr le4c5
le3fc:	dec $ca
		bit $cf
		bmi le404
		dec $cf
le404:	ldx $dc
		cpx $da
		bcs le40c
		dec $da
le40c:	jsr le421
		ldx $dc
		jsr le4b6
		php
		jsr le4c5
		plp
		bcc le420
		bit $038e
		bmi le3fc
le420:	rts
le421:	jsr le0cf
		ldy $de
		cpx $dd
		bcs le438
		inx
		jsr le4b6
		dex
		jsr le4c3
		inx
		jsr le3a6
		bcs le421
le438:	jsr le223
		ldx #$ff
		ldy #$fe
		jsr le47c
		and #$20
		bne le45b
le446:	nop
		nop
		dex
		bne le446
		dey
		bne le446
le44e:	sty $d1
le450:	ldx #$7f
		stx $df00
		ldx #$ff
		stx $df01
		rts
le45b:	ldx #$f7
		ldy #$ff
		jsr le47c
		and #$10
		bne le450
le466:	jsr le47c
		and #$10
		beq le466
le46d:	ldy #$00
		ldx #$00
		jsr le47c
		and #$3f
		eor #$3f
		beq le46d
		bne le44e
le47c:	sei
		stx $df00
		sty $df01
		jsr le8ca
		cli
		rts
le488:	lda $d5
		bne le4b3
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
le4aa:	nop
		nop
		iny
		bne le4aa
		dex
		stx $da04
le4b3:	rts
le4b4:	ldx $ca
le4b6:	jsr le4dc
		and $0389,x
		cmp #$01
		jmp le4d0
le4c1:	ldx $ca
le4c3:	bcs le4d4
le4c5:	jsr le4dc
		eor #$ff
		and $0389,x
le4cd:	sta $0389,x
le4d0:	ldx $0388
		rts
le4d4:	jsr le4dc
		ora $0389,x
		bne le4cd
le4dc:	stx $0388
		txa
		and #$07
		tax
		lda lec08,x
		pha
		lda $0388
		lsr
		lsr
		lsr
		tax
		pla
		rts
		ldy $de
		sty $cb
le4f4:	jsr le4b4
		bcc le4ff
		dec $ca
		bpl le4f4
		inc $ca
le4ff:	jmp le0cd
le502:	inc $ca
		jsr le4b4
		bcs le502
		dec $ca
		jsr le0cd
		ldy $df
		sty $cb
		bpl le519
le514:	jsr le540
		bcs le529
le519:	jsr le23e
		cmp #$20
		bne le529
		cpy $de
		bne le514
		jsr le4b4
		bcs le514
le529:	sty $038f
		rts
le52d:	pha
		ldy $cb
		cpy $df
		bcc le53b
		jsr le374
		ldy $de
		dey
		sec
le53b:	iny
		sty $cb
		pla
		rts
le540:	ldy $cb
		dey
		bmi le549
		cpy $de
		bcs le558
le549:	ldy $dc
		cpy $ca
		bcs le55d
		dec $ca
		pha
		jsr le0cd
		pla
		ldy $df
le558:	sty $cb
		cpy $df
		clc
le55d:	rts
le55e:	ldy $cb
		sty $d9
		ldx $ca
		stx $da
		rts
		bcs le59d
		jsr le333
		jsr le55e
		bcs le580
le571:	cpy $df
		bcc le58b
		ldx $ca
		inx
		jsr le4b6
		bcs le58b
		jsr le216
le580:	lda $d9
		sta $cb
		lda $da
		sta $ca
		jmp le0cd
le58b:	jsr le52d
		jsr le23e
		jsr le540
		jsr le218
		jsr le52d
		jmp le571
le59d:	jsr le55e
		jsr le502
		cpx $da
		bne le5a9
		cpy $d9
le5a9:	bcc le5cc
		jsr le5e7
		bcs le5d2
le5b0:	jsr le540
		jsr le23e
		jsr le52d
		jsr le218
		jsr le540
		ldx $ca
		cpx $da
		bne le5b0
		cpy $d9
		bne le5b0
		jsr le216
le5cc:	inc $d3
		bne le5d2
		dec $d3
le5d2:	jmp le580
		bcc le5e6
		sei
		ldx #$09
		stx $d1
le5dc:	lda leb4f,x
		sta $03b0,x
		dex
		bne le5dc
		cli
le5e6:	rts
le5e7:	cpy $df
		bcc le5f6
		ldx $ca
		cpx $dd
		bcc le5f6
		bit $0387
		bmi le607
le5f6:	jsr le0cd
		jsr le52d
		bcc le607
		jsr le4b4
		bcs le606
		jsr le3c0
le606:	clc
le607:	rts
le608:	jmp ($0371)
		jsr le3c0
		jsr le0c7
		inx
		jsr le4b6
		php
		jsr le4c1
		plp
		bcs le61f
		sec
		ror $cf
le61f:	rts
		jsr le4f4
		lda $dc
		pha
		lda $ca
		sta $dc
		lda $038e
		pha
		lda #$80
		sta $038e
		jsr le3fc
		pla
		sta $038e
		lda $dc
		sta $ca
		pla
		sta $dc
		sec
		ror $cf
		jmp le0c7
		jsr le55e
le64a:	jsr le228
		inc $ca
		jsr le0cd
		ldy $de
		jsr le4b4
		bcs le64a
le659:	jmp le580
		jsr le55e
le65f:	jsr le216
		cpy $de
		bne le66b
		jsr le4b4
		bcc le659
le66b:	jsr le540
		bcc le65f
		jsr le55e
		txa
		pha
		jsr le3ea
		pla
		sta $da
		jmp le659
		jsr le55e
		jsr le4b4
		bcs le689
		sec
		ror $cf
le689:	lda $dc
		sta $ca
		jsr le3c0
		jsr le4c5
		jmp le659
le696:	lda #$00
		sta $d3
		sta $0383
		sta $d2
		rts
		clc
		bit $38
		lda #$00
		ror
		sta $0387
		rts
		clc
		bcc le6ae
		sec
le6ae:	lda #$00
		ror
		sta $038e
		rts
le6b5:	dey
		bmi le6bb
		jmp le772
le6bb:	ldy #$00
le6bd:	iny
		sty $d9
		dey
		lda $0393,y
		beq le731
		sta $038d
		jsr le8f5
		sta $c2
		stx $c3
		ldx #$03
le6d2:	lda le75a,x
		jsr le757
		dex
		bpl le6d2
		ldx #$2f
		lda $d9
		sec
le6e0:	inx
		sbc #$0a
		bcs le6e0
		adc #$3a
		cpx #$30
		beq le6f1
		pha
		txa
		jsr le757
		pla
le6f1:	jsr le757
		ldy #$00
		lda #$2c
le6f8:	jsr le757
		ldx #$07
le6fd:	jsr le27e
		lda ($c2),y
		jsr le28d
		cmp #$0d
		beq le739
		cmp #$8d
		beq le739
		cmp #$22
		beq le74c
		cpx #$09
		beq le71c
		pha
		lda #$22
		jsr le757
		pla
le71c:	jsr le757
		ldx #$09
		iny
		cpy $038d
		bne le6fd
		lda #$22
		jsr le757
le72c:	lda #$0d
		jsr le757
le731:	ldy $d9
		cpy #$14
		bne le6bd
		clc
		rts
le739:	lda le75e,x
		jsr le757
		dex
		bpl le739
le742:	iny
		cpy $038d
		beq le72c
		lda #$2b
		bne le6f8
le74c:	lda le768,x
		jsr le757
		dex
		bpl le74c
		bmi le742
le757:	jmp ($0363)
le75a:	jsr $4559
		!byte $4b
le75e:	and #$33
		and ($28),y
		bit $52
		pha
		!byte $43
		!byte $2b
		!byte $22
le768:	and #$34
		!byte $33
		plp
		bit $52
		pha
		!byte $43
		!byte $2b
		!byte $22
le772:	pha
		tax
		sty $d9
		lda $00,x
		sec
		sbc $0393,y
		sta $da
		iny
		jsr le8f5
		sta $c4
		stx $c5
		ldy #$14
		jsr le8f5
		sta $c6
		stx $c7
		ldy $da
		bmi le7a8
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
		bcc le7a8
		pla
		rts
le7a8:	jsr le27e
le7ab:	lda $c6
		clc
		sbc $c4
		lda $c7
		sbc $c5
		bcc le7de
		ldy #$00
		lda $da
		bmi le7cc
		lda $c6
		bne le7c2
		dec $c7
le7c2:	dec $c6
		lda ($c6),y
		ldy $da
		sta ($c6),y
		bpl le7ab
le7cc:	lda ($c4),y
		ldy $da
		dec $c5
		sta ($c4),y
		inc $c5
		inc $c4
		bne le7ab
		inc $c5
		bne le7ab
le7de:	ldy $d9
		jsr le8f5
		sta $c4
		stx $c5
		ldy $d9
		pla
		pha
		tax
		lda $00,x
		sta $0393,y
		tay
		lda $01,x
		sta $c6
		lda $02,x
		sta $c7
le7fa:	dey
		bmi le80e
		lda $03,x
		sta $01
		lda ($c6),y
		jsr le28d
		jsr le27e
		sta ($c4),y
		jmp le7fa
le80e:	jsr le28d
		clc
		pla
		rts
le814:	pla
		tay
		pla
		tax
		pla
		rti
le81a:	ldy #$00
		sty $df01
		sty $df00
		jsr le8ca
		and #$3f
		eor #$3f
		bne le82e
		jmp le89f
le82e:	lda #$ff
		sta $df00
		asl
		sta $df01
		jsr le8ca
		pha
		ora #$30
		bne le842
le83f:	jsr le8ca
le842:	ldx #$05
le844:	lsr
		bcc le857
		iny
		dex
		bpl le844
		sec
		rol $df01
		rol $df00
		bcs le83f
		pla
		bcc le89f
le857:	ldx le9d0,y
		pla
		asl
		asl
		asl
		bcc le86e
		bmi le871
		ldx lea30,y
		lda $cc
		beq le871
		ldx lea90,y
		bne le871
le86e:	ldx leaf0,y
le871:	cpx #$ff
		beq le8a1
		cpx #$e0
		bcc le882
		tya
		pha
		jsr le8d3
		pla
		tay
		bcs le8a1
le882:	txa
		cpy $cd
		beq le8ae
		ldx #$13
		stx $d8
		ldx $d1
		cpx #$09
		beq le89f
		cpy #$59
		bne le8be
		cpx #$08
		beq le89f
		sta $03b1,x
		inx
		bne le8be
le89f:	ldy #$ff
le8a1:	sty $cd
le8a3:	ldx #$7f
		stx $df00
		ldx #$ff
		stx $df01
		rts
le8ae:	dec $d8
		bpl le8a3
		inc $d8
		dec $d7
		bpl le8a3
		inc $d7
		ldx $d1
		bne le8a3
le8be:	sta $03b1,x
		inx
		stx $d1
		ldx #$03
		stx $d7
		bne le8a1
le8ca:	lda $df02
		cmp $df02
		bne le8ca
		rts
le8d3:	jmp ($0391)
		cpy $cd
		beq le8f3
		lda $d1
		ora $d6
		bne le8f3
		sta $038d
		txa
		and #$1f
		tay
		lda $0393,y
		sta $d6
		jsr le8f5
		sta $c2
		stx $c3
le8f3:	sec
		rts
le8f5:	lda $c0
		ldx $c1
le8f9:	clc
		dey
		bmi le905
		adc $0393,y
		bcc le8f9
		inx
		bne le8f9
le905:	rts
le906:	tya
		and #$07
		tax
		lda lec08,x
		sta $0388
		tya
		lsr
		lsr
		lsr
		tax
		lda $03a7,x
		bit $0388
		rts
le91c:	and #$7f
		sec
		sbc #$41
		cmp #$1a
		bcc le926
		rts
le926:	asl
		tax
		lda le932,x
		pha
		lda le931,x
		pha
		rts
le931:	cmp #$e9
		ror $e9
		dec $e9
		!byte $1f
		inc $92
		sbc #$89
		sbc #$81
		sbc #$83
		sbc #$0a
		inc $ef
		cpx $01
		sbc $9f
		inc $a1
		inc $ab
		sbc #$95
		inc $5b
		inc $46
		inc $9c
		sbc #$8f
		sbc #$64
		sbc #$86
		sbc #$6f
		inc $7d
		inc $24
		sbc #$ae
		sbc #$9f
		sbc #$18
		bit $38
		ldx $cb
		lda $ca
		bcc le97d
le96e:	sta $dd
		stx $df
		rts
le973:	lda #$18
		ldx #$4f
		jsr le96e
		lda #$00
		tax
le97d:	sta $dc
		stx $de
		rts
		lda #$00
		sta $d5
		rts
		lda #$0b
		bit $60a9
		ora $d4
		bne le997
		lda #$f0
		bit $0fa9
		and $d4
le997:	sta $d4
		ldx #$0a
		bne le9c0
		lda #$20
		bit $10a9
		ldx #$0e
		stx $d800
		ora $d801
		bne le9b9
		lda #$df
		bit lefa9
		ldx #$0e
		stx $d800
		and $d801
le9b9:	sta $d801
		and #$30
		ldx #$0c
le9c0:	stx $d800
		sta $d801
		rts
		lda #$00
		bit lffa9
		sta $0386
		rts
le9d0:	cpx #$1b
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
lea0e:	!byte $5f
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
		bmi lea2e
		!byte $2f
		and $0d2b
		!byte $ff
lea30:	nop
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
		beq lea7c
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
		bne leac6
		!byte $22
		ora ($2b),y
lea6e:	!byte $5c
		eor $de8d,x
		sta ($9d),y
		ora $8294,x
		!byte $ff
		!byte $93
		!byte $3f
		!byte $37
		!byte $34
lea7c:	and ($30),y
		!byte $92
		sty $38
		and $32,x
		rol $2a0e
		and $3336,y
		bmi lea0e
		!byte $2f
		and $8d2b
		!byte $ff
lea90:	nop
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
		beq leadc
		cmp $ca,x
		cmp lf1a0
		rol
		cmp #$cb
		!byte $3c
		rol $28f2,x
		!byte $cf
		dec $3a,x
		!byte $3f
leac6:	!byte $f3
		and #$2d
		bne leb26
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
leadc:	and ($30),y
		!byte $92
		!byte $04
		sec
		and $32,x
		rol $2a0e
		and $3336,y
		bmi lea6e
leaeb:	!byte $2f
		and $8d2b
		!byte $ff
leaf0:	!byte $ff
		!byte $ff
leaf2:	!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		!byte $ff
		lda ($11,x)
		ora ($1a,x)
		!byte $ff
leafc:	!byte $ff
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
leb0c:	!byte $07
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
leb26:	!byte $ff
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
		bcs leaeb
		!byte $ff
		clv
leb40:	lda $b2,x
		ldx lffbd
		lda $b3b6,y
		!byte $db
		!byte $ff
		!byte $ff
		!byte $af
		tax
		!byte $ab
		!byte $ff
leb4f:	!byte $ff
leb50:	!byte $44
		cpy $2a22
		ora $5552
		lsr $000d
		bvc leafc
		beq leb9e
		bcc leb40
		bmi leae2
		bne leb84
		bvs leb26
		bpl lebc8
		bcs leb6a
leb6a:	bvc leb0c
		beq lebae
		bcc leb50
		bmi leaf2
leb72:	bne leb44
		bne leb46
		cmp ($d1),y
		cmp ($d2),y
		!byte $d2
		!byte $d2
		!byte $d3
		!byte $d3
		!byte $d3
		!byte $d4
		!byte $d4
		!byte $d4
		cmp $d5,x
leb84:	cmp $d5,x
		dec $d6,x
		dec $d7,x
		!byte $d7
leb8b:	asl
leb8c:	!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		!byte $d4
		sbc $0a
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		!byte $87
		cpx $0a
		!byte $e3
		!byte $53
leb9e:	!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		sta $48e3
		!byte $e2
		!byte $67
		sbc #$0a
		!byte $e3
		ora $3de3
		!byte $e3
		!byte $43
		!byte $e3
		ror $e5
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		asl
		!byte $e3
		rol
		!byte $e3
		asl
lebc8:	!byte $e3
		asl
lebca:	!byte $e3
		ora $04
		!byte $04
		!byte $04
		!byte $04
		ora $04
		ora #$07
lebd4:	ora $50
		!byte $52
		eor #$4e
		!byte $54
		jmp $5349
		!byte $54
		jmp $414f
		!byte $44
		!byte $53
		eor ($56,x)
		eor $4f
		bvc lec2e
		lsr $4c43
		!byte $4f
		!byte $53
		eor $43
		!byte $4f
		bvc lec4c
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
lec08:	!byte $80
		rti
		jsr $0810
		!byte $04
		!byte $02
		ora ($6c,x)
		bvc lec63
		!byte $0f
		ora $1903,y
		ora $0d00,y
		rts
		ora $0000
		brk
		brk
		brk
		brk
		ror $6050,x
		asl
		!byte $1f
		asl $19
		!byte $1c
		brk
		!byte $07
		brk
		!byte $07
lec2e:	brk
		brk
		brk
		brk
		brk
		brk
		!byte $7f
		bvc lec97
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
		brk
		tax
		tax
		tax
		tax
		tax
lec4c:	tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
lec63:	tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
lec97:	tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
ledfd:	tax
		tax
		tax
lee00:	cld
		jsr lffcc
lee04:	jsr lffcf
		jmp lee04
lee0a:	ora $2f49
		!byte $4f
		jsr $5245
		!byte $52
		!byte $4f
		!byte $52
		jsr $0da3
		!byte $53
lee18:	eor $41
		!byte $52
		!byte $43
		pha
		eor #$4e
		!byte $47
		ldy #$46
		!byte $4f
		!byte $52
		ldy #$0d
		bvc lee7a
		eor $53
		!byte $53
		jsr $4c50
		eor ($59,x)
		jsr $4e4f
		jsr $4154
		bvc ledfd
		bvc lee8c
		eor $53
		!byte $53
		jsr $4552
		!byte $43
		!byte $4f
		!byte $52
		!byte $44
		jsr $2026
		bvc lee95
		eor ($59,x)
		jsr $4e4f
		jsr $4154
		bvc lee18
		ora $4f4c
		eor ($44,x)
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
		sta $2d2c
lee7a:	!byte $03
		bpl lee8a
lee7d:	lda lee0a,y
		php
		and #$7f
		jsr lffd2
		iny
		plp
		bpl lee7d
lee8a:	clc
		rts
lee8c:	ora #$40
		bne lee92
lee90:	ora #$20
lee92:	pha
		lda #$3b
lee95:	sta $de03
		lda #$ff
		sta $dc00
		sta $dc02
		lda #$fe
		sta $de00
		lda $aa
		bpl leec4
		lda $de00
		and #$df
		sta $de00
		lda $ab
		jsr lef16
		lda $aa
		and #$7f
		sta $aa
		lda $de00
		ora #$20
		sta $de00
leec4:	lda $de00
		and #$f7
		sta $de00
		pla
		jmp lef16
leed0:	jsr lef16
leed3:	lda $de00
		ora #$08
		sta $de00
		rts
leedc:	jsr lef16
leedf:	lda #$3d
		and $de00
		sta $de00
		lda #$c3
		sta $de03
		lda #$00
		sta $dc02
		beq leed3
leef3:	pha
		lda $aa
		bpl leeff
		lda $ab
		jsr lef16
		lda $aa
leeff:	ora #$80
		sta $aa
		pla
		sta $ab
		rts
lef07:	lda #$5f
		bne lef0d
lef0b:	lda #$3f
lef0d:	jsr lee92
		jsr leedf
		jmp leed3
lef16:	eor #$ff
		sta $dc00
		lda $de00
		ora #$12
		sta $de00
		bit $de00
		bvc lef31
		bpl lef31
		lda #$80
		jsr lfba8
		bne lef5c
lef31:	lda $de00
		bpl lef31
		and #$ef
		sta $de00
lef3b:	jsr lefc2
lef3e:	bit $de00
		bvs lef54
		lda $dc0d
		and #$02
		beq lef3e
		lda $032a
		bmi lef3b
		lda #$01
		jsr lfba8
lef54:	lda $de00
		ora #$10
		sta $de00
lef5c:	lda #$ff
		sta $dc00
		rts
lef62:	lda $de00
		and #$bd
		ora #$81
		sta $de00
lef6c:	jsr lefc2
lef6f:	lda $de00
		and #$10
		beq lef92
		lda $dc0d
		and #$02
		beq lef6f
		lda $032a
		bmi lef6c
		lda #$02
		jsr lfba8
		lda $de00
		and #$3d
		sta $de00
		lda #$0d
		rts
lef92:	lda $de00
		and #$7f
		sta $de00
		and #$20
		bne lefa3
		lda #$40
		jsr lfba8
lefa3:	lda $dc00
		eor #$ff
		pha
lefa9:	lda $de00
		ora #$40
		sta $de00
lefb1:	lda $de00
		and #$10
		beq lefb1
		lda $de00
		and #$bf
		sta $de00
		pla
		rts
lefc2:	lda #$ff
		sta $dc07
		lda #$19
		sta $dc0f
		lda $dc0d
		rts
lefd0:	jmp lf70f
lefd3:	jsr lf080
		ldy #$00
lefd8:	cpy $9d
		beq lefe7
		jsr lf879
		sta $0375,y
		iny
		cpy #$04
		bne lefd8
lefe7:	lda $0375
		sta $dd03
		lda $0376
		and #$f2
		ora #$02
		sta $dd02
		clc
		lda $a0
		and #$02
		beq lf013
		lda $037c
		sta $037b
		lda $a8
		and #$f0
		beq lf013
		jsr lf04e
		sta $a8
		stx $a6
		sty $a7
lf013:	bcc lf018
		jmp lf711
lf018:	rts
lf019:	cmp #$41
		bcc lf02d
		cmp #$5b
		bcs lf023
		ora #$20
lf023:	cmp #$c1
		bcc lf02d
		cmp #$db
		bcs lf02d
		and #$7f
lf02d:	rts
lf02e:	cmp #$41
		bcc lf042
		cmp #$5b
		bcs lf038
		ora #$80
lf038:	cmp #$61
		bcc lf042
		cmp #$7b
		bcs lf042
		and #$df
lf042:	rts
lf043:	lda $dd02
		ora #$09
		and #$fb
		sta $dd02
		rts
lf04e:	ldx #$00
		ldy #$01
lf052:	txa
		sec
		eor #$ff
		adc $0321
		tax
		tya
		eor #$ff
		adc $0322
		tay
		lda $0323
		bcs lf06c
		lda #$ff
lf068:	ora #$40
		sec
		rts
lf06c:	cpy $0328
		bcc lf068
		bne lf078
		cpx $0327
		bcc lf068
lf078:	stx $0321
		sty $0322
		clc
		rts
lf080:	php
		sei
		lda $dd01
		and #$60
		sta $0379
		sta $037a
		plp
		rts
		lda $a1
		bne lf09f
		lda $d1
		ora $d6
		beq lf0ec
		sei
		jsr le007
		clc
		rts
lf09f:	cmp #$02
		beq lf0a6
		jmp lffcf
lf0a6:	sty $0331
		stx $0332
		ldy $037b
		cpy $037c
		bne lf0ca
		lda $dd02
		and #$fd
		ora #$01
		sta $dd02
		lda $0379
		ora #$10
		sta $0379
		lda #$00
		beq lf0e6
lf0ca:	lda $0379
		and #$ef
		sta $0379
		ldx $01
		lda $a8
		sta $01
		lda ($a6),y
		stx $01
		inc $037b
		bit $a0
		bpl lf0e6
		jsr lf02e
lf0e6:	ldy $0331
		ldx $0332
lf0ec:	clc
		rts
		lda $a1
		bne lf0fd
		lda $cb
		sta $ce
		lda $ca
		sta $cf
		jmp lf108
lf0fd:	cmp #$03
		bne lf10d
		sta $d0
		lda $df
		sta $038e
lf108:	jsr le00a
		clc
		rts
lf10d:	bcs lf14a
		cmp #$02
		beq lf157
		stx $0331
		jsr lf134
		bcs lf133
		pha
		jsr lf134
		bcs lf130
		bne lf128
		lda #$40
		jsr lfba8
lf128:	dec $032e
		ldx $0331
		pla
		rts
lf130:	tax
		pla
		txa
lf133:	rts
lf134:	jsr $bc00
		bne lf145
		jsr $bc38
		bcs lf151
		lda #$00
		sta $032e
		beq lf134
lf145:	jsr lf85e
		clc
		rts
lf14a:	lda $9c
		beq lf152
lf14e:	lda #$0d
lf150:	clc
lf151:	rts
lf152:	jsr lef62
		clc
		rts
lf157:	jsr lffe4
		bcs lf151
		cmp #$00
		bne lf150
		lda $0379
		and #$10
		beq lf150
		lda $0379
		and #$60
		bne lf14e
		jsr lffe1
		bne lf157
		sec
		rts
		pha
		lda $a2
		cmp #$03
		bne lf182
		pla
		jsr le00d
		clc
		rts
lf182:	bcc lf18a
		pla
		jsr leef3
		clc
		rts
lf18a:	cmp #$02
		beq lf1bb
		pla
lf18f:	sta $032f
		pha
		txa
		pha
		tya
		pha
		jsr $bc00
		bne lf1aa
		jsr $bc5d
		bcs lf1b1
		lda #$02
		jsr lf869
		iny
		sty $032e
lf1aa:	lda $032f
		jsr lf86c
		clc
lf1b1:	pla
		tay
		pla
		tax
lf1b5:	pla
		bcc lf1ba
		lda #$00
lf1ba:	rts
lf1bb:	stx $032f
		sty $0330
		lda $0379
		and #$60
		bne lf1ea
		pla
		bit $a0
		bpl lf1d0
		jsr lf019
lf1d0:	sta $dd00
		pha
lf1d4:	lda $0379
		and #$60
		bne lf1ea
		lda $dd01
		and #$10
		bne lf1ea
		jsr lffe1
		bne lf1d4
		sec
		bcs lf1b5
lf1ea:	pla
		ldx $032f
		ldy $0330
		clc
		rts
		jsr lf30c
		beq lf1fb
		jmp lf6fd
lf1fb:	jsr lf31e
		lda $9f
		beq lf233
		cmp #$03
		beq lf233
		bcs lf237
		cmp #$02
		bne lf22a
		lda $a0
		and #$02
		beq lf230
		and $dd02
		beq lf226
		eor #$ff
		and $dd02
		ora #$01
		pha
		jsr lf080
		pla
		sta $dd02
lf226:	lda #$02
		bne lf233
lf22a:	ldx $a0
		cpx #$60
		beq lf233
lf230:	jmp lf706
lf233:	sta $a1
		clc
		rts
lf237:	tax
		jsr lee8c
		lda $a0
		bpl lf245
		jsr leedf
		jmp lf248
lf245:	jsr leedc
lf248:	txa
		bit $9c
		bpl lf233
		jmp lf703
		jsr lf30c
		beq lf258
		jmp lf6fd
lf258:	jsr lf31e
		lda $9f
		bne lf262
lf25f:	jmp lf709
lf262:	cmp #$03
		beq lf281
		bcs lf285
		cmp #$02
		bne lf27b
		lda $a0
		lsr
		bcc lf25f
		jsr lf080
		jsr lf043
		lda #$02
		bne lf281
lf27b:	ldx $a0
		cpx #$60
		beq lf25f
lf281:	sta $a2
		clc
		rts
lf285:	tax
		jsr lee90
		lda $a0
		bpl lf292
		jsr leed3
		bne lf295
lf292:	jsr leed0
lf295:	txa
		bit $9c
		bpl lf281
		jmp lf703
		php
		jsr lf311
		beq lf2a6
		plp
		sec
		rts
lf2a6:	jsr lf31e
		plp
		txa
		pha
		bcc lf2e7
		lda $9f
		beq lf2e7
		cmp #$03
		beq lf2e7
		bcs lf2e4
		cmp #$02
		bne lf2c3
		lda #$00
		sta $dd02
		beq lf2e7
lf2c3:	lda $a0
		and #$0f
		beq lf2e7
		jsr lf7f7
		lda #$00
		jsr lf18f
		jsr $bc5d
		bcs lf308
		lda $a0
		cmp #$62
		bne lf2e7
		lda #$05
		jsr lf779
		jmp lf2e7
lf2e4:	jsr lf655
lf2e7:	pla
		tax
		dec $032c
		cpx $032c
		beq lf306
		ldy $032c
		lda $0300,y
		sta $0300,x
		lda $030a,y
		sta $030a,x
		lda $0314,y
		sta $0314,x
lf306:	clc
		rts
lf308:	tax
		pla
		txa
		rts
lf30c:	lda #$00
		sta $9c
		txa
lf311:	ldx $032c
lf314:	dex
		bmi lf344
		cmp $0300,x
		bne lf314
		clc
		rts
lf31e:	lda $0300,x
		sta $9e
		lda $030a,x
		sta $9f
		lda $0314,x
		sta $a0
		rts
lf32e:	tya
		ldx $032c
lf332:	dex
		bmi lf344
		cmp $0314,x
		bne lf332
		clc
lf33b:	jsr lf31e
		tay
		lda $9e
		ldx $9f
		rts
lf344:	sec
		rts
lf346:	tax
		jsr lf30c
		bcc lf33b
		rts
		ror $0331
		sta $0332
lf353:	ldx $032c
lf356:	dex
		bmi lf36e
		bit $0331
		bpl lf366
		lda $0332
		cmp $030a,x
		bne lf356
lf366:	lda $0300,x
		jsr lffc3
		bcc lf353
lf36e:	lda #$00
		sta $032c
		ldx #$03
		cpx $a2
		bcs lf37c
		jsr lef0b
lf37c:	cpx $a1
		bcs lf383
		jsr lef07
lf383:	ldx #$03
		stx $a2
		lda #$00
		sta $a1
		rts
		bcc lf391
		jmp lf450
lf391:	ldx $9e
		bne lf398
		jmp lf706
lf398:	jsr lf30c
		bne lf3a0
		jmp lf6fa
lf3a0:	ldx $032c
		cpx #$0a
		bcc lf3aa
		jmp lf6f7
lf3aa:	inc $032c
		lda $9e
		sta $0300,x
		lda $a0
		ora #$60
		sta $a0
		sta $0314,x
		lda $9f
		sta $030a,x
		beq lf41b
		cmp #$03
		beq lf41b
		bcc lf3cd
		jsr lf41d
		bcc lf41b
lf3cd:	cmp #$02
		bne lf3d4
		jmp lefd3
lf3d4:	jsr lf7f7
		bcs lf41c
		lda $a0
		and #$0f
		bne lf3fe
		jsr $bc0c
		bcs lf41c
		jsr lf5b1
		lda $9d
		beq lf3f5
		jsr lf828
		bcc lf40a
		beq lf41c
lf3f2:	jmp lf700
lf3f5:	jsr lf73d
		beq lf41c
		bcc lf40a
		bcs lf3f2
lf3fe:	jsr $bc2f
		bcs lf41c
		lda #$04
		jsr lf779
		bcs lf41c
lf40a:	lda #$bf
		ldy $a0
		cpy #$60
		beq lf418
		lda #$02
		jsr lf869
		tya
lf418:	sta $032e
lf41b:	clc
lf41c:	rts
lf41d:	lda $a0
		bmi lf44e
		ldy $9d
		beq lf44e
		lda $9f
		jsr lee90
		lda $a0
		ora #$f0
lf42e:	jsr leed0
		lda $9c
		bpl lf43a
		pla
		pla
		jmp lf703
lf43a:	lda $9d
		beq lf44b
		ldy #$00
lf440:	jsr lf879
		jsr leef3
		iny
		cpy $9d
		bne lf440
lf44b:	jsr lef0b
lf44e:	clc
		rts
lf450:	lda $9f
		jsr lee90
		lda #$6f
		sta $a0
		jmp lf42e
		stx $0347
		sty $0348
		sta $032b
		sta $0349
		lda #$00
		sta $9c
		lda $9f
		bne lf473
lf470:	jmp lf70f
lf473:	cmp #$03
		beq lf470
		bcs lf47c
		jmp lf526
lf47c:	lda #$60
		sta $a0
		ldy $9d
		bne lf487
		jmp lf70c
lf487:	jsr lf5b1
		jsr lf41d
		lda $9f
		jsr lee8c
		lda $a0
		jsr leedc
		jsr lef62
		sta $96
		sta $99
		lda $9c
		lsr
		lsr
		bcc lf4a7
		jmp lf700
lf4a7:	jsr lef62
		sta $97
		sta $9a
		jsr lf5d6
		lda $0349
		sta $98
		sta $9b
		lda $0347
		and $0348
		cmp #$ff
		beq lf4d0
		lda $0347
		sta $96
		sta $99
		lda $0348
		sta $97
		sta $9a
lf4d0:	lda #$fd
		and $9c
		sta $9c
		jsr lffe1
		bne lf4de
		jmp lf649
lf4de:	jsr lef62
		tax
		lda $9c
		lsr
		lsr
		bcs lf4d0
		txa
		ldx $01
		ldy $98
		sty $01
		ldy #$00
		bit $032b
		bpl lf504
		sta $93
		lda ($96),y
		cmp $93
		beq lf506
		lda #$10
		jsr lfba8
		lda $9691
lf506:	stx $01
		inc $96
		bne lf516
		inc $97
		bne lf516
		inc $98
		lda #$02
		sta $96
lf516:	bit $9c
		bvc lf4d0
		jsr lef07
		jsr lf655
		jmp lf5a9
lf523:	jmp lf700
lf526:	cmp #$02
		bne lf52d
		jmp lefd0
lf52d:	jsr lf7f7
		bcs lf537
		jsr $bc0c
		bcc lf538
lf537:	rts
lf538:	jsr lf5b1
lf53b:	lda $9d
		beq lf548
		jsr lf828
		bcc lf551
		beq lf5b0
		bcs lf523
lf548:	jsr lf73d
		bcc lf551
		beq lf5b0
		bcs lf523
lf551:	cpx #$01
		bne lf53b
		lda $9c
		and #$10
		bne lf53b
		ldy #$01
		jsr lf85e
		sta $99
		jsr lf85d
		sta $9a
		jsr lf85d
		sta $96
		jsr lf85d
		sta $97
		lda $0349
		sta $98
		sta $9b
		lda $0347
		and $0348
		cmp #$ff
		beq lf5a2
		sec
		lda $96
		sbc $99
		sta $96
		lda $97
		sbc $9a
		sta $97
		clc
		lda $0347
		sta $99
		adc $96
		sta $96
		lda $0348
		sta $9a
		adc $97
		sta $97
lf5a2:	jsr lf5d6
		jsr $bc42
		bit $18
		lda $98
		ldx $96
		ldy $97
lf5b0:	rts
lf5b1:	bit $032d
		bpl lf5d5
		ldy #$0c
		jsr lee7d
		lda $9d
		beq lf5d5
		ldy #$17
		jsr lee7d
lf5c4:	ldy $9d
		beq lf5d5
		ldy #$00
lf5ca:	jsr lf879
		jsr lffd2
		iny
		cpy $9d
		bne lf5ca
lf5d5:	rts
lf5d6:	ldy #$49
		lda $032b
		bpl lf5df
		ldy #$59
lf5df:	jmp lee78
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
		bne lf603
lf600:	jmp lf70f
lf603:	cmp #$03
		beq lf600
		bcc lf66c
		lda #$61
		sta $a0
		ldy $9d
		bne lf614
		jmp lf70c
lf614:	jsr lf41d
		jsr lf697
		lda $9f
		jsr lee90
		lda $a0
		jsr leed0
		ldx $01
		jsr lf9ba
		lda $93
		jsr leef3
		lda $94
		jsr leef3
		ldy #$00
lf635:	jsr lf9c9
		bcs lf650
		lda ($93),y
		jsr leef3
		jsr lf9d7
		jsr lffe1
		bne lf635
		stx $01
lf649:	jsr lf655
		lda #$00
		sec
		rts
lf650:	stx $01
		jsr lef0b
lf655:	bit $a0
		bmi lf66a
		lda $9f
		jsr lee90
		lda $a0
		and #$ef
		ora #$e0
		jsr leed0
		jsr lef0b
lf66a:	clc
lf66b:	rts
lf66c:	cmp #$02
		bne lf673
		jmp lefd0
lf673:	jsr lf7f7
		bcs lf66b
		jsr $bc2f
		bcs lf66b
		jsr lf697
		lda #$01
		jsr lf779
		bcs lf66b
		jsr $bc60
		bcs lf66b
		lda $a0
		and #$02
		beq lf66a
		lda #$05
		jmp lf779
lf697:	lda $032d
		bpl lf66b
		ldy #$51
		jsr lee7d
		jmp lf5c4
lf6a4:	lda $dc08
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
		bne lf6a4
		lda $93
		rts
lf6cc:	pha
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
lf6f7:	lda #$01
		bit $02a9
		bit $03a9
		bit $04a9
		bit $05a9
		bit $06a9
		bit $07a9
		bit $08a9
		bit $09a9
lf711:	pha
		jsr lffcc
		ldy #$00
		bit $032d
		bvc lf726
		jsr lee7d
		pla
		pha
		ora #$30
		jsr lffd2
lf726:	pla
		sec
		rts
		lda $a9
		and #$01
		bne lf736
		php
		jsr lffcc
		sta $d1
		plp
lf736:	rts
lf737:	lda $df02
		sta $a9
		rts
lf73d:	lda $032b
		pha
		jsr $bc38
		tay
		pla
		sta $032b
		tya
		bcs lf778
		ldy #$00
		jsr lf85e
		cmp #$05
		beq lf778
		cmp #$01
		beq lf75d
		cmp #$04
		bne lf73d
lf75d:	pha
		bit $032d
		bpl lf775
		ldy #$63
		jsr lee7d
		ldy #$05
lf76a:	jsr lf85e
		jsr lffd2
		iny
		cpy #$15
		bne lf76a
lf775:	clc
		pla
		tax
lf778:	rts
lf779:	sta $032f
		jsr lf7f7
		bcs lf7f6
		lda $9b
		pha
		lda $9a
		pha
		lda $99
		pha
		lda $98
		pha
		lda $97
		pha
		lda $96
		pha
		ldy #$bf
		lda #$20
lf797:	jsr lf86c
		dey
		bne lf797
		lda $032f
		jsr lf86c
		lda $99
		jsr lf86b
		lda $9a
		jsr lf86b
		lda $96
		jsr lf86b
		lda $97
		jsr lf86b
		iny
		sty $0330
		ldy #$00
		sty $032f
lf7c0:	ldy $032f
		cpy $9d
		beq lf7d8
		jsr lf879
		ldy $0330
		jsr lf86c
		inc $032f
		inc $0330
		bne lf7c0
lf7d8:	jsr lf811
		lda #$69
		sta $b7
		jsr $bc64
		tay
		pla
		sta $96
		pla
		sta $97
		pla
		sta $98
		pla
		sta $99
		pla
		sta $9a
		pla
		sta $9b
		tya
lf7f6:	rts
lf7f7:	lda $a5
		cmp #$10
		bcc lf806
		jsr lf04e
		sta $a5
		stx $a3
		sty $a4
lf806:	lda $a5
		ldx $a3
		ldy $a4
		bcc lf7f6
		jmp lf711
lf811:	jsr lf7f7
		sta $9b
		sta $98
		txa
		sta $99
		clc
		adc #$c0
		sta $96
		tya
		sta $9a
		adc #$00
		sta $97
		rts
lf828:	jsr lf73d
		bcs lf85c
		ldy #$05
		sty $0330
		ldy #$00
		sty $032f
lf837:	cpy $9d
		beq lf855
		jsr lf879
		sta $b4
		ldy $0330
		jsr lf85e
		cmp $b4
		bne lf828
		inc $032f
		inc $0330
		ldy $032f
		bne lf837
lf855:	ldy #$00
		jsr lf85e
		tax
		clc
lf85c:	rts
lf85d:	iny
lf85e:	ldx $01
		lda $a5
		sta $01
		lda ($a3),y
		stx $01
		rts
lf869:	ldy #$ff
lf86b:	iny
lf86c:	ldx $01
		pha
		lda $a5
		sta $01
		pla
		sta ($a3),y
		stx $01
		rts
lf879:	ldx $01
		lda $92
		sta $01
		lda ($90),y
		stx $01
		rts
lf884:	lda $bb
		lsr
		lda #$f2
		ldx #$00
		bcc lf891
lf88d:	lda #$92
lf88f:	ldx #$01
lf891:	sta $dc06
		stx $dc07
		lda #$19
		sta $dc0f
		lda $dc0d
		lda $de07
		sta $de07
		lda $de01
		eor #$20
		sta $de01
		and #$20
		rts
		lda $b4
		bne lf8c6
		lda #$52
		ldx #$02
		jsr lf891
		bne lf8ec
		inc $b4
		lda $ba
		bpl lf8ec
		jmp lf93f
lf8c6:	lda $b5
		bne lf8d3
		jsr lf88d
		bne lf8ec
		inc $b5
		bne lf8ec
lf8d3:	jsr lf884
		bne lf8ec
		lda $b1
		eor #$01
		sta $b1
		beq lf8ef
		lda $bb
		eor #$01
		sta $bb
		and #$01
		eor $bc
		sta $bc
lf8ec:	jmp lfce3
lf8ef:	lsr $bb
		dec $b0
		lda $b0
		beq lf936
		bpl lf8ec
lf8f9:	jsr $bfba
		cli
		lda $b2
		beq lf913
		ldx #$00
		stx $bf
		dec $b2
		ldx $bd
		cpx #$02
		bne lf90f
		ora #$80
lf90f:	sta $bb
		bne lf8ec
lf913:	jsr lf9c9
		bcc lf927
		bne lf922
		inc $95
		lda $bf
		sta $bb
		bcs lf8ec
lf922:	sec
		ror $ba
		bmi lf8ec
lf927:	ldy #$00
		lda ($93),y
		sta $bb
		eor $bf
		sta $bf
		jsr lf9d7
		bne lf8ec
lf936:	lda $bc
		eor #$01
		sta $bb
lf93c:	jmp lfce3
lf93f:	dec $bd
		bne lf946
		jsr lf9b1
lf946:	lda #$50
		sta $b3
		sei
		lda #$58
		sta $0351
		lda #$f9
		sta $0352
		jmp lf93c
		lda #$22
		clc
		jsr lf88f
		bne lf93c
		dec $b3
		bne lf93c
		jsr $bfba
		dec $b7
		bpl lf93c
		lda #$b0
		sta $0351
		lda #$f8
		sta $0352
		cli
		inc $b7
		lda $bd
		beq lf9ac
		jsr lf9ba
		ldx #$09
		stx $b2
		stx $ba
		jmp lf8f9
lf988:	php
		sei
		jsr lf9b1
		lda #$13
		sta $dc0d
		lda #$1f
		sta $de05
		lda $034e
		beq lf9aa
		sta $0352
		lda $034f
		sta $01
		lda $034d
		sta $0351
lf9aa:	plp
		rts
lf9ac:	jsr lf988
		beq lf93c
lf9b1:	lda $de01
		ora #$40
		sta $de01
		rts
lf9ba:	lda $9a
		sta $94
		lda $99
		sta $93
		lda $9b
		sta $95
		sta $01
		rts
lf9c9:	sec
		lda $93
		sbc $96
		lda $94
		sbc $97
		lda $95
		sbc $98
		rts
lf9d7:	inc $93
		bne lf9e7
		inc $94
		bne lf9e7
		inc $95
		inc $01
		lda #$02
		sta $93
lf9e7:	rts
lf9e8:	!byte $c2
		cmp lfea2
		sei
		txs
		cld
		lda #$ff
		eor $03fa
		eor $03fb
		beq lfa4c
		lda #$06
		sta $96
		lda #$00
		sta $97
		sta $03f8
		ldx #$30
lfa06:	ldy #$03
		lda $97
		bmi lfa24
		clc
		adc #$10
		sta $97
		inx
		txa
		cmp ($96),y
		bne lfa06
		dey
lfa18:	lda ($96),y
		dey
		bmi lfa27
		cmp lf9e8,y
		beq lfa18
		bne lfa06
lfa24:	ldy #$e0
		bit $97a4
		sty $03f9
		tax
		bpl lfa4c
		jsr lfa53
		jsr lfe71
		jsr lfae9
		jsr lfbeb
		jsr le004
		lda #$a5
		sta $03fa
		lda #$5a
		sta $03fb
		cli
lfa49:	jmp ($03f8)
lfa4c:	lda #$03
		sta $03f8
		bne lfa49
lfa53:	lda #$f3
		sta $de06
		lda #$ff
		sta $de05
		lda #$5c
		sta $de01
		lda #$7d
		sta $de04
		lda #$3d
		sta $de00
		lda #$3f
		sta $de03
		lda #$ff
		sta $df00
		sta $de01
		sta $df03
		sta $df04
		lsr $df00
		lda #$00
		sta $df02
		sta $df05
		lda #$84
		sta $dc0d
		ldy #$00
		sty $dc02
		sty $dc03
		sty $dc0f
		sta $dc08
		sty $de02
lfaa0:	lda $de02
		ror
		bcc lfaa0
		sty $de02
		ldx #$00
		ldy #$00
lfaad:	inx
		bne lfaad
		iny
		lda $de02
		ror
		bcc lfaad
		cpy #$1b
		bcc lfabe
		lda #$88
		bit $08a9
		sta $dc0e
		lda $db0d
		lda #$90
		sta $db0d
		lda #$40
		sta $db01
		lda #$00
		sta $db02
		sta $db0f
		sta $db0e
		lda #$48
		sta $db03
		lda #$01
		ora $de01
		sta $de01
		rts
lfae9:	lda #$00
		tax
lfaec:	sta $0002,x
		sta $0200,x
		sta $02f8,x
		inx
		bne lfaec
		lda #$00
		sta $01
		sta $0326
		sta $0320
		lda #$02
		sta $0324
		sta $031e
lfb0a:	inc $01
		lda $01
		cmp #$0f
		beq lfb36
		ldy #$02
lfb14:	lda ($93),y
		tax
		lda #$55
		sta ($93),y
		lda ($93),y
		cmp #$55
		bne lfb36
		asl
		sta ($93),y
		lda ($93),y
		cmp #$aa
		bne lfb36
		txa
		sta ($93),y
		iny
		bne lfb14
		inc $94
		bne lfb14
		beq lfb0a
lfb36:	ldx $01
		dex
		txa
		ldx #$ff
		ldy #$ff
		sta $0323
		sty $0322
		stx $0321
		ldy #$fa
		clc
		jsr lfbc1
		dec $a8
		dec $a5
		rts
lfb52:	rti
		rol $fc
		brk
		inc lfb52
		sty $9df3
		!byte $f2
		!byte $f3
		sbc ($50),y
		!byte $f2
		!byte $73
		!byte $f3
		inc $75f0
		sbc ($29),y
		!byte $f7
		!byte $8f
		beq lfbb9
		!byte $f3
		!byte $5c
		!byte $f4
		!byte $e2
		sbc $00,x
		inc le01f
		!byte $1f
		cpx #$6c
		eor $03,x
lfb7a:	sta $9d
		lda $00,x
		sta $90
		lda $01,x
		sta $91
		lda $02,x
		sta $92
		rts
lfb89:	sta $9e
		stx $9f
		sty $a0
		rts
lfb90:	bcc lfbad
		lda $9f
		cmp #$02
		bne lfba6
		lda $0379
		pha
		lda #$00
		sta $0379
		pla
		rts
lfba3:	sta $032d
lfba6:	lda $9c
lfba8:	ora $9c
		sta $9c
		rts
lfbad:	pha
		lda $9f
		cmp #$02
		bne lfbb9
		pla
		sta $0379
		rts
lfbb9:	pla
		sta $9c
		rts
lfbbd:	sta $032a
		rts
lfbc1:	bcc lfbcc
		lda $0329
		ldx $0327
		ldy $0328
lfbcc:	stx $0327
		sty $0328
		sta $0329
		rts
lfbd6:	bcc lfbe1
		lda $0326
		ldx $0324
		ldy $0325
lfbe1:	stx $0324
		sty $0325
		sta $0326
		rts
lfbeb:	ldx #$53
		ldy #$fb
		lda #$0f
		clc
lfbf2:	stx $93
		sty $94
		ldx $01
		sta $01
		bcc lfc06
		ldy #$23
lfbfe:	lda $0351,y
		sta ($93),y
		dey
		bpl lfbfe
lfc06:	ldy #$23
lfc08:	lda ($93),y
		sta $0351,y
		dey
		bpl lfc08
		stx $01
		rts
lfc13:	pha
		txa
		pha
		tya
		pha
		tsx
		lda $0104,x
		and #$10
		bne lfc23
		jmp ($0351)
lfc23:	jmp ($0353)
		lda $01
		pha
		cld
		lda $de07
		bne lfc32
		jmp lfce0
lfc32:	cmp #$10
		beq lfc39
		jmp lfc97
lfc39:	lda $dd01
		tax
		and #$60
		tay
		eor $037a
		beq lfc52
		tya
		sta $037a
		ora $0379
		sta $0379
		jmp lfcdd
lfc52:	txa
		and #$08
		beq lfc7c
		ldy $037c
		iny
		cpy $037b
		bne lfc64
		lda #$08
		bne lfc76
lfc64:	sty $037c
		dey
		ldx $a8
		stx $01
		lda $dd00
		sta ($a6),y
		lda $dd01
		and #$07
lfc76:	ora $0379
		sta $0379
lfc7c:	lda $dd01
		and #$10
		beq lfc94
		lda $dd02
		and #$0c
		cmp #$04
		bne lfc94
		lda #$f3
		and $dd02
		sta $dd02
lfc94:	jmp lfcdd
lfc97:	cmp #$08
		bne lfca5
		lda $db0d
		cli
		jsr lfd86
		jmp lfcdd
lfca5:	cli
		cmp #$04
		bne lfcb6
		lda $dc0d
		ora $037d
		sta $037d
		jmp lfcdd
lfcb6:	cmp #$02
		bne lfcbd
		jmp lfcdd
lfcbd:	jsr le013
		lda $df02
		sta $a9
		lda $de01
		bpl lfcd3
		ldy #$00
		sty $0350
		ora #$40
		bne lfcda
lfcd3:	ldy $0350
		bne lfcdd
		and #$bf
lfcda:	sta $de01
lfcdd:	sta $de07
lfce0:	pla
		sta $01
lfce3:	pla
		tay
		pla
		tax
		pla
		rti
lfce9:	lda $080d
		and #$7f
		tay
		jsr lfe5f
		lda #$04
		and $db01
		bne lfce9
		lda #$08
		ora $db01
		sta $db01
		nop
		lda $db01
		tax
		and #$04
		beq lfd16
		txa
		eor #$08
		sta $db01
		txa
		nop
		nop
		nop
		bne lfce9
lfd16:	lda #$ff
		sta $db02
		lda $080d
		sta $db00
		jsr lfe46
		lda $db01
		and #$bf
		sta $db01
		ora #$40
		cli
		nop
		nop
		nop
		sta $db01
		jsr lfe2c
		lda #$00
		sta $db02
		jsr lfe34
		jsr lfe24
		ldy #$00
		beq lfd64
lfd47:	lda #$ff
		sta $db02
		lda $0812,y
		sta $db00
		jsr lfe3d
		jsr lfe2c
		lda #$00
		sta $db02
		jsr lfe34
		jsr lfe24
		iny
lfd64:	cpy $0810
		bne lfd47
		ldy #$00
		beq lfd80
lfd6d:	jsr lfe3d
		jsr lfe2c
		lda $db00
		sta $0812,y
		jsr lfe34
		jsr lfe24
		iny
lfd80:	cpy $0811
		bne lfd6d
		rts
lfd86:	lda #$00
		sta $db02
		lda $db00
		sta $080d
		and #$7f
		tay
		jsr lfe5f
		tya
		asl
		tay
		lda $0800,y
		sta $080e
		iny
		lda $0800,y
		sta $080f
		jsr lfe3d
		jsr lfe24
		ldy #$00
lfdaf:	cpy $0810
		beq lfdc9
		jsr lfe34
		jsr lfe2c
		lda $db00
		sta $0812,y
		jsr lfe3d
		jsr lfe24
		iny
		bne lfdaf
lfdc9:	bit $080d
		bmi lfe01
		lda #$fd
		pha
		lda #$d6
		pha
		jmp ($080e)
		jsr lfe34
		ldy #$00
		beq lfdfb
lfdde:	jsr lfe2c
		lda #$ff
		sta $db02
		lda $0812,y
		sta $db00
		jsr lfe3d
		jsr lfe24
		lda #$00
		sta $db02
		jsr lfe34
		iny
lfdfb:	cpy $0811
		bne lfdde
lfe00:	rts
lfe01:	lda #$fe
		pha
		lda #$0c
		pha
		jsr lfe4f
		jmp ($080e)
		jsr lfe46
		lda $0811
		sta $0810
		sta $080d
		lda #$00
		sta $0811
		jsr lfce9
		jmp lfe00
lfe24:	lda $db01
		and #$04
		bne lfe24
		rts
lfe2c:	lda $db01
		and #$04
		beq lfe2c
		rts
lfe34:	lda $db01
		and #$f7
		sta $db01
		rts
lfe3d:	lda #$08
		ora $db01
		sta $db01
		rts
lfe46:	lda $de01
		and #$ef
		sta $de01
		rts
lfe4f:	lda $db01
		and #$02
		beq lfe4f
		lda $de01
		ora #$10
		sta $de01
		rts
lfe5f:	lda $0900,y
		pha
		and #$0f
		sta $0810
		pla
		lsr
		lsr
		lsr
		lsr
		sta $0811
		rts
lfe71:	lda #$f0
		sta $c1
		jmp le004
		php
		pha
		lda #$03
		sta $01
		pla
		plp
		php
		sei
		pha
		txa
		pha
		tya
		pha
		jsr lfee7
		tay
		lda $00
		jsr lfef8
		lda #$d2
		ldx #$fe
		jsr lfef2
		tsx
		lda $0105,x
		sec
		sbc #$03
		pha
		lda $0106,x
lfea2:	sbc #$00
		tax
		pla
		jsr lfef2
		tya
lfeaa:	sec
		sbc #$04
		sta $01ff
		tay
		ldx #$04
lfeb3:	pla
		iny
		sta ($ac),y
		dex
		bne lfeb3
		ldy $01ff
		lda #$fb
		ldx #$fe
		jsr lfef2
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
		php
		pha
		txa
		pha
		tya
		pha
		tsx
		lda $0107,x
		sta $01
		jsr lfee7
		jmp lfeaa
lfee7:	ldy #$01
		sty $ad
		dey
		sty $ac
		dey
		lda ($ac),y
		rts
lfef2:	pha
		txa
		sta ($ac),y
		dey
		pla
lfef8:	sta ($ac),y
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
		rts
		nop
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
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		tax
		jmp le022
		jmp lfce9
		jmp lfa53
		jmp le004
lff81:	jmp lf052
		jmp lfbf2
		jmp lfbeb
		jmp lf32e
		jmp lf346
		jmp lfba3
		jmp leed0
		jmp leedc
		jmp lfbc1
		jmp lfbd6
		jmp le013
		jmp lfbbd
		jmp lef62
lffa8:	jmp leef3
		jmp lef07
		jmp lef0b
		jmp lee90
		jmp lee8c
		jmp lfb90
		jmp lfb89
lffbd:	jmp lfb7a
		jmp ($0357)
lffc3:	jmp ($0359)
		jmp ($035b)
		jmp ($035d)
lffcc:	jmp ($035f)
lffcf:	jmp ($0361)
lffd2:	jmp ($0363)
		jmp ($036b)
		jmp ($036d)
		jmp lf6cc
		jmp lf6a4
lffe1:	jmp ($0365)
lffe4:	jmp ($0367)
		jmp ($0369)
		jmp lf737
		jmp le010
		jmp le019
		jmp le01c
lfff6:	sta $00
		rts
		tax
lfffa:	!byte $77
		!byte $fb
		nop
		sbc lfc13,y
