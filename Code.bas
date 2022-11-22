  10 REM *********************
  20 REM *    MasterMind     *
  30 REM *      V1.0.0       *
  40 REM * Mark Bennett 2022 *
  50 REM *********************

 100 CLEAR
 110 RANDOMISE
 120 initialise_game
 125 set_up_windows
 130 reset_game
 140 draw_help

1000 REPEAT forever
1010   select_difficulty
1015   reset_game
1017   BLOCK #1, 192, 170, 40, 30, 5
1020   select_secret_code
1030   draw_secret_code 0
1100   REPEAT until_end
1110     REPEAT until_play
1120       get_peg_play
1130       IF p$ = "p" OR p$ = "P" THEN EXIT until_play
1140       IF p$ = "q" OR p$ = "Q" THEN EXIT until_end
1190     END REPEAT until_play
1200     do_score
1210     IF detect_win = 1 THEN 
1220       PRINT #0, "You won in "; (try + 1);" rows."
1230       EXIT until_end
1240     END IF
1500     try = try + 1
1510     IF try > 9 THEN 
1520       PRINT #0, "You have run out of tries, you lose."
1530       EXIT until_end
1540     END IF
1600   END REPEAT until_end
1610   draw_secret_code 1
1990 END REPEAT forever

2000 DEF PROC get_peg_play
2010   LOCAL column, colour, i
2020   INPUT #0, "Enter peg position and colour (eg A1)" \ "or U to copy last try" \ "or S to swap (eg SAD to swap A and D)" \ "P to play row or Q to quit game "; p$
2030   LET column = -1
2040   LET colour = -1

2050   IF LEN(p$) = 2 THEN
2060     IF p$(1) = "A" OR p$(1) = "a" THEN column = 0
2070     IF p$(1) = "B" OR p$(1) = "b" THEN column = 1
2080     IF p$(1) = "C" OR p$(1) = "c" THEN column = 2
2090     IF p$(1) = "D" OR p$(1) = "d" THEN column = 3
2100     IF column > -1 THEN
2110       IF p$(2) = "0" THEN colour = -1
2120       IF p$(2) = "1" THEN colour = 0
2130       IF p$(2) = "2" THEN colour = 1
2140       IF p$(2) = "3" THEN colour = 2
2150       IF p$(2) = "4" THEN colour = 3
2160       IF p$(2) = "5" THEN colour = 4
2170       IF p$(2) = "6" THEN colour = 5
2180       IF p$(2) = "7" THEN colour = 6
2190     END IF
2200     IF column >= 0 AND column <= 3 AND colour >= -1 AND colour <= 6 THEN
2210       tries(try, column) = colour
2220       draw_peg 1, column, try
2230     END IF
2240   END IF

2300   IF LEN(p$) = 3 THEN
2310     IF p$(1) = "S" OR p$(1) = "s" THEN
2320       IF p$(2) = "A" OR p$(2) = "a" THEN 
2330         IF p$(3) = "B" OR p$(3) = "b" THEN swap_pegs 0, 1
2340         IF p$(3) = "C" OR p$(3) = "c" THEN swap_pegs 0, 2
2350         IF p$(3) = "D" OR p$(3) = "d" THEN swap_pegs 0, 3
2360       END IF
2370       IF p$(2) = "B" OR p$(2) = "b" THEN 
2380         IF p$(3) = "A" OR p$(3) = "a" THEN swap_pegs 1, 0
2390         IF p$(3) = "C" OR p$(3) = "c" THEN swap_pegs 1, 2
2400         IF p$(3) = "D" OR p$(3) = "d" THEN swap_pegs 1, 3
2410       END IF
2420       IF p$(2) = "C" OR p$(2) = "c" THEN 
2430         IF p$(3) = "A" OR p$(3) = "a" THEN swap_pegs 2, 0
2440         IF p$(3) = "B" OR p$(3) = "b" THEN swap_pegs 2, 1
2450         IF p$(3) = "D" OR p$(3) = "d" THEN swap_pegs 2, 3
2460       END IF
2470       IF p$(2) = "D" OR p$(2) = "d" THEN 
2480         IF p$(3) = "A" OR p$(3) = "a" THEN swap_pegs 3, 0
2490         IF p$(3) = "B" OR p$(3) = "b" THEN swap_pegs 3, 1
2500         IF p$(3) = "C" OR p$(3) = "c" THEN swap_pegs 3, 2
2510       END IF
2520     END IF
2530   END IF

