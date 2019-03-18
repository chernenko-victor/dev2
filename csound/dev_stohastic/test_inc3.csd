<CsoundSynthesizer>
<CsOptions>
--env:SSDIR+=../SourceMaterials -d -odac -m0
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#include "c:\audio\csound\include\math\stochastic\distribution2.inc.csd"

#include "c:\audio\csound\include\sound\synthesis\phys_mod.inc.csd"

</CsInstruments>
<CsScore>

;r 3
; instr							start	len		seed	distrType	distrDepth
;i "different_distrib_note" 		0 		1		0		1			0


;r 3
; instr							start	len		seed	distrType	distrDepth
;i "different_distrib_note" 		0 		1		0		2			0


;r 3
; instr							start	len		seed	distrType	distrDepth
;i "different_distrib_note" 		0 		1		0		7			3


r 6
; instr					start	len		seed	iTypeOfDistrib	iDistribDepth
i "discr_distr" 		0 		2		0		1				-1


r 6
; instr					start	len		seed	iTypeOfDistrib	iDistribDepth
i "discr_distr" 		0 		2		0		6				3


</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
