// requires "dev2\csound\include\utils\utils.inc.orc"

// gkScales[][] init 2, 127

/*
gkScales[0][0] = fillarray(0, 2, 4, 5, 7, 9, 11, 12) // diatonic european
gkScales[1][0]= fillarray(0, 2, 4, 7, 9, 11, 14, 16) // penthatonic-like


gSscalesInfo[][] init 2, 2

gSscalesInfo[0][0] = "diatonic european"
gSscalesInfo[1][0]= "penthatonic-like"
*/

opcode calc_min_interval, k, kk 
    kDiapason, kStepNumber xin
    kInterval = pow(kDiapason, 1/kStepNumber)
    xout kInterval
endop
