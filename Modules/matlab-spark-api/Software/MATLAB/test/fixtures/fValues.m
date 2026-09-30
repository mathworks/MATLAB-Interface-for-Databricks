function [o_id, o_ts, o_tf, o_dn, o_fl, o_i16, o_i32, o_i64, o_name] = fValues(id, ts, tf, dn, fl, i16, i32, i64, name)
    % fValues Test all types as values

    % Copyright 2023 MathWorks, Inc.

    o_id = id;
    o_ts = ts - hours(12);
    o_tf = ~tf;
    o_dn = -dn ;
    o_fl = -fl;
    o_i16 = i16 + 10;
    o_i32 = i32 + 100;
    o_i64 = i64 + 1000;
    o_name = name + "_suffix";
    
end