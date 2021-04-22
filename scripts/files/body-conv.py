#!/usr/bin/env python3
import sys


def convert_height(height: str) -> str:
    if "cm" in height:
        centimeters = float(height.split("cm")[0])
        inches = centimeters / CM2INCH
        feet = inches // 12
        inches %= 12
        return f"{feet:.2f}ft {inches:.2f}in"
    elif "ft" in height:
        split_str = height.split("ft")
        feet = float(split_str[0])
        inches = float(split_str[1].replace("in",""))
        centimeters = (CM2INCH * 12 * feet) + (CM2INCH * inches)
        return f"{centimeters}cm"


def convert_weight(weight: str) -> str:
    if "kg" in weight:
        lbs = float(weight.split("kg")[0]) * KG2LBS
        return f"{lbs:.2f}lbs"
    elif "lbs" in weight:
        kg = float(weight.split("lbs")[0]) / KG2LBS
        return f"{kg:.2f}kg"


if __name__ == "__main__":
    CM2INCH = 2.54
    KG2LBS = 2.2
    if len(sys.argv) >= 3:
        height_str = sys.argv[1]
        weight_str = sys.argv[2]
        print(convert_height(height_str))
        print(convert_weight(weight_str))
    elif len(sys.argv) == 2:
        arg = sys.argv[1]
        if "cm" in arg or "ft" in arg:
            height_str = sys.argv[1]
            print(convert_height(height_str))
        elif "kg" in arg or "lbs" in arg:
            weight_str = sys.argv[1]
            print(convert_weight(weight_str))
    else:
        height_str = input("Enter original height with unit: (cm, ft/in) ")
        weight_str = input("Enter original weight with unit: (kg, lbs) ")
        print(convert_height(height_str))
        print(convert_weight(weight_str))
