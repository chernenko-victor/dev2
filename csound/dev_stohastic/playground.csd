<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

seed       0

giSine    ftgen     0, 0, 2^10, 10, 1

#include "C:\Users\win8\Desktop\csound\tmp\csd\include\math\stochastic\distribution3.inc.csd"
#include "C:\Users\win8\Desktop\csound\tmp\csd\include\utils\table.v1.csd"

opcode RndSplit, k[], kki
	kMin, kMax, iIntervalNumber xin
	;kSplit[] init iIntervalNumber
	;kSplit[] fillarray 1, 1, 1
	
	if iIntervalNumber<=0 then 
		iIntervalNumber = 1
	endif
	
	kSplit[] init iIntervalNumber
	kIndex	   	=	0
	kTotalLen	=	0
	
	;kSplit[kIndex]	IntRndDistrK 	1, 1, 10, 1
	until kIndex >= iIntervalNumber do
		kSplit[kIndex]	IntRndDistrK 	1, 1, 10, 1
		kTotalLen		+=	kSplit[kIndex] 
		kIndex    		+=  1
	enduntil
	
	;y = A x + B
	;kMin = B
	;kMax = A kTotalLen + B
	
	;B = kMin
	;A = (kMax - kMin) / kTotalLen
	
	;y = A x + B
	kA = (kMax - kMin) / kTotalLen
	kB = kMin
	kIndex	   	=	0
	until kIndex >= iIntervalNumber do
		kSplit[kIndex]	= 	kA * kSplit[kIndex] + kB
		kIndex    		+=  1
	enduntil
	xout kSplit
endop

instr rythm_disp
	kDur			init 	1
	kTrig			metro	1/kDur
	
	if kTrig == 1 then
		;kDur 		random 	15, 30
		;event  "i", "part", 0, kDur*2.5, kCenter, kPan
		;kSplitted[]		init	3
		kSplitted[]  	RndSplit	0, 5, 3
		fprintks 	"playground_dump.txt", "new kSplitted[]\n"
		kIndex    =        0
		until kIndex == lenarray(kSplitted) do
			;prints   "iArr[%d] = %d\n", kIndex, iArr[kIndex]
			fprintks 	"playground_dump.txt", "kSplitted[%d] = %f\n", kIndex, kSplitted[kIndex]
			kIndex    +=       1
		od
	endif
	
endin

instr simple_sin
	iAmp = p5
	iFrq = p4
	kenv      linen     1, p3/4, p3, p3/4
	aOsc1     poscil    iAmp, iFrq, giSine
			  outs      aOsc1*kenv, aOsc1*kenv
endin

</CsInstruments>
<CsScore>

	;type	instr				start	len
	i 		"rythm_disp" 		0 		10
	;i 		"simple_sin" 		0 		2		440		.5

</CsScore>
</CsoundSynthesizer>