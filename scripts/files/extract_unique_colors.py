# This script takes a colorscheme generated by vivify, and identifies unique
# rgb and xterm colors appearing in that theme.

import re
import sys


def parse_colors(line):
    colorset = {
        "guifg": None,
        "guibg": None,
        "ctermfg": None,
        "ctermbg": None
    }
    sets = line.split()
    targets = [2, 3, 6, 7]
    for i, target in enumerate(targets):
        colorset[list(colorset.keys())[i]] = sets[target].split('=')[1]
    return colorset


def find_uniques(colorsets):
    uniques = []
    # quick and dirty nested for loop for sick O(n^2) performance
    for cset in colorsets:
        is_unique = True
        for entry in uniques:
            # we only give a shit about unique xterm colors, really, since
            # rgb colors are limited by their mappings to them
            if (cset["ctermfg"] == entry["ctermfg"] and
                    cset["ctermbg"] == entry["ctermbg"]):
                is_unique = False
        if is_unique:
            uniques.append(cset)
    return uniques

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: extract_unique_colors.py <colorscheme.vim>")
        exit(-1)
    with open(sys.argv[1], 'r') as infile:
        lines = [line.replace('\n', '') for line in infile.readlines()]
    lines = list(filter(lambda l: re.search("^hi ",l), lines))
    colorsets = []
    for line in lines:
        colorsets.append(parse_colors(line))
    uniques = find_uniques(colorsets)
    for entry in uniques:
        print(entry)
