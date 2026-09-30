function OUT = nycAlgo(NYC)
    % nycAlgo Analyzes NYC taxi data computing some simple statistics
    
    arguments(Input)
        NYC table
    end
    arguments(Output)
        OUT table
    end

    % We assume that we only get values for a specific passenger count,
    % i.e. the data has already been grouped.

    passenger_count = NYC{1, 'passenger_count'};
    trip_distance = mean(NYC.trip_distance);
    fare_amount = mean(NYC.fare_amount);
    tip_amount = mean(NYC.tip_amount);
    entries = height(NYC);

    % Create table of one row
    OUT = table(passenger_count, trip_distance, fare_amount, tip_amount, entries, ...
        'VariableNames', {'passenger_count', 'trip_distance', 'fare_amount', 'tip_amount', 'entries'});
end
