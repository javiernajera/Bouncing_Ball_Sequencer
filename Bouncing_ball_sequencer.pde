//this is from processing example

 // Gravity acts at the shape's acceleration
BallLauncher happyBalls;
int freq;
int count;
Lines surfaces = new Lines();
int x1; // realtime starting x
int y1; // realtime starting y
int x2; // realtime ending x
int y2; //realtime ending y
boolean clicked = false;
boolean released = false;
void setup() {
  size(640,640);
  happyBalls = new BallLauncher(new PVector(0, 0));
  freq = 50;
  count = 50;
  
}

void draw() {
  background(0);                            //this sets the screen to black for every frame
  
  
  if (mousePressed == true && !clicked) {      //if mouse is pressed record the coordinates
    x1 = mouseX;
    y1 = mouseY;
    clicked = true;
    released = false;
  }
  
  if(mousePressed == false && !released){    //when it is released record those coordinates
    x2 = mouseX;
    y2 = mouseY;
    clicked = false;
    released = true;
    surfaces.addLine(x1, y1, x2, y2);        //add line to surfaces arraylist
  }
  stroke(255);
  surfaces.printLines();                    //function reprints the surfaces
  
  //surfaces.printLines();
  
  if(count == freq){
    happyBalls.addBall();
    count = 0;
  }
  happyBalls.run();
  count++;

  if (frameCount % 60 == 0){
    println("fps: " + frameRate);
  }
}


class BallLauncher{
  ArrayList<Ball> balls;
  PVector origin; 
  
  BallLauncher(PVector position){
    origin = position.copy();
    balls = new ArrayList<Ball>();
  }
  
  void addBall(){
    balls.add(new Ball(origin));
  }
  
  void run(){
    for (int i = balls.size()-1; i >= 0; i--){
      Ball b = balls.get(i);
      if(b.offScreen){
        balls.remove(i);
      }
      else{
        b.run();
      }
      System.out.println(balls.size());
      
    }
  }
}


class Lines{
  ArrayList<Surface> ourLines = new ArrayList<Surface>();    // Data Structure that collects lines that are being drawn
  
  Lines(){}
  
  void printLines(){                            // prints all surface objects stored in the arraylist
    Surface l;
    if(ourLines.size() > 0){
      for(int i = 0; i < ourLines.size(); i++){
        stroke(255);
        l = ourLines.get(i);
        line(l.startX, l.startY, l.endX, l.endY); 
      }
    }
  }
  
  void addLine(int x1, int y1, int x2, int y2){        // adds line to the array list
    ourLines.add(new Surface(x1, y1, x2, y2));
  }
  
  
}

class Surface{                                        // literally just an object that represents a line
  int startX;
  int startY;
  int endX;
  int endY;
  
  Surface(int x1, int y1, int x2, int y2){          // the coordinates of the line
    startX = x1;
    startY = y1;
    endX = x2;
    endY = y2;
  }
}

class Ball{
  PVector location;  // Location of shape
  PVector velocity;  // Velocity of shape  
  PVector gravity;  
  boolean offScreen = false;

  Ball(PVector loc){
    location = loc.copy();
    velocity = new PVector(1.6,2.1);
    gravity = new PVector(0,0.2);
  }

  void run(){
    update();
    display();
  }

  void display(){
    // Display circle at location vector
    stroke(255);
    strokeWeight(2);
    fill(127);
    ellipse(location.x,location.y,38,38);
  }  

  void update(){
    // Add velocity to the location.
    location.add(velocity);
    // Add gravity to velocity
    velocity.add(gravity);
    
    // Bounce off edges
    if ((location.x > width+38) || (location.x < 0)) {
      offScreen = true;
    }
    
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
