# 10-pin-bowling

This ruby file makes it easy to simulate the score for 10-pin bowling game. 

The input is frames on the board and the output will be the respective score for the board.

# My approach

I took an approach of considering everything as an event. The first event is a roll event and everything else are subsequent to it.
And the points are counted much the same way a manual scorer would score the board with some subtle differences. 

The game can be split into following events.

|Event Name|Description|
|--------|--------|
|Shot|The exact time at which pins are counted.|
|Frame complete|The frame is complete when the remaining pins are zero or when both shot are played.|
|Strike|When 10 pins are shot in the first attempt.|
|Spare|When all 10 pins are shot in the second attempt.|
|Awared bonuses|Bonuses are awarded when a strike or spare event takes place.|
|Display|Display to show the points are counted.|
