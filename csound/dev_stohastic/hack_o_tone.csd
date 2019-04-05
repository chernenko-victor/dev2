<CsoundSynthesizer>
<CsOptions>
-Q2 --midioutfile=hack_o_tone.mid
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 8
0dbfs = 1

#define DUMP_FILE_NAME #"dump__hack_o_tone.txt"#
#define SPAT_SUM_LIMIT #2#
#define SPAT_MULT_LIMIT #2#
#define SPAT_X_MIN #0.01#
#define SPAT_Y_MIN #0.01#
#define SPAT_Y_MAX #1.#
#define ROOM_DIM_SM #1000#

#include "..\include\math\stochastic\distribution3.inc.csd"
#include "..\include\math\stochastic\util.inc.csd"
#include "..\include\utils\table.v1.csd"

/*
	=======================================================
	================	init instr 	=======================
	=======================================================
	
	initialize global vars there
*/

gkSpat[][][][] init  100, 5, 5, 9
gkCurrentPart init 0

gkSpeakerPos[][] init 8, 2
gkSpeakerPos array 	300, 800,
					600, 800,
					200, 600,
					750, 600,
					200, 300,
					750, 300,
					200, 200,
					750, 200

gkModi[][] init  9, 8
gkModi array	/* natural */			1, 2, 3, 4, 5, 6, 7, 8,
				/* geom */				1, 2, 4, 8, 16, 32, 64, 128,
				/* fibon */				1, 2, 3, 5, 8, 13, 21, 34,
				/* ionian */ 			1, 1.1111, 1.25, 1.3333, 1.5, 1.6667, 1.875, 2,
				/* Phrygian */ 			1, 1.0667, 1.2, 1.3333, 1.5, 1.6, 1.8, 2,
				/* Dorian */			1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
				/* Anhemitone */		1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
				/* tone-half */			1, 1.0667, 1.2, 1.25, 1.4063, 1.5, 1.6667, 1.8, 
				/* tone-half-half */	1, 1.1111, 1.2, 1.25, 1.4063, 1.5, 1.6, 1.8
				 

gkPeriod	init 	1
gkMinPeriod	init 	.25
;gkMinPeriod	init 	.15

seed       0

giSine    ftgen     0, 0, 2^10, 10, 1

/*
gkModi16[][] init  9, 16
gkModi16 array   1, 2, 3, 4, 5, 6, 7, 8,		0, 0, 0, 0, 0, 0, 0, 0,
                 1, 2, 4, 8, 16, 32, 64, 128,		0, 0, 0, 0, 0, 0, 0, 0,
				 1, 2, 3, 5, 8, 13, 21, 34,		0, 0, 0, 0, 0, 0, 0, 0,
                 1, 1.1111, 1.25, 1.3333, 1.5, 1.6667, 1.875, 2,		0, 0, 0, 0, 0, 0, 0, 0,
                 1, 1.0667, 1.2, 1.3333, 1.5, 1.6, 1.8, 2,		0, 0, 0, 0, 0, 0, 0, 0,
                 1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,		0, 0, 0, 0, 0, 0, 0, 0,
                 1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,		0, 0, 0, 0, 0, 0, 0, 0,
                 1, 1.0667, 1.2, 1.25, 1.4063, 1.5, 1.6667, 1.8, 		0, 0, 0, 0, 0, 0, 0, 0,
				 1, 1.1111, 1.2, 1.25, 1.4063, 1.5, 1.6, 1.8,		0, 0, 0, 0, 0, 0, 0, 0

*/				 
	

;BEGIN prepare theme arrays	
gkThemeModus[][]    		init 	8, 64
gkThemeIndexInModus[][]    	init 	8, 64
gkThemePitch[][]    		init 	8, 64
gkThemeStart[][]    		init 	8, 64
gkThemeDur[][]    			init 	8, 64
gkThemeAmp[][]    			init 	8, 64

kThemeIndex		init	0

until kThemeIndex > 7 do
	gkThemeModus[kThemeIndex][0]    	= 	-1
	gkThemeIndexInModus[kThemeIndex][0] = 	-1
	gkThemePitch[kThemeIndex][0]    =	-1
	gkThemeStart[kThemeIndex][0]    =	-1
	gkThemeDur[kThemeIndex][0]    	=	-1
	gkThemeAmp[kThemeIndex][0]    	=	-1
	kThemeIndex    	+=         1
enduntil

gkCurrentThemeIndex	init	0
;END prepare theme arrays	

gkLineRythm[][] init  8, 8
gkLineRythm array		0.8,	0.2,	0.,		0.,		0.,		0.,		0.,		0.,
						0.1,	0.8,	0.1,	0.,		0.,		0.,		0.,		0.,
						0.,		0.1,	0.8,	0.1,	0.,		0.,		0.,		0.,
						0.,		0.,		0.1,	0.8,	0.1,	0.,		0.,		0.,
						0.,		0.,		0.,		0.1,	0.8,	0.1,	0.,		0.,
						0.,		0.,		0.,		0.,		0.1,	0.8,	0.1,	0.,
						0.,		0.,		0.,		0.,		0.,		0.1,	0.8,	0.1,
						0.,		0.,		0.,		0.,		0.,		0.,		0.2,	0.8	
	
