public class Sound extends Chubgraph
{
   //frequency modulation


// sound patch
 20 =>   float mfreq;
 1000 =>  float mfmax;
 0 =>   float mgain;
 10 =>  float mgmax;
 0.1 => float attack;
 0.2 => float amax;
 0.1 => float decay;
 0.1 => float dmax;
 0.5 => float sustain;
 1.0 => float smax;
 0.1 => float release;
 0.2 => float rmax;
 
   SinOsc modulator => SinOsc carrier => ADSR env => outlet;

   0.8 => carrier.gain;
   2   => carrier.sync;   
   mfreq => modulator.freq;  
   mgain => modulator.gain;

   env.set(attack :: second, decay :: second, sustain, release :: second);
   <<<env.state()>>>; // print env state 0 atack 1 decay 2 sustain 3 release 4 done

   function void noteOn(float vel ){env.keyOn(1); <<<env.state()>>>;}
   
   function void noteOff(float vel){ env.keyOff(1); <<<env.state()>>>;}
   
   function void setFreq(float Hz){Hz => carrier.freq;}
   
   //=========== custom functions =============================
  
   // edit to set effect of each slider 
   function void oscSlider(int sliderNo, float value){  // value 0 - 127
        if(sliderNo == 0){ mfmax * value/127   => modulator.freq; <<<"mfreq">>>;}
        if(sliderNo == 1){ mgmax * value/127   => modulator.gain;}
        if(sliderNo == 2){ amax * value/127    => attack; 
            env.attackTime(attack :: second); }
        if(sliderNo == 3){ dmax * value/127    => decay; 
            env.decayTime(decay :: second); }
        if(sliderNo == 4){ smax * value/127    => sustain; 
           env.sustainLevel(sustain); }
        if(sliderNo == 5){ rmax * value/127    => release; 
           env.releaseTime(release :: second); }                                      
} 
   
}