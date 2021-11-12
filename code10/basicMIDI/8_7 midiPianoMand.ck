// midiPianoMand.ck
// process midi note and control messages
// recieved using two threads
// cc 64 toggles piano and mandolin


MidiIn midin;   // midi input event;
Event note;   // note shred trigger event
Event controller;// control shred trigger event
MidiMsg msg;
int cmd;
int chan;

0 => int port;
if( !midin.open(port) )  
{
    <<< "Error: MIDI port did not open on port: ", port >>>;
    me.exit();
}else{
    <<< "Opened: MIDI port: ", port , " name: ", midin.name() >>>;
}

BeeThree organ => JCRev r => dac;
Mandolin mand => r;
int voiceSelect;


//main loop
spork ~ handleNote(note);
spork ~ handleController(controller);
second => now;


while(true){ 
    <<<"main loop">>>;
    midin => now;
    while( midin.recv(msg) ){   
        // <<< "recv: ", msg.data1, msg.data2, msg.data3 >>>; 
        ((msg.data1 & 0x70)>>7) => cmd;// upper nible
        (msg.data1 & 0x0f) => chan;
            
        if ((cmd == 0)||(cmd == 1)){note.broadcast();}
        if (cmd == 3) {controller.broadcast();}
    }
}

//---------------------- voice playing functions --------------//

function void handleNote(Event note){
    
    while( true )
    {
        note => now;
        <<< "note: ", msg.data1, msg.data2, msg.data3 >>>;
        if( cmd == 0 ){//note on
            if (voiceSelect == 0){
                Std.mtof( msg.data2 ) => organ.freq;
                organ.noteOn(msg.data3);   
            }else{
                Std.mtof( msg.data2 ) => mand.freq;
                mand.noteOn(msg.data3); 
            }           
        } else {//note off
            if (voiceSelect == 0){
                0 => organ.noteOff;
            }else{
                0 => mand.noteOff;
            }     
        }  
    }       
}

function void handleController(Event controller){
    
     while( true )
    {
        controller => now;
        <<< "controller: ", msg.data1, msg.data2, msg.data3 >>>;
        if (msg.data2 == 64){
            if (msg.data3 == 0){0 => voiceSelect;}else{1 => voiceSelect;}
        }
    } 
}



