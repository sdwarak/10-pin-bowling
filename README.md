# 10-pin-bowling

This ruby file makes it easy to simulate the score for 10-pin bowling game. 

The input is frames on the board and the output will be the respective score for the board.

# My approach

I took an approach of considering everything as an event. The first event is a roll event and everything else are subsequent to it.
And the points are counted much the same way a manual scorer would score the board with some subtle differences. 

The game can be split into following events.

|Event Name|Description|
|--------|--------|
|shot|The exact time at which pins are counted.|
