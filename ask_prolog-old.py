from pyswip import Prolog
import re

def valid_prolog_term(text):
    # Check if it matches "functor(arg1, arg2, ...)"
    if not re.fullmatch(r"^\w+\((\s*\w+\s*(,\s*\w+\s*)*)\)$", text):
        return False
    return True

def query_prolog(text):
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
                result = f"{arglist[0]}({arglist[1]})"
                print(f"asseting {result}")
                prolog.assertz(result)
            elif func_name == "query":
                if args_str == "requirements":
                    print(f"querying requirements ...")
            else:
                return "Invalid Functor?"
                print("Invalid Functor?")
                


prolog = Prolog()
prolog.consult("data.pl")

# query_prolog("require(item, hyperion). query(requirements).")

# prolog.assertz("father(john, mary)")
# prolog.assertz("father(john, bob)")

# for soln in prolog.query("father(michael,X)"):
#    print(soln["X"])