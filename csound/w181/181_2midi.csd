<CsoundSynthesizer>
<CsOptions>
;-o dac
-o w181_2.wav -W 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

seed    0
gisine  ftgen	0,0,4096,10,1

instr 3 ; Cl.
	;iFrq = p4
	;iModAmp = p5
	;iModFrq = p6
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	aMod poscil iModAmp, iModFrq, gisine
	aCar poscil iVel, iFrq+aMod, gisine
	outs aCar, aCar
endin


instr 1, 2, 4 ; Fl., Ob, Fag.

endin


</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>