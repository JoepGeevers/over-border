*=$c000                 ; 49152 


    ; set sprite location to 832
    lda #$0d
    sta $07f8   ; sprite 0
    sta $07f9   ; sprite 1
    sta $07fa   ; sprite 2

    ; set x
    lda #$99
    sta $d000    ; sprite 0
    lda #$18
    sta $d002    ; sprite 1
    lda #$48
    sta $d004    ; sprite 2

    ; set y
    lda #$99
    sta $d001    ; sprite 0
    lda #$08
    sta $d003    ; sprite 1
    sta $d005    ; sprite 2

    ; set color
    lda #$01
    sta $D027    ; sprite 0
    lda #$0e
    sta $D028    ; sprite 1
    sta $D029    ; sprite 2

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

   asl $d019 ; Acknowledge interrupt by clearing VICs interrupt flag

   jmp $ea31 ; Kernel routine including scanning the keyboard











