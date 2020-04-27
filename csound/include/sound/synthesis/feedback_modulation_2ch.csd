instr feedback_modulation
	;kCarFreq = 200
	kCarFreq = p4
	
	/* 				**
	**	Amplitude 	**
	**				*/
	iAmp		random     .1, .9
	iAttTime	random     0.01, p3/3
	iSustTime	random     0.01, p3/3
	;aAmpEnv expseg .001, 0.001, 1, 0.3, 0.5, 8.5, .001
	aAmpEnv expseg .001, iAttTime, 1, iSustTime, 0.5, p3-(iAttTime+iSustTime), .001
	
	
	iPeaKAmount		=	i(gkTotalLen)+1
	
	;kFeedbackAmountEnv linseg 0, 2, 0.2, 0.1, 0.3, 0.8, 0.2, 1.5, 0
	kFeedbackAmountEnv linseg 0, 2, random(0.1, .9), 	0.1, 0.3*iPeaKAmount, 	random(0.1, .8), 0.2, 	1.5, 0
	;kFeedbackAmountEnv linseg 0, p3/3, random(.9, 2), p3/3, 0, p3/3, random(.9, 2)
	;kFeedbackAmountEnv 	rspline 0.001, 2, (.1+gkTotalLen)^2, (.3+gkTotalLen)^2*1.5
	;kFeedbackAmountEnv 	rspline 0.1, 3, .001, .01
	
	aPhase phasor kCarFreq
	aCarrier init 0 ; init for feedback
	;aCarrier tablei aPhase+(aCarrier*kFeedbackAmountEnv), 1, 1, 0, 1
	aCarrier tablei aPhase+(aCarrier*kFeedbackAmountEnv), giSine, 1, 0, 1
	
	outs aCarrier*aAmpEnv*iAmp/15, aCarrier*aAmpEnv*iAmp/15
endin