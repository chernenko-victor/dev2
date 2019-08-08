giLine    ftgen     0, 0, 2^10, 7, 0,  2^10,   1
giExp    ftgen     0, 0, 2^10, 5, 0.01,  2^10, .99

instr shepard_tone
	iPartialNum = 5
	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	ibasefrq  =         p4
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	;iAmp       random     0.1, .9
	iAmp       =		p5
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
	
	krangeMin init .01
	krangeMax init .3
	kcpsmin init 3
	kcpsmax init 4
	
	aOut = 0
	
	kBaseFrqSlide 	oscili 3000., .1, giLine
	kBaseFrqNew = 50 + kBaseFrqSlide
	
	;kBaseFrqSlide 	oscili 1., .1, giExp
	;kBaseFrqNew = 50 + 3000.*(1-1/kBaseFrqSlide)
	
	kCnt = 0
	until kCnt > iPartialNum do
		kFrqMod = get_different_distrib_value(0, 1, .5, 2, 1)	
		kPartialAmp  = rspline(krangeMin, krangeMax, kcpsmin, kcpsmax)
		kFrqOsc   = poscil(kPartialAmp, kFrqMod, giSine)
		;aOsc     =  poscil(ibaseamp/(kCnt+1)+kPartialAmp, ibasefrq*(kCnt+1)+kFrqOsc, giSine)
		;aOsc     =  poscil(ibaseamp/(kCnt+1)+kPartialAmp, kBaseFrqNew*(kCnt+1)+kFrqOsc, giSine)
		aOsc     =  poscil(ibaseamp/kPartialAmp, kBaseFrqNew*(kCnt+2), giSine)
		aOut += aOsc
		kCnt += 1
	enduntil
	
	aOut /= iPartialNum
	
	;apply simple envelope
	kenv      linen     1, p3/4, p3, p3/4
	;kenv expseg .01, p3/3, .5, p3/3, .3, p3/3, .01
	
	;add partials and write to output
	;aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
    outs      aOut*kenv*iPan, aOut*kenv*(1-iPan)
	;outs      aOut, aOut
	
	
	/*
	kalpha line iFromAzim, p3, iToAzim
	kbeta = 0
        
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aOut*kenv, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	outo a1, a2, a3, a4, a5, a6, a7, a8
	*/
endin