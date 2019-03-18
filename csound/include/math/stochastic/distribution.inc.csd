;---------------------------------------------------------------------------
#ifndef DistributionInc 
#define DistributionInc #1#
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;-----------------------        distribution        ------------------------
;---------------------------------------------------------------------------


instr generate2
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
           seed       p4
 ;generate four notes to be played from subinstrument
iNoteCount =          0
 until iNoteCount == 4 do
iFreq      random     400, 800
           event_i    "i", "play", iNoteCount, 2, iFreq
iNoteCount +=         1 ;increase note count
 enduntil
endin

#else 
;---------------------------------------------------------------------------
#end 