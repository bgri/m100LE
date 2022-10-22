# How to send an ASCII file to a Model 100 via RS232C

Receiving an ASCII (plain text) file over the serial port is easy on a
Model 100 and no special program is needed. Sending a file to the
Model 100 is also fairly simple, but the instructions depend upon what
type of computer you are using.

[Side note: For _binary_ files, you must use a special program, like
[TEENY](https://youtu.be/H0xx9cOe97s).]

## Sending from a GNU/Linux UNIX box

* Use the [sendtomodelt](adjunct/sendtomodelt) program, which is
  essentially a glorified `cat foo > /dev/ttyUSB0`.

## Sending from any UNIX box, logged in with getty

<ul><details>

Turn on Download in TELCOM, which starts a screen capture, and use
`cat foo` on the UNIX host, where foo is the name of the file you want
to transfer. Turn off Download when finished.
  
* Tip: To avoid having the command "cat foo" and the trailing prompt
  embedded in the file, you can do this:
  
  1. Type `cat foo; read` but do _not_ press <kbd>Enter</kbd>.
  1. Turn on TELCOM's Download.
  1. Now press <kbd>Enter</kbd>.
  1. Wait for the file to finish transferring.
  1. Turn off Download.
  1. Hit <kbd>Enter</kbd> a final time to get back to the prompt.
 
* Tip: For large files, one can speed up transmission by disabling the
  Model 100's screen scrolling. Use `echo -en "\eV"` to turn off
  scrolling and `echo -en "\eW"` to turn it back on.

</details></ul>

## Sending from Apple MacOS UNIX

* The [sendtomodelt](adjunct/sendtomodelt) program could work but it
  will need to be tested and ported.

## Sending from Microsoft Windows (WSL UNIX)

* Not written yet

## Sending from Microsoft Windows (GUI)

* Not written yet

## Sending from another Model 100
<ul><details>

* If sending a BASIC program: `SAVE "COM:98N1ENN", A`
  <ul><details><summary>Side note or NEC users</summary
  
  For the NEC PC-8201A, use `SAVE "COM:9N81XN", A`
  </details></ul>

* If sending a text file: use TELCOM's "Upload" function
  (<kbd>F3</kbd> on Tandy portables).

</details>

## Sending from an Android/Linux device

* Not written yet

## Sending from an Apple iOS device (iPad / iPhone)

* Not written yet






