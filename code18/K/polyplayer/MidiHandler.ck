public class MidiHandler 
{ // modified 11/12/2020 Midi events are not handled quicker than before to prevent note off messages from being missed

    MidiIn midin;   
    Event noteOn;  
    Event noteOff;  
    Event pad;   
    Event controller;
    MidiMsg msg;
    int cmd;
    int chan;
    PolyVoices @ midipv;
    SamplePlayer @ midisp;

    [40,41,42,43,36,37,38,39,48,49,50,51,44,45,46,47 ] @=> int pads[];// midi notes from novation pads
    [41,42,43,44,45,46,47,48,49] @=> int sliders[];
    [21,22,23,24,25,26,27,28]    @=> int dials[];    
    
    function void MidiGo(int myPort, PolyVoices watchPV, SamplePlayer watchSP ){  
        if( !midin.open(myPort) )  
        {
            <<< "Error: MIDI port did not open on port: ", myPort >>>;
            me.exit();
        }else{
            <<< "Opened: MIDI port: ", myPort , " name: ", midin.name() >>>;   
            watchPV @=> midipv;
            watchSP @=> midisp;
            spork ~ handleNoteOn(noteOn);
            spork ~ handleNoteOff(noteOff);
            spork ~ handlePad(pad);
            spork ~ handleController(controller);

            second => now;

            while(true){ 
                midin => now;
                while( midin.recv(msg) ){   
                    ((msg.data1 & 0x70)>>4) => cmd;// upper nible     
                    (msg.data1 & 0x0f) => chan;// lower nibble
                        
                    if (cmd == 0)                   {noteOff.broadcast(); me.yield();continue;}
                    if (cmd == 1)                   {noteOn.broadcast(); me.yield();continue;}
                    if ((chan == 9) && (cmd == 1))  {pad.broadcast(); me.yield();continue;}
                    if (cmd == 3) {controller.broadcast(); me.yield();}
                }
            }
        }
    }
    // ----------------- handle midi events -----------------------//
    function void handleNoteOn(Event noteOn){   
        while( true )
        {   
            noteOn => now;
            <<< "channel 0 note on: ", msg.data1, msg.data2, msg.data3 >>>;          
            midipv.noteOn(msg.data2, msg.data3);
        }       
    }

    function void handleNoteOff(Event noteOff){   
        while( true )
        {   
            noteOff => now;
            <<< "channel 0 noteOff: ", msg.data1, msg.data2, msg.data3 >>>;
            midipv.noteOff(msg.data2); 
        }       
    }

    function void handlePad(Event pad){   
        while( true )
        {   
            pad => now;    
            <<< "channel 9 note: ", msg.data1, msg.data2, msg.data3 >>>;
            if( cmd == 1 ){//note on
                for(0 => int i; i<pads.cap(); i++){
                    if (msg.data2 == pads[i]){
                        midisp.play(i, msg.data3); 
                        break;
                    }    
                }    
            }          
        }       
    }

    function void handleController(Event controller){
        false => int sliderFound;
         while( true )
        {   
            controller => now;
            <<< "controller: ", msg.data1, msg.data2, msg.data3 >>>;
            for(0 => int i; i<sliders.cap(); i++){// check dials and affect poly player
                if (msg.data2 == sliders[i]){
                    midipv.setControl(i, msg.data3); 
                    true => sliderFound;
                    break;
                }    
            }
            
            if(! sliderFound){
                for(0 => int i; i<dials.cap(); i++){// check dials and affect sample player
                    if (msg.data2 == dials[i]){
                        midisp.soundControl(i, msg.data3); 
                        true => sliderFound;
                        break;
                    } 
                }   
            }
            false => sliderFound;
            
        } 
    }  
}