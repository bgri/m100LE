m100le - Wordle for the Tandy TRS-80 Model 100  
# m100le
A version of Wordle created for a fourty-year-old computer, the Tandy TRS-80 Model 100.
![m100le](https://user-images.githubusercontent.com/14062627/157380662-b14b5225-cd50-479e-8fc5-f1fa1faf0162.png)

--
## Updates v0.m
### A note about this update
Though the look of the game hasn't changed much, a lot has gone on behind the scenes, thanks to the amazing work by [hackerb9](https://github.com/hackerb9):

- Hardware agnostic - runs on any m100 platform
- Speed increase - due to the following...
- Compressed binary word list files - smaller size and discourages peeking :)
- Commented and uncommented code files
- VT52 character positioning vs Tandy/NEC-specific routines
- Harmonized date and manual date entry - play tomorrow's game today!
- Synchronized with the 'official' NYT Wordle list
- Data cleanup, code cleanup, and other optimizations

Whew, lots there -- and more detail on a few things below!

--bgrier Oct. 8, 2022

--

### Hardware agnostic
**m100le** should be able to run m100le on ANY Kyocera-based computer (Kyocera KY-85, NEC PC-8201a, NEC PC-8201, NEC PC-8300, NEC PC-8400\*, Olivetti M10\*, Tandy Model-100, Tandy Model-102, Tandy Model-200). 

### Code versions
Four versions of code now in repository

Filename|Size|Meaning
---|---:|---
M100LE+comments.DO | 16KB | The actual source code, including all comments, in ASCII format
M100LE+comments.BA  | 14KB | Tokenized Tandy BASIC format, including all comments 
M100LE.DO | 8.5KB | All comments removed, in ASCII format
M100LE.BA | 6.6KB | All comments removed, in tokenized Tandy BASIC format

### Date
You can now enable the ability to manually enter the date or accept the system date. You could use this to replay a specific game or enter today's date on a vintage system that doesn't understand dates beyond 1999. `LINE 16 MD=1` will enable. When run, the system will prompt you for the date **` YY/MM/DD `** OR you could enter the ordinal 'Day-of-year' ex. `200` for the 200th day of the loaded year.

The date must be typed exactly in **` YY/MM/DD `** format.

### Word list files
Word list files are now compressed binary files. The system looks at the date (see above) to load the appropriate .CO word list file, based on year. As before, this file must be in RAM along with `m100le.ba`

