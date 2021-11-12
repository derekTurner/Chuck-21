/* 
 Sliders and dials extend controllers
 
 Spot object displays 1-127 as red - green
 Textbox displays number message
 Add a Toggle
 
 */


class Controller {
  //properties of all controllers
  int cposX;    // Position on layout grid
  int cposY;    // Position on layout grid
  int cwidth;   // Width on layout grid
  int cheight;  // Height on layout grid
  int cpixX;    // Pixel position X
  int cpixY;    // Pixel position Y
  int cpixW;    // Pixel width 
  int cpixH;    // Pixel height
  public int valueLSB = 0;
  public int valueMSB = 0;
  boolean isGrabbed;
  boolean highRes;
  boolean isDual = false; // identifies dual controller such as Pad x-y
  int ccNumber;
  int midiChannel;
  color[] colors;
  int frameStrokeWeight;

  //constructor
  Controller(int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols ) {
  }
  void update() {
  }
  void controllerDraw() {
  }
  boolean cursorOver() {
    return false;
  }
  void setControllerPosition() {
  }
  boolean release(){
    this.isGrabbed = false;
    return false;
  }
}  


class Slider extends Controller {
  // properties of Slider controllers
  int grooveW;  // Pixel groove width
  int grooveH;  // Pixel groove height
  int knobW;    // Pixel knob width
  int knobH;    // Pixel knob height
  int baseY;    // Pixel Bottom of slider motion
  int topY;     // Pixel Top of slider motion
  int sLeft;    // Pixel Left edge of slider 
  int sRight;   // Pixel Right edge of slider
  int cpixMSB;    // Pixel slider position MSB
  int cpixLSB;     // Pixel slider position LSB
  boolean mouseOverMSB; // denotes mouse over slider knob full or MSB;
  boolean mouseOverLSB; // denote s mouse over slider knob right half or LSB 
  boolean isMSB;
  int sliderStrokeWeight; // thickness of lines drawn for slider
  color frameStroke;
  color frameFill;
  color grooveStroke;
  color grooveFill;
  color knobStroke;
  color knobFill;
  color lineStroke;



  //constructor
  Slider(int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols ) {
    super(fx, fy, fw, fh, cc, channel, isHighRes, cols);
    this.cposX = fx;   // Position on layout grid
    this.cposY = fy;   // Position on layout grid
    this.cwidth = fw;   // Width on layout grid
    this.cheight = fh; // Height on layout grid
    this.valueMSB = 0;
    this.valueLSB = 0; 
    this.highRes = isHighRes;
    this.ccNumber = cc;
    this.midiChannel = channel;
    this.update();
    this.colors = cols;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.grooveStroke = cols[2];
    this.grooveFill = cols[3];
    this.knobStroke = cols[4];
    this.knobFill   = cols[5];
    this.lineStroke   = cols[6];
  }

  void update() {// on creation or screen resize
    this.cpixX = this.cposX * grid.x;
    this.cpixY = this.cposY * grid.y;
    this.cpixW = this.cwidth * grid.x;
    this.cpixH = this.cheight * grid.y;
    this.grooveW = int(this.cpixW /8);  // scale groovewidth to container
    this.grooveH = int(this.cpixH /1.2);// scale groovewidth to container
    this.knobW   = int(this.cpixW  /1.6); // scale knob to container
    this.knobH   = int (this.cpixH/12); // scale knob to container
    this.baseY   = this.cpixY + int(this.cpixH/2)+ int(this.grooveH/2); 
    this.topY    = this.baseY - this.grooveH;
    this.sLeft   = this.cpixX  + int(this.cpixW/2)- int(this.knobW/2);
    this.sRight  = this.cpixX  + int(this.cpixW/2)+ int(this.knobW/2);
    this.frameStrokeWeight = 4;
    this.sliderStrokeWeight = 2;
  }
  // slider controller
  void controllerDraw() {
    pushMatrix();
    rectMode(CORNER);
    strokeWeight(this.frameStrokeWeight);
    stroke(this.frameStroke); 
    fill (this.frameFill);  
    translate(this.cpixX, this.cpixY);
    rect( 0, 0, this.cpixW, this.cpixH);
    translate(this.cpixW/2, this.cpixH/2);

    //Represent groove as a narrow black rectangle
    strokeWeight(this.sliderStrokeWeight);
    stroke(this.grooveStroke); //color 0
    fill(this.grooveFill); // color2
    rectMode(CENTER);
    rect(0, 0, this.grooveW, this.grooveH);
    translate(0, floor(this.grooveH/2));

    //Represent the knob as a small wide rectangle
    if (! this.highRes) { // draw single control
      stroke(this.knobStroke); 
      fill(this.knobFill);    
      rect( 0, cpixMSB, knobW, knobH);
      //Draw an index line across the centre of the knob
      stroke(this.lineStroke);  
      line(floor(-knobW/2), cpixMSB, floor(knobW/2), cpixMSB);
    } else {//draw double control

      stroke(knobStroke); // Draw MSB control
      fill(knobFill);     
      rect( -int(knobW/4), cpixMSB, int(knobW/2), knobH);
      //Draw an index line across the centre of the knob
      stroke(lineStroke);  
      line(floor(-knobW/2), cpixMSB, 0, cpixMSB);

      stroke(knobStroke); // Draw LSB control
      fill(knobFill);     
      rect(int(knobW/4), cpixLSB, floor(knobW/2), knobH);
      //Draw an index line across the centre of the knob
      stroke(lineStroke);   
      line(0, cpixLSB, floor(knobW/2), cpixLSB);
    }

    popMatrix();
  }

