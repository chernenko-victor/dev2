/*
FLpanel "Dev2", 450, 550, 100, 100 ;***** start of container
	FLgroup "Modus Select", 200, 200, 10, 10	
		;gk1, iha 		FLslider "FLslider 1", 500, 1000, 0 ,1, -1, 300,15, 20,50
		gkVol, iHdlVol	FLslider "Volume", .001, .99, 1, 2, idisp, iwidth, \
			iheight, ix, iy
	FLgroupEnd
FLpanelEnd ;***** end of container
*/
/*
FLpanel "Dev2", 900, 500, 10, 10
	FLgroup "Modus Select", 200, 200, 10, 10
		; Width of the value display box in pixels
		iwidth = 50
		; Height of the value display box in pixels
		iheight = 20
		; Distance of the left edge of the value display
		; box from the left edge of the panel
		ix = 65
		; Distance of the top edge of the value display
		; box from the top edge of the panel
		iy = 55

		idisp FLvalue "Hertz", iwidth, iheight, ix, iy
		;kout, ihandle FLslider "label", imin, imax, iexp, itype, idisp, iwidth, iheight, ix, iy
		gkfreq, ihandle FLslider "Frequency", 200, 5000, -1, 5, idisp, 750, 30, 125, 50
		FLsetVal_i 500, ihandle
	FLgroupEnd
; End of panel contents
FLpanelEnd
*/

