import ballerina/log;
import projzone/webhook;

listener webhook:Listener webhookListener = new(port, orgName, projName, secret, hub);

table<DiscussionDetails> discussionDetails = table [];

service webhook:BugDiscussionService on webhookListener {

    remote function onDiscussionClosed(webhook:BugDiscussionEvent event) {
        return;
    }

    remote function onDiscussionOpened(webhook:BugDiscussionOpenedOrCommentedEvent event) {
        log:printInfo("[BugDiscussionService] Webhook recieved onDiscussionOpened", event = event);
        if event.labels.indexOf("documentation") is () {
            return;
        }
        int priority = priorityMap.get("bug").get(event.severity);
        discussionDetails.add({title: event.title, priority, kind: "bug", affectedVersion: event.'version});
    }

    remote function onDiscussionCommented(webhook:BugDiscussionOpenedOrCommentedEvent event) {
        return;
    }

    remote function onDiscussionLabeled(webhook:BugDiscussionLabeledEvent event) {
        log:printInfo("[BugDiscussionService] Webhook recieved onDiscussionLabeled", event = event);
        if event.labels.indexOf("documentation") is () || event.new_label !== "documentation" {
            return;
        }
        int priority = priorityMap.get("bug").get(event.severity);
        discussionDetails.add({title: event.title, priority, kind: "bug", affectedVersion: event.'version});
    }
}

service webhook:ImprovementDiscussionService on webhookListener {

    remote function onDiscussionClosed(webhook:ImprovementDiscussionEvent event) {
        return;
    }

    remote function onDiscussionOpened(webhook:ImprovementDiscussionOpenedOrCommentedEvent event) {
        log:printInfo("[ImprovementDiscussionService] Webhook recieved onDiscussionOpened", event = event);
        if event.labels.indexOf("documentation") is () {
            return;
        }
        int priority = priorityMap.get("improvement").get(event.impact);
        discussionDetails.add({title: event.title, priority, kind: "improvement", affectedVersion: event.'version});
    }

    remote function onDiscussionCommented(webhook:ImprovementDiscussionOpenedOrCommentedEvent event) {
        return;
    }

    remote function onDiscussionLabeled(webhook:ImprovementDiscussionLabeledEvent event) {
        log:printInfo("[ImprovementDiscussionService] Webhook recieved onDiscussionLabeled", event = event);
        if event.labels.indexOf("documentation") is () || event.new_label !== "documentation" {
            return;
        }
        int priority = priorityMap.get("improvement").get(event.impact);
        discussionDetails.add({title: event.title, priority, kind: "improvement", affectedVersion: event.'version});
    }
}
