import ims/billionairehub;

# Client ID and Client Secret to connect to the billionaire API
configurable string clientId = ?;
configurable string clientSecret = ?;

type Billionaire record {
    readonly string name;
    float netWorth;
    string country;
    string industry;
};

public function getTopXBillionaires(string[] countries, int x) returns string[]|error {

    billionairehub:Client cl = check new ({auth: {clientId, clientSecret}});
    Billionaire[] billionairesArray = [];

    foreach string country in countries {
        billionairehub:Billionaire[] res = check cl->getBillionaires(country);

        Billionaire[] oldBillionaires = check res.cloneWithType();
        billionairesArray.push(...oldBillionaires);
    }

    table<Billionaire> key(name) billionaires = table key(name) from var billionaire in billionairesArray
        select billionaire;

    return from var {name, netWorth} in billionaires
        order by netWorth descending
        limit x
        select name;
}
