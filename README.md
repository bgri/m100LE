m100le - Wordle for the Tandy TRS-80 Model 100
# m100le
A version of Wordle created for a fourty-year-old computer, the Tandy TRS-80 Model 100.
![m100le](https://user-images.githubusercontent.com/14062627/157380662-b14b5225-cd50-479e-8fc5-f1fa1faf0162.png)

--
## Updates v0.m
### A note about this update
Though the look of the game hasn't changed much, a lot has gone on
behind the scenes, thanks to the amazing work by
[hackerb9](https://github.com/hackerb9):

<details><summary>
Click to see summary of changes.
</summary>

- Hardware agnostic - runs on any of the eight Kyotronic sisters
  (TRS-80 Model 100, Tandy 200, Tandy 102, Kyocera Kyotronic-85,
  Olivetti M-10, NEC PC-8201, NEC PC-8201A, and NEC PC-8300).
- Speed increase - due to the following...
  - Random, instead of sequential, access to RAM file
  - Compressed binary word list files - smaller size and discourages peeking :)
  - Smarter string handling (avoid concatenations, `CLEAR` plenty of space)
- Commented and uncommented code files
- VT52 character positioning vs Tandy/NEC-specific routines
- Harmonized auto and manual date entry — play tomorrow's game today!
- Synchronized with the 'official' NYT Wordle list
- Data cleanup, code cleanup, and other optimizations

Whew, lots there -- and more detail on a few things below!

--bgrier Oct. 8, 2022
	*	*	*	*	*
</details>


### Hardware agnostic
<details><summary>
M100LE now runs unmodified on any "Model T" type portable computer.
</summary>

<img src="README.md.d/pc8201-small.png" align="right">

* Kyocera Kyotronic-85<sup>&dagger;</sup>,
* TRS-80 Model 100, Tandy 102, and Tandy 200
* NEC PC-8201a, NEC PC-8201, NEC PC-8300,
* Olivetti M10<sup>&dagger;</sup>,

(<sup>&dagger;</sup> marks models not yet tested on actual hardware.)

</details>

### Code versions
Multiple versions of the code are now available, but you only need one
for your machine. For TRS-80 and Tandy computers, you will use
[M100LE.BA][4]. For others, or if you want the original source code,
see the [Formats](#Formats) section for more details.



### Word list files
Word list files are now compressed binary files with the extension
`.CO`, although the old `.DO` format still works. As before, you only
need to download the wordlist for the year you wish to play.

Also available are the uncompressed wordlists (.DO), which are mainly
of use if you wish to edit the words or if you are transfering the
files using the builtin TELCOM program which can only send ASCII
files. M100LE is smart enough to use the .DO files if .CO cannot be
found.

## Documentation
**m100le** is an implementation of
[WORDLE](https://en.wikipedia.org/wiki/Wordle) for the Tandy TRS-80
Model 100 family of computers. It is written in the unit's on-board
BASIC, a subset of
[Microsoft BASIC](https://en.wikipedia.org/wiki/Microsoft_BASIC)
included with the device.

As far as possible, we have attempted to remain faithful to the original game and gameplay.

WORDLE'S instructions are very simple:

* Guess the WORDLE in 6 tries.
* Every day you get a new WORDLE.
* Each guess must be a valid 5 letter word. Hit the enter button to submit.
* After each guess, the colour of the tiles will change to show how close your guess was to the word.

![image](https://user-images.githubusercontent.com/14062627/159618578-ef980bb7-de0f-47d1-a496-b3f191d9700f.png)

## Differences from Wordle
### Valid 5 letter word
We've chosen to eliminate this constraint, given the limited onboard
memory of the Model 100.

WORDLE initially checks the date and loads today's word from the
wordlist. When a guess is submitted, WORDLE checks the guess to verify
that it's a word in a [large dictionary](adjunct/allowedwords.txt). If
the guess doesn't appear in the dictionary, the guess is invalid and
will not be accepted. The game does not progress until a valid guess
is made. 

**m100le** initially **loads** today's word based on the system
**DATE$** value. When a guess is submitted, **m100le** compares it to
today's word, and provides the resultant clue. **m100le** does _not_
test to verify the word appears in the wordlist. A guess of 'MOIST' is
valid, as is a guess of 'DDDDD'.

### Every possible daily word
WORDLE contains a wordlist of over 2000 five-letter words, one per day
for six years. Uncompressed, the data is over 17 Kbytes; over half of
the memory on a TRS-80 Model 100.

Rather than impose this burden, **m100le** has split the wordlist into
seven files, based on the year so you need only download the **current
year's** wordfile. For example, in the year 2023, **m100le** sees the
two digit year of "23" in **DATE$** and loads the wordfile
`WL2023.CO`. If you've enabled the Manual Date Entry function (see
below), then the program will attempt to load whatever wordlist file
that corresponds to the year entered.

### Coloured tiles
As the Model 100 uses a monochrome LCD display, we don't have the
ability to use colours to provide the clues.

For each guess, a line in the **Clue Panel** will be filled in with
the clue for that guess, and the cumulative **Alphabet Panel** will be
updated.

| Clue | Meaning                            |
|:----:|:-----------------------------------|
| .    | Wrong letter                       |
| ?    | Letter is in word, wrong location  |
| */X  | X = Any letter in proper location<sup>&ddagger;</sup> |

#### <sup>&ddagger;</sup> an asterisk will appear in the **Alphabet Panel**, and the actual correct letter will appear in the **Clue Panel**

![image](https://user-images.githubusercontent.com/14062627/159623555-542d1454-eb42-4dc9-be3b-e3264fb2ec91.png)


### Setting the Date

When you restart the game with the <kbd>A</kbd> (AGAIN) key, you will
be prompted for the date you wish to play. If your DATE$ is never set
correctly or you'd like to replay a specific game, you can change
M100LE to always prompt for Manual Date Entry at startup by changing line
16 to set `MD` to 1:
```BASIC
16 MD=1
```

This will allow you to play a game from any date from any word file
loaded into your unit's memory. When enabled and run, the system will
prompt you for the date **` YY/MM/DD `**. The date must be typed
exactly in **` YY/MM/DD `** format. If you hit Enter, it will use the
the system's date.

Alternately, you could enter the ordinal 'Day-of-Year' ex. `200` for
the 200th day of the loaded year. You may also specify a year before
the ordinal day. For example, `21/170` would give you the 170th day of
the year 2021, which happens to be the first day in the official
Wordle wordlist. The ordinal day is shown on the right side of the
screen while playing. Subtract one to play the previous day's word.

### Y2K Compliance

M100LE works fine whether or not your m100 has a [Y2K patched
ROM](http://bitchin100.com/wiki/index.php?title=REXsharp). The century
number is just cosmetic as the m100 only keeps track of the last two
digits and the game presumes you are in the 21st century. For example,
if you set `DATE$="06/20/26"`, you'll get the same game no matter
whether the MENU shows 1926 or 2026.

### End of game
When either the word is guessed correctly, or no correct word is
guessed after six attempts, the game ends and you have a few options:

- [A]GAIN? - Prompt for a new date to play
- [R]ANDOM? - Starts a new game with the word chosen randomly from
  this year's wordlist
- [S]OCIAL? - Display your game's progress in a way suitable for
  sharing on social networks (Take a photo of the display & impress
  your friends :)
- [Q]UIT? - End the program execution and return to the main system menu.

### Gameplay
![image](https://user-images.githubusercontent.com/14062627/159623862-c2d431f8-f88a-48b0-ac1d-45fa83ce3df9.png)
Daily, a five-letter word is selected and players have six tries to
guess it. Each guess is rewarded with clues. After every guess, each
letter is evaluated and marked in the **Clue Panel** as either
<kbd>X</kbd>, <kbd>\*</kbd>, <kbd>?</kbd>, or <kbd>.</kbd> (CORRECT
LETTER, QUESTION MARK, or PERIOD). CORRECT LETTER in **Clue Panel**
indicates that letter is correct and in the correct position. QUESTION
MARK indicates that the letter is in the answer but not in the proper
position. PERIOD means that the letter is not in the answer at all. To
play the same as the official Wordle, M100LE now marks multiple
instances of the same letter in a guess, such as the "P"s in "POPPY",
with a QUESTION MARK even if the letter only appears once in the
answer. (In previous version of m100le, excess repeating letters were
shown as a PERIOD.)

## Installation

### Quickstart Guide

If you already know how to transfer binary files to your Model 100,
you only need two files: the tokenized basic for your system (e.g.,
[M100LE.BA][4]), and the compressed wordlist for the current year
(e.g., [WL2023.CO][23]). Pick one from each of the tables below. 

<details><summary>
Table of all code versions.
</summary>

| Filename                |  Size | Meaning                                                         |
|-------------------------|------:|-----------------------------------------------------------------|
| **ALL PLATFORMS**       |       |                                                                 |
| [M100LE+comments.DO][1] |  16KB | The actual source code, including all comments, in ASCII format |
| [M100LE.DO][2]          | 8.5KB | All comments removed, in ASCII format                           |
| **TANDY / TRS-80**      |       |                                                                 |
| [M100LE+comments.BA][3] |  14KB | Tokenized Tandy BASIC format, including all comments            |
| [M100LE.BA][4]          | 6.6KB | All comments removed, in tokenized Tandy BASIC format           |
| **NEC**                 |       |                                                                 |
| M100LE+comments.BA.NEC  |       | Tokenized NEC N82 BASIC format, including all comments          |
| M100LE.BA.NEC           |       | All comments removed, in tokenized NEC N82 BASIC format         |

</details>

<details><summary>
Table of all Word Lists.
</summary>

| Filename          | Size | Notes                                                         |
|-------------------|-----:|---------------------------------------------------------------|
| **ALL PLATFORMS** |      |                                                               |
| [WL2021.CO][21]   |   1K | Words before June 19th, 2021 are bonus words, added by M100LE |
| [WL2022.CO][22]   |   1K |                                                               |
| [WL2023.CO][23]   |   1K |                                                               |
| [WL2024.CO][24]   |   1K |                                                               |
| [WL2025.CO][25]   |   1K |                                                               |
| [WL2026.CO][26]   |   1K |                                                               |
| [WL2027.CO][27]   |   1K | Wordle's official list ends on October 14th, 2027             |

</details>

### Standard (ASCII) install

If you do not know how to transfer binary files to your Model 100, read on
for more specific advice on how to transfer both the program and at
least one wordlist file. Because the ASCII versions are larger, we
will have to do some tricks to save memory.

#### Step 1: Connect Model 100 to a modern computer

You will need a NULL modem cable. Since current computers do not come
with serial ports, you will likely also need a USB to Serial adapter.

> Warning: if you get certain serial adapters, your transfers will be
> garbled. Technically, you'll need a device that has hardware-level
> XON/XOFF flow-control, but that's rarely listed on the box. Some
> keywords you _might_ see in advertising: "on-chip flow control",
> "16950 UART", "MU860", or "FTDI". Additionally, _most_ adapters
> labelled "PL2303" will work, but not all of them.

#### Step 2: Pick a wordlist and run CMPRSS

Because it takes extra RAM that might not be available once the M100LE
program is loaded, it is best to load and run [CMPRSS](CMPRSS.DO)
first. CMPRSS is a BASIC program that runs on the Model 100. It reads
words from the serial port from a personal computer that is sending the
wordlist in ASCII. CMPRSS writes them out to a binary file in the RAM
storage, usually named WL20_xx_.CO. (Where 20xx is a year.)

##### Step 2A: Pick an uncompressed, ASCII wordlist
Download one of the following files to your personal computer:

<details><summary>
Table of uncompressed Word Lists.
</summary>

| Filename          | Size | Notes                                                         |
|-------------------|-----:|---------------------------------------------------------------|
| **ALL PLATFORMS** |      |                                                               |
| [WL2021.DO][31]   | 2.5K | Words before June 19th, 2021 are bonus words, added by M100LE |
| [WL2022.DO][32]   | 2.5K |                                                               |
| [WL2023.DO][33]   | 2.5K |                                                               |
| [WL2024.DO][34]   | 2.6K |                                                               |
| [WL2025.DO][35]   | 2.5K |                                                               |
| [WL2026.DO][36]   | 2.5K |                                                               |
| [WL2027.DO][37]   | 2.0K | Wordle's official list ends on October 14th, 2027             |

____
</details>

##### Step 2B: Download CMPRSS.DO to the PC.

##### Step 2C: Transfer CMPRSS.DO from PC to the Model 100.


##### Step 2D: Run CMPRSS on the Model 100

Tell it to load over the serial port.
Alternately, it works fine to run CMPRSS on a file.

#### Step 2E: Delete CMPRSSf



<details>
<summary>
Program: Installing over RS232C serial using a stock Model 100 and BASIC
</summary>


1. Download the most recent .zip file from the
   [RELEASES section](https://github.com/bgri/m100LE/releases).
1. Extract and copy 'M100LE.DO' to your Model 100.
1. Enter BASIC on the Model 100, and type:
   `LOAD "M100LE.DO"`
1. Then save the file as a .BA file:
   `SAVE "M100LE.BA"`
1. Delete the now-unnecessary .DO file to free up RAM:
   `KILL "M100LE.DO"`
1. Extract and copy 'WL20XX.DO' to your Model 100 replacing XX with
   the current year.

</details>


   Note that .CO files cannot be transferred via BASIC or the builtin
   TELCOM program. If you do not have a better transfer program, you
   can download the uncompressed .DO version of the wordlist instead.
   M100LE will automatically use it if the .CO file is missing.
   Optionally, you may use the [CMPRSS](CMPRSS.DO) program to convert
   WL20XX.DO into WL20XX.CO.

<details>
<summary>
If you don't have enough RAM.
</summary>

Since the source code is a bit large, it is possible that trying to
LOAD the file will fail with an Out of Memory (`?OM`) Error. There are
two possible workarounds: load the tokenized BASIC version for your
platform or tokenize the ASCII version one line at a time over the
serial port by using `LOAD "COM:98N1ENN"`.

### Formats

As mentioned above, there are multipe versions of the program
available. Only one file, ([M100LE+comments.DO](M100LE+comments.DO)),
is the true source code. All others are derived automatically, mostly
for smaller file size and to ease installation.

There are two variables that cause the proliferation of files:

1. **Comments** By default files have comments stripped to keep the size down.
   Versions which contain "+comments" in the filename include notes
   for developers who wish to edit or improving M100LE.

2. **Tokenization** Files can be in ASCII or one of four binary formats.
   * ASCII BASIC source code has two main benefits: it will run on any
     of the platforms and it can be downloaded by the builtin TELCOM
     program. ASCII format can be read on any machine and will run on
     any of the platforms. However, downloading requires an extra
     tokenization step which may require more memory than your
     computer has. (But, see [installation](#Installation) for a
     workaround.)
     * **.DO** Runs on any of the Kyotronic Sisters
   * Tokenized BASIC format which saves memory during transfer, but
     requires using a program such as TEENY which can download binary
     files. Tokenization is specific to each family of machines.
	 * **.BA** Runs only on Model 100, Tandy 102 (US and UK), and Tandy 200.
	 * **.BA.NEC** Runs only on NEC PC-8201, PC-8201A, and PC-8300.
	 * **.BA.K85** Runs only on Kyocera Kyotronic-85
	 * **.BA.M10** Runs only on Olivetti M10

## Roadmap

- Add the ability to save and display statistics
- Improve clues, guess feedback and messages
- Do the impossible: Cram Wordle's 72 KB spelling dictionary into 10 KB (or less).

## FAQ
### About the word files and today's word
The current version of **m100le** (greater than v0.l) uses the New
York Times Wordle word lists. Prevously, the wordfiles used were based
on the the **original** javascript WORDLE, which contained the entire
set of daily words (the wordfile) within the program code. Over six
years worth of words.

While the order changed, there are
[very few differences](https://github.com/jackgreenburg/wordle-wordlists)
between the original and the current word lists.

### How wordfiles work
Big wordfiles wouldn't work for our little units, so we broke each
wordfile into manageable chunks of one year each. The .CO files are
also compressed so each five-letter word takes only three bytes. If
you have enough memory and you'd like to see and change the words, you
may want to download the plain text WL20xx.DO files instead. M100LE
will automatically use a .DO file if the .CO file is not found.

The wordfiles are all named for the year they correspond to. On
program load, **m100le** checks the system **DATE$** for the current
date OR the manually entered date (if enabled) and scans the
appropriate wordfiles for the matching daily word.

### Will my m100le word be the same as today's NYT Wordle word?
Maybe. Mostly. It ought to, anyhbow. The NYT may change their word
list at any time. If that happens, and we don't catch it, let us know
and we'll update ours.

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

	[1]: https://raw.githubusercontent.com/bgri/m100LE/main/M100LE%2Bcomments.DO
	[2]: https://raw.githubusercontent.com/bgri/m100LE/main/M100LE.DO
	[3]: https://raw.githubusercontent.com/bgri/m100LE/main/M100LE%2Bcomments.BA
	[4]: https://raw.githubusercontent.com/bgri/m100LE/main/M100LE.BA
	[21]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2021.CO
	[22]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2022.CO
	[23]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2023.CO
	[24]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2024.CO
	[25]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2025.CO
	[26]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2026.CO
 	[27]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2027.CO
  	[31]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2021.DO
	[32]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2022.DO
	[33]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2023.DO
	[34]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2024.DO
	[35]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2025.DO
	[36]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2026.DO
	[37]: https://raw.githubusercontent.com/bgri/m100LE/main/WL2027.DO
