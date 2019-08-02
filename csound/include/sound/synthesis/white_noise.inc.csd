instr white_noise_my
	kBeta 	linseg		-.99, p3/2, 0, p3/2, .99
	kAmp	linseg		.2, p3/2, .8, p3/2, .2
	aRes 	noise 		kAmp, kBeta
			outs		aRes, aRes
endin