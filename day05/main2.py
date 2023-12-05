def map_stuff(lines, source: list[tuple[int, int]]):
    missing = [s for s in source]
    destiny = []
    for line in lines:
        dst, src, ran = tuple(map(lambda x: int(x), line.strip(" \n").split(" ")))
        current = [m for m in missing]
        while current:
            s = current.pop(0)
            if s[1] >= src and s[0] <= src + ran - 1:
                missing.remove(s)
                s_min = max(s[0], src)
                s_max = min(s[1], src + ran - 1)
                start = dst + max(s[0] - src, 0)
                destiny.append((start, start + s_max - s_min))
                if s[0] < src:
                    missing.append((s[0], src - 1))
                    current.append((s[0], src - 1))
                if s[1] > src + ran - 1:
                    missing.append((src + ran, s[1]))
                    current.append((src + ran, s[1]))

    return destiny + missing


def main():
    with open("./day05/input.txt") as f:
        lines = list(f.readlines())

    seeds = list(map(lambda x: int(x), lines[0][7:].strip(" \n").split(" ")))
    real_seeds = []
    for i in range(0, len(seeds), 2):
        real_seeds.append((seeds[i], seeds[i] + seeds[i + 1] - 1))

    soils = map_stuff(lines[3:46], real_seeds)
    fertilizers = map_stuff(lines[48:79], soils)
    waters = map_stuff(lines[81:106], fertilizers)
    lights = map_stuff(lines[108:135], waters)
    temperatures = map_stuff(lines[137:165], lights)
    humidities = map_stuff(lines[167:205], temperatures)
    locations = map_stuff(lines[208:256], humidities)

    locations_min = min(map(lambda x: x[0], locations))

    print(locations_min)


if __name__ == "__main__":
    main()
