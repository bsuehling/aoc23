NUMBERS = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]


def main():
    with open("./day03/input.txt") as f:
        result = 0
        stars = []
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
                    if symbol == "*":
                        stars.append((i, j))
        for s in stars:
            star_nums = []
            for (i, j), number in numbers.items():
                do_append = False
                for k in range(j, j + len(number)):
                    if (
                        (i - 1, k - 1) == s
                        or (i - 1, k) == s
                        or (i - 1, k + 1) == s
                        or (i, k - 1) == s
                        or (i, k + 1) == s
                        or (i + 1, k - 1) == s
                        or (i + 1, k) == s
                        or (i + 1, k + 1) == s
                    ):
                        do_append = True
                if do_append:
                    star_nums.append(number)
            if len(star_nums) >= 2:
                prod = 1
                for n in star_nums:
                    prod *= int(n)
                result += int(prod)
        print(result)


if __name__ == "__main__":
    main()
