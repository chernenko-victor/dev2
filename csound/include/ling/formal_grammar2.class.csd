;require #include include\math\stochastic\distribution3.inc.csd"
;require #include include\utils\table.v1.csd"

;Context-free Formal Grammar
opcode CFFG, k[], k[][]k[][]k[]
	kRules[][], kAlternativeProb[][], kFinal[] xin

	kTemporary[] init 128
	;kAlternativeRules[] init 128, 128
	kCurrentRule[] init 128
	kDiscrProb[] init 128

	iSeedType = 0
	kTypeOfDistrib init 1
	kMin init 0
	kMax init 1
	kDistribDepth init 1

		;fprintks 	$DUMP_FILE_NAME, "\n========================== FG testing \n"
		kIndex = 0
		;fprintks 	$DUMP_FILE_NAME, "\ngkFinal[%d] = %f\n", kIndex, kFinal[kIndex]
		while (kFinal[kIndex] != 0)&&(len_arr_new(kFinal) < 127) do
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
					;fprintks 	$DUMP_FILE_NAME, "\nGet alternative index by random\n", kAltRuleIndex
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
							;fprintks 	$DUMP_FILE_NAME, "\nkCurrentRule[%d] = %f\n", kCurrentRuleIndex, kCurrentRule[kCurrentRuleIndex]
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
