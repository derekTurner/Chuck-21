public class Sound extends Chubgraph
{
   //Adding slider control to Listing 6.5 Simple carrierin using SawOsc, Envelope, and SinOsc for modulator
   // starting values for ADSR parameters

   // sound patch
   20 =>   float tfreq;
   1000 =>  float tfmax;
   1 =>   float tgain;
   10 =>  float tgmax;
   0.1 => float attack;
   0.2 => float amax;
   0.1 => float decay;
   0.1 => float dmax;
   0.5 => float sustain;
   1.0 => float smax;
   0.1 => float release;
   0.2 => float rmax;
 
   SinOsc  carrier => Gain am => Gain master => ADSR env => outlet;
   SinOsc modulator => Gain amOffset => am;
   Step offset => amOffset;

   am.op(3);//3: normal operation, multiply all inputs.    
  
   0.1 => master.gain;
   0.8 => carrier.gain;
   0   => carrier.sync; // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth  
   tfreq => modulator.freq;  
   tgain => modulator.gain;

   env.set(attack :: second, decay :: second, sustain, release :: second);
   <<<env.state()>>>; // print env state 0 atack 1 decay 2 sustain 3 release 4 done

   function void noteOn(float vel ){env.keyOn(1); <<<env.state()>>>;}
   
   function void noteOff(float vel){ env.keyOff(1); <<<env.state()>>>;}
   
   function void setFreq(float Hz){Hz => carrier.freq;}
   
   //=========== custom functions =============================
  
   // edit to set effect of each slider 
   function void oscSlider(int sliderNo, float value){  // value 0 - 127
        if(sliderNo == 0){ tfmax * value/127   => modulator.freq; <<<"tfreq">>>;}
        if(sliderNo == 1){ tgmax * value/127   => modulator.gain;}
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