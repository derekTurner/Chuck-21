# Audio Programming C2
## Playing multiple sounds and samples in a timed sequence

 The **Timeline.ck** file in section C above is suitable as a starter for the second CW piece however I was asked how to play different samples and also how to add rests to the audio so this will adress these questions.

 To work with many samples I would recommend using an array of buffers, but for two or three samples it is easiest to use two sample files which I will call **Sample1.ck** and **Sample2.ck** These will be almost identical except that I will change the name of the classes to Sample1 and Sample 2, keeping them matching with the file names and each will hold a different sample.

**Sample1.ck** (extract)

```javascript
public class Sample1 extends Chubgraph
{
    // select sample file from this list or your own sample
 
    // "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
    // "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
    // "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"

    "stereo_fx_01" => string fileName;
```
This will play sound effect 1.

**Sample2.ck** (extract)

```javascript
public class Sample2 extends Chubgraph
{
    // select sample file from this list or your own sample
 
    // "clap_01","click_01","click_02","cowbell_01","hihat_01","hihat_02",
    // "hihat_04","kick_01","kick_04","snare_01","snare_02","snare_03",
    // "stereo_fx_01","stereo_fx_03","stereo_fx_01","stereo_fx_03"

    "cowbell_01" => string fileName;
```

This will play the cowbell sample.

In a Similar way I will make two files **Sound1.ck** and **Sound2.ck** with different sound patches and class names.


**Sound1.ck** (extract)

```javascript
public class Sound1 extends Chubgraph
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
```

This is a copy from the sound which was in the Harmonics2.ck file with the class renamed to Sound1.

**Sound2.ck** (extract)

```javascript
public class Sound2 extends Chubgraph
{
   0.3 => float weight1;
   0.3 => float weight2;
   0.3 => float weight3;
   0.05 => float envtime; // in seconds


   SqrOsc osc1 => Gain g => Envelope env => outlet;
   SawOsc osc2 => g;
   TriOsc osc3 => g;

   weight1 => osc1.gain;
   weight2 => osc2.gain;
   weight1 => osc3.gain;
```

This is a copy from the sound which was in the ThreeOscsEnv.ck file with the class renamed to Sound2.

The full contents of these files can be viewed in the download files.

These four sounds are then played from the timeline in **Timelinemultivoice.ck** which is adapted from **Timeline.cl**

```javascript
// Example of a simple tune and rhythm using synthesis and samples in a timeline. 
// Demonstrating use of multiple voices
// chuck Sound1.ck Sound2.ck Sample1.ck Sample2.ck Timelinemultivoice.ck

1.059463094359  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
384 * tick :: second => dur minim;
288 * tick :: second => dur crotchetD;
192 * tick :: second => dur crotchet;
96  * tick :: second => dur quaver;
48  * tick :: second => dur semiquaver;

20 * tick :: second  => dur gap;

// MIDI scale based on A(3)
57 => int doh; 
doh + 2  => int re;
re  + 2  => int mi;
mi  + 1  => int fah;
fah + 2  => int soh;
soh + 2  => int la;
la  + 2  => int te;
te  + 1  => int doh2;

// sample scale based on A(3)
1.0                              => float sdoh; 
Math.pow ( 1.059463094359, 2 )   => float sre;
Math.pow ( 1.059463094359, 4 )   => float smi;
Math.pow ( 1.059463094359, 5 )   => float sfah;
Math.pow ( 1.059463094359, 7 )   => float ssoh;
Math.pow ( 1.059463094359, 9 )   => float sla;
Math.pow ( 1.059463094359, 11 )  => float ste;
2.0                              => float sdoh2;

// set available music dynamic values
1.0 => float f;
0.6 => float mf;
0.4 => float p;

```
 These lines are just the same as before, you can extend the notes available to your melody by defining variables named for the next octave re2. mi2, fah2 ....

 You could also define additional durations in terms of ticks to match your musical requirements.  How for example would you represent a dotted minim?

```javascript

// Use sound patch here with external class file
Sound1  snd1 => Gain sum => dac;
Sound2  snd2 => sum;
Sample1 smp1 => sum;
Sample2 smp2 => sum;
0.8 => sum.gain;
0.0 => snd1.noteOff;
0.0 => snd2.noteOff;
0.0 => smp1.noteOff;
0.0 => smp2.noteOff;
```
The classes Sound1, Sound2, Sample1 and Sample2 are routed in from external files and allocated to variable names.


```javascript
for (0 => int i; i<2; i + 1 => i){
// Timed Midi Notes
    Std.mtof(doh)   => snd1.setFreq;  f =>   snd1.noteOn; smi  => smp2.setFreq;  f => smp2.noteOn ;     semiquaver  - gap   => now;  0.0 => snd1.noteOff;  0.0 => smp2.noteOff; gap   => now;

```
On each line which plays a sound care must be taken to identify the correct sound variables for noteOn and noteOff.  There is only a single timeline running here so it is possible to play a sound and a sample at the same time as above, but not to have two rhythms running at the same time.

