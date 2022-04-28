import os
import sys
from git import Repo
import requests
import re
import time
import datetime

url = "http://35.195.60.0:9000"

new_version = None

fault_delay = 60 # seconds

inject_faults = False


def change_config_version():
    print("Changing version...")
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
    print("Committing version change...")
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


def perform_fault_injection():
    for i, com in enumerate(sys.argv):
        if i == 0:
            continue

        if com == "-drone-fault":
            print("Injecting Drone fault...", " " * 25)
            os.system('kubectl apply -f ./chaos-mesh/drone-pod.yaml')
        elif com == "-argocd-fault":
            print("Injecting ArgoCD fault...", " " * 25)
            os.system('kubectl apply -f ./chaos-mesh/argocd-pod.yaml')
        elif com == "-argo-fault":
            print("Injecting Argo fault...", " " * 25)
            os.system('kubectl apply -f ./chaos-mesh/argo-workflow-pod.yaml')
        elif com == "-gocd-fault":
            print("Injecting GoCD fault...", " " * 25)
            os.system('kubectl apply -f ./chaos-mesh/gocd-pod.yaml')
        else:
            print("Unknown command:", com)
            exit(1)


def fault_injection(start):
    global inject_faults
    if not inject_faults:
        return

    elapsed_time = time.time() - start
    if elapsed_time > fault_delay:
        perform_fault_injection()
        inject_faults = False


def scan_for_change():
    print("Scanning for update...")
    print("")
    i = 1
    start = time.time()
    while (True):
        fault_injection(start)

        website_version = get_website_version()
        if website_version == new_version:
            return True

        curr_time_arr = re.split(':|\.', str(datetime.timedelta(seconds=time.time() - start)))
        print("New_Version:", new_version, "Website_Version:", website_version, "|", ":".join(curr_time_arr[1:-1]), end="\r")
        i += 1
        if i == 4:
            i = 1

        time.sleep(1)

        elapsed_time = time.time() - start
        if (elapsed_time > 15 * 60): # 10 Minutes
            return False

def parse_command():
    global inject_faults

    if len(sys.argv) > 3:
        print("Error, must take 0, 1 or 2 command line parameters")

    validCommands = ["-drone-fault", "-argocd-fault", "-argo-fault", "-gocd-fault"]
    for i in range(1, len(sys.argv)):
        inject_faults = True

        if not sys.argv[i] in validCommands:
            print("Invalid command: ", sys.argv[i])
            print("Valid commands:", validCommands)
            exit(1)


def main():
    parse_command()

    start = time.time()

    change_config_version()
    if new_version == None:
        print("Error: new_version not initialized")
        exit(1)
    print("New Version:", new_version)

    commit_change()

    success = scan_for_change()
    print("")
    end = time.time()

    if success:
        print("===SUCCESS===")
        print ("Time elapsed:", int(end - start), "seconds")
    else:
        print("===FAILED===")
        print("Timeout after", int(end - start), "seconds")

main()
