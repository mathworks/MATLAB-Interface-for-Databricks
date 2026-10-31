function T = benchDecode(N)
    % benchDecode Benchmark for base64 decode

    % Copyright 2020-2022 MathWorks, Inc.
    
    if nargin == 0
        N = 6;
    end
    sz = 10.^(1:N);
    data = cell(1,N);
    data2 = cell(1,N);
    for k=1:N
        d = randi(256,1,sz(k),'uint8');
        data{k} = uint8(matlab.net.base64encode(d));
        data2{k} = char(matlab.net.base64encode(d));
    end


    M = 5;
    for k=1:N
        matlab.net.base64('setconfig', 'mex');
        t1MX = zeros(1,M);
        for m=1:M
            t0 = tic;
            Qmx = matlab.net.base64('decode', data{k});
            t1MX(m) = toc(t0);
        end
        matlab.net.base64('setconfig', 'shipping');
        t1MX = mean(t1MX);
        t1Ship = zeros(1,M);
        for m=1:M
            t0 = tic;
            Qship = matlab.net.base64('decode', data2{k});
            t1Ship(m) = toc(t0);
        end
        t1Ship = mean(t1Ship);
        S(k) = struct(...
            'Size', sz(k), ...
            'MX', t1MX, ...
            'Ship', t1Ship, ...
            'Ratio', t1Ship/t1MX, ...
            'Equal', isequal(Qmx, Qship)); %#ok<AGROW>
    end
    T = struct2table(S);
end
