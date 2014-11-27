# Ruby Projects

Two small Ruby command line projects which use a common dictionary.

### Word Chains
Based on rubyquiz.com #44, ["Word Chains"](http://rubyquiz.com/quiz44.html).  Word Chains takes two words of equal length as command line arguments and builds a chain of words connecting the first to the second, if such a chain exists.  Every word in the chain must both be in the dictionary and exactly one letter different from the previous word.

### Hangman
Hangman features two modes: guessing and checking.  The user is prompted to choose a mode at the beginning of the program.

If the user opts to guess, the computer chooses a word randomly from the dictionary file and play begins.

In check mode, the user selects a word for the computer to guess.  The computer then guesses intelligently by narrowing down the dictionary based on the length of the word, then guessing the most frequent letter in the subset of possible words.  If the guessed letter is found, the computer filters the dictionary to only words that have the guessed letter in the correct position.  Computer AI is further enhanced by filtering out all words with the guessed letter at an incorrect position.
