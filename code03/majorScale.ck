//Major scale
1.05946309  => float semitone;
0.3 => float hold;

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
tonic => s.freq;       hold :: second => now; 
supertonic => s.freq;  hold :: second => now;
mediant => s.freq;     hold :: second => now; 
subdominant => s.freq; hold :: second => now;
dominant => s.freq;    hold :: second => now; 
submediant => s.freq;  hold :: second => now;
leading => s.freq;     hold :: second => now; 
octaveUp => s.freq;    hold :: second => now;