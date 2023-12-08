def main():
    with open("./day04/input.txt") as f:
        lines = list(f.readlines())
        scratchcards = [1 for _ in lines]
        for i, line in enumerate(lines):
            line = line[10:]
            wl = line.split("|")
            winning = wl[0].strip(" ").split(" ")
            mine = wl[1].strip(" \n").split(" ")
            winning = list(map(lambda x: int(x), filter(lambda x: x != "", winning)))
            mine = list(map(lambda x: int(x), filter(lambda x: x != "", mine)))

            correct = 0
            for card in mine:
                if card in winning:
                    correct += 1
            for j in range(i + 1, i + correct + 1):
                if j < len(scratchcards):
                    scratchcards[j] += scratchcards[i]
        print(sum(scratchcards))


if __name__ == "__main__":
    main()
