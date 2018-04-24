class Links {
 
  boolean isHovering;
  float textWidth;
  int textHeight;
  int xpos, ypos;
  int textFile;
  
  Links(int xpos_, int ypos_, float textWidth_, int textHeight_, int textFile_) {
    textWidth = textWidth_;
    textHeight = textHeight_;
    xpos = xpos_;
    ypos = ypos_;
    textFile = textFile_;
    }
  
  int textSelector() {  
    return textFile;
  }
    
  void clickableArea() {
    noFill();
    noStroke();
    rect(xpos, ypos, textWidth, textHeight);
  }
  boolean isInside() {
    return isHovering = mouseX > xpos & mouseX < (xpos+textWidth) & mouseY > ypos & mouseY < (ypos + textHeight);
  }
}
