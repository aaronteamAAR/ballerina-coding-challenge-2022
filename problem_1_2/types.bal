
public type InputFuelRecord record {|
    int employee_id;
    int odometer_reading;
    decimal gallons;
    decimal gas_price;
|};

public type Employee record {|
    readonly int employee_id;
    int gas_fill_up_count;
    decimal total_fuel_cost;
    decimal total_gallons;
    int total_miles_accrued?;
|};

public type OdometerReading record {|
    readonly int employee_id;
    int[] readings;
|};
