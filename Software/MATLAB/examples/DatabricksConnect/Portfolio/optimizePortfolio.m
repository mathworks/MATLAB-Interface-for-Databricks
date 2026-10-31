function result = optimizePortfolio(portfolioInput)
    % optimizePortfolio Simple portfolio optimization example

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        portfolioInput table
    end
    arguments (Output)
        result
    end


    %% Start the Portfolio Optimization
    % Prepare the setup
    portObj = Portfolio('AssetList',portfolioInput.Properties.VariableNames(2:end-2));
    portObj = estimateAssetMoments(portObj, portfolioInput(:,2:end-2),'missingdata',true);
    portObj = setDefaultConstraints(portObj);
    % plotFrontier(portObj);

    %% Do the actual optimization
    % Start the optimization

    N = 5;
    pwgt = estimateFrontier(portObj, N);
    varNames = [{'Stock'}, cellstr("Port" + (1:N))];

    numCols = N + 1;
    data = cell(1, numCols);
    data{1} = string(portObj.AssetList)';
    for k=1:N
        data{k+1} = pwgt(:,k);
    end
    result = table(data{:}, 'VariableNames',varNames);
end
