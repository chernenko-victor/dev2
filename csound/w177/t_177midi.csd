<CsoundSynthesizer>
<CsOptions>
;-o dac
-o w177_4_1.wav -W 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

seed    0
gisine  ftgen	0,0,4096,10,1

instr 1, 2, 3, 4 ; Legni
	;iFrq = p4
	;iModAmp = p5
	;iModFrq = p6
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	aMod poscil iModAmp, iModFrq, gisine
	aCar poscil iVel, iFrq+aMod, gisine
	outs aCar, aCar
endin


instr 9, 10, 11, 12, 13 ; wgbow instrument -> Arci
	kamp     =        0.3
	;kfreq    =        p4
	;ipres1   =        p5
	;ipres2   =        p6
	ipres1   =        0.03
	ipres2   =        0.1
	; kpres (bow pressure) defined using a random spline
	kpres    rspline  ipres1, ipres2, 0.5, 2
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	krat     =        0.127236
	kvibf    =        4.5
	kvibamp  =        0
	iminfreq =        20
	; call the wgbow opcode
	;aSigL	 wgbow    kamp,iFrq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
	aSigL	 wgbow    iVel,iFrq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
	; modulating delay time
	kdel     rspline  0.01,0.1,0.1,0.5
	; bow pressure parameter delayed by a varying time in the right channel
	kpres    vdel_k   kpres,kdel,0.2,2
	aSigR	 wgbow	  iVel,iFrq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
			 outs     aSigL,aSigR
 endin


instr 5, 7 ; Cor, Tr-ni -> harmonic additive synthesis 
;receive general pitch and volume from the score

iKey         notnum                 ; read in midi note number
iVel         ampmidi            1 ; read in key velocity
iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))

;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude

ibasefrq  =         iFrq
ibaseamp  =         iVel ;convert dB to amplitude

;create 8 harmonic partials
aOsc1     poscil    ibaseamp, ibasefrq, gisine
aOsc2     poscil    ibaseamp/2, ibasefrq*2, gisine
aOsc3     poscil    ibaseamp/3, ibasefrq*3, gisine
aOsc4     poscil    ibaseamp/4, ibasefrq*4, gisine
aOsc5     poscil    ibaseamp/5, ibasefrq*5, gisine
aOsc6     poscil    ibaseamp/6, ibasefrq*6, gisine
aOsc7     poscil    ibaseamp/7, ibasefrq*7, gisine
aOsc8     poscil    ibaseamp/8, ibasefrq*8, gisine
;apply simple envelope

;kenv      linen     1, p3/4, p3, p3/4
kenv	init 1

;add partials and write to output
aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
          outs      aOut*kenv, aOut*kenv
endin

instr 6, 8 ; Tr-ba, Tuba -> inharmonic additive synthesis
iKey         notnum                 ; read in midi note number
iVel         ampmidi            1 ; read in key velocity
iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))

;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude

ibasefrq  =         iFrq
ibaseamp  =         iVel ;convert dB to amplitude
;create 8 inharmonic partials
aOsc1     poscil    ibaseamp, ibasefrq, gisine
aOsc2     poscil    ibaseamp/2, ibasefrq*1.02, gisine
aOsc3     poscil    ibaseamp/3, ibasefrq*1.1, gisine
aOsc4     poscil    ibaseamp/4, ibasefrq*1.23, gisine
aOsc5     poscil    ibaseamp/5, ibasefrq*1.26, gisine
aOsc6     poscil    ibaseamp/6, ibasefrq*1.31, gisine
aOsc7     poscil    ibaseamp/7, ibasefrq*1.39, gisine
aOsc8     poscil    ibaseamp/8, ibasefrq*1.41, gisine

kenv      linen     1, p3/4, p3, p3/4
kenv	init 1

aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
          outs aOut*kenv, aOut*kenv
    endin


</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>