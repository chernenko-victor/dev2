gaSend init 0

 instr wgbow_instr
    ;iMixRatio = .01
    iMixRatio = 2
	kamp     init        0.3
	;kamp     =        p4
	kfreq    init        p4
	kpres    init        0.2
	;krat     rspline  0.006,0.988,0.1,0.4
	kvibf    init        4.5
	kvibamp  init        0
	iminfreq init        20
	
	
	iSeedType	=	0
	kTypeOfDistrib	init 	2
	kMin			init 	.006
	kMax			init 	.988
	kDistribDepth	init	5
	
	kEnvFrqAmpTypeOfDistrib	init	6
	kEnvFrqAmpMin			init	p4/98
	kEnvFrqAmpMax			init	(p4+10)/98
	kEnvFrqAmpDistribDepth	init	2

	kEnvFrqCpsTypeOfDistrib	init	7
	kEnvFrqCpsMin			init	.3
	kEnvFrqCpsMax			init	3
	kEnvFrqCpsDistribDepth	init	1
	
	
	kEnvFrqAmp	get_different_distrib_value_k 	iSeedType, kEnvFrqAmpTypeOfDistrib, kEnvFrqAmpMin, kEnvFrqAmpMax, kEnvFrqAmpDistribDepth
	kEnvFrqCps	get_different_distrib_value_k 	iSeedType, kEnvFrqCpsTypeOfDistrib, kEnvFrqCpsMin, kEnvFrqCpsMax, kEnvFrqCpsDistribDepth
	;kEnvFrq 	oscil 	kEnvFrqAmp, kEnvFrqCps
	kEnvFrq 	rspline  kEnvFrqAmp, kEnvFrqAmp+4, kEnvFrqCps, kEnvFrqCps+7
	
	
	kRatMin 	get_different_distrib_value_k 	iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth
	kRatMax 	get_different_distrib_value_k 	iSeedType, 7, kMin, kMax, kDistribDepth
	krat	linseg 		i(kRatMin), p3, i(kRatMax)
	
	
	kAzimtDistrType init 1
	kAzimMin	init 0
	kAzimMax	init 360
	kAzimDepth	init 1
	kAzimMinDelta init 45
	
	kFromAzim	=	IntRndDistrK(kAzimtDistrType, kAzimMin, kAzimMax, kAzimDepth)
	kToAzim	=	IntRndDistrK(kAzimtDistrType, kFromAzim+kAzimMinDelta, kAzimMax, kAzimDepth)
	
	iFromAzim = i(kFromAzim)
	iToAzim = i(kToAzim)
	
	;aSig	 wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
	aSig	 wgbow    kamp,kfreq+kEnvFrq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
	;aSig     butlp     aSig,2000
	;aSig     pareq    aSig,80,6,0.707
	;outs     aSig,aSig
	kalpha line iFromAzim, p3, iToAzim
	kbeta = 0
		
	kEnvAmp      linen     1, p3/4, p3, p3/4
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aSig*kEnvAmp, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	;outo a1, a2, a3, a4, a5, a6, a7, a8
	outo a1*iMixRatio, a2*iMixRatio, a3*iMixRatio, a4*iMixRatio, a5*iMixRatio, a6*iMixRatio, a7*iMixRatio, a8*iMixRatio
	;fout "liquid030922_5.wav", 18, a1*iMixRatio, a2*iMixRatio, a3*iMixRatio, a4*iMixRatio, a5*iMixRatio, a6*iMixRatio, a7*iMixRatio, a8*iMixRatio
	gaSend   =        gaSend + aSig/3
	
	gaSend1 = gaSend1 + a1*iMixRatio
	gaSend2 = gaSend2 + a2*iMixRatio
	gaSend3 =  gaSend3 + a3*iMixRatio
	gaSend4 =  gaSend4 + a4*iMixRatio
	gaSend5 =  gaSend5 + a5*iMixRatio
	gaSend6 =  gaSend6 + a6*iMixRatio	
	gaSend7 =  gaSend7 + a7*iMixRatio
	gaSend8 =  gaSend8 + a8*iMixRatio
	
 endin


instr wgbow_reverb_instr
	aRvbL,aRvbR reverbsc gaSend,gaSend,0.9,7000
	;outs     aRvbL,aRvbR
	kalpha line 0, p3, 360
	kbeta = 0
		
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aRvbL, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	outo a1, a2, a3, a4, a5, a6, a7, a8
	;outo a1*iMixRatio, a2*iMixRatio, a3*iMixRatio, a4*iMixRatio, a5*iMixRatio, a6*iMixRatio, a7*iMixRatio, a8*iMixRatio
	clear    gaSend
 endin