--
## Documentation
**m100le** is an implementation of [WORDLE](https://en.wikipedia.org/wiki/Wordle) for the Tandy TRS-80 Model 100 family of computers. It is written in the unit's on-board BASIC, a subset of [Microsoft BASIC](https://en.wikipedia.org/wiki/Microsoft_BASIC) included with the device.

As far as possible, we have attempted to remain faithful to the original game and gameplay. 

WORDLE'S instructions are very simple:

* Guess the WORDLE in 6 tries.
* Every day you get a new WORDLE.
* Each guess must be a valid 5 letter word. Hit the enter button to submit.
* After each guess, the colour of the tiles will change to show how close your guess was to the word.

![image](https://user-images.githubusercontent.com/14062627/159618578-ef980bb7-de0f-47d1-a496-b3f191d9700f.png)

## Differences from Wordle
### Valid 5 letter word
We've chosen to eliminate this constraint, given the limited onboard memory of the Model 100. 

WORDLE initially checks the date and loads today's word from the wordlist. When a guess is submitted, WORDLE checks the guess to verify that it's a word in the wordlist. If the guess doesn't appear in the wordlist the guess is invalid. WORDLE will not accept and evaluate an invalid guess and the game doesn't progress.

**m100le** initially **loads** today's word based on the system **DATE$** value. When a guess is submitted, **m100le** compares it to today's word, and provides the resultant clue. **m100le** does not test to verify the word appears in the wordlist. A guess of 'MOIST' is valid, as is a guess of 'DDDDD'.

Implementing the WORDLE method, would require the Model 100 to have the entire wordlist in memory to check for valid words. The Wordle wordlist is about 17k bytes (spanning six years of words);  just over half of the maximum memory of a Tandy Model 100. 

Rather than impose this burden, **m100le** reads the **current year's** wordfile for the appropriate word based on today's **Date$**. Currently, **m100le** is using the 2022 version of the wordfile 'WL2022.CO'. If you've enabled the Date Entry function, then the program will attempt to load whatever wordlist file that corresponds to the year entered.



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


## Setting the Date
If your m100 doesn't have a ROM that has a Y2K patch (or some other method to bring your unit into this century, like the most excellent [REX# ROM](http://bitchin100.com/wiki/index.php?title=REXsharp) ), then to you'll need to edit line 16 so that the program promts you for the current date when playing a non-random, daily-sequental game. This will let you share relevant screenshots to your various social media and impress your friends :)

So in line 16, change the value of MD from Zero to One if you want to be prompted for the date.
```
16 MD=0: 'DEFINE DATE$ AND MANUAL DATE FLAG
```

This will allow you to play a game from any date from any word file loaded into your unit's memory. When enabled and run, the system will prompt you for the date **` YY/MM/DD `** OR you could enter the ordinal 'Day-of-year' ex. `200` for the 200th day of the loaded year.

The date must be typed exactly in **` YY/MM/DD `** format.

### End of game
When either a word is guessed correctly, or no correct word is guessed after six attempts, the game ends and you have a few options:

- [A]GAIN? - Restarts today's game
- [R]ANDOM? - Starts a new game with the word chosen randomly from this year's wordlist
- [S]OCIAL? - Display your game's progress in a way suitable for sharing on social networks (Take a photo of the display)
- [Q]UIT? - End the program execution and return to the main system menu. 

### Gameplay
![image](https://user-images.githubusercontent.com/14062627/159623862-c2d431f8-f88a-48b0-ac1d-45fa83ce3df9.png)
Daily, a five-letter word is selected and players have six tries to guess it. Each guess is rewarded with clues. After every guess, each letter is evaluated and marked in the **Clue Panel** as either [X], [**\***], [?], or [.] (CORRECT LETTER, QUESTION MARK, or PERIOD). CORRECT LETTER in **Clue Panel** indicates that letter is correct and in the correct position. QUESTION MARK indicates that the letter is in the answer but not in the proper position. PERIOD means that the letter is not in the answer at all. Multiple instances of the same letter in a guess, such as the "P"s in "POPPY", will be CORRECT LETTER or QUESTION MARK only if the letter also appears multiple times in the answer; otherwise, excess repeating letters will be a PERIOD.

## Installation

1. Download the most recent .zip file from the [RELEASES section](https://github.com/bgri/m100LE/releases).
2. Extract and copy 'M100LE.DO' to your Model 100.
3. Extract and copy 'WL20XX.CO' to your Model 100 replacing XX with the current year. For 2022 you want WL2022.CO.
4. Enter BASIC on the Model 100, and type:
`LOAD "M100LE.DO"`
5. Then save the file as a .BA file:
`SAVE "M100LE.BA"`
6. Delete the now-unnecessary .DO file to free up RAM:
`KILL "M100LE.DO"`

    
## Roadmap

- Add the ability to save and display statistics
- Improve clues, guess feedback and messages


## FAQ
### About the word files and today's word
The current version of **m100le** (greater than v0.l) uses the New York Times Wordle word lists. Prevously, the wordfiles used were based on the the **original** javascript WORDLE, which contained the entire set of daily words (the wordfile) within the program code.  Over six years worth of words. 

### How wordfiles work
Big wordfiles wouldn't work for our little units, so we broke each wordfile into manageable chunks of one year each. 

The wordfiles are all appropriately named for the year they correspond to.  On program load, **m100le** checks the system **DATE$** for the current date OR the manually entered date (if enabled) and scans the appropriate wordfiles for the matching daily word.

### Will my m100le word be the same as today's NYT Wordle word?
Maybe. Mostly. The NYT may change their word list at any time. If that happens, and we don't catch it, let us know and we'll update ours.

## Feedback

If you have any feedback, please reach out to us:
- in the [discussions area](https://github.com/bgri/m100LE/discussions) for general conversation about m100LE
- in the [issues area](https://github.com/bgri/m100LE/issues) for bugs and feature requests



## Acknowledgements

 - [Josh Wardle - Wordle's creator](https://en.wikipedia.org/wiki/Josh_Wardle)
 - [hackerb9](https://github.com/hackerb9) - significant optimization and improvements. This thing rocks!!
 - [TRS-80 Model 100 BASIC - based on Microsoft BASIC, with special support for the RAM file store, LCD display, and other built-in hardware of the TRS-80 Model 100 and Tandy 102 portable computers](https://archive.org/details/MasteringBasicOnTheTrs80Model100/page/n5/mode/2up)
 

## Authors

- [@bgrier](http://blog.bradgrier.com)
- [hackerb9](https://github.com/hackerb9)


