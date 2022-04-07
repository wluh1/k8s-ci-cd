import sys


def change_config_version():
    with open("../podtato-head/.config", "r+") as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if line.startswith("VERSION"):
                lineArr = line.split("=")
                version_numbers = lineArr[1].strip().split(".")
                version_numbers[-1] = str(int(version_numbers[-1]) + 1)
                new_version = ".".join(version_numbers)
                lines[i] = lineArr[0] + "=" + new_version

        f.truncate(0)
        f.seek(0)
        f.writelines(lines)


def main():
    change_config_version()


main()
