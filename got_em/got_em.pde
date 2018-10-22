//this is from processing example

// Gravity acts at the shape's acceleration
BallLauncher happyBalls;
float globalSpeed = 2.1;
int count;
int freq;

Lines surfaces = new Lines();
int x1; // realtime starting x
int y1; // realtime starting y
int x2; // realtime ending x
int y2; //realtime ending y
int radius; // radius of balls;
boolean clicked = false;
boolean released = false;
PVector[] coords;
PVector[] all_lines;
int curr_line = 0;

void setup() {
  size(640, 640);
  radius = 20;
  happyBalls = new BallLauncher(new PVector(0, height), radius);
  freq = 50;
  count = 50;
  clicked = false;
  released = true;
}

void draw() {
  background(0);                               //this sets the screen to black for every frame


  if (mousePressed == true && !clicked) {      //if mouse is pressed record the coordinates
    x1 = mouseX;
    y1 = mouseY;
    clicked = true;
    released = false;

  }

  else if (mousePressed == false && !released) {    //when it is released record those coordinates
    x2 = mouseX;
    y2 = mouseY;
    clicked = false;
    released = true;
    surfaces.addLine(x1, y1, x2, y2);        //add line to surfaces arraylist
    
    
    curr_line += 1;
  }
  stroke(255);
  surfaces.printLines();                    //function reprints the surfaces

  if (count == freq) {
    happyBalls.addBall();
    count = 0;
  }
  happyBalls.run();
  count++;
}


class BallLauncher {
  ArrayList<Ball> balls;
  PVector origin; 
  int radius;
  ArrayList<Surface> ourLines;

  BallLauncher(PVector position, int radius) {
    origin = position.copy();
    balls = new ArrayList<Ball>();
    this.radius = radius;
    ourLines = surfaces.ourLines;
  }

  void addBall() {
    balls.add(new Ball(origin, radius));
  }
  
  
  void run() {
    for (int i = balls.size()-1; i >= 0; i--) {
      Ball b = balls.get(i);
      if (b.offScreen) {
        balls.remove(i);
      } else {
        b.run();
      }
      // System.out.println(balls.size());
    }
  }
}

class Lines {
  ArrayList<Surface> ourLines;     // Data Structure that collects lines that are being drawn

  Lines() {
    ourLines = new ArrayList<Surface>();
  }

  void printLines() {                            // prints all surface objects stored in the arraylist
    Surface l;
    if (ourLines.size() > 0) {
      for (int i = 0; i < ourLines.size(); i++) {
        stroke(255);
        l = ourLines.get(i);
        line(l.start.x, l.start.y, l.end.x, l.end.y);
      }
    }
  }

  int getSize() {
    return ourLines.size();
  }

  Surface getLine(int i) {
    return ourLines.get(i);
  }

  void addLine(int x1, int y1, int x2, int y2) {        // adds line to the array list
    ourLines.add(new Surface(x1, y1, x2, y2));
    
  }
}

class Surface {                                        // literally just an object that represents a line
  PVector start;
  PVector end;
  PVector topNormal;
  PVector bottomNormal;
  float surfaceLength;
  PVector[] coords; 
  Surface(){System.err.println("I don't know how this happened");}
 
  Surface(int x1, int y1, int x2, int y2) {          // the coordinates of the line
    start = new PVector(x1, y1);
    end = new PVector(x2, y2);
    surfaceLength = PVector.dist(start, end);
    setSurfaceCoords();
    setStart();
    setNormals();
  }
  void setStart(){
    if(start.x > end.x){
      PVector temp = start.copy();
      start = end.copy();
      end = temp.copy();
    }
  }
  void setNormals(){
    PVector baseDelta = PVector.sub(end, start);
    baseDelta.normalize();
    topNormal = new PVector(-baseDelta.y, baseDelta.x);
    bottomNormal = new PVector (baseDelta.y, -baseDelta.x);
  }
  
  void setSurfaceCoords(){
    
    coords = new PVector[ceil(surfaceLength)];
    for (int i=0; i<coords.length; i++) {
      coords[i] = new PVector();
      coords[i].x = start.x + ((end.x-start.x)/surfaceLength)*i;
      coords[i].y = start.y + ((end.y-start.y)/surfaceLength)*i;
    }
  }
  
}

class Ball {
  PVector location;  // Location of shape
  PVector velocity;  // Velocity of shape  
  PVector gravity;  
  boolean offScreen = false;
  int radius;
  ArrayList<Surface> ourLines = surfaces.ourLines;
  PVector incidence;
  float speed = globalSpeed; 

  Ball(PVector loc, int radius) {
    location = loc.copy();
    velocity = new PVector(1.6, 2.1);
    gravity = new PVector(0, 0.2);
    this.radius = radius;
  }
  
  void checkCollisions(){
    for(int i = 0; i < ourLines.size(); i++){
    coords = ourLines.get(i).coords;
    

      for(int j = 0; j < coords.length; j++){
       
        if(PVector.dist(location, coords[j]) < radius){
            setIncidence();
            float dot;
            PVector realNormal;
            System.out.println("interect");
            if(location.y < coords[j].y){
       
              dot = incidence.dot(ourLines.get(i).topNormal);
              realNormal = ourLines.get(i).topNormal.copy();
              velocity.set(2*realNormal.x*dot - incidence.x, 2*realNormal.y*dot - incidence.y, 0);
            velocity.mult(speed);
            }
            else{
              dot = incidence.dot(ourLines.get(i).bottomNormal);
              realNormal = ourLines.get(i).bottomNormal.copy();
              velocity.set((2*realNormal.x*dot - incidence.x), 2*realNormal.y*dot - incidence.y, 0);
            velocity.mult(speed);
            }
            

        }
      }
    }
  }
  
  void setIncidence(){
  incidence = PVector.mult(velocity, -1);
  incidence.normalize();
}

  void run() {
    checkCollisions();
    update();
    display();
  }

  void display() {
    // Display circle at location vector
    stroke(255);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, radius, radius);
  }  

  void update() {
    // Add velocity to the location.
    location.add(velocity);
      
    
    

    // Remove the ball if it's off the screen
    if ((location.x > width+38) || (location.x < 0)) {
      offScreen = true;
    }

    // bounce off edges
    if (location.x < 0) {
      velocity.x = velocity.x * -1;
    }
    if (location.y > height) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      velocity.y = velocity.y * -0.95; 
      location.y = height;
    }
  }
}
