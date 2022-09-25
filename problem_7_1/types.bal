type DiscussionDetails record {|
    string title;
    string kind;
    string affectedVersion;
    int priority;
|};

type HubResponse record {
  string kind;
  string title;
  string action;
  string[] labels;
  string 'version;
  string severity?;
  string impact?;
  string new_label?;
};
