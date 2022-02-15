// play sounds from buffers in threads with normal distribution.
// chuck spork1normSamp.ck

Event start;

Gain master => dac;
0.4 => master.gain;

spork ~ track1(start);
5.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 

//---------------------- library  functions --------------//

function void loadSamples (string path, string filenames[], SndBuf sounds[], Gain target){
    // load samples defined by path + filename into buffer array and route to target
    "null" =>  string filename;

    for (0 => int i;  i < filenames.cap(); i++){
        me.dir() + path + filenames[i]  =>    filename;
        filename => sounds[i].read;
        sounds[i] => target;
    }    
}

function float normRand(int n, float sigma, float mean ){
    // n is number to average typical 20 minimum 3 gives looser fit to normal distribution
    // std deviation sigma 68.2% within 1 sigma 95.4 within 2 sigma 99.7 within 3 sigma
    // mean is average value of distribution.
    // Mohazzabi, P. and Connolly, M. (2019) An Algorithm for Generating Random Numbers with Normal Distribution. Journal of Applied Mathematics and Physics, 7, 2712-2722. doi: 10.4236/jamp.2019.711185.
  
    0.0 => float x;
    for (0 =>int index; index < n; index ++){
       Math.random2f( 0, 1 ) + x => x;
    }
    x/n => x;  // x is mean of n random generated numbers 0 - 1
    Math.sqrt(3 * n)* sigma * ((2 * x) -1) + mean => x;
    <<<x>>>;
    return x;
}

//---------------------- thread  functions --------------//

function void track1 (Event start){

    "../audio/" => string samplepath;
    ["clap_01.wav"] @=> string samplefiles[];
    samplefiles << "click_01.wav";
    samplefiles << "click_02.wav";
    samplefiles << "cowbell_01.wav";
    samplefiles << "hihat_01.wav";
    SndBuf buffers[samplefiles.cap()];

    0 => int buf;

    // the patch 
    Gain samples => master;
    0.8 => samples.gain;

    loadSamples (samplepath, samplefiles, buffers, samples);

    start => now;

    // play loop
    while( true )
    {
        Math.random2(0,4) => buf;
        0 => buffers[buf].pos;
        normRand(20, 0.05, 0.3) => buffers[buf].gain;
        normRand(20, 0.1, 1) => buffers[buf].rate;
        normRand(20, 100, 500)::ms => now;
    }

}