gaSend init 0

instr wgbow_instr
	kFlag	init	1

	kamp     init        0.3
	kfreq    init        p4
	kpres    init        0.2
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
	;krat     rspline  kRatMin, kRatMax, 0.1, 0.4
	
	
	
	;if kFlag == 1 then
	;	fprintks 	"wgbow_debug.txt", "kRatMin = %f | kRatMax = %f\\n", kRatMin, kRatMax
	;	kFlag	=	0
	;endif
	
	aSig	 wgbow    kamp,kfreq+kEnvFrq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
	;aSig     butlp    aSig,2000
	;aSig     pareq    aSig,80,6,0.707
	kEnv	linseg		.01, p3/5, 1., p3/5, .8, 2*p3/5, .8, p3/5, .001 
			 outs     aSig*kEnv, aSig*kEnv
	gaSend   =        gaSend + aSig/3
endin

instr wgbow_reverb_instr
	aRvbL,aRvbR reverbsc gaSend,gaSend,0.9,7000
            outs     aRvbL,aRvbR
            clear    gaSend
endin