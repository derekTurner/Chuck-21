//Major scale 120
1.05946309  => float semitone;
120 => float tempo;

60/(tempo * 192) => float tick;
192 * tick :: second => dur crotchet;
96  * tick :: second => dur quaver;
220 => float tonic; // Scale based on A(3)
tonic * semitone * semitone => float supertonic;
supertonic * semitone * semitone => float mediant;
mediant * semitone => float subdominant;
subdominant * semitone * semitone => float dominant;
dominant * semitone * semitone => float submediant;
submediant * semitone * semitone => float leading;
leading * semitone => float octaveUp;

SinOsc s => dac; 
0.6 => s.gain; 
tonic => s.freq;       crotchet => now; 
supertonic => s.freq;  quaver   => now;
mediant => s.freq;     quaver   => now; 
subdominant => s.freq; quaver   => now;
dominant => s.freq;    quaver   => now; 
submediant => s.freq;  quaver   => now;
leading => s.freq;     quaver   => now; 
octaveUp => s.freq;    crotchet => now;