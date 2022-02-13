<CsoundSynthesizer>
<CsOptions>
;-Q2 --midioutfile=dev_stoh_v29.mid
;-odac
;-o w192-5a.wav
;-B 16384
-B 32768
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#define DUMP_FILE_NAME #"dev_stohastic.v32.txt"#

/*
	=======================================================
	================	init instr 	=======================
	=======================================================
	
	initialize global vars there
*/

#include "..\include\math\stochastic\distribution3.inc.csd"
#include "..\include\math\stochastic\util.inc.csd"
#include "..\include\utils\table.v1.csd"


#define DUMP_FILE_NAME #"dev_stohastic.v32.txt"#


gkPartID	init 	0
gkPattern[][][] init  32, 64, 5
/*
[PartID][StepNum][kPeriod, kDur, kFrq, kAmp, iPan]
At Start New Part PartID++
*/

gkModi[][] init  9, 8
gkModi fillarray	/* natural */			1, 2, 3, 4, 5, 6, 7, 8,
					/* geom */				1, 2, 4, 8, 16, 32, 64, 128,
					/* fibon */				1, 2, 3, 5, 8, 13, 21, 34,
					/* ionian */ 			1, 1.1111, 1.25, 1.3333, 1.5, 1.6667, 1.875, 2,
					/* Phrygian */ 			1, 1.0667, 1.2, 1.3333, 1.5, 1.6, 1.8, 2,
					/* Dorian */			1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
					/* Anhemitone */		1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
					/* tone-half */			1, 1.0667, 1.2, 1.25, 1.4063, 1.5, 1.6667, 1.8, 
					/* tone-half-half */	1, 1.1111, 1.2, 1.25, 1.4063, 1.5, 1.6, 1.8
				 

gkPeriod	init 	1
;gkMinPeriod	init 	2.5
gkMinPeriod	init 	.25
;gkMinPeriod	init 	.15

gkRythmMode init 1
gkPitchMode init 7
gkInstrNum init 0
;gkInstrNum init 6

gkiDistrTypeNoteStart init 7

giDurSeedType		=		0
gkDurTypeOfDistrib	init	2
gkDurMin			init	.1
gkDurMax			init	3	
gkDurDistribDepth	init	1

seed       0

giSine    ftgen     0, 0, 2^10, 10, 1


gkTotalLen			init 0

gkFrqIndxMarkovTable[][] init  7, 7
gkFrqIndxMarkovTable array     0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 0.0,
                      0.2, 0.0, 0.2, 0.2, 0.2, 0.1, 0.1,
                      0.1, 0.1, 0.5, 0.1, 0.1, 0.1, 0.0,
                      0.0, 0.1, 0.1, 0.5, 0.1, 0.1, 0.1,
                      0.2, 0.2, 0.0, 0.0, 0.2, 0.2, 0.2,
                      0.1, 0.1, 0.0, 0.0, 0.1, 0.1, 0.6,
                      0.1, 0.1, 0.0, 0.0, 0.1, 0.6, 0.1

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
	

gkLineRythm[][] init  8, 8
gkLineRythm fillarray	0.9,	0.1,	0.,		0.,		0.,		0.,		0.,		0.,
						0.05,	0.9,	0.5,	0.,		0.,		0.,		0.,		0.,
						0.,		0.05,	0.9,	0.05,	0.,		0.,		0.,		0.,
						0.,		0.,		0.05,	0.9,	0.05,	0.,		0.,		0.,
						0.,		0.,		0.,		0.05,	0.9,	0.05,	0.,		0.,
						0.,		0.,		0.,		0.,		0.05,	0.9,	0.05,	0.,
						0.,		0.,		0.,		0.,		0.,		0.05,	0.9,	0.05,
						0.,		0.,		0.,		0.,		0.,		0.,		0.1,	0.9	

;waveforms used for granulation
giSaw   ftgen 1,0,4096,7,0,4096,1
giSq    ftgen 2,0,4096,7,0,2046,0,0,1,2046,1
giTri   ftgen 3,0,4096,7,0,2046,1,2046,0
giPls   ftgen 4,0,4096,7,1,200,1,0,0,4096-200,0
giBuzz  ftgen 5,0,4096,11,20,1,1

;window function - used as an amplitude envelope for each grain
;(hanning window)
giWFn   ftgen 7,0,16384,20,2,1


gkBtnstop init 1
gkAlgoNum init 0

/*
		=====================================================================
		====================		widget		 		=====================
		=====================================================================
*/	

#include "dev_stohastic_widget.inc.csd"


/*
		=====================================================================
		====================		sonification 		=====================
		=====================================================================
*/


;instr 1 
#include "..\include\sound\synthesis\harmonic_additive_synthesis_2ch.csd"

;instr 2 
#include "..\include\sound\synthesis\inharmonic_additive_synthesis_2ch.csd"

;instr 3 
;#include "..\include\sound\synthesis\impulse_2ch.csd"

;instr 4
#include "..\include\sound\sampler\play_audio_from_disk_2ch.csd"

