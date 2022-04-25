import os
import sys
from git import Repo
import requests
import re
import time

url = "http://35.195.60.0:9000"

new_version = None

fault_delay = 60 * 2 # 2 minutes

fault_function = None


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


def drone_fault():
    print("Injecting Drone fault...")
    os.system('kubectl apply -f ./chaos-mesh/drone-pod.yaml')

def argo_fault():
    print("Injecting Argo fault...")
    os.system('kubectl apply -f ./chaos-mesh/argo-workflow-pod.yaml')

def argocd_fault():
    print("Injecting Drone fault...")
    os.system('kubectl apply -f ./chaos-mesh/drone-pod.yaml')

def gocd_fault():
    print("Injecting GoCD fault...")
    os.system('kubectl apply -f ./chaos-mesh/gocd-pod.yaml')

def fault_injection(start):
    if fault_function == None:
        return

    elapsed_time = time.time() - start
    if elapsed_time > fault_delay:
        fault_function()
        fault_function = None



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

        print("New_Version:", new_version, "Website_Version:", website_version, '.' * i, ' ' * (3 - i), end="\r")
        i += 1
        if i == 4:
            i = 1

        time.sleep(1)

        elapsed_time = time.time() - start
        if (elapsed_time > 15 * 60): # 10 Minutes
            return False

def parse_command():
    global fault_function

    if len(sys.argv) > 2:
        print("Error, must take 0 or 1 command line parameters")

    if len(sys.argv) > 1:
        if sys.argv[1] == "-drone-fault":
            fault_function = drone_fault
        elif sys.argv[1] == "-argocd-fault":
            fault_function = argocd_fault
        elif sys.argv[1] == "-argo-fault":
            fault_function = argo_fault
        elif sys.argv[1] == "-gocd-fault":
            fault_function = gocd_fault
        else:
            print("Invalid command:", sys.argv[1])
            exit(1)

def main():
    
    parse_command()

    fault_function()

    # start = time.time()

    # change_config_version()
    # if new_version == None:
    #     print("Error: new_version not initialized")
    #     exit(1)
    # print("New Version:", new_version)

    # commit_change()

    # success = scan_for_change()
    # print("")
    # end = time.time()

    # if success:
    #     print("===SUCCESS===")
    #     print ("Time elapsed:", int(end - start), "seconds")
    # else:
    #     print("===FAILED===")
    #     print("Timeout after", int(end - start), "seconds")

main()
