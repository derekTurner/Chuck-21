public class SamplePlayer extends Chubgraph
{  // samplePlayer 2 load tabla samples add FX

 
    // setup and play 16 samples with control from controllers 21 - 28
    // https://www.mpcindia.co/free-indian-percussive-samples/
    ["Tabla 01","Tabla 02","Tabla 03","Tabla 04","Tabla 05","Tabla 06",
     "Tabla 07","Tabla 08","Tabla 09","Tabla 10","Tabla 11","Tabla 12",
     "Tabla 13","Tabla 14","Tabla 15","Tabla 16"] @=>string fileNames [];

    Gain percGain => ResonZ zed => outlet;  // add one FX
    0.8 => percGain.gain;

    1000 => float zedfreq;
    1    => float zedq;
    // max and min
    2000 => float zedfreqmax;
    200  => float zedfreqmin;
    18   => float zedqmax;
    0.5  => float zedqmin;

    zedfreq => zed.freq;
    zedq => zedq;

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
    ["reson freq","reson Q","rate"] @=> string controls[];    
    
    // define control functions specific to instrument
    function void soundControl(int index, float value){      // value 0 - 127
        if(index == 0){zedfreqmin + ((value/127)*(zedfreqmax - zedfreqmin)) => zed.freq;};
        if(index == 1){zedqmin + ((value/127)*(zedqmax - zedqmin)) => zed.Q;};
        if(index == 2){(2*value/127.0)-1  => buffers[2].rate;};// -1 - +1
        if(index == 3){(2*value/127.0)-1  => buffers[3].rate;};// -1 - +1       
        if(index == 4){(2*value/127.0)-1  => buffers[4].rate;};// -1 - +1
        if(index == 5){(2*value/127.0)-1  => buffers[5].rate;};// -1 - +1
        if(index == 6){(2*value/127.0)-1  => buffers[6].rate;};// -1 - +1
        if(index == 7){(2*value/127.0)-1  => buffers[7].rate;};// -1 - +1
        if(index == 8){(2*value/127.0)-1  => buffers[8].rate;};// -1 - +1    
        if(index == 9){(2*value/127.0)-1  => buffers[9].rate;};// -1 - +1
        if(index == 10){(2*value/127.0)-1 => buffers[10].rate;};// -1 - +1
        if(index == 11){(2*value/127.0)-1 => buffers[11].rate;};// -1 - +1
        if(index == 12){(2*value/127.0)-1 => buffers[12].rate;};// -1 - +1
        if(index == 13){(2*value/127.0)-1 => buffers[13].rate;};// -1 - +1   
        if(index == 14){(2*value/127.0)-1 => buffers[14].rate;};// -1 - +1
        if(index == 15){(2*value/127.0)-1 => buffers[15].rate;};// -1 - +1
    }
}