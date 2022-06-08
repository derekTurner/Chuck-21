# Playback music from MDV format

A library file is provided to play back music saved in the the MDV format.

You don't need to follow the detail of operation, but an outline is provided here.

## Playback melody from mdv file

This example **mdvPlayer.ck** plays back a single part using a single voice in **Sound.ck**  Which is the most basic sound patch consisting of a sine wave with ADSR envelope.

```c
public class Sound extends Chubgraph
{

// starting and max values for ADSR parameters
// These values may be edited as required
 0.8 => float attack;
 0.1 => float decay;
 0.5 => float sustain;
 0.05 => float release;
 

SinOsc s => ADSR env => outlet;
1 => s.gain;

env.set(attack :: second, decay :: second, sustain, release :: second);

   
   function void noteOn(float vel ){env.keyOn(1);}
   
   function void noteOff(float vel){ env.keyOff(1);}
   
   function void setFreq(float Hz){Hz => s.freq;}

}
```

The player will read the numbers from an  mdv file into arrays containing midi notes (M) durations (D) and velocities (V)

**mdvPlayer.ck**

```c
//ode to joy using single sound in separate class file
//Now reading note arrays from an mdv file
//chuck Sound.ck mdvPlayer.ck

120 => float tempo;

60/(tempo * 192) => float tick;

int melNotes[0];
int myDurs[0];
float myVelocities[0];
10 => int gap;



// sound patch read from an external class file Sound,ck
Sound snd => dac;
0.0 =>snd.noteOff;

"mdv/OdeToJoy1.txt" => string filename;
```
You should edit the file name here to playback the mdv format text file of your choice.  Note that the full path to the file including any folder it may be in is needed here (in this example the file is in the mdv folder).

```c
retrieve(melNotes, myDurs, myVelocities);


Event start;

spork ~ player(melNotes, myDurs, myVelocities, start, gap);
1.0 * second => now;
start.broadcast();

while(true){// main loop
    100::second => now;
}; 
```
The retrieve function will read back the data in the mdv file and place it into three arrays representing midinote, duration and velocity).  There is no conversion needed here so the file is read very quickly.

The player function takes the three arrays as arguments together with an event to allow it to start under control, and a gap count which will allow for varying degrees of staccato to separate notes.  In this example the gap has been set to 10 ticks.  The affect of this will vary dependant on the release time of the sound used in playback.

1 second is allowed to elapse, just to demonstrate that the player does not start until the start event is broadcast.

At this point you do not need to know the details of the library functions provided to read the file and play back.

```c
// ------------------------ file reading function --------------//

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
```

The file reading funcion locates the file and opens it to read.

The length of the first line is used to determine how many values will be read back for each or the arrays.

The arrays which were passed into the retrieve function are populated.

The file is closed after it has been read.

```c
//---------------------- voice playing functions --------------//

function void player(int N[], int D[], float V[], Event start, int gap){
    while( true){
        //0 => s.gain ;
        start => now;
        for (1 => int i; i <= 4; i++) {// four repeats
            for (1 =>int index; index < N.cap(); index ++){ //for each non zero element of the array
                Std.mtof(N[index])  => snd.setFreq;
                V[index]   * 0.2    => snd.noteOn;
                (D[index]-gap)* tick :: second => now;
                0.0 => snd.noteOff;
                gap * tick :: second => now;
            }
        }
    }
}
```
The player reads each element of the arrays except the first (which is set as 0 as a marker) 

The gap parameter is used to shorten the duration of the played sound and then is added back as a short silence.

To play back the audio:

> chuck Sound.ck mdvPlayer.ck

A single melody line of Ode to joy is played four times.

Can you play back an mdv file which you have created yourself.

Try to play back on a more interesting sound.

