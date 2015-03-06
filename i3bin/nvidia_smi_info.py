#!/usr/bin/python

import sys;smi= sys.stdin.read()
data_line = smi.split('\n')[8]
_,temp,ram,_,_= data_line.split('|')
print temp.split()[1]
print ram.strip()