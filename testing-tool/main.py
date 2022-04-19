import sys
from git import Repo
import requests
import re

url = "http://35.195.60.0:9000"

new_version = "1.15"


def change_config_version():
    global new_version
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


def commit_change():
    repo = Repo("../")
    repo.git.add("./podtato-head/.config")

    repo.git.commit("-m", "TESTING-TOOL: test commit")

    origin = repo.remote(name='origin')
    origin.push()


def get_website_version():
    try:
        res = requests.get(url, timeout=2)
    except:
        return ""

    m = re.search("Version ([0-9.]+) ", str(res.content))
    if m:
        found = m.group(1)
        return found

    return ''


def main():
    # change_config_version()

    # commit_change()

    # TODO: Start timer and check when the new version can be seen in the URL

    website_version = get_website_version()
    print("NewV:", new_version)
    print("Website:", website_version)


main()
