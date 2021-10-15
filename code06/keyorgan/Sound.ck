public class Sound extends Chubgraph
{
   SinOsc osc1 => Envelope env => Gain g => dac;
   SinOsc osc2 => env;
   SinOsc osc3 => env;
   env.keyOff();
   0.3 => g.gain;
   
   function void noteOn(float vel ){
      env.time(Math.random2f(0.01, 0.5));
      env.keyOn();
   }
   
   function void noteOff(float vel){env.keyOff();}
   
   function void setFreq(float Hz){
      Hz => osc1.freq;
      Hz * 2 => osc2.freq;
      Hz * 3 => osc3.freq;
   } 
}
// see floss manual additive synthesis pg 32


