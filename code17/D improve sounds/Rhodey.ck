public class Sound extends Chubgraph
{

   Rhodey voc  => outlet;

   0.8 => voc.gain;

   10 =>voc.lfoSpeed;
   0.5 => voc.lfoDepth;
 

   function void noteOn(float vel ){  
      1 => voc.noteOn;
   }

   function void noteOff(float vel){
      0 => voc.noteOff;
   }
   
   function void setFreq(float Hz){
      Hz => voc.freq;
   }
   
}