public type InputFuelRecord record {|
    int employeeId;
    int odometerReading;
    decimal gallons;
    decimal gasPrice;
|};

public type Employee record {|
    readonly int employeeId;
    int gasFillUpCount;
    decimal totalFuelCost;
    decimal totalGallons;
    int totalMilesAccrued?;
|};

public type OdometerReading record {|
    readonly int employeeId;
    int[] readings;
|};
