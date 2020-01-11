instr fft_stretch_pitchsfht_2ch


	gifftsize =         1024
	gioverlap =         gifftsize / 4
	giwinsize =         gifftsize
	giwinshape =        1; von-Hann window
	
	kSpeed	=	1
	iSkip	=	0
	iLoop	=	1
	iPan	=	p6

	kTrigLog		metro	1
	
	iRnd1	 		random 	0.5, 24.5 ;from 1 to 25
	iFileNum		=		ceil(iRnd1);
	
	iRnd2	 		random 	0.5, 24.5 ;from 1 to 25
	iFileNum2		=		ceil(iRnd2);
	
	

	; read audio from disk using diskin2 opcode
	a1, a2      diskin2  iFileNum, kSpeed, iSkip, iLoop
	
	a21, a22      diskin2  iFileNum2, kSpeed, iSkip, iLoop
	
	aAmpEnv expseg .001, .01, 1, 	p3-.01-.1, 1, 	.1, .001
	
	
	/*	**
	**	Scale factor	**
	**					*/
	
	iSpeedBegin		=		1

	if gkTotalLen <= .6 then
		kRndMin = 1.75/.6 * gkTotalLen + .25
	else
		kRndMin = -1.5 / .4 * gkTotalLen + .5 + 1.5 / .4
	endif
	
	kRndMax = kRndMin + .3
	iRndMin = i(kRndMin) + .0001
	iRndMax = i(kRndMax) + .0001
	;iRndBegin	 	random 	0.5, 1.5 
	iRndBegin	 	random 	iRndMin, iRndMax 
	iRndEnd	 		random 	iRndMin, iRndMax 
	
	if kTrigLog == 1 then
		;fprintks 	$DUMP_FILE_NAME, "iSpeedBegin = %f :: iRnd2 = %f :: kSpeed = %f :: iFileNum = %f \\n", iSpeedBegin, iRnd2, kSpeed, iFileNum
		;fprintks 	$DUMP_FILE_NAME, "iSpeedBegin = %f :: kSpeed = %f \\n", iSpeedBegin,  kSpeed
		;fprintks 	"sampler.log.txt", "iRndMin = %f :: iRndMax = %f :: iRndBegin = %f :: iRndEnd = %f \\n", iRndMin, iRndMax, iRndBegin, iRndEnd
		;fprintks 	"sampler.log.txt", "gkTotalLen = %f :: kRndMin = %f :: kRndMax = %f \\n", gkTotalLen, kRndMin, kRndMax
	endif	
	
	printks 	"gkTotalLen = %f :: kRndMin = %f :: kRndMax = %f :: iRndBegin = %f :: iRndEnd = %f \\n", 1, gkTotalLen, kRndMin, kRndMax, iRndBegin, iRndEnd
	
	;kSpeed	expseg iSpeedBegin, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin*iRnd2-1, p3/3, iSpeedBegin
	;kSpeed expseg iSpeedBegin, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin
	;kSpeed expseg iSpeedBegin*iRndBegin, p3/3, iSpeedBegin*iRndEnd, p3/3, iSpeedBegin*iRndEnd, p3/3, iSpeedBegin*iRndBegin
	
	if iRndMin <= .0001 then
		kSpeed	rspline	iSpeedBegin*random(kRndMin, kRndMax), iSpeedBegin*random(kRndMin, kRndMax), .5, 2
	else
		kSpeed	rspline	iSpeedBegin*iRndBegin, iSpeedBegin*iRndEnd, .5, 2
	endif
	
	/*	**
	**	Pitch shift		**
	**					*/
	
	;ain       soundin  "fox.wav"
	fftin1     pvsanal  a1, gifftsize, gioverlap, giwinsize, giwinshape
	fftin2     pvsanal  a2, gifftsize, gioverlap, giwinsize, giwinshape
	
	fftin21     pvsanal  a21, gifftsize, gioverlap, giwinsize, giwinshape
	fftin22     pvsanal  a22, gifftsize, gioverlap, giwinsize, giwinshape
	
	fftscal1   pvscale  fftin1, kSpeed
	fftscal2   pvscale  fftin2, kSpeed
	
	;fvoc1      pvsvoc    fftscal1, fftin21, 1, 1
	;fvoc2      pvsvoc    fftscal2, fftin22, 1, 1
		
	fcross1    pvscross  fftscal1, fftin21, .5, 1
	fcross2    pvscross  fftscal2, fftin21, .5, 1
	
	;aout1      pvsynth  fftscal1
	;aout2      pvsynth  fftscal2
	
	aout1      pvsynth  fcross1
	aout2      pvsynth  fcross2
				;out      aout
				outs       aout1*iPan*aAmpEnv, aout2*(1-iPan)*aAmpEnv
				
endin