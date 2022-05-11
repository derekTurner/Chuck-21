# Audio Programming C
## Playing sounds and samples in a timed sequence using

 The sounds and samples worked on so far can be brought together into a folder where they can be played from a new file in a timed sequence..

 The example described here creates a timed and pitched sequence which follows the simple melody of 'Ode to Joy'

 The Sound.ck file is based on Harmonics2.ck (a small modification to the Harmonics.ck file)

 The Sample.ck file is set to play a snare sound.

 

### A single sample

A number of samples are provided in the Audio folder for practice, but you may download or create your own.

    audio folder
     "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
     "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
     "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"

### Timed Programme

 The **Timeline.ck** programme requires the **Sound.ck** and **Sample.ck** programmes to be in the same folder and the audio samples to be in an audio folder within this.

```c
//Example of a simple tune and rhythm using synthesis and samples in a timeline. 
// playing ode to joy using solfa to set midi notes to a major scale
// chuck Sound.ck Sample.ck Timeline.ck

1.059463094359  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
384 * tick :: second => dur minim;
288 * tick :: second => dur crotchetD;
192 * tick :: second => dur crotchet;
96  * tick :: second => dur quaver;
48  * tick :: second => dur semiquaver;

20 * tick :: second  => dur gap;
```
The semitone variable is loaded with the multiplier which is used for setting the frequency shift for samples.  This number is always the same it is determined by the definition of the well tempered scale.

The tempo of the piece is set to 120 beats per minute, this can be edited to change the overall tempo.

The duration of a tick is calculated on the basis of 192 ticks per crotchet beat.

Durations in seconds which represent the lengths of musical notes at the selected tempo are set.

A short duration called gap is set to 20 ticks.  This will create a short gap between notes.  This is needed because the synthesised notes at this point do not have dynamic shaping and without gaps consecutive notes of the same pitch would merge into one. In musical terms, no gap would be *legato* a small gap would be *tenuto* and a larger gap would become *staccato*.

These gaps will not have much effect of the sound of samples if they decay over a shorter period than the note duration.

```c

// MIDI scale based on A(3)
57 => int doh; 
doh + 2  => int re;
re  + 2  => int mi;
mi  + 1  => int fah;
fah + 2  => int soh;
soh + 2  => int la;
la  + 2  => int te;
te  + 1  => int doh2;
```
The major scale is represented by doh, re, mi ... and these variables contain midi note values determined by adding a number of semitone steps to the *tonic* note which in this case is A(3) or midi note 57.  To change the key edit the value 57, the scale will stay in the correct pitch relationship to this.

```c
// sample scale based on A(3)
1.0                              => float sdoh; 
Math.pow ( 1.059463094359, 2 )   => float sre;
Math.pow ( 1.059463094359, 4 )   => float smi;
Math.pow ( 1.059463094359, 5 )   => float sfah;
Math.pow ( 1.059463094359, 7 )   => float ssoh;
Math.pow ( 1.059463094359, 9 )   => float sla;
Math.pow ( 1.059463094359, 11 )  => float ste;
2.0                              => float sdoh2;
```
The sample pitch shift multipliers are floating point values calculated to match the musical scale and saved in variables sdoh, sre, smi ...

The multiplier for an octave shift is 2.

```c
// set available music dynamic values
1.0 => float f;
0.6 => float mf;
0.4 => float p;
```
The notes can be played loud or soft.  The values in the range 0 - 1 can be edited and stored in variables named after musical dynamics: forte, mezzoforte and piano.

The sound and sample files will need to be adjusted to ensure that if they are played with a forte volume, they do not produce distortion.

```c
// Use sound patch here with external class file
Sound snd => Gain sum => dac;
Sample smp => sum;
0.8 => sum.gain;
0.0 => snd.noteOff;
0.0 => smp.noteOff;
```
The sound patch must separately bring in audio from the external Sound and Sample files.  These are patched to a Gain unit which sums the audio at its input.  This also provides a master gain setting for the patch which here has been set to 0.8.

The noteOff function is called for both the Sound and the Sample so that the piece will start from silence.

```c
// Timed Midi Notes
    Std.mtof(mi)  => snd.setFreq;  f =>   snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now;
    Std.mtof(mi)  => snd.setFreq;  mf =>  snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now;
    Std.mtof(fah) => snd.setFreq;  mf =>  snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(soh) => snd.setFreq;  mf =>  snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now;
    Std.mtof(soh) => snd.setFreq;  f =>   snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(fah) => snd.setFreq;  mf =>  snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now;
    Std.mtof(mi)  => snd.setFreq;  mf =>  snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(re)  => snd.setFreq;  mf =>  snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(doh) => snd.setFreq;  f =>   snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(doh) => snd.setFreq;  p =>   snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(re)  => snd.setFreq;  f =>   snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now;
    Std.mtof(mi)  => snd.setFreq;  p =>   snd.noteOn;      crotchet  - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(mi)  => snd.setFreq;  f =>   snd.noteOn;      crotchetD - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(re)  => snd.setFreq;  f =>   snd.noteOn;      quaver    - gap   => now; 0.0 => snd.noteOff; gap   => now; 
    Std.mtof(re)  => snd.setFreq;  f =>   snd.noteOn;      minim     - gap   => now; 0.0 => snd.noteOff; gap   => now; 
```

