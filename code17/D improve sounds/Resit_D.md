# Improved Sounds

The sound patches used so far have been fairly basic.  Although complex waveforms have been formed, the sounds have been fairly static.

In this section different ways to produce a complex wave are illustrated along with ways to make the sound less static.

## Wavetable version of Additive synthesis with UGENs

 In the previous section a complex waveform was generated using additive synthesis.  This involved adding together sine waves of the fundamental frequency, first, second and third harmonic and so on generally progressing to smaller ammounts as the frequency is raised.

 The file **Harmonics.ck** could be copied to **Sound.ck** and played with **keyorganMap.ck**.  The addition of the harmonics needed code to determine the amounts of each component to be added.

 ```c
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
The sound patch required 9 oscillators which puts a high demand on the CPU.  That is one of the greatest drawbacks of additive synthesis.

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
The [floss manual](https://en.flossmanuals.net/chuck/_full/#unit-generators) includes details of unit generators (UGENS), which include oscillators such as sine wave and triangular wave, but extends to more complex generators.

One of these, GEN9 can be used to make a look up table of a waveform which is calculated form the coefficients a1 - a9.

The file **gen9.ck** can be copied to **Sound.ck** to audition with **keyorganMap.ck**

```c
public class Sound extends Chubgraph
{
   Phasor drive => Gen9 g9 => Envelope env => outlet;
```
The Gen9 class is a lookup table and it is read out by a Phasor waveform which ramps from 0 - 1, flicks back to 0 and ramps over and over again.

Gen9 is making sound all the time and the envelope is used to switch the output sound on and off without clicks.

```c   

   [1.0, 1.00, 0.0,   
   2.0, 0.50, 0.0,   
   3.0, 0.20, 0.0,
   4.0, 0.25, 0.0,   
   5.0, 0.20, 0.0,   
   6.0, 0.17, 0.0,
   7.0, 0.14, 0.0,   
   8.0, 0.12, 0.0,   
   9.0, 0.10, 0.0
   ] => g9.coefs;

```
The data in the array is grouped into triplets corresponding to the ratio (1.0, 2.0, 3.0 ... for the harmonic series), the amplitude coefficient (1.0 for the fundamental falling to 0.10 for the 9th harmonic) and zero ( degrees ) for the phase shift.

This produces a waveform lookup table matching the previous example in **Harmonics.ck**.  

Although the ratios here follow the harmonic series this is not compulsary and ratios could vary to your choice (1.0, 2.1, 3.2, 4.3 ...)  likewise the coefficients and phase shifts can be freely set so that non-harmonic aounds could be produced.

```c   

   env.keyOff(); 
   0.3 => g9.gain;

```
Initially set the envelope off to start with silence.

Limit the gain of the Gen9 unit generator so that the sound does not clip and distort.

```c   

   function void noteOn(float vel ){
      
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }

   function void setFreq(float Hz){Hz => drive.freq;}
 
}
```
The noteOn() and noteOff() functions simply trigger the envelope on and off.

To control the frequency, the Phasor drive frequency must be set.  If the drive frequency is 100 Hz it will scan from 0-1 100 times in a second, scribing out the stored waveform through 100 cycles per second.

You can experiment with changing the g9 coefficients and can investigate the other UGENS GenX, Gen5,  Gen7, Gen10 and Gen17.  There are sample files in the special folder of the chuck examples.


## Amplitude Modulation

Ampitude modulation applies a sine wave (typically) modulator to the volume of a carrier signal.  When the modulator frequency is low this can be heard as a tremulo effect.

As the modulator frequency increases the ear no longer hears the variation in volume but percieves a change in tone.

Start by copying **Tremulo.ck** to **Sound.ck** to audition with **keyorganMap.ck**

```c
public class Sound extends Chubgraph
{
   1 =>     float modfreq;
   0.5 =>   float modgain;
   1.0 =>   float modoffset;
```
Set the values of key variables at the top of the programme, these wil be used below to set the modulator frequency, gain and offset.

A modulation frequency of 1 should give 1 tremolo beat per second.

The modulator would normally oscillate between -1 and 1.  By applying an offset of 1 the result will oscillate between 0 and 2.

Applying a gain of 0.5 to offset modulator will result in an output which varies between 0 and 1.

With these values we expect the modulated output of the carrier to vary between 0 and 1 so it should dip to silence once per second.

```c
   SinOsc  carrier => Gain am => Gain master => Envelope env => outlet;
   SinOsc modulator => Gain amOffset => am;
   Step offset => amOffset;
```
The sound patch passes the carrier (the audio signal we want to hear) through a Gain unit named am.  As the gain of am changes the modulation will be applied to the carrier.

This is followed by a master Gain for volume control and an envelope to switch on and off without clicking.

The modulator passes through a Gain unit named amOffset and the result is then sent to the Gain unit am.

The Step object is one which holds the value which is set and then steps to the next value when that is set.  That value which will be set to 1 is passed to the Gain amOffset.  The Gain unit sums its inputs so 1 is added to the signal -1 to +1 which is coming from the modulator.

This modulating signal is then supplied to Gain am

```c   

