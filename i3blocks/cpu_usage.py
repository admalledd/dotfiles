#!/usr/bin/python3

import sys
from subprocess import check_output


mpout = check_output(["mpstat", "1", "1"])
#Output is in (expected) format of:
_="""Linux 4.15.0-33-generic (admalledd-sys76)  09/02/2018  _x86_64_    (8 CPU)

09:31:18 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
09:31:19 PM  all    3.37    0.00    3.12    0.00    0.00    0.12    0.00    0.00    0.00   93.38
Average:     all    3.37    0.00    3.12    0.00    0.00    0.12    0.00    0.00    0.00   93.38
"""
#split by lines, take Average line, split by spaces, convert nums to floats
mpusage = [float(f) for f in mpout.split(b'\n')[4].split()[2:]]
#usage for me is usr + sys. (I ignore iowait and soft, because they don't heat up CPU for me)
percent_usage = mpusage[0]+mpusage[2]

hzout = check_output(["lscpu"])
#split by lines, we only need the line that starts/contains the exact "CPU MHz: #####"
hzout = hzout.split(b'\n')
clockMHz = -999
for line in hzout: 
    if line.startswith(b"CPU MHz:"):
        #split by ":", convert str to float, then floor via int since I don't need decimal here
        clockMHz = int(float(line.split(b':')[1].strip()))


#Get CPU Temps
sensout = check_output(["sensors", "coretemp-isa-0000"]).decode('UTF-8')
#Output is in (expected) format of: (NOTE THE BLANK END LINES)
_="""coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +48.0°C  (high = +100.0°C, crit = +100.0°C)
Core 0:        +47.0°C  (high = +100.0°C, crit = +100.0°C)
Core 1:        +46.0°C  (high = +100.0°C, crit = +100.0°C)
Core 2:        +45.0°C  (high = +100.0°C, crit = +100.0°C)
Core 3:        +44.0°C  (high = +100.0°C, crit = +100.0°C)


"""
#get highest temp from output
maxtemp = max([int(float(l.split(':')[1].split('C')[0].strip()[1:-1])) for l in sensout.split('\n')[2:] if l])

#OUTPUT 55.12% 2400 MHz 87c
#Print full text, short, color
print("%5.2f%% %4dMHz %2dC"%(percent_usage,clockMHz,maxtemp))
print("%5.2f%% %4dMHz %2dC"%(percent_usage,clockMHz,maxtemp))

#Color is depends on %Usage (not clock/temp)
if percent_usage > 50 and percent_usage <= 80:
    print('#FFFC00')
elif percent_usage > 80:
    print('#FF0000')
else:
    print('#FF00FF')