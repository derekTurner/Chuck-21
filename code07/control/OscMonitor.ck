public class OscMonitor
{
 // setup osc
    OscIn oin;
    9999 => oin.port;
    oin.listenAll();
    OscMsg msg;
    int gui[2]; // will store value, controller and channel from gui 



    function void oscGo(Sound snd){  
        while(true)
        {
            oin => now;
            while(oin.recv(msg) != 0){    
                //<<<msg.address, "args: ",msg.numArgs()>>>; 
                for(int n; n < msg.numArgs(); n++){
                    if(msg.typetag.charAt(n) == 105 ){ // 105 ascii character 'i'
                        //<<<n, msg.typetag.charAt(n)>>>;
                        Std.abs(msg.getInt(n)) => gui[n];
                    }                 
                } 
                <<< msg.address,": ", gui[0]," ",gui[1] >>>;
                snd.oscSlider( gui[0], gui[1]);                                     
            }
        }  
    }  
}

// include lines below for standalone testing
/*
Sound snd;


OscMonitor oscmon;
spork ~ oscmon.oscGo(snd);

while(true){1::second => now;<<<"1 second loop">>>;};
*/