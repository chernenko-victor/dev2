<CsoundSynthesizer>
<CsOptions>
;-o dac
-o w181_3_2.wav -W 
</CsOptions>
<CsInstruments>
/*
csd for render from midi file
*/
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

seed    0
gisine  ftgen	0,0,4096,10,1

;giSine    ftgen     0, 0, 2^10, 10, 1
;massign   0, 1 ;all midi channels to instr 1


;frequency and amplitude multipliers for 11 partials of Risset's bell
giFqs     ftgen     0, 0, -11, -2, .56,.563,.92,.923,1.19,1.7,2,2.74,3,\
                    3.74,4.07
giAmps    ftgen     0, 0, -11, -2, 1, 2/3, 1, 1.8, 8/3, 1.46, 4/3, 4/3, 1,\
                    4/3
;giSine    ftgen     0, 0, 2^10, 10, 1


instr 1 ; Fl. master instrument
	/*
	iChan       midichn
	iCps        cpsmidi            ; read pitch in frequency from midi notes
	iVel        veloc	0, 127 ; read in velocity from midi notes
	kDur        timeinsts          ; running total of duration of this note
	kRelease    release            ; sense when note is ending
	 if kRelease=1 then            ; if note is about to end
	;           p1  p2  p3    p4     p5    p6
	event "i",  2,  0, kDur, iChan, iCps, iVel ; send full note data to instr 2
	 endif
	*/

	ibasfreq  cpsmidi	;base frequency
	iampmid   ampmidi   10 ;receive midi-velocity and scale 0-20
	inparts   =         int(iampmid)+1 ;exclude zero
	ipart     =         1 ;count variable for loop
	;loop for inparts over the ipart variable
	;and trigger inparts instances of the sub-instrument
	kDur        timeinsts          ; running total of duration of this note
	kRelease    release            ; sense when note is ending
	if kRelease=1 then            ; if note is about to end
		loop:
		ifreq     =         ibasfreq * ipart
		iamp      =         1/ipart/inparts
				  event   "i", 10, 0, kDur, ifreq/4, iamp*4
				  loop_le   ipart, 1, inparts, loop
		;event   "i", 10, 0, kDur, 440., .1
	endif
endin

instr 10 ;subinstrument for playing one partial
	ifreq     =         p4 ;frequency of this partial
	iamp      =         p5 ;amplitude of this partial
	aenv      transeg   0, .01, 0, iamp, p3-.01, -3, 0
	apart     poscil    aenv, ifreq, gisine
			  outs      apart/3, apart/3
endin


instr 2 ; Ob. master instrument
	;;scale desired deviations for maximum velocity
	;frequency (cent)
	imxfqdv   =         100
	;amplitude (dB)
	imxampdv  =         12
	;duration (%)
	imxdurdv  =         100
	;;get midi values
	ibasfreq  cpsmidi	;base frequency
	iampmid   ampmidi   1 ;receive midi-velocity and scale 0-1
	;;calculate maximum deviations depending on midi-velocity
	ifqdev    =         imxfqdv * iampmid
	iampdev   =         imxampdv * iampmid
	idurdev   =         imxdurdv * iampmid
	;;trigger subinstruments
	indx      =         0 ;count variable for loop
	kDur        timeinsts          ; running total of duration of this note
	kRelease    release            ; sense when note is ending
	if kRelease=1 then            ; if note is about to end
		loop:
		ifqmult   tab_i     indx, giFqs ;get frequency multiplier from table
		ifreq     =         ibasfreq * ifqmult
		iampmult  tab_i     indx, giAmps ;get amp multiplier
		iamp      =         iampmult / 20 ;scale
				  ;event_i   "i", 10, 0, 3, ifreq, iamp, ifqdev, iampdev, idurdev
				  event   "i", 10, 0, kDur, ifreq, iamp, ifqdev, iampdev, idurdev
				  loop_lt   indx, 1, 11, loop
	endif
endin

instr 20 ;subinstrument for playing one partial
	;receive the parameters from the master instrument
	ifreqnorm =         p4 ;standard frequency of this partial
	iampnorm  =         p5 ;standard amplitude of this partial
	ifqdev    =         p6 ;maximum freq deviation in cents
	iampdev   =         p7 ;maximum amp deviation in dB
	idurdev   =         p8 ;maximum duration deviation in %
	;calculate frequency
	icent     random    -ifqdev, ifqdev ;cent deviation
	ifreq     =         ifreqnorm * cent(icent)
	;calculate amplitude
	idb       random    -iampdev, iampdev ;dB deviation
	iamp      =         iampnorm * ampdb(idb)
	;calculate duration
	idurperc  random    -idurdev, idurdev ;duration deviation (%)
	iptdur    =         p3 * 2^(idurperc/100)
	p3        =         iptdur ;set p3 to the calculated value
	;play partial
	aenv      transeg   0, .01, 0, iamp, p3-.01, -10, 0
	apart     poscil    aenv, ifreq, gisine
			  outs      apart, apart
endin


instr 3, 4
endin

/*
instr 3 ; Cl.
	;iFrq = p4
	;iModAmp = p5
	;iModFrq = p6
	iAmp     =        0.3
	iModAmp = 11
	iModFrq = 39
	
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))
	
	aMod poscil iModAmp, iModFrq, gisine
	aCar poscil iVel, iFrq+aMod, gisine
	outs aCar, aCar
endin

instr 4 ; Fag.
	iKey         notnum                 ; read in midi note number
	iVel         ampmidi            1 ; read in key velocity
	
	iFrq     =        (440.0*exp(log(2.0)*((iKey)-69.0)/12.0))

	kamp       =          24 ; Amplitude
	
	;kfreq      expseg     p4, p3/2, 50*p4, p3/2, p4 ; Base frequency
	kfreq      expseg     iFrq, p3/2, 50*iFrq, p3/2, iFrq ; Base frequency
	
	iloopnum   =          p5 ; Number of all partials generated
	alyd1      init       0
	alyd2      init       0
			   seed       0
	kfreqmult  oscili     1, 2, 1
	kosc       oscili     1, 2.1, 1
	ktone      randomh    0.5, 2, 0.2 ; A random input
	icount     =          1

	loop: ; Loop to generate partials to additive synthesis
	kfreq      =          kfreqmult * kfreq
	atal       oscili     1, 0.5, 1
	apart      oscili     1, icount*exp(atal*ktone) , 1 ; Modulate each partials
	anum       =          apart*kfreq*kosc
	asig1      oscili     kamp, anum, 1
	asig2      oscili     kamp, 1.5*anum, 1 ; Chorus effect to make the sound more "fat"
	asig3      oscili     kamp, 2*anum, 1
	asig4      oscili     kamp, 2.5*anum, 1
	alyd1      =          (alyd1 + asig1+asig4)/icount ;Sum of partials
	alyd2      =          (alyd2 + asig2+asig3)/icount
			   loop_lt    icount, 1, iloopnum, loop ; End of loop

			   outs       alyd1, alyd2 ; Output generated sound
endin
*/
</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>