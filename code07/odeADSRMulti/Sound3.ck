public class Sound3 extends Chubgraph
{

   // starting and max values for ADSR parameters
   // These values may be edited as required
   0.9 => float attack;
   1.0 => float amax;
   0.1 => float decay;
   1.0 => float dmax;
   0.5 => float sustain;
   1.0 => float smax;
   0.1 => float release;
   3.0 => float rmax;
   

   SawOsc s => ADSR env => outlet;
   0.5 => s.gain;

   env.set(attack :: second, decay :: second, sustain, release :: second);
   <<<env.state()>>>; // print env state 0 atack 1 decay 2 sustain 3 release 4 done



   function void noteOn(float vel ){env.keyOn(1); <<<env.state()>>>;}
   
   function void noteOff(float vel){ env.keyOff(1); <<<env.state()>>>;}
   
   function void setFreq(float Hz){Hz => s.freq;}
   
   //=========== custom functions =============================
  
   // edit to set effect of each slider 
   function void oscSlider(int sliderNo, int value){  // value 0 - 127
        <<<"hello ", sliderNo, value>>>;
        if(sliderNo == 0){ 
           amax * value/127    => attack; 
           env.attackTime(attack :: second);
           <<<attack>>>; }
        if(sliderNo == 1){ 
           dmax * value/127    => decay; 
            env.decayTime(decay :: second);
            <<<decay>>>; }
        if(sliderNo == 2){ 
           smax * value/127    => sustain; 
           env.sustainLevel(sustain); }
        if(sliderNo == 3){ 
           rmax * value/127    => release; 
           env.releaseTime(release :: second); }                                      
   } 
   
}