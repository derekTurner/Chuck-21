# Audio Programming Resit 
## A. Making a sound using synthesis

 This section looks at creating a sound that can be usefully used in a musical context.

 In order to be able to audition the sound in a convenient way it will be triggered by playing the alphanumentic keyboard like a piano keyboard.

 To keep focus on the sound, the keyboard handling will be placed in one file and the sound will be placed in another.

 ### Keyboard programme

 The keyboard programme is called keyorganMap.ck it is not essential to follow the details of how this works.  What you really need to know is that:
 * to run the sound and keyboard together copy the command  **chuck Sound.ck keyorganMap.ck** into the Visual Studio Code Terminal
 * The keyboard programme expects the sound programme to have functions **noteOn(), noteOff() and setFreq()** it uses these to play notes.

The detail of the keyboard programme is presented in sections.

```c
// Use keyboard Human interface device to play sound in separate file.
// Maps the keyboard keys asdf to notes cdef to match piano keyboard pattern
// chuck Sound.ck keyorganMap.ck
```
Comment lines are added to describe what the programme does and the prompt line to remind how to run the programme is the last comment.

```c

Hid hi;
HidMsg msg;
int midiNote;
0.4 => float keyGain;

```
Declare global variables which cam be accessed anywhere in the code.

The keyboard is a human interface device and chuck has built in objects Hid and HidMsg to handle this.

The midiNote integer variable will be used to contain the note requested to play.

The keygain could be used to control sound volume initially set to 0.4 but you could adjust this to suit.

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

```
An array maps the keyboard to midi values over a 17 semitone range.  Keys mapped to -1 do not sound.  The mapping listed here works with a PC, a different pattern would be needed for a mac keyboard.  Use the multiline comment /*    */ to comment out the array you are not using depending on machine type.
```c

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;
```
The devices connected to the computer are all numbered, there are not usually more than one keyboard and computational numbering always starts from zero so setting the value of the device variable to 0 should point to the coffect keyboard.

(Occasionally you may want to pass the device number in from the terminal command line using arguments but this is rare.  If there are no arguments passed in the first if statement is ignored otherwise the argument passed in overwrites the device value).

The ! is used to invert logic, true goes to false and false goes to true.  So if (!*test expression*) will run the controlled statement if the value of the test expression is false.  Thus the programme will exit if no keyboard has been found with the chosen device number.


The <<< >>> symbols are used to print to the terminal for debugging.  The keyboard has been found at this point and its' name is displayed.

```c
// Use sound patch here with external class file
Sound snd => dac;
0.0 =>snd.noteOff;
```
The sound is brought in from the external sound chuck file and linked to the soundcard.  

Sending a noteOff makes sure the programme starts silently.

```c

