import math


def get_values(t, d):
    a1 = math.floor((-t - math.sqrt(t**2 - 4 * d)) / -2)
    a2 = math.ceil((-t + math.sqrt(t**2 - 4 * d)) / -2)
    return a1 - a2 + 1


def main():
    result = 1
    result *= get_values(53, 275)
    result *= get_values(71, 1181)
    result *= get_values(78, 1215)
    result *= get_values(80, 1524)

    print(result)


if __name__ == "__main__":
    main()
