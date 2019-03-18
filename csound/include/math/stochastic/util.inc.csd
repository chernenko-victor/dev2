#define DUMP_FILE_NAME_UTIL #"dump_util.inc.txt"#

/*
opcode RndSplit, k[], kki
	kMin, kMax, iIntervalNumber xin
	;kSplit[] init iIntervalNumber
	;kSplit[] fillarray 1, 1, 1
	
	if iIntervalNumber<=0 then 
		iIntervalNumber = 1
	endif
	
	kSplit[] init iIntervalNumber
	kIndex	   	=	0
	kTotalLen	=	0
	
	;kSplit[kIndex]	IntRndDistrK 	1, 1, 10, 1
	until kIndex >= iIntervalNumber do
		kSplit[kIndex]	IntRndDistrK 	1, 1, 10, 1
		kTotalLen		+=	kSplit[kIndex] 
		kIndex    		+=  1
	enduntil
	
	;y = A x + B
	;kMin = B
	;kMax = A kTotalLen + B
	
	;B = kMin
	;A = (kMax - kMin) / kTotalLen
	
	;y = A x + B
	kA = (kMax - kMin) / kTotalLen
	kB = kMin
	kIndex	   	=	0
	until kIndex >= iIntervalNumber do
		kSplit[kIndex]	= 	kA * kSplit[kIndex] + kB
		kIndex    		+=  1
	enduntil
	xout kSplit
endop
*/

opcode RndSplit, k[], kkk
	kMin, kMax, kIntervalNumber xin
	;kSplit[] init iIntervalNumber
	;kSplit[] fillarray 1, 1, 1
	
	kSplit[] init 256
	kIndex	   	=	0
	kTotalLen	=	0
		
	;kSplit[kIndex]	IntRndDistrK 	1, 1, 10, 1
	until kIndex >= kIntervalNumber do
		kSplit[kIndex]	IntRndDistrK 	1, 1, 10, 1
		kTotalLen		+=	kSplit[kIndex] 
		kIndex    		+=  1
	enduntil
	
	;y = A x + B
	;kMin = B
	;kMax = A kTotalLen + B
	
	;B = kMin
	;A = (kMax - kMin) / kTotalLen
	
	;y = A x + B
	kA = (kMax - kMin) / kTotalLen
	kB = kMin
	kIndex	   	=	0
	until kIndex >= kIntervalNumber do
		kSplit[kIndex]	= 	kA * kSplit[kIndex] + kB
		kIndex    		+=  1
	enduntil
	kSplit[kIndex] = -1;
	xout kSplit
endop

opcode GetLine, k, kkkkk
	kXcurr, kXmin, kXmax, kYmin, kYmax xin 
	kVal init 0.
	;y = A x + B
	;kYmin = A kXmin + B
	;kYmax = A kXmax + B
	kA = (kYmax - kYmin) / (kXmax - kXmin)
	kB = kYmin - kA * kXmin
	kVal = kA * kXcurr + kB
	xout kVal
endop

opcode GetPow, k, kkkkk
	kXcurr, kXmin, kXmax, kYmin, kYmax xin 
	kVal init 0.
	;y = A * x^2 + B
	;kYmin = A * kXmin^2 + B
	;kYmax = A * kXmax^2 + B
	kA = (kYmax - kYmin) / (kXmax^2 - kXmin^2)
	kB = kYmin - kA * kXmin^2
	kVal = kA * kXcurr^2 + kB
	xout kVal
endop

opcode GetExp, k, kkkkk
	kXcurr, kXmin, kXmax, kYmin, kYmax xin 
	kVal init 0.
	;kXcurrScale	scale 
	kXcurrScale = GetLine(kXcurr, kXmin, kXmax, 0., 1.)
	kExpCurved expcurve kXcurrScale, 2.71828
	;kExpCurved expcurve kXcurrScale, 2.73
	kVal = GetLine(kExpCurved, 0., 1., kYmin, kYmax)
	xout kVal
endop

opcode GetSin, k, kkkkkk
	kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod xin 
	kVal init 1.
	kVal = GetLine(sin($M_PI * kXcurr), -1., 1., kYmin, kYmax)
	xout kVal
endop

opcode GetSaw, k, kkkkkk
	kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod xin 
	kVal init 1.
	kVal = GetSin(kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod)
	xout kVal
endop

/*
opcode GetFrq, k, kkkkkkkkk
	kEnvFunctionType, kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod, kDistrType, kDepth xin 
	;{1 = linear, 2 = power, 3 = exponential, 4 = sinus, 5 = saw i.e. modulo, 6 = stochastic}
	kFrq init 440.
	if kEnvFunctionType == 1 then
	  kFrq = GetLine(kXcurr, kXmin, kXmax, kYmin, kYmax)
	elseif kEnvFunctionType == 2 then
	  kFrq = GetPow(kXcurr, kXmin, kXmax, kYmin, kYmax)
	elseif kEnvFunctionType == 3 then
	  kFrq = GetExp(kXcurr, kXmin, kXmax, kYmin, kYmax)
	elseif kEnvFunctionType == 4 then
	  kFrq = GetSin(kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod)    
	elseif kEnvFunctionType == 5 then
	  kFrq = GetSaw(kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod)    
	elseif kEnvFunctionType == 6 then
	  kFrq = get_different_distrib_value_k(0, kYmin, kYmax, kDistrType, kDepth)
	endif
	xout kFrq
endop
*/
opcode GetFrq, k, kk[]
	kXcurr, kEnvFunctionOne[] xin
	
	kFrq init 440.
	kEnvFunctionType = kEnvFunctionOne[0] ;{1 = linear, 2 = power, 3 = exponential, 4 = sinus, 5 = saw i.e. modulo, 6 = stochastic}
	kXmin = kEnvFunctionOne[1]
	kXmax = kEnvFunctionOne[2]
	kYmin = kEnvFunctionOne[3]
	kYmax = kEnvFunctionOne[4]
	kPeriod = kEnvFunctionOne[5]
	kDistrType = kEnvFunctionOne[6]
	kDepth = kEnvFunctionOne[7]
	
	fprintks $DUMP_FILE_NAME, "kEnvFunctionType = %f | kXmin = %f | kXmax = %f | kYmin = %f | kYmax = %f | kPeriod = %f | kDistrType = %f | kDepth = %f\n", kEnvFunctionType, kXmin, kXmax, kYmin, kYmax, kPeriod, kDistrType, kDepth
	
	if kEnvFunctionType == 1 then
	  kFrq = GetLine(kXcurr, kXmin, kXmax, kYmin, kYmax)
	elseif kEnvFunctionType == 2 then
	  kFrq = GetPow(kXcurr, kXmin, kXmax, kYmin, kYmax)
	elseif kEnvFunctionType == 3 then
	  kFrq = GetExp(kXcurr, kXmin, kXmax, kYmin, kYmax)
	elseif kEnvFunctionType == 4 then
	  kFrq = GetSin(kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod)    
	elseif kEnvFunctionType == 5 then
	  kFrq = GetSaw(kXcurr, kXmin, kXmax, kYmin, kYmax, kPeriod)    
	elseif kEnvFunctionType == 6 then
	  kFrq = get_different_distrib_value_k(0, kYmin, kYmax, kDistrType, kDepth)
	endif
	
	xout kFrq
endop
