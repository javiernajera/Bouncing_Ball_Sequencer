//this is from processing example

 // Gravity acts at the shape's acceleration
BallLauncher happyBalls;
int freq;
int count;
void setup() {
  size(640,640);
  happyBalls = new BallLauncher(new PVector(0, 0));
  freq = 50;
  count = 50;
}

void draw() {
  background(0);
  if(count == freq){
    happyBalls.addBall();
    count = 0;
  }
  happyBalls.run();
  count++;
 
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
      b.run();
    }
  }
}

class Ball{
PVector location;  // Location of shape
PVector velocity;  // Velocity of shape
PVector gravity;  

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
  ellipse(location.x,location.y,48,48);
}

void update(){
   // Add velocity to the location.
  location.add(velocity);
  // Add gravity to velocity
  velocity.add(gravity);
  
  // Bounce off edges
  if ((location.x > width) || (location.x < 0)) {
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
