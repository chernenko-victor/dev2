gaSend init 0

 instr wgbow_instr
kamp     =        0.1
kfreq    =        p4
kpres    =        0.2
krat     rspline  0.006,0.988,0.1,0.4
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20
aSig	 wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
aSig     butlp     aSig,2000
aSig     pareq    aSig,80,6,0.707
        ;outs     aSig,aSig
		kalpha line 0, p3, 360
		kbeta = 0
			
		; generate B format
		aw, ax, ay, az, ar, as, at, au, av bformenc1 aSig, kalpha, kbeta
		; decode B format for 8 channel circle loudspeaker setup
		a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

		; write audio out
		outo a1, a2, a3, a4, a5, a6, a7, a8
gaSend   =        gaSend + aSig/3
 endin

 instr wgbow_reverb_instr
aRvbL,aRvbR reverbsc gaSend,gaSend,0.9,7000
            ;outs     aRvbL,aRvbR
			kalpha line 0, p3, 360
			kbeta = 0
				
			; generate B format
			aw, ax, ay, az, ar, as, at, au, av bformenc1 aRvbL, kalpha, kbeta
			; decode B format for 8 channel circle loudspeaker setup
			a1, a2, a3, a4, a5, a6, a7, a8 bformdec1 4, aw, ax, ay, az, ar, as, at, au, av        

			; write audio out
			outo a1, a2, a3, a4, a5, a6, a7, a8
            clear    gaSend
 endin