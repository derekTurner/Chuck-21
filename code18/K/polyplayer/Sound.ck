public class Sound extends Chubgraph
{
   Rhodey piano => JCRev reverb => outlet; 
   0.4 => reverb.mix;
   
   function void noteOn(float vel ){piano.noteOn(vel);}// vel = 0 - 1
   
   function void noteOff(float vel){piano.noteOff(vel);}
   
   function void setFreq(float Hz){Hz => piano.freq;}
   
   // name controllable elements of sound
   ["speed","lfoDepth","aftertouch","control1","control2","mix"] @=> string controls[];    
     
   // define control functions specific to instrument
   function void soundControl(int index, float value){  // value 0 - 127
       if(index == 0){value / 10 => piano.lfoSpeed;};   // Hz
       if(index == 1){value/127 =>  piano.lfoDepth;};   // 0 - 1
       if(index == 2){value/127 =>  piano.afterTouch;}; // 0 - 1
       if(index == 3){value/127 =>  piano.controlOne;}; // 0 - 1
       if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
       if(index == 5){value/127 =>  reverb.mix;};       // 0 - 1
       
   }
   
   
}