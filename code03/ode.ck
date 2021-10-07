//ode to joy
1.05946309  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
384 * tick :: second => dur minim;
288 * tick :: second => dur crotchetD;
192 * tick :: second => dur crotchet;
96  * tick :: second => dur quaver;


220 => float tonic; // Scale based on A(3)
tonic       * semitone * semitone  => float supertonic;
supertonic  * semitone * semitone  => float mediant;
mediant     * semitone             => float subdominant;
subdominant * semitone * semitone  => float dominant;
dominant    * semitone * semitone  => float submediant;
submediant  * semitone * semitone  => float leading;
leading     * semitone             => float octaveUp;

SinOsc s => dac;  TriOsc t => dac;
0.2 => s.gain ; 0.1 => t.gain;
for (1 => int i; i <= 4; i++) {
    mediant       => s.freq;   tonic       => t.freq;   crotchet   => now; 
    mediant       => s.freq;   0           => t.gain;   crotchet   => now;
    subdominant   => s.freq;                            crotchet   => now; 
    dominant      => s.freq;                            crotchet   => now;
    dominant      => s.freq;   0.2         => t.gain;   crotchet   => now; 
    subdominant   => s.freq;   0           => t.gain;   crotchet   => now;
    mediant       => s.freq;                            crotchet   => now; 
    supertonic    => s.freq;                            crotchet   => now; 
    tonic         => s.freq;   0.2         => t.gain;   crotchet   => now; 
    tonic         => s.freq;   0           => t.gain;   crotchet   => now; 
    supertonic    => s.freq;                            crotchet   => now;
    mediant       => s.freq;   dominant    => t.freq;   crotchet   => now; 
    mediant       => s.freq;   0.2         => t.gain;   crotchetD  => now; 
    supertonic    => s.freq;   0           => t.gain;   quaver     => now; 
    supertonic    => s.freq;   0.2         => t.gain;   minim      => now; 
}