class LayoutGrid {
  //properties  
  int gridx;
  int gridy;
  int x;
  int y;
  int prevWidth;
  int prevHeight;
  boolean gridChange;

  // constructor
  LayoutGrid (int resx, int resy) {
    gridx = resx;
    gridy = resy;
    x = int(width/gridx);
    y = int(height/gridy);
    prevWidth = width;
    prevHeight = height;
    gridChange = false;
  }

  boolean gridChanged() {
    this.gridChange = ((this.prevWidth != width)||(this.prevHeight != height));
    if (this.gridChange) {
      this.x = width/this.gridx;
      this.y = height/this.gridy;
      this.prevWidth = width; 
      this.prevHeight = height;
    }
    return this.gridChange;
  }
}
