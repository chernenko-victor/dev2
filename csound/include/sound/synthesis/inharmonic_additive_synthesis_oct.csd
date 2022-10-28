instr inharmonic_additive_synthesis_oct
	;iMixRatio = .01
	iMixRatio = 2
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

	krangeMin init .01
	krangeMax init .3
	kcpsmin init 3
	kcpsmax init 4
	
	kaPartialFrq[] init 8
	kaPartialFrq fillarray 	1, 1.02, 3.1, 3.7, 4.26, 6.31, 7.39, 7.41
	
	aOut = 0
		
	kCnt = 0
	until kCnt == lenarray(kaPartialFrq) do
		;fprintks 	$DUMP_FILE_NAME, "kCnt = %f\n", kCnt
		kFrqMod = get_different_distrib_value(0, 1, .5, 2, 1)	
		kPartialAmp  = rspline(krangeMin, krangeMax, kcpsmin, kcpsmax)
		kFrqOsc   = poscil(kPartialAmp, kFrqMod, giSine)
		aOsc     =  poscil(ibaseamp/(kCnt+1)+kPartialAmp, ibasefrq+kFrqOsc, giSine) ;*kaPartialFrq[kCnt]
		aOut += aOsc
		kCnt += 1
	enduntil
	aOut /= 8
	
	kEnvAmp      linen     1, p3/4, p3, p3/4
	
	;outs aOut*kenv*iPan, aOut*kenv*(1-iPan)
	
	;fprintks 	$DUMP_FILE_NAME, "iFromAzim = %f | iToAzim = %f\\n", iFromAzim, iToAzim
	kalpha line iFromAzim, p3, iToAzim
	kbeta = 0
        
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aOut*kEnvAmp, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	outo a1*iMixRatio, a2*iMixRatio, a3*iMixRatio, a4*iMixRatio, a5*iMixRatio, a6*iMixRatio, a7*iMixRatio, a8*iMixRatio
	;fout "liquid030922_2.wav", 18, a1*iMixRatio, a2*iMixRatio, a3*iMixRatio, a4*iMixRatio, a5*iMixRatio, a6*iMixRatio, a7*iMixRatio, a8*iMixRatio
	
	gaSend1 = gaSend1 + a1*iMixRatio
	gaSend2 = gaSend2 + a2*iMixRatio
	gaSend3 =  gaSend3 + a3*iMixRatio
	gaSend4 =  gaSend4 + a4*iMixRatio
	gaSend5 =  gaSend5 + a5*iMixRatio
	gaSend6 =  gaSend6 + a6*iMixRatio	
	gaSend7 =  gaSend7 + a7*iMixRatio
	gaSend8 =  gaSend8 + a8*iMixRatio
endin