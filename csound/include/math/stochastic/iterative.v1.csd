opcode iter1, k, kk
    kRes, kParam xin
    kRes = 1 - kParam * pow:k(kRes, 2)
    xout kRes
endop

opcode hennon, kk, kkkk
    kX, kY, kFi, kDelta xin
    kXNext = kY +1 - kFi * kX * kX
	kYNext = kDelta * kX
    xout kXNext, kYNext
endop
