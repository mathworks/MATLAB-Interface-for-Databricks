function ret = compareMaps(M1, M2)
    % compareMaps Compare two maps for equality

    % Copyright 2021 MathWorks, Inc.

    ret = true;
    
    if ~isa(M1, 'containers.Map') || ~isa(M2, 'containers.Map')
        error('Spark:Error', 'Both inputs must be of type containers.Map');
    end
    
    if M1.Count ~= M2.Count
        error('Spark:Error', 'M1 and M2 have different numbers of elements');
    end
    
    keys1 = M1.keys;
    keys2 = M2.keys;

    keys1 = cell2mat(keys1);
    keys2 = cell2mat(keys2);
    
    diff1_2 = setdiff(keys1, keys2);
    diff2_1 = setdiff(keys2, keys1);
    
    if ~isempty(diff1_2) || ~isempty(diff2_1)
        disp(diff1_2);
        disp(diff2_1);
        error('Spark:Error', 'M1 and M2 have different sets of keys');
    end

    for k=1:length(keys1)
       key = keys1(k);
       v1 = M1(key);
       v2 = M2(key);
       if isequaln(v1, v2)
           continue;
       end
       pi
    
       ret = false;
       break;
    end
end