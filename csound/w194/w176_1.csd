<CsoundSynthesizer>
<CsOptions>
;-o dac
;-F w176-1.mid -o w176_1.wav -W 
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

#include "..\include\math\stochastic\distribution3.inc.csd"
#include "..\include\math\stochastic\util.inc.csd"
#include "..\include\utils\table.v1.csd"

giSine  ftgen	0,0,4096,10,1

/*
instr 1 ; Fl.
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin 
*/
  
/*
instr 1 ; Fl.
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	event_i "i", "harmonic_additive_synthesis", 0, p3, iFrq, iVel
endin
*/

/*
;a = (y2-y1)/(x2-x1)
;b = y1 - a x1

0dbf = 1

init giMax_Additive_Partial_Number = 16

; store max amp for every partial. We can select different profiles during performance
; normalized to 1, len = giMax_Additive_Partial_Number
additive_amp_tbl_1
additive_amp_tbl_2
...
additive_amp_tbl_n

; We can select different profiles during performance
; normalized to 1, len = giMax_Additive_Partial_Number
additive_amp_probability_of_fastest_attac_time_from_partial_index_tbl_1	
additive_amp_probability_of_fastest_decay_time_from_partial_index_tbl_1
additive_amp_probability_of_sustain_level_from_partial_index_tbl_1

==========	Recalc_Current_Partial_envelope_tbl	==============

opcode Recalc_Current_Partial_envelope_tbl
	baseamp, kCurrent_Partial_envelope_tbl, num_of_partials, begin_time xin

	 /\           
	/
	A D 
	
	for(j=0...num_of_partials)
		last_amp = readtable(kCurrent_Partial_envelope_tbl, 7*j)
		attac_time = GetRndVolByIndex(additive_amp_probability_of_fastest_attac_time_from_partial_index_tbl_1, j)
		a1 = (baseamp-last_amp)/(attac_time)
		b1 = baseamp - a1 * begin_time	
		
		sustain_vol = GetRndVolByIndex(additive_amp_probability_of_sustain_level_from_partial_index_tbl_1, j)
		decay_time = GetRndVolByIndex(additive_amp_probability_of_fastest_decay_time_from_partial_index_tbl_1, j)
		a2 = (sustain_vol-baseamp)/(decay_time-attac_time)
		b2 = baseamp - a2 * (begin_time + attac_time)
		
		writetable(kCurrent_Partial_envelope_tbl, 7*j+1, attac_time+begin_time)
		writetable(kCurrent_Partial_envelope_tbl, 7*j+2, sustain_vol)
		writetable(kCurrent_Partial_envelope_tbl, 7*j+3, a1)
		writetable(kCurrent_Partial_envelope_tbl, 7*j+4, b1)
		writetable(kCurrent_Partial_envelope_tbl, 7*j+5, a2)
		writetable(kCurrent_Partial_envelope_tbl, 7*j+6, b2)
	endfor
endop

==========	Handmade_Amp_Env	==============

opcode Handmade_Amp_Env
	kCurrent_Partial_envelope_tbl, time_from_instr_start, j xin
   
	 /\           
	/
	A D 

	kAmp init 0

	if(time_from_instr_start <= readtable(kCurrent_Partial_envelope_tbl, 7*j+1)) then ; attac_time
		kAmp = readtable(kCurrent_Partial_envelope_tbl, 7*j+3) * time_from_instr_start + readtable(kCurrent_Partial_envelope_tbl, 7*j+4)
	else ; after attac_time
		kAmp = readtable(kCurrent_Partial_envelope_tbl, 7*j+5) * time_from_instr_start + readtable(kCurrent_Partial_envelope_tbl, 7*j+6)
		sustain_vol = readtable(kCurrent_Partial_envelope_tbl, 7*j+2)
		if(kAmp < sustain_vol) then ; sustain time
			kAmp = sustain_vol
		endif
	endif
	
	xout kAmp
endop

==========	additive synthesis	==============
instr additive_synthesis_midi
;amount_of_unharmony = 0
;top_unharmony_rnd = j+1 + .001
;
;amount_of_unharmony = 1
;top_unharmony_rnd = j+1 + .99
;

init kRecalculate_Partial_Amp_Env_Flag = 1
kCurrTimeFromStart init 0

; normalized to 1, len = 7 : {current_amp_level_for_partial_index, attac_time, sustain_vol, a1, b1, a2, b2} * giMax_Additive_Partial_Number
kCurrent_Partial_envelope_tbl ; init 0


;from midi
baseamp = ampmidi(0dbf)
basefrq = midi_key2frq
aftertouch
pitch_band
midi_cntr1 ; amount_of_unharmony
midi_cntr2 ; noise volume
midi_cntr3 ; release len
midi_cntr4 ; amp of partial table index
midi_cntr5 ; one partial max attac time
midi_cntr6 ; one partial max decay time
midi_cntr7 ; one partial max decay volume

iRelease_Len = i(midi_cntr3)

a_top_unharmony_rnd = (j+1 + .99 - (j+1 + .001)) / 1 - 0 = .989
b_top_unharmony_rnd = j+1 + .001 - .989 * 0 = j+1.001
amount_of_unharmony = func(midi_cntr1) ; amount_of_unharmony = 0...1

frq_spline_min_frq = .05
frq_spline_max_frq = .5
amp_spline_min_frq = .05
amp_spline_max_frq = .5
frq_spline_delta = .005
amp_spline_delta = .3

kCurrTimeFromStart = timeinsts

num_of_partials = max(func(baseamp, aftertouch), giMax_Additive_Partial_Number)

if(gkRecalculate_Partial_Amp_Env_Flag == 1)
	Recalc_Current_Partial_envelope_tbl(baseamp, kCurrent_Partial_envelope_tbl, num_of_partials, kCurrTimeFromStart)
	kRecalculate_Partial_Amp_Env_Flag = 0
endif

if(trigger aftertouch)
	Recalc_Current_Partial_envelope_tbl(baseamp, kCurrent_Partial_envelope_tbl, num_of_partials, kCurrTimeFromStart)
endif

additive_amp_tbl_index = func(midi_cntr4)

sum_of_partials = 0
j=0...num_of_partials{
	curfrq = basefrq*rnd(j+1, a_top_unharmony_rnd * amount_of_unharmony + b_top_unharmony_rnd)+pitch_band
	frq[j] = rspline (frq_spline_min_frq, frq_spline_max_frq, curfrq*(1+frq_spline_delta), curfrq*(1 - frq_spline_delta))
	kCuramp_Max = baseamp*readtable(additive_amp_tbl_index, j)
	kKur_Amp_Env = Handmade_Amp_Env(kCurrent_Partial_envelope_tbl, kCurrTimeFromStart, j)
	kCur_Amp = kKur_Amp_Env*kCuramp_Max ; make A, D, S part of amp env
	tabwrite(kCurrent_Partial_envelope_tbl, j*7, kKur_Amp_Env) ; insert kKur_Amp_Env to j*7 index in kCurrent_Partial_envelope_tbl
	amp[j] = rspline (amp_spline_min_frq, amp_spline_max_frq, kCur_Amp*(1+amp_spline_delta), kCur_Amp*(1 - amp_spline_delta))
	sum_of_partials += oscil(amp[j], frq[j])
}


noise_generator = noise(baseamp, aftertouch, midi_cntr2)*Handmade_Amp_Env(kCurrent_Partial_envelope_tbl, kCurrTimeFromStart, 0)

mechanical_artifact ; e.g. valve click, string noise etc

voice_artifacts ; e.g. singing into instrument

overall_amp_env
 _________ __ 
/            \
A S         R
kOverall_Amp_Env linsegr 0, .001, 0dbf, 3600, 0dbf, iRelease_Len, 0 ; make A and R part of amp env

out = (sum_of_partials + noise_generator + mechanical_artifact + voice_artifacts)*kOverall_Amp_Env
endin

=================================================================================================

new idea
automate turn on synthesiser with volume 0
midi instr controls autoturned instr
goals: 
more detailed release control, 
artifacts (valve click, string niose etc) independent control, 
more detailed legato imitation (because we can keep last note untin new noteon msg will came thereby we will can add controlled amount of autopitch shift)

*/

