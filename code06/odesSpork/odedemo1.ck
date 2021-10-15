//ode to joy using two sporked players
// chuck odedemo1.ck

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

SinOsc a => dac;
SinOsc b => dac;
0 => a.gain => b.gain;

spork ~ player(melNotes, myDurs, myVelocities, a, start);
spork ~ player(harNotes, harDurs, harVelocities, b, start);
5.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

//---------------------- voice playing functions --------------//

function void player(int N[], int D[], float V[], SinOsc generator, Event start){
    while( true){
        0 => generator.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (0 =>int index; index < N.cap(); index ++){ //for each element of the array
                Std.mtof(N[index])      => generator.freq;
                V[index]   * 0.2    => generator.gain;
                D[index] * tick :: second => now;
            }
        }
    }
}

