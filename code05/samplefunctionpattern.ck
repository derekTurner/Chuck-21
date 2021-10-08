// load array of sounds using a function
// chuck samplefunctionpattern.ck

120 => float tempo;
60/(tempo * 192) => float tick;

// 384 * tick :: second => dur minim;
// 288 * tick :: second => dur crotchetD;
// 192 * tick :: second => dur crotchet;
// 96  * tick :: second => dur quaver;

// define as many patterns as you like
[ 0,  1,   0,   2,   3,   3,   4,   4,   2,   2,   1,   4,   3,   3,   4] @=> int bufs1[];
[192, 192, 288, 192, 96,  192, 192, 288, 192, 96,  192, 192, 288, 96,  384] @=>int myDurs1[];
[1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.7, 1.0, 1.0, 1.0] @=> float myVelocities1[];

[ 3,  3,   3,   3,   3,   3,   3,   3,   3,   1,   1,   1,   3,   3,   4] @=> int bufs2[];
[ 96,  96,  96,  96, 96,  192, 192, 288, 192, 96,   96,  96, 288, 96,   96] @=>int myDurs2[];
[1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.5, 1.0, 1.0, 0.7, 1.0, 1.0, 1.0] @=> float myVelocities2[];


// load the files and route to samples gain element
"../audio/" => string samplepath;
["clap_01.wav"] @=> string samplefiles[];
samplefiles << "click_01.wav";
samplefiles << "click_02.wav";
samplefiles << "cowbell_01.wav";
samplefiles << "hihat_01.wav";
SndBuf buffers[samplefiles.cap()];

0 => int buf;

// the patch 
Gain samples => dac;
0.8 => samples.gain;


loadSamples (samplepath, samplefiles, buffers, samples);
playPattern(bufs1, myDurs1, myVelocities1);
playPattern(bufs2, myDurs2, myVelocities2);
playPattern(bufs2, myDurs2, myVelocities2);
playPattern(bufs1, myDurs1, myVelocities1);



/*--------------------- functions ----------------------------*/

function void loadSamples (string path, string filenames[], SndBuf sounds[], Gain target){
    // load samples defined by path + filename into buffer array and route to target
    "null" =>  string filename;

    for (0 => int i;  i < filenames.cap(); i++){
        me.dir() + path + filenames[i]  =>    filename;
        filename => sounds[i].read;
        sounds[i] => target;
    }    
}

function void playPattern (int myBufs[], int myDurs[]  ,float myVelocities[]){
    for (0 =>int index; index < myBufs.cap(); index ++){ //for each element of the array
        0 => buffers[myBufs[index]].pos;
        myVelocities[index]   * 0.2    => buffers[myBufs[index]].gain;
        myDurs[index] * tick :: second => now;
    }
}