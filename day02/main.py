def main():
    with open("./day02/input.txt") as f:
        sum = 0
        for i, line in enumerate(f.readlines()):
            blue = green = red = 0
            colon_pos = line.find(":")
            game = line[colon_pos + 2 :]
            rounds = list(map(lambda x: x.strip(" \n"), game.split(";")))
            for r in rounds:
                colors = list(map(lambda x: x.strip(" \n"), r.split(",")))
                for c in colors:
                    d = c.split(" ")
                    if d[1] == "red":
                        red = max(red, int(d[0]))
                    elif d[1] == "green":
                        green = max(green, int(d[0]))
                    elif d[1] == "blue":
                        blue = max(blue, int(d[0]))
            sum += red * green * blue
    print(sum)


if __name__ == "__main__":
    main()
