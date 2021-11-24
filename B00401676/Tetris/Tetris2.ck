//ode to joy using two sporked players with different voices
// chuck odedemo2.ck

140 => float tempo;

60/(tempo * 192) => float tick;

//Note durations in ticks: 384  minim;  288  crotchetD;  192  crotchet;  96  quaver;

// Midi notes   57 59 61 62 64 66 68 69
// note name    A  B  C# D  E  F# G# A


[ 76,  71,  72,  74,  72,  71,  69,  69,  72,  76,  74,  72,  71,  71,  72,  74,  76,  72,  69,  69,  24,  74,  74,  77,  81, 79, 77, 76, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69 ] @=> int melNotes[];
[192,  96,  96, 192,  96,  96, 192,  96,  96, 192,  96,  96, 192,  96,  96, 192, 192, 192, 192, 192, 288,  96,  96,  96,  96] @=>int myDurs[];
[1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] @=> float myVelocities[];

[ 59,  52,  59,  64,  52,  59,  45,  52,  45,  52,  45,  52,  59,  52,  59,  52,  59, 45, 52, 45, 50, 57, 50, 57, 50, 57, 50, 48, 55, 48, 55, 48, 52, 59, 52, 59, 52, 57, 52, 45 ] @=> int harNotes[];
[192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192] @=>int harDurs[];
[1.0, 0.0, 0.0, 0.0 ,1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] @=> float harVelocities[];

// [ h, q, q, h, q, q, h, q, q, h, q, q, h, q, q, h, h, h, h, k, q, q, q, q, h, q, q, i, q, h, q, q, h, q, q, h, h, h, h, h ]
Event start;
SinOsc a => dac; 
TriOsc b => dac; 


0 => a.gain => b.gain;

spork ~ sinPlayer(melNotes, myDurs,  myVelocities,  a, start);
spork ~ triPlayer(harNotes, harDurs, harVelocities, b, start);
0.5 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

//---------------------- voice playing functions --------------//

function void sinPlayer(int N[], int D[], float V[], SinOsc generator, Event start){
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

function void triPlayer(int N[], int D[], float V[], TriOsc generator, Event start){
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

