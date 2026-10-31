function [T, S] = makeDeeplyData(options)
    % makeDeeplyData Creates sample structure based data for the example
    %
    % The optional named argument "N" controls the amount of sample data
    % produced, default: 10.
    %
    % The optional named argument "spark" is currently
    % not supported.

    % Copyright 2026, MathWorks Inc.

    arguments
        options.spark (1,1) databricks.PySparkSession
        options.N (1,1) double = 10
    end

    N = options.N;

    id = int64(1:N)';
    name = getNames(N);
    
    countries = ["France", "Germany", "Sweden", "Spain", "USA", "India", "China", "Norway", "Vatican"];
    cn = numel(countries);
    for k=N:-1:1
        info(k) = struct( ...
            "age", randi([5, 100]), ...
            "country", countries(randi(cn)), ...
            "arrI32", int32(randi(100, [1, 3+randi(5)])),  ...
            "deep", struct("flip", datetime('now'), 'flop', logical(rem(k,2)), "flap", seconds(k*7)) ...
            );
    end
    info = info(:);

    arr = cell(N,1);
    for k=1:N
        arr{k} = randi(1000, 1, randi(10), 'int32');
    end

    as = cell(N,1);
    for k=1:N
        NE = randi(5);
        for ai=1:NE
            tmp = struct('Id', int64(randi(1000)), 'country', countries(randi(cn)));
            if ai==1
                ass = tmp;
            else
                ass(ai) = tmp;
            end
        end
        as{k} = ass;
    end

    
    T = table(id, name, info, arr, as);

    S = compiler.build.spark.schema.DataType.createSchema(T);

end

function names = getNames(N)
    baseNames = ["Alice", "Bob", "Cecilia", "David", "Erika", "Franz", "Gisela", "Hubert", "Irma", "Jonathan", "Kajsa"];
    nbn = numel(baseNames);
    names = strings(N, 1);
    for k=1:N
        [~, uid] = fileparts(tempname);
        names(k) = baseNames(randi(nbn))+ "_" + extractBefore(string(uid),5);
    end
end