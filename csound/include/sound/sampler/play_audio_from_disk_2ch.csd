instr	play_audio_from_disk
	kSpeed  init     1           ; playback speed
	iSkip   init     0           ; inskip into file (in seconds)
	iLoop   init     0           ; looping switch (0=off 1=on)
	
	iPan	=	p6

	kTrigLog		metro	1

	;iSpeedBegin		=		(1/p4)*25
	iSpeedBegin		=		1
	iRndBegin	 	random 	0.5, 1.5 
	iRndEnd	 		random 	0.5, 1.5
	;kSpeed	expseg iSpeedBegin, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin*iRnd2-1, p3/3, iSpeedBegin
	;kSpeed expseg iSpeedBegin, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin*iRnd2, p3/3, iSpeedBegin
	kSpeed expseg iSpeedBegin*iRndBegin, p3/3, iSpeedBegin*iRndEnd, p3/3, iSpeedBegin*iRndEnd, p3/3, iSpeedBegin*iRndBegin
	;printk 			1, kSpeed
	
	;iRnd1	 		random 	0.5, 4.5 //from 1 to 5
	iRnd1	 		random 	0.5, 10.5 //from 1 to 11
	iFileNum		=		ceil(iRnd1);
	
	if kTrigLog == 1 then
		;fprintks 	$DUMP_FILE_NAME, "iSpeedBegin = %f :: iRnd2 = %f :: kSpeed = %f :: iFileNum = %f \\n", iSpeedBegin, iRnd2, kSpeed, iFileNum
	endif

	; read audio from disk using diskin2 opcode
	a1, a2      diskin2  iFileNum, kSpeed, iSkip, iLoop
	outs       a1*iPan, a2*(1-iPan)
endin