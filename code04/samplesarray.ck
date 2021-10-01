// play samples from array

SndBuf buffers[14];
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
