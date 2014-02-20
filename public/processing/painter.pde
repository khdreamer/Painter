/* @pjs preload="/images/transp_bg.png"; */
/* @pjs font="Arial.ttf"; */
/* @pjs transparent="true"; */

/******* Constants *******/

RENDER = "JAVA2D";
BG_COLOR = "ff252525";
WIDTH = window.sketch_w;
HEIGHT = window.sketch_h;

/******* Public *******/

PGraphics bg;
selectedC = 0;

// layers
currentLayerIdx = 0;
ArrayList<PGraphics> layers;

/* Parameters function */

public void setupDone(){

  BG_COLOR = "ffffffff";
  WIDTH = window.sketch_w;
  HEIGHT = window.sketch_h;

  setup();

}

public void changeColor(c){

  selectedC = unhex(c);

}

/* Layers function */

public void changeCurrentLayerIdx(i){

  currentLayerIdx = i;

}

public void createLayer(int aboveWhich){

  PGraphics layer = createGraphics(WIDTH, HEIGHT, RENDER);
  layer.beginDraw();
  layer.smooth(8);
  layer.background(255, 0); // create transparent layer
  layer.endDraw();
  layers.add(aboveWhich+1, layer);
  currentLayerIdx = aboveWhich+1;
  renderLayers();

}

public void deleteLayer(int idx){

  console.log("delete: " + idx);
  layers.remove(idx);
  currentLayerIdx--;
  if(currentLayerIdx < 0) currentLayerIdx = 0;
  renderLayers();

}

public void changeLayerOrder(int which, int toWhere){

  console.log(which, toWhere);
  if(which != toWhere && which != -1 && toWhere != -1){

    PGraphics tmp = layers.get(which);
    layers.remove(which);
    layers.add(toWhere, tmp);
    renderLayers();

  }

}

void renderLayers(){

  image(bg, 0, 0);
  for(int i = 0; i < layers.size(); i++){

    layer = layers.get(i);
    image(layer, 0, 0);

  }

}

void createBG(){

  bg = createGraphics(WIDTH, HEIGHT, RENDER);
  bg.beginDraw();
  bg.smooth(8);
  bg.background(255, 0, 0);
  bg.endDraw();

}

/******* Private *******/

// setup and draw
  
void setup(){

  size(WIDTH, HEIGHT);

  // bg = createGraphics(WIDTH, HEIGHT, RENDER);
  // bg.beginDraw();
  // bg.background(255, 0, 0);
  // bg.endDraw();
  // background(bg);

  layers = new ArrayList<PGraphics>();
  PGraphics layer = createGraphics(WIDTH, HEIGHT, RENDER);
  layer.beginDraw();
  layer.smooth(8);
  // layer.background(255, 0);
  layer.background(unhex(BG_COLOR));
  layer.endDraw();
  if(layers.size()==0)
    layers.add(layer);
  else
    layers.set(0, layer);
  
  createBG();
  renderLayers();

}

void draw(){

  // layer
  PGraphics layer = layers.get(currentLayerIdx);
  layer.beginDraw();
  layer.smooth();

  // zoom
  mX = mouseX / window.params.size.zoom;
  mY = mouseY / window.params.size.zoom;
  pmX = pmouseX / window.params.size.zoom;
  pmY = pmouseY / window.params.size.zoom;
  // functions
  switch(window.selected){
    case "brush":
      brush(layer);
      break;
    case "eraser":
      eraser(layer);
      break;
    case "text":
      text(layer);
      break;
    case "spray":
      spray(layer);
      break;
    default:
      break;
  }
  layer.endDraw();
  renderLayers();

}

void mousePressed(){

}

void mouseReleased(){

  // TODO: save current img into an array

}

/******* Custom Functions *******/

// Brush

void brush(layer){

  layer.stroke(selectedC);
  layer.strokeWeight(window.params.size.brush);
  if(mousePressed){

    layer.line(pmX, pmY, mX, mY);
   
  }

}

// Eraser

void eraser(layer){

  layer.loadPixels();
  if(mousePressed){

    int radius = window.params.size.eraser/2;
    for(int x = (int)(mX - radius); x <= (int)(mX + radius); x++){

      for(int y = (int)(mY - radius); y <= (int)(mY + radius); y++){

        float distance = dist(x, y, mX, mY);
        if (distance <= radius) 
          layer.pixels[(int)(y)*window.sketch_w+(int)(x)] = color(0, 0);

      }

    }

  }
  layer.updatePixels();

  // layer.stroke(255);
  // layer.strokeWeight(window.params.size.eraser);
  // if(mousePressed){

  //   if(!preMouseX) preMouseX = mX;
  //   if(!preMouseY) preMouseY = mY;

  //   layer.line(preMouseX, preMouseY, mX, mY);
  //   preMouseX = mX;
  //   preMouseY = mY;

  // }
  // else{

  //   preMouseX = null;
  //   preMouseY = null;

  // }

}

// Text

void text(layer){
  
  PFont font;
  font = createFont("Arial", 12, true); 
  textFont(font, 12);
  layer.fill(selectedC);
  if(mousePressed){

    // crashes. fuq
    layer.text("word", mX, mY);
  
  }

}

// Spray

void spray(layer){

  layer.loadPixels();
  if(mousePressed){

    int s = window.params.size.spray;
    int h = window.params.hardness.spray;
    int n = s*s *h /100;
    // console.log("s: " + s + " h: " + h + " n: " + n );

    layer.stroke(selectedC);
    for (int i = 0; i <= n; i++) {

      float r = random(s);
      float th = random(TWO_PI);

      x = r*cos(th) + mX;
      y = r*sin(th) + mY;

      // layer.set(x, y, color(red(selectedC), green(selectedC), blue(selectedC)));
      layer.pixels[(int)(y)*window.sketch_w+(int)(x)] 
        = color(red(selectedC), green(selectedC), blue(selectedC));

    }
  }
  layer.updatePixels();

}


