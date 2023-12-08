mapping = {
    "A": 12,
    "K": 11,
    "Q": 10,
    "J": 9,
    "T": 8,
    "9": 7,
    "8": 6,
    "7": 5,
    "6": 4,
    "5": 3,
    "4": 2,
    "3": 1,
    "2": 0,
}


def five_of_a_kind(cards: list[str]):
    return cards[0] == cards[4]


def four_of_a_kind(cards: list[str]):
    return cards[0] == cards[3] or cards[1] == cards[4]


def full_house(cards: list[str]):
    return (cards[0] == cards[2] and cards[3] == cards[4]) or (
        cards[0] == cards[1] and cards[2] == cards[4]
    )


def three_of_a_kind(cards: list[str]):
    return cards[0] == cards[2] or cards[1] == cards[3] or cards[2] == cards[4]


def two_pair(cards: list[str]):
    return (
        (cards[0] == cards[1] and cards[2] == cards[3])
        or (cards[0] == cards[1] and cards[3] == cards[4])
        or (cards[1] == cards[2] and cards[3] == cards[4])
    )


def one_pair(cards: list[str]):
    return (
        cards[0] == cards[1]
        or cards[1] == cards[2]
        or cards[2] == cards[3]
        or cards[3] == cards[4]
    )


def determine_score(cards: str):
    score = 0
    score += mapping[cards[0]] * 100_000_000
    score += mapping[cards[1]] * 1_000_000
    score += mapping[cards[2]] * 10_000
    score += mapping[cards[3]] * 100
    score += mapping[cards[4]]

    cards = sorted(cards, key=lambda x: mapping[x], reverse=True)

    if five_of_a_kind(cards):
        score += 60_000_000_000
    elif four_of_a_kind(cards):
        score += 50_000_000_000
    elif full_house(cards):
        score += 40_000_000_000
    elif three_of_a_kind(cards):
        score += 30_000_000_000
    elif two_pair(cards):
        score += 20_000_000_000
    elif one_pair(cards):
        score += 10_000_000_000

    return score


def main():
    winnings = 0
    ranks = []

    with open("./day07/input.txt") as f:
        for line in f.readlines():
            cards = line[:5]
            bid = int(line[6:].strip(" \n"))
            score = determine_score(cards)
            ranks.append((score, bid))

    ranks.sort(key=lambda x: x[0])

    for i, (_, b) in enumerate(ranks):
        winnings += (i + 1) * b

    print(winnings)


if __name__ == "__main__":
    main()
