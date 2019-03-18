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


;****DEFINITIONS FOR NOTES****
 ;notes as proportions and a base frequency
giNotes[]  array      1, 9/8, 6/5, 5/4, 4/3, 3/2, 5/3
giBasFreq  =          330
 ;probability of notes as markov matrix:
  ;first -> only to third and fourth
  ;second -> anywhere without self
  ;third -> strong probability for repetitions
  ;fourth -> idem
  ;fifth -> anywhere without third and fourth
  ;sixth -> mostly to seventh
  ;seventh -> mostly to sixth
giProbNotes[][] init  7, 7
giProbNotes array     0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 0.0,
                      0.2, 0.0, 0.2, 0.2, 0.2, 0.1, 0.1,
                      0.1, 0.1, 0.5, 0.1, 0.1, 0.1, 0.0,
                      0.0, 0.1, 0.1, 0.5, 0.1, 0.1, 0.1,
                      0.2, 0.2, 0.0, 0.0, 0.2, 0.2, 0.2,
                      0.1, 0.1, 0.0, 0.0, 0.1, 0.1, 0.6,
                      0.1, 0.1, 0.0, 0.0, 0.1, 0.6, 0.1

;****SET FIRST NOTE AND DURATION FOR MARKOV PROCESS****
giPrevNote init       1

;****INSTRUMENT FOR DURATIONS****
  instr trigger_note
;kTrig      metro      1/gkDurs[gkPrevDur]
kTrig      metro      .3
 if kTrig == 1 then
           event      "i", "select_note", 0, 1
;gkPrevDur  Markovk    gkProbDurs, gkPrevDur
 endif
  endin

;****INSTRUMENT FOR PITCHES****
  instr select_note
 ;choose next note according to markov matrix and previous note
 ;and write it to the global variable for (next) previous note
giPrevNote Markov2order     /* iSeedType */ 0, /* iTypeOfDistrib */ 1, /* iMin */ 0, /* iMax */ 1, /* iDistribDepth */ 0, giPrevNote, giProbNotes
 ;call instr to play this note
           event_i    "i", "play_note", 0, 2, giPrevNote
 ;turn off this instrument
           turnoff
  endin

;****INSTRUMENT TO PERFORM ONE NOTE****
  instr play_note
 ;get note as index in ginotes array and calculate frequency
iNote      =          p4
iFreq      =          giBasFreq * giNotes[iNote]
 ;random choice for mode filter quality and panning
iQ         random     10, 200
iPan       random     0.1, .9
 ;generate tone and put out
aImp       mpulse     1, p3
aOut       mode       aImp, iFreq, iQ
aL, aR     pan2       aOut, iPan
           outs       aL, aR
  endin
  
  
</CsInstruments>
<CsScore>

;  instr				start	len		seed	iTypeOfDistrib	iDistribDepth
;i "discr_distr" 		0 		2		0		1				-1

i "trigger_note" 0 100


</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
