<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

gkSeqHarm[]  	array      1, 2, 3, 4, 5, 6, 7, 8
gkSeqGeom[]  	array      1, 2, 4, 8, 16, 32, 64, 128
gkSeqFibon[]  	array      1, 2, 3, 5, 8, 13, 21, 34

gkSeqIoni[]  	array      1, 1.1111, 1.25, 1.3333, 1.5, 1.6667, 1.875, 2 ;ionian
gkSeqPhry[]  	array      1, 1.0667, 1.2, 1.3333, 1.5, 1.6, 1.8, 2 ;Phrygian 
gkSeqDori[]  	array      1, 1.1111, 1.2, 1.3333, 1.5, 1.6667, 1.8, 2 ;Dorian 
gkSeqAnhe[]  	array      1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111 ;Anhemitone
gkSeqTHlf[]  	array      1, 1.0667, 1.2, 1.25, 1.4063, 1.5, 1.6667, 1.8 ;tone-half
gkSeqTHlfHlf[] 	array      1, 1.1111, 1.2, 1.25, 1.4063, 1.5, 1.6, 1.8 ;tone-half-half


gkModi[][] init  9, 8
gkModi array     1, 2, 3, 4, 5, 6, 7, 8,
                      1, 2, 4, 8, 16, 32, 64, 128,
					  1, 2, 3, 5, 8, 13, 21, 34,
                      1, 1.1111, 1.25, 1.3333, 1.5, 1.6667, 1.875, 2,
                      1, 1.0667, 1.2, 1.3333, 1.5, 1.6, 1.8, 2,
                      1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
                      1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
                      1, 1.0667, 1.2, 1.25, 1.4063, 1.5, 1.6667, 1.8, 
					  1, 1.1111, 1.2, 1.25, 1.4063, 1.5, 1.6, 1.8

gkMinDur		init 		0.2
gkFrqAbsBase	init 		50.

seed       0

giSine    ftgen     0, 0, 2^10, 10, 1


/*
		=====================================================================
		====================		sonification 		=====================
		=====================================================================
*/


;instr 1 
instr harmonic_additive_synthesis
	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	ibasefrq  =         p4
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	ibaseamp  =         iAmp
	
	;create 8 harmonic partials
	aOsc1     poscil    ibaseamp, ibasefrq, giSine
	aOsc2     poscil    ibaseamp/2, ibasefrq*2, giSine
	aOsc3     poscil    ibaseamp/3, ibasefrq*3, giSine
	aOsc4     poscil    ibaseamp/4, ibasefrq*4, giSine
	aOsc5     poscil    ibaseamp/5, ibasefrq*5, giSine
	aOsc6     poscil    ibaseamp/6, ibasefrq*6, giSine
	aOsc7     poscil    ibaseamp/7, ibasefrq*7, giSine
	aOsc8     poscil    ibaseamp/8, ibasefrq*8, giSine
	;apply simple envelope
	kenv      linen     1, p3/4, p3, p3/4
	;add partials and write to output
	aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
    outs      aOut*kenv, aOut*kenv
endin

;instr 2 ;inharmonic additive synthesis
instr inharmonic_additive_synthesis
	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	ibasefrq  =         p4
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	ibaseamp  =         iAmp
	
	;create 8 inharmonic partials
	aOsc1     poscil    ibaseamp, ibasefrq, giSine
	aOsc2     poscil    ibaseamp/2, ibasefrq*1.02, giSine
	aOsc3     poscil    ibaseamp/3, ibasefrq*1.1, giSine
	aOsc4     poscil    ibaseamp/4, ibasefrq*1.23, giSine
	aOsc5     poscil    ibaseamp/5, ibasefrq*1.26, giSine
	aOsc6     poscil    ibaseamp/6, ibasefrq*1.31, giSine
	aOsc7     poscil    ibaseamp/7, ibasefrq*1.39, giSine
	aOsc8     poscil    ibaseamp/8, ibasefrq*1.41, giSine
	kenv      linen     1, p3/4, p3, p3/4
	aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
	outs aOut*kenv, aOut*kenv
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

;instr	4 ; play audio from disk
instr	play_audio_from_disk
	kSpeed  init     1           ; playback speed
	iSkip   init     0           ; inskip into file (in seconds)
	iLoop   init     0           ; looping switch (0=off 1=on)
	
	iSpeedBegin		=		(1/p4)*25
	iRnd2	 		random 	0.5, 4.5 
	;kSpeed	expseg iSpeedBegin, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin*iRnd2-1, p3/3, iSpeedBegin
	kSpeed expseg iSpeedBegin, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin
	;printk 			1, kSpeed
	
	iRnd1	 		random 	0.5, 4.5 //from 1 to 5
	iFileNum		=		ceil(iRnd1);
	
	; read audio from disk using diskin2 opcode
	a1, a2      diskin2  iFileNum, kSpeed, iSkip, iLoop
	outs       a1, a2
endin

/*
		=====================================================================
		====================		direction	 		=====================
		=====================================================================
*/



instr rythm_disp
	kDur			init 	20
	kTrig			metro	1/kDur
	kEnvStart		linseg 20, 2*p3/3, 10, p3/3, 20
	
	if kTrig == 1 then
		;kDur 		random 	15, 30
		kDur 		random 	kEnvStart, 30
		kCenter		random 	1, 6
		event  "i", "rythm_gen", 0, kDur*2.5, kCenter
	endif
