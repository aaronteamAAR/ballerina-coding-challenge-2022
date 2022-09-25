import ballerina/io;

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    InputFuelRecord[] input = check io:fileReadCsv(inputFilePath);

    table<Employee> key(employee_id) employee_table = table [];
    table<OdometerReading> key(employee_id) odometer_readings = table [];

    foreach var employee in input {
        boolean isRecordedBefore = employee_table.hasKey(employee.employee_id);
        boolean isOdometerRecordedBefore = odometer_readings.hasKey(employee.employee_id);

        if (isOdometerRecordedBefore) {
            OdometerReading reading = odometer_readings.get(employee.employee_id);
            reading.readings.push(employee.odometer_reading);
        } else {
            odometer_readings.add({employee_id: employee.employee_id, readings: [employee.odometer_reading]});
        }

        if isRecordedBefore {
            Employee recordedEmployee = employee_table.get(employee.employee_id);
            recordedEmployee.gas_fill_up_count += 1;
            recordedEmployee.total_gallons += employee.gallons;
            recordedEmployee.total_fuel_cost += employee.gallons * employee.gas_price;
        } else {
            employee_table.add({employee_id: employee.employee_id, gas_fill_up_count: 1, total_fuel_cost: employee.gallons * employee.gas_price, total_gallons: employee.gallons});
        }
    }

    foreach var k in odometer_readings.keys() {
        Employee employee = employee_table.get(k);
        OdometerReading reading = odometer_readings.get(k);
        employee.total_miles_accrued = reading.readings.pop() - reading.readings[0];
    }

    Employee[] response = from Employee emp in employee_table
        order by emp.employee_id ascending
        select emp;
    check io:fileWriteCsv(outputFilePath, response);
}