/*
		=====================================================================
		====================		sonification 		=====================
		=====================================================================
*/


;instr 1 harmonic_additive_synthesis_oct
#include "..\include\sound\synthesis\harmonic_additive_synthesis_oct.csd"

;instr 2 ;inharmonic additive synthesis_oct
#include "..\include\sound\synthesis\inharmonic_additive_synthesis_oct.csd"

;instr 3 ; impulse_oct
#include "..\include\sound\synthesis\impulse_oct.csd"

;instr	4 ; play audio from disk oct
#include "..\include\sound\sampler\play_audio_from_disk_oct.csd"

;instr	5 ;substractive_wov
#include "..\include\sound\synthesis\substractive_oct.csd"

;instr	6 ;instr wgbow_instr + inst 7 wgbow_reverb_instr
#include "..\include\sound\synthesis\wgbow_oct.csd"
				 
/*
	===============================================
	=========	regular start other insts 	=======
	===============================================
*/


instr rythm_disp
	;kFlag			init 	1
	kDur			init 	15
	kTrig			metro	1/kDur
	kEnvStart		linseg 15, 2*p3/3, 5, p3/3, 15
	
	/*
	if kFlag == 1 then
		event  "i", "part", 0, kDur*2.5, 1, .5
		kFlag = 0
	endif
	*/
	
	if kTrig == 1 then
		;kDur 		random 	15, 30
		kDur 		random 	kEnvStart, 30
		kCenter		random 	1, 6
		kPan		random 	.1, .9
		event  "i", "part", 0, kDur*2.5, kCenter, kPan
	endif
	
endin

