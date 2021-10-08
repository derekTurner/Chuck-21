// load array of sounds using a function
// chuck samplefunction.ck

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

// test sounds
for (0 => int i; i < buffers.cap(); i++){
    0 => buffers[i].pos;
    500::ms => now;
}

// time loop
while( true )
{
    Math.random2(0,4) => buf;
    0 => buffers[buf].pos;
    Math.random2f(.2,.5) => buffers[buf].gain;
    Math.random2f(.5,1.5) => buffers[buf].rate;
    100::ms => now;
}

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



