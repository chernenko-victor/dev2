<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
#define DUMP_FILE_NAME #"cffg.txt"#
#define ALTERNATIVE_RULE_DELIM #1000000#
#define ARRAY_MAX_DIM #256#
#include "distribution3.inc.csd"
#include "table.v1.csd"
#include "t_formal_grammar3.class.csd"

giSine    ftgen     0, 0, 2^10, 10, 1
;vocabulary
/*
q -1
h -2
hd -3
w -4
wd -5
b -6
S 1
A 2
B 3
C 4
D 5
*/
gkRules[][] init  $ARRAY_MAX_DIM, $ARRAY_MAX_DIM
gkAlternativeProb[][] init  $ARRAY_MAX_DIM, $ARRAY_MAX_DIM
						  ;q 	h 	hd 	w 	wd	b
gkDuration[] fillarray 0, 1, 	2, 	3,	4,	6,	8

gkMinPeriod init 0.5

instr 2
	kFlag		init 	1
	if kFlag == 1 then
		kFlag = 0

		;Cprintks 	$DUMP_FILE_NAME, "\n========================== arrays for Formal Grammar \n"
		gkRules[0][0] = 1;S
		gkRules[0][1] = -6;b
		gkRules[0][2] = 2;
		gkRules[0][3] = $ALTERNATIVE_RULE_DELIM;|
		
		gkRules[0][4] = -4;w
		gkRules[0][5] = 3;B
		gkRules[0][6] = $ALTERNATIVE_RULE_DELIM;|
		
		gkRules[0][7] = -6
		gkRules[0][8] = 4
		
		gkRules[0][9] = 0	;0
		gkAlternativeProb[0][0]=0.33;
		gkAlternativeProb[0][1]=0.33;
		gkAlternativeProb[0][2]=0.34;
		gkAlternativeProb[0][3]=-1;
		
		gkRules[1][0]	= 2
		gkRules[1][1]	= -4
		gkRules[1][2]	= 2
		gkRules[1][3]	= $ALTERNATIVE_RULE_DELIM;|
		gkRules[1][4]	= -6
		gkRules[1][5]	= -4
		gkRules[1][6]	= -4
		gkRules[1][7]	= 3
		gkRules[1][8]	= $ALTERNATIVE_RULE_DELIM;|
		gkRules[1][9]	= -5
		gkRules[1][10]	= -2
		gkRules[1][11]	= 4
		gkRules[1][12]	= 0;0
		gkAlternativeProb[1][0]=0.2;
		gkAlternativeProb[1][1]=0.4;
		gkAlternativeProb[1][2]=0.4;
		gkAlternativeProb[1][3]=-1;
	
		
		gkRules[2][0]	= 3
		gkRules[2][1]	= 5
		gkRules[2][2]	= -1
		gkRules[2][3]	= -1
		gkRules[2][4]	= -1
		gkRules[2][5]	= -2
		gkRules[2][6]	= $ALTERNATIVE_RULE_DELIM;|
		gkRules[2][7]	= 3
		gkRules[2][8]	= -2
		gkRules[2][9]	= -2
		gkRules[2][10]	= 0;0
		gkAlternativeProb[2][0]=0.6;
		gkAlternativeProb[2][1]=0.4;
		gkAlternativeProb[2][2]=-1;
		
		
		gkRules[3][0]	= 4;C
		gkRules[3][1]	= -6;
		;gkRules[3][1]	= 5;
		gkRules[3][2]	= -4;
		gkRules[3][3]	= -2;
		gkRules[3][4]	= -2;
		gkRules[3][5]	= -4;
		gkRules[3][6]	= $ALTERNATIVE_RULE_DELIM;|
		gkRules[3][7]	= 5;B
		gkRules[3][8]	= -5;q
		gkRules[3][9]	= -2;q
		gkRules[3][10]	= 0;0
		gkAlternativeProb[3][0]=0.2;
		gkAlternativeProb[3][1]=0.8;
		gkAlternativeProb[3][2]=-1;
		
		
		gkRules[4][0]	= 5
		gkRules[4][1]	= -1
		gkRules[4][2]	= -1
		gkRules[4][3]	= -3
		gkRules[4][4]	= 4
		gkRules[4][5]	= $ALTERNATIVE_RULE_DELIM;|
		gkRules[4][6]	= 2
		gkRules[4][7]	= $ALTERNATIVE_RULE_DELIM;|
		gkRules[4][8]	= -4
		gkRules[4][9]	= -4
		gkRules[4][10]	= -6
		gkRules[4][11]	= -6
		gkRules[4][12]	= 0
		gkAlternativeProb[4][0]=0.5;
		gkAlternativeProb[4][1]=0.3;
		gkAlternativeProb[4][2]=0.2;
		gkAlternativeProb[4][3]=-1;

		;gkRules[4][0]	= 0;
		gkRules[5][0]	= 0;

	endif
endin

instr 1
	kStart		init 	0
	kFlag		init 	1
	kAmp		init 	.4
	kFinal[] init $ARRAY_MAX_DIM
	
	if kFlag == 1 then
		kFlag = 0

		kFinal[0] = 1
		kFinal[1] = 0
		kTemporary[] init $ARRAY_MAX_DIM
		kFinal = CFFG2(gkRules, gkAlternativeProb, kFinal)

		kIndex = 0
		fprintks 	$DUMP_FILE_NAME, "\n========================== final string\n"
		while kFinal[kIndex] != 0 do
			fprintks 	$DUMP_FILE_NAME, "\nkFinal[%d] = %f\n", kIndex, kFinal[kIndex]
			kIndex = kIndex + 1
		od
		
		kIndex = 0;
		kPeriod 	=  gkMinPeriod * gkDuration[-1 * kFinal[kIndex]]
	endif
	
	kTrig			metro	1/kPeriod	;metro for event generating
	if kTrig == 1 then
		if kFinal[kIndex] != 0 then
		
			/*
				=======================================
				=========	next note start		=======
				=======================================
			*/
			kIndex = kIndex + 1;
			if kFinal[kIndex] != 0 then
				;kPeriod 	= -1 * gkMinPeriod * kFinal[kIndex]
				kPeriod 	=  gkMinPeriod * gkDuration[-1 * kFinal[kIndex]]
			else
				kIndex = 0
			endif
			
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
			;kFrq = GetExp(kRawVal, 0.01, 1., kMinFrq, kMaxFrq)
			kFrq = get_different_distrib_value_k(0, 7, 15., 1500., 2)
			
			/*
				=======================================
				=========		play 			=======
				=======================================
			*/
			kPan = get_different_distrib_value_k(0, 7, 0., 1., 1)
			event  	"i", "simple_sin", kStart, kDur, kFrq, kAmp, kPan
			
			
		endif		
	endif
endin

instr simple_sin
	iAmp = p5
	iFrq = p4
	kPan = p6
	kenv      linen     1, p3/4, p3, p3/4
	aOsc1     poscil    iAmp, iFrq, giSine
	outs      aOsc1*kenv*kPan, aOsc1*kenv*(1-kPan)
endin
</CsInstruments>
<CsScore>
i 2 0 5
i 1 6 1
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
