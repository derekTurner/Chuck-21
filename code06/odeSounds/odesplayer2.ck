//ode to joy using single sound in separate class file
//Now need to run three files in startup command
//chuck Sound1.ck Sound2.ck odesplayer2.ck

120 => float tempo;

60/(tempo * 192) => float tick;

//Note durations in ticks: 384  minim;  288  crotchetD;  192  crotchet;  96  quaver;

// Midi notes   57 59 61 62 64 66 68 69
// note name    A  B  C# D  E  F# G# A

[ 61,  61,  62,  64,  64,  62,  61,  59,  57,  57,  59,  61,  61,  59,  59] @=> int melNotes[];
[192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 288,  96, 384] @=>int myDurs[];
[1.0, 1.0, 1.0, 1.0 ,1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] @=> float myVelocities[];

[ 61,  61,  62,  64,  61,  62,  61,  59,  61,  57,  59,  61,  61,  59,  64] @=> int harNotes[];
[192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 288,  96, 384] @=>int harDurs[];
[1.0, 0.0, 0.0, 0.0 ,1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0] @=> float harVelocities[];

Event start;

// replace sound patch here with external class file
Sound1 snd1 => dac;
0.0 =>snd1.noteOff;

Sound2 snd2 => dac;
0.0 =>snd2.noteOff;

spork ~ player1(melNotes, myDurs,  myVelocities,  snd1 , start);
spork ~ player2(harNotes, harDurs, harVelocities, snd2 , start);

1.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

//---------------------- voice playing functions --------------//

function void player1(int N[], int D[], float V[], Sound1 snd, Event start){
    while( true){
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

function void player2(int N[], int D[], float V[], Sound2 snd, Event start){
    while( true){
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