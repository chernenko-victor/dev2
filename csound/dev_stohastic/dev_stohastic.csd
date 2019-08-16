<CsoundSynthesizer>
<CsOptions>
;-Q2 --midioutfile=dev_stoh_v29.mid
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

/*
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
*/

gkThemeModus[0][0]    	= 	-1
gkThemeIndexInModus[0][0] = 	-1
gkThemePitch[0][0]    =	-1
gkThemeStart[0][0]    =	-1
gkThemeDur[0][0]    	=	-1
gkThemeAmp[0][0]    	=	-1


gkCurrentThemeIndex	init	0
;END prepare theme arrays	

gkLineRythm[][] init  8, 8
gkLineRythm fillarray	0.9,	0.1,	0.,		0.,		0.,		0.,		0.,		0.,
						0.05,	0.9,	0.5,	0.,		0.,		0.,		0.,		0.,
						0.,		0.05,	0.9,	0.05,	0.,		0.,		0.,		0.,
						0.,		0.,		0.05,	0.9,	0.05,	0.,		0.,		0.,
						0.,		0.,		0.,		0.05,	0.9,	0.05,	0.,		0.,
						0.,		0.,		0.,		0.,		0.05,	0.9,	0.05,	0.,
						0.,		0.,		0.,		0.,		0.,		0.05,	0.9,	0.05,
						0.,		0.,		0.,		0.,		0.,		0.,		0.1,	0.9	
	
/*
		=====================================================================
		====================		widget		 		=====================
		=====================================================================
*/	

/*
FLpanel "Dev2", 450, 550, 100, 100 ;***** start of container
	FLgroup "Modus Select", 200, 200, 10, 10	
		;gk1, iha 		FLslider "FLslider 1", 500, 1000, 0 ,1, -1, 300,15, 20,50
		gkVol, iHdlVol	FLslider "Volume", .001, .99, 1, 2, idisp, iwidth, \
			iheight, ix, iy
	FLgroupEnd
FLpanelEnd ;***** end of container
*/
/*
FLpanel "Dev2", 900, 500, 10, 10
	FLgroup "Modus Select", 200, 200, 10, 10
		; Width of the value display box in pixels
		iwidth = 50
		; Height of the value display box in pixels
		iheight = 20
		; Distance of the left edge of the value display
		; box from the left edge of the panel
		ix = 65
		; Distance of the top edge of the value display
		; box from the top edge of the panel
		iy = 55

		idisp FLvalue "Hertz", iwidth, iheight, ix, iy
		;kout, ihandle FLslider "label", imin, imax, iexp, itype, idisp, iwidth, iheight, ix, iy
		gkfreq, ihandle FLslider "Frequency", 200, 5000, -1, 5, idisp, 750, 30, 125, 50
		FLsetVal_i 500, ihandle
	FLgroupEnd
; End of panel contents
FLpanelEnd
*/

