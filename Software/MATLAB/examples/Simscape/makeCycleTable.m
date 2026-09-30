function T = makeCycleTable(N, options)

    % Copyright 2026 The MathWorks, Inc.

    arguments
        N (1,1) double = 100
        options.addCycleId (1,1) logical = true;
    end

    t = (1:N)'-1;

    % xdot = rem(10*sin(t/5)+cos(t/50)*50 + 30, 25);
    xdot = cumsum(randn(N,1));
    xmin = min(xdot);
    xmax = max(xdot);
    xdelta = xmax-xmin;
    xdot = (xdot-xmin)*25/xdelta;
    device_id = repmat("my-id", N, 1);
    if options.addCycleId
        cycle_id = repmat("cycle-id", N, 1);
        T = table(t, xdot, device_id, cycle_id);
    else
        T = table(t, xdot, device_id);
    end
end