instr theme
	/*
		==================================================================
		==================		initialisation 	 			==============
		==================================================================
	*/
	kFlag		init 	1
	
	kStart		init 	0		;offst for event opcode, now constant 
	kDur		init 	.3		;duration of event, now is relative to kPeriod (2DO: change by system)
	kAmp		init 	.3		;amplitude of event opcode, now constant (2DO: change by system)
	kFrq		init 	440		;frequency of event
	kFrqMult	init 	1.		;base frq multiplier, now uniform random (2DO: change by system)
	
	;BEGIN var for period change 
	;change produced by generating indicies for gkModi[type] subarray 
	kStartDistrType		init 	7		;type of rnd distribution see in #PATH_TO_LIB\include\math\stochastic\distribution3.inc.csd
	kStartMin			init 	0		
	kStartMax			init 	3	
	kStartDepth			init 	2	
	kStartFoldingType	init 	2	;type of scaling indicies to gkModi[type] subarray  length
	kStartTblLen		init 	8	;gkModi[type] subarray length
	;END var for period change
	
	kGlobalThemeIndex	init 	0
	
	iPan = .5	
	
	;iThemeLen 	= 		p3
	kThemeLen 	= 		p3
	
	iMidiChannel	=	p4
	iPartType		=	p5	;{1 = theme, 2 = line, 3 = pedal, 4 = factura}
	
	kMinTotalY				init 1
	kMaxTotalY				init 127
	kMinYDeltaScaled		init 1
	
	/*
		==================================================================
		==================			once at start 	 		==============
		==================================================================
	*/
	if kFlag == 1 then
		kFlag = 0
		
		
		kBExtereme = kMinTotalY
		kAExtereme = kMaxTotalY - kMinTotalY
		kMinYDeltaNonScaled = kMinYDeltaScaled / kAExtereme
		
		/*
			==================================================================
			==================		generate frq profile 		==============
			==================================================================
		*/
	
		/*
		kEnvFunctionComposite[kMotifIndex][0] <- TEnvFunctionType EFType ;[int], EnvFunctionType {1 = linear, 2 = power, 3 = exponential, 4 = sinus, 5 = saw i.e. modulo, 6 = stochastic};
		kEnvFunctionComposite[kMotifIndex][1] <- double MinX ;motif begin, [float], sec
		kEnvFunctionComposite[kMotifIndex][2] <- double MaxX ;motif end, [float], sec
		kEnvFunctionComposite[kMotifIndex][3] <- double MinY ;minimum value, [float], normalized 0..1
		kEnvFunctionComposite[kMotifIndex][4] <- double MaxY ;maximum value, [float], normalized 0..1
		kEnvFunctionComposite[kMotifIndex][5] <- double Period; //for periodical functions (sinus, saw i.e. modulo), [float], sec
		kEnvFunctionComposite[kMotifIndex][6] <- int DistrType; //for stochastic, [int], type of rnd distribution see in #PATH_TO_LIB\include\math\stochastic\distribution3.inc.csd
		kEnvFunctionComposite[kMotifIndex][7] <- int Depth;	//for stochastic, [int]
		*/
		
		kEnvFunctionComposite[][] init 64, 8
		
		kMotifNum		IntRndDistrK 	1, 2, 5, 1 ;motif num
		kMotifLen[]  	RndSplit		0, kThemeLen, kMotifNum
		
		kCurrMinX		=	0
		kCurrMaxX		=	kMotifLen[0]
		kMotifIndex	   	=	0
		kSmallestDelta		=	1.
		until kMotifIndex >= kMotifNum do
			kEnvFunctionComposite[kMotifIndex][0]  	IntRndDistrK 	1, 1, 7, 1
			kEnvFunctionComposite[kMotifIndex][1]	=		kCurrMinX
			kEnvFunctionComposite[kMotifIndex][2]	=		kCurrMaxX
			
			kEnvFunctionComposite[kMotifIndex][3]	=		get_different_distrib_value_k(0, 1, .001+kMinYDeltaNonScaled, 1.-kMinYDeltaNonScaled, 1)
			kDirection 								IntRndDistrK 	1, 0, 2, 1
			if kDirection>0 then ;up
				kEnvFunctionComposite[kMotifIndex][4]	=		get_different_distrib_value_k(0, 1, kEnvFunctionComposite[kMotifIndex][3]+kMinYDeltaNonScaled, 1., 1)
			else ;down
				kEnvFunctionComposite[kMotifIndex][4]	=		get_different_distrib_value_k(0, 1, .001, kEnvFunctionComposite[kMotifIndex][3]-kMinYDeltaNonScaled, 1)
			endif
			
			;BEGIN define smallest delta
			kCurrDelta = abs(kEnvFunctionComposite[kMotifIndex][3]-kEnvFunctionComposite[kMotifIndex][4])
			fprintks 	$DUMP_FILE_NAME, "index = %d | kCurrDelta = %f\n", kMotifIndex, kCurrDelta
			if kCurrDelta<kSmallestDelta then
				kSmallestDelta = kCurrDelta
			endif
			;END define smallest delta
						
			if ((kEnvFunctionComposite[kMotifIndex][0] == 4) || (kEnvFunctionComposite[kMotifIndex][0] == 5))  then
				kEnvFunctionComposite[kMotifIndex][5] = get_different_distrib_value_k(0, 1, (kCurrMaxX-kCurrMinX)/3, kCurrMaxX-kCurrMinX, 1)
			endif
			
			if kEnvFunctionComposite[kMotifIndex][0] == 6 then
				kEnvFunctionComposite[kMotifIndex][6] 	IntRndDistrK 	1, 1, 7, 1
				kEnvFunctionComposite[kMotifIndex][7] 	IntRndDistrK 	1, 1, 5, 1
			endif
			
			kMotifIndex    	+=         1
			kCurrMinX		=	(kCurrMaxX + 0.001)
			kCurrMaxX		+=	kMotifLen[kMotifIndex]
  		enduntil
		
		kEnvFunctionComposite[kMotifIndex][0] = -1;
		
		kIndex    =        0
		fprintks 	$DUMP_FILE_NAME, "EnvFunctionType {1 = linear, 2 = power, 3 = exponential, 4 = sinus, 5 = saw i.e. modulo, 6 = stochastic}\n\n"
		until kEnvFunctionComposite[kIndex][0] == -1 do
			fprintks 	$DUMP_FILE_NAME, "(Len :: \t\t\tkMotifLen[%d] = %f)\n", kIndex, kMotifLen[kIndex]
			fprintks 	$DUMP_FILE_NAME, "EnvFunctionType :: \t\tkEnvFunctionComposite[%d][0] = %f\n", kIndex, kEnvFunctionComposite[kIndex][0]
			fprintks 	$DUMP_FILE_NAME, "double MinX :: \t\t\tkEnvFunctionComposite[%d][1] = %f\n", kIndex, kEnvFunctionComposite[kIndex][1]
			fprintks 	$DUMP_FILE_NAME, "double MaxX :: \t\t\tkEnvFunctionComposite[%d][2] = %f\n", kIndex, kEnvFunctionComposite[kIndex][2]
			fprintks 	$DUMP_FILE_NAME, "double MinY :: \t\t\tkEnvFunctionComposite[%d][3] = %f\n", kIndex, kEnvFunctionComposite[kIndex][3]
			fprintks 	$DUMP_FILE_NAME, "double MaxY :: \t\t\tkEnvFunctionComposite[%d][4] = %f\n", kIndex, kEnvFunctionComposite[kIndex][4]
			fprintks 	$DUMP_FILE_NAME, "double Period :: \t\tkEnvFunctionComposite[%d][5] = %f //for sinus, saw i.e. modulo\n", kIndex, kEnvFunctionComposite[kIndex][5]
			fprintks 	$DUMP_FILE_NAME, "int DistrType :: \t\tkEnvFunctionComposite[%d][6] = %f //for stochastic\n", kIndex, kEnvFunctionComposite[kIndex][6]
			fprintks 	$DUMP_FILE_NAME, "int Depth :: \t\t\tkEnvFunctionComposite[%d][7] = %f //for stochastic\n\n", kIndex, kEnvFunctionComposite[kIndex][7]
			kIndex    +=       1
		od
		
		/*
			==================================================================
			==================		define inst num 			==============
			==================================================================
		*/		
		/*
		kUnifDistrA[]    array      4.66, .66, .68
		
		;									iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[]	
		kInstrNum		get_discr_distr_k  0, 1, 4, 6, 1, kUnifDistrA
		*/		
		kInstrNum	=	3
		
		
		/*
			==================================================================
			==================		define frq diapason			==============
			==================================================================
		*/
				
		fprintks 	$DUMP_FILE_NAME, "kSmallestDelta = %f\n\n", kSmallestDelta
		
		;y = A * x + B
		;max = A * 1 + B
		;23 * max / 24 = A *( 1 - SmD) + B
		;24 * max / 24 - 23 * max / 24 = A * 1 + B - A *1 + A * SmD - B
		;max = A  + B - A + A * SmD - B
		;max  / 24 = A * SmD
		;max / (24 * SmD) = A
		;max - A = B
			
		;kMinTotalY, kMaxTotalY
		;kMinCurrY, kMaxCurrY
		
		
		kMaxCurrY		=		get_different_distrib_value_k(0, 1, kMinTotalY+kMinYDeltaScaled, kMaxTotalY-kMinYDeltaScaled, 1)
		;y = A * x + B
		;kMaxCurrY = A * 1 + B
		;kMaxCurrY - kMinYDeltaScaled = A * (1 - kSmallestDelta) + B
		;A = kMinYDeltaScaled / kSmallestDelta
		;B = kMaxCurrY - A
		;kMinCurrYLowLimit = B
		kMinCurrY		=		get_different_distrib_value_k(0, 1, kMinTotalY, (kMaxCurrY - kMinYDeltaScaled / kSmallestDelta), 1)
		
		fprintks 	$DUMP_FILE_NAME, "kMinCurrY = %f | kMaxCurrY = %f\\n", kMinCurrY, kMaxCurrY
		
		/*
		if kEnvFunctionComposite[kMotifIndex][0] == 6 then
			kEnvFunctionComposite[kMotifIndex][6] 	IntRndDistrK 	1, 1, 7, 1
			kEnvFunctionComposite[kMotifIndex][7] 	IntRndDistrK 	1, 1, 5, 1
		endif
		*/
		
		
		/*
			=======================================
			=========	next note start		=======
			=======================================
		*/
		
		;iPartType		=	p5	;{1 = theme, 2 = line, 3 = pedal, 4 = factura}

		if iPartType == 1 then
			/*
				===============================
				=========	theme 		=======
				===============================
			*/
			kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		elseif iPartType == 2 then
			/*
				===============================
				=========	line 		=======
				===============================
			*/
			kPeriod 	= gkMinPeriod * gkModi[1][0]
			kTestPeriod Markov2orderK 0, 1, 0., 1., 1, 0, gkLineRythm
			fprintks 	$DUMP_FILE_NAME, "kTestPeriod = %f\\n", kTestPeriod
		elseif iPartType == 3 then
			/*1
				===============================
				=========	pedal 		=======
				===============================
			*/
			kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		elseif iPartType == 4 then
			/*
				===============================
				=========	factura		=======
				===============================
			*/
			kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		endif
		
		
		/*
			=======================================
			=========	current motif 		=======
			=======================================
		*/
		
		kCurrMotifIndex = 0
		
		kTmpEnvFunctionComposite[] init 8
		
		kTmpEnvFunctionCompositeIndex =	0
		until kTmpEnvFunctionCompositeIndex > 7 do
			kTmpEnvFunctionComposite[kTmpEnvFunctionCompositeIndex] = kEnvFunctionComposite[kCurrMotifIndex][kTmpEnvFunctionCompositeIndex]
			kTmpEnvFunctionCompositeIndex    	+=         1
		enduntil

		;BEGIN get next free theme index
		/*
		gkThemeModus[kThemeIndex][0]    	= 	-1
		gkThemeIndexInModus[kThemeIndex][0] = 	-1
		gkThemePitch[kThemeIndex][0]    =	-1
		gkThemeStart[kThemeIndex][0]    =	-1
		gkThemeDur[kThemeIndex][0]    	=	-1
		gkThemeAmp[kThemeIndex][0]    	=	-1
		kThemeIndex    	+=         1
		
		kTmpGlobalThemeIndex = 0
		until ((kTmpGlobalThemeIndex>7)||(gkThemeModus[kThemeIndex][kTmpGlobalThemeIndex])==-1) do
			kTmpGlobalThemeIndex    	+=         1
		enduntil
		*/
		;END get next free theme index
	endif
	
	
	/*
		====================================
		============	process	============
		====================================
	*/
	
	kTimer			line 	0., p3, p3	;current time
		
	;BEGIN set Current motif
	if kEnvFunctionComposite[kCurrMotifIndex][2] < kTimer then
		kCurrMotifIndex += 1
		kTmpEnvFunctionCompositeIndex =	0
		until kTmpEnvFunctionCompositeIndex > 7 do
			kTmpEnvFunctionComposite[kTmpEnvFunctionCompositeIndex] = kEnvFunctionComposite[kCurrMotifIndex][kTmpEnvFunctionCompositeIndex]
			kTmpEnvFunctionCompositeIndex    	+=         1
		enduntil
	endif
	;END set Current motif
	
	kTrig			metro	1/kPeriod	;metro for event generating
	if kTrig == 1 then
	
		/*
			=======================================
			=========		duration 		=======
			=======================================
		*/

		kDur = kPeriod * .8
		
		
		/*
			=======================================
			=========		pitch			=======
			=======================================
		*/		
		
		/*
		kFrqIndx		IntRndDistrK 	kFrqDistrType, kFrqMin, kFrqMax, kFrqDepth
		;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
		kFrqIndxFolded	TableFolding kFoldingType, kFrqIndx, kTblLen
		;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
		kFrq	 	= 440 * kFrqMult * gkModi[3][kFrqIndxFolded]		
		;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		*/
	
		kRawVal = GetFrq(kTimer, kTmpEnvFunctionComposite)
		;kFrq = GetExp(kRawVal, 0.01, 1., kMinFrq, kMaxFrq)
		;kMidiNum = GetLine(kRawVal, 0., 1., kMinTotalY, kMaxTotalY);
		kMidiNum = GetLine(kRawVal, 0., 1., kMinCurrY, kMaxCurrY);
		kFrq = pow(2, (kMidiNum-69)/12)*440.
				
		/*
			=======================================
			=========		play 			=======
			=======================================
		*/
		kPan = get_different_distrib_value_k(0, 7, 0., 1., 1)
		event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp, kPan
		;event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
				
		
		/*
			===================================================
			=========		write to theme array		=======
			===================================================
		*/		
		
		/*
		if kTmpGlobalThemeIndex<8 then
			;...
		endif
		*/
		
		/*
			===================================================
			=========		write to midi file 			=======
			===================================================
		*/
		/*
		;moscil    kchn, knum, kvel, kdur, kpause ; send a stream of midi notes
		;kMidiNum 	ftom 	kFrq
		;log2(x) = loge(x)/loge(2)
		;m  =  12*log2(fm/440 Hz) + 69
		kMidiNum = 12 * ( log( kFrq / 440. ) / log(2) ) + 69
		*/
		moscil		iMidiChannel, kMidiNum, 80, kDur, .1 ; send a stream of midi notes
		fprintks 	$DUMP_FILE_NAME, "kMidiNum = %f\n",kMidiNum
		
		
		/*
			============================================================================
			==================		addition play 			============================
			==================		accord, reverb  etc 	============================
			============================================================================
		*/
		;accord for substractive_wov
		if kInstrNum == 5 then
		  kIndCycle1	   	init	1
		  kVowVoiceNumRnd	random 	0.5, 5.5  
		  kVowVoiceNum 	=		ceil(kVowVoiceNumRnd);
		  until kIndCycle1 >= kVowVoiceNum do
    			kIndCycle1    	+=         1
    			event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
				;fprintks 	$DUMP_FILE_NAME, "accord :: kIndCycle1 = %f \\n", kIndCycle1
  		  enduntil
		endif

		;reverb for wgbow
		/*
		if kInstrNum == 6 then
			event  		"i", kInstrNum+1, kStart, kDur, kFrq, kAmp, iPan
		endif
		*/
		
		fprintks 	$DUMP_FILE_NAME, "Event i :: Instr name = %f | kPeriod = %f | kDur = %f  | kAmp = %f  | kRawVal = %f | kFrq = %f\\n", kInstrNum, kPeriod, kDur, kAmp, kRawVal, kFrq		
	
		/*
			=======================================
			=========	next note start		=======
			=======================================
		*/

		/*
		kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
		;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
		kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
		;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
		kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
		;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		*/
		;iPartType		=	p5	;{1 = theme, 2 = line, 3 = pedal, 4 = factura}

		if iPartType == 1 then
			/*
				===============================
				=========	theme 		=======
				===============================
			*/
			kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		elseif iPartType == 2 then
			/*
				===============================
				=========	line 		=======
				===============================
			*/
			kPeriod 	= gkMinPeriod * gkModi[1][0]
			;opcode Markov2orderK, k, ikkkkkk[][]
			;iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kPrevEl, kMarkovTable[][] xin
			kTestPeriod Markov2orderK 0, 1, 0., 1., 1, kTestPeriod, gkLineRythm
			fprintks 	$DUMP_FILE_NAME, "kTestPeriod = %f\\n", kTestPeriod
		elseif iPartType == 3 then
			/*
				===============================
				=========	pedal 		=======
				===============================
			*/
			kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		elseif iPartType == 4 then
			/*
				===============================
				=========	factura		=======
				===============================
			*/
			kStartIndx		IntRndDistrK 	kStartDistrType, kStartMin, kStartMax, kStartDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kStartIndxFolded	TableFolding kStartFoldingType, kStartIndx, kStartTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		endif
		
	endif
