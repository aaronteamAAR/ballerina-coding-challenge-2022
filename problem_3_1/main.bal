import ballerina/http;

type ApiResponse record {
    string base;
    map<decimal> rates;
};

# The exchange rate API base URL
configurable string apiUrl = "http://localhost:8080";
# Convert provided salary to local currency
#
# + salary - Salary in source currency
# + sourceCurrency - Source currency
# + localCurrency - Employee's local currency
# + return - Salary in local currency or error
public function convertSalary(decimal salary, string sourceCurrency, string localCurrency) returns decimal|error {
    
    http:Client currencyApiClient = check new(apiUrl);
    ApiResponse response = check currencyApiClient->get("/rates/" + sourceCurrency);
    decimal? rate = response.rates[localCurrency];
    if rate is () {
        return error("Rate for basecurrency not found.");
    }
    return salary * rate;
}
