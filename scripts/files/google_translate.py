import json
import urllib, urllib.request

if __name__ == "__main__": import inquirer, pykakasi


def ajax_query_google(text, src='ja', to='en'):
    google_endpoint = "https://translate.googleapis.com/translate_a/single"
    parameters = {
        "client": "gtx",
        "sl": src,
        "tl": to,
        "dt": "t",
        "q": text
    }
    parameters_enc = urllib.parse.urlencode(parameters).encode('utf-8')

    response = json.loads(
        urllib.request.urlopen(
            google_endpoint, data = parameters_enc
        ).read().decode('utf-8')
    )

    return response


def jp2en(jp_text):
    return ajax_query_google(jp_text, src='ja', to='en')[0][0][0]


def expand_furigana(jp_text, converter=None):
    # the way pykakasi.kakasi() works is weird, in that it only does what
    # you expect with hiragana and katakana if there is a kanji character
    # in the string you pass into the convert() method. not sure if this
    # is a bug or not, but we get around this by appending a kanji to the
    # end of all strings we pass in, and just not displaying that one.
    converter = pykakasi.kakasi() if not converter else converter
    breakdown = converter.convert(f"{jp_text}漢字")
    expanded_jp_text = ""
    for entry in breakdown[:-1]:
        if entry['hira'] != entry['orig'] and entry['kana'] != entry['orig']:
            # it isn't hiragana or katakana, so it must be kanji
            expanded_jp_text += f"{entry['orig']}({entry['hira']})"
        else:
            expanded_jp_text += f"{entry['orig']}"
    return expanded_jp_text


if __name__ == "__main__":
    PROMPT = [inquirer.Text(name="text", message="[日本語] >> ")]
    CONVERTER = pykakasi.kakasi()
    user_input = inquirer.prompt(PROMPT)
    while "exit" not in user_input["text"]:
        jpn_text = user_input["text"]
        print(f"{expand_furigana(jpn_text, CONVERTER)} => {jp2en(jpn_text)}")
        user_input = inquirer.prompt(PROMPT)
