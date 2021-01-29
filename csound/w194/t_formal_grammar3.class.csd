;require #include include\math\stochastic\distribution3.inc.csd"
;require #include include\utils\table.v1.csd"


;Context-free Formal Grammar
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


opcode slicearray_my, k[], k[]kk 
	kCurrentRule[], kIndxBegin, kIndxEnd xin
	kOutArr[] init $ARRAY_MAX_DIM
	
	
	fprintks 	$DUMP_FILE_NAME, "\n ========================	slicearray_my ==========================\n"
	fprintks 	$DUMP_FILE_NAME, "\n kIndxBegin = %d, kIndxEnd = %d\n", kIndxBegin, kIndxEnd
	
	kOtherIndex = kIndxBegin
	while kCurrentRule[kOtherIndex] != kIndxEnd do 
		kOutArr[kOtherIndex] = kCurrentRule[kOtherIndex]
		
		fprintks 	$DUMP_FILE_NAME, "\kOutArr[%d] = %f | kCurrentRule[%d] = %f \n", kOtherIndex, kOutArr[kOtherIndex], kOtherIndex,  kCurrentRule[kOtherIndex]
		kOtherIndex = kOtherIndex + 1
	od
	
	xout kOutArr
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


opcode get_alter_rule_by_prob, k[], k[]k
	kCurrentRule[], kAltRuleNumber xin
	kCurrentRuleAlter[] init $ARRAY_MAX_DIM
	;kAltRuleNumber = 0, len(prob_arr)-1
	;kAltRuleNumber = 0 :: from 0 to 1st occurence delim
	;kAltRuleNumber = 1 :: from 1st occurence delim to 2st occurence delim
	;...
	;kAltRuleNumber = N :: from Nth occurence delim to (N+1)th occurence delim
	kIndxBegin init 0
	kIndxEnd init 0
	
	fprintks 	$DUMP_FILE_NAME, "\nget_alter_rule_by_prob :: \n"
	kIndex = 0
	kAltRuleDelimCount = 0
	
	 
		while kCurrentRule[kIndex] != 0 do ;2DO add exeption "no kDelim = 0"
			fprintks 	$DUMP_FILE_NAME, "\nkInArr[%d] = %f\n", kIndex, kCurrentRule[kIndex]
			if kCurrentRule[kIndex] == $ALTERNATIVE_RULE_DELIM then
				kAltRuleDelimCount += 1
			endif
			if kAltRuleDelimCount == kAltRuleNumber then
				if kAltRuleNumber > 0 then 
					kIndxBegin = kIndex + 1
				endif
			endif
			if kAltRuleDelimCount == kAltRuleNumber+1 then
				kIndxEnd = kIndex
			endif
			kIndex = kIndex + 1
		od	
	;cut from kCurrentRule[kIndxBegin] to kCurrentRule[kIndxEnd] ->  kCurrentRuleAlter
	kCurrentRuleAlter slicearray_my kCurrentRule, kIndxBegin, kIndxEnd ; kIndxEnd == 0 WTF???
	
	;kCurrentRuleAlter append with 0
	kIndxEnd += 1
	kCurrentRuleAlter[kIndxEnd] = 0;
	
	fprintks 	$DUMP_FILE_NAME, "\nkCurrentRuleAlter from get_alter_rule_by_prob\n"
	kTest1122 dump_1dim_arr_to_file kCurrentRuleAlter, 0
	
	xout kCurrentRuleAlter
endop

opcode get_rule_by_nonfinite_node, k[], kk[][]k[][]
	kNonfinitNode, kRules[][], kAlternativeProb[][] xin
	
	kCurrentRule[] init $ARRAY_MAX_DIM
	kCurrentRuleOneAlternative[] init $ARRAY_MAX_DIM
	kDiscrProb[] init $ARRAY_MAX_DIM
	
	;kTmp[] init $ARRAY_MAX_DIM
	
	iSeedType = 0
	kTypeOfDistrib init 1
	kMin init 0
	kMax init 1
	kDistribDepth init 1
	
	;fprintks 	$DUMP_FILE_NAME, "\nLook for replacement rule\n"
	kIndexRow = 0
	while kRules[kIndexRow][0] != kNonfinitNode do ;2DO add exeption "no rule for kNonfinitNode"
					kIndexRow = kIndexRow + 1
	od	
	fprintks 	$DUMP_FILE_NAME, "\nIndex for replacement rule found :: kIndexRow = %f\n\nCopy rule to temporary array\n", kIndexRow
	
	
	;fprintks 	$DUMP_FILE_NAME, "\nCopy replacement rule\n"	
	kCurrentRule = get_1dim_arr_from_2dim_arr(kIndexRow, kRules, 0, 1, 1)
	kRes = dump_1dim_arr_to_file(kCurrentRule, 0)
	
	;kTmpIndx = 0
	;fprintks 	$DUMP_FILE_NAME, "\nkCurrentRule[%d] = %f\n", kTmpIndx, kCurrentRule[kTmpIndx]
	
	kDiscrProb = get_1dim_arr_from_2dim_arr(kIndexRow, kAlternativeProb, -1, -1, 0)
	;kRes = dump_1dim_arr_to_file(kDiscrProb, -1)
	
	kAltRuleNumber = get_discr_distr_k(iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kDiscrProb)
	fprintks 	$DUMP_FILE_NAME, "\nkAltRuleNumber = %d\n", kAltRuleNumber
	
	kCurrentRuleOneAlternative = get_alter_rule_by_prob(kCurrentRule, kAltRuleNumber) ;4TEST
	
	xout kCurrentRuleOneAlternative
