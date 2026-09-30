function TA = genCompilerWorkflowTableArrays(N)
    % genCompilerWorkflowTableArrays Create data for tests

    % Copyright 2023 MathWorks, Inc.

    arguments
        N (1,1) double  = 1000;
    end
    idx = (1:N)';
    baseTime = datetime('2020-05-05 04:33:21');
    S.id = int64(idx);
    S.ts = baseTime + seconds(idx);
    S.tf = randi(2,N,10)==2;
    S.dn = double(sin((idx/N)*2*pi))+ (0:5); % Offsets
    S.fl = single(cos((2*idx/N)*2*pi)) + single(-5:0); % Offsets
    S.i16 = int16(idx + randi(100, N, 16));
    S.i32 = int32(idx + randi(1000, N, 32));
    S.i64 = int64(idx + randi(10000, N, 64));
    S.name = string("name_" + rem(idx,7)) + "_" + randi(20, N, 3);
    TA = struct2table(S);
end
