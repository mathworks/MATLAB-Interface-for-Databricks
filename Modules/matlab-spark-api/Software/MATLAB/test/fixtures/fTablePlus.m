function OT = fTablePlus(IT, id, ts, tf, dn, fl, i16, i32, i64, name)
    % fTablePlus Test all types as table, plus extra args

    % Copyright 2023 MathWorks, Inc.

    OT = IT;

    delta = ts - OT.ts(1);
    OT.id = OT.id + id;
    OT.ts = OT.ts + delta;
    OT.tf = ~OT.tf;
    OT.dn = OT.dn + dn;
    OT.fl = OT.fl + fl;
    OT.i16 = OT.i16 + i16;
    OT.i32 = OT.i32 + i32;
    OT.i64 = OT.i64 + i64;
    OT.name = OT.name + name;

end