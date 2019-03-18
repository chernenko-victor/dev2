/*
#ifndef DISTRIBUTIONINC
#define DISTRIBUTIONINC #5000#
;....
#else 
;....
#end 
*/

/*
types of distribution
1 = uniform
2 = linrnd_low ;linear random with precedence of lower values
3 = linrnd_high ;linear random with precedence of higher values
4 = trirnd ;for triangular distribution

5 = linrnd_low_depth ;linear random with precedence of lower values with depth
6 = linrnd_high_depth ;linear random with precedence of higher values with depth
7 = trirnd_depth ;for triangular distribution with depth
*/


opcode uniform_distr, i, ii
  iMin, iMax xin
  iRnd       random     iMin, iMax
  xout       iRnd
endop

;****DEFINE OPCODES FOR LINEAR DISTRIBUTION****

opcode linrnd_low, i, ii
 ;linear random with precedence of lower values
iMin, iMax xin
 ;generate two random values with the random opcode
iOne       random     iMin, iMax
iTwo       random     iMin, iMax
 ;compare and get the lower one
iRnd       =          iOne < iTwo ? iOne : iTwo
           xout       iRnd
endop

opcode linrnd_high, i, ii
 ;linear random with precedence of higher values
iMin, iMax xin
 ;generate two random values with the random opcode
iOne       random     iMin, iMax
iTwo       random     iMin, iMax
 ;compare and get the higher one
iRnd       =          iOne > iTwo ? iOne : iTwo
           xout       iRnd
endop


;****UDO FOR TRIANGULAR DISTRIBUTION****
opcode trirnd, i, ii
iMin, iMax xin
 ;generate two random values with the random opcode
iOne       random     iMin, iMax
iTwo       random     iMin, iMax
 ;get the mean and output
iRnd       =          (iOne+iTwo) / 2
           xout       iRnd
endop


;****UDO DEFINITIONS****
opcode linrnd_low_depth, i, iii
 ;linear random with precedence of lower values
iMin, iMax, iMaxCount xin
 ;set counter and initial (absurd) result
iCount     =          0
iRnd       =          iMax
 ;loop and reset iRnd
 until iCount == iMaxCount do
iUniRnd    random     iMin, iMax
iRnd       =          iUniRnd < iRnd ? iUniRnd : iRnd
iCount     +=         1
 enduntil
           xout       iRnd
endop

opcode linrnd_high_depth, i, iii
 ;linear random with precedence of higher values
iMin, iMax, iMaxCount xin
 ;set counter and initial (absurd) result
iCount     =          0
iRnd       =          iMin
 ;loop and reset iRnd
 until iCount == iMaxCount do
iUniRnd    random     iMin, iMax
iRnd       =          iUniRnd > iRnd ? iUniRnd : iRnd
iCount     +=         1
 enduntil
           xout       iRnd
endop

opcode trirnd_depth, i, iii
iMin, iMax, iMaxCount xin
 ;set a counter and accumulator
iCount     =          0
iAccum     =          0
 ;perform loop and accumulate
 until iCount == iMaxCount do
iUniRnd    random     iMin, iMax
iAccum     +=         iUniRnd
iCount     +=         1
 enduntil
 ;get the mean and output
iRnd       =          iAccum / iMaxCount
           xout       iRnd
endop


opcode get_different_distrib_value, i, iiiij
  iSeedType, iTypeOfDistrib, iMin, iMax, iDistribDepth xin
  iOut init 0.
  ;get seed: 0 = seeding from system clock otherwise = fixed seed
  seed       iSeedType
  
    if iTypeOfDistrib == 1 then
      iOut      uniform_distr  iMin, iMax
    elseif iTypeOfDistrib == 2 then
      iOut      linrnd_low     iMin, iMax
    elseif iTypeOfDistrib == 3 then
      iOut      linrnd_high     iMin, iMax    
    elseif iTypeOfDistrib == 4 then
      iOut      trirnd     iMin, iMax    
    elseif iTypeOfDistrib == 5 then
      iOut      linrnd_low_depth     iMin, iMax, iDistribDepth    
    elseif iTypeOfDistrib == 6 then
      iOut      linrnd_high_depth     iMin, iMax, iDistribDepth
    else
      iOut      trirnd_depth     iMin, iMax, iDistribDepth
    endif
  
  xout iOut
endop

opcode get_discr_distr, i, iiiiii[]
    iSeedType, iTypeOfDistrib, iMin, iMax, iDistribDepth, iLine[] xin
    ;iSeedType     =       p4
    ;iLine[]    array      .2, .5, .3
    ;iVal       random     0, 1
    iVal       get_different_distrib_value iSeedType, iTypeOfDistrib, iMin, iMax, iDistribDepth
    iAccum     =          iLine[0]
    iIndex     =          0
  until iAccum >= iVal do
    iIndex     +=         1
    iAccum     +=         iLine[iIndex]
  enduntil
  xout iIndex
