instr play_note
	;iNote      =          p4
	;iFreq      =          giBasFreq * giNotes[iNote]
	iFreq      =          p4
	;random choice for mode filter quality and panning
	iQ         random     10, 200
	iPan       random     0.1, .9
	;generate tone and put out
	aImp       mpulse     1, p3
	aOut       mode       aImp, iFreq, iQ
	aL, aR     pan2       aOut, iPan
			   outs       aL, aR
endin