function [dtOut,y] = withDatetime(dtIn,x)
    disp(dtIn)
    dtIn.TimeZone
    dtOut = dtIn;
    y = 2 * x;
