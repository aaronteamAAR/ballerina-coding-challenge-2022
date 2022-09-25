import ballerina/sql;
import ballerina/log;
import ballerinax/java.jdbc;

function addEmployee(string dbFilePath, string name, string city, string department, int age) returns int {
    jdbc:Client|sql:Error dbClient = new (
        url = "jdbc:h2:" + dbFilePath,
        user = "root",
        password = "root"
    );

    if dbClient is sql:Error {
        panic error(dbClient.message());
    }

    sql:ExecutionResult|sql:Error res = dbClient->execute(`INSERT INTO Employee (name, city, department, age) VALUES (${name}, ${city}, ${department}, ${age})`);

    if res is sql:Error {
        log:printError(res.message());
        return -1;
    }

    int|error id = res.lastInsertId.ensureType(int);

    if id is error {
        panic error("Faulty Table Model.");
    }

    sql:Error? err = dbClient.close();

    if err is sql:Error {
        panic error(err.message());
    }

    return id;
}
