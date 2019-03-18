<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giSeqHarm[]  	array      1, 2, 3, 4, 5, 6, 7, 8
giSeqGeom[]  	array      1, 2, 4, 8, 16, 32, 64, 128
giSeqFibon[]  	array      1, 2, 3, 5, 8, 13, 21, 34

giStartTime[]  	array      0, 0, 0, 0, 0, 0, 0, 0
giMaxNote 		init 		100
giMinDur 		init 		0.2



instr trigger_note
	kTrig      metro      .3
	if kTrig == 1 then
		event  "i", "play_note", 0, 1, 440
	endif
endin

instr rythm_gen
	iStart = giStartTime[0]+(giMinDur*giSeqHarm[1])
	giStartTime[0] = iStart
	event  "i", "play_note", iStart, 1, 440
endin
  

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
  
  
</CsInstruments>
<CsScore>

;type	instr				start	len		seed	iTypeOfDistrib	iDistribDepth
;i 		"discr_distr" 		0 		2		0		1				-1
;i 		"trigger_note" 		0 		100

i 		"rythm_gen" 		0 		1

/*
;type	instr				start	len		frq
i		"play_note"			0		1		440
i		"play_note"			+^1		.		220
i		"play_note"			.		.		330
i		"play_note"			.		.		453
*/

</CsScore>
</CsoundSynthesizer>