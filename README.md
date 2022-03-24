m100le - Wordle for the Tandy TRS-80 Model 100  
# m100le
A version of Wordle created for a fourty-year-old computer, the Tandy TRS-80 Model 100.
![m100le](https://user-images.githubusercontent.com/14062627/157380662-b14b5225-cd50-479e-8fc5-f1fa1faf0162.png)

## Documentation
**m100le** is an implementation of [WORDLE](https://en.wikipedia.org/wiki/Wordle) for the Tandy TRS-80 Model 100 family of computers. It is written in the unit's on-board BASIC, a subset of [Microsoft BASIC](https://en.wikipedia.org/wiki/Microsoft_BASIC) included with the device.

As far as possible, we have attempted to remain faithful to the original game and gameplay. 

WORDLE'S instructions are very simple:
- Guess the WORDLE in 6 tries.
- Every day you get a new WORDLE.
- Each guess must be a valid 5 letter word. Hit the enter button to submit.
- After each guess, the colour of the tiles will change to show how close your guess was to the word.

![image](https://user-images.githubusercontent.com/14062627/159618578-ef980bb7-de0f-47d1-a496-b3f191d9700f.png)

## Differences from Wordle
### Valid 5 letter word
We've chosen to eliminate this constraint, given the limited onboard memory of the Model 100. 

WORDLE initially checks the date and loads today's word from the wordlist. When a guess is submitted, WORDLE checks the guess to verify that it's a word in the wordlist. If the guess doesn't appear in the wordlist the guess is invalid. WORDLE will not accept and evaluate an invalid guess and the game doesn't progress.

**m100le** initially **loads** today's word based on the system **DATE$** value. When a guess is submitted, **m100le** compares it to today's word, and provides the resultant clue. **m100le** does not test to verify the word appears in the wordlist. A guess of 'MOIST' is valid, as is a guess of 'DDDDD'.

Implementing the WORDLE method, would require the model 100 to have the entire wordlist in memory to check for valid words. The Wordle wordlist is about 17k bytes (spanning six years of words);  just over half of the maximum memory of a Tandy Model 100. 

Rather than impose this burden, **m100le** reads the **current year's** wordfile for the appropriate word based on today's **Date$**. Currently, **m100le** is using the 2022 version of the wordfile 'WL2022.DO'.



### Coloured tiles
As the Model 100 uses a monochrome LCD display, we don't have the ability to use colours to provide the clues. 

For each guess, a line in the **Clue Panel** will be filled in with the clue for that guess, and the cumulative **Alphabet Panel** will be updated.

| Clue | Meaning             |
|:----:|:-------------------|
|   .  | Wrong letter        |
|   ?  | Letter is in word, wrong location   |
|  */X | X = Any letter in proper location* | 

#### *an asterix will appear in the **Alphabet Panel**, and the actual correct letter will appear in the **Clue Panel** 

![image](https://user-images.githubusercontent.com/14062627/159623555-542d1454-eb42-4dc9-be3b-e3264fb2ec91.png)


### End of game
When either a word is guessed correctly, or no correct word is guessed after six attempts, the game ends and you have a few options:
- [A]GAIN? - Restarts today's game
- [R]ANDOM? - Starts a new game with the word chosen randomly from this year's wordlist
- [S]OCIAL? - Display your game's progress in a way suitable for sharing on social networks (Take a photo of the display)
- [Q]UIT? - End the program execution and return to the main menu. 

### Gameplay
![image](https://user-images.githubusercontent.com/14062627/159623862-c2d431f8-f88a-48b0-ac1d-45fa83ce3df9.png)
Daily, a five-letter word is selected and players have six tries to guess it. Each guess is rewarded with clues. After every guess, each letter is evaluated and marked in the **Clue Panel** as either [X], [**\***], [?], or [.] (CORRECT LETTER, QUESTION MARK, or PERIOD). CORRECT LETTER in **Clue Panel** indicates that letter is correct and in the correct position. QUESTION MARK indicates that the letter is in the answer but not in the proper position. PERIOD means that the letter is not in the answer at all. Multiple instances of the same letter in a guess, such as the "P"s in "POPPY", will be CORRECT LETTER or QUESTION MARK only if the letter also appears multiple times in the answer; otherwise, excess repeating letters will be a PERIOD.

## Installation

1. Download the most recent .zip file from the [RELEASES section](https://github.com/bgri/m100LE/releases).
2. Extract and copy 'M100LE.DO' to your model 100.
3. Extract and copy 'WL20XX.DO' to your Model 100 replacing XX with the current year. For 2022 you want WL2022.DO.
4. Enter BASIC on the Model 100, and type:
```LOAD "M100LE.DO"```

5. Then save the file as a .BA file:
```SAVE "M100LE.BA"```

6. Delete the now-unnecessary .DO file to free up RAM:
```KILL "M100LE.DO"```

    
## Roadmap

- Add the ability to manually enter today's date (for units that aren't Y2K fixed)
----
- Port to the NEC PC-8201
- Add the ability to save and display statistics
- Add the ability to select different wordfiles



## FAQ
### About the word files and today's word
The wordfiles we use in **m100le** are based on the the **original** javascript WORDLE, which contained the entire set of daily words (the wordfile) within the program code.  Over six years worth of words. 

### How wordfiles work
Big wordfiles wouldn't work for our little units, so we broke each wordfile into manageable chunks of one year each. 

The wordfiles are all appropriately named for the year they correspond to.  On program load, **m100le** checks the system **DATE$** for the current date and scans the appropriate wordfile for the matching daily word.

### Will my m100le word be the same as today's NYT Wordle word?
Maybe. m100le wordlists are based on the javascript version that was running online prior to the NYT acquisition of WORDLE. So today's word in m100le may be the same word in NYT WORDLE, or not.

## Feedback

If you have any feedback, please reach out to us:
- in the [discussions area](https://github.com/bgri/m100LE/discussions) for general conversation about m100LE
- in the [issues area](https://github.com/bgri/m100LE/issues) for bugs and feature requests



## Acknowledgements

 - [Josh Wardle - Wordle's creator](https://en.wikipedia.org/wiki/Josh_Wardle)
 - [TRS-80 Model 100 BASIC - based on Microsoft BASIC, with special support for the RAM file store, LCD display, and other built-in hardware of the TRS-80 Model 100 and Tandy 102 portable computers](https://archive.org/details/MasteringBasicOnTheTrs80Model100/page/n5/mode/2up)
 

## Authors

- [@bgrier](http://blog.bradgrier.com)


