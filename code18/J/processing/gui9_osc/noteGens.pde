/* 
 Keyboard is a note generator
 
 */



class NoteGen {
  //properties of all displays
  int dposX;    // Position on layout grid
  int dposY;    // Position on layout grid
  int dwidth;   // Width on layout grid
  int dheight;  // Height on layout grid
  int dpiX;    // Pixel position X
  int dpiY;    // Pixel position Y
  int dpiW;    // Pixel width 
  int dpiH;    // Pixel height
  color[] colors;
  int channel;  // midi channel

  //constructor
  NoteGen (int fx, int fy, int fw, int fh, int channel, color[] cols) {
  }

  void update() {
  }
  void genDraw() {
  }
}

class Keyboard extends NoteGen {

  color frameStroke;
  color frameFill;
  int   frameStrokeWeight;
  byte  velocity = 99;
  int   octaveCount;
  int   octaveMax;
  int   keyWidth;
  int   keyHeight;
  Octave[] octaves;
  int   offset; // to centre display
  byte  keyDown = 0;
  byte  lastKeyDown = 0;
  byte  channel = 0;
  boolean mouseOver;


  Keyboard(int fx, int fy, int fw, int fh, int channel, color[] cols) {
    super(fx, fy, fw, fh, channel, cols);
    this.dposX = fx;   // position on layout grid
    this.dposY = fy;    // position on layout grid
    this.dwidth = fw;  // Width on layout grid
    this.dheight = fh;// Height on layout grid
    this.dpiX = this.dposX * grid.x;
    this.dpiY = this.dposY * grid.y;
    this.dpiW = this.dwidth * grid.x;
    this.dpiH = this.dheight * grid.y;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.velocity = 100;
    this.octaveCount = 0;
    this.octaveMax = 4;
    this.keyWidth = floor(this.dpiW/(this.octaveMax * 7));
    this.keyHeight = floor(this.dpiH* 0.9);
    this.offset = floor((dpiW - (octaveMax * 7 * keyWidth))*0.5);
    this.octaves = new Octave[this.octaveMax];
    for (this.octaveCount = 0; this.octaveCount < this.octaveMax; this.octaveCount ++) {
      octaves[octaveCount] = new Octave(octaveCount+3, this.offset+( this.keyWidth * 7 * octaveCount), 0, keyWidth, keyHeight );
    }
  } 
  void update() {  // not needed on create, just for screen resize
    this.dpiX = this.dposX * grid.x;
    this.dpiY = this.dposY * grid.y;
    this.dpiW = this.dwidth * grid.x;
    this.dpiH = this.dheight * grid.y;
    this.keyWidth = floor(this.dpiW/(this.octaveMax * 7));
    this.keyHeight = floor(this.dpiH* 0.9);
    this.offset = floor((dpiW - (octaveMax * 7 * keyWidth))*0.5);
    this.frameStrokeWeight = 4;
    for (this.octaveCount = 0; this.octaveCount < this.octaveMax; this.octaveCount ++) {
      octaves[octaveCount].changeSize(octaveCount+3, this.offset + ( this.keyWidth * 7 * octaveCount), 0, keyWidth, keyHeight ) ;
    }
  }
  void genDraw() {
    pushMatrix();
    // draw frame
    rectMode(CORNER);
    strokeWeight(frameStrokeWeight);
    stroke(frameStroke);    
    fill (frameFill);
    translate(this.dpiX, this.dpiY);
    rect( 0, 0, this.dpiW, this.dpiH);
    for (this.octaveCount = 0; this.octaveCount < this.octaveMax; this.octaveCount ++) {
      octaves[octaveCount].sketchOct();
    }


    popMatrix();
  }

  boolean scanKeys() {
    
    byte scan = 0;
    if (this.overKeyboard()){
         
      this.keyDown = 0;
      for (this.octaveCount = 0; this.octaveCount < this.octaveMax; this.octaveCount ++) {
        scan = octaves[octaveCount].scanOct(mouseX - this.dpiX, mouseY - this.dpiY);      
        if (scan != 0){this.keyDown = scan; break;}    
      }
  
      if(this.keyDown != 0){     
        if (this.lastKeyDown != 0){noteOffSend();delay(15);}
        this.noteOnSend();
        return true;
      }
    }
    return false;
  }
  
