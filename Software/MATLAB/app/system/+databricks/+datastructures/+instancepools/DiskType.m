classdef DiskType < JSONEnum
    % DISKTYPE Enumeration of All Disk types that Databricks supports

    % (c) 2025 The MathWorks Inc.

    enumeration
        PREMIUM_LRS ("PREMIUM_LRS")
        STANDARD_LRS ("STANDARD_LRS")
        GENERAL_PURPOSE_SSD ("GENERAL_PURPOSE_SSD")
        THROUGHPUT_OPTIMIZED_HDD ("THROUGHPUT_OPTIMIZED_HDD")
    end
end