The order of action for each midi note played is as follows:

* Set the sound frequency from the midi note required
* Call the sound noteOn() function passing the required volume
* Pause for a duration of the note length - the gap while the note plays
* Call the sound noteOff() function
* Pause for a duration which is the gap between notes

```c
//Timed Samples
    smi  => smp.setFreq;  f =>   smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now;
    smi  => smp.setFreq;  mf =>  smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    smi  => smp.setFreq;  p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    smi  => smp.setFreq;  p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    smi  => smp.setFreq;  p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    sfah => smp.setFreq;  mf =>  smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    ssoh => smp.setFreq;  mf =>  smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now;
    ssoh => smp.setFreq;  f =>   smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sfah => smp.setFreq;  mf =>  smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now;
    smi  => smp.setFreq;  mf =>  smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sre  => smp.setFreq;  mf =>  smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sdoh => smp.setFreq;  f =>   smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sdoh => smp.setFreq;  p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sdoh  => smp.setFreq; p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    sdoh  => smp.setFreq; p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    sdoh  => smp.setFreq; p =>   smp.noteOn;      semiquaver - gap   => now; 0.0 => smp.noteOff; gap   => now;
    sre  => smp.setFreq;  f =>   smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now;
    smi  => smp.setFreq;  p =>   smp.noteOn;      crotchet   - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    smi  => smp.setFreq;  f =>   smp.noteOn;      crotchetD  - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sre  => smp.setFreq;  f =>   smp.noteOn;      quaver     - gap   => now; 0.0 => smp.noteOff; gap   => now; 
    sre  => smp.setFreq;  f =>   smp.noteOn;      minim      - gap   => now; 0.0 => smp.noteOff; gap   => now; 
```

The order of action for each sample note played is as follows:

* Set the sample frequency from the multiplier for the pitch shift required
* Call the sample noteOn() function passing the required volume
* Pause for a duration of the note length - the gap while the note plays
* Call the sample noteOff() function
* Pause for a duration which is the gap between samples

These files provide the basis for a well structured musical rendition.  Notes elsewhere in the beginning of the module provide a view which will allow freeform timed elements.

### The Sound file

The sound file **Sound.ck** which is being used here is based on the harmonic.ck file developed earlier.  I will just point out the minor adjustments which have been made to produce a suitable sound for this example.

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
      
   env.keyOff();
   0.3 => g.gain;

   0.3 => float volumeScale;
   
   function void noteOn(float vel ){
      vel * volumeScale => g.gain;
      env.time(Math.random2f(0.01, 0.05));
      env.keyOn();
      
   }
```
A volumeScale variable has been added with a value of 0.3 so that when the timeline calls noteOn with a velocity value vel = 1, this is scaled by volumeScale to 0.3 and stored in g.gain.  This prevents the sound distorting.

You need to take care when adding the outputs of multiple oscillators together that the sum is scaled to prevent distortion.

```c   
   
   function void noteOff(float vel){
      env.time(0.005);
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

### The Sample file

The sample file is based on the earlier example again with minor modifications.

```c
public class Sample extends Chubgraph
{
    // select sample file from this list or your own sample
 
    // "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
    // "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
    // "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"

    "snare_01" => string fileName;
```
The sample chosen is the snare sound rather than stereo_fx_03.  The snare is not a strongly pitched sound so it sounds ok together with the synthesised sounds.

If you use a piched sound such as stereo_fx_03 you will need to work out a multiplier so that the sample is shifted into the base key otherwise there will be a mismatch between the apparent keys of synthesised and sampled audio.

```c    
    SndBuf buffer;
    int    sampleLength;
    0.001 => float sampleAttack;
    0.01 =>  float sampleRelease;
    0 =>     int playing;

    me.sourceDir() + "/audio/" + fileName + ".wav" => buffer.read; 
    buffer.rate(1);                         // normal playback
    buffer.samples() => sampleLength;      // store for convenience
    buffer.pos(sampleLength-1);            // move buffer position to end of sample

    Gain percGain => Envelope env => outlet;
    buffer => percGain;
    0.8 => percGain.gain;
```
The percussion gain can be editted so that there is no distortion when the timeline calls noteOn() with a velocity of 1.

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
Notice that the velocity is set by controlling the buffer.gain and the overall volume is set by the percGain.gain.

```c   
   
   function void noteOff(float vel){
        env.time(sampleRelease);
        env.keyOff();
        sampleRelease :: second => now;
        buffer.pos(sampleLength-1);  
        0 => playing;
   }
   
   function void setFreq(float rate){  
        buffer.rate(rate);

   } 
    
   
}    
```

At this point these example files can be used as a starter towards the first portfolio item in your coursework.  Alternately you may choose to develop a file which you created during T1 or based on notes up to the mid of week 4. 