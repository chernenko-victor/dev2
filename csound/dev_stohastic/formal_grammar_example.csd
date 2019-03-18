<CsoundSynthesizer>
<CsOptions>
  ;Здесь пишут параметры генерации (напр., название и тип звукового файла и проч.)
</CsOptions>
<CsInstruments>
  ;Описание оркестра
  sr        = 44100
  kr        = 4410
  ksmps     = 10
  nchnls    = 2
  0dbfs     = 1 ;amplitudes must be less or equal than 1
  
  include("list.class.csd");
  include("formal_grammar.class.csd");
  
  /* instr     0 */
  /*
	array aFormalGrammar(
	[
		[
			[0] , 
			[1, -1], [-1, -2, 2]
		],

		[
			[-2, 2, -1] , 
			[1, -3, -3, 4, -2, -2], [-1, 3, -4, 2]
		],

		[
			[-4, 2] , 
			[-2, -2, -2, -1, -1], [-3, -3, 1, 2], [-1, -1, 3]
		],

		[
			[1] , 
			[-3, -3, -3, -3], [2, -2, -2, -2]
		],

		[
			[2] , 
			[-1, -1], [1, -4, -4, -4]
		],

		[
			[3] , 
			[-1, -2, -2, -3], [-1, -2, 3, -2, -1]
		],

		[
			[-1, 3] , 
			[-1, -2, -2, -3], [1, -2, -2, -4, -4, -4]
		]
	]
	);

	list<int> lFinal;

	lFinal.pushArray(aFormalGrammar[0][0]); //[0] -> lFinal(0)

	FormalGrammar fgNewGrammar(aFormalGrammar);
	fgNewGrammar.generate();
  */
  /* endin */

  instr     1
	/*
	process lFinal
	...
	*/
  endin
  
</CsInstruments>
<CsScore>
  ;Партитура
  
  ;notes
  i     1   0   5   .9    1.
  i     1   6   2   .9    1.25
  i     1   9   1   .9    .75
  e
  
</CsScore>
</CsoundSynthesizer>