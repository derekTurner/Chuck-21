// chuck tetris.ck
// Tetris Theme with text

// by Richard Elliott 2021

// two oscillators, melody and harmony
SinOsc s => Pan2 mpan => dac;       //  SinOsc through Pan2 for melody
TriOsc t => dac;                    //  TriOsc fixed at center for harmony

0.5 => float onGain;                //  Note on/off gains
0.0 => float offGain;

// declare and initialize our arrays of MIDI note #s

[76, 71, 72, 74, 72, 71, 69,               // Melody (int) MIDI note array
69, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69, 24, 74, 74, 77, 81, 79, 77, 76, 72, 76, 74, 72, 71, 71, 72, 74, 76, 72, 69, 69 ] @=> int melNotes[];
[59, 52, 59, 64, 52, 59, 45,               // Harmony (int) MIDI note array
52, 45, 52, 45, 52, 59, 52, 59, 52, 59, 45, 52, 45, 50, 57, 50, 57, 50, 57, 50, 48, 55, 48, 55, 48, 52, 59, 52, 59, 52, 57, 52, 45 ] @=> int harmNotes[];

// note Duration (dur) array
60.0/170.0 => float beats_per_second;

(beats_per_second/2) :: second => dur q;
(beats_per_second) :: second => dur h;
(beats_per_second*1.5) :: second => dur i;
(beats_per_second*2) :: second => dur k;
[ h, q, q, h, q, q, h, q, q, h, q, q, h, q, q, h, h, h, h, k, q, q, q, q, h, q, q, i, q, h, q, q, h, q, q, h, h, h, h, h ] @=> dur myDurs[];

// make one more array to hold the message
[" "," T"," E"," T"," R"," I"," S"," ", // Text (string) array
" T", " H","E","M","E"," ","T","U","N","E"," "," "," ","B","Y"," ","R","I","C","H","A","R","D"," ","E","L","L","I","O","T","T"," "] @=> string words[];

// loop over all the arrays
for(0 => int j; j < 4; j++ ){
    for (0 => int i; i < melNotes.cap(); i++) //  Plays through all 
    {                                         //  notes in array
        // (9) print out index, MIDI notes, and words from arrays
        <<< i, melNotes[i], harmNotes[i], words[i] >>>;

        // set melody and harmony from arrays
        Std.mtof(harmNotes[i]) => s.freq;    //  Sets frequencies from
        Std.mtof(melNotes[i]) => t.freq;     //  array MIDI notes
        if( j >=1){ 
            //play sample
        }
        if( j >=2){ 
            //add chord
        }
        // melody has a random pan for each note
        Math.random2f(-1.0,1.0) => mpan.pan; // Random pan for melody oscillator

        // notes are on for 70% of duration from array
        onGain => s.gain => t.gain;          // Turns on both oscillators
        0.9*myDurs[i] => now;                // 90% of array duration is note on time

        // space between notes is 30% of array duration
        offGain => s.gain => t.gain;
        0.1*myDurs[i] => now;                // 10% of array duration is off time


        // add rest at end of loop
        if ( i == melNotes.cap()-1) {
            myDurs[i] => now; 
        }
    }
}
