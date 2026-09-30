classdef Copy < matlab.utils.mwcontext.Operation
    % Copy Class for Copy of mw_context
    %
    % This class is used to unpack a file or directory at startup, and to
    % package the same at shutdown. This enables the user to retrieve and
    % save a specific environment between sessions.

    % Copyright 2026 The MathWorks, Inc.

    properties
        srcLocation string {JSONMapper.fieldName(srcLocation, "src_location")}
        zipLocation string {JSONMapper.fieldName(zipLocation, "zip_location")}
        excludeList string {JSONMapper.fieldName(excludeList, "exclude_list")}
        context       string
    end

    methods
        function obj = Copy(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?matlab.utils.mwcontext.Copy
            end
            obj = obj.initialize(s,inputs);
        end

    end
end
