/*
	soundin.1-5 orchestral
	soundin.6-11 spoken
	
*/

instr	play_audio_from_disk
	kSpeed  init     1           ; playback speed
	iSkip   init     0           ; inskip into file (in seconds)
	iLoop   init     1           ; looping switch (0=off 1=on)
	
	iPan	=	p6

	kTrigLog		metro	1

	;iSpeedBegin		=		(1/p4)*25
	iSpeedBegin		=		1

	if gkTotalLen <= .6 then
		kRndMin = .2 * gkTotalLen + .1
	else
		kRndMin = gkTotalLen - .5
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
	
	;printk 			1, kSpeed
	
	;iRnd1	 		random 	0.5, 4.5 //from 1 to 5
	iRnd1	 		random 	0.5, 29.5 //from 1 to 30
	iFileNum		=		ceil(iRnd1);
	
	

	; read audio from disk using diskin2 opcode
	a1, a2      diskin2  iFileNum, kSpeed, iSkip, iLoop
	
	aAmpEnv expseg .001, .01, 1, 	p3-.01-.1, 1, 	.1, .001
	
	outs       a1*iPan*aAmpEnv, a2*(1-iPan)*aAmpEnv
endin