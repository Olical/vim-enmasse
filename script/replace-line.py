#!/usr/bin/env python

import argparse

parser = argparse.ArgumentParser(description='Replace a specific line in a file.')
parser.add_argument('path', help='path to the file to edit')
parser.add_argument('line', help='number of the line to replace', type=int)
parser.add_argument('replacement', help='new line to use in the replacement')

def replace_line(path, line, replacement):
    with open(path, 'r') as file:
        lines = file.readlines()

    lines[line] = replacement + '\n'

    with open(path, 'w') as file:
        file.writelines(lines)

args = parser.parse_args()
replace_line(args.path, args.line, args.replacement)