// infinite event loop till control key is pressed
while( (msg.which != 29) & (msg.which != 224))
{
    // wait for event
    hi => now;
```
The while loop cycles round indefinitely until the control key (PC mapping 29) is pressed, this will stop the programme.

The computer will stop then and wait for a keypress event.

```c    

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
                map[msg.which] => midiNote;
                if (midiNote >= 0){
                    Std.mtof( midiNote + 48 ) => snd.setFreq;
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

A while loop is used to read each item in the message, usually this will be a single keypress.

If the message is 29 , that is the control key, the programme will stop.

If the message is in the range up to the capacity of the keyboard map array a note may be generated else a noteOff will be sent, typically in response to a key Up event.

To decide which note to play the value in the array corresponding to the keypress is read.  If this is less than zero the keypress is ignored.  Otherwise the value is added to 48 to produce a midi note in the centre of the piano keyboard range.  This note is converted into a freqency and the the sounds setFreq() function is called followed immediately by noteOn.

### A sinewave sound

The simplest possible Sound.ck file is just a sine wave.  This pure tone is uncomfortable to listen to for long, so it is not very musical.  Natural sounds are more complex.

The sinewave sound file is called **SoundSine.ck** to work with this:

* Copy the contents of **SoundSine.ck** into **Sound.ck** you can then edit Sound.ck to something more interest and keep a copy under a new filename for archiving.

So for now **Sound.ck** will become 

```c
public class Sound extends Chubgraph
{
   SinOsc s => outlet;
    0 => s.gain ;
   
   function void noteOn(float vel ){0.2 => s.gain;}
   
   function void noteOff(float vel){0.0 => s.gain;}
   
   function void setFreq(float Hz){Hz => s.freq;}
   
   
}
```
The variable s has the type SinOsc which is the basic sine wave oscillator.  This is connected by => to the  *outlet* of this *Chubgraph* class named Sound.  This allows it to be accessed in the keyboard programme and connected on to the soundcard.

```c
Sound snd => dac;
```
The gain of the sinewave oscilator is set initially to zero to start from silence.

This being the most basic sound it is controlled in the noteOn and noteOff functions simply by turning the gain up and down.

The noteOn() function is capable in principle of recieving a keyboard velocity value in the range 0 - 1 but the alphanumeric keyboard can't generate one so this is ignored.

The setFreq() function recieves a floating point value which is the frequency in Herz.

Now run these programmes and audition the result.

You must press and release the alphpnumric keys one at a time.  This is monophonic sound.

## Trying different oscillators

Oscillators are simple examples of Unit Generators which are listed in the [Chuck Floss Manual](https://en.flossmanuals.net/chuck/_full/?msclkid=ed09a6b6cc7a11ec83ebb15bc63f5f3c#ugens-oscillators)

* SinOsc sinewave
* TriOsc triangle
* SawOsc sawtooth
* SqrOsc square
* PulseOsc variable duty cycle when this is 0.5 same as square wave
* Phasor Not normally used as a source for sound but as a control input in more complex sound patches.

## Combining oscillators

Complex sounds can be generated by combining oscilators in varying ratios.

The file ** ThreeOscs.ck ** combines square, saw and triangle waves with selected weighting.

Why not also include a sinOsc?  Not much point because the more complex waveforms also have the fundamental sine wave frequency covered.  Generally a complex sound is required.

The listing of ThreeOscs.ck is presented:

```c
public class Sound extends Chubgraph
{
   0.3 => int weight1;
   0.3 => int weight2;
   0.3 => int weight3;

```
It is good practice to gather numbers which you might want to adjust to the top of the code.  You can easily change the weight of the three components by editing the values set as weight1 - weight3.

At some point in the future these values might be tied to the dials or sliders of a midi control keyboard, but for now they will need to be edited manually.

```c

   SqrOsc osc1 => Gain g => outlet;
   SawOsc osc2 => g;
   TriOsc osc3 => g;

   weight1 => osc1.gain;
   weight2 => osc2.gain;
   weight1 => osc3.gain;
   0 => g.gain;

```
The three oscillators all point to a Gain object which acts by default as a summing point.

Apply the weights to the gains of the three individual oscillators.

Set the gain of summing point g to zero to start from silence.

```c
   
   function void noteOn(float vel ){
      0.2 => g.gain;
   }
   
   function void noteOff(float vel){
      0.0 => g.gain;
   }
   
   function void setFreq(float Hz){
      Hz => osc1.freq;
      Hz => osc2.freq;
      Hz => osc3.freq;
   } 
}
```
Now note on and off are achieved by controlling the gain of the summing point g.

The frequency of each oscillator needs to be set individually all the oscillators are set to the same frequency in this example.  

Copy **ThreeOscs.ck** to **Sound.ck** to audition and edit.

*You could try the effect of varying the freqencies of the three oscillators.*

When you are done copy **Sound.ck** back to **ThreeOscs.ck**.

## Removing Clicks

At the moment when a key is pressed the sound goes from silence to full volume instantly and when the key is released it returns to silence instantly.  This results in uncomfortable clicking either side of the desired sound.

To turn the sound on more steadily a simple envelope can be used.  The methods which can be called on the envelope are listed in the [Chuck Floss Manual](https://en.flossmanuals.net/chuck/_full/?msclkid=ed09a6b6cc7a11ec83ebb15bc63f5f3c#ugens-oscillators)

**Envelope**

STK envelope base class.

.keyOn (int, WRITE only) ramp to 1.0

.keyOff (int, WRITE only) ramp to 0.0

.target (float, READ/WRITE) ramp to arbitrary value

.time (float, READ/WRITE) time to reach target (in seconds)

.duration (dur, READ/WRITE) time to reach target

.rate (float, READ/WRITE) rate of change

.value (float, READ/WRITE) set immediate value

The envelope is added in the file **ThreeOscsEnv.ck** file.

```c
public class Sound extends Chubgraph
{
   0.3 => float weight1;
   0.3 => float weight2;
   0.3 => float weight3;
   0.05 => float envtime; // in seconds

```
Add a float variable  named  envtime which will set the time it takes the envelope to ramp up to the target level (default = 1) and down to zero each tie the envelope is triggered.

```c

   SqrOsc osc1 => Gain g => Envelope env => outlet;
   SawOsc osc2 => g;
   TriOsc osc3 => g;

 ```

Insert the envelope between the summing point g and the outlet.

```c  

   weight1 => osc1.gain;
   weight2 => osc2.gain;
   weight1 => osc3.gain;
   env.keyOff();
   
   env.time(envtime);
   0.3 => g.gain;
   
 ```

Make sure that the envelope is initially keyed off.

Set the time in seconds over which the envelope will ramp.

Set the starting values of gain.  This time the gain g will be left constant, suggested here is a gain of 0.3.

```c  
   function void noteOn(float vel ){
      env.keyOn();
   }
   
   function void noteOff(float vel){
      env.keyOff();
   }
```
The note on off functions will now control the envelope by env.keyOn() and env.keyOff().

```c   
   function void setFreq(float Hz){
      Hz => osc1.freq;
      Hz => osc2.freq;
      Hz => osc3.freq;
   } 
}
```
Finally the frequency setting function is unchanged.

## Additive Synthesis

The principle of additive synthesis is that a complex waveform is made up by combining simpler waveforms.  That was the approach taken above, but a common approach is to create a waveform by adding up the harmonic components in a specified ratio to change the timbre.

The harmonic components are the fundamental frequency and the integer ratio frequencies above this.  for example 100, 200, 300, 400, 500 Hz ...

To form waveforms with square edges like a square or pulse waves takes a lot of harmonics.  I would suggest eleven.

A programme which works in this way is **Harmonics.ck**

```c
public class Sound extends Chubgraph
{
   1.00 => float a1;  
   0.50 => float a2;
   0.30 => float a3;
   0.25 => float a4;
   0.20 => float a5;
   0.17 => float a6;
   0.14 => float a7;
   0.12 => float a8;
   0.10 => float a9;

```
Here nine harmonics are used.  The amplitudes of the higher harmonics usually decrease strongly.  Here I ihve used 1/n to set the values.  These will make more comples waves if they are in less regular relationships.

```c

   SinOsc osc1 => Gain g => Envelope env => outlet;
   SinOsc osc2 => g;
   SinOsc osc3 => g;
   SinOsc osc4 => g;
   SinOsc osc5 => g;
   SinOsc osc6 => g;
   SinOsc osc7 => g;
   SinOsc osc8 => g;
   SinOsc osc9 => g;
```
The sine wave harmonics are all routed to a summing point.
```c
   a1 => osc1.gain;
   a2 => osc2.gain;
   a3 => osc3.gain;
   a4 => osc4.gain;
   a5 => osc5.gain;
   a6 => osc6.gain;
   a7 => osc7.gain;
   a8 => osc8.gain;
   a9 => osc9.gain;
```
The amplitudes are applied to the oscillator gains.

```c      
   env.keyOff();
   0.3 => g.gain;
```

Rather4444444444444444444444444444444
```c  

   function void noteOn(float vel ){
      env.time(Math.random2f(0.01, 0.5));
      env.keyOn();
   }
   
   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz     => osc1.freq;
      Hz * 2 => osc2.freq;
      Hz * 3 => osc3.freq;
      Hz * 4 => osc4.freq;
      Hz * 5 => osc5.freq;
      Hz * 6 => osc6.freq;
      Hz * 7 => osc7.freq;
      Hz * 8 => osc8.freq;
      Hz * 9 => osc9.freq;
   } 
}
```