# Playback music from MDV format

A library file is provided to play back music form the MDV format.

So long as you convert them line by line you can create multipe musical parts.  I have done this for Ode to joy producing three parts.

## Playback melody from mdv file

This example **mdvPlayer.ck** plays back a single part using a single voice in **Sound.ck**  Which is the most basic sound patch.

```c
public class Sound extends Chubgraph
{

// starting and max values for ADSR parameters
// These values may be edited as required
 0.9 => float attack;
 0.1 => float decay;
 0.5 => float sustain;
 0.1 => float release;
 

SinOsc s => ADSR env => outlet;
1 => s.gain;

env.set(attack :: second, decay :: second, sustain, release :: second);
<<<"envelope state", env.state()>>>; // print env state 0 atack 1 decay 2 sustain 3 release 4 done

   
   function void noteOn(float vel ){env.keyOn(1); <<<"envelope state", env.state()>>>;}
   
   function void noteOff(float vel){ env.keyOff(1); <<<"envelope state", env.state()>>>;}
   
   function void setFreq(float Hz){Hz => s.freq;}
     
}
```

The player will read the numbers from the mdv files into arrays containing midi notes (M) durations (D) and velocities (V)

**mdvPlayer.ck**

```c
//ode to joy using single sound in separate class file
//Now reading note arrays form a file
//chuck Sound.ck mdvPlayer.ck

40 => float tempo;

60/(tempo * 192) => float tick;

int melNotes[0];
int myDurs[0];
float myVelocities[0];



// sound patch read from an external class file Sound,ck
Sound snd => dac;
0.0 =>snd.noteOff;

"mdv/OdeToJoy1.txt" => string filename;
```
You should edit the file name here to playback the file of your choice.

```c
retrieve(melNotes, myDurs, myVelocities);


Event start;

spork ~ player(melNotes, myDurs, myVelocities, start);
1.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 
```
At this point you do not need to know the detaile of the library functions provided to read the file and play back.

```c
// ------------------------ file reading function ------------------------------//

function void retrieve(int notes[], int durations[], float velocities[] ){
    int cap;
    // flags: READ_WRITE, READ, WRITE, APPEND, BINARY, ASCII combine with | bitwise or.
    me.sourceDir() + "/" + filename => string filepath;
    FileIO datafile;
    datafile.open(filepath, FileIO.READ | FileIO.ASCII  );
    Std.atoi( datafile.readLine()) => cap;
    //<<< "array length " ,cap >>>;
    cap => notes.size;
    cap => durations.size;
    cap => velocities.size;
    for( 0 => int i; i < cap; i++ ){Std.atoi(datafile.readLine())=>(notes[i]);}
    for( 0 => int i; i < cap; i++ ){Std.atoi(datafile.readLine())=>(durations[i]);}
    for( 0 => int i; i < cap; i++ ){Std.atof(datafile.readLine())=>(velocities[i]);}
    datafile.close();
    //<<<cap, notes ,durations, velocities >>>; // prints pointer to arrays not array values.
}

//---------------------- voice playing functions --------------//

function void player(int N[], int D[], float V[], Event start){
    while( true){
        //0 => s.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (0 =>int index; index < N.cap(); index ++){ //for each element of the array
                Std.mtof(N[index])      => snd.setFreq;
                V[index]   * 0.2    => snd.noteOn;
                D[index] * tick :: second => now;
                0.0 => snd.noteOff;
            }
        }
    }
}


```
> chuck Sound.ck mdvPlayer.ck

Can you play back an mdv file which you have created yourself.

Try to play back on a more interesting sound.

Can you add control running at the same time as playback?