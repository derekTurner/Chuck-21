# DT B00123456

CW1b

# Brief look at abc file

Song was composed in Logic passed to muse score then to xml  convert to abc and converted into the format to match the music arrays programmed in chuck. Conversion and file reading uses library code.

Sample abc file after cleaning up in the editor to remove %% and V line entries

```code
X:1
T:Title
C:Composer
L:1/8
M:4/4
I:linebreak $
K:C
 c'bab c'c'ba | b3 ^g a^d e2 | abc'a ^g=g^f=f | e4 d4 | c'bab c'c'ba | b3 ^g ^f=f e2 | %6
 c'bac' ba^g^f | e3 ^g a4 |] %8

```
L describes the units of time which abc uses so in this case quaver counts.

## Describe Sound Patches

### Sounpatch1

Basic sine wave patch with ADSR

Cotrolled parameters were

Attack 0.0 - 1.0
Delay 0.0 - 1.0
Sustain 0.0 - 1.0
Relese 0.0 - 3 

Sound listened to OSC messages from sliders 1 - 3

```javascript
   function void oscSlider(int sliderNo, int value){  // value 0 - 127
        <<<"hello ", sliderNo, value>>>;
        if(sliderNo == 0){ 
           amax * value/127    => attack; 
           env.attackTime(attack :: second);
           <<<attack>>>; }
        if(sliderNo == 1){ 
           dmax * value/127    => decay; 
            env.decayTime(decay :: second);
            <<<decay>>>; }
        if(sliderNo == 2){ 
           smax * value/127    => sustain; 
           env.sustainLevel(sustain); }
        if(sliderNo == 3){ 
           rmax * value/127    => release; 
           env.releaseTime(release :: second); }                                      
   }  
```

### Sounpatch2

### Sounpatch3

## Discuss OSC control

blah