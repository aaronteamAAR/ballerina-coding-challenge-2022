# Calculates gift type from total steps
# + steps - Total steps
# + return - `Types` if a creteria is met
public function giftTypeFromScore(int steps) returns Types? {
    if steps >= SILVER_BAR && steps < GOLD_BAR {
        return SILVER;
    }
    if steps >= GOLD_BAR && steps < PLATINUM_BAR {
        return GOLD;
    }
    if steps >= PLATINUM_BAR {
        return PLATINUM;
    }
    return;
}