FLpanel "Dev2", 900, 700, 10, 10
;	FLgroup "Modus Select", 200, 200, 20, 20
		; Minimum value output by counter
		imin = 0
		; Maximum value output by counter
		imax = 8
		; Single arrow step size (semitones)
		istep1 = 1
		; Double arrow step size (octave)
		istep2 = 1 
		; Counter type (1=double arrow counter)
		itype = 1
		; Width of the counter in pixels
		iwidth = 150
		; Height of the counter in pixels
		iheight = 30
		; Distance of the left edge of the counter
		; from the left edge of the panel
		ix = 20
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iy = 20
		; Score event type (-1=ignored)
		iopcode = -1
		gkRythmMode, iHdlRythmMode FLcount "Rythm Mode Number", imin, imax, istep1, istep2, itype, iwidth, iheight, ix, iy, iopcode
		
		
		; Distance of the left edge of the counter
		; from the left edge of the panel
		iPitchModX = 200
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iPitchModY = 20
		; Score event type (-1=ignored)
		iopcode = -1
		gkPitchMode, iHdlPitchMode FLcount "Pitch Mode Number", imin, imax, istep1, istep2, itype, iwidth, iheight, iPitchModX, iPitchModY, iopcode
		
		
		; Minimum value output by the text box
		iFreqTxtMin = 200
		; Maximum value output by the text box
		iFreqTxtMax = 5000
		; Step size
		iFreqTxtStep = 1
		; Text box graphic type
		iFreqTxtType = 1
		; Width of the text box in pixels
		iFreqTxtWidth = 70
		; Height of the text box in pixels
		iFreqTxtHeight = 30
		; Distance of the left edge of the text box 
		; from the left edge of the panel
		iFreqTxtX = 400
		; Distance of the top edge of the text box
		; from the top edge of the panel
		iFreqTxtY = 20
		gkFreqTxtVal, iHdlFreqTxt FLtext "Resonans Frequency", iFreqTxtMin, iFreqTxtMax, iFreqTxtStep, iFreqTxtType, iFreqTxtWidth, iFreqTxtHeight, iFreqTxtX, iFreqTxtY
		
		
		iDispFreqKnobValWidth = 50
		iDispFreqKnobValHeight = 20
		iDispFreqKnobValX = 500
		iDispFreqKnobValY = 20
		iDispFreqKnobVal FLvalue "Hertz", iDispFreqKnobValWidth, iDispFreqKnobValHeight, iDispFreqKnobValX, iDispFreqKnobValY
		
		; Minimum value output by the knob
		iFreqMin = 200
		; Maximum value output by the knob
		iFreqMax = 5000
		; Logarithmic type knob selected
		iFreqExp = -1
		; Knob graphic type (1=3D knob)
		iFreqType = 1 
		; Display handle (-1=not used)
		iFreqDisp = iDispFreqKnobVal
		; Width of the knob in pixels
		iFreqWidth = 70
		; Distance of the left edge of the knob 
		; from the left edge of the panel
		iFreqX = 550
		; Distance of the top edge of the knob 
		; from the top of the panel
		iFreqY = 20
		gkFreqKnobVal, iHdlFreqKnob FLknob "Fundamental Frequency", iFreqMin, iFreqMax, iFreqExp, iFreqType, iFreqDisp, iFreqWidth, iFreqX, iFreqY
		
		
		; Minimum value output by counter
		iInstrNumMin = 0
		; Maximum value output by counter
		iInstrNumMax = 10
		; Single arrow step size (semitones)
		iInstrNumStep1 = 1
		; Double arrow step size (octave)
		iInstrNumStep2 = 1 
		; Counter type (1=double arrow counter)
		iInstrNumType = 1
		; Width of the counter in pixels
		iInstrNumWidth = 150
		; Height of the counter in pixels
		iInstrNumHeight = 30
		; Distance of the left edge of the counter
		; from the left edge of the panel
		iInstrNumX = 650
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iInstrNumY = 20
		; Score event type (-1=ignored)
		iInstrNumOpcode = -1
		gkInstrNum, iHdlInstrNum FLcount "Instrument Number", iInstrNumMin, iInstrNumMax, iInstrNumStep1, iInstrNumStep2, iInstrNumType, iInstrNumWidth, \
		iInstrNumHeight, iInstrNumX, iInstrNumY, iInstrNumOpcode
		
		
		iDispQValWidth = 50
		iDispQHeight = 20
		iDispQValX = 20
		iDispQValY = 150
		iHdlDispQVal FLvalue "Q", iDispQValWidth, iDispQHeight, iDispQValX, iDispQValY
		
		; Minimum value output by the slider
		iQmin = 0.01
		; Maximum value output by the slider
		iQmax = .9
		; Logarithmic type slider selected
		iQexp = -1
		; Slider graphic type (5='nice' slider)
		iQtype = 5 
		; Display handle (-1=not used)
		iQdisp = iHdlDispQVal
		; Width of the slider in pixels
		iQwidth = 80
		; Height of the slider in pixels
		iQheight = 30
		; Distance of the left edge of the slider
		; from the left edge of the panel
		iQx = 100
		; Distance of the top edge of the slider 
		; from the top edge of the panel
		iQy = 150
		gkQ, iHdlQ FLslider "Quality factor", iQmin, iQmax, iQexp, iQtype, iQdisp, iQwidth, iQheight, iQx, iQy
		
		
		iDispQ2ValWidth = 50
		iDispQ2Height = 20
		iDispQ2ValX = 200
		iDispQ2ValY = 150
		iHdlDispQ2Val FLvalue "Q2", iDispQ2ValWidth, iDispQ2Height, iDispQ2ValX, iDispQ2ValY
		
		; Minimum value output by the slider
		iQ2min = 0.01
		; Maximum value output by the slider
		iQ2max = .9
		; Logarithmic type slider selected
		iQ2exp = -1
		; Slider graphic type (5='nice' slider)
		iQ2type = 5 
		; Display handle (-1=not used)
		iQ2disp = iHdlDispQ2Val
		; Width of the slider in pixels
		iQ2width = 80
		; Height of the slider in pixels
		iQ2height = 30
		; Distance of the left edge of the slider
		; from the left edge of the panel
		iQ2x = 250
		; Distance of the top edge of the slider 
		; from the top edge of the panel
		iQ2y = 150
		gkQ2, iHdlQ2 FLslider "Quality factor2", iQ2min, iQ2max, iQ2exp, iQ2type, iQ2disp, iQ2width, iQ2height, iQ2x, iQ2y
		
		
		iBtnon = 0
		iBtnoff = 0
		iBtntype = 1
		iBtnwidth = 50
		iBtnheight = 50
		iBtnx = 10
		iBtny = iQ2y + iQ2height + 50
		iBtnopcode = 0
		iBtnstarttim = 0
		iBtndur = -1  ;Turn instruments on idefinitely

		; Normal speed forwards
		gkBtnplay, ihBtnb1 FLbutton "@>", iBtnon, iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx, iBtny, iBtnopcode, 1, iBtnstarttim, iBtndur, 1 
		; Stationary 
		gkBtnstop, ihBtnb2 FLbutton "@square", iBtnon,iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx+55, iBtny, iBtnopcode, 2, iBtnstarttim, iBtndur
		; Double speed backwards
		gkBtnrew, ihBtnb3 FLbutton "@<<", iBtnon, iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx + 110, iBtny, iBtnopcode, 1, iBtnstarttim, iBtndur, -2
		; Double speed forward
		gkBtnff, ihBtnb4 FLbutton "@>>", iBtnon, iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx+165, iBtny, iBtnopcode, 1, iBtnstarttim, iBtndur, 2
		; Type 1
		gkBtnt1, ihBtnt1 FLbutton "More Expression", iBtnon, iBtnoff, 1, 200, 40, iBtnx, iBtny + 65, -1 
		; Type 2
		gkBtnt2, ihBtnt2 FLbutton "Bang Env", iBtnon, iBtnoff, 2, 200, 40, iBtnx, iBtny + 110, -1 
		; Type 3
		gkBtnt3, ihBtnt3 FLbutton "Toggle function", iBtnon, iBtnoff, 3, 200, 40, iBtnx, iBtny + 155, -1 
		; Type 4
		gkBtnt4, ihBtnt4 FLbutton "Test Env", iBtnon, iBtnoff, 4, 200, 40, iBtnx, iBtny + 200, -1 
		; Type 21
		gkBtnt5, ihBtnt5 FLbutton "Expression Breakpoint", iBtnon, iBtnoff, 21, 200, 40, iBtnx, iBtny + 245, -1 
		; Type 22
		gkBtnt6, ihBtnt6 FLbutton "Amp Envelope Breakpoint", iBtnon, iBtnoff, 22, 200, 40, iBtnx, iBtny + 290, -1
		; Type 23
		gkBtnt7, ihBtnt7 FLbutton "Panic", iBtnon, iBtnoff, 23, 200, 40, iBtnx, iBtny + 335, -1
		