  boolean overKeyboard() {
    // mx and my are current mouse position
    if ( (mouseX > this.dpiX )&&(mouseX<this.dpiX + this.dpiW)) {      

      // if mouse is in slider range 
      if ( (mouseY >= this.dpiY)&&(mouseY <= this.dpiY + this.dpiW)) {
        return true;
      }
    }
    return false;
  } 
  
  boolean checkNoteOff(){ //note off if mouse released anywhere over keyboard
    if((this.lastKeyDown != 0)){
      if (overKeyboard()){noteOffSend(); return true;}
    }
    return false;
  }

  void noteOnSend() {
    OscMessage myMessage = new OscMessage("/note");
    // use on = 1 for note on on = 0 for note off
    byte [] message = new byte[3];   
    final byte noteon  = byte(0x90);   // note on

    message[0]=(byte(noteon | this.channel));     // note on and channel
    message[1]=(byte(this.keyDown  & 0x7F));      // note number 1 - 127
    message[2]=(byte(this.velocity & 0x7F));      // velocity 1 - 127

    myMessage.add(new int[] {int(message[0]),int(message[1]),int(message[2])}); /* add an int array to the osc message */
    println("note|channel:", int(message[0]), " note:", message[1], " velocity:", message[2]); 
    oscP5.send(myMessage, myRemoteLocation);
    this.lastKeyDown = this.keyDown ; 
  }
  
    void noteOffSend() {
    OscMessage myMessage = new OscMessage("/note");
    // use on = 1 for note on on = 0 for note off
    byte [] message = new byte[3];   
    final byte noteoff = byte(0x80);  // note off

      message[0]=(byte(noteoff | this.channel )); // note off and channel
      message[1]=(byte(this.lastKeyDown & 0x7F));          // note number 1 - 127
      message[2]=(byte(0x00));                    // velocity 0
      this.lastKeyDown = 0;
    
    myMessage.add(new int[] {int(message[0]),int(message[1]),int(message[2])}); /* add an int array to the osc message */
    println("note|channel:", int(message[0]), " note:", message[1], " velocity:", message[2]); 
    oscP5.send(myMessage, myRemoteLocation);
  }
  
}




class Octave {    
  // define properties
  int x;   
  int y;   
  int w;
  int h;
  int blackKeyWidth;
  int blackKeyHeight;
  int oct;
  int fillColor;
  int strokeColor;
  boolean overKey;
  byte noteNumber;
  Key [] keys = new Key[12];

  final int whiteColor = #F2EFD0;
  final int whiteStroke = #767671;
  final int blackColor = #393938;
  final int blackStroke = #0D0D0D;

