classdef Files < databricks.Object
    % Files Class to provide an interface to the Databricks Files REST API
    %
    % The Files API is a standard HTTP API that allows you to read, write, list,
    % and delete files and directories by referring to their URI.
    % The API makes working with file content as raw bytes easier and more efficient.
    % The API supports Unity Catalog volumes, where files and directories to
    % operate on are specified using their volume URI path, which follows the
    % format /Volumes/<catalog_name>/<schema_name>/<volume_name>/<path_to_file>.
    % The Files API has two distinct endpoints, one for working with files
    % (/fs/files) and another one for working with directories (/fs/directories).
    % Both endpoints, use the standard HTTP methods GET, HEAD, PUT, and DELETE
    % to manage files and directories specified using their URI path. The path
    % is always absolute.
    %
    % See also: https://docs.databricks.com/api/workspace/files

    % Copyright 2024-2026 The MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = Files(varargin)
            % Files Constructor

            obj.Version = '2.0';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end

    methods (Hidden)
        % Big file upload and related methods
        [result, errorResponse] = bigUpload(obj, source, destination, options);
        [result, errorResponse] = completeUpload(obj, destination)
        [result, errorResponse] = initiateUpload(obj, destination, options)
    end

    methods (Hidden, Static)
        function [path, pathArray] = escapePath(in)
            arguments (Input)
                in string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                path string
                pathArray string
            end

            if contains(in, "PERCENTTWENTYFIVE")
                error("Cannot escape: %s", in);
            end

            path = replace(in, "%", "%%");
            path = replace(path, " ", "%20");
            path = replace(path, "(", "%28");
            path = replace(path, ")", "%29");
            path = replace(path, "#", "%23");
            path = replace(path, "@", "%40");
            path = replace(path, ":", "%3A");
            path = replace(path, "%%", "%25");

            pathArray = split(path, "/")';
            if numel(pathArray) > 0
                if strlength(pathArray(1)) == 0
                   pathArray(1) = [];
                end
            end
        end
    end
end