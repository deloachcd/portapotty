#!/usr/bin/env python3
import argparse

from prettytable import PrettyTable

# Parse command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument(dest='n_shares', type=float, help='Number of shares owned')
parser.add_argument(dest='buy_in', type=float,
                    help='Amount spent to buy the shares')
parser.add_argument(dest='floor', type=int,
                    help='Lower bound for selling table values')
parser.add_argument(dest='ceiling', type=int,
                    help='Upper bound for selling table values')
parser.add_argument(dest='inc', type=int, help='Incrementor for table rows')
args = parser.parse_args()

# Construct the table
gains_table = PrettyTable()
gains_table.field_names = ["sell price", "gains"]
for sell_price in range(args.floor, args.ceiling+1, args.inc):
    gains = (args.n_shares * sell_price) - args.buy_in
    gains_table.add_row([f"${sell_price}", f"${gains:.2f}"])

# Display the table
print(gains_table)