2600   IF LEN(p$) = 1 THEN
2610     IF p$ = "U" OR p$ = "u" THEN
2620       IF try > 0 THEN
2630         FOR i = 0 TO 3
2640           tries(try, i) = tries(try - 1, i)
2645           draw_peg 1, i, try
2650         NEXT i
2660       END IF
2670     END IF
2680   END IF

2690 END DEF get_peg_play

2900 DEF PROC swap_pegs(a, b)
2910   LOCAL swap
2920   swap = tries(try, a)
2930   tries(try, a) = tries(try, b)
2940   tries(try, b) = swap
2950   draw_peg 1, a, try
2960   draw_peg 1, b, try
2990 END DEF swap_pegs

3000 DEF PROC do_score
3010   LOCAL markers(1, 3), i, j
3020   FOR i = 0 TO 3
3030     IF codePegs(i) = tries(try, i) THEN
3040       score(try, i) = 2
3050       markers(0, i) = 1
3060       markers(1, i) = 1
3070     END IF
3080   NEXT i

3090   FOR i = 0 TO 3
3100     FOR j = 0 TO 3
3110       IF i <> j THEN
3120         IF markers(0, i) = 0 AND markers(1, j) = 0 THEN
3130           IF codePegs(i) = tries(try, j) THEN
3140             score(try, j) = 1
3150             markers(0, i) = 1
3160             markers(1, j) = 1
3170           END IF
3180         END IF
3190       END IF
3200     NEXT j
3210   NEXT i 

3220   IF difficulty > 0 THEN
3230     LET j = 0
3240     INK #1, 0
3250     FOR i = 0 TO 3
3260       IF score(try, i) = 2 THEN
3270         FILL #1, 1
3280         CIRCLE #1, 60 + (j * 6), 5 + (try * 8), 1.3
3290         FILL #1, 0
3300         j = j + 1
3310       END If
3320     NEXT i
3330     INK #1, 7
3340     FOR i = 0 TO 3
3350       IF score(try, i) = 1 THEN
3360         FILL #1, 1
3370         CIRCLE #1, 60 + (j * 6), 5 + (try * 8), 1.3
3380         FILL #1, 0
3390         j = j + 1
3400       END If
3410     NEXT i

3420   ELSE
3430     FOR i = 0 TO 3
3440       IF score(try, i) > 0 THEN
3450         FILL #1, 1
3460         IF score(try, i) = 2 THEN
3470           INK #1, 0
3480         ELSE
3490           INK #1, 7
3500         END IF
3510         CIRCLE #1, 60 + (i * 6), 5 + (try * 8), 1.3
3520         FILL #1, 0
3530       ELSE
3540         INK #1, 3
3550         CIRCLE #1, 60 + (i * 6), 5 + (try * 8), 0.3
3560       END IF
3570     NEXT i
3580   END IF
3990 END DEF do_score

8000 DEF PROC select_secret_code
8010   LOCAL i, peg, available, picked, position, used(5)
8020   LET available = 5
8050   FOR i = 0 TO 3
8060     SELECT ON difficulty
8070       ON difficulty = 0 TO 1
8080         picked = RND(available)
8090         position = 0

8100         REPEAT until_selected
8110           IF used(position) = 0 THEN
8120             IF picked = 0 THEN 
8130               EXIT until_selected
8140             ELSE
8150               picked = picked -1
8160               position = position + 1
8170             END IF
8180           ELSE
8190             position = position + 1
8200           END IF
8210         END REPEAT until_selected
8220         used(position) = 1
8230         peg = position
8240         available = available -1

8290       ON difficulty = 2
8300         peg = RND(5)
8310       ON difficulty = 3
8320         peg = RND(6)
8330     END SELECT
8340     codePegs(i) = peg
8350   NEXT i     
8390 END DEF select_secret_code

8400 DEF PROC set_ink(colour)
8410   SELECT ON colour
8415     ON colour = -1 
8417       INK #1, 5
8420     ON colour = 0 
8430       INK #1, 0
8440     ON colour = 1 
8450       INK #1, 1
8460     ON colour = 2 
8470       INK #1, 2
8480     ON colour = 3 
8490       INK #1, 4
8500     ON colour = 4 
8510       INK #1, 6
8520     ON colour = 5 
8530       INK #1, 7
8540     ON colour = 6 
8550       INK #1, 5
8580   END SELECT
8590 END DEF set_ink