endin


/*
	=======================================
	=========		one part 		=======
	=======================================
*/

instr part
	
	/*
		===================================================
		=========		initial var setting 		=======
		===================================================
	*/
	
	kPeriod		init 	.4 		;time between event start, now generated as gkMinPeriod * gkModi[kModTypeIndx][kIndxFolded], 
								;where gkModi is 2dim array, kModTypeIndx is type of modi, now constat (2DO change by system),
								;kIndxFolded is random generated index, scaled to modus length
								
	kStart		init 	0		;offst for event opcode, now constant 
	kDur		init 	.3		;duration of event, now is relative to kPeriod (2DO: change by system)
	kAmp		init 	.3		;amplitude of event opcode, now constant (2DO: change by system)
	kFrq		init 	440		;frequency of event
	kFrqMult	init 	1.		;base frq multiplier, now uniform random (2DO: change by system)
	
	;BEGIN var for period change 
	;change produced by generating indicies for gkModi[type] subarray 
	kiDistrType	init 	7		;type of rnd distribution see in #PATH_TO_LIB\include\math\stochastic\distribution3.inc.csd
	kiMin		init 	0		
	kiMax		init 	3	
	kDepth		init 	2	
	;END var for period change
	
	;BEGIN var for frequency change 
	;change produced by generating indicies for gkModi[type] subarray 
	kFrqDistrType	init 	5		;type of rnd distribution see in #PATH_TO_LIB\include\math\stochastic\distribution3.inc.csd
	kFrqMin			init 	0		
	kFrqMax			init 	7	
	kFrqDepth		init 	3	
	;END var for frequency change
	
	kFoldingType	init 	2	;type of scaling indicies to gkModi[type] subarray  length
	kTblLen			init 	8	;gkModi[type] subarray length

	iPan		=	p5	

	kTrig			metro	1/kPeriod	;metro for event generating
	
	kTimer			line 	0., p3, 1.	;part of whole duration of current note now

	kFlag		init 	1
	
    
	/*
		==================================================================
		==================		once at start 	 			==============
		==================================================================
	*/
	if kFlag == 1 then
			kFlag = 0
			
			/*
				==================================================================
				==================		define inst num 			==============
				==================================================================
			*/
			;iRnd1	 		random 	0.5, 6.5
			;iInstrNum		=		ceil(iRnd1);			
			;kInstrNum		IntRndDistrK 	1, 5, 6, 1
			
			/*
			kUnifDistrA[]    array      4.66, .66, .68
			;									iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[]	
			kInstrNum		get_discr_distr_k  0, 1, 4, 6, 1, kUnifDistrA
			*/
			kInstrNum	=	2
			
			
			/*
				==================================================================
				==================		define frq mult 			==============
				==================================================================
			*/
			kFrqMult	random 	.4, 3.
			
			
			/*
				==================================================================
				==================		define spatial	function	==============
				==================================================================
			*/
			/*			
			sum_num = rnd(1, $SPAT_SUM_LIMIT)
			for(i = 1, sum_num)
			{
				i,mult_num = rnd(1, $SPAT_MULT_LIMIT)
			}
			
			kEnvFunctionType = kEnvFunctionOne[0] ;{1 = linear, 2 = power, 3 = exponential, 4 = sinus, 5 = saw i.e. modulo, 6 = stochastic}
			kXmin = kEnvFunctionOne[1] = 0.01
			kXmax = kEnvFunctionOne[2] = p3
			kYmin = kEnvFunctionOne[3] = 0.01
			kYmax = kEnvFunctionOne[4] = 1.
			kPeriod = kEnvFunctionOne[5] = rnd(p3/3, 3 * p3)
			kDistrType = kEnvFunctionOne[6] = rnd(1, 8)
			kDepth = kEnvFunctionOne[7] = rnd(1, 11)
			kParamNumber = kEnvFunctionOneArray[i][j][8] = rnd(1, 4)
			
				i=1				i,j=1
				S			(	П			(kEnvFunctionOne i,j(x|y|t)	)	)
				sum_num			i,mult_num
			*/
			
			/*
			;fprintks 	$DUMP_FILE_NAME, "\ngkCurrentPart = %f\n", gkCurrentPart
			
			kiSpatDistrType = 1
			kSpatDepth = 1
			kSumNum = IntRndDistrK(kiSpatDistrType, 0, ($SPAT_SUM_LIMIT+1), kSpatDepth)
			kCntSum = 0;
			kCntMult = 0;
			until kCntSum > kSumNum do
    			kMultNum = IntRndDistrK(kiSpatDistrType, 0, ($SPAT_MULT_LIMIT+1), kSpatDepth)
				until kCntMult > kMultNum do
					gkSpat[gkCurrentPart][kCntSum][kCntMult][0] = IntRndDistrK(kiSpatDistrType, 1, 7, kSpatDepth) 			;kEnvFunctionType
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][0] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][0]
					gkSpat[gkCurrentPart][kCntSum][kCntMult][1] = $SPAT_X_MIN												;kXmin
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][1] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][1]
					
					kParamNumber	= 	IntRndDistrK(kiSpatDistrType, 1, 4, kSpatDepth)
					
					if kParamNumber == 3 then
						gkSpat[gkCurrentPart][kCntSum][kCntMult][2] = p3													;kXmax
					else 
						gkSpat[gkCurrentPart][kCntSum][kCntMult][2] = $ROOM_DIM_SM											
					endif
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][2] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][2]
					
					gkSpat[gkCurrentPart][kCntSum][kCntMult][3] = $SPAT_Y_MIN												;kYmin
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][3] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][3]
					gkSpat[gkCurrentPart][kCntSum][kCntMult][4] = $SPAT_Y_MAX												;kYmax
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][4] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][4]
					gkSpat[gkCurrentPart][kCntSum][kCntMult][5] = IntRndDistrK(kiSpatDistrType, p3/3, 3*p3, kSpatDepth)		;kPeriod	
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][5] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][5]
					gkSpat[gkCurrentPart][kCntSum][kCntMult][6] = IntRndDistrK(kiSpatDistrType, 1, 8, kSpatDepth)			;kDistrType
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][6] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][6]
					gkSpat[gkCurrentPart][kCntSum][kCntMult][7] = IntRndDistrK(kiSpatDistrType, 1, 11, kSpatDepth)			;kDepth
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][7] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][7]
					gkSpat[gkCurrentPart][kCntSum][kCntMult][8] = kParamNumber
					fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][8] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][8]
					kCntMult    	+=         1
				enduntil
				gkSpat[gkCurrentPart][kCntSum][kCntMult][0] = 0
				fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][0] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][kCntMult][0]
				kCntSum    	+=        1
				kCntMult    =         0
				;fprintks 	$DUMP_FILE_NAME, "accord :: kIndCycle1 = %f \n", kIndCycle1
			enduntil
			gkSpat[gkCurrentPart][kCntSum][0][0] = 0
			fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][0][0] = %f\n", gkCurrentPart, kCntSum, kCntMult, gkSpat[gkCurrentPart][kCntSum][0][0]
			gkCurrentPart	+=		1
			
			;fprintks 	$DUMP_FILE_NAME, "\ngkCurrentPart = %f\n", gkCurrentPart
			fprintks 	$DUMP_FILE_NAME, "\n============ from main ================\n"
			;fprintks 	$DUMP_FILE_NAME, "gkSpat[0][0][0][0] = %f\n", (gkCurrentPart-1), 0, 0, 0, gkSpat[0][0][0][0]
			kCntSum = 0;
			kCntMult = 0;
			until (gkSpat[(gkCurrentPart-1)][kCntSum][0][0] == 0) do
				until ((gkSpat[(gkCurrentPart-1)][kCntSum][kCntMult][0] == 0)||(kCntMult>($SPAT_MULT_LIMIT+1))) do
					fprintks 	$DUMP_FILE_NAME, "gkSpat[%d][%d][%d][%d] = %f\n", (gkCurrentPart-1), kCntSum, kCntMult, 0, gkSpat[(gkCurrentPart-1)][kCntSum][kCntMult][0]
					kCntMult += 1
				enduntil
				kCntSum    	+=        1
				kCntMult = 0
			enduntil
			
			;kOctVolume[] init 8
			
			;kOctVolume = GetOctVolume(gkCurrentPart-1, 1., gkSpat, gkSpeakerPos)
			;fprintks 	$DUMP_FILE_NAME, "kOctVolume[0] = %f \n", kOctVolume[0]
			*/
			
			/*
				=======================================
				=========	next note start		=======
				=======================================
			*/

			kiIndx		IntRndDistrK 	kiDistrType, kiMin, kiMax, kDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kIndxFolded	TableFolding kFoldingType, kiIndx, kTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
	endif
	
	
	if kTrig == 1 then				
		
		/*
			=======================================
			=========	next note start		=======
			=======================================
		*/

		kiIndx		IntRndDistrK 	kiDistrType, kiMin, kiMax, kDepth
		fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
		kIndxFolded	TableFolding kFoldingType, kiIndx, kTblLen
		;kIndxFolded	TableFolding kFoldingType, kiIndx, 6
		fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
		kPeriod 	= gkMinPeriod * gkModi[1][kIndxFolded]		
		fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		;kNew uniform_distr_k kiMin, kiMax
		;kNew linrnd_low_depth_k kiMin, kiMax, kDepth
		
		/*
			=======================================
			=========		duration 		=======
			=======================================
		*/

		kDur = kPeriod * .8
		
		/*
			=======================================
			=========		pitch			=======
			=======================================
		*/
		;kFrq		=		kFrq * kFrqMult
		
		
		kFrqIndx		IntRndDistrK 	kFrqDistrType, kFrqMin, kFrqMax, kFrqDepth
		;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
		kFrqIndxFolded	TableFolding kFoldingType, kFrqIndx, kTblLen
		;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
		kFrq	 	= 440 * kFrqMult * gkModi[3][kFrqIndxFolded]		
		;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		
		
		/*
			=======================================
			=========		play 			=======
			=======================================
		*/
		;event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp
		event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
		
		
		/*
			===================================================
			=========		write to midi file 			=======
			===================================================
		*/
		;moscil    kchn, knum, kvel, kdur, kpause ; send a stream of midi notes
		;kMidiNum 	ftom 	kFrq
		;log2(x) = loge(x)/loge(2)
		;m  =  12*log2(fm/440 Hz) + 69
		kMidiNum = 12 * ( log( kFrq / 440. ) / log(2) ) + 69
		;moscil		kInstrNum+1, kMidiNum, 80, kDur, .1 ; send a stream of midi notes
		
		
		/*
			============================================================================
			==================		addition play 			============================
			==================		accord, reverb  etc 	============================
			============================================================================
		*/
		;accord for substractive_wov
		if kInstrNum == 5 then
		  kIndCycle1	   	init	1
		  kVowVoiceNumRnd	random 	0.5, 5.5  
		  kVowVoiceNum 	=		ceil(kVowVoiceNumRnd);
		  until kIndCycle1 >= kVowVoiceNum do
    			kIndCycle1    	+=         1
    			event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
				;fprintks 	$DUMP_FILE_NAME, "accord :: kIndCycle1 = %f \\n", kIndCycle1
  		  enduntil
		endif

		;reverb for wgbow
		/*
		if kInstrNum == 6 then
			event  		"i", kInstrNum+1, kStart, kDur, kFrq, kAmp, iPan
		endif
		*/
		
		fprintks 	$DUMP_FILE_NAME, "Event i :: Instr name = %f | Start = %f | kDur = %f  | kAmp = %f  | kFrq = %f \\n", kInstrNum, kStart, kDur, kAmp, kFrq		
	endif
	
	
	/*
		=======================================
		=========	envelope rnd param	=======
		=========	period 				=======
		=======================================
	*/
	
	kiMin		line 	0, p3, 2
	kiMax		line 	3, p3, 5
	
	/*
		=======================================
		=========	envelope rnd param	=======
		=========	frq 				=======
		=======================================
	*/
	
	kFrqMin		line 	0, p3, 3
	kFrqMax		line 	7, p3, 5
	
	kTrigLog		metro	1

	if kTrigLog == 1 then
		fprintks 	$DUMP_FILE_NAME, "kTimer = %f :: kiMin = %f :: kiMax = %f \\n", kTimer, kiMin, kiMax
	endif
		
