//ode to joy using arrays and function
<<< "ode to joy" >>>;
120 => float tempo;

60/(tempo * 192) => float tick;
// 384 * tick :: second => dur minim;
// 288 * tick :: second => dur crotchetD;
// 192 * tick :: second => dur crotchet;
// 96  * tick :: second => dur quaver;

// Midi notes   57 59 61 62 64 66 68 69
// note name    A  B  C# D  E  F# G# A

[ 61,  61,  62,  64,  64,  62,  61,  59,  57,  57,  59,  61,  61,  59,  59] @=> int melNotes[];
[192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 288,  96, 384] @=>int myDurs[];
[1.0, 1.0, 1.0, 1.0 ,1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] @=> float myVelocities[];


SinOsc s => dac;
0.2 => s.gain ;

for (1 => int i; i <= 4; i++) {// four repeats
    player(melNotes, myDurs, myVelocities);
}

function void player(int N[], int D[], float V[]){
    for (0 =>int index; index < N.cap(); index ++){ //for each element of the array
        Std.mtof(N[index])      => s.freq;
        V[index]   * 0.2    => s.gain;
        D[index] * tick :: second => now;
    }
}