FLpanel "Dev2", 900, 700, 10, 10
;	FLgroup "Modus Select", 200, 200, 20, 20
		; Minimum value output by counter
		imin = 0
		; Maximum value output by counter
		imax = 8
		; Single arrow step size (semitones)
		istep1 = 1
		; Double arrow step size (octave)
		istep2 = 1 
		; Counter type (1=double arrow counter)
		itype = 1
		; Width of the counter in pixels
		iwidth = 150
		; Height of the counter in pixels
		iheight = 30
		; Distance of the left edge of the counter
		; from the left edge of the panel
		ix = 20
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iy = 20
		; Score event type (-1=ignored)
		iopcode = -1
		gkRythmMode, iHdlRythmMode FLcount "Rythm Mode Number", imin, imax, istep1, istep2, itype, iwidth, iheight, ix, iy, iopcode
		
		
		; Distance of the left edge of the counter
		; from the left edge of the panel
		iPitchModX = 200
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iPitchModY = 20
		; Score event type (-1=ignored)
		iopcode = -1
		gkPitchMode, iHdlPitchMode FLcount "Pitch Mode Number", imin, imax, istep1, istep2, itype, iwidth, iheight, iPitchModX, iPitchModY, iopcode		
				
		
		; Minimum value output by the text box
		iFreqTxtMin = 200
		; Maximum value output by the text box
		iFreqTxtMax = 5000
		; Step size
		iFreqTxtStep = 1
		; Text box graphic type
		iFreqTxtType = 1
		; Width of the text box in pixels
		iFreqTxtWidth = 70
		; Height of the text box in pixels
		iFreqTxtHeight = 30
		; Distance of the left edge of the text box 
		; from the left edge of the panel
		iFreqTxtX = 400
		; Distance of the top edge of the text box
		; from the top edge of the panel
		iFreqTxtY = 20
		gkFreqTxtVal, iHdlFreqTxt FLtext "Resonans Frequency", iFreqTxtMin, iFreqTxtMax, iFreqTxtStep, iFreqTxtType, iFreqTxtWidth, iFreqTxtHeight, iFreqTxtX, iFreqTxtY
		
		
		iDispFreqKnobValWidth = 50
		iDispFreqKnobValHeight = 20
		iDispFreqKnobValX = 500
		iDispFreqKnobValY = 20
		iDispFreqKnobVal FLvalue "Hertz", iDispFreqKnobValWidth, iDispFreqKnobValHeight, iDispFreqKnobValX, iDispFreqKnobValY
		
		; Minimum value output by the knob
		iFreqMin = 200
		; Maximum value output by the knob
		iFreqMax = 5000
		; Logarithmic type knob selected
		iFreqExp = -1
		; Knob graphic type (1=3D knob)
		iFreqType = 1 
		; Display handle (-1=not used)
		iFreqDisp = iDispFreqKnobVal
		; Width of the knob in pixels
		iFreqWidth = 70
		; Distance of the left edge of the knob 
		; from the left edge of the panel
		iFreqX = 550
		; Distance of the top edge of the knob 
		; from the top of the panel
		iFreqY = 20
		gkFreqKnobVal, iHdlFreqKnob FLknob "Fundamental Frequency", iFreqMin, iFreqMax, iFreqExp, iFreqType, iFreqDisp, iFreqWidth, iFreqX, iFreqY
		
		
		; Minimum value output by counter
		iInstrNumMin = 0
		; Maximum value output by counter
		iInstrNumMax = 10
		; Single arrow step size (semitones)
		iInstrNumStep1 = 1
		; Double arrow step size (octave)
		iInstrNumStep2 = 1 
		; Counter type (1=double arrow counter)
		iInstrNumType = 1
		; Width of the counter in pixels
		iInstrNumWidth = 150
		; Height of the counter in pixels
		iInstrNumHeight = 30
		; Distance of the left edge of the counter
		; from the left edge of the panel
		iInstrNumX = 650
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iInstrNumY = 20
		; Score event type (-1=ignored)
		iInstrNumOpcode = -1
		gkInstrNum, iHdlInstrNum FLcount "Instrument Number", iInstrNumMin, iInstrNumMax, iInstrNumStep1, iInstrNumStep2, iInstrNumType, iInstrNumWidth, \
		iInstrNumHeight, iInstrNumX, iInstrNumY, iInstrNumOpcode
		
		
		iDispQValWidth = 50
		iDispQHeight = 20
		iDispQValX = 20
		iDispQValY = 150
		iHdlDispQVal FLvalue "Q", iDispQValWidth, iDispQHeight, iDispQValX, iDispQValY
		
		; Minimum value output by the slider
		iQmin = 0.01
		; Maximum value output by the slider
		iQmax = .9
		; Logarithmic type slider selected
		iQexp = -1
		; Slider graphic type (5='nice' slider)
		iQtype = 5 
		; Display handle (-1=not used)
		iQdisp = iHdlDispQVal
		; Width of the slider in pixels
		iQwidth = 80
		; Height of the slider in pixels
		iQheight = 30
		; Distance of the left edge of the slider
		; from the left edge of the panel
		iQx = 100
		; Distance of the top edge of the slider 
		; from the top edge of the panel
		iQy = 150
		gkQ, iHdlQ FLslider "Quality factor", iQmin, iQmax, iQexp, iQtype, iQdisp, iQwidth, iQheight, iQx, iQy
		
		
		iDispQ2ValWidth = 50
		iDispQ2Height = 20
		iDispQ2ValX = 200
		iDispQ2ValY = 150
		iHdlDispQ2Val FLvalue "Q2", iDispQ2ValWidth, iDispQ2Height, iDispQ2ValX, iDispQ2ValY
		
		; Minimum value output by the slider
		iQ2min = 0.01
		; Maximum value output by the slider
		iQ2max = .9
		; Logarithmic type slider selected
		iQ2exp = -1
		; Slider graphic type (5='nice' slider)
		iQ2type = 5 
		; Display handle (-1=not used)
		iQ2disp = iHdlDispQ2Val
		; Width of the slider in pixels
		iQ2width = 80
		; Height of the slider in pixels
		iQ2height = 30
		; Distance of the left edge of the slider
		; from the left edge of the panel
		iQ2x = 250
		; Distance of the top edge of the slider 
		; from the top edge of the panel
		iQ2y = 150
		gkQ2, iHdlQ2 FLslider "Quality factor2", iQ2min, iQ2max, iQ2exp, iQ2type, iQ2disp, iQ2width, iQ2height, iQ2x, iQ2y
		
		
		iBtnon = 0
		iBtnoff = 0
		iBtntype = 1
		iBtnwidth = 50
		iBtnheight = 50
		iBtnx = 10
		iBtny = iQ2y + iQ2height + 50
		iBtnopcode = 0
		iBtnstarttim = 0
		iBtndur = -1  ;Turn instruments on idefinitely

		; Normal speed forwards
		gkBtnplay, ihBtnb1 FLbutton "@>", iBtnon, iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx, iBtny, iBtnopcode, 1, iBtnstarttim, iBtndur, 1 
		; Stationary 
		gkBtnstop, ihBtnb2 FLbutton "@square", iBtnon,iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx+55, iBtny, iBtnopcode, 2, iBtnstarttim, iBtndur
		; Double speed backwards
		gkBtnrew, ihBtnb3 FLbutton "@<<", iBtnon, iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx + 110, iBtny, iBtnopcode, 1, iBtnstarttim, iBtndur, -2
		; Double speed forward
		gkBtnff, ihBtnb4 FLbutton "@>>", iBtnon, iBtnoff, iBtntype, iBtnwidth, iBtnheight, iBtnx+165, iBtny, iBtnopcode, 1, iBtnstarttim, iBtndur, 2
		; Type 1
		gkBtnt1, ihBtnt1 FLbutton "More Expression", iBtnon, iBtnoff, 1, 200, 40, iBtnx, iBtny + 65, -1 
		; Type 2
		gkBtnt2, ihBtnt2 FLbutton "Bang Env", iBtnon, iBtnoff, 2, 200, 40, iBtnx, iBtny + 110, -1 
		; Type 3
		gkBtnt3, ihBtnt3 FLbutton "Toggle function", iBtnon, iBtnoff, 3, 200, 40, iBtnx, iBtny + 155, -1 
		; Type 4
		gkBtnt4, ihBtnt4 FLbutton "Test Env", iBtnon, iBtnoff, 4, 200, 40, iBtnx, iBtny + 200, -1 
		; Type 21
		gkBtnt5, ihBtnt5 FLbutton "Expression Breakpoint", iBtnon, iBtnoff, 21, 200, 40, iBtnx, iBtny + 245, -1 
		; Type 22
		gkBtnt6, ihBtnt6 FLbutton "Amp Envelope Breakpoint", iBtnon, iBtnoff, 22, 200, 40, iBtnx, iBtny + 290, -1
		; Type 23
		gkBtnt7, ihBtnt7 FLbutton "Panic", iBtnon, iBtnoff, 23, 200, 40, iBtnx, iBtny + 335, -1
		
		
		; Minimum value output by counter
		iDistrTypeNoteStartMin = 1
		; Maximum value output by counter
		iDistrTypeNoteStartMax = 7
		; Distance of the left edge of the counter
		; from the left edge of the panel
		iDistrTypeNoteStartX = 400
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iDistrTypeNoteStartY = 150
		; Score event type (-1=ignored)
		iopcode = -1
		gkiDistrTypeNoteStart, iHdlDistrTypeNoteStart FLcount "Distr Type Note Start", iDistrTypeNoteStartMin, iDistrTypeNoteStartMax, istep1, istep2, itype, iwidth, iheight, iDistrTypeNoteStartX, iDistrTypeNoteStartY, iopcode
		
		iDispMinPeriodKnobValWidth = 50
		iDispMinPeriodKnobValHeight = 20
		iDispMinPeriodKnobValX = 600
		iDispMinPeriodKnobValY = 150
		iDispMinPeriodKnobVal FLvalue "Sec", iDispMinPeriodKnobValWidth, iDispMinPeriodKnobValHeight, iDispMinPeriodKnobValX, iDispMinPeriodKnobValY
		
		; Minimum value output by the knob
		iMinPeriodMin = .15
		; Maximum value output by the knob
		iMinPeriodMax = 2.5
		; Logarithmic type knob selected
		iMinPeriodExp = -1
		; Knob graphic type (1=3D knob)
		iMinPeriodType = 1 
		; Display handle (-1=not used)
		iMinPeriodDisp = iDispMinPeriodKnobVal
		; Width of the knob in pixels
		iMinPeriodWidth = 70
		; Distance of the left edge of the knob 
		; from the left edge of the panel
		iMinPeriodX = 650
		; Distance of the top edge of the knob 
		; from the top of the panel
		iMinPeriodY = 150
		gkMinPeriod, iHdlMinPeriod FLknob "Minimal Duration", iMinPeriodMin, iMinPeriodMax, iMinPeriodExp, iMinPeriodType, iMinPeriodDisp, iMinPeriodWidth, iMinPeriodX, iMinPeriodY
		
		
		; Minimum value output by counter
		iDistrTypeNoteDurMin = 1
		; Maximum value output by counter
		iDistrTypeNoteDurMax = 7
		; Distance of the left edge of the counter
		; from the left edge of the panel
		iDistrTypeNoteDurX = 730
		; Distance of the top edge of the counter
		; from the top edge of the panel
		iDistrTypeNoteDurY = 150
		; Score event type (-1=ignored)
		iopcode = -1
		gkDurTypeOfDistrib, iHdlDistrTypeNoteDur FLcount "Distr Type Note Duration", iDistrTypeNoteDurMin, iDistrTypeNoteDurMax, istep1, istep2, itype, iwidth, iheight, iDistrTypeNoteDurX, iDistrTypeNoteDurY, iopcode
		
;	FLgroupEnd
; End of panel contents
FLpanelEnd
FLrun ;***** runs the widget thread, it is always required!

FLsetVal_i 1, iHdlRythmMode
FLsetVal_i 7, iHdlPitchMode
FLsetVal_i 300, iHdlFreqKnob
FLsetVal_i 300, iHdlFreqTxt
FLsetVal_i 0, iHdlFreqTxt
FLsetVal_i 0.5, iHdlQ
FLsetVal_i 0.5, iHdlQ2
FLsetVal_i 7, iHdlDistrTypeNoteStart
FLsetVal_i .25, iHdlMinPeriod
FLsetVal_i 2, iHdlDistrTypeNoteDur

