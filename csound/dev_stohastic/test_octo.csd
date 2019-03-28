<CsoundSynthesizer>
<CsOptions>
-Q2 --midioutfile=hack_o_tone.mid
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 8
0dbfs = 1

instr simple_sin
	iAmp = p5
	iFrq = p4
	kenv      linen     1, p3/4, p3, p3/4
	aOsc1     poscil    iAmp, iFrq, giSine
	;outs      aOsc1*kenv, aOsc1*kenv
	asig1	= aOsc1*kenv
	asig2	= aOsc1*kenv
	asig3	= aOsc1*kenv
	asig4	= aOsc1*kenv
	asig5	= aOsc1*kenv
	asig6	= aOsc1*kenv
	asig7	= aOsc1*kenv
	asig8	= aOsc1*kenv
	outo asig1, asig2, asig3, asig4, asig5, asig6, asig7, asig8
endin

</CsInstruments>
<CsScore>

;		1					2		3		4				5

;type	instr				start	len		
i 		"simple_sin"		0 		5		0.5				440.
i 		"simple_sin"		6 		3		0.5				880.

</CsScore>
</CsoundSynthesizer>