// samplepattern.ck play samples in array pattern

1.05946309  => float semitone;
120 => float tempo;
60/(tempo * 192) => float tick;

// 384 * tick :: second => dur minim;
// 288 * tick :: second => dur crotchetD;
// 192 * tick :: second => dur crotchet;
// 96  * tick :: second => dur quaver;

[ 0,  1,   0,   2,   3,   3,   4,   4,   2,   2,   1,   4,   3,   3,   4] @=> int bufs[];
[192, 192, 288, 192, 96,  192, 192, 288, 192, 96,  192, 192, 288, 96,  384] @=>int myDurs[];
[1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.7, 1.0, 1.0, 1.0] @=> float myVelocities[];

SndBuf buffers[5];
0 => int buf;
string filename;

// the patch 
Gain samples => dac;
0.8 => samples.gain;
for (0 => int i; i < buffers.cap(); i++){
    buffers[i] => samples;
}

// load the files
me.dir() + "../audio/clap_01.wav" =>    filename;
filename => buffers[0].read;
me.dir() + "../audio/click_01.wav" =>   filename;
filename => buffers[1].read;
me.dir() + "../audio/click_02.wav" =>   filename;
filename => buffers[2].read;
me.dir() + "../audio/cowbell_01.wav" => filename;
filename => buffers[3].read;
me.dir() + "../audio/hihat_01.wav" =>   filename;
filename => buffers[4].read;



// pattern
for (0 =>int index; index < bufs.cap(); index ++){ //for each element of the array
        0 => buffers[bufs[index]].pos;
        myVelocities[index]   * 0.2    => buffers[bufs[index]].gain;
        myDurs[index] * tick :: second => now;
    }
