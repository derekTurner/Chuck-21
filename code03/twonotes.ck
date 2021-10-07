SinOsc s => dac; 
TriOsc t => dac; 
110.0 => float note1;
165.0 => float note2;
0.3 => float gain1;
0.4 => float gain2; 
2.3 :: second => dur myDur;  

note1 => s.freq;
gain1 => s.gain; 
note2 => t.freq;  
gain2 => t.gain;
myDur => now;

