classdef ChannelName 
    % CHANNELNAME Databricks ChannelName Data Structure

    % Copyright 2022-2023 The MathWorks, Inc.
    
    enumeration
        % SQL warehouse is set to the preview channel and uses upcoming functionality.
        CHANNEL_NAME_PREVIEW
        % SQL warehouse is set to the current channel.
        CHANNEL_NAME_CURRENT

        CHANNEL_NAME_UNSPECIFIED
        CHANNEL_NAME_PREVIOUS
        CHANNEL_NAME_CUSTOM
    end
end