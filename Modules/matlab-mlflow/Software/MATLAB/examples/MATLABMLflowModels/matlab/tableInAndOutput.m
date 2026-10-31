function tOut = tableInAndOutput(tIn)
       disp(tIn)
       summary(tIn)
       tOut = table;
       tOut.x = tIn.a + tIn.b;
       tOut.y = tIn.a - tIn.b;