instr 1 ; Fl.
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity

	;receive general pitch and volume from the score
	;ibasefrq  =         cpspch(p4) ;convert pitch values to frequency
	;ibasefrq  =         p4
	ibasefrq  =        	 (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;ibaseamp  =         ampdbfs(p5) ;convert dB to amplitude
	iAmp       random     0.1, .9
	;ibaseamp  =         iAmp
	ibaseamp  =         iVel

	;iPan	=	p6
	iPan	=	.5
	
	;create 8 harmonic partials
	;aOsc1     poscil    ibaseamp, ibasefrq, giSine
	;aOsc2     poscil    ibaseamp/2, ibasefrq*2, giSine
	;aOsc3     poscil    ibaseamp/3, ibasefrq*3, giSine
	;aOsc4     poscil    ibaseamp/4, ibasefrq*4, giSine
	;aOsc5     poscil    ibaseamp/5, ibasefrq*5, giSine
	;aOsc6     poscil    ibaseamp/6, ibasefrq*6, giSine
	;aOsc7     poscil    ibaseamp/7, ibasefrq*7, giSine
	;aOsc8     poscil    ibaseamp/8, ibasefrq*8, giSine
	
	kPartialDecayTimeArr[] fillarray 2, 1.5, 1.3, 1.1, 0.9, 0.9, 0.9, 0.7, 0.7, 0.5, 0.5, 0.5, 0.3, 0.3, 0.1, 0.1
	
	krangeMin init .1
	krangeMax init .3
	kcpsmin init .05
	kcpsmax init .5
	
	aOut = 0
	
	kCnt = 0
	until kCnt > 16 do
		;kEnvDecey - make D and S part of amp env, because of stupid csound design, lets made it by hand, 
		;calculating value as function of time from note start
		;see timeinsts opcode
		kFrqMod = get_different_distrib_value(0, 1, .5, 2, 1)	
		kPartialAmp  = rspline(krangeMin, krangeMax, kcpsmin, kcpsmax)
		kFrqOsc   = poscil(kPartialAmp, kFrqMod, giSine)
		aOsc     =  poscil(ibaseamp/(kCnt+1)+kPartialAmp, ibasefrq*(kCnt+1)+kFrqOsc, giSine)
		aOut += aOsc
		kCnt += 1
	enduntil
	
	aOut /= 8
	
	aNoise noise ibaseamp/10, 0.5
	aOut += aNoise
	
	;apply simple envelope
	;kenv expseg .01, p3/3, .5, p3/3, .3, p3/3, .01 ;not for MIDI!
	kenv linsegr 0, .1, 1 , 200, 1, .1, 0 ; make A and R part of amp env
	
	;add partials and write to output
	;aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
    outs      aOut*kenv*iPan, aOut*kenv*(1-iPan)
	;outs      aOut*iPan, aOut*(1-iPan)
endin

instr 2 ; Cor
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin

instr 3 ; Tuba
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin

instr 4 ; V-no
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	;aMod poscil iModAmp, iModFrq, giSine
	;aCar poscil iVel, iFrq+aMod, giSine
	aCar poscil iVel, iFrq, giSine
	outs aCar, aCar
endin


;instr 5 
#include "..\include\sound\synthesis\harmonic_additive_synthesis_2ch.csd"

</CsInstruments>
<CsScore>
f 0 100
</CsScore>
</CsoundSynthesizer>