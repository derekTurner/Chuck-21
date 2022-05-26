//ode to joy using single sound in separate class file
//Now reading note arrays form a file
//chuck Sound.ck mdvPlayer.ck

40 => float tempo;

60/(tempo * 192) => float tick;

int melNotes[0];
int myDurs[0];
float myVelocities[0];



// sound patch read from an external class file Sound,ck
Sound snd => dac;
0.0 =>snd.noteOff;

"mdv/OdeToJoy1.txt" => string filename;
retrieve(melNotes, myDurs, myVelocities);


Event start;

spork ~ player(melNotes, myDurs, myVelocities, start);
1.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

// ------------------------ file reading function ------------------------------//

function void retrieve(int notes[], int durations[], float velocities[] ){
    int cap;
    // flags: READ_WRITE, READ, WRITE, APPEND, BINARY, ASCII combine with | bitwise or.
    me.sourceDir() + "/" + filename => string filepath;
    FileIO datafile;
    datafile.open(filepath, FileIO.READ | FileIO.ASCII  );
    Std.atoi( datafile.readLine()) => cap;
    //<<< "array length " ,cap >>>;
    cap => notes.size;
    cap => durations.size;
    cap => velocities.size;
    for( 0 => int i; i < cap; i++ ){Std.atoi(datafile.readLine())=>(notes[i]);}
    for( 0 => int i; i < cap; i++ ){Std.atoi(datafile.readLine())=>(durations[i]);}
    for( 0 => int i; i < cap; i++ ){Std.atof(datafile.readLine())=>(velocities[i]);}
    datafile.close();
    //<<<cap, notes ,durations, velocities >>>; // prints pointer to arrays not array values.
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

