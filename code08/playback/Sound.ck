public class Sound extends Chubgraph
{

// starting and max values for ADSR parameters
// These values may be edited as required
 0.9 => float attack;
 0.1 => float decay;
 0.5 => float sustain;
 0.1 => float release;
 

SinOsc s => ADSR env => outlet;
1 => s.gain;

env.set(attack :: second, decay :: second, sustain, release :: second);
<<<"envelope state", env.state()>>>; // print env state 0 atack 1 decay 2 sustain 3 release 4 done

   
   function void noteOn(float vel ){env.keyOn(1); <<<"envelope state", env.state()>>>;}
   
   function void noteOff(float vel){ env.keyOff(1); <<<"envelope state", env.state()>>>;}
   
   function void setFreq(float Hz){Hz => s.freq;}
   
   
}