endin

instr simple_sin
	iAmp = p5
	iFrq = p4
	kenv      linen     1, p3/4, p3, p3/4
	aOsc1     poscil    iAmp, iFrq, giSine
			;outs      aOsc1*kenv, aOsc1*kenv
			kalpha line 0, p3, 360
			kbeta = 0
				
			; generate B format
			aw, ax, ay, az, ar, as, at, au, av bformenc1 aOsc1*kenv, kalpha, kbeta
			; decode B format for 8 channel circle loudspeaker setup
			a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

			; write audio out
			outo a1, a2, a3, a4, a5, a6, a7, a8
endin


instr test_env_instr
	kTrigLog		metro	1
	
	kTimer			line 	0., p3, 1.
	
	kfEnvMin	expseg .1, p3/3, 4.1, p3/3, 10.1, p3/3, 6.1
	kfEnvMin	=	kfEnvMin - 8.1
	kiMin		= ceil(kfEnvMin)
	
	;-8 -4 2 -2
	;+8.1
	;=
	;0.1 4.1 10.1 6.1
	
	kfEnvMax	expseg 8.1, p3/3, .1, p3/3, 4.1, p3/3, 8.1 
	;kfEnvMax	=	kfEnvMin - 7.
	kiMax		= ceil(kfEnvMax)
		
	;8.1 0.1 4.1 8.1
		
	
	if kTrigLog == 1 then
		fprintks 	$DUMP_FILE_NAME, "kTimer = %f :: kfEnvMin = %f :: kiMin = %f :: kiMax = %f \\n", kTimer, kfEnvMin, kiMin, kiMax
	endif
	
endin


</CsInstruments>
<CsScore>

;		1					2		3		4				5

;type	instr				start	len		
;i 		"part" 				0 		60		1				.5
;i 		"test_env_instr" 	0 		30
i 		"rythm_disp" 		0 		100

;type	"theme" instr 		start	len		midi channel	part type
;i 		"theme"		 		0 		5		1				2
;i 		"theme"		 		10 		20		2				2

</CsScore>
</CsoundSynthesizer>