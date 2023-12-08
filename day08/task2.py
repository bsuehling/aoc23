import math


def main():
    with open("./day08/input.txt") as f:
        lines = f.readlines()

    mapping = {}
    steps = 0
    sequence = lines[0].strip("\n")
    current: list[str] = []

    for line in lines[2:]:
        mapping[line[:3]] = {"L": line[7:10], "R": line[12:15]}
        if line[2] == "A":
            current.append(line[:3])

    found: list[int] = [0 for _ in current]

    instruction_map = {k: k for k in mapping}
    for k in mapping:
        v = k
        for instruction in sequence:
            v = mapping[v][instruction]
        instruction_map[k] = v

    while True:
        current = [instruction_map[c] for c in current]
        steps += len(sequence)
        terminate = True
        for i, x in enumerate(current):
            if x.endswith("Z"):
                found[i] = steps
            if not found[i]:
                terminate = False

        if terminate:
            print(math.lcm(*found))
            quit()


if __name__ == "__main__":
    main()
