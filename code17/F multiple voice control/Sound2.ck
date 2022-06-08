public class Sound2 extends Chubgraph
{

   // control ranges max - min
 
   0.2   =>   float amax;
   0.005 =>   float amin;
   
   0.8 =>     float dmax;
   0.01 =>    float dmin;
   
   1.0 =>     float smax;
   0.0 =>     float smin;

   0.8 =>     float rmax;
   0.05 =>    float rmin;


   // starting values
   0.1 =>   float attack;
   0.1 =>   float decay;
   0.5 =>   float sustain;
   0.1 =>   float release;
   

   SawOsc s => ADSR env => outlet;
   0.6 => s.gain;

   env.set(attack :: second, decay :: second, sustain, release :: second);

   function void noteOn(float vel ){env.keyOn(1);}
   
   function void noteOff(float vel){ env.keyOff(1);}
   
   function void setFreq(float Hz){Hz => s.freq;}
   
   //=========== custom functions =============================
  
   // edit to set effect of each slider 
   function void oscSlider(int sliderNo, int value){  // value 0 - 127
      if(sliderNo == 6){ amin  + ((amax  - amin ) * value/127 )  => attack; 
            env.attackTime(attack :: second); }      
      if(sliderNo == 7){ dmin  + ((dmax  - dmin ) * value/127 )  => decay; 
            env.decayTime(decay :: second); }
      if(sliderNo == 8){ smin  + ((smax  - smin ) * value/127 )  => sustain; 
           env.sustainLevel(sustain); }
      if(sliderNo == 9){ rmin  + ((rmax  - rmin ) * value/127 )  => release; 
           env.releaseTime(release :: second); }                                         
   } 
   
}