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

// Use sound patch here with external class file
Sound snd => Gain sum => dac;
Sample smp => sum;
0.8 => sum.gain;
0.0 => snd.noteOff;
0.0 => smp.noteOff;

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