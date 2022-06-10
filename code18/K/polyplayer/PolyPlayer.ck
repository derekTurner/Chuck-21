// midiPolyClassSoundTemplate.ck
// process midi note and control messages
// recieved using two threads
// 12 voice polyphony using rhodey UGen
// Starter file for CW2

//list Dependant files first
//Sound.ck
//SamplePlayer.ck
//PolyVoices.ck
//MidiHandler.ck
//OscHandler.ck

// chuck Sound.ck SamplePlayer.ck PolyVoices.ck MidiHandler.ck OscHandler.ck PolyPlayer.ck



//----------------- main code ------------------//

MidiIn midin;   
Event note;   
Event controller;
MidiMsg msg;
int cmd;
int chan;
0 => int port;  // edit this to your iac, keyboard or loopBE port number
9999 => int oscLocalPort;


PolyVoices pv => dac;
SamplePlayer sp => dac;
MidiHandler mh;
spork ~ mh.MidiGo(port,pv,sp);

OscHandler osc;
spork ~ osc.OscGo(oscLocalPort,pv,sp);

<<< "hello" >>>;
while(true){second => now;}//loop doing nothing till close

