<CsoundSynthesizer>
sr = 44100
#define DUMP_FILE_NAME #"cffg.txt"#
#include "C:\Users\win8\Desktop\csound\tmp\csd\include\math\stochastic\distribution3.inc.csd"
;vocabulary
gkRules[][] init  128, 128

		;fprintks 	$DUMP_FILE_NAME, "\n========================== arrays for Formal Grammar \n"
		gkRules[1][0]	= 3;E
		gkRules[2][0]	= 2;D
		gkRules[3][0]	= 4;F
		gkRules[4][0]	= 0;
		kTemporary[] init 128
		gkFinal = CFFG(gkRules, gkAlternativeProb, gkFinal)
</CsInstruments>