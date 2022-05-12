public class Sound extends Chubgraph
{
   0.3 => float weight1;
   0.3 => float weight2;
   0.3 => float weight3;
   0.05 => float envtime; // in seconds


   SqrOsc osc1 => Gain g => Envelope env => outlet;
   SawOsc osc2 => g;
   TriOsc osc3 => g;

   weight1 => osc1.gain;
   weight2 => osc2.gain;
   weight1 => osc3.gain;
   env.keyOff();
   
   env.time(envtime);
   0.3 => g.gain;
   
   
   function void noteOn(float vel ){
      env.keyOn();
   }
   
   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz => osc1.freq;
      Hz => osc2.freq;
      Hz => osc3.freq;
   } 
}
