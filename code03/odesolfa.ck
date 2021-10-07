//ode to joy solfa
1.05946309  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
384 * tick :: second => dur minim;
288 * tick :: second => dur crotchetD;
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
0.2 => s.gain ; 0.1 => t.gain;
for (1 => int i; i <= 4; i++) {
    Std.mtof(mi)  => s.freq;   Std.mtof(doh) => t.freq;  crotchet   => now; 
    Std.mtof(mi)  => s.freq;   0             => t.gain;  crotchet   => now;
    Std.mtof(fah) => s.freq;                             crotchet   => now; 
    Std.mtof(soh) => s.freq;                             crotchet   => now;
    Std.mtof(soh) => s.freq;   0.2            => t.gain; crotchet   => now; 
    Std.mtof(fah) => s.freq;   0              => t.gain; crotchet   => now;
    Std.mtof(mi)  => s.freq;                             crotchet   => now; 
    Std.mtof(re)  => s.freq;                             crotchet   => now; 
    Std.mtof(doh) => s.freq;   0.2            => t.gain; crotchet   => now; 
    Std.mtof(doh) => s.freq;   0              => t.gain; crotchet   => now; 
    Std.mtof(re)  => s.freq;                             crotchet   => now;
    Std.mtof(mi)  => s.freq;   Std.mtof(soh)  => t.freq; crotchet   => now; 
    Std.mtof(mi)  => s.freq;   0.2            => t.gain; crotchetD  => now; 
    Std.mtof(re)  => s.freq;   0.2            => t.gain; minim      => now; 
}