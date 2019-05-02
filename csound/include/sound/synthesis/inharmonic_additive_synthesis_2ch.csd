instr inharmonic_additive_synthesis
	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	ibasefrq  =         p4
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	ibaseamp  =         iAmp

	iPan	=	p6
	
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
	outs aOut*kenv*iPan, aOut*kenv*(1-iPan)
endin