#!/usr/bin/python3

#Displayport, and some driver quirks (and multiple computers) has me needing to build all this layout myself a bit more specifically
#  So this file has some parsing/tooling to sorta automatically build a xrandr command line.
#  Tested on ADM-Desk currently. Means I can now just power off monitors and power on, run this and be happy.


#EDID finding Via https://gist.github.com/mvollrath/9aa0198264e6b4890914

import re
import subprocess
import sys
import binascii
import os.path
from pprint import pprint

#Define custom monitor layout via dict
# Key == internal name to be used in layout mapping
# Val == { 
#    'key' = regex to identify this monitor via edid (most likely just the serial number line)
#    'args' = settings for this monitor on xrandr command line. 
#    'loc' = relative location formatted, replacing %NAME% with connection name matching internal name
#           Example: 'loc': '--right-of %HP%' --> '--right-of HDMI-A-0'
# }
# Value == internal name to be used in layout mapping
##TODO: convert this to load from config file or something... also test loss+addition of monitors.
MONITORS={
    'HP':{
        'key':'Serial number: 3CM308015D',
        'args': '--mode 1920x1080 --rate 60',
        'loc': '--primary'
    },
    'Dell_Left':{
        'key':'Serial number: 59JJ465G07HL',
        'args': '--mode 1920x1080 --rate 60',
        'loc': '--right-of %HP%'
    },
    'Dell_Right':{
        'key':'Serial number: 59JJ465H0FAL',
        'args': '--mode 1920x1080 --rate 60',
        'loc': '--right-of %Dell_Left%'
    }
}

#Example xrandr final command:
#xrandr --output HDMI-A-0 --primary --mode 1920x1080 --rate 60
#       --output DisplayPort-4 --mode 1920x1080 --rate 60 --right-of HDMI-A-0
#       --output DisplayPort-7 --mode 1920x1080 --rate 60 --right-of DisplayPort-4



#We want to use/parse xrandr's format so that we don't have to map betweem /sys/class/drm/*/edid directory names/numbers and xrandr args.
XRANDR_BIN = 'xrandr'
EDID_PARSE_BIN = 'edid-decode'
# re.RegexObject: expected format of xrandr's EDID ascii representation
EDID_DATA_PATTERN = re.compile(r'^\t\t[0-9a-f]{32}$')


def get_edid_all():
    """Finds all the EDID for each connector.

    Returns:
        tuple(connection_name,binary_edid)
    Raises:
        OSError: failed to run xrandr
    """
    # re.RegexObject: pattern for this connector's xrandr --props section
    connector_pattern = re.compile('^([\w\d-]+) connected')

    try:
        xrandr_output = subprocess.check_output([XRANDR_BIN, '--props'])
    except OSError as e:
        sys.stderr.write('Failed to run {}\n'.format(XRANDR_BIN))
        raise e

    output_lines = xrandr_output.decode('ascii').split('\n')

    def slurp_edid_string(line_num):
        """Helper for getting the EDID from a line match in xrandr output."""
        edid = ''
        assert re.match(r'\tEDID:', output_lines[line_num+1])
        for i in range(line_num + 2, len(output_lines)):
            line = output_lines[i]
            if EDID_DATA_PATTERN.match(line):
                edid += line.strip()
            else:
                break
        return edid if len(edid) > 0 else None

    for i,line in enumerate(output_lines):
        connector_match = connector_pattern.match(line)
        if connector_match:
            connector_name = connector_match.group(1)
            edid_str = slurp_edid_string(i)
            if edid_str is None: return (connector_name, None)
            yield (connector_name, edid_str) #yield (connector_name, binascii.unhexlify(edid_str))


def parse_edid(moncon, rawedid):
    """Parse the edid hex into text

    Returns: 
        tuple(edid_text, monitor_name)
    """
    try:
        #Why does input= not work here as it should per docs? meh... 
        #edid_output = subprocess.check_output(EDID_PARSE_BIN, input=rawedid.encode('ascii'))
        edid_parse = subprocess.Popen(EDID_PARSE_BIN, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout,stderr = edid_parse.communicate(rawedid.encode('ascii'))
        edid_output = stdout.decode('ascii')
        #print(stderr.decode('ascii'))
    except OSError as e:
        sys.stderr.write('Failed to run {}\n'.format(EDID_PARSE_BIN))
        raise e

    #attempt to find montior in MONITORS dict
    for name,vals in MONITORS.items():
        mon_pattern = re.search(vals['key'],edid_output)
        if (mon_pattern): break
    else: name=None
    if not name: print('could not map this edid to a configured monitor. connection:{}'.format(moncon))
    return edid_output,name



if __name__ == '__main__':
    connected_mons = [m for m in get_edid_all()]
    settings = []
    connection_map = {}
    for moncon,edid in connected_mons:
        edid,name = parse_edid(moncon,edid)
        settings.append([moncon,name,MONITORS[name]])
        connection_map[name] = moncon
    args=[] #todo stringbuilder/join
    for s in settings:
        #replace values with connection names
        monitor_args = s[2]['args']
        monitor_loc = s[2]['loc']
        for k,v in connection_map.items():
            monitor_loc = monitor_loc.replace('%'+k+'%',v)
            monitor_loc = monitor_loc.replace('%'+k+'%',v)
        args.append('--output {} {} {}'.format(s[0],monitor_args,monitor_loc))
    xrandr_args = ' '.join(args)
    subprocess.check_output(XRANDR_BIN + ' ' + xrandr_args, shell=True)
    
