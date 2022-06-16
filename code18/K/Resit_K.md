# Polyphonic keyboard

Chuck code is provided to enable a 12 note polyphonic keyboard to be be played using either an external hardware keyboard controller or a software GUI standing in for the keyboard.

In this section the overview operation of the code is described.  You do not need to know the full detail of the code.

To make individual code sections easier to follow, the code is divided amongst several files.  These are run in chuck using the following command.

> chuck Sound.ck SamplePlayer.ck PolyVoices.ck MidiHandler.ck OscHandler.ck PolyPlayer.ck

## Polyplayer files

An overview of the files making up the polyplayer application.

### MidiHandler.ck

The **MidiHandler.ck** file contains a MidiHandler class which responds to incoming midi messages.

```c
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
 ```
Chuck has a number of built in classes to support MIDI.  MidiIn is used to connect to a MIDI device and MidiMsg is used to hold individual midi messages.

We have used events to start threads using ~sporked functions for playing tracks in individual timelines.  Events are defined here to enable a response to be fired on an input event from the midi device.

Integers cmd and chan are provided to hold details of midi commands and channels.

Polyvoices and SamplePlayer are in separate files.

The arrays for pads sliders and dials are the midi continuous controller values which map to the novation launchkey 48 keypoard controller.  

The funtion MidiGo will be called from the main polyplayer program.  This connects to the midi port and moniitors input.

 ```c   
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
```
The function tries to open the midi device using the value of myPort which is set in the main polyplayer.ck file.  If no midi device is found it prints an error warning, but the programme does not break, this allows the processing GUI keyboard to still be used. 

```c
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
 ```
In the while loop the programme waits until midi input triggers the midin event.

The first byte of midi data is interpreted to determine which midi command it represents and which midi channel it is coming in on.  These are saved to variables cmd and chan.

Commands 0 and 1 are noteOff and noteOn so the noteOn or noteOff events are triggered.  The line me.yield() allows the computer to give processing time priority to the other sporked strands so that the response latency is cut down.

When a noteOn command comes from midi channel 9 (or channel 10 in hardware labelling) this is caused for this keyboard by pressing one of the 16 pads.  The broadcast pad event will allow a response to play a sample.

If command = 3 this represents an continuous controllor from activating a slider, dial or button, so the controller event is broadcast.

 ```c   
    // ----------------- handle midi events -----------------------//
    function void handleNoteOn(Event noteOn){   
        while( true )
        {   
            noteOn => now;
            <<< "channel 0 note on: ", msg.data1, msg.data2, msg.data3 >>>;          
            midipv.noteOn(msg.data2, msg.data3);
        }       
    }
    
```
The handleNoteOn function sits waiting for a noteOn event.  When this is recieved a message is printed showing the three byte midi message.  The two data bytes of the midi message are passed to the noteOn function of the midi polyvoice (defined in a separate file).

```c

    function void handleNoteOff(Event noteOff){   
        while( true )
        {   
            noteOff => now;
            <<< "channel 0 noteOff: ", msg.data1, msg.data2, msg.data3 >>>;
            midipv.noteOff(msg.data2); 
        }       
    }
```
The note off handler operates in an equivalent way.  It only sends one databyte to the polyvoice noteOff function because the velocity is always zero for noteOff.

```c    

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
```

The pad handler prints the midi message confirming that data came in ion channel 9.  The incoming midi note is checked against each of the midi notes held in the pads array until a match is found.  This identifies which midi sample should be played.

```c


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
```
The controller handler checks first if the message coming in matches the continuous controller number of one of the sliders.   If so a message is sent to the polyvoice to control a sound parameter.

If no sliders are detected the function continues to check the continuous controller values corresponding to the dials.  If a match is found a control message is sent to the sample player to affect a sound parameter.

You should not change this file.

### Sound.ck

The file **Sound.ck** contains the sound patch and control functions.  You will customise this file with your own patch and control functions.

```c
public class Sound extends Chubgraph
{
   Rhodey piano => JCRev reverb => outlet; 
   0.4 => reverb.mix;
   
   function void noteOn(float vel ){piano.noteOn(vel);}// vel = 0 - 1
   
   function void noteOff(float vel){piano.noteOff(vel);}
   
   function void setFreq(float Hz){Hz => piano.freq;}
```
The file as provided uses an STK instrument going to the outlet via a reverb.  You can put your own patch here.  That will mean making sure that the noteOn, noteOff and setFreq functions are kept up to date to correctly trigger your sound patch.

