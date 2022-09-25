type StepsApiResponse record {|
    StepsActivityData[] activity;
|};

type StepsActivityData record {|
    string date;
    int steps;
|};

type HeartApiResponse record {|
    HeartActivityData[] activity;
|};

type HeartActivityData record {|
    string date;
    HeartData heart;
|};

type HeartData record {|
    decimal caloriesOut;
    int max;
    int min;
    int minutes;
    string name;
|};

type ActivityDetails record {|
    readonly string date;
    int steps;
    Heart heart;
|};

type Heart record {|
    int min;
    int max;
    decimal caloriesOut;
    int minutes;
    string name;
|};
