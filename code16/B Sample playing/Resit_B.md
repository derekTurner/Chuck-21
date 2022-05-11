# Audio Programming B
## Making a sound using samples

 This section looks at using the keyboard programme to trigger samples.

 The keyboard can be used to play a sample.  

 The samples used at first are not tuned.  The alphanumeric keyboard will be used to play a single sample with different playback rates.

 If tuned samples were used the keyboard could be arranged to play different samples.  Using many samples will wait until we can use arrays.

 

### A single sample

A number of samples are provided in the Audio folder for practice, but you may download or create your own.

    audio folder
     "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
     "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
     "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"

### Keyboard programme

 The keyboard programme is called keysampleMap.ck it is not essential to follow the details of how this works.  What you really need to know is that:
 * to run the sound and keyboard together copy the command  **chuck Sample.ck keysampleMap.ck** into the Visual Studio Code Terminal
 * The keyboard programme expects the sample programme to have functions **noteOn(), noteOff() and setFreq()** it uses these to play notes.

The detail of the keyboard programme is very similar to the that used to play synthesised sound so here I will just pick out some of the differences.

```c
// Use keyboard Human interface device to play sound in separate file.
// Maps the keyboard keys asdf to notes cdef to match piano keyboard pattern
// chuck Sample.ck keysampleMap.ck

Hid hi;
HidMsg msg;
int semitone;
0.4 => float keyGain;

```
Rather  than use a midinote the samples will be played up and down in semitone steps from the samples recorded pitch.  A semitone variable is defined to manage this.

```c
/*
// PC keyboard map
[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 -1,-1,-1,-1,-1,-1,-1, 1, 3,-1,
  6, 8,10,-1,13,15,-1,-1,-1,-1,
  0, 2 ,4, 5, 7, 9,11,12,14,16,
 17,-1,-1,-1,-1,-1,-1,-1,-1,-1 
] @=> int map[];
*/

// MAC keyboard map
[-1,-1,-1,-1, 0,-1,-1, 4, 3, 5,
  7, 9,-1,11,12,14,-1, 1,13,15,
 -1,-1, 2, 6,10,-1, 1,-1, 8,-1,
 -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 -1,-1,-1,-1,-1,-1,-1,-1,18,-1,
 -1,16,17,-1,-1,-1,-1,-1,-1,-1
] @=> int map[];


// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;
```
The map[] array maps the PC keyboard to a piano keyboard pattern and the values other than -1 represent semitone shifts from the samples recorded pitch. 

| Keys |  | | ||  | | | |  | | | |  | | | |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |--- | --- | --- | --- | --- |
|  |w| |e|  ||t ||y ||u | ||o | | p  |  Black notes |
|a||s||d|f||g||h||j|k||l |   | White notes|

```c

// Use sound patch here with external class file
Sample snd => dac;
0.0 =>snd.noteOff;
```
The sample patch is defined in a Sample class in a separate file and connected to the sound card here.

```c
// infinite event loop till control key is pressed
while( (msg.which != 29) & (msg.which != 224))
{
    // wait for event
    hi => now;

    // get message
    while( hi.recv( msg ) )
    {
        // check
        if( msg.isButtonDown() )
        {
            <<<msg.which>>>;
            if(msg.which == 29) break;
            if (msg.which < map.cap())
            {
                map[msg.which] => semitone;
                if (semitone >= 0){
                    Math.pow ( 1.059463094359, semitone ) => snd.setFreq;
                    keyGain => snd.noteOn;
                }
            }
        }
        else
        {
            0.0 => snd.noteOff;
        }
    }
}

```
The keyboard activity is monitored in a while loop which continues until the ctrl key is pressed.

The keyboard data is collected in a human interface message object.  The key pressed is read from msg.which and mapped to the value of ofset in semitone.  The key "a" will produce the original sample rate and "w" will raise by 1 semitone.

The semitone shift is calculated using the standard formula for musical notes based on a multipier based on 1.059 raised to the power of n (where n is the semitone shift).

### Sample program

The file **Sample.ck** can be edited to play any single sample of your choice.

```c
public class Sample extends Chubgraph
{
    // select sample file from this list or your own sample
 
    // "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
    // "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
    // "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"
```
A selection of basic samples are provided in the audio folder and you may add your own samples to supplement or replace these.
```c    

    "stereo_fx_03" => string fileName;
    SndBuf buffer;
    int    sampleLength;
    0.001 => float sampleAttack;
    0.01 =>  float sampleRelease;
    0 =>     int playing;

```
The selected sample name is stored in the fileName string variable.

A sound buffer is declared which will hold the binary content of the sample.  For clarity a sampleLength variable is also added.

If the sample is interrupted abruptly when a key is raised, a click will result so an envelope will be used to cut off the end of a sample smoothly if the sample is still sounding when the key is raised.

The sampleAttack and sampleRelease variables are just used to store times to control this envelope.

Clicks could occur if one sample is called before the last has been stopped.  This could arise if a key was pressed before the previous was released.  For this reason integer variable playing is used to keep track when a sample is being played.

```c
    me.sourceDir() + "/audio/" + fileName + ".wav" => buffer.read; 
```
The location of the sound file is found relative to the location of the Sample.ck file.  It is important to organise your file structure and an incorrect file address is a common error.  Once located the file is then given to the buffer to read in.

The wave remains in the buffer whilever the programme is running.  The buffer is not used up when it is played!  It can be played over many times.

```c
    buffer.rate(1);                         // normal playback
    buffer.samples() => sampleLength;      // store for convenience
    buffer.pos(sampleLength-1);            // move buffer position to end of sample
```
The buffer rate is set to 1 which is the standard playback rate of the sample.

All the samples in the audio folder have different sample lengths and will play for different durations.  The end of the buffer is denoted by sampleLength -1.  Placing the buffer position at the end of the buffer will
stop the buffer content playing out.

```c
    Gain percGain => Envelope env => outlet;
    buffer => percGain;
    0.8 => percGain.gain;
```
The sound patch connects the buffer to a gain node percGain.  This would be a summing point if we wanted to play multiple samples.  This then goes to an envelope which is included just to prevent clicking between keyed sounds.

```c

    function void noteOn(float vel ){
        if (playing){
               env.time(sampleRelease);
               env.keyOff();
               sampleRelease :: second => now;
        }
        env.time(sampleAttack);
        env.keyOn(); 
        vel => buffer.gain;
        0 => buffer.pos;  
        1 => playing;
   }
```
The noteOn() function includes a parameter vel which should be in the range 0-1 to set the buffer gain.

If a note is playing form a previous key press which has not been released, the release envelope is invoked to prevent clicks.  The attack envelope is always applied and should have a small attack time.  The programme waits until the envelope has completed the release phase before continuing.

The buffer commences to play out when its position is set to zero.  The position will step through the buffer until it reaces the end position and then the sample playback will be complete.

```c   
   function void noteOff(float vel){
        env.time(sampleRelease);
        env.keyOff();
        sampleRelease :: second => now;
        buffer.pos(sampleLength-1);  
        0 => playing;
   }
```
When noteOff is called the release envelope is triggered and the programme waits till this is complete before moving the buffer position to the end of the buffer which halts sample playback.

The playing variable is set to 0 to denote that the sample is not playing.

```c   
   function void setFreq(float rate){  
        buffer.rate(rate);

   } 
    
}    
```

The pitch of the sample is controlled by speeding and reducing the playback rate.  This also increases the length of the sample.  (This reflects the way a sampler programme might work, but in that case the pitch of an individual sample would not normally by varied by more than 3 semitones).