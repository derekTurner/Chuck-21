public class Sound extends Chubgraph
{
   Phasor drive => Gen9 g9 => Envelope env => outlet;

   [1.0, 1.00, 0.0,   
   2.0, 0.50, 0.0,   
   3.0, 0.20, 0.0,
   4.0, 0.25, 0.0,   
   5.0, 0.20, 0.0,   
   6.0, 0.17, 0.0,
   7.0, 0.14, 0.0,   
   8.0, 0.12, 0.0,   
   9.0, 0.10, 0.0
   ] => g9.coefs;

   env.keyOff(); 
   0.3 => g9.gain;

   function void noteOn(float vel ){
      
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }

   function void setFreq(float Hz){Hz => drive.freq;}
 
}