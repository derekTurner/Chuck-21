//Major scale 120 four times contrary motion Solfa
1.05946309  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
192 * tick :: second => dur crotchet;
96  * tick :: second => dur quaver;
57 => int doh; // Scale based on A(3)
doh + 2  => int re;
re  + 2  => int mi;
mi  + 1  => int fah;
fah + 2  => int soh;
soh + 2  => int la;
la  + 2  => int te;
te  + 1  => int doh2;

SinOsc s => dac;  TriOsc t => dac;
0.2 => s.gain ; 0.2 => t.gain;
for (1 => int i; i <= 4; i++) {
    Std.mtof(doh)  => s.freq;   Std.mtof(doh2) => t.freq;   crotchet => now; 
    Std.mtof(re)   => s.freq;   Std.mtof(te)   => t.freq;   quaver   => now;
    Std.mtof(mi)   => s.freq;   Std.mtof(la)   => t.freq;   quaver   => now; 
    Std.mtof(fah)  => s.freq;   Std.mtof(soh)  => t.freq;   quaver   => now;
    Std.mtof(soh)  => s.freq;   Std.mtof(fah)  => t.freq;   quaver   => now; 
    Std.mtof(la)   => s.freq;   Std.mtof(mi)   => t.freq;   quaver   => now;
    Std.mtof(te)   => s.freq;   Std.mtof(re)   => t.freq;   quaver   => now; 
    Std.mtof(doh2) => s.freq;   Std.mtof(doh)  => t.freq;   crotchet => now;
}