import random
import sys # argparse would be overkill for this

import genanki

STD_FLASHCARD = genanki.Model(
  1607392319, # TODO
  'Standard flashcard',
  fields=[
    {'name': 'Question'},
    {'name': 'Answer'},
  ],
  templates=[
    {
      'name': 'Card 1',
      'qfmt': '{{Question}}',
      'afmt': '{{FrontSide}}<hr id="answer">{{Answer}}'
    },
  ])

def gen_id():
    return random.randrange(1 << 30, 1 << 31)


def parse_file(filename):
    with open(filename, 'r') as src_file:
        lines = [line.replace('\n', '') for line in src_file.readlines()]
    # ignore comment lines
    lines = list(filter(lambda line: line[0] != '#', lines))
    return lines


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: deck-from-file.py <source_file>")
        exit(-1)
    else:
        fname = sys.argv[1]
    lines = parse_file(fname)
    for line in lines:
        line = line.split('=>')
        card = {
            'question': line[0].strip(),
            'answer': line[1].strip()
        }
        print(card)
