<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 4410

instr 1
iCount    init      0          ; set icount to 0 first
          reinit    new        ; reinit the section each k-pass
		  
		  
	kCnt = 0
	until kCnt > 16 do
		new:
		iCount    =         iCount + 1 ; increase
        print     iCount     ; print the value
        rireturn
		kCnt += 1
	enduntil

endin

</CsInstruments>
<CsScore>
i 1 0 .5
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz