instr inharmonic_additive_synthesis_oct
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
	
	iFrqMod1	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod2	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod3	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod4	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod5	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod6	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod7	=	get_different_distrib_value(0, 1, .5, 2, 1)
	iFrqMod8	=	get_different_distrib_value(0, 1, .5, 2, 1)
	
	iFromAzim = i(kFromAzim)
	iToAzim = i(kToAzim)
		
	krangeMin init .01
	krangeMax init .3
	kcpsmin init 3
	kcpsmax init 4

	kPartialAmp1  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp2  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp3  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp4  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp5  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp6  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp7  rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	kPartialAmp8 rspline krangeMin, krangeMax, kcpsmin, kcpsmax	
	
	kFrqOsc1     poscil    kPartialAmp1, iFrqMod1, giSine
	kFrqOsc2     poscil    kPartialAmp2, iFrqMod2, giSine
	kFrqOsc3     poscil    kPartialAmp3, iFrqMod3, giSine
	kFrqOsc4     poscil    kPartialAmp4, iFrqMod4, giSine
	kFrqOsc5     poscil    kPartialAmp5, iFrqMod5, giSine
	kFrqOsc6     poscil    kPartialAmp6, iFrqMod6, giSine
	kFrqOsc7     poscil    kPartialAmp7, iFrqMod7, giSine
	kFrqOsc8     poscil    kPartialAmp8, iFrqMod8, giSine
	
	;create 8 inharmonic partials
	aOsc1     poscil    ibaseamp+kPartialAmp1, ibasefrq+kFrqOsc1, giSine
	aOsc2     poscil    ibaseamp/2+kPartialAmp2, ibasefrq*1.02+kFrqOsc2, giSine
	aOsc3     poscil    ibaseamp/3+kPartialAmp3, ibasefrq*3.1+kFrqOsc3, giSine
	aOsc4     poscil    ibaseamp/4+kPartialAmp4, ibasefrq*3.7+kFrqOsc4, giSine
	aOsc5     poscil    ibaseamp/5+kPartialAmp5, ibasefrq*4.26+kFrqOsc5, giSine
	aOsc6     poscil    ibaseamp/6+kPartialAmp6, ibasefrq*6.31+kFrqOsc6, giSine
	aOsc7     poscil    ibaseamp/7+kPartialAmp7, ibasefrq*7.39+kFrqOsc7, giSine
	aOsc8     poscil    ibaseamp/8+kPartialAmp8, ibasefrq*7.41+kFrqOsc8, giSine
	kenv      linen     1, p3/4, p3, p3/4
	aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
	;outs aOut*kenv*iPan, aOut*kenv*(1-iPan)
	
	fprintks 	$DUMP_FILE_NAME, "iFromAzim = %f | iToAzim = %f\\n", iFromAzim, iToAzim
	kalpha line iFromAzim, p3, iToAzim
	kbeta = 0
        
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aOut*kenv, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	outo a1, a2, a3, a4, a5, a6, a7, a8
endin