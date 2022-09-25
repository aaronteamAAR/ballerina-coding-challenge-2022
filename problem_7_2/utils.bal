function calculatePriority(string kind, string? impact, string? severity) returns int|error {
    int priority;
    if kind == "feature request" {
        priority = 3;
    } else if kind == "bug" {
        if severity is () {
            return error("Unexpected payload");
        }
        priority = priorityMap.get("bug").get(severity);
    } else {
        if impact is () {
            return error("Unexpected payload.");
        }
        priority = priorityMap.get("improvement").get(impact);
    }
    return priority;
}

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
