def main():
    with open("./day02/input.txt") as f:
        sum = 0
        for i, line in enumerate(f.readlines()):
            possible = True
            colon_pos = line.find(":")
            game = line[colon_pos + 2 :]  # noqa: E203
            rounds = list(map(lambda x: x.strip(" \n"), game.split(";")))
            for r in rounds:
                colors = list(map(lambda x: x.strip(" \n"), r.split(",")))
                for c in colors:
                    d = c.split(" ")
                    if d[1] == "red":
                        possible &= int(d[0]) <= 12
                    elif d[1] == "green":
                        possible &= int(d[0]) <= 13
                    elif d[1] == "blue":
                        possible &= int(d[0]) <= 14
            if possible:
                sum += i + 1
    print(sum)


if __name__ == "__main__":
    main()