endop

opcode CFFG2, k[], k[][]k[][]k[]
	kRules[][], kAlternativeProb[][], kFinal[] xin

	kTemporary[] init $ARRAY_MAX_DIM
	;kAlternativeRules[] init 128, 128
	kCurrentRule[] init $ARRAY_MAX_DIM
	;kDiscrProb[] init $ARRAY_MAX_DIM

	
	/*
	iSeedType = 0
	kTypeOfDistrib init 1
	kMin init 0
	kMax init 1
	kDistribDepth init 1
	*/
	
	fprintks 	$DUMP_FILE_NAME, "\n========================== FG testing \n"
	kIndex = 0
	fprintks 	$DUMP_FILE_NAME, "\nkFinal[%d] = %f :: len_arr_new(kFinal) = %d\n", kIndex, kFinal[kIndex], len_arr_new(kFinal)
	
	
	
	while (kFinal[kIndex] != 0)&&(len_arr_new(kFinal) < $ARRAY_MAX_DIM - 1) do
	
		fprintks 	$DUMP_FILE_NAME, "\nCurrent Node :: kFinal[%d] = %f\n", kIndex, kFinal[kIndex]
		
		if kFinal[kIndex] > 0 then
			kNonfinitNode = kFinal[kIndex]
			fprintks 	$DUMP_FILE_NAME, "\nNonfinite Node found :: kNonfinitNode = %f\n", kNonfinitNode
			kCurrentRule = get_rule_by_nonfinite_node(kNonfinitNode, kRules, kAlternativeProb)
			
			;replace Nonfinite Node with One alternative Rule
			;kFinal = ReplaceArrElWithArr(kFinal, kIndex, kCurrentRule)
			
			;lets go from begin
			;kIndex = 0
			
		;else ;go further
			;kIndex = kIndex + 1	
		endif
		kIndex = kIndex + 1
	
	od
	kFinal[kIndex+1] = 0
	xout kFinal
endop

