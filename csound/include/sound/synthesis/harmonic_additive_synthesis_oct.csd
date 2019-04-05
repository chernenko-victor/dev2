instr harmonic_additive_synthesis_oct
	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	ibasefrq  =         p4
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	ibaseamp  =         iAmp

	iPan	=	p6
	
	kAzimtDistrType init 1
	kAzimMin	init 0
	kAzimMax	init 360
	kAzimDepth	init 1
	kAzimMinDelta init 45
	
	kFromAzim	=	IntRndDistrK(kAzimtDistrType, kAzimMin, kAzimMax, kAzimDepth)
	kToAzim	=	IntRndDistrK(kAzimtDistrType, kFromAzim+kAzimMinDelta, kAzimMax, kAzimDepth)
	
	iFromAzim = i(kFromAzim)
	iToAzim = i(kToAzim)
	
	;create 8 harmonic partials
	aOsc1     poscil    ibaseamp, ibasefrq, giSine
	aOsc2     poscil    ibaseamp/2, ibasefrq*2, giSine
	aOsc3     poscil    ibaseamp/3, ibasefrq*3, giSine
	aOsc4     poscil    ibaseamp/4, ibasefrq*4, giSine
	aOsc5     poscil    ibaseamp/5, ibasefrq*5, giSine
	aOsc6     poscil    ibaseamp/6, ibasefrq*6, giSine
	aOsc7     poscil    ibaseamp/7, ibasefrq*7, giSine
	aOsc8     poscil    ibaseamp/8, ibasefrq*8, giSine
	;apply simple envelope
	kenv      linen     1, p3/4, p3, p3/4
	;kenv expseg .01, p3/3, .5, p3/3, .3, p3/3, .01
	;add partials and write to output
	aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
    ;outs      aOut*kenv*iPan, aOut*kenv*(1-iPan)
	;outs      aOut, aOut
	
	
	kalpha line iFromAzim, p3, iToAzim
	kbeta = 0
        
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aOut*kenv, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	outo a1, a2, a3, a4, a5, a6, a7, a8
endin