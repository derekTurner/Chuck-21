/*
Maps the keyboard keys asdf to notes cdef to match piano keyboard pattern
*/

// HID
Hid hi;
HidMsg msg;

int midiNote;

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

// patch
BeeThree organ => JCRev r => Echo e => Echo e2 => dac;
r => dac;

// set delays
240::ms => e.max => e.delay;
480::ms => e2.max => e2.delay;
// set gains
.6 => e.gain;
.3 => e2.gain;
.05 => r.mix;
0 => organ.gain;

// infinite event loop
while( true )
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
            if (msg.which < map.cap())
            {
                map[msg.which] => midiNote;
                if (midiNote >= 0){
                    Std.mtof( midiNote + 48 ) => float freq;
                    if( freq > 20000 ) continue;

                    freq => organ.freq;
                    .5 => organ.gain;
                    1 => organ.noteOn;
                }

                80::ms => now;
            }
        }
        else
        {
            0 => organ.noteOff;
        }
    }
}