  boolean cursorOver() {
    // detect MouseOver
    if (mousePressed) {
      int mx = mouseX;
      int my = mouseY;
      this.mouseOverMSB = false;
      this.mouseOverLSB = false;
      if (mx>=this.sLeft) {
        if (mx <= this.sRight) {
          if (my>=this.topY-int(knobH/2)) {
            if (my <= this.baseY+int(knobH/2)) {
              if (!this.highRes) {
                this.mouseOverMSB = true;
              } else { 
                this.mouseOverMSB = (mx<=(this.cpixX+this.cpixW/2));
                this.mouseOverLSB = (!mouseOverMSB & mx<=(this.cpixX+this.cpixW));
              }
            }
          }
        }
      }
    }
    return (this.mouseOverMSB||this.mouseOverLSB);
  }

  void setControllerPosition() {
    int ypos = mouseY;
    if (this.mouseOverMSB) {
      this.cpixMSB = ypos - this.baseY;
      this.cpixMSB = min(this.cpixMSB, 0);
      this.cpixMSB = max(this.cpixMSB, -this.grooveH);
      this.valueMSB = floor(map(-this.cpixMSB, 0, this.grooveH, 0, 127));
    } else {
      this.cpixLSB = ypos - this.baseY;
      this.cpixLSB = min(this.cpixLSB, 0);
      this.cpixLSB = max(this.cpixLSB, -this.grooveH);
      this.valueLSB = floor(map(-this.cpixLSB, 0, this.grooveH, 0, 127));
    }
  }
}



class Dial extends Controller {
  //properties of dials
  int centreX;  // pixel units
  int centreY;  // pixel units
  int radius;   // pixel units
  int innerRadius; // pixel units

  color frameStroke;
  color frameFill;
  color circleStroke;
  color circleFill;
  color lineStroke;
  int   circleStrokeWeight; 
  int   lineStrokeWeight;
  float radiansMSB; 
  float radiansLSB;
  // boolean highRes;  // this is defined in controller shouldn't need it here
  float dialRatio ;   // set size of inner dial 
  boolean dMouseOver; // denotes mouse over dial
  boolean overLSB;
  boolean isGrabbed;


  //constructor
  Dial (int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols ) {
    super(fx, fy, fw, fh, cc, channel, isHighRes, cols);
    this.cposX = fx; // Position of frame on layout grid
    this.cposY = fy; // Position of frame on layout grid
    this.cwidth = fw; // Width of frame on layout grid
    this.cheight = fh;// Height of frame on layout grid
    this.valueMSB = 0;
    this.valueLSB = 0; 
    this.highRes = isHighRes;println(isHighRes);
    this.ccNumber = cc;
    this.midiChannel = channel;
    this.isGrabbed = false;
    this.frameStroke  = cols[0];
    this.frameFill    = cols[1];
    this.circleStroke = cols[4];
    this.circleFill   = cols[5];  
    this.lineStroke   = cols[6];
    this.dialRatio = 0.5;
    this.radiansMSB= 0; 
    this.radiansLSB= 0; 
    this.valueMSB = 0;
    this.valueLSB = 0;
    this.overLSB = false;
    this.update();
  }

