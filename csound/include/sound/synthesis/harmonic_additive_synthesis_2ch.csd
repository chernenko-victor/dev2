instr harmonic_additive_synthesis
	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	ibasefrq  =         p4
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	ibaseamp  =         iAmp

	iPan	=	p6
	
	/*
	;create 8 harmonic partials
	aOsc1     poscil    ibaseamp, ibasefrq, giSine
	aOsc2     poscil    ibaseamp/2, ibasefrq*2, giSine
	aOsc3     poscil    ibaseamp/3, ibasefrq*3, giSine
	aOsc4     poscil    ibaseamp/4, ibasefrq*4, giSine
	aOsc5     poscil    ibaseamp/5, ibasefrq*5, giSine
	aOsc6     poscil    ibaseamp/6, ibasefrq*6, giSine
	aOsc7     poscil    ibaseamp/7, ibasefrq*7, giSine
	aOsc8     poscil    ibaseamp/8, ibasefrq*8, giSine
	*/
	
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
	kenv      linen     1, p3/4, p3, p3/4
	;kenv expseg .01, p3/3, .5, p3/3, .3, p3/3, .01
	;add partials and write to output
	;aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
    	outs      aOut*kenv*iPan, aOut*kenv*(1-iPan)
	;outs      aOut, aOut
endin