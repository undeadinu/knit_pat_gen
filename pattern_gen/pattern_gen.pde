import controlP5.*;

ControlP5 cp5;
PImage img;
// DropdownList presetSelector;
Range range;
int row = 100;
int column = 100;
boolean [][] pixelBool = new boolean [row][column];
int rectSize = 500;
int res = rectSize/row;
int horizonMargin = 20;
int topMargin = 20;
int bottomMargin = 60;
int colorVal;
int maxInterval = 10000;
int interval = 1000;
boolean [] materialArray = new boolean [maxInterval];

int element_0 = 10; 
int element_1 = 20;
int rangeLimit = 100;

void setup() {
  size(rectSize + horizonMargin*2, rectSize + topMargin +bottomMargin);
  colorMode(RGB);
  cp5 = new ControlP5(this);
  // presetSelector = cp5.addDropdownList("presetSelector")
  //         .setPosition(horizonMargin, 40)
  //         .setSize(100,230)
  //         ;
  range = cp5.addRange("rangeController")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(horizonMargin, rectSize + topMargin+20)
        .setSize(240, 20)
          .setHandleSize(20)
            .setRange(0, rangeLimit)
              .setRangeValues(element_0, element_1)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  .setColorForeground(color(64, 124, 255, 90))
                    .setColorBackground(color(0, 10, 100, 80))  
                      ;        

  cp5.addButton("export_image")
    .setPosition(rectSize-70, rectSize+topMargin+20)
      .setSize(90, 20)
        .setColorBackground(color(0, 10, 100, 80))
          ;
  // customize(presetSelector); // customize the first list
  img = createImage(row, column, HSB);
  textSize(10);
  for (int i=0; i<interval; i++) {
    if (i%element_1 < element_0) materialArray[i] = true;
    else materialArray[i] = false;
  }
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("rangeController")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    element_0 = int(theControlEvent.getController().getArrayValue(0));
    element_1 = int(theControlEvent.getController().getArrayValue(1));
    println("range update, done.");
  }
  for (int i=0; i<interval; i++) {
    if (i%element_1 < element_0) materialArray[i] = true;
    else materialArray[i] = false;
  }
}

void draw() {
  background(96);
  // fill(255);
  // text("pattern generator for machine knitting", 30, 20);

  //make a gingham check for default


  //make a pixel array
  for (int i=0; i<row; i++) {
    for (int j=0; j<column; j++) {
      pixelBool[i][j] = materialArray[ (i*row+j) % interval ];
    }
  }

  //draw the pixel array
  for (int i=0; i<row; i++) {
    for (int j=0; j<column; j++) {
      if (i*row + j < interval) {
        stroke(192);
        if (pixelBool[i][j] == true) colorVal = 200;
        else colorVal = 50;
      }
      else {
        stroke(64);
        if (pixelBool[i][j] == true) colorVal = 255;
        else colorVal = 0;
      }
      fill(colorVal);
      rect(horizonMargin+j*res, topMargin+i*res, res, res);
    }
  }
  stroke(64);

  //display the small image to export
  img.loadPixels();
  for (int i=0; i<row; i++) {
    for (int j=0; j<column; j++) {
      if (pixelBool[i][j]) img.pixels[i*row+j] = color(255);
      else img.pixels[i*row+j] = color(0);
    }
  }
  img.updatePixels();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && interval < maxInterval) interval++;
    if (keyCode == LEFT && interval > 1) interval--;	
    if (keyCode == DOWN && interval < maxInterval) interval+=row;
    if (keyCode == UP && interval > row) interval-=row;
  }
  boolean [] materialArray = new boolean [interval];
}

void mousePressed() {
  if (mouseX >= horizonMargin 
    && mouseX <= rectSize + horizonMargin
    && mouseY >= topMargin 
    && mouseY <= rectSize + topMargin) {
    int xPos = (mouseX - horizonMargin) / res;
    int yPos = (mouseY - topMargin) / res;
    int xyPos = yPos*row + xPos;
    if ((xyPos) > interval) {
      xyPos = xyPos % interval;
    }
    materialArray[xyPos] = !materialArray[xyPos];
  }
}

void export_image() {
  selectOutput("Select a file to write to:", "fileOutput");
}

void fileOutput(File selection) {
  if (selection != null) {
    println("User selected " + selection.getAbsolutePath());
    img.save(selection.getAbsolutePath() + ".jpg");
    println("done saving");
  }
}