  void update() {// on creation of screen resize
    this.cpixX = this.cposX * grid.x;    // Pixel position X
    this.cpixY = this.cposY * grid.y;    // Pixel position Y
    this.cpixW = this.cwidth * grid.x;    // Pixel width 
    this.cpixH = this.cheight * grid.y;    // Pixel height
    this.centreX = cpixX + int(cpixW/2);
    this.centreY = cpixY + int(cpixH/2);
    this.radius = int(cpixW * 0.4);
    this.innerRadius = int(this.radius * this.dialRatio);
    this.frameStrokeWeight = 4;
    this.circleStrokeWeight = 2;
    this.lineStrokeWeight = 4;
  }


  void controllerDraw() {
    pushMatrix();
    rectMode(CORNER);

    //draw frame
    strokeWeight(frameStrokeWeight);
    stroke(this.frameStroke);
    fill (this.frameFill);
    translate(this.cpixX, this.cpixY);
    rect( 0, 0, this.cpixW, this.cpixH);

    translate(int(this.cpixW/2), int(this.cpixH/2));
    rotate(-this.radiansMSB);
    stroke(this.circleStroke);
    strokeWeight(this.circleStrokeWeight);
    fill(this.circleFill);
    ellipseMode(RADIUS);
    ellipse(0, 0, this.radius, this.radius);
    strokeWeight(this.lineStrokeWeight);
    stroke(this.lineStroke);
    line(0, (- this.radius/1.8), 0, ( - this.radius + this.circleStrokeWeight) );
    if (this.highRes) {
      rotate(this.radiansMSB - radiansLSB);
      stroke(this.circleStroke);
      strokeWeight(this.circleStrokeWeight);
      fill(this.circleFill);
      // add ellipseMode
      ellipse(0, 0, this.innerRadius, this.innerRadius);
      strokeWeight(this.lineStrokeWeight);
      stroke(this.lineStroke);
      line(0, (- this.radius * this.dialRatio/1.8), 0, ( - this.radius * this.dialRatio + this.circleStrokeWeight) );
    }

    popMatrix();
  }

  boolean cursorOver() {
    int mx = mouseX;
    int my = mouseY;
    int i = 0;
    int j = 0;
    // detect MouseOver
    if (mousePressed) {
      this.dMouseOver = false;  
      this.overLSB = false;
      // mouse to centre distances
      i = mx - this.centreX;
      j = this.centreY - my;

      // if mouse is over circle
      if ((abs(i)< this.radius)& (abs(j) < this.radius)) {
        this.dMouseOver = true;
        if (highRes & (abs(i)< (this.innerRadius)) & (abs(j) < (this.innerRadius))) {
          this.overLSB = true;
        }
      }
    }   
    return this.dMouseOver;
  }

  void setControllerPosition() {
    int i = 0;
    int j = 0;
    float angle=0;

    i = mouseX - this.centreX;
    j = this.centreY - mouseY;
    float h = sqrt((i*i) + (j*j)); // hypotenuse  
    angle = asin(j/h);
    //check quadrant
    if ((i<0)&(j>=0)) {
      angle = PI - angle;
    };
    if ((i<0)&(j<0)) {
      angle =  PI - angle;
    };
    if ((i>0)&(j<0)) {
      angle = (TWO_PI) + angle;
    };
    angle = (angle + TWO_PI - HALF_PI)% TWO_PI;  // offset so zero is at top
    if (this.overLSB) {
      this.radiansLSB = angle;  
      angle = (TWO_PI - angle)%TWO_PI;// clockwise angle
      this.valueLSB = int(128*angle/TWO_PI);
    } else {
      this.radiansMSB = angle;  
      angle = (TWO_PI - angle)%TWO_PI;// clockwise angle
      this.valueMSB = int(128*angle/TWO_PI);
    }
  }
}

class Toggle extends Controller { // uses external global grid
  private  color onColor;
  private  color offColor;
  private  int bStrokeColor; 
  private  int bStrokeWeight;
  public   boolean bState ;
  private  boolean ToggleMouseOver;
  private  color frameStroke;
  private  color frameFill;
  private  int leftEdge;   // clickable area
  private  int rightEdge;  // clickable area
  private  int topEdge;    // clickable area
  private  int bottomEdge; // clickable area
  private  float ToggleFormFactor; // relate Toggle to framesize
  private  int curve; // rounding Toggle corners

