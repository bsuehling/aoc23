def main():
    with open("./day04/input.txt") as f:
        result = 0
        for line in f.readlines():
            line = line[10:]
            wl = line.split("|")
            winning = wl[0].strip(" ").split(" ")
            mine = wl[1].strip(" \n").split(" ")
            winning = list(map(lambda x: int(x), filter(lambda x: x != "", winning)))
            mine = list(map(lambda x: int(x), filter(lambda x: x != "", mine)))
            points = 0
            for card in mine:
                if card in winning:
                    points = 1 if points == 0 else points * 2
            result += points
        print(result)


if __name__ == "__main__":
    main()
