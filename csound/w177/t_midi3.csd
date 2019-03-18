<CsoundSynthesizer>
<CsOptions>
;-o dac
-o w177_3.wav -W 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

seed    0
gisine  ftgen	0,0,4096,10,1

instr 1
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


instr 2 ; wgbow instrument
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



</CsInstruments>
<CsScore>

/*
;   		FM Amplitude	FM Frequency
i 1 0	2	440		10				20  ; 5 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	660		15				>  ; 5 Hz vibrato with 90 Hz modulation-width
i 1 ^+3	2	440		10				. ; 50 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	880		15				. ; 100 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	440		10				50 ; 220 Hz vibrato with 10 Hz modulation-width


; instr. 2
;  p4 = pitch (hz.)
;  p5 = minimum bow pressure
;  p6 = maximum bow pressure
; 7 notes played by the wgbow instrument
i 2  0 480  70 0.03 0.1
i 2  0 480  85 0.03 0.1
i 2  0 480 100 0.03 0.09
i 2  0 480 135 0.03 0.09
i 2  0 480 170 0.02 0.09
i 2  0 480 202 0.04 0.1
i 2  0 480 233 0.05 0.11
*/

;f0 3600
</CsScore>
</CsoundSynthesizer>