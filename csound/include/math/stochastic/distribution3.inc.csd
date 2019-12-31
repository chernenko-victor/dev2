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

#define DUMP_FILE_NAME #"dump_distribution3.inc.txt"#

opcode uniform_distr, i, ii
  iMin, iMax xin
  iRnd       random     iMin, iMax
  xout       iRnd
endop

opcode uniform_distr_k, k, kk
  kMin, kMax xin
  kRnd       random     kMin, kMax
  xout       kRnd
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

opcode linrnd_low_k, k, kk
 ;linear random with precedence of lower values
kMin, kMax xin
 ;generate two random values with the random opcode
kOne       random     kMin, kMax
kTwo       random     kMin, kMax
 ;compare and get the lower one
kRnd       =          kOne < kTwo ? kOne : kTwo
           xout       kRnd
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

opcode linrnd_high_k, k, kk
 ;linear random with precedence of higher values
kMin, kMax xin
 ;generate two random values with the random opcode
kOne       random     kMin, kMax
kTwo       random     kMin, kMax
 ;compare and get the higher one
kRnd       =          kOne > kTwo ? kOne : kTwo
           xout       kRnd
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

opcode trirnd_k, k, kk
kMin, kMax xin
 ;generate two random values with the random opcode
kOne       random     kMin, kMax
kTwo       random     kMin, kMax
 ;get the mean and output
kRnd       =          (kOne+kTwo) / 2
           xout       kRnd
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

opcode linrnd_low_depth_k, k, kkk
 ;linear random with precedence of lower values
kMin, kMax, kMaxCount xin
 ;set counter and initial (absurd) result
kCount     =          0
kRnd       =          kMax
 ;loop and reset iRnd
 until kCount == kMaxCount do
kUniRnd    random     kMin, kMax
kRnd       =          kUniRnd < kRnd ? kUniRnd : kRnd
kCount     +=         1
 enduntil
           xout       kRnd
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

opcode linrnd_high_depth_k, k, kkk
 ;linear random with precedence of higher values
kMin, kMax, kMaxCount xin
 ;set counter and initial (absurd) result
kCount     =          0
kRnd       =          kMin
 ;loop and reset iRnd
 until kCount == kMaxCount do
kUniRnd    random     kMin, kMax
kRnd       =          kUniRnd > kRnd ? kUniRnd : kRnd
kCount     +=         1
 enduntil
           xout       kRnd
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

opcode trirnd_depth_k, k, kkk
kMin, kMax, kMaxCount xin
 ;set a counter and accumulator
kCount     =          0
kAccum     =          0
 ;perform loop and accumulate
 until kCount == kMaxCount do
kUniRnd    random     kMin, kMax
kAccum     +=         kUniRnd
kCount     +=         1
 enduntil
 ;get the mean and output
kRnd       =          kAccum / kMaxCount
           xout       kRnd
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

opcode get_different_distrib_value_k, k, ikkkO
  iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth xin
  kOut init 0.
  ;get seed: 0 = seeding from system clock otherwise = fixed seed
  seed       iSeedType
  
    if kTypeOfDistrib == 1 then
      kOut      uniform_distr_k  kMin, kMax
    elseif kTypeOfDistrib == 2 then
      kOut      linrnd_low_k     kMin, kMax
    elseif kTypeOfDistrib == 3 then
      kOut      linrnd_high_k     kMin, kMax    
    elseif kTypeOfDistrib == 4 then
      kOut      trirnd_k     kMin, kMax    
    elseif kTypeOfDistrib == 5 then
      kOut      linrnd_low_depth_k     kMin, kMax, kDistribDepth    
    elseif kTypeOfDistrib == 6 then
      kOut      linrnd_high_depth_k     kMin, kMax, kDistribDepth
    else
      kOut      trirnd_depth_k     kMin, kMax, kDistribDepth
    endif
  
  xout kOut
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

/*
opcode get_discr_distr_k, k, ikkkkk[]
    iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[] xin
    ;iSeedType     =       p4
    ;iLine[]    array      .2, .5, .3
    ;iVal       random     0, 1
    kVal       get_different_distrib_value_k iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth
    kAccum     =          kLine[0]
    kIndex     =          0
	until kAccum >= kVal do
		kIndex     +=         1
		kAccum     +=         kLine[kIndex]
	enduntil
	xout kIndex + kMin
endop
*/

opcode get_discr_distr_k, k, ikkkkk[]
	iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[] xin
	;kIndex = 6
	;xout kIndex
	kVal       get_different_distrib_value_k iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth
    kAccum     =          kLine[0]
    kIndex     =          0
	until kAccum >= kVal do
		kIndex     +=         1
		kAccum     +=         kLine[kIndex]
	enduntil
	xout kIndex + kMin
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

opcode Markov2orderK, k, ikkkkkk[][]
  iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kPrevEl, kMarkovTable[][] xin
  ;iRandom    random     0, 1
  kRandom    get_different_distrib_value_k iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth
  ;fprintks 	$DUMP_FILE_NAME, "kRandom = %f\n", kRandom
  kNextEl    =          0
  kAccum     =          kMarkovTable[kPrevEl][kNextEl]
  ;fprintks 	$DUMP_FILE_NAME, "kAccum = %f | kMarkovTable[%d][%d] = %f\n", kAccum, kPrevEl, kNextEl, kMarkovTable[kPrevEl][kNextEl]
  until kAccum >= kRandom do
    kNextEl    +=         1
    kAccum     +=         kMarkovTable[kPrevEl][kNextEl]
	;fprintks 	$DUMP_FILE_NAME, "kAccum = %f | kMarkovTable[%d][%d] = %f\n", kAccum, kPrevEl, kNextEl, kMarkovTable[kPrevEl][kNextEl]
  enduntil
  xout       kNextEl
endop


;kiIndx		IntRndDistrK 	kiDistrType, kiMin, kiMax, kDepth
opcode IntRndDistrK, k, kkkk
  kiDistrType, kiMin, kiMax, kDepth xin
  kA = kiMax - kiMin
  kB = kiMin

  ;kTypeOfDistrib, kMin, kMax, kDistribDepth
  kRndZeroOne	get_different_distrib_value_k 0, kiDistrType, 0, 1, kDepth
  
  kOut = int(kA*kRndZeroOne + kB)
  xout kOut
endop


opcode expon_rnd_k, k, k
	kLambda xin
	kUniRnd    random     .0001, 1
	kUniRndScaled = kUniRnd / kLambda
	kRes = log(kUniRndScaled)
	xout kRes
endop 


/*
2DO

1. Random Walk
2. poisson http://www.csounds.com/manual/html/poisson.html betarand, bexprnd, cauchy, exprand, gauss, linrand, pcauchy, trirand, unirand, weibull

3. http://en.wikipedia.org/wiki/List_of_probability_distributions

?? remain of http://write.flossmanuals.net/csound/d-random/

*/


;=========================================================
