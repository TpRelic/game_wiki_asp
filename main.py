import os
import google.generativeai as genai

import check_api_key    # to get the env GEMINI_API_KEY
import example_prompts  # mostly plaintext, just has the 'history' to be fed into the model.start_chat's history.
import ask_prolog       # bridges with the prolog

api_key = check_api_key.get_key()
if api_key is None:
    print("Error: Gemini API key not found. Please set it in your environment variables or .env file.")
    exit()
genai.configure(api_key = api_key)

# create the model
generation_config = {
    "temperature": 0.0,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 1024,
    "response_mime_type": "text/plain"
}

input_instructions = f"""### Instructions
You are an AI assistant that helps the user plan tasks from the game Hypixel Skyblock.
Parse the necessary information from the user's request.

Respond in the following structured template format.
Reply "irrelevant" or "unknown" with anything not related to Hypixel Skyblock.

### Follow the examples.
query(item) if the user wants to find an item by name.
How can I get a Terminator?
require(item, Terminator). query(item).

query(setup) else look for X by existing facts.
What's a high damage archer weapon?
require(damage, high). require(class, archer). query(setup).

query(prices). query(classes). query(damages). query(stages).
Give a list of all items related to that subject. 
"""

input_model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    generation_config = generation_config,
    
    system_instruction = input_instructions
)

input_chat = input_model.start_chat(
    history = example_prompts.history_in
)

output_instructions = f"""### Instructions
You are an AI assistant that helps the user plan tasks from the game Hypixel Skyblock.
The job is to parse the necessary Answer Set Programming output, and format it back as plain english.

Read in the following ASP.
If something unknown or not listed in the ASP, you can say you don't know.

### Follow the examples.
"""

output_model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    generation_config = generation_config,
    
    system_instruction = output_instructions
)

output_chat = output_model.start_chat(
    history = example_prompts.history_out
)

def main():
    print("Executed as main \n We process the logic using ASP, then send it back to the AI for a human response.\n Ask an AI about Hypixel Skyblock.\n")
    # print(example_prompts.history_in)
    while True:
        user_input = input("Ask about Skyblock (or exit): ")
        if user_input.lower() == 'exit':
            print("ok bye bye")
            break
        if not user_input.strip(): # Check if the input is empty or contains only whitespace
            print("Empty input?")
        else:
            response_in = input_chat.send_message(content=user_input)
            #print(f"Asking Prolog: {response_in.text}")
            feedback = ask_prolog.query_prolog(response_in.text)
            #print(f"prolog feedback = {feedback}\n")
            
            feedback = "The user asked " + user_input + "\n" + feedback
            
            response_out = output_chat.send_message(content=feedback)
            print(f"AI output = {response_out.text}")


if __name__ == "__main__":
    main()