  //constructor  
  Toggle (int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols ) {
    super(fx, fy, fw, fh, cc, channel, isHighRes, cols);
    this.cposX = fx; // Position of frame on layout grid
    this.cposY = fy; // Position of frame on layout grid
    this.cwidth = fw; // Width of frame on layout grid
    this.cheight = fh;// Height of frame on layout grid
    this.valueMSB = 0;// Toggle only sets LSB
    this.valueLSB = 0; 
    this.highRes = false; // Toggle can't represent 14 bits
    this.ccNumber = cc;
    this.midiChannel = channel;
    this.isGrabbed = false;
    this.ToggleMouseOver = false;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.offColor = cols[7];
    this.onColor = cols[6];
    this.bStrokeColor = cols[4]; 
    this.bState = false ;
    this.ToggleFormFactor = 0.8; // range 0.1 - 1.0
    this.curve = 7;
    this.update(); 
  }

  void update() {

    this.cpixX = this.cposX * grid.x;    // Pixel position X
    this.cpixY = this.cposY * grid.y;    // Pixel position Y
    this.cpixW = this.cwidth * grid.x;    // Pixel width 
    this.cpixH = this.cheight * grid.y;    // Pixel height
    this.leftEdge =   int(this.cpixX + (cpixW * (0.5 - ToggleFormFactor/2)));
    this.rightEdge =  int(this.cpixX + (cpixW * (0.5 + ToggleFormFactor/2)));
    this.topEdge  =   int(this.cpixY + (cpixH * (0.5 - ToggleFormFactor/2)));
    this.bottomEdge = int(this.cpixY + (cpixH * (0.5 + ToggleFormFactor/2)));
    this.frameStrokeWeight = 4;
    this.bStrokeWeight = 2;
  }

  void controllerDraw() {// Draw Toggle

    pushMatrix();
    rectMode(CORNER);

    //draw frame
    strokeWeight(frameStrokeWeight);
    stroke(this.frameStroke);
    fill (this.frameFill);
    translate(this.cpixX, this.cpixY);
    rect( 0, 0, this.cpixW, this.cpixH);
    translate(int(this.cpixW/2), int(this.cpixH/2));

    if (this.bState) {
      fill(this.onColor);
    } else {
      fill(this.offColor);
    }
    stroke(this.bStrokeColor);
    strokeWeight(this.bStrokeWeight);
    rectMode(CENTER);
    rect( 0, 0, this.cpixW * this.ToggleFormFactor, this.cpixH * this.ToggleFormFactor, this.curve);
    popMatrix();
  }

  boolean cursorOver() {
    this.ToggleMouseOver = false;
    if (mouseX>=this.leftEdge) {
      if (mouseX <= this.rightEdge) {
        if (mouseY>= this.topEdge) {
          if (mouseY <= this.bottomEdge) {
            this.ToggleMouseOver = true;            
          } 
        } 
      } 
    } 
    return this.ToggleMouseOver;
  }

  void setControllerPosition() {
    if ( this.isGrabbed){
    this.bState = !this.bState;  
    if (this.bState){this.valueLSB = 64; }else{this.valueLSB = 0;};
    this.isGrabbed = false; // can't drag mouse over a switch
    }
  }
}

class Trigger extends Controller { // uses external global grid
  private  color onColor;
  private  color offColor;
  private  int bStrokeColor; 
  private  int bStrokeWeight;
  public   boolean bState ;
  private  boolean TriggerMouseOver;
  private  color frameStroke;
  private  color frameFill;
  private  int leftEdge;   // clickable area
  private  int rightEdge;  // clickable area
  private  int topEdge;    // clickable area
  private  int bottomEdge; // clickable area
  private  float TriggerFormFactor; // relate Toggle to framesize
  private  int curve; // rounding Toggle corners