The variable name piano is used elsewhere, regard this as a keyword and do not change it even if your patch sounds nothing like a piano.


```c   
   // name controllable elements of sound
   ["speed","lfoDepth","aftertouch","control1","control2","mix"] @=> string controls[];    
     
   // define control functions specific to instrument
   function void soundControl(int index, float value){  // value 0 - 127
       if(index == 0){value / 10 => piano.lfoSpeed;};   // Hz
       if(index == 1){value/127 =>  piano.lfoDepth;};   // 0 - 1
       if(index == 2){value/127 =>  piano.afterTouch;}; // 0 - 1
       if(index == 3){value/127 =>  piano.controlOne;}; // 0 - 1
       if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
       if(index == 5){value/127 =>  reverb.mix;};       // 0 - 1
       
   }

}
```
   The soundControl function responds to incoming slider values in what should now be a familiar way.  
   An array of strings can label the controls, the labels themselves don't matter, but there must be the same number of labels as the number of sliders you want to respond to.


### Sample Player

The samples which will be played when the keyboard pads are struck are determined in ***SamplePlayer.ck***

It should be a relatively easy step to replace the samples listed here with your own.

```c
public class SamplePlayer extends Chubgraph
{

 
    // setup and play 16 samples with control from controllers 21 - 28
 
    ["clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
     "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
     "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"] @=>string fileNames [];

    Gain percGain => outlet;
    0.8 => percGain.gain;

    SndBuf buffers[16];
    int    sampleLengths[16];

    for (0 => int i; i< fileNames.cap(); i ++){
         me.sourceDir() + "/audio/" + fileNames[i] + ".wav" => buffers[i].read;   
         buffers[i].rate(1);
         buffers[i].samples() => sampleLengths[i];
         buffers[i].pos(sampleLengths[i]-1);
         0=>buffers[0].pos;
         buffers[i] => percGain;
    }
```
The array of strings of filenames must be a perfect match to the wav files stored in the audio folder.
Simply changing the files and these names will change the samples available for playback.

As the buffers are loaded they are pointed to the Gain named percGate to compete the sound patch.  You could add other controllable element such as filter or pan between percGain and the outlet.

The sounds are stored into 16 buffers, one for each available pad, so make sure you have 16 filenames in your list.
Don't change any other code in this file.

```c    

    function void playsound(int sampleNo , int vel){
        vel/127.0 => buffers[sampleNo].gain;
        0 => buffers[sampleNo].pos;
        <<<fileNames[sampleNo], sampleLengths[sampleNo],sampleNo, vel>>>;
        sampleLengths[sampleNo] :: samp => now;
    }
    
    function void play(int sampleNo , int vel){
         <<<"play: ",sampleNo, vel>>>;
        spork ~ playsound(sampleNo, vel);     
    }
 ```
The function play will print the message to confirm which sample is requested and then run the playsound function in its own thread.

Spork has been used to start some threads which keep running while the program continues to run, but the playsound functin will close when the sound has played so the thread needs to be started each time.

The code for controlling the sample sounds is similar to that for the synthesised sounds.  In this demo only one controllable feature is listed.


 ```c   
    
    // name controllable elements of sound
    ["rate"] @=> string controls[];    
    
    // define control functions specific to instrument
    function void soundControl(int index, float value){      // value 0 - 127
        if(index == 0){(2*value/127.0)-1  => buffers[0].rate;};// -1 - +1
        if(index == 1){(2*value/127.0)-1  => buffers[1].rate;};// -1 - +1
        if(index == 2){(2*value/127.0)-1  => buffers[2].rate;};// -1 - +1
        if(index == 3){(2*value/127.0)-1  => buffers[3].rate;};// -1 - +1        if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
        if(index == 4){(2*value/127.0)-1  => buffers[4].rate;};// -1 - +1
        if(index == 5){(2*value/127.0)-1  => buffers[5].rate;};// -1 - +1
        if(index == 6){(2*value/127.0)-1  => buffers[6].rate;};// -1 - +1
        if(index == 7){(2*value/127.0)-1  => buffers[7].rate;};// -1 - +1
        if(index == 8){(2*value/127.0)-1  => buffers[8].rate;};// -1 - +1        if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
        if(index == 9){(2*value/127.0)-1  => buffers[9].rate;};// -1 - +1
        if(index == 10){(2*value/127.0)-1 => buffers[10].rate;};// -1 - +1
        if(index == 11){(2*value/127.0)-1 => buffers[11].rate;};// -1 - +1
        if(index == 12){(2*value/127.0)-1 => buffers[12].rate;};// -1 - +1
        if(index == 13){(2*value/127.0)-1 => buffers[13].rate;};// -1 - +1        if(index == 4){value/127 =>  piano.controlTwo;}; // 0 - 1
        if(index == 14){(2*value/127.0)-1 => buffers[14].rate;};// -1 - +1
        if(index == 15){(2*value/127.0)-1 => buffers[15].rate;};// -1 - +1
    }
}    
```

