<CsoundSynthesizer>
<CsOptions>
;-o dac
-F w194.mid -o w194.wav -W 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

gisine  ftgen	0,0,4096,10,1
  
instr 1 ; Fl.
/*
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	aMod poscil iModAmp, iModFrq, gisine
	aCar poscil iVel, iFrq+aMod, gisine
	outs aCar, aCar
*/
;
endin

instr 2 ; Tr-ba
	;
endin

instr 3 ; Tr-no
	;
endin

instr 4 ; Tuba
	;
endin


instr 5 ;  Track name: Bass Drum
  ;
endin

instr 6 ;  Track name: Cymbals
  ;
endin

instr 7 ;  Track name: Snare Drum
  ;
endin

instr 8 ;  Track name: Triangle
  ;
endin

instr 9 ;  Track name: Piano
/*
	;iNote      =          p4
	;iFreq      =          giBasFreq * giNotes[iNote]
	;iFreq      =          p4
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;random choice for mode filter quality and panning
	iQ         random     10, 200
	iPan       random     0.1, .9
	;generate tone and put out
	aImp       mpulse     1, p3
	aOut       mode       aImp, iFrq, iQ
	aL, aR     pan2       aOut, iPan
			   outs       aL, aR
*/
	iAmp     =        0.3
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	aCar poscil iAmp, iFrq, gisine
	outs aCar, aCar
endin

instr 10 ;  Track name: Violin
  ;
endin

instr 11 ;  Track name: Violoncello
  ;
endin

</CsInstruments>
<CsScore>
f 0 100
</CsScore>
</CsoundSynthesizer>