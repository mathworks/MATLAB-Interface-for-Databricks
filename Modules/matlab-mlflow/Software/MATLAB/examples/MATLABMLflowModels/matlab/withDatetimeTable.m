function tOut = withDatetimeTable(tIn)
    disp(tIn)
    summary(tIn)
    tOut = table;
    tOut.dt = tIn.dt;
    tOut.x = tIn.a + tIn.b;
    tOut.y = tIn.a - tIn.b;