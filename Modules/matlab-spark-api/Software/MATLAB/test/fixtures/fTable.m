function OT = fTable(IT)
    % fTable Test all types as table

    % Copyright 2023 MathWorks, Inc.

    OT = IT;
    OT.ts = OT.ts + hours(1) + minutes(2) + seconds(3);
    OT.tf = ~OT.tf;
    OT.dn = -OT.dn;
    OT.fl = -OT.fl;
    OT.i16 = OT.i16 + int16(10);
    OT.i32 = OT.i32  + int32(100);
    OT.i64 = OT.i64 + int64(1000);
    OT.name = OT.name + "_suffix";

end