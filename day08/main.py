def main():
    with open("./day08/input.txt") as f:
        lines = f.readlines()

    mapping = {}
    steps = 0
    sequence = lines[0].strip("\n")
    current = "AAA"
    for line in lines[2:]:
        mapping[line[:3]] = {"L": line[7:10], "R": line[12:15]}

    while True:
        current = mapping[current][sequence[steps % len(sequence)]]
        steps += 1
        if current == "ZZZ":
            print(steps)
            quit()


if __name__ == "__main__":
    main()
