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
gkMinPeriod	init 	.5
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
	
	kFrqIndx	init 0
	kFrqIndxStep	init 0
	kFrqIndxDirect	init 0
	
    
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
			;kInstrNum	=	6
			kInstrNum		=	IntRndDistrK(1, 1, 7, 1)
			
			
			/*
				==================================================================
				==================		define frq mult 			==============
				==================================================================
			*/
			kFrqMult	random 	.4, 3.
			
			
			/*
				=======================================
				=========	next note start		=======
				=======================================
			*/

			kiIndx		= IntRndDistrK(kiDistrType, kiMin, kiMax, kDepth)
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kIndxFolded	= TableFolding(kFoldingType, kiIndx, kTblLen)
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[1][kIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
			
			/*
				=======================================
				=========	pitch				=======
				=======================================
			*/
			kFrqIndx = IntRndDistrK(kFrqDistrType, kFrqMin, kFrqMax, kFrqDepth)
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kFrqIndxFolded	= TableFolding(kFoldingType, kFrqIndx, kTblLen)
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kFrq	 	= 440 * kFrqMult * gkModi[3][kFrqIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
	endif
	
	
	if kTrig == 1 then				
		
		/*
			=======================================
			=========	next note start		=======
			=======================================
		*/

		kiIndx		= IntRndDistrK(kiDistrType, kiMin, kiMax, kDepth)
		;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
		kIndxFolded	= TableFolding(kFoldingType, kiIndx, kTblLen)
		;kIndxFolded	TableFolding kFoldingType, kiIndx, 6
		;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
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
		
		kFrqIndxStep	= IntRndDistrK(kFrqDistrType, kFrqMin, kFrqMax, kFrqDepth)
		kFrqIndxDirect	= IntRndDistrK(1, 0, 2, kFrqDepth)
		if (kFrqIndxDirect==1) then
				kFrqIndxStep *= -1
		endif
		
		kFrqIndx += kFrqIndxStep
		if kFrqIndx<0 then
			kFrqMult *= .5
		elseif kFrqIndx>kTblLen-1 then
			kFrqMult *= 2
		endif				
		if ((kFrqIndx<0)||(kFrqIndx>kTblLen-1)) then
			kFrqIndx = kFrqIndx%kTblLen
		endif
		kFrqIndx = abs(kFrqIndx)
		
		;kFrqIndx = 0
		kFrq	 	= 440 * kFrqMult * gkModi[3][kFrqIndx]
		;fprintks 	$DUMP_FILE_NAME, "kFrqIndx = %f | kFrq = %f | kFrqIndxStep =%f | kFrqIndxDirect =%f | \n", kFrqIndx, kFrq, kFrqIndxStep, kFrqIndxDirect
		
		
		/*
			=======================================
			=========		play 			=======
			=======================================
		*/
		;event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp
		
		/*
				kFundementalEndValue = kFrq + get_different_distrib_value_k(0, 1, -200., 200., 1)
				kVowelBeginValue = get_different_distrib_value_k(0, 1, 0., 1., 1)
				kVowelEndValue = get_different_distrib_value_k(0, 1, 0., 1., 1)
				kBandwidthFactorBegin = get_different_distrib_value_k(0, 1, 0., 2., 1)
				kBandwidthFactorEnd = get_different_distrib_value_k(0, 1, 0., 2., 1)
				kVoice = IntRndDistrK(1, 0, 5, 1)
				kInputSourceBegin = IntRndDistrK(1, 0, 2, 1)
				kInputSourceEnd = IntRndDistrK(1, 0, 2, 1)
		*/
		
		;event  		"i", kInstrNum, kStart, kDur, kFrq, kFundementalEndValue, kVowelBeginValue, kVowelEndValue, kBandwidthFactorBegin, kBandwidthFactorEnd, kVoice,\
		;	kInputSourceBegin, kInputSourceEnd
		
		;pause ;linear random with precedence of lower values with depth
		;IntRndDistrK 	kiDistrType, kiMin, kiMax, kDepth
		kIsPause = IntRndDistrK(5, 0, 3, 2)
		fprintks 	$DUMP_FILE_NAME, "kIsPause = %f\n", kIsPause
		
		if kIsPause!=2 then
			event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
		endif
		
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
		
		;fprintks 	$DUMP_FILE_NAME, "Event i :: Instr name = %f | Start = %f | kDur = %f  | kAmp = %f  | kFrq = %f \\n", kInstrNum, kStart, kDur, kAmp, kFrq		
	endif
	
	
	/*
		=======================================
		=========	envelope rnd param	=======
		=========	period 				=======
		=======================================
	*/
	
	;kTimer
	;get_different_distrib_value_k, k, ikkkO
    ;iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth xin
	kProbOfJump = get_different_distrib_value_k(0, 1, 0., kTimer, 1)
	
	kiMinSmooth		line 	0, p3, 2
	kiMaxSmooth		line 	3, p3, 5
	
	if kProbOfJump<=.3 then
		kiMin		=	kiMinSmooth
		kiMax		=	kiMaxSmooth
	else
		kiMin		=	IntRndDistrK(1, 0, 7, 1)
		kiMax		=	IntRndDistrK(1, kiMin, 8, 1)
	endif
	
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
		;fprintks 	$DUMP_FILE_NAME, "kTimer = %f :: kiMin = %f :: kiMax = %f \\n", kTimer, kiMin, kiMax
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
		;fprintks 	$DUMP_FILE_NAME, "kTimer = %f :: kfEnvMin = %f :: kiMin = %f :: kiMax = %f \\n", kTimer, kfEnvMin, kiMin, kiMax
	endif
	
endin


</CsInstruments>
<CsScore>

;		1					2		3		4				5

;type	instr				start	len		
;i 		"part" 				0 		60		1				.5
;i 		"test_env_instr" 	0 		30
i 		"rythm_disp" 		0 		400

;type	"theme" instr 		start	len		midi channel	part type
;i 		"theme"		 		0 		5		1				2
;i 		"theme"		 		10 		20		2				2

</CsScore>
</CsoundSynthesizer>