# How to send an ASCII file to a Model 100 via RS232C serial

To receive ASCII (plain text) files, no special program is needed on
the Model 100. The instructions on the other end, however, depend upon
what type of computer you are sending from.

[Side note: For _binary_ files, you must use a special program, like
[TEENY](https://youtu.be/H0xx9cOe97s).]

## Sending from a GNU/Linux UNIX box

* Use the [sendtomodelt](adjunct/sendtomodelt) program, which is
  essentially a glorified `cat foo > /dev/ttyUSB0`.

## Sending from any UNIX box, logged in with getty

* Turn on File Download in TELCOM, which captures everything sent to
  the screen, and use `cat foo`, where foo is the name of the file you
  want to transfer.

## Sending from Apple MacOS UNIX

* The [sendtomodelt](adjunct/sendtomodelt) program may work. 

## Sending from Microsoft Windows (WSL UNIX)

* Not written yet

## Sending from Microsoft Windows (GUI)

* Not written yet

## Sending from another Model 100

* Not written yet

## Sending from an Android/Linux device

* Not written yet

## Sending from an Apple iOS device (iPad / iPhone)

* Not written yet






