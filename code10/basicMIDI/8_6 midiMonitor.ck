//midiMonitor.ck
// print details of midi note and control messages
// recieved using two threads
// cc 64 switches between Piano and mandolin voices


MidiIn midin;   // midi input event;
Event note;   // note shred trigger event
Event controller;// control shred trigger event
MidiMsg msg;

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
[organ, mand] => StkInstrument stk[];

//main loop
spork ~ handleNote(note);
spork ~ handleController(controller);
second => now;


while(true){ 
    <<<"main loop">>>;
    midin => now;
    while( midin.recv(msg) ){   
         <<< "recv: ", msg.data1, msg.data2, msg.data3 >>>;    
        if (((msg.data1 & 0xf0) == 0x90)||((msg.data1 & 0xf0) == 0x80)){note.broadcast();}
        if ((msg.data1 & 0xf0) == 0xB0) {controller.broadcast();}
    }
}

//---------------------- voice playing functions --------------//

function void handleNote(Event note){
    
    while( true )
    {
        note => now;
        <<< "note: ", msg.data1, msg.data2, msg.data3 >>>;
    }       
}

function void handleController(Event controller){
    
     while( true )
    {
        controller => now;
        <<< "controller: ", msg.data1, msg.data2, msg.data3 >>>;
    } 
}



