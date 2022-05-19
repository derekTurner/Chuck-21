public class Sound extends Chubgraph
{
   1.00 => float a1;  
   0.50 => float a2;
   0.30 => float a3;
   0.25 => float a4;
   0.20 => float a5;
   0.17 => float a6;
   0.14 => float a7;
   0.12 => float a8;
   0.10 => float a9;



   SinOsc osc1 => Gain g => Envelope env => outlet;
   SinOsc osc2 => g;
   SinOsc osc3 => g;
   SinOsc osc4 => g;
   SinOsc osc5 => g;
   SinOsc osc6 => g;
   SinOsc osc7 => g;
   SinOsc osc8 => g;
   SinOsc osc9 => g;

   a1 => osc1.gain;
   a2 => osc2.gain;
   a3 => osc3.gain;
   a4 => osc4.gain;
   a5 => osc5.gain;
   a6 => osc6.gain;
   a7 => osc7.gain;
   a8 => osc8.gain;
   a9 => osc9.gain;
      
   env.keyOff();
   0.3 => g.gain;

   0.4 => float volumeScale;
   
   function void noteOn(float vel ){
      vel * volumeScale => g.gain;
      env.time(Math.random2f(0.01, 0.05));
      env.keyOn();
      
   }
   
   function void noteOff(float vel){
      env.time(0.005);
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz     => osc1.freq;
      Hz * 2 => osc2.freq;
      Hz * 3 => osc3.freq;
      Hz * 4 => osc4.freq;
      Hz * 5 => osc5.freq;
      Hz * 6 => osc6.freq;
      Hz * 7 => osc7.freq;
      Hz * 8 => osc8.freq;
      Hz * 9 => osc9.freq;
   } 
}



