function allocateCubicles(int[] requests) returns int[] {
    int[] allocated = [];
    foreach var request in requests {
        if allocated.indexOf(request) is () {
            allocated.push(request);
        }
    }
    return allocated.sort();
}
