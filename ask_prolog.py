import subprocess
import re

def valid_prolog_term(text):
    # Check if it matches "functor(arg1, arg2, ...)"
    if not re.fullmatch(r"^\w+\((\s*\w+\s*(,\s*\w+\s*)*)\)$", text):
        return False
    return True
def contains_irrelevant(text):
    pattern = r"irrelevant|unknown"  # This matches either word
    match = re.search(pattern, text, re.IGNORECASE)  # re.IGNORECASE makes it case-insensitive
    return bool(match)
    
def format_unicode(text):
    def replace_match(match):
        return chr(int(match.group(0)[2:], 16))
    return re.sub(r"\\u[0-9a-fA-F]{4}", replace_match, text)

def query_prolog_helper(text):
    # default queries
    prolog_assert = "."
    prolog_check = "? "
    prolog_check2 = "? not "
    
    terms = [term.strip() for term in text.split('.') if term.strip()]
    for term in terms:
        if not (valid_prolog_term(term)):
            return "Invalid Format"
    
    # if we get here then all terms are probably ok
    for term in terms:
        match = re.match(r"(\w+)\(([^)]*)\)", term)
        if match:
            func_name = match.group(1)
            args_str = match.group(2)
            arglist = [arg.strip() for arg in args_str.split(',') if arg.strip()]
            #print(func_name)
            #print(arglist)
            
            if func_name == "require":
                result = f"scasp_assert({arglist[0]}({arglist[1]}))"
                #prolog.assertz(result)
                #print(f"asseting: {result}")
                prolog_assert = result + prolog_assert + " "
            elif func_name == "query":
                # single item
                if args_str == "item":
                    prolog_check = prolog_check + "check_item(X) "
                    prolog_check2 = prolog_check2 + "check_item(X) "
                if args_str == "setup":
                    prolog_check = prolog_check + "check_setup(X) "
                    prolog_check2 = prolog_check2 + "check_setup(X) "
                
                # multi item
                if args_str == "prices":
                    prolog_check = prolog_check + "search_price(X) "
                    prolog_check2 = prolog_check2 + "search_price(X) "
                if args_str == "classes":
                    prolog_check = prolog_check + "search_class(X) "
                    prolog_check2 = prolog_check2 + "search_class(X) "
                if args_str == "damages":
                    prolog_check = prolog_check + "search_damage(X) "
                    prolog_check2 = prolog_check2 + "search_damage(X) "
                if args_str == "stages":
                    prolog_check = prolog_check + "search_stage(X) "
                    prolog_check2 = prolog_check2 + "search_stage(X) "
            else:
                return "Invalid Functor?"
                print("Invalid Functor?")
    
    
    prolog_assert = ensure_period(prolog_assert)
    prolog_check = ensure_period(prolog_check)
    prolog_check2 = ensure_period(prolog_check2)
    return prolog_assert, prolog_check, prolog_check2

def ensure_period(text):
    text = text.rstrip('. ').strip()
    text += '.'
    text = re.sub(r'(?<=\))\s*(?=\w)', r'. ', text)
    return text

def query_prolog(text):
    if(contains_irrelevant(text)):
        return(f"The user generated a irrelevant query: {text}")
    prolog_file = "data.pl"

    process = subprocess.Popen(
        ["swipl", "-q", "-s", prolog_file],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    try:
        prolog_assert, prolog_check, prolog_check2 = query_prolog_helper(text)
    except:
        process.terminate()
        return(f"Prolog generated a irrelevant query from: {text}")
    query = f"{prolog_assert}\n{prolog_check}\n{prolog_check2}\n" + "halt.\n" 
    # print(f"Sending SWI Prolog queries: {query}.\n")
    out, err = process.communicate(query) # Send all input at once

    # print
    format_out = format_unicode(out)
    #print("Prolog Output:")
    #print(format_out)
    process.terminate()
    return format_out
    