8600 DEF PROC draw_peg(type, peg, row)
8610   FILL #1, 1
8612   IF type = 0 THEN
8614     set_ink codePegs(peg)
8616   ELSE
8618     set_ink tries(row, peg)
8620   END IF
8630   CIRCLE #1, 20 + (peg * 8), 5 + (row * 8), 3
8640   FILL #1, 0
8650   INK #1, 0
8652   IF type = 0 THEN
8654     IF codePegs(peg) < 3 THEN INK #1, 7
8656   ELSE
8657     IF tries(row, peg) = -1 THEN INK #1, 5
8658     IF tries(row, peg) >= 0 AND tries(row, peg) < 3 THEN INK #1, 7
8660   END IF
8670   CIRCLE #1, 20 + (peg * 8), 5 + (row * 8), 3
8690 END DEF draw_peg

8700 DEF PROC draw_secret_code(show)
8710   BLOCK #1, 92, 18, 40, 6, 235
8720   IF show = 1 THEN
8730     draw_peg 0, 0, 11
8740     draw_peg 0, 1, 11
8750     draw_peg 0, 2, 11
8760     draw_peg 0, 3, 11
8770   END IF
8780   AT #1, 1, 12
8790   INK #1, 0
8800   PRINT #1, "Secret code"
8890 END DEF draw_secret_code

8900 DEF PROC select_difficulty
8910   LOCAL d
8920   REPEAT until_difficulty_accepted
8930     INPUT #0, "Enter difficulty " \ "(0 Easiest to 3 hardest) "; d
8940     IF d >= 0 AND d <= 3 THEN EXIT until_difficulty_accepted
8950   END REPEAT until_difficulty_accepted
8960   difficulty = d
8970   INK #1, 7 : AT #1, 19, 36 : PRINT #1, difficulty;
8990 END DEF select_difficulty

9000 DEF FUNCTION detect_win
9010   LOCAL count, i, value
9015   LET value = 0
9017   LET count = 0
9020   FOR i = 0 TO 3
9030     IF score(try, i) = 2 THEN count = count + 1
9040   NEXT i
9050   IF count = 4 THEN 
9060     value = 1
9070   END IF
9080   RETURN value 
9090 END DEF detect_win  

9100 DEF PROC draw_help
9110   INK #1, 7
9120   AT #1, 0, 25 : PRINT #1, "MASTERMIND"
9130   AT #1, 2, 25 : PRINT #1, "Colours"
9140   AT #1, 3, 25 : PRINT #1, "1"
9150   AT #1, 5, 25 : PRINT #1, "2"
9160   AT #1, 7, 25 : PRINT #1, "3"
9170   AT #1, 9, 25 : PRINT #1, "4"
9180   AT #1, 11, 25 : PRINT #1, "5"
9190   AT #1, 13, 25 : PRINT #1, "6"
9200   AT #1, 15, 25 : PRINT #1, "7"
9205   AT #1, 17, 25 : PRINT #1, "0 Clear Peg"
9210   AT #1, 19, 25 : PRINT #1, "Difficulty"
9220   draw_help_peg 0, 7, 82
9230   draw_help_peg 1, 7, 82 - 10
9240   draw_help_peg 2, 7, 82 - 20
9250   draw_help_peg 4, 0, 82 - 30
9260   draw_help_peg 6, 0, 82 - 40
9270   draw_help_peg 7, 0, 82 - 50
9280   draw_help_peg 5, 0, 82 - 60
9290 END DEF draw_help

9400 DEF PROC draw_help_peg(colour, border, y)
9420   FILL #1, 1
9430   INK #1, colour
9440   CIRCLE #1, 125, y, 3
9450   FILL #1, 0
9460   INK #1, border
9470   CIRCLE #1, 125, y, 3
9490 END DEF draw_help_peg

9500 DEF PROC reset_game
9510   LOCAL i, j
9520   FOR i = 0 TO 3
9530     codePegs(i) = -1
9540   NEXT i
9550   FOR i = 0 TO 9
9560     FOR j = 0 TO 3
9570       tries(i, j) = -1
9575       score(i, j) = 0
9580     NEXT j
9590   NEXT i
9600   try = 0
9690 END DEF reset_game

9700 DEF PROC set_up_windows
9710   PAPER #1, 5
9720   CLS #1
9790 END DEF set_up_windows

9800 DEF PROC initialise_game
9810   DIM codePegs(3)
9820   DIM tries(9, 3)
9830   DIM score(9, 3)
9840   LET try = 0
9846   REM difficulty 0 = max 1 of each colour, score pegs in relevant position
9847   REM difficulty 1 = max 1 of each colour
9848   REM difficulty 2 = repeat colours allowed
9849   REM difficulty 3 = includes blank as extra colour
9850   LET difficulty = 2
9860   LET p$ = ""
9890 END DEF initialise_game

9900 DEF PROC reset
9910   MODE 4
9920   PAPER 0 : INK 7
9930   CLS
9940 END DEF reset