  //constructor  
  Trigger (int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols ) {
    super(fx, fy, fw, fh, cc, channel, isHighRes, cols);
    this.cposX = fx; // Position of frame on layout grid
    this.cposY = fy; // Position of frame on layout grid
    this.cwidth = fw; // Width of frame on layout grid
    this.cheight = fh;// Height of frame on layout grid
    this.valueMSB = 0;// Toggle only sets LSB
    this.valueLSB = 0; 
    this.highRes = false; // Toggle can't represent 14 bits
    this.ccNumber = cc;
    this.midiChannel = channel;
    this.isGrabbed = false;
    this.TriggerMouseOver = false;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.offColor = cols[7];
    this.onColor = cols[6];
    this.bStrokeColor = cols[4]; 
    this.bState = false ;
    this.TriggerFormFactor = 0.8; // range 0.1 - 1.0
    this.curve = 7;
    this.update(); 
  }

  void update() {

    this.cpixX = this.cposX * grid.x;    // Pixel position X
    this.cpixY = this.cposY * grid.y;    // Pixel position Y
    this.cpixW = this.cwidth * grid.x;    // Pixel width 
    this.cpixH = this.cheight * grid.y;    // Pixel height
    this.leftEdge =   int(this.cpixX + (cpixW * (0.5 - TriggerFormFactor/2)));
    this.rightEdge =  int(this.cpixX + (cpixW * (0.5 + TriggerFormFactor/2)));
    this.topEdge  =   int(this.cpixY + (cpixH * (0.5 - TriggerFormFactor/4)));
    this.bottomEdge = int(this.cpixY + (cpixH * (0.5 + TriggerFormFactor/4)));
    this.frameStrokeWeight = 4;
    this.bStrokeWeight = 2;
  }

  void controllerDraw() {// Draw Toggle

    pushMatrix();
    rectMode(CORNER);

    //draw frame
    strokeWeight(frameStrokeWeight);
    stroke(this.frameStroke);
    fill (this.frameFill);
    translate(this.cpixX, this.cpixY);
    rect( 0, 0, this.cpixW, this.cpixH);
    translate(int(this.cpixW/2), int(this.cpixH/2));

    if (this.isGrabbed) {
      fill(this.onColor);
    } else {
      fill(this.offColor);
    }
    stroke(this.bStrokeColor);
    strokeWeight(this.bStrokeWeight);
    rectMode(CENTER);
    rect( 0, 0, this.cpixW * this.TriggerFormFactor, this.cpixH * this.TriggerFormFactor/2, this.curve);
    popMatrix();
  }

  boolean cursorOver() {
    this.TriggerMouseOver = false;
    if (mouseX>=this.leftEdge) {
      if (mouseX <= this.rightEdge) {
        if (mouseY>= this.topEdge) {
          if (mouseY <= this.bottomEdge) {
            this.TriggerMouseOver = true;            
          } 
        } 
      } 
    } 
    return this.TriggerMouseOver;
  }

  void setControllerPosition() {// controlled by isGrabbed
    if ( this.isGrabbed){
    this.valueLSB = 64; 
    }
  }
  
 boolean release(){// return true if release generates ccSend
    this.isGrabbed = false;
    this.valueLSB = 0;
    return true;
  }
}




class Pad extends Controller { // uses external global grid
  // recommend minimum layout size for xy pad 18 x 18 to give full 7 bit resolution

  private  color padColor;
  private  color cursorColor;
  private  color bStrokeColor; 
  private  int bStrokeWeight;
  private  boolean PadMouseOver;
  private  color frameStroke;
  private  color frameFill;
  private  int leftEdge;   // clickable area
  private  int rightEdge;  // clickable area
  private  int topEdge;    // clickable area
  private  int bottomEdge; // clickable area
  private  float PadFormFactor; // relate Pad to framesize
  private  int cursorRadius;
  private  int padWidth;
  private  int padHeight;
  private  int xpos;      // dot position 
  private  int ypos;      // dot position


  //constructor  
  Pad (int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols ) {
    super(fx, fy, fw, fh, cc, channel, isHighRes, cols);
    this.cposX = fx; // Position of frame on layout grid
    this.cposY = fy; // Position of frame on layout grid
    this.cwidth = fw; // Width of frame on layout grid
    this.cheight = fh;// Height of frame on layout grid
    this.valueMSB = 0;// Pad stores x value 0-127 in MSB
    this.valueLSB = 0;// Pad stores y value 0-127 in LSB
    this.highRes = false; // Pad can't represent 14 bits
    this.isDual = true;   // Pad represents two 7 bit values (on ajacent controllers)
    this.ccNumber = cc;   // Pad will use cc and cc + 1 for x and y
    this.midiChannel = channel;
    this.isGrabbed = false;
    this.PadMouseOver = false;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.padColor = cols[3];
    this.bStrokeColor = cols[4]; 
    this.cursorColor = cols[5];
    this.PadFormFactor = 0.9; // range 0.1 - 1.0
    this.cursorRadius = 3;
    this.update();
  }

