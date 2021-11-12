/* 
 Spots and textboxes extend displays
 
 Spot object displays 1-127 as red - green
 Textbox displays number message
 
 */
class Display {
  //properties of all displays
  int dposX;    // Position on layout grid
  int dposY;    // Position on layout grid
  int dwidth;   // Width on layout grid
  int dheight;  // Height on layout grid
  int dpixX;    // Pixel position X
  int dpixY;    // Pixel position Y
  int dpixW;    // Pixel width 
  int dpixH;    // Pixel height
  int displayValue; //0 - 127
  color[] colors;
  boolean highRes;   

  //constructor
  Display(int fx, int fy, int fw, int fh, color[] cols) {
  }

  void update() {
  }
  void displayDraw() {
  }
  void setDisplayValue(int dv) {
  }
}  


class Spot extends Display {

  // Spot properties

  float spotScaleX;// size of spot within frame
  float spotScaleY;// size of spot within frame
  int spotRadX;  // elipse radius X pixel
  int spotRadY;  // elipse radius Y pixel
  int frameStrokeWeight; 
  color frameStroke;
  color frameFill;
  int spotStrokeWeight;
  color spotStroke;


  // Spot constructor
  Spot (int fx, int fy, int fw, int fh, color[] cols) {
    super(fx, fy, fw, fh, cols);
    this.highRes = false;   // spot only 0 - 127
    this.dposX = fx;   // position on layout grid
    this.dposY = fy;    // position on layout grid
    this.dwidth = fw;  // Width on layout grid
    this.dheight = fh;// Height on layout grid
    this.spotScaleX = 0.5;
    this.spotScaleY = 0.5;
    this.displayValue = 0;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.spotStroke = cols[3];
    this.update();
  }
  // Spot methods
  void update() {// on creation or screen resize
    this.dpixX = this.dposX * grid.x;
    this.dpixY = this.dposY * grid.y;
    this.dpixW = this.dwidth * grid.x;
    this.dpixH = this.dheight * grid.y;
    this.spotRadX = int(this.dpixW * this.spotScaleX / 2);
    this.spotRadY = int(this.dpixH * this.spotScaleY / 2);
    this.frameStrokeWeight = 4; 
    this.spotStrokeWeight = 2;
  }
  void displayDraw() {
    pushMatrix();
    rectMode(CORNER);
    strokeWeight(frameStrokeWeight);
    stroke(frameStroke);    
    fill (frameFill);
    translate(this.dpixX, this.dpixY);
    rect( 0, 0, this.dpixW, this.dpixH);
    translate(this.dpixW/2, this.dpixH/2);
    colorMode(HSB, 255); // hue saturation brightness
    fill(this.displayValue * 0.7, 255, 200);// covers red to green 0 - 127
    strokeWeight(spotStrokeWeight);
    stroke(spotStroke);
    ellipseMode(RADIUS);
    ellipse(0, 0, this.spotRadX, this.spotRadY);
    colorMode(RGB, 255);// colorMode not saved by matrix
    popMatrix();
  }

  void setDisplayValue(int dv) {
    this.displayValue = dv;
  }
}





class Textbox extends Display { //class use Capital

  private float fontSizeFactor; // relate fontsize to frame height
  private float boxSizeFactor;  // relate display box to frame size
  public int fontSize;
  public String message;
  public color frameStroke;
  public color frameFill;
  public color fillColor;
  public color strokeColor;
  public color fontColor;
  private int frameStrokeWeight;
  private int textStrokeWeight;
    

  Textbox (int fx, int fy, int fw, int fh, color[] cols) {
    super(fx, fy, fw, fh, cols);
    this.highRes = true;
    this.dposX = fx; // Position of frame on layout grid
    this.dposY = fy; // Position of frame on layout grid
    this.dwidth = fw;
    this.dheight = fh;
    this.fontSizeFactor = 0.2;// adjust to preferred appearance
    this.boxSizeFactor = 0.8; // adjust to preferred appearance
    this.message = "000";
    this.frameStroke  = cols[0];
    this.frameFill    = cols[1];
    this.fillColor    = cols[2];
    this.strokeColor  = cols[4];
    this.fontColor    = cols[5];
    this.frameStrokeWeight = 4;
    this.textStrokeWeight = 2;
    this.update();
  }
  // Textbox Methods
  void update() {
    this.dpixX = this.dposX   * grid.x;    // Pixel position X
    this.dpixY = this.dposY   * grid.y;    // Pixel position Y
    this.dpixW = this.dwidth  * grid.x;    // Pixel width 
    this.dpixH = this.dheight * grid.x;    // Pixel height
    this.fontSize = int(dpixH*fontSizeFactor);
  }
  void displayDraw() {
    pushMatrix();
    //draw frame
    strokeWeight(this.frameStrokeWeight);
    stroke(this.frameStroke);
    fill (this.frameFill);
    translate(this.dpixX, this.dpixY);
    rectMode(CORNER);
    rect( 0, 0, this.dpixW, this.dpixH);
    // draw textbox
    rectMode(CENTER);
    translate(int(this.dpixW/2), int(this.dpixH/2));
    fill(this.fillColor);
    strokeWeight(this.textStrokeWeight);
    stroke(this.strokeColor);
    rect(0, 0, this.dpixW*boxSizeFactor, this.dpixH*boxSizeFactor);
    fill(this.fontColor);
    textSize(this.fontSize);
    textAlign(CENTER, CENTER);
    text(this.message, 0, 0, this.dpixW, this.dpixH);
    popMatrix();
  }
  void setDisplayValue(int dv) {
    this.displayValue = dv;
    this.message = nf(this.displayValue, 3, 0);// format number to string
  }
}
