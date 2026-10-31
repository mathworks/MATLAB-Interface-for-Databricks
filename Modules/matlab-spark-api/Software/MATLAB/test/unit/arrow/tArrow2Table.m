classdef tArrow2Table < matlab.unittest.TestCase
%TARROW2TABLE Contains unit tests for matlab.internal.arrow.arrow2table.

% Copyright 2026 The MathWorks, Inc.

    methods (Test)

        function smoke(testCase)
            pa = py.importlib.import_module("pyarrow");
            array1 = pa.array([1, 2, 3, 4]);
            array2 = pa.array(int32([10, 11, 12, 13]));
            arrowTable = pa.table({array1, array2}, pyargs(names={'Col1', 'Col2'}));

            actual = matlab.internal.arrow.arrow2table(arrowTable);
            expected = table((1:4)', int32(10:13)', VariableNames=["Col1" "Col2"]);
            testCase.verifyEqual(actual, expected);
        end

        function castToDouble(testCase)
            pa = py.importlib.import_module("pyarrow");
            array1 = pa.array([1, 2, 3, 4]);
            array2 = pa.array({int32(10), int32(11), py.None, int32(13)}, pyargs("type", pa.int32()));
            arrowTable = pa.table({array1, array2}, pyargs(names={'Col1', 'Col2'}));

            actual = matlab.internal.arrow.arrow2table(arrowTable);
            expected = table((1:4)', [10 11 NaN 13]', VariableNames=["Col1" "Col2"]);
            testCase.verifyEqual(actual, expected);

            actual = matlab.internal.arrow.arrow2table(arrowTable, CastToDouble=true);
            testCase.verifyEqual(actual, expected);

            expected = table((1:4)', int32([10 11 0 13]'), VariableNames=["Col1" "Col2"]);
            actual = matlab.internal.arrow.arrow2table(arrowTable, CastToDouble=false);
            testCase.verifyEqual(actual, expected);
        end

        function columnNames(testCase)
            pa = py.importlib.import_module("pyarrow");
            array1 = pa.array([1, 2, 3, 4]);
            array2 = pa.array(int32(10:13));
            array3 = pa.array([true false false true]);
            columns = {array1, array2, array3};
            
            % Invalid MATLAB "variable" identifiers are not modified
            arrowTable = pa.table(columns, pyargs(names={' invalid', '12', ':VarName'}));
            expected = table((1:4)', int32(10:13)', [true; false; false; true]);
            fcn = @() matlab.internal.arrow.arrow2table(arrowTable);
            actual = testCase.verifyWarningFree(fcn);
            expected.Properties.VariableNames = [" invalid", "12", ":VarName"];
            testCase.verifyEqual(actual, expected);

            % Duplicate column names are uniquified
            arrowTable = arrowTable.rename_columns({'Col1', 'Col2', 'Col1'});
            fcn = @() matlab.internal.arrow.arrow2table(arrowTable);
            actual = testCase.verifyWarning(fcn, "sparkapi:ModifiedColumnNames");
            expected.Properties.VariableNames = ["Col1", "Col2", "Col1_1"];
            testCase.verifyEqual(actual, expected);

            % invalid MATLAB table identifiers are modified
            arrowTable = arrowTable.rename_columns({'RowNames', 'Properties', ':'});
            fcn = @() matlab.internal.arrow.arrow2table(arrowTable);
            actual = testCase.verifyWarning(fcn, "sparkapi:ModifiedColumnNames");
            expected.Properties.VariableNames = ["RowNames_1", "Properties_1", ":_1"];
            testCase.verifyEqual(actual, expected);
        end
        

        function emptyTable(testCase)
            pa = py.importlib.import_module("pyarrow");

            expected = table;
            arrowTable = pa.table({}, pyargs(names={}));
            actual = matlab.internal.arrow.arrow2table(arrowTable);
            testCase.verifyEqual(actual, expected);

            expected = table(Size=[0 2], VariableNames=["Num", "Text"], VariableTypes=["double" "string"]);
            array1 = pa.array({}, pyargs(type=pa.float64()));
            array2 = pa.array({}, pyargs(type=pa.string()));
            arrowTable = pa.table({array1, array2}, pyargs(names={'Num' 'Text'}));
            actual = matlab.internal.arrow.arrow2table(arrowTable);
            testCase.verifyEqual(actual, expected);
        end

    end

end