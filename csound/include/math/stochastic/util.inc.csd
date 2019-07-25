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

/*
opcode SetOctVolumeValue, k[], kk[]k[]k[][]k
	kMode, kVolume, kEnvFunctionComposite, kSpeakerPos, kTime xin
	;kMode = {0 - set, 1 - mult, 2 - add)
	
	kRes[] init 8
	
	;kCnt = 0
	;until kCnt > 7 do
	;	kRes[kCnt] = .0	
	;	kCnt += 1
	;enduntil
	
	;;kParamNumber
	;if kEnvFunctionComposite[8] == 3 then
	;	;GetFrq(kk[]) ;t
	;elseif kEnvFunctionComposite[8] == 2
	;	;GetFrq(kk[]) ;y
	;else 
	;	;GetFrq(kk[]) ;x
	;endif
	
	;xout kRes
endop
*/

opcode SetOctVolumeArray, k[], kk[]
	kMode, kVolume[] xin
	kRes[] init 8
	kCnt = 0
	
	;until kCnt > 7 do
	until kCnt == lenarray(kRes) do 
		kRes[kCnt] = 0.
		kCnt += 1
	enduntil	
	
	xout kRes
endop

opcode GetOctVolume, k[], kkk[][][][]k[][]
	kCurrentPart, kTime, kSpat[][][][], kSpeakerPos[][] xin
	kVolume[] init 8
	kMultCurr[] init 8
	kEnvFunctionComposite[] init 9
	
	
	kCnt = 0
	kMode = 0
	;until kCnt > 7 do
	until kCnt == lenarray(kVolume) do 
		kVolume[kCnt] = .0	
		kMultCurr[kCnt] = .0
		kCnt += 1
	enduntil
	kCnt = 0	
	
	;fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][0][0][0] = %f \n", kCurrentPart, kSpat[kCurrentPart][0][0][0]
	
	kCntSum = 0
	kCntMult = 0
	;until ((kSpat[kCurrentPart][kCntSum][0][0] == 0)||(kCntSum>$SPAT_SUM_LIMIT)) do
	until kSpat[kCurrentPart][kCntSum][0][0] == 0 do
		;fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][0][0] = %f \n", kCurrentPart, kCntSum, kSpat[kCurrentPart][kCntSum][0][0]
		;until ((kSpat[kCurrentPart][kCntSum][kCntMult][0] == 0)||(kCntMult>$SPAT_MULT_LIMIT))  do
		until kSpat[kCurrentPart][kCntSum][kCntMult][0] == 0  do
			fprintks 	$DUMP_FILE_NAME_UTIL, "kCurrentPart = %d | kCntSum = %d | kCntMult = %d\n", kCurrentPart, kCntSum, kCntMult
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][0] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][0]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][1] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][1]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][2] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][2]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][3] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][3]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][4] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][4]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][5] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][5]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][6] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][6]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][7] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][7]
			fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][8] = %f \n", kCurrentPart, kCntSum, kCntMult, kSpat[kCurrentPart][kCntSum][kCntMult][8]
			
			/*
			
			until kCnt == 9 do
				;kEnvFunctionComposite[kCnt] = kSpat[kCurrentPart][kCntSum][kCntMult][kCnt]
				;fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][%d] = %f \n", kCurrentPart, kCntSum, kCntMult, kCnt, kSpat[kCurrentPart][kCntSum][kCntMult][kCnt]
				fprintks 	$DUMP_FILE_NAME_UTIL, "kSpat[%d][%d][%d][%d] = %f \n", kCurrentPart, kCntSum, kCntMult, kCnt, 1.
				;fprintks 	$DUMP_FILE_NAME_UTIL, "kCnt = %d \n", kCnt
				kCnt += 1
			enduntil
			
			
			;kMultCurr = SetOctVolumeValue(kMode, kVolume, kEnvFunctionComposite, kSpeakerPos, kTime) ;kMode = {0 - set, 1 - mult, 2 - add)
			;kMultCurr = SetOctVolumeArray(kMode, kVolume)
			*/
			kCntMult    	+=         1
			if kMode == 0 then 
				kMode = 1
			endif
		enduntil
		;kVolume 	+=		kMultCurr
		kCntSum    	+=      1
		kCntMult    =       0
		;fprintks 	$DUMP_FILE_NAME, "accord :: kIndCycle1 = %f \n", kIndCycle1
	enduntil
	xout kVolume
endop

/*
gkSpat[kCurrentPart][kCntSum][kCntMult][0] = IntRndDistrK(kiSpatDistrType, 1, 7, kSpatDepth) 			;kEnvFunctionType
gkSpat[kCurrentPart][kCntSum][kCntMult][1] = $SPAT_X_MIN												;kXmin

kParamNumber	= 	IntRndDistrK(kiSpatDistrType, 1, 4, kSpatDepth)

if kParamNumber == 3 then
	gkSpat[kCurrentPart][kCntSum][kCntMult][2] = p3													;kXmax
else 
	gkSpat[kCurrentPart][kCntSum][kCntMult][2] = $ROOM_DIM_SM											
endif

gkSpat[kCurrentPart][kCntSum][kCntMult][3] = $SPAT_Y_MIN												;kYmin
gkSpat[kCurrentPart][kCntSum][kCntMult][4] = $SPAT_Y_MAX												;kYmax
gkSpat[kCurrentPart][kCntSum][kCntMult][5] = IntRndDistrK(kiSpatDistrType, p3/3, 3*p3, kSpatDepth)		;kPeriod	
gkSpat[kCurrentPart][kCntSum][kCntMult][6] = IntRndDistrK(kiSpatDistrType, 1, 8, kSpatDepth)			;kDistrType
gkSpat[kCurrentPart][kCntSum][kCntMult][7] = IntRndDistrK(kiSpatDistrType, 1, 11, kSpatDepth)			;kDepth
gkSpat[kCurrentPart][kCntSum][kCntMult][8] = kParamNumber
fprintks 	$DUMP_FILE_NAME, "\ngkSpat[%d][%d][%d][0] = %f\n", kCurrentPart, kCntSum, kCntMult, gkSpat[kCurrentPart][kCntSum][kCntMult][0]
*/
