instr impulse_oct
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
			   ;outs       aL, aR
	kalpha line 0, p3, 360
	kbeta = 0
        
	; generate B format
	aw, ax, ay, az, ar, as, at, au, av bformenc1 aOut, kalpha, kbeta
	; decode B format for 8 channel circle loudspeaker setup
	a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

	; write audio out
	outo a1, a2, a3, a4, a5, a6, a7, a8
endin