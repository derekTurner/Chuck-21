public class OscHandler 
{
    Event oscNote;   
    Event oscController;
    int gui[3]; // will store value, controller and channel from gui 
    OscIn oin;
    OscMsg msg;
    int OscPort;
    int cmd;
    int chan;
    PolyVoices @ pvosc;
    SamplePlayer  @ sposc;
    [40,41,42,43,36,37,38,39,48,49,50,51,44,45,46,47 ] @=> int pads[];// midi notes from novation pads
    [41,42,43,44,45,46,47,48,49] @=> int sliders[];// midi continuous controllers
    [21,22,23,24,25,26,27,28]    @=> int dials[];  // midi continuous controllers  
    

    function void OscGo(int myPort, PolyVoices watchPV, SamplePlayer watchSP ){ 
        
        myPort => OscPort;
        watchPV @=>   pvosc;
        watchSP @=>   sposc;  

        OscPort => oin.port;
        oin.listenAll();
        
        spork ~ handleOscNote(oscNote);
        spork ~ handleOscController(oscController); 
        0.1 * second => now;

        while(true){ 
            oin => now;
            while(oin.recv(msg)){  
                <<<msg.address, "args: ",msg.numArgs(), dials[0]>>>; 
            for(int n; n < msg.numArgs(); n++)
            {
                <<<n, msg.typetag , msg.typetag.charAt(n), Std.abs(msg.getInt(n)),msg.getInt(n)>>>;
                if(msg.typetag.charAt(n) == 105 ){ // 105 ascii character 'i'
                    Std.abs(msg.getInt(n)) => gui[n];
                } 
                <<< "gui: ", gui[0]," ",gui[1]," ",gui[2]," ">>>;
                
            }    
              
                if(msg.address == "/note"){oscNote.signal();}       
                if(msg.address == "/cc"){oscController.signal();}
           
            }
        }
        
        
    }
    // ----------------- handle osc events -----------------------//
    function void handleOscNote(Event oscNote ){
        while( true )
        {   
            // msg format: cmd|chan note velocity 
            oscNote => now;
            ((gui[0] & 0x70)>>4) => cmd;// upper nible     
            (gui[0] & 0x0f)      => chan;// lower nibble
            
            if (chan == 0){ // novation keyboard
                <<< "channel 0 note: ", gui[0], gui[1], gui[2] >>>;
                if( cmd == 1 ){//note on
                    pvosc.noteOn(gui[1], gui[2]);
                } else {//note off
                    pvosc.noteOff(gui[1]);
                                   
                } 
            } 
            if (chan == 9){  // pad input channel
                <<< "channel 9 note: ", gui[0], gui[1], gui[2] >>>;
                if( cmd == 1 ){//note on
                    for(0 => int i; i<pads.cap(); i++){
                        if (gui[1] == pads[i]){
                            sposc.play(i, gui[2]); 
                            break;
                        }    
                    }    
                }
            }
        }       
    }

    function void handleOscController(Event oscController){
   
        
        false => int sliderFound;
         while( true )
        {   
            // message format value, ccnum, channel
            oscController => now;
            <<< "controller: ", gui[0], gui[1], gui[2] >>>;
            for(0 => int i; i<sliders.cap(); i++){// check dials and affect poly player
                if (gui[1] == sliders[i]){
                    pvosc.setControl(i, gui[0]); 
                    true => sliderFound;
                    break;
                }    
            }
            
            if(! sliderFound){
                for(0 => int i; i<dials.cap(); i++){// check dials and affect sample player
                    if (gui[1] == dials[i]){
                        sposc.soundControl(i, gui[0]); 
                        true => sliderFound;
                        break;
                    } 
                }   
            }
            false => sliderFound;
            
        } 
    }  
}