There are not really enough dials to control all the possible parameters for each buffer and subsequent sound patches so anything you do in this section of code will need to be a compromise between adding features and losing other controls.

### OscHandler

You do not need to know the details of **OscHandler.ck** the purpose of the file is to detect OSC commands coming from the processing keyboard gui and to treat these in an equivalent way to midi commands from the keyboard.

Do not edit this file.

```c
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

```
### Polyphonic voices

The file **PolyVoices.ck** enables a polyphonic keyboard.

You do not need to know the details of this file and should not edit it.

```c
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
    
```
The sound is read in from the Sound class and instances are loaded into an array.  12 voices are supplied here, but this number could be increased if required.

Each of the voices in the array is chucked into a gain named mix which then goes to the outlet.  

The mix.gain is kept low to avoid clipping.

```c 
        
//  ---------------   methods for poly sound ------------------//

    function void setControl(int option, float value){
        for( 0 => int i; i < poly ; i++){
            if (option<maxControl){
                voices[i].soundControl(option, value);
                <<<"Sound ",voices[0].controls[option],": ", value >>>;
            }    
        }
         
    }

```
The setcontrol function recieves control messages from the midi and osc handlers and applies these to every voice.

```c    
    function void noteOn(int note, int vel){
        note => buffer[bufferIn];
        Std.mtof( note ) => voices[bufferIn].setFreq;
        voices[bufferIn].noteOn((vel)/127.0); 
        (bufferIn + 1) % buffer.cap() => bufferIn;  
        <<< buffer[0], buffer[1],buffer[2],buffer[3],buffer[4],buffer[5], 
        buffer[6], buffer[7],buffer[8],buffer[9],buffer[10],buffer[11]>>>;
    }

```
When noteOn is called the frequency is set and the note sounded for the voice in the array indicated by the variable bufferIn.  Buffer in then increases to point to the next voice which wil pick up the next noteon.  When bufferIn exceeds the size of the buffer it is pointed back to the beginning and this kind of action defines a circular buffer.

```c    

    function void noteOff(int note){
        indexOf(note, buffer, 0) => index;
        if (index >= 0){
            0 => voices[index].noteOff; 
            0 => buffer[index]; 
        }
    }    

```c
When a noteOff function is called this may not apply to the most recent note played.  The indexOf function is called to see which voice last played the note with the midivalue which is to be turned off.  When the index is known the correct indexed note can be turned off.


```c

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

```

### polyplayer

The **polyplayer** file contains the frontend to operate the other classes.  Key information which the user may need to edit is gathered at the top of the file.

```c
// midiPolyClassSoundTemplate.ck
// process midi note and control messages
// recieved using two threads
// 12 voice polyphony using rhodey UGen
// Starter file for CW

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

```
The port represents the location of the midi device which is the hardware keyboard.  This number will depend on the configuration of your machine so if your keyboard is not detected you can edit this till it is.

A useful utility to see what the device numbers are on your machine is

> chuck --probe

