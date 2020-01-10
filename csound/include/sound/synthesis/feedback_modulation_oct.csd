instr feedback_modulation_oct
	;kCarFreq = 200
	kCarFreq = p4
	/* 				**
	**	Amplitude 	**
	**				*/
	iAmp		random     0.1, .9
	iAttTime	random     0.01, p3/3
	iSustTime	random     0.01, p3/3
	;aAmpEnv expseg .001, 0.001, 1, 0.3, 0.5, 8.5, .001
	aAmpEnv expseg .001, iAttTime, 1, iSustTime, 0.5, p3-(iAttTime+iSustTime), .001
	
	
	iPeaKAmount		=	i(gkTotalLen)+1
	
	;kFeedbackAmountEnv linseg 0, 2, 0.2, 0.1, 0.3, 0.8, 0.2, 1.5, 0
	kFeedbackAmountEnv linseg 0, 2, random(0.1, .9), 	0.1, 0.3*iPeaKAmount, 	random(0.1, .8), 0.2, 	1.5, 0
	
	aPhase phasor kCarFreq
	aCarrier init 0 ; init for feedback
	;aCarrier tablei aPhase+(aCarrier*kFeedbackAmountEnv), 1, 1, 0, 1
	aCarrier tablei aPhase+(aCarrier*kFeedbackAmountEnv), giSine, 1, 0, 1
	
	;outs aCarrier*aAmpEnv, aCarrier*aAmpEnv
	kAzimtDistrType init 1
	kAzimMin	init 0
	kAzimMax	init 360
	kAzimDepth	init 1
	kAzimMinDelta init 45
	
	kFromAzim	=	IntRndDistrK(kAzimtDistrType, kAzimMin, kAzimMax, kAzimDepth)
	kToAzim	=	IntRndDistrK(kAzimtDistrType, kFromAzim+kAzimMinDelta, kAzimMax, kAzimDepth)
		
	iFromAzim = i(kFromAzim)
	iToAzim = i(kToAzim)		   
	
	kalpha line iFromAzim, p3, iToAzim
	kbeta = 0
        
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aCarrier*aAmpEnv, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        
	
	outo a1, a2, a3, a4, a5, a6, a7, a8
endin