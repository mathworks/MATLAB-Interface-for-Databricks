classdef S3StorageInfo < handle
    % S3StorageInfo DBFS storage information
    % The destination must be specified as a character vector or scalar string
    
    % Copyright 2022 The MathWorks, Inc.

    properties
        % S3 destination. Example: s3://init_script_bucket/prefix
        destination = char.empty
        % S3 region. For example: us-west-2. Either region or endpoint must be set. If both are set, endpoint is used
        region =  char.empty
        % S3 endpoint. For example: https://s3-us-west-2.amazonaws.com
        endpoint = char.empty
 	    % Enable server side encryption, false by default, optional.
        enable_encryption = false
        % Optional encryption type, it could be sse-s3 (default) or sse-kms
        encryption_type = char.empty
        % Optional KMS key used if encryption is enabled and encryption type is set to sse-kms.
        kms_key = char.empty
        % Optional canned access control list
        canned_acl = char.empty
    end

    methods
        function obj = S3StorageInfo(varargin)
            % TODO implement checks for destination, region and endpoint
            % currently in the initscriptinfo setDEstination method
        end
    end
end