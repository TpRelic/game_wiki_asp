import subprocess
import re

# SWI-Prolog in quiet mode to suppress other stuff
prolog_file = "data.pl"

process = subprocess.Popen(
    ["swipl", "-q", "-s", prolog_file],
    stdin=subprocess.PIPE,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True
)

# formats unicode '\uXXXX' with their corresponding symbols.
def format_unicode(text):
    def replace_match(match):
        return chr(int(match.group(0)[2:], 16))
    return re.sub(r"\\u[0-9a-fA-F]{4}", replace_match, text)

def main():
    # Combine queries and send the assert
    prolog_query_assert = "scasp_assert(item(hyperion))."
    prolog_query_check = "? check_item_requirements(Reqs)."
    prolog_query_check2 = "? not check_item_requirements(Reqs)."
    query = f"{prolog_query_assert}\n{prolog_query_check}\n{prolog_query_check2}\n" + "halt.\n" 

    print(f"Sending SWI Prolog queries: '{prolog_query_assert}', '{prolog_query_check}', '{prolog_query_check2}'.\n")
    out, err = process.communicate(query) # Send all input at once

    # print
    format_out = format_unicode(out)
    print("Prolog Output:")
    print(format_out)

if __name__ == "__main__":
    main()
