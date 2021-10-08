// Use keyboard Human interface device to play sound in separate file.
// chuck Sound.ck keyorganAll.ck

Hid hi;
HidMsg msg;
0.4 => float keyGain;

// which keyboard
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( device ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

// Use sound patch here with external class file
Sound snd => dac;
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
            Std.mtof( msg.which + 45 ) => snd.setFreq;
            keyGain => snd.noteOn;
            80::ms => now;
        }
        else
        {
            0.0 => snd.noteOff;
        }
    }
}
