def main():
    sum = 0
    with open("./day01/input.txt") as f:
        for line in f.readlines():
            numbers = [int(number) for number in line if number in "0123456789"]
            sum += 10 * numbers[0] + numbers[-1]
    print(sum)


if __name__ == "__main__":
    main()
