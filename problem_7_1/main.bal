import ballerina/log;
import ballerina/websub;

@websub:SubscriberServiceConfig {
    target: [
        hub,
        topic
    ],
    secret
}

service /JuApTOXq19 on new websub:Listener(port) {

    remote function onEventNotification(websub:ContentDistributionMessage event) returns error? {
        map<json> res = check event.content.ensureType();
        HubResponse hubResponse = check res.cloneWithType();
        log:printInfo(string `webhook recieved of kind ${hubResponse.kind}`, payload = hubResponse);
        if hubResponse.labels.indexOf("documentation") is () || hubResponse.action == "commented" || hubResponse.action == "closed" {
            return;
        }
        int priority = check calculatePriority(hubResponse.kind, hubResponse.impact, hubResponse.severity);
        if hubResponse.action == "opened" || (hubResponse.action == "labeled" && hubResponse.new_label == "documentation") {
            discussionDetails.add({priority, affectedVersion: hubResponse.'version, kind: hubResponse.kind, title: hubResponse.title});
        }
    }
}

table<DiscussionDetails> discussionDetails = table [];

map<map<int>> priorityMap = {
    "bug": {
        "high": 1,
        "medium": 2,
        "low": 3
    },
    "improvement": {
        "significant": 2,
        "low": 3
    }
};