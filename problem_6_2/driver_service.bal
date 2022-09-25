import ballerina/websocket;
import ballerina/regex;
import ballerina/log;
import ballerina/time;

service class driverService {
    *websocket:Service;

    remote function onMessage(string buildingIdAndName) returns error? {
        string[] splitString = regex:split(regex:replace(buildingIdAndName, ":", " "), " ");
        string buildingId = splitString[0];
        string name = splitString[1];
        string time = time:utcToString(time:utcNow());

        log:printInfo("Message recieved by a driver", info = {name, buildingId, time});

        websocket:Caller[]? riders = riderRequestedLocationMap[buildingId];
        if riders is () {
            return error("Unusual error.");
        }

        foreach var rider in riders {
            check rider->writeTextMessage(name);
        }

        dailyDrivers.add({driver: name, buildingId, time});
    }
}
