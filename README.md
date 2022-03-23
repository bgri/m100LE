m100le - Wordle for the Tandy TRS-80 Model 100  
# m100le

A version of Wordle created for a fourty-year-old computer, the Tandy TRS-80 Model 100.
## Documentation
**m100le** is an implementation of [WORDLE](https://en.wikipedia.org/wiki/Wordle) for the Tandy TRS-80 Model 100 family of computers. It is written in the unit's on-board BASIC, a subset of [Microsoft BASIC](https://en.wikipedia.org/wiki/Microsoft_BASIC) included with the device.

As far as possible, we have attempted to remain faithful to the original game and gameplay. 

WORDLE'S instructions are very simple:
- Guess the WORDLE in 6 tries.
- Every day you get a new WORDLE.
- Each guess must be a valid 5 letter word. Hit the enter button to submit.
- After each guess, the color of the tiles will change to show how close your guess was to the word.

## Differences from Wordle
### Valid 5 letter word
We've chosen to eliminate this constraint, given the limited onboard memory of the Model 100. 

WORDLE initially checks the date and loads today's word from the wordlist. When a guess is submitted, WORDLE checks the guess to verify that it's a word in the wordlist. If the guess doesn't appear in the wordlist the guess is invalid. WORDLE will not accept and evaluate an invalid guess and the game doesn't progress.

**m100le** initially **loads** today's word based on the system **DATE$** value. When a guess is submitted, **m100le** compares it to today's word, and provides the resultant clue. **m100le** does not test to verify the word appears in the wordlist. A guess of 'MOIST' is valid, as is a guess of 'DDDDD'.

Implementing the WORDLE method, would require the model 100 to have the entire wordlist in memory to check for valid words. The Wordle wordlist is about 17k bytes (spanning six years of words);  just over half of the maximum memory of a Tandy Model 100. 

Rather than impose this burden, **m100le** reads the **current year's** wordfile for the appropriate word based on today's **Date$**. Currently, **m100le** is using the 2022 version of the wordfile 'WL2022.DO'.


## Acknowledgements

 - [Josh Wardle - Wordle's creator](https://en.wikipedia.org/wiki/Josh_Wardle)
 - [TRS-80 Model 100 BASIC - based on Microsoft BASIC, with special support for the RAM file store, LCD display, and other built-in hardware of the TRS-80 Model 100 and Tandy 102 portable computers](https://archive.org/details/MasteringBasicOnTheTrs80Model100/page/n5/mode/2up)
 

## Authors

- [@bgrier](http://blog.bradgrier.com)


# m100LE
 A Wordle-like game for the vintage Tandy (Radio Shack) Model 100
 


It's been too many years since I programmed in a version of Basic. Converting this popular word game to a vintage platform seemed like a great way to refresh the skills, so to speak.

m100le plays pretty much as Wordle does, with compromises made due to the lack of colour hints.

