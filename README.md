# Game Wiki using sCASP and Python
#### 'Server/Software Project' 


I wanted to try something like a Game Helper bot / wiki, one that gets stuff like item info without getting confused about items or magic that doesn’t exist.
So you could say "What are the requirements for the best archer weapon?" and the Ai returns require(class, archer), require(damage, high), etc
(regex to make sure it’s the right format, else returns invalid / unclear)
The Prolog ASP reasons the best archer weapon is “terminator” and returns requirements of “terminator”
(facts about that weapon are explicitly listed in the database)
We send the Generated sCASP model to a 2nd LLM to get a plaintext output.
Ai responds "The best is the terminator because blah blah..."

## Instructions
Make sure Python, SWIProlog, and sCASP are installed
pip_installs.bat (should) have the pyhton installs you need to run.
Make sure your environment or .env has a valid gemini api key.
