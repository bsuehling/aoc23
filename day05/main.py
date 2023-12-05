def map_stuff(lines, source):
    mapping = {src: False for src in source}
    destiny = []
    for line in lines:
        dst, src, ran = tuple(map(lambda x: int(x), line.strip(" \n").split(" ")))
        for s in source:
            if src <= s < src + ran:
                destiny.append(s + dst - src)
                mapping[s] = True
    for s, b in mapping.items():
        if not b:
            destiny.append(s)
    return destiny


def main():
    with open("./day05/input.txt") as f:
        lines = list(f.readlines())

    seeds = list(map(lambda x: int(x), lines[0][8:].strip(" \n").split(" ")))

    soils = map_stuff(lines[3:46], seeds)
    fertilizers = map_stuff(lines[48:79], soils)
    waters = map_stuff(lines[81:106], fertilizers)
    lights = map_stuff(lines[108:135], waters)
    temperatures = map_stuff(lines[137:165], lights)
    humidities = map_stuff(lines[167:205], temperatures)
    locations = map_stuff(lines[208:256], humidities)

    print(min(locations))


if __name__ == "__main__":
    main()
