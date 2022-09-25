import ballerina/sql;
import ballerinax/java.jdbc;

function getHighPaymentDetails(string dbFilePath, decimal amount) returns HighPayment[]|error {
    jdbc:Client|sql:Error dbClient = new (
        url = "jdbc:h2:" + dbFilePath,
        user = "root",
        password = "root"
    );

    if dbClient is sql:Error {
        panic error("Incorrect DB credentials.");
    }

    HighPayment[] highPayments = [];

    stream<HighPayment, sql:Error?> paymentsStream = dbClient->query(`
        SELECT Employee.name, Employee.department, Payment.amount, Payment.reason
        FROM Payment
        INNER JOIN Employee ON Payment.employee_id = Employee.employee_id
        WHERE Payment.amount > ${amount};`
    , HighPayment);

    check from HighPayment highPayment in paymentsStream
        do {
            highPayments.push(highPayment);
        };

    check paymentsStream.close();
    return highPayments;
}
