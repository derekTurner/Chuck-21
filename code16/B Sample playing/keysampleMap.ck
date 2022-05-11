// Use keyboard Human interface device to play sound in separate file.
// Maps the keyboard keys asdf to notes cdef to match piano keyboard pattern
// chuck Sample.ck keysampleMap.ck

Hid hi;
HidMsg msg;
int semitone;
0.4 => float keyGain;

[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
 -1,-1,-1,-1,-1,-1,-1, 1, 3,-1,
  6, 8,10,-1,13,15,-1,-1,-1,-1,
  0, 2 ,4, 5, 7, 9,11,12,14,16,
 17,-1,-1,-1,-1,-1,-1,-1,-1,-1 
] @=> int map[];

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// Use sound patch here with external class file
Sample snd => dac;
0.0 =>snd.noteOff;


// infinite event loop till control key is pressed
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
            <<<msg.which>>>;
            if(msg.which == 29) break;
            if (msg.which < map.cap())
            {
                map[msg.which] => semitone;
                if (semitone >= 0){
                    Math.pow ( 1.059463094359, semitone ) => snd.setFreq;
                    keyGain => snd.noteOn;
                }
            }
        }
        else
        {
            0.0 => snd.noteOff;
        }
    }
}
