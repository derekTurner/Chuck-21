class Arrow extends Controller { // uses external global grid


  int cposX;    // Position on layout grid
  int cposY;    // Position on layout grid
  int cwidth;   // Width on layout grid
  int cheight;  // Height on layout grid
  int cpixX;    // Pixel position X
  int cpixY;    // Pixel position Y
  int cpixW;    // Pixel width 
  int cpixH;    // Pixel height
  int cpixS;    // pixel spacing
  boolean isGrabbed;
  color[] colors;
  int frameStrokeWeight;

  private  color onColor;
  private  color offColor;
  private  int bStrokeColor; 
  private  int bStrokeWeight;
  public   boolean bState ;
  private  color frameStroke;
  private  color frameFill;
  private  int upLeftEdge;   // clickable area
  private  int upRightEdge;  // clickable area
  private  int upTopEdge;    // clickable area
  private  int upBottomEdge; // clickable area
  private  int downLeftEdge;   // clickable area
  private  int downRightEdge;  // clickable area
  private  int downTopEdge;    // clickable area
  private  int downBottomEdge; // clickable area
  private  int spacing;
  private  float ToggleFormFactor; // relate Toggle to framesize
  private  int curve; // rounding Toggle corners
  private  byte value;

  //constructor  
  Arrow (int fx, int fy, int fw, int fh, int cc, int channel, boolean isHighRes, color[] cols, int spacing ) {
    super(fx, fy, fw, fh, cc, channel, isHighRes, cols);
    this.cposX = fx; // Position of frame on layout grid
    this.cposY = fy; // Position of frame on layout grid
    this.cwidth = fw; // Width of frame on layout grid
    this.cheight = fh;// Height of frame on layout grid
    this.spacing = spacing;
    this.value = 0; 
    this.isGrabbed = false;
    this.frameStroke = cols[0];
    this.frameFill = cols[1];
    this.offColor = cols[7];
    this.onColor = cols[6];
    this.bStrokeColor = cols[4]; 
    this.bState = false ;
    this.ToggleFormFactor = 0.8; // range 0.1 - 1.0
    this.curve = 7;
    this.update(); 
    this.value = 1;
 
  }

  void update() {

    this.cpixX = this.cposX * grid.x;      // Pixel position X
    this.cpixY = this.cposY * grid.y;      // Pixel position Y
    this.cpixW = this.cwidth * grid.x;     // Pixel width 
    this.cpixH = this.cheight * grid.y;    // Pixel height
    this.cpixS = this.spacing * grid.y;    // Pixel spacing
    this.upLeftEdge =   int(this.cpixX + (cpixW * (0.5 - ToggleFormFactor/2)));
    this.upRightEdge =  int(this.cpixX + (cpixW * (0.5 + ToggleFormFactor/2)));
    this.upTopEdge  =   int(this.cpixY + (cpixH * (0.5 - ToggleFormFactor/2)));
    this.upBottomEdge = int(this.cpixY + (cpixH * (0.5 + ToggleFormFactor/2)));
    
    this.downLeftEdge =   this.upLeftEdge;
    this.downRightEdge =  this.upRightEdge;
    this.downTopEdge  =   this.upTopEdge + cpixS;
    this.downBottomEdge = this.upBottomEdge + cpixS;
    
    this.frameStrokeWeight = 4;
    this.bStrokeWeight = 2;
  }

  void arrowDraw() {// Draw Arrow

    pushMatrix();
    rectMode(CORNER);

    //draw frame
    strokeWeight(frameStrokeWeight);
    stroke(this.frameStroke);
    fill (this.frameFill);
    translate(this.cpixX, this.cpixY);
    
    
      triangle(0 + this.cpixW/2, 0, this.cpixW, this.cpixH , 0, this.cpixH );//up 
      triangle( + this.cpixW/2,this.cpixH + this.cpixS, this.cpixW, this.cpixS, 0,  + cpixS); //down
    
    
    translate(int(this.cpixW/2), int(this.cpixH/2));

    if (this.bState) {
      fill(this.onColor);
    } else {
      fill(this.offColor);
    }
    popMatrix();
  }

  boolean cursorOver() {
    boolean over = false;
    //test up arrow
    if (mouseX>=this.upLeftEdge) {
      if (mouseX <= this.upRightEdge) {
        if (mouseY>= this.upTopEdge) {
          if (mouseY <= this.upBottomEdge) {
            over = true;
            this.value ++;
            if (this.value == 17){this.value = 1;}
            return over;
          } 
        } 
      } 
    } 
    // test down arrow
    if (mouseX>=this.downLeftEdge) {
      if (mouseX <= this.downRightEdge) {
        if (mouseY>= this.downTopEdge) {
          if (mouseY <= this.downBottomEdge) {
            over = true;
            this.value--;
            if (this.value == 0){this.value = 16;}
            return over;
          } 
        } 
      } 
    } 
    
    return over;
  }

  void setControllerPosition() {
    if ( this.isGrabbed){
    this.bState = !this.bState;  
    if (this.bState){this.valueLSB = 64; }else{this.valueLSB = 0;};
    this.isGrabbed = false; // can't drag mouse over a switch
    }
  }
}
