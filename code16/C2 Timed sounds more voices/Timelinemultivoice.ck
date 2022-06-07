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


for (0 => int i; i<2; i + 1 => i){
// Timed Midi Notes
    Std.mtof(doh)   => snd1.setFreq;  f =>   snd1.noteOn; smi  => smp2.setFreq;  f => smp2.noteOn ;     semiquaver  - gap   => now;  0.0 => snd1.noteOff;  0.0 => smp2.noteOff; gap   => now;
    Std.mtof(re)    => snd1.setFreq;  mf =>  snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now;
    Std.mtof(mi)    => snd1.setFreq;  mf =>  snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now; 
    Std.mtof(soh)   => snd1.setFreq;  mf =>  snd1.noteOn;      semiquaver  - gap   => now; 0.0 => snd1.noteOff; gap   => now;
    Std.mtof(te)    => snd1.setFreq;  f =>   snd1.noteOn; doh  => smp1.setFreq;  f => smp2.noteOn  ;     semiquaver  - gap   => now; 0.0 => snd1.noteOff; 0.0 => smp2.noteOff;gap   => now; 
    Std.mtof(la)    => snd2.setFreq;  mf =>  snd2.noteOn;      semiquaver  - gap   => now; 0.0 => snd2.noteOff; gap   => now;
    Std.mtof(soh)   => snd2.setFreq;  mf =>  snd2.noteOn;      semiquaver  - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
    Std.mtof(re)    => snd2.setFreq;  mf =>  snd2.noteOn;      semiquaver  - gap   => now; 0.0 => snd2.noteOff; gap   => now; 
    crotchet => now;
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