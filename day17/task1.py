import sys

result = list[list[dict[str, list[int]]]]


def find_path(nodes: list[list[int]], res: result, row: int, col: int, d: str, s: int):
    if d == "S":
        for i in range(3):
            res[0][1]["R"][i] = nodes[0][1]
            res[1][0]["D"][i] = nodes[1][0]
        res = find_path(nodes, res, 0, 1, "R", 0)
        return find_path(nodes, res, 1, 0, "D", 0)

    e = res[row][col][d][2 - s]

    if d in "RL":
        w, cost = worth_it(nodes, res, row, col, "U", 0, e)
        for i in w:
            res[row - 1][col]["U"][i] = e + cost
        if w:
            res = find_path(nodes, res, row - 1, col, "U", 0)
        w, cost = worth_it(nodes, res, row, col, "D", 0, e)
        for i in w:
            res[row + 1][col]["D"][i] = e + cost
        if w:
            res = find_path(nodes, res, row + 1, col, "D", 0)
    elif d in "DU":
        w, cost = worth_it(nodes, res, row, col, "L", 0, e)
        for i in w:
            res[row][col - 1]["L"][i] = e + cost
        if w:
            res = find_path(nodes, res, row, col - 1, "L", 0)
        w, cost = worth_it(nodes, res, row, col, "R", 0, e)
        for i in w:
            res[row][col + 1]["R"][i] = e + cost
        if w:
            res = find_path(nodes, res, row, col + 1, "R", 0)

    r, c = {
        "R": (row, col + 1),
        "L": (row, col - 1),
        "D": (row + 1, col),
        "U": (row - 1, col),
    }[d]

    w, cost = worth_it(nodes, res, row, col, d, s + 1, e)
    for i in w:
        res[r][c][d][i] = e + cost
    if w:
        return find_path(nodes, res, r, c, d, s + 1)

    return res


def worth_it(
    nodes: list[list[int]], res: result, row: int, col: int, d: str, s: int, e: int
) -> tuple[list[int], int | None]:
    if s > 2:
        return [], None

    r, c = {
        "R": (row, col + 1),
        "L": (row, col - 1),
        "D": (row + 1, col),
        "U": (row - 1, col),
    }[d]
    w = []
    if 0 <= r < len(nodes) and 0 <= c < len(nodes[0]):
        for i in range(3 - s):
            if res[r][c][d][i] > e + nodes[r][c]:
                w.append(i)
    return w, nodes[r][c] if w else None


def main():
    with open("./day17/input.txt") as f:
        nodes = [[int(c) for c in line.strip(" \n")] for line in f.readlines()]

    rows, cols = len(nodes), len(nodes[0])

    i = j = h = 0
    while i < rows - 1:
        j += 1
        h += nodes[i][j]
        i += 1
        h += nodes[i][j]

    res = [
        [{c: 3 * [h] for c in ["R", "L", "D", "U"]} for _ in range(cols)]
        for _ in range(rows)
    ]

    sys.setrecursionlimit(1_000_000)

    res = find_path(nodes, res, 0, 0, "S", 0)

    print(res[rows - 1][cols - 1])


if __name__ == "__main__":
    main()