;Context-free Formal Grammar
opcode CFFG, k[], k[][]k[][]k[]
	kRules[][], kAlternativeProb[][], kFinal[] xin

	kTemporary[] init $ARRAY_MAX_DIM
	;kAlternativeRules[] init 128, 128
	kCurrentRule[] init $ARRAY_MAX_DIM
	kDiscrProb[] init $ARRAY_MAX_DIM

	iSeedType = 0
	kTypeOfDistrib init 1
	kMin init 0
	kMax init 1
	kDistribDepth init 1

		;fprintks 	$DUMP_FILE_NAME, "\n========================== FG testing \n"
		kIndex = 0
		;fprintks 	$DUMP_FILE_NAME, "\ngkFinal[%d] = %f\n", kIndex, kFinal[kIndex]
		while (kFinal[kIndex] != 0)&&(len_arr_new(kFinal) < $ARRAY_MAX_DIM - 1) do
			;fprintks 	$DUMP_FILE_NAME, "\nCurrent Node :: kFinal[%d] = %f\n", kIndex, kFinal[kIndex]
			if kFinal[kIndex] > 0 then
				kNonfinitNode = kFinal[kIndex]
				;fprintks 	$DUMP_FILE_NAME, "\nNonfinite Node found :: kNonfinitNode = %f\n", kNonfinitNode

				kIndexRow = 0
				while kRules[kIndexRow][0] != kNonfinitNode do
					kIndexRow = kIndexRow + 1
				od
				;fprintks 	$DUMP_FILE_NAME, "\nIndex for replacement rule found :: kIndexRow = %f\n\nCopy rule to temporary array\n", kIndexRow

				kIndexCol = 1
				kIndexTmp = 0

				;fprintks 	$DUMP_FILE_NAME, "\nSlice for alternative rules\n"
				;===========================================================
				kAltRuleIndex = 0
				while (kRules[kIndexRow][kIndexCol] != 0) do
					if kRules[kIndexRow][kIndexCol] == $ALTERNATIVE_RULE_DELIM then
						kAltRuleIndex = kAltRuleIndex + 1
					endif
					kIndexCol = kIndexCol + 1
				od
				kIndexCol = 1

				;fprintks 	$DUMP_FILE_NAME, "\nALTERNATIVE_RULE_DELIM count = %d\n", kAltRuleIndex
				;fprintks 	$DUMP_FILE_NAME, "\nBegin copy from all rules to current\n"
				kAltRuleNumber = 0
				kCurrRuleColBegin = 0
				kCurrRuleColEnd = 0
				if kAltRuleIndex>0 then
					;;fprintks 	$DUMP_FILE_NAME, "\nGet alternative index by random\n", kAltRuleIndex
					kDiscrProbIndex = 0
					while kDiscrProbIndex <= kAltRuleIndex do
						kDiscrProb[kDiscrProbIndex] = kAlternativeProb[kIndexRow][kDiscrProbIndex]
						kDiscrProbIndex = kDiscrProbIndex + 1
					od
					kAltRuleNumber = get_discr_distr_k(iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kDiscrProb)
					;fprintks 	$DUMP_FILE_NAME, "\nAlternative index by random :: kAltRuleNumber = %d\n", kAltRuleNumber

					kAltRuleIndex = 0
					kBeginCopy = 0
					kCurrentRuleIndex = 0
					while (kRules[kIndexRow][kIndexCol] != 0) do
						if kRules[kIndexRow][kIndexCol] == $ALTERNATIVE_RULE_DELIM then
							kAltRuleIndex = kAltRuleIndex + 1
						endif
					
						;fprintks 	$DUMP_FILE_NAME, "\nkAltRuleIndex = %f | kAltRuleNumber = %f\n", kAltRuleIndex, kAltRuleNumber
						if kAltRuleNumber == kAltRuleIndex then
							kBeginCopy = 1	
						elseif kAltRuleNumber < kAltRuleIndex then
							kBeginCopy = 0
						endif

						if (kBeginCopy == 1)&&(kRules[kIndexRow][kIndexCol] != $ALTERNATIVE_RULE_DELIM) then
							kCurrentRule[kCurrentRuleIndex] = kRules[kIndexRow][kIndexCol]
							;;fprintks 	$DUMP_FILE_NAME, "\nkCurrentRule[%d] = %f\n", kCurrentRuleIndex, kCurrentRule[kCurrentRuleIndex]
							kCurrentRuleIndex = kCurrentRuleIndex + 1
						endif
						kIndexCol = kIndexCol + 1
					od
				elseif kAltRuleIndex==0 then
					kCurrentRuleIndex = 0
					while (kRules[kIndexRow][kIndexCol] != 0) do
						kCurrentRule[kCurrentRuleIndex] = kRules[kIndexRow][kIndexCol]
						;fprintks 	$DUMP_FILE_NAME, "\nkCurrentRule[%d] = %f\n", kCurrentRuleIndex, kCurrentRule[kCurrentRuleIndex]
						kIndexCol = kIndexCol + 1
						kCurrentRuleIndex = kCurrentRuleIndex + 1
					od
				endif
				kCurrentRule[kCurrentRuleIndex+1] = 0				
				;fprintks 	$DUMP_FILE_NAME, "\nEnd copy from all rules to current\n"
				;===========================================================

				;kIndexCol = 1
				kIndexCol = 0
				kIndexTmp = 0

				;while kRules[kIndexRow][kIndexCol] != 0 do
				while kCurrentRule[kIndexCol] != 0 do
					;fprintks 	$DUMP_FILE_NAME, "\nkRules[%d][%d] = %f\n", kIndexRow,kIndexCol, kRules[kIndexRow][kIndexCol]
					;fprintks 	$DUMP_FILE_NAME, "\nkCurrentRule[%d] = %f\n", kIndexCol, kCurrentRule[kIndexCol]
					kTemporary[kIndexTmp] = kCurrentRule[kIndexCol]
					;fprintks 	$DUMP_FILE_NAME, "\nkTemporary[%d] = %f\n", kIndexTmp, kTemporary[kIndexTmp]
					kIndexCol = kIndexCol + 1
					kIndexTmp = kIndexTmp + 1
				od
				kIndexTmp = kIndexTmp + 1
				kTemporary[kIndexTmp] = 0
				;fprintks 	$DUMP_FILE_NAME, "\nkTemporary[%d] = %f\n", kIndexTmp, kTemporary[kIndexTmp]

				;fprintks 	$DUMP_FILE_NAME, "\nReplacing nonfinite node with rule\n", kIndexRow
				kFinal = ReplaceArrElWithArr(kFinal, kIndex, kTemporary)

				;fprintks 	$DUMP_FILE_NAME, "\nRestart scan for nonfinite node\n"
				kIndex = 0
			elseif kFinal[kIndex] < 0 then
				;fprintks 	$DUMP_FILE_NAME, "\nNonfinite Node not found, continue scanning for nonfinite node\n"
				kIndex = kIndex + 1
			endif
		od
		kFinal[kIndex+1] = 0

	xout kFinal
endop
