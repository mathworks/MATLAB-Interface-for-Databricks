function deployedInputError(errID, msg)
% DEPLOYEDINPUTERROR Errors if in deployed mode where input will cause an apparent hang
% The default errID is: "DATABRICKS:INPUT"
% The default msg is: "Unexpected interactive input request in deployed mode"

%  (c) 2022 The MathWorks, Inc.

    arguments
        errID (1,1) string = "DATABRICKS:INPUT"
        msg (1,1) string = "Unexpected interactive input request in deployed mode"
    end

    if isdeployed
        error(errID, msg);
    end
end