# Game Wiki using sCASP and Python
#### 'Server/Software Project' 

A simplified version of https://github.com/Sambour/Concierge-bot/tree/main/src as a Game Wiki / Helper bot.

This bot tries to get stuff like item info from the user without getting confused about items or magic that doesn’t exist.
So if the user asks about something not in the Prolog, it will correctly say it does not have enough info instead of making it up (using the context / history window instead).

This example uses the game, Hypixel Skyblock, as it is popular enough to have some plaintext info, but not popular enough to ask an LLM and get 100% correct answers.

So you could say "What are the requirements for the best archer weapon?" and the Input LLM returns require(class, archer), require(damage, high), etc based on the example prompts we gave it.
We regex to make sure it’s the right format (else returns invalid / unclear) then send it to SWIProlog.
The Prolog sCASP reasons the best archer weapon is "terminator" and returns everything it can prove about the requirements of a "terminator" (facts about that weapon are explicitly listed in the database).
We send the Generated sCASP model to a 2nd LLM given example outputs, to get a plaintext output for the user.
AI responds "The best is the terminator because blah blah..."

## Instructions
Make sure Python, SWIProlog, and sCASP are installed
pip_installs.bat (should) have the python installs you need to run.
Make sure your environment or .env has a valid gemini api key.

example_prompts.py is basically a plaintext file, you can change it for different responses.
data.pl is the main prolog part, you can add / change weapon facts from there.
