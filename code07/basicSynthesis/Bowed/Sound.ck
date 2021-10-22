public class Sound extends Chubgraph
{
   //Adding slider control to Listing 6.5 Simple violin using SawOsc, Envelope, and SinOsc for vibrato
   // starting values for ADSR parameters

// sound patch
 0 =>   float bpressure;
 1 =>   float bpressuremax;
 0 =>   float bposition;
 1 =>   float bpositionmax;
 0 =>   float bvibratoFreq;
 12=>   float bvibratoFreqmax;
 0 =>   float bvibratoGain;
 1 =>   float bvibratoGainmax;


 0.1 => float attack;
 0.2 => float amax;
 0.1 => float decay;
 0.1 => float dmax;
 0.5 => float sustain;
 1.0 => float smax;
 0.1 => float release;
 0.2 => float rmax;
 
 Bowed bow => ADSR env => outlet;

 0 => bow.bowPressure;
 0 => bow.bowPosition;
 0 => bow.vibratoFreq;
 0 => bow.vibratoGain;
 440 => bow.freq;
 0.8 => bow.volume;

   env.set(attack :: second, decay :: second, sustain, release :: second);
   <<<env.state()>>>; // print env state 0 atack 1 decay 2 sustain 3 release 4 done

   function void noteOn(float vel ){0.8 => bow.noteOn; env.keyOn(1); ;}
   
   function void noteOff(float vel){ 0 => bow.noteOff; env.keyOff(1); ;}
   
   function void setFreq(float Hz){Hz => bow.freq;}
   
   //=========== custom functions =============================
  
   // edit to set effect of each slider 
   function void oscSlider(int sliderNo, float value){  // value 0 - 127
        if(sliderNo == 0){ bpressuremax * value/127   => bow.bowPressure; ;}
        if(sliderNo == 1){ bpositionmax * value/127   => bow.bowPosition;}
        if(sliderNo == 2){ bvibratoFreqmax * value/127 => bow.vibratoFreq;}
        if(sliderNo == 3){ bvibratoGainmax * value/127   => bow.vibratoGain;}
        if(sliderNo == 4){ amax * value/127    => attack; 
            env.attackTime(attack :: second); }
        if(sliderNo == 5){ dmax * value/127    => decay; 
            env.decayTime(decay :: second); }
        if(sliderNo == 5){ smax * value/127    => sustain; 
           env.sustainLevel(sustain); }
        if(sliderNo == 7){ rmax * value/127    => release; 
           env.releaseTime(release :: second); }                                      
} 
   
}