function t = variousIntsWithTable(t)
    disp(t)
    summary(t)
    t.ui8=uint8(t.ui8);
    t.i8=int8(t.i8);
    t.ui16=uint16(t.ui16);
    t.i16=int16(t.i16);
    t.ui32=uint32(t.ui32);
    t.i32=int32(t.i32);
    t.ui64=uint64(t.ui64);
    t.i64=int64(t.i64);