```code
[chuck]: found 7 device(s) ...
[chuck]: ------( audio device: 1 )---------------
[chuck]: device name = "Apple Inc.: Built-in Microphone"
[chuck]: probe [success] ...
[chuck]: # output channels = 0
[chuck]: # input channels  = 2
[chuck]: # duplex Channels = 0
[chuck]: default output = NO
[chuck]: default input = YES
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   32000 Hz
[chuck]:   44100 Hz
[chuck]:   48000 Hz
[chuck]:   88200 Hz
[chuck]:   96000 Hz
[chuck]: 
[chuck]: ------( audio device: 2 )---------------
[chuck]: device name = "Apple Inc.: Built-in Output"
[chuck]: probe [success] ...
[chuck]: # output channels = 2
[chuck]: # input channels  = 0
[chuck]: # duplex Channels = 0
[chuck]: default output = NO
[chuck]: default input = NO
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   44100 Hz
[chuck]:   48000 Hz
[chuck]:   88200 Hz
[chuck]:   96000 Hz
[chuck]: 
[chuck]: ------( audio device: 3 )---------------
[chuck]: device name = "BEHRINGER: UMC202HD 192k"
[chuck]: probe [success] ...
[chuck]: # output channels = 2
[chuck]: # input channels  = 2
[chuck]: # duplex Channels = 2
[chuck]: default output = YES
[chuck]: default input = NO
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   44100 Hz
[chuck]:   48000 Hz
[chuck]:   88200 Hz
[chuck]:   96000 Hz
[chuck]:   176400 Hz
[chuck]:   192000 Hz
[chuck]: 
[chuck]: ------( audio device: 4 )---------------
[chuck]: device name = "C-Media Electronics Inc.: USB Audio Device"
[chuck]: probe [success] ...
[chuck]: # output channels = 2
[chuck]: # input channels  = 1
[chuck]: # duplex Channels = 1
[chuck]: default output = NO
[chuck]: default input = NO
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   44100 Hz
[chuck]:   48000 Hz
[chuck]: 
[chuck]: ------( audio device: 5 )---------------
[chuck]: device name = "Existential Audio Inc.: BlackHole 2ch"
[chuck]: probe [success] ...
[chuck]: # output channels = 2
[chuck]: # input channels  = 2
[chuck]: # duplex Channels = 2
[chuck]: default output = NO
[chuck]: default input = NO
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   44100 Hz
[chuck]:   48000 Hz
[chuck]:   88200 Hz
[chuck]:   96000 Hz
[chuck]:   176400 Hz
[chuck]:   192000 Hz
[chuck]: 
[chuck]: ------( audio device: 6 )---------------
[chuck]: device name = "Microsoft Corp.: Microsoft Teams Audio"
[chuck]: probe [success] ...
[chuck]: # output channels = 2
[chuck]: # input channels  = 2
[chuck]: # duplex Channels = 2
[chuck]: default output = NO
[chuck]: default input = NO
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   48000 Hz
[chuck]: 
[chuck]: ------( audio device: 7 )---------------
[chuck]: device name = "Splashtop Inc.: Splashtop Remote Sound"
[chuck]: probe [success] ...
[chuck]: # output channels = 2
[chuck]: # input channels  = 2
[chuck]: # duplex Channels = 2
[chuck]: default output = NO
[chuck]: default input = NO
[chuck]: natively supported data formats:
[chuck]:   32-bit float
[chuck]: supported sample rates:
[chuck]:   44100 Hz
[chuck]:   48000 Hz
[chuck]:   88200 Hz
[chuck]:   96000 Hz
[chuck]:   176400 Hz
[chuck]:   192000 Hz
[chuck]: 
[chuck]: 
[chuck]: ------( chuck -- 3 MIDI inputs )------
[chuck]:     [0] : "IAC Driver Bus 1"
[chuck]:     [1] : "Launchkey 49 Launchkey MIDI"
[chuck]:     [2] : "Launchkey 49 Launchkey InControl"
[chuck]: 
[chuck]: ------( chuck -- 3 MIDI outputs )-----
[chuck]:     [0] : "IAC Driver Bus 1"
[chuck]:     [1] : "Launchkey 49 Launchkey MIDI"
[chuck]:     [2] : "Launchkey 49 Launchkey InControl"
```
For the current machine I will need to change to port 1 to use the launchkey keyboard.

So now you can audition the code supplied in folder K inside code18.zip

> chuck Sound.ck SamplePlayer.ck PolyVoices.ck MidiHandler.ck OscHandler.ck PolyPlayer.ck
