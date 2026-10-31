classdef EbsVolumeType < JSONEnum
    % EBSVOLUMETYPE Enumeration of All AWS Disk types that Databricks supports

    % (c) 2025 The MathWorks Inc.

    enumeration
        GENERAL_PURPOSE_SSD ("GENERAL_PURPOSE_SSD")
        THROUGHPUT_OPTIMIZED_HDD ("THROUGHPUT_OPTIMIZED_HDD")
    end
end

