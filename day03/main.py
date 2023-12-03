NUMBERS = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]


def main():
    with open("./day03/input.txt") as f:
        result = 0
        symbols = []
        numbers = {}
        current_number = ""
        lines = list(f.readlines())
        for i, line in enumerate(lines):
            for j, symbol in enumerate(line):
                if symbol in NUMBERS:
                    current_number += symbol
                else:
                    if current_number:
                        numbers[(i, j - len(current_number))] = current_number
                        current_number = ""
                    if symbol not in [".", "\n"]:
                        symbols.append((i, j))
        for (i, j), number in numbers.items():
            do_add = False
            for k in range(j, j + len(number)):
                if (
                    (i - 1, k - 1) in symbols
                    or (i - 1, k) in symbols
                    or (i - 1, k + 1) in symbols
                    or (i, k - 1) in symbols
                    or (i, k + 1) in symbols
                    or (i + 1, k - 1) in symbols
                    or (i + 1, k) in symbols
                    or (i + 1, k + 1) in symbols
                ):
                    do_add = True
            if do_add:
                result += int(number)
        print(result)


if __name__ == "__main__":
    main()
