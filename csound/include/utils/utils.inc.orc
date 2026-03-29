// requires "dev2\csound\include\utils\table.v2.orc"

opcode pow_exponent_sign, k, kk
    kVal2Test, kDirection xin
    kRes init 1
    if kVal2Test < 0 then
        kRes = -1
    endif

    if kVal2Test == 0 && kDirection == 1 then
        kRes = 1
    elseif kVal2Test == 0 && kDirection == -1 then 
        kRes = -1
    endif

    xout kRes
endop

/*
========================================
            multiply
========================================

pseudocode:
mul(current_val, current_step, step_to_go, steps_array) = {
	for(i = current_step, step_to_go, 1) {
		current_val *= pow(
			steps_array[
				modulo(
					abs(i),
					len(steps_array)
				)
			],
			is_positive(i)
		)
	};
	current_val;
};
*/

/*
opcode multiply uses for calculate value like frequency based on 
    current freq (kCurrentVal), 
    array (kStepsArray) - for ratios between next and current step, e.g. 
        equal 12-step temperation implies that ratio of every next freq and 
        current freq are equal to pow(2, 1/12)
    current step (kCurrentStep) - begining index in array
    steps to go (kStepToGo) - how many steps should be gone
*/
// 
// array continuation like mirror, e.g.
//                                               <-- | -->
// [2, 3, 4, 5, 6] means  ... 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, 2, 3, 4, 5, 6, ...
// ERROR: downstep now work like
//  ... 4, 3, 2, 2, 3, 4 ...
//
opcode multiply, k, kkkk[]
    kCurrentVal, kCurrentStep, kStepToGo, kStepsArray[] xin
    
    kDirection init 1
    kFlag init 0

    if kFlag == 0 then
        kFlag = 1
        
        if kCurrentStep > kStepToGo then
            kDirection = -1
        endif

        // kStepToGo = kStepToGo - 1 
    endif 

    kLenStepArr = lenarray(kStepsArray)

    /*
    printf("kCurrentVal = %f, kCurrentStep = %f, kStepToGo = %f\n", abs(kCurrentStep) + 1, kCurrentVal, kCurrentStep, kStepToGo)
    printf("kCurrentStep = %d, kDirection = %d, kStepToGo = %d\n\n", abs(kCurrentStep) + 1, kCurrentStep, kDirection, kStepToGo)
    */

    while (kCurrentStep * kDirection) < (kStepToGo * kDirection) do
            kCurrentStep = kCurrentStep + kDirection
            //kCurrentVal = kCurrentVal * pow(kStepsArray[abs(kCurrentStep)%kLenStepArr], pow_exponent_sign(kCurrentStep, kDirection))
            kCurrentVal = kCurrentVal * pow(kStepsArray[circular_index(kCurrentStep, kLenStepArr)], pow_exponent_sign(kCurrentStep, kDirection))

            /*
            printf("kCurrentStep = %d, kDirection = %d, kStepToGo = %d\n", abs(kCurrentStep) + 1, kCurrentStep, kDirection, kStepToGo)
            printf("kCurrentVal = %f, kCurrentStep = %f, kStepToGo = %f\n", abs(kCurrentStep) + 1, kCurrentVal, kCurrentStep, kStepToGo)
            printf("circular_index(kCurrentStep, kLenStepArr) = %f, kLenStepArr = %d, is_non_negative(kCurrentStep) = %f\n", \
                abs(kCurrentStep) + 1, \
                circular_index(kCurrentStep, kLenStepArr), \
                kLenStepArr, pow_exponent_sign(kCurrentStep, kDirection) \
            )
            */
    od

    xout kCurrentVal
endop


opcode addition, k, kkkk[]
    kCurrentVal, kCurrentStep, kStepToGo, kStepsArray[] xin

    kDirection init 1

    if kCurrentStep > kStepToGo then
        kDirection = -1
    endif 

    kLenStepArr = lenarray(kStepsArray)

    while (kCurrentStep * kDirection) < (kStepToGo * kDirection) do
            kCurrentVal = kCurrentVal + (kStepsArray[abs(kCurrentStep)%kLenStepArr] * kDirection)
            kCurrentStep = kCurrentStep + kDirection
    od

    xout kCurrentVal
endop
