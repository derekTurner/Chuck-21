//ode to joy using single sound in separate class file
//Now reading note arrays form a file
//chuck Sound1.ck Sound2.ck Sound3.ck OscMonitorSplit.ck triReaderParam.ck:name

120 => float tempo;

60/(tempo * 192) => float tick;

int   Notes1[0];  
int   Durs1[0]; 
float Velocities1[0];

int   Notes2[0]; 
int   Durs2[0]; 
float Velocities2[0];

int   Notes3[0] ;    
int   Durs3[0]; 
float Velocities3[0];
string filename;

10 => int gap1;
15 => int gap2;
05 => int gap3;

// replace sound patch here with external class file
Sound1 snd1 => Gain master =>dac;
Sound2 snd2 => master;
Sound3 snd3 => master;
0.3 => master.gain;

0.0 =>snd1.noteOff;
0.0 =>snd2.noteOff;
0.0 =>snd3.noteOff;

if(me.args()){
    "mdv/"+ me.arg(0)+"1.txt" => filename;
}   
retrieve(Notes1, Durs1, Velocities1);

if(me.args()){
    "mdv/"+ me.arg(0)+"2.txt" => filename;
}   
retrieve(Notes2, Durs2, Velocities2);

if(me.args()){
    "mdv/"+ me.arg(0)+"3.txt" => filename;
}   
retrieve(Notes3, Durs3, Velocities3);

Event start;

OscMonitorSplit oscmon;
spork ~ oscmon.oscGo(snd1, snd2, snd3);

spork ~ player1(Notes1, Durs1, Velocities1, snd1, start, gap1);
spork ~ player2(Notes2, Durs2, Velocities2, snd2, start, gap2);
spork ~ player3(Notes3, Durs3, Velocities3, snd3, start, gap3);

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

function void player1(int N[], int D[], float V[], Sound1 generator, Event start,  int gap){
    while( true){
        //0 => s.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (1 =>int index; index < N.cap(); index ++){ //for each element of the array
                Std.mtof(N[index])      => generator.setFreq;
                V[index]   * 0.2    => generator.noteOn;
                (D[index]-gap)* tick :: second => now;
                0.0 => generator.noteOff;
                gap * tick :: second => now;
            }
        }
    }
}

function void player2(int N[], int D[], float V[], Sound2 generator, Event start, int gap){
    while( true){
        //0 => s.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (1 =>int index; index < N.cap(); index ++){ //for each element of the array
                Std.mtof(N[index])      => generator.setFreq;
                V[index]   * 0.2    => generator.noteOn;
                (D[index]-gap)* tick :: second => now;
                0.0 => generator.noteOff;
                gap * tick :: second => now;
            }
        }
    }
}

function void player3(int N[], int D[], float V[], Sound3 generator, Event start, int gap){
    while( true){
        //0 => s.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (1 =>int index; index < N.cap(); index ++){ //for each element of the array
                Std.mtof(N[index])      => generator.setFreq;
                V[index]   * 0.2    => generator.noteOn;
                (D[index]-gap)* tick :: second => now;
                0.0 => generator.noteOff;
                gap * tick :: second => now;
            }
        }
    }
}
