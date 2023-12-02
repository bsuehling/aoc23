DIGITS = {
    "one": 1,
    "1": 1,
    "two": 2,
    "2": 2,
    "three": 3,
    "3": 3,
    "four": 4,
    "4": 4,
    "five": 5,
    "5": 5,
    "six": 6,
    "6": 6,
    "seven": 7,
    "7": 7,
    "eight": 8,
    "8": 8,
    "nine": 9,
    "9": 9,
}


def main():
    sum = 0
    with open("./day01/input.txt") as f:
        for line in f.readlines():
            occ = {}
            for s, i in DIGITS.items():
                f = line.find(s)
                if f >= 0:
                    occ[f] = i
                r = line.rfind(s)
                if r >= 0:
                    occ[r] = i
            sum += 10 * occ[min(occ)] + occ[max(occ)]
    print(sum)


if __name__ == "__main__":
    main()