   am.op(3);//3: normal operation, multiply all inputs.    
```

Gain units usually sum their inputs, but this would not achieve the modulation we require so the op() method of the Gain is passed the value 3 which switches its operation to multiply its inputs rather than sum them.  Now modulation is achieved.

```c  
   0.1 => master.gain;
   0.8 => carrier.gain;
   0   => carrier.sync; // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth  
   modfreq => modulator.freq;  
   modgain => modulator.gain;
   modoffset => offset.next;
```
The values for master gain and carrier gain are set just to prevent clipping and distortion

Oscillators also have different modes of operation determined by their sync setting.  In this the carrier sync is set to zero.  This is the default value and it would have shill worked had this line been omitted.  In default operation the number fed into the oscillator sets its' frequency.

```c

   function void noteOn(float vel ){  
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
     
}
```
The noteOn() and noteOff() functions control the envelope as in previous examples.

The setFreq() funcion sets the carrier frequency to the note we hear.

You should try running this example with higher modulation frequencies to hear the point at which the tremolo becomes a change in tone.

Reducing the offset to zero will cause the gain to pass through zero twice per cycle of the modulator so you should hear the dips to silence double in frequency.

Reducing the modulator gain  below 0.5 should make the dips in volume not reach zero and this is a more normal setting for musical effect.

## Frequency Modulation

In frequency modulation, the frequency of the carrier is raised and lowered (typically) by a sine wave modulator.  If the frequency of the modulator is low we percieve a vibrato effect.  As the modulator frequency increases this changes to a percieved tonal change.

Start by copying **fm.ck** to **Sound.ck** to audition with keyorganMap.ck

```c
public class Sound extends Chubgraph
{

   1.0 =>  float modfreq;
   20.0 =>  float modgain;
```
The modulation frequency is set here to a low value of 1 which will result in the frequency shift cycling above and below the carrier frequency once per second.  This will sound as vibrato.

The modulation gain determines how many hertz the frequency of the carrier will be raised and lowered by the modulator.

```c   

   SinOsc modulator => SinOsc carrier => Envelope env => outlet;
```
The sound patch looks simple, the modulator is passed to the carrier, then on to and envelope to control the sound on and off without clicking.

```c
   0.8 => carrier.gain;
   2   => carrier.sync;  // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth     
   modfreq => modulator.freq;  
   modgain => modulator.gain;
```
The carrier gain is set to a level which will avoid clipping and distortion.

In its default setting the input to the SinOsc would be its frequency.  With a modulator gain of 1 this would lead to the carrier frequency being driven between -1 and +1 Hz which is clearly not the desired effect.

Setting the carrier sync to 2 selects and operating mode where the carrier frequency is determined by the carrier.freq and the input to the carrier oscilator acts as a frequency offset.  So if the carrier frequency was 400 Hz, a modulator with gain of 1 would cause the carrier frequency to be driven between 399 and 400 Hz, which is frequency modulation.

The modulation frequency and gain are set from the variables gathered at the top of the program.

```c   

   function void noteOn(float vel ){  
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
   
}
```

The noteOn() and noteOff() functions operate by triggering the envelope on and off.

The carrier frequency is set in the setFreq() function by accessing the freq property.

You can try changing the modulation frequency to find where the perception shift between vibrato and tone change lies.  You can also increase the modulator gain and notice that when the modulation becomes too great the sound is less natural.

The modulator does not have to be a sine wave, you can try other waveforms, this will create a more complex waveform.

Frequency modulation is the basis of the Ableton Operator synthesis.  Each operator is a combined unit of oscillator, gain and envelope under midi control.  Four of these units can be combined together in different configurations to create a complex sound patch.

## STK UGENS

 Perry R. Cook and Gary P. Scavone have produced a set of C++ language library code which they call the Sound Tool Kit (STK).  There are a range of technical papers about the code and [documentation](https://ccrma.stanford.edu/software/stk/index.html) is provided.

 Some of these have been developed as chuck UGENS.  This means that a single unit generator is capable of producing a complex sound which can be controlled by a number of parameters.

 The down side is that it is difficult to know the internal workings of the UGEN and some combinations of input do not lead to desired sounds.

 The STK instuments are described in the [Floss Manual](https://en.flossmanuals.net/chuck/_full/#ugens-stkinstruments).  These can be very useful, but should be used sparingly.

 Some of the instruments are based on FM synthesis  and the example here uses Rhodey which is a 4 operator based FM synthesis voice.

 ```c
 public class Sound extends Chubgraph
{

