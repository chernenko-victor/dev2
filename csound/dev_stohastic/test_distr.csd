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

seed 0

instr rythm_disp
	kTrig			metro	.5
	kFlag init 1
	
	if kFlag == 1 then
		if p4 == 0 then
			;fprintks 	$DUMP_FILE_NAME, "=============== linear ===============\n"
			printks "=============== linear ===============\n", 2
		else
			;fprintks 	$DUMP_FILE_NAME, "=============== expoential ===============\n"
			printks "=============== expoential ===============\n", 2
		endif
		kFlag = 0
	endif
		
	if kTrig == 1 then
		;		type	instr	start	dur		p4 = distr type (0 = linear 1 = expon)
		event  	"i", 	"part",	0, 		1,		p4
	endif
	
endin

instr part
	kFlag init 1
	
	iSeedType	=	0
	kTypeOfDistrib	init	2
	kMin	init	.0001
	kMax	init	1
	
	if kFlag == 1 then
		if p4 == 0 then
			kRes  get_different_distrib_value_k 	iSeedType, kTypeOfDistrib, kMin, kMax
		else
			kRes expon_rnd_k 1
			;kRes += 10
		endif
		;fprintks 	$DUMP_FILE_NAME, "Rnd number kRes = %f\n", kRes
		kFlag = 0
	endif
	
	printks "Rnd number kRes = %f\n", 2, kRes
endin

</CsInstruments>
<CsScore>

i 		"rythm_disp" 		0 		20		0
i 		"rythm_disp" 		20 		40		1

</CsScore>
</CsoundSynthesizer>