```javascript

    Std.mtof(re)    => snd1.setFreq;  mf =>  snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now;
    Std.mtof(mi)    => snd1.setFreq;  mf =>  snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now; 
    Std.mtof(soh)   => snd1.setFreq;  mf =>  snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now;
    Std.mtof(te)    => snd1.setFreq;  f =>   snd1.noteOn; doh  => smp1.setFreq;  f => smp2.noteOn  ;     semiquaver  - gap   => now; 0.0 => snd1.noteOff; 0.0 => smp2.noteOff;gap   => now; 
    Std.mtof(la)    => snd2.setFreq;  mf =>  snd2.noteOn;      semiquaver  - gap   => now; 0.0 => snd2.noteOff; gap   => now;
    Std.mtof(soh)   => snd2.setFreq;  mf =>  snd2.noteOn;      semiquaver  - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
    Std.mtof(re)    => snd2.setFreq;  mf =>  snd2.noteOn;      semiquaver  - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
    crotchet => now;
```
A rest (silence) can be generated simply by chucking a selected duration to now as in the line above which provides a crotchet rest.

```javascript    
    Std.mtof(doh)   => snd1.setFreq;  f =>   snd1.noteOn; smi  => smp1.setFreq;  f => smp1.noteOn  ;     semiquaver  - gap   => now; 0.0 => snd1.noteOff; 0.0 => smp1.noteOff;gap   => now; 
    Std.mtof(re)    => snd1.setFreq;  p =>   snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now; 
    Std.mtof(mi)    => snd1.setFreq;  f =>   snd1.noteOn;      semiquaver - gap   => now; 0.0 => snd1.noteOff; gap   => now;
    Std.mtof(soh)   => snd1.setFreq;  p =>   snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now; 
    Std.mtof(doh)   => snd1.setFreq;  f =>   snd1.noteOn; re  => smp2.setFreq;  f => smp2.noteOn   ;     semiquaver - gap   => now; 0.0 => snd1.noteOff; 0.0 => smp2.noteOff;gap   => now; 
    Std.mtof(mi)    => snd2.setFreq;  f =>   snd2.noteOn;      semiquaver    - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
    Std.mtof(re)    => snd2.setFreq;  f =>   snd2.noteOn;      semiquaver     - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
    Std.mtof(soh)   => snd2.setFreq;  f =>   snd2.noteOn;      semiquaver   - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
}
//Timed Samples
    smi  => smp1.setFreq;  f =>   smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    smi  => smp1.setFreq;  mf =>  smp1.noteOn;      semiquaver - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    smi  => smp1.setFreq;  p =>   smp1.noteOn;      semiquaver - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    smi  => smp1.setFreq;  p =>   smp1.noteOn;      semiquaver - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    smi  => smp1.setFreq;  p =>   smp1.noteOn;      semiquaver - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    sfah => smp1.setFreq;  mf =>  smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now; 
    ssoh => smp1.setFreq;  mf =>  smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    ssoh => smp1.setFreq;  f =>   smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now; 
    sfah => smp1.setFreq;  mf =>  smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now;
    smi  => smp1.setFreq;  mf =>  smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now; 
    sre  => smp1.setFreq;  mf =>  smp1.noteOn;      crotchet   - gap   => now; 0.0 => smp1.noteOff; gap   => now; 

    sdoh => smp2.setFreq;  f =>   smp2.noteOn;      crotchet   - gap   => now; 0.0 => smp2.noteOff; gap   => now; 
    sdoh => smp2.setFreq;  p =>   smp2.noteOn;      semiquaver - gap   => now; 0.0 => smp2.noteOff; gap   => now; 
    sdoh  => smp2.setFreq; p =>   smp2.noteOn;      semiquaver - gap   => now; 0.0 => smp2.noteOff; gap   => now;
    sdoh  => smp2.setFreq; p =>   smp2.noteOn;      semiquaver - gap   => now; 0.0 => smp2.noteOff; gap   => now;
    sdoh  => smp2.setFreq; p =>   smp2.noteOn;      semiquaver - gap   => now; 0.0 => smp2.noteOff; gap   => now;
    sre  => smp2.setFreq;  f =>   smp2.noteOn;      crotchet   - gap   => now; 0.0 => smp2.noteOff; gap   => now;
    smi  => smp2.setFreq;  p =>   smp2.noteOn;      crotchet   - gap   => now; 0.0 => smp2.noteOff; gap   => now; 
    smi  => smp2.setFreq;  f =>   smp2.noteOn;      crotchetD  - gap   => now; 0.0 => smp2.noteOff; gap   => now; 
    sre  => smp2.setFreq;  f =>   smp2.noteOn;      quaver     - gap   => now; 0.0 => smp2.noteOff; gap   => now; 
    sre  => smp2.setFreq;  f =>   smp2.noteOn;      minim      - gap   => now; 0.0 => smp2.noteOff; gap   => now; 
```




The example here provides an integrated sequence of multiple sounds followed by timed and pitched sequence which follows the simple melody of 'Ode to Joy'

 