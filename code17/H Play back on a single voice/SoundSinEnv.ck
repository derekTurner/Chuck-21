public class Sound extends Chubgraph
{

// starting and max values for ADSR parameters
// These values may be edited as required
 0.8 => float attack;
 0.1 => float decay;
 0.5 => float sustain;
 0.05 => float release;
 

SinOsc s => ADSR env => outlet;
1 => s.gain;

env.set(attack :: second, decay :: second, sustain, release :: second);

   
   function void noteOn(float vel ){env.keyOn(1);}
   
   function void noteOff(float vel){ env.keyOff(1);}
   
   function void setFreq(float Hz){Hz => s.freq;}
   
   
}