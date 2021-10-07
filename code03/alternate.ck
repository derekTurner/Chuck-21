// alternate notes
SinOsc s => dac; 
TriOsc t => dac; 
110.0 => float note1;
165.0 => float note2;
0.3 => float gain1;
0.4 => float gain2; 
0.0 => float off;
0.5 :: second => dur myDur;  

note1 => s.freq;
gain1 => s.gain;

1 => int chance;
while(1){
    if (chance == 1){   
        gain1 => s.gain; 
        off   => t.gain;
    }else{
        off   => s.gain;  
        gain2 => t.gain;
    }
    myDur => now;
    !chance => chance;
}
