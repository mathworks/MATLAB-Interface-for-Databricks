function T = genCompilerWorkflowTable(N)
    % genCompilerWorkflowTable Create data for tests

    % Copyright 2023 MathWorks, Inc.
    arguments
        N (1,1) double  = 1000;
    end
    idx = (1:N)';
    baseTime = datetime('2020-05-05 04:33:21');
    S.id = int64(idx);
    S.ts = baseTime + seconds(idx);
    S.tf = xor(rem(idx,13) == 1, rem(idx,7) == 1);
    S.dn = double(sin((idx/N)*2*pi));
    S.fl = single(cos((2*idx/N)*2*pi));
    S.i16 = int16(idx);
    S.i32 = int32(idx);
    S.i64 = int64(idx);
    S.name = string("name_" + rem(idx,7));
    T = struct2table(S);
end
