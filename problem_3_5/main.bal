import problem_3_5.customers;
import problem_3_5.sales;

type Q "Q1"|"Q2"|"Q3"|"Q4";

type Quarter [int, Q];

type Sales record {|
    *sales:Sales;
    readonly string customerId;
|};

type Customer record {|
    *customers:Customer;
    readonly string id;
|};

function findTopXCustomers(Quarter[] quarters, int x) returns customers:Customer[]|error {
    sales:Client salesClient = check new("http://localhost:8080/sales");
    customers:Client customersClient = check new("http://localhost:8080/customers");

    customers:Customer[] customersArray = check customersClient->get();
    Customer[] customersReadOnly = check customersArray.cloneWithType();

    table<Sales> key(customerId) salesTable = table [];
    table<Customer> key(id) customerTable = table key(id) from var customer in customersReadOnly select customer;

    foreach var quarter in quarters {
        sales:Sales[] quarterSales = check salesClient->get(quarter[0], quarter[1]);
        Sales[] quarterSalesReadOnly = check quarterSales.cloneWithType();
        foreach Sales sales in quarterSalesReadOnly {
            if salesTable.hasKey(sales.customerId) {
                Sales sale = salesTable.get(sales.customerId);
                sale.amount += sales.amount;
                continue;
            }
            salesTable.add(sales);
        }
    }

    return from var {amount, customerId} in salesTable order by amount descending limit x join Customer customer in customerTable on customerId equals customer.id select customer;
}