;	FLgroupEnd
; End of panel contents
FLpanelEnd
FLrun ;***** runs the widget thread, it is always required!

FLsetVal_i 1, iHdlRythmMode
FLsetVal_i 7, iHdlPitchMode
FLsetVal_i 300, iHdlFreqKnob
FLsetVal_i 300, iHdlFreqTxt
FLsetVal_i 0, iHdlFreqTxt
FLsetVal_i 0.5, iHdlQ
FLsetVal_i 0.5, iHdlQ2


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
#include "..\include\sound\synthesis\impulse_2ch.csd"

;instr 4
#include "..\include\sound\sampler\play_audio_from_disk_2ch.csd"

;instr 5 ;substractive_wov
#include "..\include\sound\synthesis\substractive.csd"

;instr 6 ;instr wgbow_instr + inst 7 wgbow_reverb_instr
#include "..\include\sound\synthesis\wgbow.csd"

;instr 8 ;instr white_noise_my
#include "..\include\sound\synthesis\white_noise.inc.csd"

;instr 9 ;instr shepard_tone
#include "..\include\sound\synthesis\shepard_tone.inc.csd"

;instr 10 ;instr filtered_noise
#include "..\include\sound\synthesis\filtered_noise.inc.csd"
				 
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
	
	/*
	if kFlag == 1 then
		event  "i", "part", 0, kDur*2.5, 1, .5
		kFlag = 0
	endif
	*/
	
	if kTrig == 1 then
		;kDur 		random 	15, 30
		kDur 		random 	kEnvStart, 30
		;kDur 		random 	kEnvStartSlow, 300
		kCenter		random 	1, 6
		kPan		random 	.1, .9
					;		type	instr	start	dur			p4			p5		p6	p7	p8 (instr num extern > 0)
					event  	"i", 	"part",	0, 		kDur*2.5,	kCenter,	kPan,	0,	0,	gkInstrNum
	endif
	
