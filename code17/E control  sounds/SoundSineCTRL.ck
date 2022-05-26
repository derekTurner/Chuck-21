public class Sound extends Chubgraph
{
   1 => float volumeMax;
   0 => float volumeMin;


   SinOsc s => Gain volume => outlet;
    0 => s.gain ;
    1 => volume.gain;
   
   function void noteOn(float vel ){0.2 => s.gain;}
   
   function void noteOff(float vel){0.0 => s.gain;}
   
   function void setFreq(float Hz){Hz => s.freq;}
   

 //=========== custom functions =============================
  
   // edit to set effect of each slider 
   function void oscSlider(int sliderNo, float value){  // value 0 - 127
        if(sliderNo == 0){ volumeMin + ((volumeMax - volumeMin) * value/127 )  => volume.gain;<<< value >>>;}   
   }                                  
} 