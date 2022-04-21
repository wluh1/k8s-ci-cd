import sys
from git import Repo
import requests
import re
import time

url = "http://35.195.60.0:9000"

new_version = None


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


def fault_injection():
    pass


def scan_for_change():
    start = time.time()
    while (True):
        

        website_version = get_website_version()
        if website_version == new_version:
            print("Versions are correct")
            return True

        time.sleep(1)

        elapsed_time = time.time() - start
        if (elapsed_time > 10 * 60): # 10 Minutes
            return False



def main():
    start = time.time()

    change_config_version()
    if new_version == None:
        print("Error: new_version not initialized")
        exit(1)

    commit_change()

    success = scan_for_change()
    end = time.time()

    if success:
        print("===SUCCESS===")
        print ("Time elapsed:", int(end - start), "seconds")
    else:
        print("===FAILED===")
        print("Timeout after", int(end - start), "seconds")

main()
