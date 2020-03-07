*   = $2000 ; sys 8192


interrupt
    sei         ;turn interrupts off while we do this
    lda #$7f     ;keep some other random interrupts off
    sta $dc0d
    sta $dd0d

   lda $dc0d   ;clear any pending interrupts
   lda $dd0d

   lda #$01   ;turn on the raster interrupt
   sta $d01a

   ldy #$aa   ;generate interrupt on first line on main screen area
   sty $d012

   lda #$1b  ;Not sure what this does exactly?
   sta $d011

   lda #<irq  ;set the correct address for the interrupt
   sta $0314
   lda #>irq
   sta $0315

   cli      ;turn all interrupts back on

    rts

irq
   asl $d019 ; Acknowledge interrupt by clearing VICs interrupt flag
   inc $d020 ; Change border colour
   jmp $ea81 ; Kernel routine