endop


/* see example in t_markov2.csd */
opcode Markov2order, i, iiiiiii[][]
  iSeedType, iTypeOfDistrib, iMin, iMax, iDistribDepth, iPrevEl, iMarkovTable[][] xin
  ;iRandom    random     0, 1
  iRandom    get_different_distrib_value iSeedType, iTypeOfDistrib, iMin, iMax, iDistribDepth
  iNextEl    =          0
  iAccum     =          iMarkovTable[iPrevEl][iNextEl]
  until iAccum >= iRandom do
    iNextEl    +=         1
    iAccum     +=         iMarkovTable[iPrevEl][iNextEl]
  enduntil
  xout       iNextEl
endop


/*
2DO

1. Random Walk

2. poisson http://www.csounds.com/manual/html/poisson.html betarand, bexprnd, cauchy, exprand, gauss, linrand, pcauchy, trirand, unirand, weibull

3. http://en.wikipedia.org/wiki/List_of_probability_distributions

?? remain of http://write.flossmanuals.net/csound/d-random/

*/


;=========================================================

instr discr_distr_old
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
            seed       p4
 iLine[]    array      .2, .5, .3
 iVal       random     0, 1
 iAccum     =          iLine[0]
 iIndex     =          0
until iAccum >= iVal do
 iIndex     +=         1
 iAccum     +=         iLine[iIndex]
enduntil
 iVal2      get_different_distrib_value /* iSeedType */ 0, /* iTypeOfDistrib*/ 1, /* iMin */ 100., /* iMax*/ 200., /* iDistribDepth */ 3
            ;printf_i   "Random number = %.3f, next element = %c!\n", 1, iVal, iIndex+97
            printf_i   "Random number = %.3f\n", 1, iVal2
endin

instr discr_distr
   ;get seed: 0 = seeding from system clock
   ;          otherwise = fixed seed
   iSeedType          =       p4
   iTypeOfDistrib     =       p5
   iDistribDepth      =       p6
   ;iLine[]    array      .2, .5, .3
   iLine[]    array      .2, .4, .3, .1
   
   iIndex get_discr_distr iSeedType, iTypeOfDistrib, /* iMin */ 0., /* iMax*/ 1., iDistribDepth, /* distrib array */ iLine
            ;printf_i   "Random number = %.3f, next element = %c!\n", 1, iVal, iIndex+97
            printf_i   "next element = %c!\n", 1, iIndex+97
endin


instr uniform_distr_seed
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
           seed       p4
 ;generate four notes to be played from subinstrument
iNoteCount =          0
 until iNoteCount == 4 do
iFreq      random     400, 800
           event_i    "i", "mass_spring_damper", iNoteCount, 2, iFreq
iNoteCount +=         1 ;increase note count
 enduntil
endin


instr linrnd_low_note
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
           seed       p4
 ;generate four notes to be played from subinstrument
iNoteCount =          0
 until iNoteCount == 4 do
iFreq      linrnd_low     400, 800
           event_i    "i", "mass_spring_damper", iNoteCount, 2, iFreq
iNoteCount +=         1 ;increase note count
 enduntil
endin


instr linrnd_high_note
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
           seed       p4
 ;generate four notes to be played from subinstrument
iNoteCount =          0
 until iNoteCount == 4 do
iFreq      linrnd_low     400, 800
           event_i    "i", "mass_spring_damper", iNoteCount, 2, iFreq
iNoteCount +=         1 ;increase note count
 enduntil
endin

instr trirnd_note
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
           seed       p4
 ;generate four notes to be played from subinstrument
iNoteCount =          0
 until iNoteCount == 4 do
iFreq      trirnd     400, 800
           event_i    "i", "mass_spring_damper", iNoteCount, 2, iFreq
iNoteCount +=         1 ;increase note count
 enduntil
endin

instr different_distrib_note
  ;get seed: 0 = seeding from system clock otherwise = fixed seed
  seed       p4
  iTypeOfDistrib = p5
  iDistribDepth = p6
    
  ;generate four notes to be played from subinstrument
  iNoteCount =          0
  until iNoteCount == 4 do
    ;iFreq      trirnd     400, 800
    if iTypeOfDistrib == 1 then
      iFreq      uniform_distr  400, 800
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
    event_i    "i", "mass_spring_damper", iNoteCount, 2, iFreq
    iNoteCount +=         1 ;increase note count
  enduntil
endin
