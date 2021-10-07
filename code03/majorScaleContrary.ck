//Major scale 120 four times contrary motion
1.05946309  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
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
0.2 => s.gain ; 0.2 => t.gain;
for (1 => int i; i <= 4; i++) {
    tonic       => s.freq;   octaveUp    => t.freq;   crotchet => now; 
    supertonic  => s.freq;   leading     => t.freq;   quaver   => now;
    mediant     => s.freq;   submediant  => t.freq;   quaver   => now; 
    subdominant => s.freq;   dominant    => t.freq;   quaver   => now;
    dominant    => s.freq;   subdominant => t.freq;   quaver   => now; 
    submediant  => s.freq;   mediant     => t.freq;   quaver   => now;
    leading     => s.freq;   supertonic  => t.freq;   quaver   => now; 
    octaveUp    => s.freq;   tonic       => t.freq;   crotchet => now;
}