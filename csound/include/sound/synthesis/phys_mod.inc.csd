/* ============================================================================
==========					Modal Frequency Ratios					===========
==========	http://www.csounds.com/manual/html/MiscModalFreq.html	===========
============================================================================ */

giDahinaTabla[] array 1, 2.89, 4.95, 6.99, 8.01, 9.02
giBayanTabla[] array 1, 2.0, 3.01, 4.01, 4.69, 5.63

/*
 if iTypeOfDistrib == 1 then
      ;iFreq      uniform_distr_seed     400, 800
    elseif iTypeOfDistrib == 2 then
      iFreq      linrnd_low     400, 800
    elseif iTypeOfDistrib == 3 then
      iFreq      linrnd_high     400, 800    
    elseif iTypeOfDistrib == 4 then
      iFreq      trirnd     400, 800    
    elseif iTypeOfDistrib == 5 then
      iFreq      linrnd_low_depth     400, 800, iDistribDepth    
    elseif iTypeOfDistrib == 6 then
      iFreq      linrnd_high_depth     400, 800, iDistribDepth
    else
      iFreq      trirnd_depth     400, 800, iDistribDepth
    endif

kLen     lenarray  kArr

*/

instr mass_spring_damper
iFreq      =          p4
           print      iFreq
aImp       mpulse     .5, p3
aMode      mode       aImp, iFreq, 1000
aEnv       linen      aMode, 0.01, p3, p3-0.01
           outs       aEnv, aEnv
endin


opcode mass_spring_damper, a, ki
  ;iFreq - resonant frequency of the filter 
  ; kIntvl - Interval of time in seconds to the next pulse; 
  kIntvl, iFreq			xin

  iRise 	 init 		0.01
  iDur		 = 			i(kIntvl)
  aImp       mpulse     .5, kIntvl
  /*
  aMode1      mode       aImp, iFreq, 100
  ;aMode2      mode       aImp, iFreq*2.89, 100
  ;aMode3      mode       aImp, iFreq*4.95, 100
  aMode2      mode       aImp, iFreq*3.932, 10
  aMode3      mode       aImp, iFreq*9.538, 10
  aMode 	  = 		aMode1+aMode2+aMode3/3
  */
  /*
  aMode		init	0
  kIndx    =        0
  ;until kIndx == lenarray(giDahinaTabla)-1 do
  until kIndx == 1 do
		;aCurrMode 	mode       aImp, iFreq*giBayanTabla[kIndx], .1
		aCurrMode 	mode       aImp, iFreq, .1
		aMode += (aCurrMode/(kIndx+1))
		kIndx    +=       1
  od
  */
  
  aMode      mode       aImp, iFreq, 10
  aEnv       linen      aMode, iRise, iDur, iDur-0.01
			 xout       aEnv
endop


opcode white_noise, aa, i
	iBit      xin
	;iBit       =          1 ;0 = 16 bit, 1 = 31 bit
	 ;input of rand: amplitude, fixed seed (0.5), bit size
	aNoiseL     rand       .1, 0.5, iBit
	aNoiseR     rand       .1, 0.5, iBit
	;           outs       aNoise, aNoise
	xout       aNoiseL, aNoiseR
endop

/*
opcode white_noise, aa, i

iBit xin;0 = 16 bit, 1 = 31 bit
 ;input of rand: amplitude, fixed seed (0.5), bit size
aNoise     rand       .1, 0.5, iBit
           xout       aNoise, aNoise
endop
*/