  void update() {

    this.cpixX = this.cposX * grid.x;    // Pixel position X
    this.cpixY = this.cposY * grid.y;    // Pixel position Y
    this.cpixW = this.cwidth * grid.x;    // Pixel width 
    this.cpixH = this.cheight * grid.y;    // Pixel height
    this.leftEdge =   int(this.cpixX + (cpixW * (0.5 - PadFormFactor/2)));
    this.rightEdge =  int(this.cpixX + (cpixW * (0.5 + PadFormFactor/2)));
    this.topEdge  =   int(this.cpixY + (cpixH * (0.5 - PadFormFactor/2)));
    this.bottomEdge = int(this.cpixY + (cpixH * (0.5 + PadFormFactor/2)));
    this.padWidth = this.rightEdge - this.leftEdge;
    this.padHeight = this.bottomEdge - this.topEdge;
    this.xpos = this.leftEdge;
    this.ypos = this.bottomEdge;
    this.frameStrokeWeight = 4;
    this.bStrokeWeight = 2;
  }

  void controllerDraw() {// Draw Pad

    pushMatrix();
    rectMode(CORNER);

    //draw frame
    strokeWeight(frameStrokeWeight);
    stroke(this.frameStroke);
    fill (this.frameFill);
    translate(this.cpixX, this.cpixY);
    rect( 0, 0, this.cpixW, this.cpixH);
    translate(int(this.cpixW/2), int(this.cpixH/2));
    fill(this.padColor);
    stroke(this.bStrokeColor);
    strokeWeight(this.bStrokeWeight);
    rectMode(CENTER);
    rect( 0, 0, this.cpixW * this.PadFormFactor, this.cpixH * this.PadFormFactor);
    popMatrix();// set translate back to origin 0,0
    pushMatrix();
    strokeWeight(0);
    fill(this.cursorColor);
    ellipseMode(RADIUS);
    ellipse(this.xpos,this.ypos,this.cursorRadius,this.cursorRadius);
    popMatrix();
  }

  boolean cursorOver() {
    this.PadMouseOver = false;
    if (mouseX>=this.leftEdge) {
      if (mouseX <= this.rightEdge) {
        if (mouseY>= this.topEdge) {
          if (mouseY <= this.bottomEdge) {
            this.PadMouseOver = true;
          }
        }
      }
    } 
    return this.PadMouseOver;
  }

  void setControllerPosition() {
    this.xpos = max(mouseX, this.leftEdge);
    this.xpos = min(xpos, this.rightEdge);
    this.ypos = max(mouseY, this.topEdge);
    this.ypos = min(ypos, this.bottomEdge);   
    this.valueMSB = round(map(xpos- this.leftEdge, 0, this.padWidth, 0, 127)); // 7 bit x position
    this.valueLSB = round(map(this.bottomEdge - ypos, 0, this.padHeight, 0, 127)); // 7 bit x position
  }
}



float radiansToDegrees(float radians) {
  return (360 * radians/ TWO_PI);
}


void ccSend(int myValue, int ccnum, int chan) {
  OscMessage myMessage = new OscMessage("/cc");
  // must now match a message format
  //myMessage.add(123); /* add an int to the osc message */
  //myMessage.add(12.34); /* add a float to the osc message */
  //myMessage.add("some text"); /* add a string to the osc message */
   // myMessage.add(new int[] {1, 2, 3, 4}); /* add a byte blob to the osc message */
  // valid osc message types not read by chuk audio
  // myMessage.add(new byte[] {0x00, 0x01, 0x10, 0x20}); /* add a byte blob to the osc message */

  myMessage.add(new int[] {myValue,ccnum,chan}); /* add an int array to the osc message */
  println("cc: ", myValue, ccnum, chan);
  // send the message 
  oscP5.send(myMessage, myRemoteLocation);
}
