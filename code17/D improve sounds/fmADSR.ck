public class Sound extends Chubgraph
{

   0.1 => float attack; // time in seconds
   0.1 => float decay;  // time in seconds
   0.5 => float sustain;// level 0-1
   0.1 => float release;// time in seconds

   1.0 =>  float modfreq;
   20.0 =>  float modgain;

   SinOsc modulator => SinOsc carrier => ADSR env => outlet;

   0.8 => carrier.gain;
   2   => carrier.sync;  // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth     
   modfreq => modulator.freq;  
   modgain => modulator.gain;

    env.set(attack :: second, decay :: second, sustain, release :: second);
 

   function void noteOn(float vel ){  
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
   
}