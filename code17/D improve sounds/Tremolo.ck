public class Sound extends Chubgraph
{
   1 =>     float modfreq;
   0.5 =>   float modgain;
   1.0 =>   float modoffset;

   SinOsc  carrier => Gain am => Gain master => Envelope env => outlet;
   SinOsc modulator => Gain amOffset => am;
   Step offset => amOffset;

   am.op(3);//3: normal operation, multiply all inputs.    
  
   0.1 => master.gain;
   0.8 => carrier.gain;
   0   => carrier.sync; // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth  
   modfreq => modulator.freq;  
   modgain => modulator.gain;
   modoffset => offset.next;


   function void noteOn(float vel ){  
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
     
}