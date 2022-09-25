import ballerina/io;

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    json inputJSON = check io:fileReadJson(inputFilePath);
    if !(inputJSON is json[]) {
        panic error("Invalid JSON");
    }
    InputFuelRecord[] input = check inputJSON.fromJsonWithType();
    table<Employee> key(employeeId) employee_table = table [];
    table<OdometerReading> key(employeeId) odometer_readings = table [];

    foreach var employee in input {
        boolean isRecorded = employee_table.hasKey(employee.employeeId);
        boolean isOdometerRecorded = odometer_readings.hasKey(employee.employeeId);

        if (isOdometerRecorded) {
            OdometerReading reading = odometer_readings.get(employee.employeeId);
            reading.readings.push(employee.odometerReading);
        } else {
            odometer_readings.add({employeeId: employee.employeeId, readings: [employee.odometerReading]});
        }

        if isRecorded {
            Employee recordedEmployee = employee_table.get(employee.employeeId);
            recordedEmployee.gasFillUpCount += 1;
            recordedEmployee.totalGallons += employee.gallons;
            recordedEmployee.totalFuelCost += employee.gallons * employee.gasPrice;
        } else {
            employee_table.add({employeeId: employee.employeeId, gasFillUpCount: 1, totalFuelCost: employee.gallons * employee.gasPrice, totalGallons: employee.gallons});
        }
    }

    foreach var k in odometer_readings.keys() {
        Employee employee = employee_table.get(k);
        OdometerReading reading = odometer_readings.get(k);
        employee.totalMilesAccrued = reading.readings[reading.readings.length() - 1] - reading.readings[0];
    }

    Employee[] response = from Employee emp in employee_table
        order by emp.employeeId ascending
        select emp;
    check io:fileWriteJson(outputFilePath, response.toJson());
}
