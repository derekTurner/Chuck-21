//Save the data arrays for ode to joy to a file odeData1.txt
//
//chuck odesaver.ck


// Midi notes   57 59 61 62 64 66 68 69
// note name    A  B  C# D  E  F# G# A

[ 61,  61,  62,  64,  64,  62,  61,  59,  57,  57,  59,  61,  61,  59,  59] @=> int melNotes[];
[192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 288,  96, 384] @=>int myDurs[];
[1.0, 1.0, 1.0, 1.0 ,1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] @=> float myVelocities[];
"odePart1.txt" => string filename;

stash(melNotes, myDurs, myVelocities);


function void stash (int notes[], int durations[], float velocities[] ){
    // flags: READ_WRITE, READ, WRITE, APPEND, BINARY, ASCII combine with | bitwise or.
    me.sourceDir() + "/" + filename => string filepath;
    FileIO datafile;
    datafile.open(filepath, FileIO.WRITE | FileIO.ASCII  );
    datafile.write(melNotes.cap());
    datafile.write("\n");
    for( 0 => int i; i < notes.cap(); i++ ){datafile.write(notes[i]);datafile.write("\n");}
    for( 0 => int i; i < notes.cap(); i++ ){datafile.write(durations[i]);datafile.write("\n");}
    for( 0 => int i; i < notes.cap(); i++ ){datafile.write(velocities[i]);datafile.write("\n");}
    datafile.close();
}

