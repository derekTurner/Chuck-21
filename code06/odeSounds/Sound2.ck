public class Sound2 extends Chubgraph
{
   TriOsc s => outlet;
    0 => s.gain ;
   
   function void noteOn(float vel ){0.2 => s.gain;}
   
   function void noteOff(float vel){0.0 => s.gain;}
   
   function void setFreq(float Hz){Hz => s.freq;}
     
}