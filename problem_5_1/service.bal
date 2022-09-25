import ballerina/http;
import ballerina/graphql;

public enum TimeUnit {
    SECONDS,
    MINUTES
}

http:Client apiClient = check new ("http://localhost:9091/activities/summary/sleep/user");

service /graphql on new graphql:Listener(9090) {

    resource function get sleepSummary(string ID, TimeUnit timeunit) returns SleepSummary[] {

        ApiResponse|error response = apiClient->get(string `/${ID}`);
        if response is error {
            return [];
        }
        table<SleepSummary> key(date) sleepTable = table key(date) from var sleep in response.sleep
            select {date: sleep.date, duration: timeunit == SECONDS ? sleep.duration * 60 : sleep.duration, levels: {deep: timeunit == SECONDS ? sleep.levels.summary.deep.minutes * 60 : sleep.levels.summary.deep.minutes, light: timeunit == SECONDS ? sleep.levels.summary.light.minutes * 60 : sleep.levels.summary.light.minutes, wake: timeunit == SECONDS ? sleep.levels.summary.wake.minutes * 60 : sleep.levels.summary.wake.minutes}};

        return sleepTable.toArray();
    }
}
