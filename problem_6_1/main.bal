import ballerina/websocket;

function negotiatePickUp(string path, string name, Location location) returns error|Location[] {
  websocket:Client socketClient = check new(string `${path}?name=${name}`);
  check socketClient->writeMessage(location);
  string nextShuttleLocation = check socketClient->readTextMessage();

  return decidePickUp(socketClient, location, check nextShuttleLocation.ensureType(Location));
}

function decidePickUp(websocket:Client socketClient, Location location, Location nextShuttleLocation) returns error|Location[] {
  match loc[location][nextShuttleLocation] {
    -1 => {
      check socketClient->close();
      return error("Client has already gone past the pickup point.");
    }
    1 => {
      return [location, check nextShuttleLocation.ensureType(Location)];
    }
  }
  check socketClient->writeMessage("V");
  string currentNextLocation = check socketClient->readTextMessage();
  return decidePickUp(socketClient, "V", check currentNextLocation.ensureType(Location));
}

map<map<int>> loc = {
  "R": {
    "R": 1,
    "S": -1,
    "T": 0,
    "U": 0,
    "V": -1,
    "W": -1
  },
  "S": {
    "R": 1,
    "S": 1,
    "T": 0,
    "U": 0,
    "V": -1,
    "W": -1
  },
  "T": {
    "R": 0,
    "S": 0,
    "T": 1,
    "U": -1,
    "V": -1,
    "W": -1
  },
  "U": {
    "R": 0,
    "S": 0,
    "T": 1,
    "U": 1,
    "V": -1,
    "W": -1
  },
  "V": {
    "R": 1,
    "S": 1,
    "T": 1,
    "U": 1,
    "V": 1,
    "W": -1
  }
};