endin


/*
EnvFunctionType:|	1 = linear	| 2 = power	|	3 = exponential	|	4 = sinus	|	5 = saw i.e. modulo	|	6 = stochastic	|
----------------------------------------------------------------------------------------------------------------------------
iPartType	\/	|				|			|					|				|						|					|
----------------------------------------------------------------------------------------------------------------------------
1 = theme		|		C		|	
----------------------------------------------------------------------------------------------------------------------------
2 = line		|
----------------------------------------------------------------------------------------------------------------------------
3 = pedal		|
----------------------------------------------------------------------------------------------------------------------------
4 = factura		|
----------------------------------------------------------------------------------------------------------------------------
*/

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
	
	
	
	;kMinTotalY				init 1
	;kMinTotalY				init 16
	kMinTotalY		=		p6
	
	;kMaxTotalY				init 127
	;kMaxTotalY				init 108
	kMaxTotalY		=		p7
	
	kMinYDelta				init 1
	kMinYDeltaScaled		init 1
	;kMinYFrameScaled		init 3
	
	/*
		==================================================================
		==================			once at start 	 		==============
		==================================================================
	*/
	if kFlag == 1 then
		kFlag = 0
		
		/*
			==================================================================
			==================		generate frq profile 		==============
			==================================================================
		*/
	
		/*
		kEnvFunctionComposite[kMotifIndex][0] <- TEnvFunctionType EFType ;[int], EnvFunctionType {1 = linear, 2 = power, 3 = exponential, 4 = sinus, 5 = saw i.e. modulo, 6 = stochastic};
		kEnvFunctionComposite[kMotifIndex][1] <- double MinX ;motif begin, [float], sec
		kEnvFunctionComposite[kMotifIndex][2] <- double MaxX ;motif end, [float], sec
		kEnvFunctionComposite[kMotifIndex][3] <- double MinY ;minimum value, [int], kMinTotalY...kMaxTotalY 
		kEnvFunctionComposite[kMotifIndex][4] <- double MaxY ;maximum value, [int], kMinTotalY...kMaxTotalY
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
		until kMotifIndex >= kMotifNum do
			if iPartType == 2 then
				/*
					===============================
					=========	line 		=======
					===============================
				*/
				kEnvFunctionComposite[kMotifIndex][0]  	IntRndDistrK 	1, 1, 6, 1
			else
				;kEnvFunctionComposite[kMotifIndex][0]  	IntRndDistrK 	1, 1, 7, 1
				kEnvFunctionComposite[kMotifIndex][0]  	=	1
			endif
			kEnvFunctionComposite[kMotifIndex][1]	=		kCurrMinX
			kEnvFunctionComposite[kMotifIndex][2]	=		kCurrMaxX
			
			kDirection = IntRndDistrK(1, 0, 2, 1)
			if iPartType == 4 then
				/*
					===============================
					=========	factura		=======
					===============================
				*/
				kEnvFunctionComposite[kMotifIndex][3] = IntRndDistrK(1, kMinTotalY+kMinYDeltaScaled, kMaxTotalY-kMinYDeltaScaled+1, 1)
				if kDirection>0 then ;up
					kFActuraY = min(kMaxTotalY-kMinYDeltaScaled+1, kEnvFunctionComposite[kMotifIndex][3]+3)
					kEnvFunctionComposite[kMotifIndex][4] = IntRndDistrK(1, kEnvFunctionComposite[kMotifIndex][3], kFActuraY, 1)
				else ;down
					kFActuraY = max(kMaxTotalY-kMinYDeltaScaled+1, kEnvFunctionComposite[kMotifIndex][3]-3)
					kEnvFunctionComposite[kMotifIndex][4] =	IntRndDistrK(1, kFActuraY, kEnvFunctionComposite[kMotifIndex][3], 1)
				endif
			elseif iPartType == 1 then
				/*
					===============================
					=========	theme 		=======
					===============================
				*/
				kEnvFunctionComposite[kMotifIndex][3] = IntRndDistrK(1, kMinTotalY+kMinYDeltaScaled, kMaxTotalY-kMinYDeltaScaled+1, 1)				
				
				kAcoeff = -1 * pow(-1, kDirection) * kMinYDelta / gkMinPeriod
				kBcoeff = kEnvFunctionComposite[kMotifIndex][3] - kAcoeff * kEnvFunctionComposite[kMotifIndex][1]
				;kLimitMaxY = round(kAcoeff * kEnvFunctionComposite[kMotifIndex][2] + kBcoeff)
				kLimitMaxY = kAcoeff * kEnvFunctionComposite[kMotifIndex][2] + kBcoeff
								
				kDispersionY = IntRndDistrK(1, 0, 2, 1)
				if kDirection>0 then ;up
					;kEnvFunctionComposite[kMotifIndex][4] = IntRndDistrK(1, kEnvFunctionComposite[kMotifIndex][3]+kMinYDeltaScaled, kMaxTotalY+1, 1)
					
					;if kMaxTotalY<kLimitMaxY then
					;	kLimitMaxYHigh = kLimitMaxY+IntRndDistrK(1, 3, 12, 1)
					;else
					;	kLimitMaxYHigh = kMaxTotalY
					;endif
					;kEnvFunctionComposite[kMotifIndex][4] = IntRndDistrK(1, kLimitMaxY, kLimitMaxY+kDispersionY+1, 1)
					kEnvFunctionComposite[kMotifIndex][4] = kLimitMaxY
					fprintks 	$DUMP_FILE_NAME, "up\n"
				else ;down
					;if kMinTotalY>kLimitMaxY then
					;	kLimitMaxYHigh = kLimitMaxY-IntRndDistrK(1, 3, 12, 1)
					;else
					;	kLimitMaxYHigh = kMinTotalY
					;endif
					;kEnvFunctionComposite[kMotifIndex][4] =	IntRndDistrK(1, kLimitMaxY-kDispersionY, kLimitMaxY+1, 1)
					kEnvFunctionComposite[kMotifIndex][4] =	kLimitMaxY
					fprintks 	$DUMP_FILE_NAME, "down\n"
				endif
				fprintks 	$DUMP_FILE_NAME, "Limit :: kAcoeff = %f\tkBcoeff = %f\n\tkLimitMaxY = %f\kDispersionY = %f\tkEnvFunctionComposite[kMotifIndex][3] = %f\n\tkEnvFunctionComposite[kMotifIndex][4] = %f\n", \
				kAcoeff, kBcoeff, kLimitMaxY, kDispersionY, kEnvFunctionComposite[kMotifIndex][3], kEnvFunctionComposite[kMotifIndex][4]
			else 
				/*
					===============================
					=========	line 		=======
					===============================
				*/
				/*
					===============================
					=========	pedal 		=======
					===============================
				*/
				kEnvFunctionComposite[kMotifIndex][3] = IntRndDistrK(1, kMinTotalY+kMinYDeltaScaled, kMaxTotalY-kMinYDeltaScaled+1, 1)				
				if kDirection>0 then ;up
					kEnvFunctionComposite[kMotifIndex][4] = IntRndDistrK(1, kEnvFunctionComposite[kMotifIndex][3]+kMinYDeltaScaled, kMaxTotalY+1, 1)
				else ;down
					kEnvFunctionComposite[kMotifIndex][4] =	IntRndDistrK(1, kMinTotalY, kEnvFunctionComposite[kMotifIndex][3]-kMinYDeltaScaled+1, 1)
				endif
			endif			

			;period if sin or saw func type
			if ((kEnvFunctionComposite[kMotifIndex][0] == 4) || (kEnvFunctionComposite[kMotifIndex][0] == 5))  then
				kEnvFunctionComposite[kMotifIndex][5] = get_different_distrib_value_k(0, 1, (kCurrMaxX-kCurrMinX)/3, kCurrMaxX-kCurrMinX, 1)
			else
				kEnvFunctionComposite[kMotifIndex][5] = 0;
			endif
			
			;distribution type and depth if stochastic func type
			if kEnvFunctionComposite[kMotifIndex][0] == 6 then
				kEnvFunctionComposite[kMotifIndex][6] 	IntRndDistrK 	1, 1, 7, 1
				kEnvFunctionComposite[kMotifIndex][7] 	IntRndDistrK 	1, 1, 5, 1
			else
				kEnvFunctionComposite[kMotifIndex][6] = 0
				kEnvFunctionComposite[kMotifIndex][7] = 0
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
		;kInstrNum	=	4
		kInstrNum	=	IntRndDistrK(1, 1, 7, 1)

	
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
			;opcode Markov2orderK, k, ikkkkkk[][]
			;iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kPrevEl, kMarkovTable[][] xin
			kStartIndxFolded = Markov2orderK(0, 1, 0., 1., 1, 0, gkLineRythm)
			fprintks 	$DUMP_FILE_NAME, "Markov::kStartIndxFolded = %f\\n", kStartIndxFolded
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]
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
		
		/*
		kTmpEnvFunctionCompositeIndex =	0
		;until kTmpEnvFunctionCompositeIndex > 7 do
		until kTmpEnvFunctionCompositeIndex == lenarray(kTmpEnvFunctionComposite) do
			fprintks 	$DUMP_FILE_NAME, "kTmpEnvFunctionCompositeIndex = %d kEnvFunctionComposite[kCurrMotifIndex][kTmpEnvFunctionCompositeIndex] = %f\\n", kTmpEnvFunctionCompositeIndex, kEnvFunctionComposite[kCurrMotifIndex][kTmpEnvFunctionCompositeIndex]
			kTmpEnvFunctionComposite[kTmpEnvFunctionCompositeIndex] = kEnvFunctionComposite[kCurrMotifIndex][kTmpEnvFunctionCompositeIndex]
			kTmpEnvFunctionCompositeIndex    	+=         1
		enduntil
		*/
		
		kTmpEnvFunctionComposite[0] = kEnvFunctionComposite[kCurrMotifIndex][0]
		kTmpEnvFunctionComposite[1] = kEnvFunctionComposite[kCurrMotifIndex][1]
		kTmpEnvFunctionComposite[2] = kEnvFunctionComposite[kCurrMotifIndex][2]
		kTmpEnvFunctionComposite[3] = kEnvFunctionComposite[kCurrMotifIndex][3]
		kTmpEnvFunctionComposite[4] = kEnvFunctionComposite[kCurrMotifIndex][4]
		kTmpEnvFunctionComposite[5] = kEnvFunctionComposite[kCurrMotifIndex][5]
		kTmpEnvFunctionComposite[6] = kEnvFunctionComposite[kCurrMotifIndex][6]
		kTmpEnvFunctionComposite[7] = kEnvFunctionComposite[kCurrMotifIndex][7]
		

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
		
		; ====================================== /2
	endif
	
	
	/*
		====================================
		============	k-rate	============
		====================================
	*/
	
	kTimer			line 	0., p3, p3	;current time
	
	
	/*
		============================================
		============	change motif 	============
		============================================
	*/
	/*
	;BEGIN set Current motif
	if kEnvFunctionComposite[kCurrMotifIndex][2] < kTimer then
		kCurrMotifIndex += 1
		kTmpEnvFunctionCompositeIndex =	0
		;until kTmpEnvFunctionCompositeIndex > 7 do
		until kTmpEnvFunctionCompositeIndex == lenarray(kTmpEnvFunctionComposite) do 
			kTmpEnvFunctionComposite[kTmpEnvFunctionCompositeIndex] = kEnvFunctionComposite[kCurrMotifIndex][kTmpEnvFunctionCompositeIndex]
			kTmpEnvFunctionCompositeIndex    	+=         1
		enduntil
	endif
	;END set Current motif
	*/
	
	;BEGIN set Current motif
	if kEnvFunctionComposite[kCurrMotifIndex][2] < kTimer then
		kCurrMotifIndex += 1		 
		kTmpEnvFunctionComposite[0] = kEnvFunctionComposite[kCurrMotifIndex][0]
		kTmpEnvFunctionComposite[1] = kEnvFunctionComposite[kCurrMotifIndex][1]
		kTmpEnvFunctionComposite[2] = kEnvFunctionComposite[kCurrMotifIndex][2]
		kTmpEnvFunctionComposite[3] = kEnvFunctionComposite[kCurrMotifIndex][3]
		kTmpEnvFunctionComposite[4] = kEnvFunctionComposite[kCurrMotifIndex][4]
		kTmpEnvFunctionComposite[5] = kEnvFunctionComposite[kCurrMotifIndex][5]
		kTmpEnvFunctionComposite[6] = kEnvFunctionComposite[kCurrMotifIndex][6]
		kTmpEnvFunctionComposite[7] = kEnvFunctionComposite[kCurrMotifIndex][7]
		
	endif
	;END set Current motif
	
	kTrig			metro	1/kPeriod	;metro for event generating
	
	/*
		========================================================
		============	next event triggered 	================
		========================================================
	*/
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
		
		fprintks 	$DUMP_FILE_NAME, "EnvFunctionType :: \t\tkkTmpEnvFunctionComposite[0] = %f\n", kTmpEnvFunctionComposite[0]
		fprintks 	$DUMP_FILE_NAME, "double MinX :: \t\t\tkTmpEnvFunctionComposite[1] = %f\n", kTmpEnvFunctionComposite[1]
		fprintks 	$DUMP_FILE_NAME, "double MaxX :: \t\t\tkTmpEnvFunctionComposite[2] = %f\n", kTmpEnvFunctionComposite[2]
		fprintks 	$DUMP_FILE_NAME, "double MinY :: \t\t\tkTmpEnvFunctionComposite[3] = %f\n", kTmpEnvFunctionComposite[3]
		fprintks 	$DUMP_FILE_NAME, "double MaxY :: \t\t\tkTmpEnvFunctionComposite[4] = %f\n", kTmpEnvFunctionComposite[4]
		fprintks 	$DUMP_FILE_NAME, "double Period :: \t\tkTmpEnvFunctionComposite[5] = %f //for sinus, saw i.e. modulo\n", kTmpEnvFunctionComposite[5]
		fprintks 	$DUMP_FILE_NAME, "int DistrType :: \t\tkTmpEnvFunctionComposite[6] = %f //for stochastic\n", kTmpEnvFunctionComposite[6]
		fprintks 	$DUMP_FILE_NAME, "int Depth :: \t\t\tkTmpEnvFunctionComposite[7] = %f //for stochastic\n\n", kTmpEnvFunctionComposite[7]
		
		kMidiNum = GetFrq(kTimer, kTmpEnvFunctionComposite)
		;fprintks 	$DUMP_FILE_NAME, "kMidiNum = %f\n",kMidiNum
		kFrq = pow(2, (kMidiNum-69)/12)*440.
				
		/*
			=======================================
			=========		play 			=======
			=======================================
		*/
		kPan = get_different_distrib_value_k(0, 7, 0., 1., 1)
		;event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp, kPan
		event  		"i", kInstrNum, kStart, kDur, kFrq, kAmp, iPan
				
		
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
		
		fprintks 	$DUMP_FILE_NAME, "Event i :: Instr name = %f | kPeriod = %f | kDur = %f  | kAmp = %f  | kMidiNum = %f | kFrq = %f\\n", kInstrNum, kPeriod, kDur, kAmp, kMidiNum, kFrq		
	
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
			;opcode Markov2orderK, k, ikkkkkk[][]
			;iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kPrevEl, kMarkovTable[][] xin
			kStartIndxFolded Markov2orderK 0, 1, 0., 1., 1, kStartIndxFolded, gkLineRythm
			fprintks 	$DUMP_FILE_NAME, "Markov::kStartIndxFolded = %f\\n", kStartIndxFolded
			kPeriod 	= gkMinPeriod * gkModi[1][kStartIndxFolded]
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
	
	iInstrNumExtern	=	p8
	
	
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
			kInstrNum		IntRndDistrK 	1, 1, 11, 1
			
						
			;kUnifDistrA[]    array      4.66, .66, .68
			;									iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[]	
			;kInstrNum		get_discr_distr_k  0, 1, 4, 6, 1, kUnifDistrA
			
			
			;kInstrNum	=	9
			
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
			
			;kPeriod 	= gkMinPeriod * gkModi[gkRythmMode][kIndxFolded]		
			kPeriod = gkMinPeriod * TableExtrapolate(gkModi, gkRythmMode, kiIndx, kTblLen)
			
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
		
		;kPeriod 	= gkMinPeriod * gkModi[gkRythmMode][kIndxFolded]		
		kPeriod = gkMinPeriod * TableExtrapolate(gkModi, gkRythmMode, kiIndx, kTblLen)
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
		
		;kFrq	 	= 440 * kFrqMult * gkModi[3][kFrqIndxFolded]		
		kFrq	 	= kFrqMult * gkModi[gkPitchMode][kFrqIndxFolded]		
		;fprintks 	$DUMP_FILE_NAME, ":: kPeriod = %f \\n", kPeriod
		
		
		/*
			=======================================
			=========		play 			=======
			=======================================
		*/
		;event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp
		;					p1		p2		p3		p4	p5		p6
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
	
	;kiMin		line 	0, p3, 2
	;kiMax		line 	3, p3, 5
	kiMin	= expseg(4, (2/3)*p3, 1, (1/3)*p3, 3)-1;
	;kiMax	= expseg(6, (2/3)*p3, 3, (1/3)*p3, 8)-1;
	kiMax	= expseg(6, (2/3)*p3, 3, (1/3)*p3, 10)-1;
	
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

;for live performance
;i 		"rythm_disp" 		0 		3600

;for test
i 		"rythm_disp" 		0 		100

;i 		"simple_sin" 		0 		100		440.			.5

;		1					2		3		4				5			6			7		
;type	"theme" instr 		start	len		midi channel	part type	minMidi		maxMidi
;i 		"theme"		 		0 		20		1				1			40			84
;i 		"theme"		 		25 		10		2				1			52			72

</CsScore>
</CsoundSynthesizer>