  // constructor function initialise properties
  Octave(int octaveNumber, int x1, int y1, int keyWidth, int keyHeight) 
  {
    this.x = x1;   
    this.y = y1;   
    this.w = keyWidth;
    this.h = keyHeight;
    this.blackKeyWidth = int(keyWidth * 0.55);
    this.blackKeyHeight = int(keyHeight * 0.6);
    this.oct = octaveNumber;

    this.keys[0]  = new Key(this.x + 0, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct)); 
    this.keys[1]  = new Key(this.x + 1 * keyWidth, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct + 2));
    this.keys[2]  = new Key(this.x + 2 * keyWidth, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct +4)); 
    this.keys[3]  = new Key(this.x + 3 * keyWidth, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct + 5));
    this.keys[4]  = new Key(this.x + 4 * keyWidth, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct +7)); 
    this.keys[5]  = new Key(this.x + 5 * keyWidth, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct + 9));
    this.keys[6]  = new Key(this.x + 6 * keyWidth, 0, keyWidth, keyHeight, whiteColor, whiteStroke, byte(12*oct + 11));
    this.keys[7]  = new Key(this.x + int(1 * keyWidth - 0.6 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight, blackColor, blackStroke, byte(12*oct + 1));
    this.keys[8]  = new Key(this.x + int(2 * keyWidth - 0.4 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight, blackColor, blackStroke, byte(12*oct + 3));
    this.keys[9]  = new Key(this.x + int(4 * keyWidth - 0.6 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight, blackColor, blackStroke, byte(12*oct + 6));
    this.keys[10] = new Key(this.x + int(5 * keyWidth - 0.5 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight, blackColor, blackStroke, byte(12*oct + 8));
    this.keys[11] = new Key(this.x + int(6 * keyWidth - 0.4 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight, blackColor, blackStroke, byte(12*oct + 10));
  }
  // define methods
  void changeSize(int octaveNumber, int x1, int y1, int keyWidth, int keyHeight) {
    this.x = x1;   
    this.y = y1; 
    this.w = keyWidth;
    this.h = keyHeight;
    this.blackKeyWidth = int(keyWidth * 0.55);
    this.blackKeyHeight = int(keyHeight * 0.6);
    this.oct = octaveNumber;
    this.keys[0].keyResize(this.x + 0, 0, keyWidth, keyHeight); 
    this.keys[1].keyResize(this.x + 1 * keyWidth, 0, keyWidth, keyHeight);
    this.keys[2].keyResize(this.x + 2 * keyWidth, 0, keyWidth, keyHeight); 
    this.keys[3].keyResize(this.x + 3 * keyWidth, 0, keyWidth, keyHeight);
    this.keys[4].keyResize(this.x + 4 * keyWidth, 0, keyWidth, keyHeight); 
    this.keys[5].keyResize(this.x + 5 * keyWidth, 0, keyWidth, keyHeight);
    this.keys[6].keyResize(this.x + 6 * keyWidth, 0, keyWidth, keyHeight);
    this.keys[7].keyResize(this.x + int(1 * keyWidth - 0.6 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight);
    this.keys[8].keyResize(this.x + int(2 * keyWidth - 0.4 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight);
    this.keys[9].keyResize(this.x + int(4 * keyWidth - 0.6 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight);
    this.keys[10].keyResize(this.x + int(5 * keyWidth - 0.5 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight);
    this.keys[11].keyResize(this.x + int(6 * keyWidth - 0.4 * blackKeyWidth), 0, blackKeyWidth, blackKeyHeight);
  }

  void sketchOct() {
    int count = 0;
    for (count = 0; count < keys.length; count++) {
      this.keys[count].sketchKey();
    }
  }
  
  byte scanOct(int x, int y) {
    int count = 0;
    int keyIndex = 0;
    byte noteKeyed = 0;
    // check black keys first so that they lie over white keys
    for (count = 0; count < this.keys.length; count ++) {
      keyIndex = (count+7)%12;
      noteKeyed = this.keys[keyIndex].overKey(x, y);
      if (noteKeyed != 0) {
        return noteKeyed;
      }
    }
    return 0;
  }
}


class Key {    
  // define properties
  int x;   
  int y;   
  int w;
  int h;
  int fillColor;
  int strokeColor;
  int keyStrokeWeight;
  boolean overKey;
  byte noteNumber;

  // constructor function initialise properties
  Key(int x1, int y1, int keyWidth, int keyHeight, 
    int keyFill, int keyStroke, byte nn) {
    this.x = x1;   
    this.y = y1;   
    this.w = keyWidth;
    this.h = keyHeight;
    this.fillColor = keyFill;
    this.keyStrokeWeight = 1;
    this.strokeColor = keyStroke;
    this.noteNumber = nn;
  }
  // define methods
  void keyResize(int x1, int y1, int keyWidth, int keyHeight) {
    this.x = x1;   
    this.y = y1;   
    this.w = keyWidth;
    this.h = keyHeight;
  }


  void sketchKey() {

    fill(this.fillColor);
    strokeWeight(this.keyStrokeWeight);
    stroke(this.strokeColor);
    rect(this.x, this.y, this.w, this.h);
  }
  byte overKey(int mx, int my) {
    // mx and my are current mouse position
    if ( (mx > x)&&(mx<x + w)) {      

      // if mouse is in slider range 
      if ( (my >= y)&&(my <= y + h)) {
        return this.noteNumber;
      }
    }
    return 0;
  } 

}
