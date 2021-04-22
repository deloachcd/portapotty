#!/usr/bin/env python3

import argparse
import re

from requests import get
from bs4 import BeautifulSoup


def contains_member(collection, string):
    lowercase_string = string.lower()
    for entry in collection:
        if entry.lower() in lowercase_string:
            return True
    return False


parser = argparse.ArgumentParser(
    description='Web scrape craigslist for car deals'
)
parser.add_argument('--minprice', help='minimum price of cars to notify for')
parser.add_argument('--maxprice', help='maximum price of cars to notify for')
parser.add_argument('--drivetrain', help='type of drivetrain (fwd, rwd, awd)')
parser.add_argument('--transmission',
                    help='type of transmission (automatic, manual)')
parser.add_argument('--title', help='title status (clean, salvage, rebuilt)')
parser.add_argument('--sort-by', help='how to sort results (price, year)')
parser.add_argument('--makes',
                    help='file containing list of makes to restrict search to')
args = parser.parse_args()

params = [] 
if args.drivetrain:
    ids = { 'fwd': 1, 'rwd': 2, 'awd': 3 }  # url params are numeric
    params.append("auto_drivetrain={}".format(ids[args.drivetrain.lower()]))
if args.title:
    ids = { 'clean': 1, 'salvage': 2, 'rebuilt': 3 }
    params.append("auto_title_status={}".format(ids[args.title.lower()]))
if args.transmission:
    ids = { 'manual': 1, 'automatic': 2 }
    params.append("auto_transmission={}".format(ids[args.transmission.lower()]))
if args.minprice:
    params.append("min_price={}".format(args.minprice))
if args.maxprice:
    params.append("max_price={}".format(args.maxprice))
if args.makes:
    with open(args.makes, 'r') as f:
        allowed_makes = [s.replace("\n", "") for s in f.readlines()]

query = "&".join(params)
response = get("https://denver.craigslist.org/search/cto?{}".format(query))
soup = BeautifulSoup(response.text, 'html.parser')
posts = soup.find_all('li', class_='result-row')

listings = []
for post in posts:
    listing_title = next(post.find('a', class_='result-title').children)
    price_str = next(post.find('span', class_='result-price').children)
    price = int(price_str[1:].replace(',', ''))
    listing = {'title': listing_title, 'price': price}
    year = re.search('(19|20)\d{2}', listing_title)
    if year:
        # I don't really care about listings without a year in the title
        listing['year'] = int(year.group(0))
        listing['title'] = re.sub('(19|20)\d{2}\s', "", listing['title'])
        if args.makes and contains_member(allowed_makes, listing['title']):
            listings.append(listing)
        elif not args.makes:
            listings.append(listing)

if args.sort_by:
    listings.sort(key=lambda x: x[args.sort_by], reverse=True)
for listing in listings:
    print("{} {} - ${}".format(listing['year'],
                               listing['title'],
                               listing['price']))
