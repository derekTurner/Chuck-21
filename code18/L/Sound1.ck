public class Sound extends Chubgraph
{
   // play with AM 
   SinOsc piano => Gain velocity => ADSR env => Gain AM => outlet; 
   SinOsc mod => Gain modamp => AM;

   AM.op(3);// multiply inputs 

    // min-max values for adsr  
    0.1 => float amin;
    0.2 => float amax;
    0.1 => float dmin;
    0.1 => float dmax;
    0.5 => float smin;
    1.0 => float smax;
    0.1 => float rmin;
    0.2 => float rmax;

    // min-max values for mamp
    0.0 => float modampgainmin;
    1.0 => float modampgainmax;

    // min-max values for mod frequency (small range gives tremulo,  large range gives AM)  
    0.0 => float modmin;
    5.0 => float modmax;

    // initial state
    env.set(amin :: second, dmin :: second, smin, rmin :: second);
    5.0 => mod.freq;
    400 => piano.freq;
    0.5 => modamp.gain;


   function void noteOn(float vel ){vel => velocity.gain; 1 => env.keyOn;}// vel = 0 - 1
   
   function void noteOff(float vel){1 => env.keyOff;}
   
   function void setFreq(float Hz){Hz => piano.freq;}
   
   // name controllable elements of sound
   ["speed","lfoDepth","aftertouch","control1","control2","mix"] @=> string controls[];    
     
   // define control functions specific to instrument
   function void soundControl(int index, float value){  // value 0 - 127
       if(index == 0){};//value / 10 => piano.lfoSpeed;};   // Hz
       if(index == 1){};//value/127 =>  piano.lfoDepth;};   // 0 - 1
       if(index == 2){};//value/127 =>  piano.afterTouch;}; // 0 - 1
       if(index == 3){};//value/127 =>  piano.controlOne;}; // 0 - 1
       if(index == 4){};//value/127 =>  piano.controlTwo;}; // 0 - 1
       if(index == 5){};//value/127 =>  reverb.mix;};       // 0 - 1
       
   }
   
   
}