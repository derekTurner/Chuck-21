public class Sound extends Chubgraph
{

   0.1 => float attack; // time in seconds
   0.1 => float decay;  // time in seconds
   0.5 => float sustain;// level 0-1
   0.1 => float release;// time in seconds

   0.8 => float attackMod; // time in seconds
   0.2 => float decayMod;  // time in seconds
   0.4 => float sustainMod;// level 0-1
   0.1 => float releaseMod;// time in seconds

   50 =>  float modfreq;
   20.0 =>  float modgain;

   SinOsc modulator => ADSR envMod => SinOsc carrier => ADSR env => outlet;

   0.8 => carrier.gain;
   2   => carrier.sync;  // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth     
   modfreq => modulator.freq;  
   modgain => modulator.gain;

    env.set(   attack    :: second, decay       :: second, sustain, release    :: second);
    envMod.set(attackMod :: second, decayMod :: second, sustainMod, releaseMod :: second);
 

   function void noteOn(float vel ){  
      env.keyOn();
      envMod.keyOn();

   }

   function void noteOff(float vel){
      env.keyOff();
      envMod.keyOff();   
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
   
}