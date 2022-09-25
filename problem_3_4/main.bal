import ballerina/http;

http:ClientConfiguration ActivitesEPConfig = {
    retryConfig : {
        count: 5,
        interval: 3,
        statusCodes: [500]
    },
    timeout: 10
};

http:FailoverClientConfiguration InsureEPConfig = {
    targets: [
        {url: "http://localhost:9092/insurance1"},
        {url: "http://localhost:9092/insurance2"}
    ],
    failoverCodes: [500],
    timeout: 10,
    interval: 3
};

function findTheGift(string userID, string 'from, string to) returns Gift|error {
    final http:Client fifitEp = check new ("http://localhost:9091/activities", ActivitesEPConfig);
    final http:FailoverClient insureEveryoneEp = check new ({...InsureEPConfig});

    Activities activities = check fifitEp->get(string `/steps/user/${userID}/from/${'from}/to/${to}`);
    UserResult res = check insureEveryoneEp->get(string `/user/${userID}`);

    int steps = 0;

    foreach var activity in activities.activities\-steps {
        steps += activity.value;
    }

    int age = res.user.age;
    int score = steps / ((100 - age) / 10);

    Types? giftType = giftTypeFromScore(score);

    if giftType is () {
        return {eligible: false, 'from, to, score};
    }

    GiftDetails giftDetails = {'type: giftType, message: string `Congratulations! You have won the ${giftType} gift!`};
    Gift gift = {eligible: true, 'from, to, score, details: giftDetails};

    return gift;
}
const int SILVER_BAR = 5000;
const int GOLD_BAR = 10000;
const int PLATINUM_BAR = 20000;
