public class Sound extends Chubgraph
{
   SinOsc s => outlet;
    0 => s.gain ;
   
   function void noteOn(float vel ){0.2 => s.gain;}
   
   function void noteOff(float vel){0.0 => s.gain;}
   
   function void setFreq(float Hz){Hz => s.freq;}
   
   /*
    for subsequent development


   // name controllable elements of sound
   ["control1","control2","control3","control4","control5","control6"] @=> string controls[];    
     
   // define control functions specific to instrument
   function void soundControl(int index, float value){  // value 0 - 127
       if(index == 0){value/127 =>  s.control1;};   // Hz
       if(index == 1){value/127 =>  s.control2;};   // 0 - 1
       if(index == 2){value/127 =>  s.control3;};   // 0 - 1
       if(index == 3){value/127 =>  s.control4;};   // 0 - 1
       if(index == 4){value/127 =>  s.control5;};   // 0 - 1
       if(index == 5){value/127 =>  s.control6;};   // 0 - 1
    }
    */
   
   
}