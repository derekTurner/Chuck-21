// chuck osc_dump.ck
// listen to all OSC messages on specified port

OscIn oin;
if(me.args()) me.arg(0) => Std.atoi => oin.port;
else 9999 => oin.port;
oin.listenAll();

OscMsg msg;
string data;
" Ready to read OSC" => data;
<<<data>>>;

while(true)
{
    oin => now;
    
    while(oin.recv(msg) != 0)
    {
        //<<<msg.address, "args: ",msg.numArgs()>>>;
        msg.address + " " + msg.typetag + " " => data;
        for(int n; n < msg.numArgs(); n++)
        {
            if(msg.typetag.charAt(n) == 'i')
                data + " " + msg.getInt(n) => data;
            else if(msg.typetag.charAt(n) == 'f')
                chout <= msg.getFloat(n) <= " ";
            else if(msg.typetag.charAt(n) == 's')
                chout <= msg.getString(n) <= " ";
        }
        
        <<<data>>>;
    }
}

