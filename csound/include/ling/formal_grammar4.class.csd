opcode simple_op, k, k
  kIn xin
  xout kIn
endop

opcode test_op, k, k
  kNum xin
  xout kNum
endop

opcode number_in_arr_cnt, k, k[]k
  kInArr[], kNum xin
  ;fprintks 	$DUMP_FILE_NAME, "\nnumber_in_arr_cnt kNum = %d\n", kNum
  kCnt init 0
  kIndx init 0
  until kInArr[kIndx] == 0 do
    if kInArr[kIndx] == kNum then 
      kCnt += 1	
	endif
    kIndx += 1
  od
  xout kCnt
endop

opcode dump_1dim_arr_to_file, k, k[]k
	kInArr[], kDelim xin
	kRes init 0
	
	fprintks 	$DUMP_FILE_NAME, "\ndump_1dim_arr_to_file :: \n"
	kIndexRow = 0
	while kInArr[kIndexRow] != kDelim do ;2DO add exeption "no kDelim"
		fprintks 	$DUMP_FILE_NAME, "\nkInArr[%d] = %f\n", kIndexRow, kInArr[kIndexRow]
		kIndexRow = kIndexRow + 1
	od	

	fprintks 	$DUMP_FILE_NAME, "\nkInArr[%d] = %f\n", kIndexRow, kInArr[kIndexRow]
	
	xout kRes
endop


opcode get_1dim_arr_from_2dim_arr, k[], kk[][]kkk
	kIndex, kInArr[][], kDelim, kOtherIndxFrom, kIsDelimInOutArr xin
	if kOtherIndxFrom < 0 then
		kOtherIndex = 0
	else
		kOtherIndex = kOtherIndxFrom ;2DO add exeption "kOtherIndxFrom > len_array"
	endif
	kOutArr[] init $ARRAY_MAX_DIM
	
	fprintks 	$DUMP_FILE_NAME, "\nget_1dim_arr_from_2dim_arr :: kIndex = %d :: kInArr[0][0] = %f :: kDelim = %d :: kOtherIndxFrom = %d\n", kIndex, kInArr[0][0], kDelim, kOtherIndxFrom
	
	kOtherIndexNew = 0
	while kInArr[kIndex][kOtherIndex] != kDelim do ;2DO add exeption "no kDelim"
		kOutArr[kOtherIndexNew] = kInArr[kIndex][kOtherIndex]
		fprintks 	$DUMP_FILE_NAME, "\kOutArr[%d] = %f | kInArr[%d][%d] = %f \n", kOtherIndexNew, kOutArr[kOtherIndexNew], kIndex, kOtherIndex, kInArr[kIndex][kOtherIndex]
		kOtherIndex = kOtherIndex + 1
		kOtherIndexNew = kOtherIndexNew + 1
	od
	
	if kIsDelimInOutArr == 1 then
		kOutArr[kOtherIndexNew] = kDelim
		fprintks 	$DUMP_FILE_NAME, "\kOutArr[%d] = %f \n", kOtherIndexNew, kOutArr[kOtherIndexNew]
	endif
	
	xout kOutArr
endop

opcode get_alternate_part, k[], k[]kk
	kInArr[], kDelim, kPartIndx xin
	fprintks 	$DUMP_FILE_NAME, "\nopcode get_alternate_part kDelim = %d kPartIndx = %d\n\n", kDelim, kPartIndx
	;kPartIndx 0...
	kOutArr[] init  $ARRAY_MAX_DIM
	
	;unify kInArr[]: add delim in begin and end!
	kTmpArr[] init  $ARRAY_MAX_DIM
	kTmpArr[0] = kDelim
	kTmpArr[1] = -1
	kTmpArr[2] = kDelim
	kTmpArr[3] = 0
	kInArr = ReplaceArrElWithArr(kTmpArr, 1, kInArr)
	
	
	kDilimPosArr[] init  $ARRAY_MAX_DIM ;in this array we write position i.e. index + 1 to avoid 1st value == 0
	kDilimPosIndx init 0
	kDilimInArrCnt init 0
	
	;kBeginDelimCnt = kPartIndx
	;kEndDelimCnt = kPartIndx+1
	kBeginIndx init 0
	kEndIndx init 0
	
	kInArrActualLen = len_arr_new(kInArr)
	fprintks 	$DUMP_FILE_NAME, "\nlen_arr_new(kInArr) = %d\n", kInArrActualLen
	
	kDilimInArrCnt = number_in_arr_cnt(kInArr, kDelim)
	fprintks 	$DUMP_FILE_NAME, "\nkDilimInArrCnt = %d\n", kDilimInArrCnt
	
	;kDilimPosArr[kDilimPosIndx] = 1 ;see array init above
	;kDilimPosIndx += 1
	
	kIndx  = 0
	until kInArr[kIndx] == 0 do
	  ;kArr[kIndx] rnd31 10, 0
	  fprintks 	$DUMP_FILE_NAME, "\nkInArr[%d] = %d kDelim = %d\n", kIndx, kInArr[kIndx], kDelim
	  
	  if kInArr[kIndx] == kDelim then
		kDilimPosArr[kDilimPosIndx] = kIndx + 1
		fprintks 	$DUMP_FILE_NAME, "\nkDilimPosArr[%d] = %d\n", kDilimPosIndx, kDilimPosArr[kDilimPosIndx]
		kDilimPosIndx += 1		
	  endif
	  
	  kIndx += 1
	od
	
	;kDilimPosArr[kDilimPosIndx] = kInArrActualLen
	;fprintks 	$DUMP_FILE_NAME, "\nkDilimPosArr[%d] = %d\n", kDilimPosIndx, kDilimPosArr[kDilimPosIndx]
	;kDilimPosIndx += 1
	kDilimPosArr[kDilimPosIndx] = 0
	fprintks 	$DUMP_FILE_NAME, "\nkDilimPosArr[%d] = %d\n", kDilimPosIndx, kDilimPosArr[kDilimPosIndx]
	kRes = dump_1dim_arr_to_file(kDilimPosArr, 0)
	
	kBeginIndx = kDilimPosArr[kPartIndx] ;-1 see above 
	kEndIndx = kDilimPosArr[kPartIndx+1]-1 ;-1 see above
	fprintks 	$DUMP_FILE_NAME, "\nbegin indx = %d end indx = %d\n", kBeginIndx, kEndIndx
	
	kOutIndx  = 0
	kIndx  = kBeginIndx
	until kIndx == kEndIndx do
	  kOutArr[kOutIndx] = kInArr[kIndx]
	  kOutIndx += 1
	  kIndx += 1
	od
	kOutIndx += 1
	kOutArr[kOutIndx] = 0;
	kRes = dump_1dim_arr_to_file(kOutArr, 0)
	
	xout kOutArr
endop
