*=$c000                 ; 49152 


    ; set sprite location to 832
    lda #$0d
    sta $07f8   ; sprite 0
    sta $07f9   ; sprite 1
    sta $07fa   ; sprite 2
    sta $07fa   ; sprite 3
    sta $07fa   ; sprite 4
    sta $07fa   ; sprite 5
    sta $07fa   ; sprite 6
    sta $07fa   ; sprite 7

    ; set x
    lda #$99
    sta $d000    ; sprite 0
    lda #$18
    sta $d002    ; sprite 1
    lda #$48
    sta $d004    ; sprite 2
    lda #$78
    sta $d006    ; sprite 3
    lda #$a8
    sta $d008    ; sprite 4
    lda #$d8
    sta $d00a    ; sprite 5
    lda #$08
    sta $d00c    ; sprite 6
    lda #$38
    sta $d00e    ; sprite 7

    ; set most significant bit for last two sprites
    lda #$c0;
    sta $d010

    ; set y
    lda #$99
    sta $d001    ; sprite 0
    lda #$08
    sta $d003    ; sprite 1
    sta $d005    ; sprite 2
    sta $d007    ; sprite 3
    sta $d009    ; sprite 4
    sta $d00b    ; sprite 5
    sta $d00d    ; sprite 6
    sta $d00f    ; sprite 7

    ; set color
    lda #$01
    sta $D027    ; sprite 0
    lda #$0e
    sta $D028    ; sprite 1
    sta $D029    ; sprite 2
    sta $D02a    ; sprite 3
    sta $D02b    ; sprite 4
    sta $D02c    ; sprite 5
    sta $D02d    ; sprite 5
    sta $D02e    ; sprite 5

    ; double size
    lda #$ff
    sta $d017
    sta $d01d

    ; fill sprite data
    lda #$ff
    ldx #$3f
loop    
    DEX
    STA $0340,X
    bne loop    

    ; enable all sprites
    lda #$ff
    sta $d015

    sei         ; ignore interrupts

    ; disable all interrupts and clear pending interrupts
    lda #%0111111    
    sta $dc0d ; interrupt control register CIA #1
    sta $dd0d ; interrupt control register CIA#2

   lda $dc0d   ;clear any pending interrupts CIA#1 by reading
   lda $dd0d    ; clear any pending interrupts CIA#2 by reading

    ; enable raster interrupt
   lda #%00000001   ;turn on the raster interrupt
   sta $d01a  ; irq mask register

    ; setting the interrupt line
   ldy #$33   ;generate interrupt on first line on main screen area
   sty $d012  ; write: line to compare for raster interrupt
   lda #$1b  ;clear high order bit of the raster interrupt compare. very naive
   sta $d011

    ; set the interrupt vector
   lda #<25rows  ;set the correct address for the interrupt
   sta $0314
   lda #>25rows
   sta $0315

   cli      ; enable interrupts 
    rts

25rows

    ; set to 25 column mode
    lda $d011
    ora #%00001000
    sta $d011

    ; register interrupt for 24rows
   ldy #$f9     ; rasterline
   sty $d012
   lda #<24rows ; vector
   sta $0314
   lda #>24rows
   sta $0315

   asl $d019 ; Acknowledge interrupt by clearing VICs interrupt flag

   jmp $ea31 ; Kernel routine including scanning the keyboard

24rows

    ; set to 24 column mode
    lda $d011
    and #%11110111
    sta $d011

    ; register interrupt for 25rows
   ldy #$33     ; rasterline
   sty $d012
   lda #<25rows ; vector
   sta $0314
   lda #>25rows
   sta $0315

    dec $d001    ; sprite 0

   asl $d019 ; Acknowledge interrupt by clearing VICs interrupt flag

   jmp $ea31 ; Kernel routine including scanning the keyboard











