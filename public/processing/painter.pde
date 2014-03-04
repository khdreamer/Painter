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
  layer.background(0, 0); // create transparent layer
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
    currentLayerIdx = toWhere;
    renderLayers();

  }

}

void renderLayers(){

  background(0, 0);
  for(int i = 0; i < layers.size(); i++){

    layer = layers.get(i);
    image(layer, 0, 0);

  }

}

void createBG(){

  bg = createGraphics(WIDTH, HEIGHT, RENDER);
  bg.beginDraw();
  bg.smooth(8);
  bg.background(0, 0);
  bg.endDraw();

}

/******* Private *******/

// setup and draw
  
void setup(){

  size(WIDTH, HEIGHT);
  background(0, 0);

  // the default layer
  layers = new ArrayList<PGraphics>();
  PGraphics layer = createGraphics(WIDTH, HEIGHT, RENDER);
  layer.beginDraw();
  layer.smooth(8);
  layer.background(unhex(BG_COLOR));
  layer.endDraw();
  if(layers.size()==0)
    layers.add(layer);
  else
    layers.set(0, layer);
  
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

void eraseCircle(cX, cY, radius){

  for(int x = (int)(cX - radius); x <= (int)(cX + radius); x++){

    for(int y = (int)(cY - radius); y <= (int)(cY + radius); y++){

      float distance = dist(x, y, cX, cY);
      if (distance <= radius) 
        layer.pixels[(int)(y)*window.sketch_w+(int)(x)] = color(0, 0);

    }

  }

}

void eraser(layer){

  layer.loadPixels();
  if(mousePressed){

    int radius = window.params.size.eraser/2;

    if(abs(mX - pmX) > abs(mY - pmY)){

      for(int cX = min(mX, pmX); cX <= max(mX, pmX); cX++){

        int cY = (cX-pmX)*(mY - pmY)/(mX - pmX) + pmY;
        eraseCircle(cX, cY, radius);
        
      }

    }
    else{

      for(int cY = min(mY, pmY); cY <= max(mY, pmY); cY++){

        int cX = (cY-pmY)*(mX - pmX)/(mY - pmY) + pmX;
        eraseCircle(cX, cY, radius);
        
      }

    }
    

  }
  layer.updatePixels();

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


