public class Sound extends Chubgraph
{
   0.3 => float weight1;
   0.3 => float weight2;
   0.3 => float weight3;


   SqrOsc osc1 => Gain g => outlet;
   SawOsc osc2 => g;
   TriOsc osc3 => g;

   weight1 => osc1.gain;
   weight2 => osc2.gain;
   weight1 => osc3.gain;
   0 => g.gain;
   
   function void noteOn(float vel ){
      0.2 => g.gain;
   }
   
   function void noteOff(float vel){
      0.0 => g.gain;
   }
   
   function void setFreq(float Hz){
      Hz => osc1.freq;
      Hz => osc2.freq;
      Hz => osc3.freq;
   } 
}
