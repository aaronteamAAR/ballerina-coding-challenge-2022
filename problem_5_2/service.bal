import ballerina/http;
import ballerina/graphql;

http:Client stepsEPClient = check new ("http://localhost:9091/activities/v2/steps/user");
http:Client heartEPClient = check new ("http://localhost:9091/activities/v2/heart/user");

service /graphql on new graphql:Listener(9090) {

    resource function get activity(string ID) returns ActivityDetails[]|error {
        StepsApiResponse stepsRes = check stepsEPClient->get(string `/${ID}`);
        HeartApiResponse heartRes = check heartEPClient->get(string `/${ID}`);

        table<ActivityDetails> key(date) activityDetailsTable = table key(date) from StepsActivityData step in stepsRes.activity
            join HeartActivityData heart in heartRes.activity on step.date equals heart.date
            select {date: step.date, steps: step.steps, heart: {min: heart.heart.min, max: heart.heart.max, minutes: heart.heart.minutes, caloriesOut: heart.heart.caloriesOut, name: heart.heart.name}};
        return activityDetailsTable.toArray();
    }
}
