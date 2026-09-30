function [numericVersion, fullVersion] = getJavaVersion()
    % GETJAVAVERSION Get java version in numeric form and string form
    %
    % Uses the result of the version("-java") command.
    %
    % For MATLAB's included Java the full version value is:
    %   Java 1.8.0_202-b08 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode
    % 
    % Alternative example Java 17:
    %   Java 17.0.15+6-Ubuntu-0ubuntu124.04 with Ubuntu OpenJDK 64-Bit Server VM mixed mode, sharing
    %
    % numericVersion is the single digit Java version returned as a double.
    % For Java 1.8 8 is returned otherwise the number preceding the . returned e.g. 17
    %
    % The fullVersion is the output of version("-java") in string form.
    %
    % If a Java environment is not enabled including by attempting to invoke a Java
    % call and error is thrown.
    %
    % Example:
    %   [numericVersion, fullVersion] = matlab.utils.internal.getJavaVersion()
    %
    % See also: jenv and matlab_jenv

    % (c) 2025 MathWorks Inc.

    fullVersion = string(version("-java"));

    if strcmp(fullVersion, 'Java is not enabled')
        % Call a Java function to see if that loads Java
        java.time.LocalDate.parse(java.lang.String('2025-07-10'));
        fullVersion = string(version("-java"));
        if strcmp(fullVersion, 'Java is not enabled')
            error("Java is not enabled, see:  https://www.mathworks.com/help/matlab/ref/jenv.html");
        end
    end

    if ~startsWith(fullVersion, "Java " + digitsPattern(1,3) + ".")
        error("Expected version string to start with 'Java <N>.', found: %s", fullVersion);
    end

    str = extractAfter(fullVersion, "Java ");
    if startsWith(str, "1.8.")
        numericVersion = 8;
    else
        numStr = extractBefore(str, ".");
        if isempty(numStr) || strlength(numStr) == 0
            error("Expected version value to start with a number, found: %s", str);
        end
        numericVersion = double(string(numStr));
    end
end