# QL-MasterMind
QL Version of the classic pegging game

I came across my family’s old game of MasterMind recently and it reminded me that I wrote a version for the QL back when I first had a Sinclair QL, 1985 or 86. While the code was lost in the mists of time the desire to write it was still there so I rewrote it in 2022.

A version of the popular coloured peg game for the Sinclair QL written in SuperBASIC.
Instructions, load in the basic from the text file or the MDV file and type “run”.
Select the difficulty level

0)	6 colours, no duplicate colours, score pegs in position to indicate correct pegs
1)	6 colours, no duplicate colours
2)	6 colours, duplicates possible
3)	7 colours, duplicates possible

Type in the column (A-D left to right) followed by the colour code to set a peg. E.G. A1 or C3
Type in a column and zero to clear the peg in the column.
Type in U to copy the last try (row) into the current try.
Type S followed by two column letters to swap those pegs, e.g. SBD will swap the pegs in B and D.
Type P to play the selected pegs, the score pins will show to the right.
Type Q to quit out of the game.
