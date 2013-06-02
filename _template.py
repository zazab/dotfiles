#!/usr/bin/python
# coding=utf8

import fileinput
import re

from sys import argv, stderr, stdout, exit
from os.path import isfile
from getpass import getpass

utf8stdout = open(1, 'w', encoding='utf-8', closefd=1)

if len(argv) < 2:
    print('Usage: %s <filename>' % (argv[0]), file=stderr)
    exit(1)

if not isfile(argv[1]):
    print('%s is not a file' % (argv[1]), file=stderr)
    exit(2)

for line in open(argv[1], 'r', encoding='utf-8').readlines():
    while True:
        match = re.search(r'\{\{[^}]+}}', line)
        if not match:
            break
        placeholder = match.group(0)
        if re.search(r'password', placeholder, flags=re.I):
            answer = getpass(placeholder + ': ', stream=stderr)
        else:
            print(placeholder + ': ', file=stderr, end='')
            answer = input()
        line = line.replace(placeholder, answer)
    print(line, file=utf8stdout, end='')