endin

instr rythm_gen
	kRange			init	.1
	;kCenter			init	1.
	kCenter			init	p4
	kIndex2			init	1.
	kIndex2_prev	init	1.
		
	;kIndex			init 	2.	
	kDur			init 	.4
	
	kFrqBaseFlag	init	1
	kModeFlag	init	0
	
	iRnd1	 		random 	0.5, 3.5
	iInstrNum		=		ceil(iRnd1);
	
	kTimer			line 	0., 1., p3
	
	kFrqRange			init	.1
	;kFrqCenter			init	1.
	kFrqCenter			init	p4
	kFrqIndex2			init	1.
	kFrqIndex2_prev		init	1.
	
	kTrig		metro	1/kDur
	
	if kTrig == 1 then
		;printk 	1, iInstrNum
	
		;kIndex 		random 	0, 7
		;kDur		=		gkMinDur*gkSeqGeom[kIndex]
		kDur		=		gkMinDur*gkSeqGeom[kIndex2]
		
		printk 	1, 1/kDur
		
		if kModeFlag==0 then
			kRnd2	 		random 	0.5, 8.5
			kFrqTblNum		=		ceil(kRnd2);
			kModeFlag	=		1
		endif
		
		if kFrqBaseFlag==1 then
			kFrqBaseIndex	random 	0, 7
			kFrqBase		= 		gkSeqFibon[kFrqBaseIndex]*gkFrqAbsBase
			kFrqBaseFlag	=		0
		endif
		
		;kFrq 			random 	110, 1100
		;kFrqIndex 		random 	0, 7
		;kFrq 			= 	kFrqBase*gkSeqHarm[kFrqIndex];
		
		
		if kIndex2 < 2 then
			kExp3 		random 	0.5, 1.5
			kExp3		=	ceil(kExp3);
			kSign3 		pow -1, kExp3
			kFrqIndex2			=		kFrqIndex2 + kSign3
		else
			kFrqIndex2New		gauss 	kFrqRange
			kFrqIndex2			=		kFrqIndex2 + kFrqIndex2New
			kFrqIndex2			= 		kFrqCenter + ceil(kFrqIndex2)
		endif		
		
		
		if kFrqIndex2 < 0 then
			kFrqIndex2		=		1
		endif
		
		if kFrqIndex2 > 7 then
			kFrqIndex2		=		7
		endif
		
		
		kFrq 			= 	kFrqBase*gkModi[kFrqTblNum-1][kFrqIndex2]
		event  "i", iInstrNum, 0, kDur-.1, kFrq
		;event  "i", 4, 0, kDur-.1, kFrq
		;printf  "Play kIndex=%f Tbl_val=%f Dur=%f MinDur=%f\n", 1, kIndex, gkSeqGeom[kIndex], kDur, gkMinDur
		
		/*
		=====================================================================
		====================		duration change 	=====================
		=====================================================================
		*/
		
		kIndex2			gauss 	kRange
		kIndex2			= 		kCenter + ceil(kIndex2)
		
		if kIndex2 < 0 then
			kIndex2		=		1
		endif
		
		if kIndex2 > 7 then
			kIndex2		=		7
		endif
		
		kDelta			=		abs(kIndex2 - kIndex2_prev)
		
		printk 			1, kIndex2
		printk 			1, kIndex2_prev
		printk 			1, kDelta
		
		kExp 		random 	0.5, 1.5
		kExp		=	ceil(kExp);
		kSign 		pow -1, kExp
		printk 			1, kSign
		
		if kDelta > 0 then
			kCenter			= 	kSign*kIndex2
			kIndex2_prev	=	kSign*kIndex2
		endif
		
		kRange			poscil    5, 2/p3, giSine
		kRange			=		kRange + .2
		
		/*
		=====================================================================
		====================		pitch change 		=====================
		=====================================================================
		*/
		
		if kTimer > 0.3 then
			if kModeFlag==1 then
				kRnd2	 		random 	0.5, 8.5
				kFrqTblNum		=		ceil(kRnd2);
				kModeFlag		= 		2
			endif
		endif
		
		
		if kFrqIndex2 < 0 then
			kFrqIndex2		=		1
		endif
		
		if kFrqIndex2 > 7 then
			kFrqIndex2		=		7
		endif
		
		kFrqDelta			=		abs(kFrqIndex2 - kFrqIndex2_prev)
		
		kFrqExp 		random 	0.5, 1.5
		kFrqExp		=	ceil(kFrqExp);
		kFrqSign 		pow -1, kFrqExp
		
		if kFrqDelta > 0 then
			kFrqCenter			= 	kFrqSign*kFrqIndex2
			kFrqIndex2_prev		=	kFrqSign*kFrqIndex2
		endif
		
		kFrqRange			poscil    10, 4/p3, giSine, (2^10)/4
		kFrqRange			=		kFrqRange + .2
	
	endif
endin

 
</CsInstruments>
<CsScore>

;type	instr				start	len		seed	iTypeOfDistrib	iDistribDepth
;i 		"rythm_gen" 		0 		100
i 		"rythm_disp" 		0 		200



</CsScore>
</CsoundSynthesizer>