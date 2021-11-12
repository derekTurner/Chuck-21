// Polyphonic MIDI output to test poly piano

MidiOut mout;  
MidiMsg msg;
0 => int midiChannel;           // choose midi channel
0 => int port;                 // choose port to suit your hardware

if( !mout.open(port) )
{
    <<< "Error: MIDI port did not open on port: ", port >>>;
    me.exit();
}


while( true )
{
    Math.random2(60,72) => int note;
    Math.random2(80,127) => int velocity;
    
    MIDInote(1, note, velocity, midiChannel); 
    0.3::second => now;
    MIDInote(1, note + 5, velocity, midiChannel); 
    0.3::second => now;
    MIDInote(1, note + 7, velocity, midiChannel); 
    0.3::second => now;
    MIDInote(1, note+ 12, velocity, midiChannel); 
    0.3::second => now;
    
    
    MIDInote(0, note ,velocity, midiChannel); 
    0.3::second => now;
    MIDInote(0, note + 5, velocity, midiChannel); 
    0.3::second => now;
    MIDInote(0, note + 7, velocity, midiChannel); 
    0.3::second => now;
    MIDInote(0, note+ 12, velocity, midiChannel); 
    0.3::second => now;
}

// ----------------- functions -----------------------//

function void MIDInote(int onoff, int note, int velocity, int midiChannel)
{                             
if (onoff == 0) (128 + midiChannel) => msg.data1;  
else (144 + midiChannel) => msg.data1;    
note => msg.data2;
velocity => msg.data3;
mout.send(msg);
<<< "sent: ", msg.data1, msg.data2, msg.data3 >>>;
}
