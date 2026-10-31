function [wheelFile, wheelName] = getWheelFile(obj)
    % getWheelFile Return name of wheel file
    %

    % Copyright 2022-2026 The MathWorks, Inc.

    wheel = dir(fullfile(obj.OutputDir, "dist", "*.whl"));
    if isempty(wheel)
        error('SPARKAPI:GETWHEEL:NOTCREATED', "No wheel file found. The build process either did not run, or failed due to an error.");
    elseif length(wheel) > 1
        error('SPARKAPI:GETWHEEL:TOOMANY', 'There were several wheel files in the dist folder. There should be only one');
    end
    
    wheelFile = fullfile(wheel.folder, wheel.name);
    wheelName = wheel.name;
end