;instr 5 ;substractive_wov
#include "..\include\sound\synthesis\substractive.csd"

;instr 6 ;instr wgbow_instr + inst 7 wgbow_reverb_instr
#include "..\include\sound\synthesis\wgbow.csd"

;instr 8 ;instr white_noise_my
;#include "..\include\sound\synthesis\white_noise.inc.csd"

;instr 8 ;feedback_modulation
#include "..\include\sound\synthesis\feedback_modulation_2ch.csd"

;instr 9 ;instr shepard_tone
;#include "..\include\sound\synthesis\shepard_tone.inc.csd"

;instr 9 ;granulator
#include "..\include\sound\synthesis\grain_2ch.csd"

;instr 10 ;instr filtered_noise
;#include "..\include\sound\synthesis\filtered_noise.inc.csd"

;instr 11 ;fft_stretch_pitchsfht_2ch
#include "..\include\sound\synthesis\fft_stretch_pitchsfht_2ch.csd"
				 
				 
instr 12  ; simple PM-Synth
kCarFreq = p4
;kModFreq = kCarFreq*12/7
iModFreqB random p4*12/7, p4*12/7+50
iModFreqE random p4*12/7, p4*12/7+50
kModFreq line iModFreqB, p3, iModFreqE
kModFactor = kCarFreq/kModFreq
kIndex = 12/6.28   ;  12/2pi to convert from radians to norm. table index
aEnv expseg .001, 0.001, 1, 0.3, 0.5, 8.5, .001
aModulator poscil kIndex*aEnv, kModFreq, 1
aPhase phasor kCarFreq
aCarrier tablei aPhase+aModulator, 1, 1, 0, 1
outs (aCarrier*aEnv), (aCarrier*aEnv)
endin
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
	kEnvStartSlow	linseg 150, 2*p3/3, 50, p3/3, 150
	
	gkMinPeriod		expseg 2.5, p3/2, .25, .5, 2.5, p3/2-.5, .25
	
	/*
	if kFlag == 1 then
		event  "i", "part", 0, kDur*2.5, 1, .5
		kFlag = 0
	endif
	*/
	
	if kTrig == 1 then
		gkPartID	+= 	1
		;kDur 		random 	15, 30
		kDur 		random 	kEnvStart, 30
		;kDur 		random 	kEnvStartSlow, 300
		kCenter		random 	1, 6
		kPan		random 	.1, .9
					;		type	instr	start	dur			p4			p5		p6	p7	p8 (instr num extern > 0)	p9
					event  	"i", 	"part",	0, 		kDur*2.5,	kCenter,	kPan,	0,	0,	gkInstrNum,					gkPartID
	endif
	
	gkTotalLen	linseg .0, p3, 1.
	
	aSigL, aSigR 	monitor ; read audio from output bus
	fout 			"render.wav", 4, aSigL, aSigR ;write audio to file (16bit
	;mono)
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
	
	iInstrNumExtern	=	p8
	
	iFrqIndxSeedType		=	0
	kFrqIndxTypeOfDistrib	init 1
	kFrqIndxMin				init 0
	kFrqIndxMax				init 1
	kFrqIndxDistribDepth	init 1
	kFrqIndxPrevEl			init 1
	
	kLocalPartID	=	p9
	kCurrentStep	init	0
	
		
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
			
			kInstrNum		IntRndDistrK 	1, 1, 10, 1
			;kInstrNum		IntRndDistrK 	1, 1, 11, 1
			;kInstrNum		IntRndDistrK 	1, 1, 9, 1
			
						
			;kUnifDistrA[]    array      4.66, .66, .68
			;									iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[]	
			;kInstrNum		get_discr_distr_k  0, 1, 4, 6, 1, kUnifDistrA
			
			
			;kInstrNum	=	1
			
			if iInstrNumExtern > 0 then
				kInstrNum	=	iInstrNumExtern
			endif
			
			
			
			/*
				==================================================================
				==================		define frq mult 			==============
				==================================================================
			*/
			;kFrqMult	random 	.3, 3.
			kFrqMult	random 	110., 1500.
			
			/*
				=======================================
				=========	next note start		=======
				=======================================
			*/

			kiIndx		IntRndDistrK 	kiDistrType, kiMin, kiMax, kDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
			
			kIndxFolded	TableFolding kFoldingType, kiIndx, kTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
			
			kPeriod 	= gkMinPeriod * gkModi[gkRythmMode][kIndxFolded]		
			;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
	endif
	
	
	if kTrig == 1 then				
		
		/*
			=======================================
			=========	next note start		=======
			=======================================
		*/

		kiIndx		IntRndDistrK 	gkiDistrTypeNoteStart, kiMin, kiMax, kDepth
		fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: gkiDistrTypeNoteStart = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
		kIndxFolded	TableFolding kFoldingType, kiIndx, kTblLen
		;kIndxFolded	TableFolding kFoldingType, kiIndx, 6
		fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
		kPeriod 	= gkMinPeriod * gkModi[gkRythmMode][kIndxFolded]		
		fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		;kNew uniform_distr_k kiMin, kiMax
		;kNew linrnd_low_depth_k kiMin, kiMax, kDepth
		
		/*
			=======================================
			=========		duration 		=======
			=======================================
		*/
		kDurPercent get_different_distrib_value_k 	giDurSeedType, gkDurTypeOfDistrib, gkDurMin, gkDurMax, gkDurDistribDepth	
		kDur = kPeriod * kDurPercent
		
		/*
			=======================================
			=========		pitch			=======
			=======================================
		*/
		;kFrq		=		kFrq * kFrqMult
		
		if gkAlgoNum == 0 then ;auto
			gkAlgoNum = 1
		endif
		
		if gkAlgoNum == 1 then ;1 = discrete
			kFrqIndx		IntRndDistrK 	kFrqDistrType, kFrqMin, kFrqMax, kFrqDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
			kFrqIndxFolded	TableFolding kFoldingType, kFrqIndx, kTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		elseif gkAlgoNum == 2 then ;2 markov
		    kFrqIndx Markov2orderK iFrqIndxSeedType, kFrqIndxTypeOfDistrib, kFrqIndxMin, kFrqIndxMax, kFrqIndxDistribDepth, kFrqIndxPrevEl, gkFrqIndxMarkovTable
		endif
		
		/*
		if gkBtnstop==1 then
			kFrqIndx Markov2orderK iFrqIndxSeedType, kFrqIndxTypeOfDistrib, kFrqIndxMin, kFrqIndxMax, kFrqIndxDistribDepth, kFrqIndxPrevEl, gkFrqIndxMarkovTable
		else
			kFrqIndx		IntRndDistrK 	kFrqDistrType, kFrqMin, kFrqMax, kFrqDepth
			;fprintks 	$DUMP_FILE_NAME, "IntRndDistrK :: kiDistrType = %f | kiMin = %f | kiMax = %f | kDepth = %f | kiIndx = %f \\n", kiDistrType, kiMin, kiMax, kDepth, kiIndx
		
			kFrqIndxFolded	TableFolding kFoldingType, kFrqIndx, kTblLen
			;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		endif
		*/
		
		kFrqIndxFolded	TableFolding kFoldingType, kFrqIndx, kTblLen
		;fprintks 	$DUMP_FILE_NAME, "TableFolding :: kFoldingType = %f | kiIndx = %f | kTblLen = %f | kIndxFolded = %f \\n", kFoldingType, kiIndx, kTblLen, kIndxFolded
		
		;kFrq	 	= 440 * kFrqMult * gkModi[3][kFrqIndxFolded]		
		kFrq	 	= kFrqMult * gkModi[gkPitchMode][kFrqIndxFolded]		
		;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		
		kFrqIndxPrevEl = kFrqIndx
		
		
		/*
			=======================================
			=========		play 			=======
			=======================================
		*/
		;event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp
		;					p1		p2		p3		p4	p5		p6
		event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
		
		
		if kCurrentStep < 9 then
			gkPattern[kLocalPartID][kCurrentStep][0] = kPeriod
			gkPattern[kLocalPartID][kCurrentStep][1] = kDur
			gkPattern[kLocalPartID][kCurrentStep][2] = kFrq
			gkPattern[kLocalPartID][kCurrentStep][3] = kAmp
			gkPattern[kLocalPartID][kCurrentStep][4] = iPan
			kCurrentStep	+=	1
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
		
		fprintks 	$DUMP_FILE_NAME, "Event i :: Instr name = %f | Start = %f | kDur = %f  | kAmp = %f  | kFrq = %f \\n", kInstrNum, kStart, kDur, kAmp, kFrq		
	endif
	
	
	/*
		=======================================
		=========	envelope rnd param	=======
		=========	period 				=======
		=======================================
	*/
	
	;kiMin		line 	0, p3, 2
	;kiMax		line 	3, p3, 5
	kiMin	= expseg(4, (2/3)*p3, 1, (1/3)*p3, 3)-1;
	kiMax	= expseg(6, (2/3)*p3, 3, (1/3)*p3, 8)-1;
	
	/*
		=======================================
		=========	envelope rnd param	=======
		=========	frq 				=======
		=======================================
	*/
	
	;kFrqMin		line 	0, p3, 3
	;kFrqMax		line 	7, p3, 5
	
	kFrqMin	= expseg(1, (2/3)*p3, 5, (1/3)*p3, 1)-1;
	kFrqMax	= expseg(3, (2/3)*p3, 8, (1/3)*p3, 3)-1;
	
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
			  outs      aOsc1*kenv, aOsc1*kenv
endin


/*
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
*/

</CsInstruments>
<CsScore>

;		1					2		3		4				5

;type	instr				start	len		
;i 		"part" 				0 		60		1				.5
;i 		"test_env_instr" 	0 		30
i 		"rythm_disp" 		0 		1200
;i 		"simple_sin" 		0 		100		440.			.5
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
