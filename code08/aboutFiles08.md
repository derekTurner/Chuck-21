
# FileIO

It would be more versatile to be able to compose simple tunes in a notation editor and transfer them to chuckrRather than writing midi note values directly to the source array.

Use of file output and input will allow the note, duration and velocity arrays to be saved into a text file which can then be read to replay the tune.

Subsequently the text file can be produced by a chain of conversions Notation Editor ==> music XML ==> ABC format ==> chuck array format.

ABC format is preferred over MIDI at this point but later on we will also consider input to chuck directly form MIDI.

## odesaver.ck odePart1.txt

The values from the note, duration and velocity arrays are stored into human readable text file. 

## odeReader.ck odePart1.txt

The values stored in a human readable text file are read back into note, duration and velocity arrays within chuck.

# convert

Conferting files from ABC format into Midi Duration Velocity format to be read by chuck.

## abcconverter.ck:name  & name.txt

TheABC code is read from a text file and converted into a chuck readable format stored in the mdv folder.

