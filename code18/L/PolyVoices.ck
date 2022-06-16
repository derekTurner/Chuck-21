// needs public class Sound

public class PolyVoices extends Chubgraph
{
    // Dont edit anything in this class
      
// class variables 
    Sound voices[12];
    [0,0,0,0,0,0,0,0,0,0,0,0] @=> int buffer[];
    buffer.cap() => int voiceSize;
     0 => int bufferIn => int bufferOut;
    0 => int index;
    voices[0].controls.cap() => int maxControl; 
    voices.cap() =>   int poly;
    int voiceSelect;
       
    //setup sounds
    Gain mix  => outlet;
    // prevent clipping
    for (0 => int i; i<voices.cap(); i++){
        0.8 => voices[i].gain;
        voices[i] => mix;
    }
    0.4 => mix.gain; 
    
 
        
//  ---------------   methods for poly sound ------------------//

    function void setControl(int option, float value){
        for( 0 => int i; i < poly ; i++){
            if (option<maxControl){
                voices[i].soundControl(option, value);
                <<<"Sound ",voices[0].controls[option],": ", value >>>;
            }    
        }
         
    }
    
    
    function void noteOn(int note, int vel){
        note => buffer[bufferIn];
        Std.mtof( note ) => voices[bufferIn].setFreq;
        voices[bufferIn].noteOn((vel)/127.0); 
        (bufferIn + 1) % buffer.cap() => bufferIn;  
        <<< buffer[0], buffer[1],buffer[2],buffer[3],buffer[4],buffer[5], 
        buffer[6], buffer[7],buffer[8],buffer[9],buffer[10],buffer[11]>>>;
    }

    function void noteOff(int note){
        indexOf(note, buffer, 0) => index;
        if (index >= 0){
            0 => voices[index].noteOff; 
            0 => buffer[index]; 
        }
    }    


    function int indexOf(int value, int buff[],int start){ //look for value in circular buffer 
        -1 => int result;
        start => int count;
        buff.cap() => int size;
    
        do{
            if(buff[count] == value){ 
                count => result;
                break;    
            }
            (count + 1) % size => count; 
        }until (count == start);
    
    return result;
    }
}// end of class polyvoice
