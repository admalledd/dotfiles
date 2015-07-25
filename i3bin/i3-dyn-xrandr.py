#!/usr/bin/env python3
import subprocess
import time

#Script I mangled to try and parse my current workspace info and change monitor resolutions 
#Depending on which workspace was/is active. Alas this is too slow and buggy with multi-mon
# A whole new way of parsing and semi-auto configuring this would be required.

# list of resolution per viewport, for each viewport a separate [hor, vert]
resolutions = [
    [1920, 1080],
    [1920, 1080],
    [1920, 1080],
    [1920, 1080],
    [1360, 768], #1360x768
    ]
xr_monitor_output = ["eDP-1-0"]

def get_xr():
    return subprocess.check_output(["xrandr"]).decode("utf-8").split()

check = get_xr()
plus = 2 if check[check.index("connected")+1] == "primary" else 1

while True:
    # resolution:
    xr = get_xr()    
    res = [int(n) for n in xr[xr.index("connected")+plus].split("+")[0].split("x")]
    # get current workspace
    vp_data = subprocess.check_output(["wmctrl", "-d"]).decode("utf-8").splitlines()
    curr_ws = int([l.split()[0] for l in vp_data if "*" in l][0])
    # check and change resolution if needed
    if res != resolutions[curr_ws]:
        new_res = ("x").join([str(n) for n in resolutions[curr_ws]])
        print("setting new res: '%s' for workspace %d"%(new_res,curr_ws+1))
        subprocess.call(["xrandr", "--output"]+xr_monitor_output+["--mode", new_res])
    time.sleep(0.5)