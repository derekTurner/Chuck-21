// chuck osc_dump.ck
// listen to all OSC messages on specified port
// just a debugging file tested and working
// chuck Sound.ck OscMonitorDev.ck



public class OscMonitor
{
    
    OscIn oin;
    9999 => oin.port;
    oin.listenAll();  // listen to all OSC messages on this port
    //oin.addAddress("/slider/1, ii"); // listen only to slider 1
    
    OscMsg msg;
    string data;
    " Ready to read OSC" => data;
    <<<data>>>;
    int gui[2]; // will store value, controller and channel from gui 
  


    function void oscGo(Sound snd){
        while(true)
        {
            oin => now;
            
            while(oin.recv(msg) != 0)
            {
                //<<<msg.address, "args: ",msg.numArgs()>>>;
                msg.address + " " + msg.typetag + " " => data;
                for(int n; n < msg.numArgs(); n++)
                {
                    if(msg.typetag.charAt(n) == 'i'){
                        Std.abs(msg.getInt(n)) => gui[n];
                        data + " " + msg.getInt(n) => data;
                    }
                    else if(msg.typetag.charAt(n) == 'f')
                        chout <= msg.getFloat(n) <= " ";
                    else if(msg.typetag.charAt(n) == 's')
                        chout <= msg.getString(n) <= " ";
                }
                <<< msg.address,": ", gui[0]," ",gui[1] >>>;
                <<<data>>>;
                snd.oscSlider( gui[0], gui[1]); 
            }
        }
    }
}

Sound snd;


OscMonitor oscmon;
spork ~ oscmon.oscGo(snd);

while(true){1::second => now;<<<"1 second loop">>>;};