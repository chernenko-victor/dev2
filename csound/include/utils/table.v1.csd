;utils

;require #define DUMP_FILE_NAME #"cffg.txt"#

;kIndxFolded	TableFolding kFoldingType, kiIndx, kTblLen
opcode TableFolding, k, kkk
  kFoldingType, kiIndx, kTblLen xin
  kIndxFolded = kiIndx
  if kiIndx<0 then
	kIndxFolded = kTblLen-1 
  elseif kiIndx>kTblLen-1 then
	kIndxFolded = 0
  endif
  xout kIndxFolded
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
