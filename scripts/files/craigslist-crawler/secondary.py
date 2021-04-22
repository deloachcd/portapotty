#!/usr/bin/env python3

def at_least_one(l, s):
    for i in l:
        if i in s:
            return True
    return False