   Rhodey voc  => outlet;

   0.8 => voc.gain;

   10 =>voc.lfoSpeed;
   0.5 => voc.lfoDepth;
 ```

The sound patch here is simple and direct.

For each STK instrument you need to refer to the floss manual or examples in the stk folder to see what can can be controlled and the range of control values;

In this case the low frequency oscillator depth and speed can be controlled.  You can vary these values to audition the effect.

 ```c

   function void noteOn(float vel ){  
      1 => voc.noteOn;
   }

   function void noteOff(float vel){
      0 => voc.noteOff;
   }
   
   function void setFreq(float Hz){
      Hz => voc.freq;
   }
   
}
 ```
 The UGEN has built in ADSR envelopes so does not need to feed in to an envelope to trigger the sound.  Instead call the noteOn and noteOff functions of the instrument directly.

 For other STK instruments you will need to consider how the note should be triggered on and off.

 ## Adding an ADSR envelope

 So far an Envelope has been added to noteOn() and noteOff() to reduce clicking due to abrupt turn on of sounds.  A more sophisticated envelope is the ADSR (attack, decay, sustain, release) envelope.  This gives shape to the notes amplitude envelope.  Attack is the time taken for the envelope to rise to its maximum value, decay is the time to decay to a level determined by sustain.  Finally, release deternines the time to decay to zero.

 Copy **fnADSR** to **Sound.ck** to audition the affect of an ADSR envelope replacing the simple envelope.

 ```c
 public class Sound extends Chubgraph
{

   0.1 => float attack; // time in seconds
   0.1 => float decay;  // time in seconds
   0.5 => float sustain;// level 0-1
   0.1 => float release;// time in seconds

```
Save the times and levels required into convenient variables at the top of the program.

```c   

   1.0 =>  float modfreq;
   20.0 =>  float modgain;

   SinOsc modulator => SinOsc carrier => ADSR env => outlet;

   0.8 => carrier.gain;
   2   => carrier.sync;  // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth     
   modfreq => modulator.freq;  
   modgain => modulator.gain;

    env.set(attack :: second, decay :: second, sustain, release :: second);
```
Use the env.set() function to pass all the timing and level parameters to the envelope in on step.

```c 

   function void noteOn(float vel ){  
      env.keyOn();
   }

   function void noteOff(float vel){
      env.keyOff();
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
   
}
 ```

 The keyOn() and keyOff() functions work with ADSR in the same way as they did with Envelope.

 You can experiment with different ADSR settings and could add ADSR envelopes into files with other sound patches.

 ## Creative use of ADSR

 ADSR envelopes can be applied to more than just output volumes. in this next example **fnADSR2.ck** a second ADSR envelope is applied to the modulator gain.

 ```c
 public class Sound extends Chubgraph
{

   0.1 => float attack; // time in seconds
   0.1 => float decay;  // time in seconds
   0.5 => float sustain;// level 0-1
   0.1 => float release;// time in seconds

   0.8 => float attackMod; // time in seconds
   0.2 => float decayMod;  // time in seconds
   0.4 => float sustainMod;// level 0-1
   0.1 => float releaseMod;// time in seconds
```
The timing and level values for two ADSR parameter sets are held in convenient variables at the top of the program.

```c
   50 =>  float modfreq;
   20.0 =>  float modgain;

   SinOsc modulator => ADSR envMod => SinOsc carrier => ADSR env => outlet;
```
An ADSR envelope is added to the sound patch between the modulator and the carrier oscillators.

```c
   0.8 => carrier.gain;
   2   => carrier.sync;  // .sync (int, READ/WRITE) (0) sync frequency to input, (1) sync phase to input, (2) fm synth     
   modfreq => modulator.freq;  
   modgain => modulator.gain;

    env.set(   attack    :: second, decay       :: second, sustain, release    :: second);
    envMod.set(attackMod :: second, decayMod :: second, sustainMod, releaseMod :: second);
 
 ```
The envelope parameters of both ADSR units are set.

 ```c

   function void noteOn(float vel ){  
      env.keyOn();
      envMod.keyOn();

   }

   function void noteOff(float vel){
      env.keyOff();
      envMod.keyOff();   
   }
   
   function void setFreq(float Hz){
      Hz => carrier.freq;
   }
   
}
 ```
 So that these ADSR envelopes are triggered together they are both added into noteOn() and noteOff().

 You can experiment with ADSR values to get the a suitable musical effect.

 Are there any other places where you could use the second ADSR within this patch?

 Can you add a second ADSR to other example files?

 
