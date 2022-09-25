type ApiResponse record {|
    Sleep[] sleep;
|};

type Sleep record {|
    string date;
    int duration;
    record {|Summary summary;|} levels;
|};

type Summary record {|
    LevelData deep;
    LevelData light;
    LevelData wake;
|};

type LevelData record {
    int minutes;
};

public type SleepSummary record {
    readonly string date;
    int duration;
    Levels levels;
};

public type Levels record {
    int deep;
    int wake;
    int light;
};
