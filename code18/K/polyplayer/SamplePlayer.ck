public class SamplePlayer extends Chubgraph
{

 
    // setup and play 16 samples with control from controllers 21 - 28
 
    ["clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
     "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
     "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"] @=>string fileNames [];

    Gain percGain => outlet;
    0.8 => percGain.gain;

    SndBuf buffers[16];
    int    sampleLengths[16];

    for (0 => int i; i< fileNames.cap(); i ++){
         me.sourceDir() + "/audio/" + fileNames[i] + ".wav" => buffers[i].read;   
         buffers[i].rate(1);
         buffers[i].samples() => sampleLengths[i];
         buffers[i].pos(sampleLengths[i]-1);
         0=>buffers[0].pos;
         buffers[i] => percGain;
    }
    
    function void playsound(int sampleNo , int vel){
        vel/127.0 => buffers[sampleNo].gain;
        0 => buffers[sampleNo].pos;
        <<<fileNames[sampleNo], sampleLengths[sampleNo],sampleNo, vel>>>;
        sampleLengths[sampleNo] :: samp => now;
    }
    
    function void play(int sampleNo , int vel){
         <<<"play: ",sampleNo, vel>>>;
        spork ~ playsound(sampleNo, vel);     
    }
    
    
    // name controllable elements of sound
    ["rate"] @=> string controls[];    
    
    // define control functions specific to instrument
    function void soundControl(int index, float value){      // value 0 - 127
        if(index == 0){(2*value/127.0)-1  => buffers[0].rate;};// -1 - +1
        if(index == 1){(2*value/127.0)-1  => buffers[1].rate;};// -1 - +1
        if(index == 2){(2*value/127.0)-1  => buffers[2].rate;};// -1 - +1
        if(index == 3){(2*value/127.0)-1  => buffers[3].rate;};// -1 - +1        if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
        if(index == 4){(2*value/127.0)-1  => buffers[4].rate;};// -1 - +1
        if(index == 5){(2*value/127.0)-1  => buffers[5].rate;};// -1 - +1
        if(index == 6){(2*value/127.0)-1  => buffers[6].rate;};// -1 - +1
        if(index == 7){(2*value/127.0)-1  => buffers[7].rate;};// -1 - +1
        if(index == 8){(2*value/127.0)-1  => buffers[8].rate;};// -1 - +1        if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
        if(index == 9){(2*value/127.0)-1  => buffers[9].rate;};// -1 - +1
        if(index == 10){(2*value/127.0)-1 => buffers[10].rate;};// -1 - +1
        if(index == 11){(2*value/127.0)-1 => buffers[11].rate;};// -1 - +1
        if(index == 12){(2*value/127.0)-1 => buffers[12].rate;};// -1 - +1
        if(index == 13){(2*value/127.0)-1 => buffers[13].rate;};// -1 - +1        if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
        if(index == 14){(2*value/127.0)-1 => buffers[14].rate;};// -1 - +1
        if(index == 15){(2*value/127.0)-1 => buffers[15].rate;};// -1 - +1
    }
}    