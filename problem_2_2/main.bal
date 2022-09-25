import ballerina/sql;
import ballerina/io;
import ballerinax/java.jdbc;

function addPayments(string dbFilePath, string paymentFilePath) returns error|int[] {
    jdbc:Client|sql:Error dbClient = new (
        url = "jdbc:h2:" + dbFilePath,
        user = "root",
        password = "root"
    );

    if dbClient is sql:Error {
        panic error(dbClient.message());
    }

    json jsonFile = check io:fileReadJson(paymentFilePath);

    if !(jsonFile is json[]) {
        panic error("Invalid JSON.");
    }

    Payment[] payments = check jsonFile.fromJsonWithType();

    sql:ParameterizedQuery[] insertQueries = from Payment payment in payments
        select `INSERT INTO Payment (date, amount, employee_id, reason) VALUES (${payment.date}, ${payment.amount}, ${payment.employee_id}, ${payment.reason})`;

    sql:ExecutionResult[] result = check dbClient->batchExecute(insertQueries);

    int[] generatedIds = [];
    foreach var summary in result {
        generatedIds.push(<int>summary.lastInsertId);
    }

    check dbClient.close();
    return generatedIds;
}
