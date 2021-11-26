// load array of sounds using a function
// chuck samplefunctionpattern002.ck

// All wav files are stereo so need sndBuf2

120 => float tempo;
60/(tempo * 192) => float tick;

// 384 * tick :: second => dur minim;
// 288 * tick :: second => dur crotchetD;
// 192 * tick :: second => dur crotchet;
// 96  * tick :: second => dur quaver;

// define as many patterns as you like

[192, 500, 192, 192, 192,  192, 192, 192, 192, 192,  192, 192, 192, 192,  192] @=>int myDurs1[];
[1.0, 0.0, 0.5, 0.0, 1.0, 0.0, 0.0, 1.0, 0.5, 1.0, 1.0, 0.7, 1.0, 1.0, 1.0] @=> float myVelocities1[];


SndBuf2 buffer;

(me.dir()  + "AMEN/" + "AmenMain_L+R.WAV") => string filename;
filename =>  buffer.read;
<<< filename >>>;

/*
samplefiles << "crash01.wav";
samplefiles << "crashLong.WAV";
samplefiles << "dbKick01.WAV";
samplefiles << "dbKick02.WAV";
samplefiles << "dbKick03.WAV";
samplefiles << "hat01.WAV";
samplefiles << "hat02.WAV";
samplefiles << "hat03.WAV";
samplefiles << "kick02.WAV";
samplefiles << "kick03.WAV";
samplefiles << "kick04.WAV";
samplefiles << "shuff01.WAV";
samplefiles << "shuff02.WAV";
samplefiles << "shuff03.WAV";
samplefiles << "shuff04.WAV";
samplefiles << "shuff05.WAV";
samplefiles << "smallSnare01.WAV";
samplefiles << "snare01.WAV";
samplefiles << "snare02.WAV";
samplefiles << "snare03.WAV";
samplefiles << "snare04.WAV";
samplefiles << "snare05.WAV";
samplefiles << "snare06.WAV";
samplefiles << "snare07.WAV";
*/




// the patch 
buffer => Gain samples => dac;
0.8 => samples.gain;

playPattern(buffer, myDurs1, myVelocities1);




/*--------------------- functions ----------------------------*/


function void playPattern (SndBuf2 buffer,  int myDurs[]  ,float myVelocities[]){
    for (0 =>int index; index < myDurs.cap(); index ++){ //for each element of the array

        1.0 => buffer.rate;
        myVelocities[index]   * 0.2    => buffer.gain ;
        
        <<< "on",  buffer.samples() >>>;
        if (myVelocities[index] >0) {0 => buffer.pos;<<<"sound">>>; }
        myDurs[index] * tick :: second => now;
        <<< "off" >>>;
        buffer.samples() => buffer.pos ;
    }
}