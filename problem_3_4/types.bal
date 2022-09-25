# Type `Activities`
#
# + activities\-steps - 
public type Activities record {
    record {|
        string date;
        int value;
    |}[] activities\-steps;
};


# Type `UserResult`
# Insure Api response
# + user - User
public type UserResult record {
    record {
        int age;
    } user;
};

# Type `Gift`
#
# + eligible - user eligibility  
# + score - calculated score 
# + 'from - From date
# + to - To date  
# + details - Gift details
public type Gift record {
    boolean eligible;
    int score;
    string 'from;
    string to;
    GiftDetails details?;
};

# Type `GiftDetails`
#
# + 'type - Gift type  
# + message - message
public type GiftDetails record {
    Types 'type;
    string message;
};

public enum Types {
    SILVER,
    GOLD,
    PLATINUM
}
