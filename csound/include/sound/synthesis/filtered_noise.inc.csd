instr filtered_noise
	;ksep	= p4				;vary seperation of center frequency of filters in octaves
	ksep	random 	1, 5				;vary seperation of center frequency of filters in octav
	kenv	linseg	0, p3*.5, 1, p3*.5, 0	;envelope
	asig	rand	0.7
	iBeginFrq random 	200, 2500
	iEndFrq random 	400, 3500
	kbf	line	iBeginFrq, p3, iEndFrq		;vary base frequency
	afilt	resony	asig, kbf, 300, 4, ksep
	asig	balance afilt, asig
		outs	asig*kenv, asig*kenv
endin