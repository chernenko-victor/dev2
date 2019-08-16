;utils

;require #define DUMP_FILE_NAME #"cffg.txt"#

;kIndxFolded	TableFolding kFoldingType, kiIndx, kTblLen
opcode TableFolding, k, kkk
  kFoldingType, kiIndx, kTblLen xin
  
  if kFoldingType==2 then
	  kIndxFolded = kiIndx
	  if kiIndx<0 then
		kIndxFolded = kTblLen-1 
	  elseif kiIndx>kTblLen-1 then
		kIndxFolded = 0
	  endif
  elseif kFoldingType==1 then /* TO DO */
	  kIndxFolded = kiIndx
	  if kiIndx<0 then
		kIndxFolded = kTblLen-1 
	  elseif kiIndx>kTblLen-1 then
		kIndxFolded = 0
	  endif	
  endif
  
  xout kIndxFolded
endop

;kValue = TableExtrapolate(kArray[][], kIndxRow, kIndx, kTblLen)
opcode TableExtrapolate, k, k[][]kkk
	kArray[][], kIndxRow, kIndx, kTblLen xin
	kRes init 1
	/*
		arr[kTblLen-1+n] = arr[kTblLen-1] * arr[n%(kTblLen-1)], e.g.
		[0] => 1, [1] => 2, [2] => 4, [3] => 8, [4] => 16, [5] => 32, [6] => 64, [7] => 128,
		kTblLen = 8;
		n = 8; n%(kTblLen-1) = 1; arr[n%(kTblLen-1)] = 2; arr[kTblLen-1] = 128; arr[kTblLen-1+n] = 256
	*/
	if kIndx<0 then
		kRes = kArray[kIndxRow][kTblLen-1]
	elseif kIndx>kTblLen-1 then
		kFoldedIndx = kIndx % (kTblLen - 1)
		kRes = kArray[kIndxRow][kTblLen-1] * kArray[kIndxRow][kFoldedIndx]
	else 
		kRes = kArray[kIndxRow][kIndx]
	endif
	xout kRes
endop

opcode len_arr_new, k, k[]
  kArr[] xin
  kIndex = 0
  until kArr[kIndex] == 0 do
    kIndex    +=    1
  enduntil
  xout       kIndex+1
endop

opcode ReplaceArrElWithArr, k[], k[]kk[]
	kInArr[], kInArrIndex, kInArrReplace[] xin

	kOutArray[] init 128

	kArrBeforeIndex[] init 128
	kArrAfterIndex[] init 128
	kArrTmp[] init 128

	;fprintks 	$DUMP_FILE_NAME, "\n=======================================\ncopy left part of In Array to Out Array\n"
	kIterator = 0
	;fprintks 	$DUMP_FILE_NAME, "kIterator = %d iInArrIndex = %d \n", kIterator, kInArrIndex
	while kIterator < kInArrIndex do
		kOutArray[kIterator] = kInArr[kIterator]
		;fprintks $DUMP_FILE_NAME, "kOutArray[%d] = %f kInArr[%d] = %f \n", kIterator, kOutArray[kIterator], kIterator, kInArr[kIterator]
		kIterator = kIterator + 1
	od	

	;fprintks 	$DUMP_FILE_NAME, "\n=======================================\ncopy right part of In Array to Temporary Array\n"
	kIterator = kInArrIndex + 1
	kIndex = 0
	;fprintks 	$DUMP_FILE_NAME, "kIterator = %d kIndex = %d \n", kIterator, kIndex
	while kInArr[kIterator] != 0 do
		kArrTmp[kIndex] = kInArr[kIterator]
		;fprintks 	$DUMP_FILE_NAME, "kArrTmp[%d] = %f kInArr[%d] = %f \n", kIndex, kArrTmp[kIndex], kIterator, kInArr[kIterator]
		kIterator = kIterator + 1
		kIndex = kIndex + 1
	od	
	kArrTmp[kIndex+1] = 0

	;fprintks 	$DUMP_FILE_NAME, "\n=======================================\ncopy Replacement Array to Out Array\n"
	kIterator = kInArrIndex
	kIndex = 0
	;fprintks 	$DUMP_FILE_NAME, "kIterator = %d kIndex = %d \n", kIterator, kIndex
	while kInArrReplace[kIndex] != 0 do
		kOutArray[kIterator] = kInArrReplace[kIndex]
		;fprintks 	$DUMP_FILE_NAME, "kOutArray[%d] = %f kInArrReplace[%d] = %f \n", kIterator, kOutArray[kIterator], kIndex, kInArrReplace[kIndex]
		kIterator = kIterator + 1
		kIndex = kIndex + 1
	od	

	;fprintks 	$DUMP_FILE_NAME, "\n=======================================\ncopy Temporary Array to Out Array\n"
	kIndex = 0
	;fprintks 	$DUMP_FILE_NAME, "kIterator = %d kIndex = %d \n", kIterator, kIndex
	while kArrTmp[kIndex] != 0 do
		kOutArray[kIterator] = kArrTmp[kIndex]
		;fprintks 	$DUMP_FILE_NAME, "kOutArray[%d] = %f kArrTmp[%d] = %f \n", kIterator, kOutArray[kIterator], kIndex, kArrTmp[kIndex]
		kIterator = kIterator + 1
		kIndex = kIndex + 1
	od
	kOutArray[kIterator+1] = 0

	xout kOutArray
endop
