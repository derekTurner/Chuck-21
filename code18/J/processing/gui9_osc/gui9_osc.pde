/*
Audio Programming
 Week 10
 Gui 2.8
 D.P.Turner
 Gui reflects novation impulse keyboard sends midi like messages as osc to localhost:9999 listens on localhost:12000
 next step, make dials respond to osc input
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5; 
String oscRemoteIP = "127.0.0.1";
int oscRemotePort = 9999;
int oscLocalPort = 12000;

NetAddress myRemoteLocation;
LayoutGrid grid;

Controller[] controllers = new Controller[35];
Display[]    displays    = new Display[20];
Keyboard keys48;
Arrow[] arrows = new Arrow[1];
int currentControllerIndex;
int currentDisplayIndex;
color[] colorscheme = new color[8];
color bgnd;
int count;


// The following code is run only once
void setup() {
  oscP5 = new OscP5(this,oscLocalPort);
  myRemoteLocation = new NetAddress(oscRemoteIP,oscRemotePort);// listen 12000 send to 1234
  
  size(1280, 720); 
  surface.setResizable(true);
  grid = new LayoutGrid(80, 45);
  bgnd = color(#3438AA);  // hex colors;
  colorscheme [0] = color(0x00, 0x00, 0x00, 0x80);// frameStroke
  colorscheme [1] = color(0x00, 0x00, 0x00, 0x40);// frameFill
  colorscheme [2] = color(0x66, 0x69, 0xB7, 0x80);// grooveStroke : textFill
  colorscheme [3] = color(0x00, 0x00, 0x00);// grooveFill :spotStroke
  colorscheme [4] = color(0x6C, 0x62, 0x48);// knob - circle - tpggle - trigger - textStroke
  colorscheme [5] = color(0xE3, 0xD1, 0xA9);// knobFill : CircleFill : textFont
  colorscheme [6] = color(0x81, 0x28, 0x24);// lineStroke : oncolor
  colorscheme [7] = color(0x40, 0x14, 0x12, 0xA0); //off color

  // controllers set to lowres (false) to mimic keyboard controller Novation impulse
  controllers[0] = new Slider( 3, 5, 3, 20, 41, 0, false, colorscheme);// position controller and set to cc 41
  controllers[1] = new Slider( 7, 5, 3, 20, 42, 0, false, colorscheme);// position controller and set to cc 42
  controllers[2] = new Slider(11, 5, 3, 20, 43, 0, false, colorscheme);// position controller and set to cc 43
  controllers[3] = new Slider(15, 5, 3, 20, 44, 0, false, colorscheme);// position controller and set to cc 44
  controllers[4] = new Slider(19, 5, 3, 20, 45, 0, false, colorscheme);// position controller and set to cc 45
  controllers[5] = new Slider(23, 5, 3, 20, 46, 0, false, colorscheme);// position controller and set to cc 46
  controllers[6] = new Slider(27, 5, 3, 20, 47, 0, false, colorscheme);// position controller and set to cc 47
  controllers[7] = new Slider(31, 5, 3, 20, 48, 0, false, colorscheme);// position controller and set to cc 48
  controllers[8] = new Slider(37, 5, 3, 20, 49, 0, false, colorscheme);// position controller and set to cc 49
  
  
  controllers[9]  = new Dial(48,  5, 4, 4, 21, 0, false, colorscheme);// position controller and set to cc 21
  controllers[10] = new Dial(56,  5, 4, 4, 22, 0, false, colorscheme);// position controller and set to cc 22
  controllers[11] = new Dial(64,  5, 4, 4, 23, 0, false, colorscheme);// position controller and set to cc 23
  controllers[12] = new Dial(72,  5, 4, 4, 24, 0, false, colorscheme);// position controller and set to cc 24
  controllers[13] = new Dial(48, 15, 4, 4, 25, 0, false, colorscheme);// position controller and set to cc 25
  controllers[14] = new Dial(56, 15, 4, 4, 26, 0, false, colorscheme);// position controller and set to cc 26
  controllers[15] = new Dial(64, 15, 4, 4, 27, 0, false, colorscheme);// position controller and set to cc 27
  controllers[16] = new Dial(72, 15, 4, 4, 28, 0, false, colorscheme);// position controller and set to cc 28
  
  controllers[17] = new Pad (55, 20, 15, 15, 1, 0, true, colorscheme);// position controller and set to cc 1 (switch)
  //recommend minimum layout size for xy pad 18 x 18 to give full 7 bit resolution
  // make single pad after all dials and sliders as this needs two displays
  
  controllers[18] = new Toggle( 3, 26, 3, 2, 51, 0, true, colorscheme);// position controller and set to cc 51
  controllers[19] = new Toggle( 7, 26, 3, 2, 52, 0, true, colorscheme);// position controller and set to cc 12
  controllers[20] = new Toggle(11, 26, 3, 2, 53, 0, true, colorscheme);// position controller and set to cc 53
  controllers[21] = new Toggle(15, 26, 3, 2, 54, 0, true, colorscheme);// position controller and set to cc 54
  controllers[22] = new Toggle(19, 26, 3, 2, 55, 0, true, colorscheme);// position controller and set to cc 55
  controllers[23] = new Toggle(23, 26, 3, 2, 56, 0, true, colorscheme);// position controller and set to cc 56
  controllers[24] = new Toggle(27, 26, 3, 2, 57, 0, true, colorscheme);// position controller and set to cc 57
  controllers[25] = new Toggle(31, 26, 3, 2, 58, 0, true, colorscheme);// position controller and set to cc 58
  controllers[26] = new Toggle(37, 26, 3, 2, 59, 0, true, colorscheme);// position controller and set to cc 59
  
  controllers[27] = new Trigger(3, 29, 3, 3, 65, 0, true, colorscheme);// position controller and set to cc 65 (switch)
  controllers[28] = new Trigger(7, 29, 3, 3, 66, 0, true, colorscheme);// position controller and set to cc 66 (switch)
  controllers[29] = new Trigger(11, 29, 3, 3, 67, 0, true, colorscheme);// position controller and set to cc 67 (switch)
  controllers[30] = new Trigger(15, 29, 3, 3, 68, 0, true, colorscheme);// position controller and set to cc 68 (switch)
  controllers[31] = new Trigger(19, 29, 3, 3, 69, 0, true, colorscheme);// position controller and set to cc 69 (switch)
  controllers[32] = new Trigger(23, 29, 3, 3, 70, 0, true, colorscheme);// position controller and set to cc 70 (switch)
  controllers[33] = new Trigger(27, 29, 3, 3, 71, 0, true, colorscheme);// position controller and set to cc 71 (switch)
  controllers[34] = new Trigger(31, 29, 3, 3, 72, 0, true, colorscheme);// position controller and set to cc 72 (switch)

  arrows[0] = new Arrow(1, 39, 3, 2, 58, 0, true, colorscheme, 3);// count up

 

  displays[0] = new Spot(3, 1, 3, 3, colorscheme);
  displays[1] = new Spot(7, 1, 3, 3, colorscheme);
  displays[2] = new Spot(11, 1, 3, 3, colorscheme);
  displays[3] = new Spot(15, 1, 3, 3, colorscheme);
  displays[4] = new Spot(19, 1, 3, 3, colorscheme);
  displays[5] = new Spot(23, 1, 3, 3, colorscheme);
  displays[6] = new Spot(27, 1, 3, 3, colorscheme);
  displays[7] = new Spot(31, 1, 3, 3, colorscheme);
  displays[8] = new Spot(37, 1, 3, 3, colorscheme);

  displays[9] = new Textbox(48, 1, 4, 3, colorscheme);
  displays[10] = new Textbox(56, 1, 4, 3, colorscheme);
  displays[11] = new Textbox(64, 1, 4, 3, colorscheme);
  displays[12] = new Textbox(72, 1, 4, 3, colorscheme);
  displays[13] = new Textbox(48, 11, 4, 3, colorscheme);
  displays[14] = new Textbox(56, 11, 4, 3, colorscheme);
  displays[15] = new Textbox(64, 11, 4, 3, colorscheme);
  displays[16] = new Textbox(72, 11, 4, 3, colorscheme);  
  displays[17] = new Textbox(72, 22, 4, 3, colorscheme);
  displays[18] = new Textbox(72, 30, 4, 3, colorscheme);
  displays[19] = new Textbox(1, 35, 3, 3, colorscheme); displays[1].setDisplayValue(1);// midi channel for keys
  
  keys48 = new Keyboard(5, 35, 72, 12, 0, colorscheme);// midi channel 0
}

// The following code runs in a continuous loop
void draw() {
  int count;
  if (grid.gridChanged()) {  // update size of gui elements
    for (count = 0; count < controllers.length; count++) {
      controllers[count].update();
    }
    for (count = 0; count < displays.length; count++) {
      displays[count].update();
    }
    for (count = 0; count < arrows.length; count++) {
      arrows[count].update();
    }
    keys48.update();
  }
  background(bgnd);  // hex colors
  for ( count = 0; count < controllers.length; count++) {
    controllers[count].controllerDraw();
  }
  for ( count = 0; count < displays.length; count++) {
    displays[count].displayDraw();
  }
  for ( count = 0; count < arrows.length; count++) {
    arrows[count].arrowDraw();
  }
  keys48.genDraw();
}

void mousePressed() {
  //
  if (keys48.scanKeys()) return;
  int i  = 0;
  for ( i = 0; i <controllers.length; i++) {
    if (controllers[i].cursorOver()) {
      currentControllerIndex = i;
     // currentDisplayIndex = i;   
      controllers[i].isGrabbed = true;
      controllers[i].setControllerPosition(); 
      if (controllers[currentControllerIndex].isDual ) {
        ccSend(controllers[currentControllerIndex].valueMSB, controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
        ccSend(controllers[currentControllerIndex].valueLSB, 1 + controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
      }else{
        if (controllers[currentControllerIndex].highRes) {
          ccSend(controllers[i].valueMSB, controllers[i].ccNumber, controllers[i].midiChannel);
          ccSend(controllers[i].valueLSB, 32 + controllers[i].ccNumber, controllers[i].midiChannel);
        } else {
          ccSend(controllers[i].valueMSB, controllers[i].ccNumber, controllers[i].midiChannel);
        }
      }
      setDisplay();
      break;
    }
  }
  for ( i = 0; i <arrows.length; i++) {
    if (arrows[i].cursorOver()){keys48.channel = (byte)(arrows[i].value -1  );
    displays[19].setDisplayValue(arrows[i].value);
    println((byte)(arrows[i].value -1  ),arrows[i].value );
  }
  }
  
}

void mouseDragged() {
  if (currentControllerIndex != -1) {
    if (controllers[currentControllerIndex].isGrabbed) {
      controllers[currentControllerIndex].setControllerPosition();
      if (controllers[currentControllerIndex].isDual ) {
        ccSend(controllers[currentControllerIndex].valueMSB, controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
        ccSend(controllers[currentControllerIndex].valueLSB, 1 + controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
      }else{
        if (controllers[currentControllerIndex].highRes) {
          ccSend(controllers[currentControllerIndex].valueMSB, controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
          ccSend(controllers[currentControllerIndex].valueLSB, 32 + controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
        } else {
          ccSend(controllers[currentControllerIndex].valueMSB, controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel);
        }
      }
      setDisplay();
    }
  }
}

void mouseReleased() {
  boolean action = false;
  if (keys48.checkNoteOff()) return;
  if (currentControllerIndex != -1)action = controllers[currentControllerIndex].release();
  if (action) ccSend(128*controllers[currentControllerIndex].valueMSB + controllers[currentControllerIndex].valueLSB, controllers[currentControllerIndex].ccNumber, controllers[currentControllerIndex].midiChannel); 

  currentControllerIndex = -1;
  currentDisplayIndex = -1;
  
}


void setDisplay() {// allow different displays to show different calculated values
  if(currentControllerIndex < displays.length){
    if(!controllers[currentControllerIndex].isDual){ // process dial or slider
      if(controllers[currentControllerIndex].highRes && displays[currentControllerIndex].highRes) {// determine different values for different displays
        displays[currentControllerIndex].setDisplayValue(128*controllers[currentControllerIndex].valueMSB + controllers[currentControllerIndex].valueLSB);
      }else{ 
        displays[currentControllerIndex].setDisplayValue(controllers[currentControllerIndex].valueMSB);
      }
    }else{//process pads
      displays[currentControllerIndex].setDisplayValue(controllers[currentControllerIndex].valueMSB);
      displays[currentControllerIndex+1].setDisplayValue(controllers[currentControllerIndex].valueLSB);
    }  
  }
}
