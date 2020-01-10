instr grain_2ch
  ;random spline generates formant values in oct format
  kOct    rspline 4,8,0.1,0.5
  ;oct format values converted to cps format
  kCPS    =       cpsoct(kOct)
  ;phase location is left at 0 (the beginning of the waveform)
  kPhs    =       0
  ;frequency (formant) randomization and phase randomization are not used
  kFmd    =       0
  kPmd    =       0
  ;grain duration and density (rate of grain generation)
  kGDur   rspline 0.01,0.2,0.05,0.2
  kDens   rspline 10,200,0.05,0.5
  ;maximum number of grain overlaps allowed. This is used as a CPU brake
  iMaxOvr =       1000
  ;function table for source waveform for content of the grain
  ;a different waveform chosen once every 10 seconds
  kFn     randomh 1,5.99,0.1
  ;print info. to the terminal
          ;printks "CPS:%5.2F%TDur:%5.2F%TDensity:%5.2F%TWaveform:%1.0F%n",1,                     kCPS,kGDur,kDens,kFn
  aSig    grain3  (kCPS+p4)/2, kPhs, kFmd, kPmd, kGDur, kDens, iMaxOvr, kFn, giWFn, \
                    0, 0
					
	/* 				**
	**	Amplitude 	**
	**				*/
	iAmp		random     0.1, .9
	iAttTime	random     0.01, p3/3
	iSustTime	random     0.01, p3/3
	;aAmpEnv expseg .001, 0.001, 1, 0.3, 0.5, 8.5, .001
	aAmpEnv expseg .001, iAttTime, 1, iSustTime, 0.5, p3-(iAttTime+iSustTime), .001
	
    outs     aSig*0.06*aAmpEnv, aSig*0.06*aAmpEnv
endin
