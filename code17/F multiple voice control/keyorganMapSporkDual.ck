// Use keyboard Human interface device to play sound two separate files simoultaneously.
// Maps the keyboard keys asdf to notes cdef to match piano keyboard pattern
// chuck Sound1.ck Sound2.ck OscMonitorDual.ck keyorganMapSporkDual.ck
true =>int running;
Hid hi;
HidMsg msg;
int midiNote;
0.4   => float keyGain;
400.0 => float keyFreq;

//PC keyboard map
[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 -1,-1,-1,-1,-1,-1,-1, 1, 3,-1,
  6, 8,10,-1,13,15,-1,-1,-1,-1,
  0, 2 ,4, 5, 7, 9,11,12,14,16,
 17,-1,-1,-1,-1,-1,-1,-1,-1,-1 
] @=> int map[];

/*
// MAC keyboard map
[-1,-1,-1,-1, 0,-1,-1, 4, 3, 5,
  7, 9,-1,11,12,14,-1, 1,13,15,
 -1,-1, 2, 6,10,-1, 1,-1, 8,-1,
 -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 -1,-1,-1,-1,-1,-1,-1,-1,18,-1,
 -1,16,17,-1,-1,-1,-1,-1,-1,-1
] @=> int map[];
*/

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// Use sound patch here with external class file
Sound1 snd1 => Gain master => dac;
Sound2 snd2 => master;
0.0 => snd1.noteOff;
0.0 => snd2.noteOff;
0.7 => master.gain;

OscMonitorDual oscmon;
spork ~ oscmon.oscGo(snd1, snd2);
spork ~ monitorKeyboard(snd1, snd2);

while(running){1::second => now;};

<<<"All done", running>>>;


function void monitorKeyboard(Sound1 snd1, Sound2 snd2){
    // infinite event loop till control key is pressed
    <<<"monitoring keyboard">>>;
    while( msg.which != 29 )
    {
        // wait for event
        hi => now;

        // get message
        while( hi.recv( msg ) )
        {
            // check
            if( msg.isButtonDown() )
            {
                <<<msg.which, map.cap()>>>;
                if(msg.which == 29) { false => running; me.exit();}
                if (msg.which < map.cap())
                {
                    map[msg.which] => midiNote;

                    if (midiNote >= 0){
                        Std.mtof( midiNote + 48 ) => keyFreq;
                        keyFreq => snd1.setFreq;
                        keyFreq => snd2.setFreq;
                        keyGain => snd1.noteOn;
                        keyGain => snd2.noteOn;

                    }
                }
            }
            else
            {
                0.0 => snd1.noteOff;
                0.0 => snd2.noteOff;
            }
        }
    }
}
