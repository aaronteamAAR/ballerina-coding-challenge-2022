import ballerina/time;
import ballerina/log;
import ballerina/websocket;

map<websocket:Caller[]> riderRequestedLocationMap = {"Building-1": [], "Building-2": [], "Building-3": [], "Building-4": [], "Building-5": []};

service class riderService {
    *websocket:Service;
    private string name;
    private string time;

    public function init(string name) {
        if riderRequestedLocationMap.hasKey(name) {
            panic error websocket:UpgradeError(string `User ${name} is already registered`);
        }
        self.name = name;
        self.time = "";
        log:printInfo("New Rider Instance was made", name = "name");
    }

    remote function onOpen(websocket:Caller caller) returns websocket:Error? {
        foreach var key in riderRequestedLocationMap {
            int i = 0;
            foreach var registeredCaller in key {
                if registeredCaller.getConnectionId() == caller.getConnectionId() {
                    return;
                }
                i += 1;
            }
        }
        self.time = time:utcToString(time:utcNow());
        log:printInfo("A connection was made by rider", info = {name: self.name, time: self.time});
    }

    remote function onMessage(websocket:Caller caller, string buildingId) returns websocket:Error? {
        websocket:Caller[]? building = riderRequestedLocationMap[buildingId];
        log:printInfo("A Message recieved by rider", info = {name: self.name, buildingId: buildingId});

        if building is () {
            riderRequestedLocationMap[buildingId] = [caller];
        } else {
            foreach var registeredCaller in building {
                if registeredCaller.getConnectionId() == caller.getConnectionId() {
                    return;
                }
            }

            building.push(caller);
        }

        dailyRiders.add({buildingId, rider: self.name, time: self.time});
    }

    remote function onClose(websocket:Caller caller) returns websocket:Error? {
        log:printInfo("A Connection closed by rider", info = {name: self.name});
        foreach var key in riderRequestedLocationMap {
            int i = 0;
            foreach var registeredCaller in key {
                if registeredCaller.getConnectionId() == caller.getConnectionId() {
                    _ = key.remove(i);
                    return;
                }
                i += 1;
            }
        }
    }
}
