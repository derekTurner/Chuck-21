// load array of sounds using a function
// chuck samplefunctionpattern001.ck

// All wav files are stereo so need sndBuf2

120 => float tempo;
60/(tempo * 192) => float tick;

// 384 * tick :: second => dur minim;
// 288 * tick :: second => dur crotchetD;
// 192 * tick :: second => dur crotchet;
// 96  * tick :: second => dur quaver;

// define as many patterns as you like
[ 0,  1,   3,   4,   5,   6,   7,   8,   9,   10,   11,   12,   13,   14,   15] @=> int bufs1[];
[192, 192, 192, 192, 192,  192, 192, 192, 192, 192,  192, 192, 192, 192,  192] @=>int myDurs1[];
[1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.7, 1.0, 1.0, 1.0] @=> float myVelocities1[];

[ 3,  3,   3,   3,   3,   3,   3,   3,   3,   1,   1,   1,   3,   3,   4] @=> int bufs2[];
[ 96,  96,  96,  96, 96,  192, 192, 288, 192, 96,   96,  96, 288, 96,   96] @=>int myDurs2[];
[1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.7, 1.0, 1.0, 1.0] @=> float myVelocities2[];

[2 ,2, 2] @=> int bufs3[];
[ 500, 500,500] @=>int myDurs3[];
[0.0, 0.0, 1.0] @=> float myVelocities3[];

// load the files and route to samples gain element
"Amen/" => string samplepath;
//["AmenMain_L+R.WAV"] @=> string samplefiles[];
["crashLong.WAV"] @=> string samplefiles[];
samplefiles << "crash01.wav";

samplefiles << "crashLong.WAV";
/*
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
<<<samplefiles>>>;
SndBuf2 buffers[samplefiles.cap()];

0 => int buf;

// the patch 
Gain samples => dac;
0.8 => samples.gain;


loadSamples (samplepath, samplefiles, buffers, samples);
playPattern(buffers, bufs3, myDurs3, myVelocities3);
//playPattern(bufs2, myDurs2, myVelocities2);
//playPattern(bufs2, myDurs2, myVelocities2);
//playPattern(bufs1, myDurs1, myVelocities1);



/*--------------------- functions ----------------------------*/

function void loadSamples (string path, string filenames[], SndBuf2 sounds[], Gain target){
    // load samples defined by path + filename into buffer array and route to target
    "null" =>  string filename;

    for (0 => int i;  i < filenames.cap(); i++){
        me.dir() + path + filenames[i]  =>    filename;
        <<<filename>>>;
        filename => sounds[i].read;
        sounds[i] => target;
    }    
}

function void playPattern (SndBuf2 buffers[], int myBufs[], int myDurs[]  ,float myVelocities[]){
    for (0 =>int index; index < myBufs.cap(); index ++){ //for each element of the array

        1.0 => buffers[myBufs[index]].rate;
        myVelocities[index]   * 0.2    => buffers[myBufs[index]].gain ;
        buffers[myBufs[index]].samples()  => buffers[myBufs[index]].pos;
        <<< "on" , myBufs[index], buffers[myBufs[index]].samples() >>>;
        if (myVelocities[index] >0) myDurs[index] * tick :: second => now;
        <<< "off" , myBufs[index]>>>;
        buffers[myBufs[index]].samples() => buffers[myBufs[index]].pos ;
    }
}