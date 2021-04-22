import random
import subprocess
# a - z => 97 - 122 (inc.)
# 0 - 9 => 48 - 57

def _generate_random_char():
    raw = random.randint(87, 122)
    return chr(raw if raw >= 97 else raw - 39)

def rstrn(n):
    # return a random text string, containing lowercase
    # letters and numbers, of length n
    return "".join([_generate_random_char() for i in range(n)])

if __name__ == "__main__":
    while True:
        cols = int(subprocess.check_output(["tput", "cols"]))
        print(rstrn(cols))
