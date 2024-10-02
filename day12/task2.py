ResultType = dict[tuple[int, tuple[int, ...]], int]


def operational(res: ResultType) -> ResultType:
    new_res = {}
    for (c, r), n in res.items():
        if c > 0 and (not r or c != r[0]):
            continue
        else:
            k = 0, r[1:] if c > 0 else r
            if k not in new_res:
                new_res[k] = 0
            new_res[k] += n
    return new_res


def broken(res: ResultType) -> ResultType:
    return {(c + 1, r): n for (c, r), n in res.items()}


def question_mark(res: ResultType) -> ResultType:
    return operational(res) | broken(res)


def main():
    with open("./day12/input.txt") as f:
        lines: list[str] = f.readlines()

    result = 0

    for line in lines:
        [sym, freq] = line.strip("\n").split(" ")
        symbols = "?".join(5 * [sym])
        freqs = 5 * [int(s) for s in freq.split(",")]

        solution: ResultType = {(0, tuple(freqs)): 1}

        for symbol in symbols:
            f_map = {".": operational, "#": broken, "?": question_mark}
            solution = f_map[symbol](solution)

        for (c, r), n in solution.items():
            if c == 0 and not r:
                result += n
            elif len(r) == 1 and c == r[0]:
                result += n

    print(result)


if __name__ == "__main__":
    main()
