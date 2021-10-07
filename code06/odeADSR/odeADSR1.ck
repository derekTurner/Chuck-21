//ode to joy using arrays
// run slider html file and bridge first
// then play files on sounds 1 and 2 with slider control
// chuck Sound.ck OscMonitor.ck odeADSR1.ck

120 => float tempo;

60/(tempo * 192) => float tick;

//Note durations in ticks: 384  minim;  288  crotchetD;  192  crotchet;  96  quaver;

// Midi notes   57 59 61 62 64 66 68 69
// note name    A  B  C# D  E  F# G# A

[ 61,  61,  62,  64,  64,  62,  61,  59,  57,  57,  59,  61,  61,  59,  59] @=> int melNotes[];
[192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 192, 288,  96, 384] @=>int myDurs[];
[1.0, 1.0, 1.0, 1.0 ,1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0] @=> float myVelocities[];

Event start;

// replace sound patch here with external class file
Sound snd => dac;
0.0 =>snd.noteOff;

OscMonitor oscmon;
spork ~ oscmon.oscGo(snd);

spork ~ player(melNotes, myDurs, myVelocities, start);
1.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

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