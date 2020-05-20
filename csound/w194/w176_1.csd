<CsoundSynthesizer>
<CsOptions>
;-o dac
;-F w176-1.mid -o w176_1.wav -W 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#include "..\include\math\stochastic\distribution3.inc.csd"
#include "..\include\math\stochastic\util.inc.csd"
#include "..\include\utils\table.v1.csd"

giSine  ftgen	0,0,4096,10,1

/*
instr 1 ; Fl.
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin 
*/
  
/*
instr 1 ; Fl.
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	event_i "i", "harmonic_additive_synthesis", 0, p3, iFrq, iVel
endin
*/

instr 1 ; Fl.
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity

	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	;ibasefrq  =         p4
	ibasefrq  =        	 (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	;ibaseamp  =         iAmp
	ibaseamp  =         iVel

	;iPan	=	p6
	iPan	=	.5
	
	;create 8 harmonic partials
	;aOsc1     poscil    ibaseamp, ibasefrq, giSine
	;aOsc2     poscil    ibaseamp/2, ibasefrq*2, giSine
	;aOsc3     poscil    ibaseamp/3, ibasefrq*3, giSine
	;aOsc4     poscil    ibaseamp/4, ibasefrq*4, giSine
	;aOsc5     poscil    ibaseamp/5, ibasefrq*5, giSine
	;aOsc6     poscil    ibaseamp/6, ibasefrq*6, giSine
	;aOsc7     poscil    ibaseamp/7, ibasefrq*7, giSine
	;aOsc8     poscil    ibaseamp/8, ibasefrq*8, giSine
	
	krangeMin init .1
	krangeMax init .3
	kcpsmin init .05
	kcpsmax init .5
	
	aOut = 0
	
	kCnt = 0
	until kCnt > 8 do
		kFrqMod = get_different_distrib_value(0, 1, .5, 2, 1)	
		kPartialAmp  = rspline(krangeMin, krangeMax, kcpsmin, kcpsmax)
		kFrqOsc   = poscil(kPartialAmp, kFrqMod, giSine)
		aOsc     =  poscil(ibaseamp/(kCnt+1)+kPartialAmp, ibasefrq*(kCnt+1)+kFrqOsc, giSine)
		aOut += aOsc
		kCnt += 1
	enduntil
	
	aOut /= 8
	
	;apply simple envelope
	;kenv expseg .01, p3/3, .5, p3/3, .3, p3/3, .01 ;not form MIDI!
	kenv linsegr 0, .1, 1 , 10, 1, .1, 0
	
	;add partials and write to output
	;aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
    outs      aOut*kenv*iPan, aOut*kenv*(1-iPan)
	;outs      aOut*iPan, aOut*(1-iPan)
endin

instr 2 ; Cor
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin

instr 3 ; Tuba
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin

instr 4 ; V-no
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin


;instr 5 
#include "..\include\sound\synthesis\harmonic_additive_synthesis_2ch.csd"


</CsInstruments>
<CsScore>
f 0 100
</CsScore>
</CsoundSynthesizer>