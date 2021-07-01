// chuck osc_dump.ck
// listen to all OSC messages on specified port

OscIn oin;
9999 => oin.port;
oin.listenAll();  // listen to all OSC messages on this port
//oin.addAddress("/slider/1, ii"); // listen only to slider 1


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

