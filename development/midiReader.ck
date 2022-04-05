//Trying to read a midi file with one track into notes, durs, vel array
//
//chuck Sound.ck midiReader.ck

120 => float tempo;

60/(tempo * 192) => float tick;

int melNotes[0];
int myDurs[0];
float myVelocities[0];



// replace sound patch here with external class file
Sound snd => dac;
0.0 =>snd.noteOff;

"threenotes.mid" => string filename;
readMidiTrack(filename,melNotes, myDurs, myVelocities);


Event start;

spork ~ player(melNotes, myDurs, myVelocities, start);
1.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

// ------------------------ file reading function ------------------------------//

function void readMidiTrack(string midiFile, int notes[], int durations[], float velocities[] ){
    int cap;
    // flags: READ_WRITE, READ, WRITE, APPEND, BINARY, ASCII combine with | bitwise or.
    me.sourceDir() + "/" + midiFile => string filepath;
    FileIO datafile;
    datafile.open(filepath,  FileIO.READ | FileIO.MODE_BINARY  );
    Std.atoi( datafile.readLine()) => cap;


    filepath => int size;
    file.finish(); // wait for the read to finish without advancing time
                   // before continuing
    
    // now read in the contents
    int ret[size];
    for (0 => int i; i < size; i++)
        file => ret[i];
        <<<ret[i] >>>;
    // and we're done
    file.close(ret[i]); // automatically calls file.finish()


    /*
    <<< cap >>>;
    cap => notes.size;
    cap => durations.size;
    cap => velocities.size;
    for( 0 => int i; i < cap; i++ ){Std.atoi(datafile.readLine())=>(notes[i]);}
    for( 0 => int i; i < cap; i++ ){Std.atoi(datafile.readLine())=>(durations[i]);}
    for( 0 => int i; i < cap; i++ ){Std.atof(datafile.readLine())=>(velocities[i]);}
    datafile.close();
    <<<cap, notes ,durations, velocities >>>; // prints pointer to arrays not array values.
    */
}

//---------------------- voice playing functions --------------//

function void player(int N[], int D[], float V[], Event start){
    while( true){
        //0 => s.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (0 =>int index; index < N.cap(); index ++){ //for each element of the array
                Std.mtof(N[index])      => snd.setFreq;
                V[index]   * 0.2    => snd.noteOn;
                D[index] * tick :: second => now;
                0.0 => snd.noteOff;
            }
        }
    }
}

