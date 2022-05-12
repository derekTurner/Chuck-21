public class Sample extends Chubgraph
{
    // select sample file from this list or your own sample
 
    // "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
    // "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
    // "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"

    "snare_01" => string fileName;
    SndBuf buffer;
    int    sampleLength;
    0.001 => float sampleAttack;
    0.01 =>  float sampleRelease;
    0 =>     int playing;

    me.sourceDir() + "/audio/" + fileName + ".wav" => buffer.read; 
    buffer.rate(1);                         // normal playback
    buffer.samples() => sampleLength;      // store for convenience
    buffer.pos(sampleLength-1);            // move buffer position to end of sample

    Gain percGain => Envelope env => outlet;
    buffer => percGain;
    0.8 => percGain.gain;

    function void noteOn(float vel ){
        if (playing){
               env.time(sampleRelease);
               env.keyOff();
               sampleRelease :: second => now;
        }
        env.time(sampleAttack);
        env.keyOn(); 
        vel => buffer.gain;
        0 => buffer.pos;  
        1 => playing;
   }
   
   function void noteOff(float vel){
        env.time(sampleRelease);
        env.keyOff();
        sampleRelease :: second => now;
        buffer.pos(sampleLength-1);  
        0 => playing;
   }
   
   function void setFreq(float rate){  
        buffer.rate(rate);

   } 
    
   
}    