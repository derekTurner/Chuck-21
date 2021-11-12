public class Sound extends Chubgraph
{
   // play with FM 
   Phasor noteFreq => Gen9 piano =>  Gain velocity => ADSR env => LPF lp => outlet; 
   110 => noteFreq.freq;
   1000 => lp.freq;
   1 => lp.Q;

[1.0, 1.0, 0.0,   2, 0.5, 90.0,   3., 0.2, 180.0] => piano.coefs;
[a1, 1.0, 0.0,   a2, 0.5, 90.0,   a3, 0.2, 180.0] => piano.coefs;
// [1., 1., 0.] => piano.coefs; // a simple one

// make it quiet
0.8 => piano.gain;

   //piano.sync(0); // normal frequency goes into sin osc
   //piano.sync(1);// phase to input or read waveform table 
   //piano.sync(2); //set piano.freq  100 going in is an offset




   function void noteOn(float vel ){vel => velocity.gain; 1 => env.keyOn;}// vel = 0 - 1
   
   function void noteOff(float vel){1 => env.keyOff;}
   
   function void setFreq(float Hz){Hz => noteFreq.freq;}
   
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