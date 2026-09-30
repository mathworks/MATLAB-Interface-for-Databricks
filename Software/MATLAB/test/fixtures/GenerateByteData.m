% Script to generate random byte data for testing
%
% (c)2020 MathWorks, Inc.

% Column counter 
cellArr = {};

% Datetime 
cellArr{end+1} = datetime('now');

% String based types
cellArr{end+1} = char(java.util.UUID.randomUUID());    % char
cellArr{end+1} = string(java.util.UUID.randomUUID());  % string

% Floating point types
cellArr{end+1} = double(rand(1,1));                    % double
cellArr{end+1} = double(rand(1,1));                    % double

% Integer types
cellArr{end+1} = int64(rand(1,1)*intmax('int64'));
cellArr{end+1} = int32(rand(1,1)*intmax('int32'));
cellArr{end+1} = int16(rand(1,1)*intmax('int16'));
cellArr{end+1} = int8(rand(1,1)*intmax('int8'));

% Unsigned integer types
cellArr{end+1} = int64(rand(1,1)*intmax('int64'));
cellArr{end+1} = int32(rand(1,1)*intmax('int32'));
cellArr{end+1} = int16(rand(1,1)*intmax('int16'));
cellArr{end+1} = int8(rand(1,1)*intmax('int8'));

% Boolean and logical types
cellArr{end+1} = boolean(0);
cellArr{end+1} = boolean(1);
cellArr{end+1} = true;
cellArr{end+1} = false;

% Bytes
%byteData = load(fullfile(databricksRoot,'test','fixtures','ByteSupport','bytearrayint8.mat'));
%cellArr{end+1} = byteData.sig_raw;
cellArr{end+1} = rand(100,1);

% Create a simple table
testTable = cell2table(cellArr);
% testTable.cellArr18 = [testTable.cellArr18{:}]';
