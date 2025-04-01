# Compiler-Theory-Interpret
This repo contains code from a school project that asked us to modify a skeleton file of an interpreter using flex, bison, C++, and make as part of a study in compiler theory.

## Requirements
- Your favorite Linux distribution (I recommend Ubuntu for this project)
- Use `apt` or `yum` to get the packages for Flex, Bison, Make, and G++ (Use `sudo` to avoid permission issues)
- Create your desired directory for the files using `mkdir`
- Move source files to your chosen directory using `mv` or your personally prefered method
- Navigate to the directory with the source files and use `make` to compile the project
- Utilize the following syntax to run the program `./compile < test1.txt`

## Features Added
- Added ability to properly interpret/solve expressions containing Hex values
- Added ability to properly interpret/solve expressions containing Real values
- Added ability to properly interpret/solve expressions containing Escape characters
- Added ability to properly interpret/solve expressions containing arithmetic operators
- Added ability to properly interpret/solve expressions containing relational operators
- Added ability to properly interpret/solve expressions containing if/nested if statements
- Added ability to properly interpret/solve expressions containing multiple variables
- Added ability to properly interpret/solve expressions containing single and multiple parameters 

### Special Notes
- If you are modifying any of the files, you must run `make` to compile your new changes
- If you are modifying any `.cc` files, be sure to modify the corresponding `.h` files.
- You can initiate a coding environment using VS Code using the `code .` command.
- Included test cases can be accessed via the **tests** folder in the repo
