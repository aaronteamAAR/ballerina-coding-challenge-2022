import ballerinax/java.jdbc;
import ballerina/sql;

function getHighPaymentEmployees(string dbFilePath, decimal thresholdAmount) returns string[]|error {
    jdbc:Client|sql:Error dbClient = new (
        url = "jdbc:h2:" + dbFilePath,
        user = "root",
        password = "root"
    );

    if dbClient is sql:Error {
        panic error("Incorrect DB credentials.");
    }

    stream<HighPayment, sql:Error?> paymentsStream = dbClient->query(`
        SELECT Employee.name as employee_name, Payment.amount, Payment.payment_id
        FROM Payment
        INNER JOIN Employee ON Payment.employee_id = Employee.employee_id`
    , HighPayment);

    table<HighPayment> key(payment_id) employeeTable = table [];

    check from HighPayment payment in paymentsStream
        do {
            employeeTable.add(payment);
        };

    check paymentsStream.close();
    check dbClient.close();
    table<record {|readonly string employee_name;|}> key(employee_name) names = table key(employee_name) from var {employee_name, amount} in employeeTable
        where amount > thresholdAmount
        order by employee_name ascending
        select {employee_name};

    return from record {|readonly string employee_name;|} {employee_name} in names
        select employee_name;
}
