import ballerina/websocket;

table<RiderDetails> dailyRiders = table [];
table<DriverDetails> dailyDrivers = table [];

listener websocket:Listener wsListener = new (9092);

service /rider on wsListener {

    resource function get .(string name) returns websocket:Service {
        return new riderService(name);
    }
}

service /driver on wsListener {

    resource function get .() returns websocket:Service|websocket:Error {
        return new driverService();
    }
}
