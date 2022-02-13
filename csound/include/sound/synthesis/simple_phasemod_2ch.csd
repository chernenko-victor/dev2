instr simple_phasemod_2ch
	kCarFreq = p4
	;kModFreq = kCarFreq*12/7
	iModFreqB random p4*12/7, p4*12/7+50
	iModFreqE random p4*12/7, p4*12/7+50
	kModFreq line iModFreqB, p3, iModFreqE
	kModFactor = kCarFreq/kModFreq
	kIndex = 12/6.28   ;  12/2pi to convert from radians to norm. table index
	
	iAmp random .1, .3
	;iAttTime = 0.001
	iAttTime random 0.001, .5
	iDecTime = 0.3
	iDecAmp = 0.5
	aEnv expseg .001, iAttTime, iAmp, iDecTime, iDecAmp, p3 - iAttTime - iDecTime, .001
	aModulator poscil kIndex*aEnv, kModFreq, 1
	aPhase phasor kCarFreq
	aCarrier tablei aPhase+aModulator, 1, 1, 0, 1
	outs (aCarrier*aEnv), (aCarrier*aEnv)
endin