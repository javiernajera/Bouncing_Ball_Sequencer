// Position of left hand side of floor
PVector base1;
// Position of right hand side of floor
PVector base2;
// Length of floor
float baseLength;
boolean addBall;
// An array of subpoints along the floor path
PVector[] coords;

// ball stuff
BallLauncher happyBalls;
int freq;
int count;

// Variables related to moving ball
PVector position;
PVector velocity;
float speed = 9;

// current balls
ArrayList<Ball> balls;

void setup() {
  size(640, 640);
  happyBalls = new BallLauncher(new PVector(width/2,0));
  freq = 50;
  count = 50;
  addBall = true;
  
  fill(128);
  base1 = new PVector(0, height-150);
  base2 = new PVector(width, height);
  createGround();
}

void draw() {
  // draw background
  fill(0, 12);
  noStroke();
  rect(0, 0, width, height);

  // draw base
  fill(200);
  quad(base1.x, base1.y, base2.x, base2.y, base2.x, height, 0, height);


  // draw ellipse
  if (mousePressed == true && addBall) {
    addBall = false;
    happyBalls.addBall();
  }
  else if(mousePressed == false){
    addBall = true;
  }
  happyBalls.run();
  
  
  // calculate base top normal
  PVector baseDelta = PVector.sub(base2, base1);
  baseDelta.normalize();
  PVector normal = new PVector(-baseDelta.y, baseDelta.x);
  
  for (int i=0; i< balls.size(); i++) {
    Ball b = balls.get(i);
    velocity = b.velocity;
    position = b.location;
    PVector incidence = PVector.mult(velocity, -1);
    incidence.normalize();
    //println("coords length: " + coords.length);
    //println("position: " + position.x + " " + position.y);
    for (int j=0;j<coords.length; j++) { 
      // check distance between ellipse and base top coordinates
      if (PVector.dist(position, coords[j]) < 38) {
        //println("hit base");

        // calculate dot product of incident vector and base top normal 
        float dot = incidence.dot(normal);

        // calculate reflection vector
        // assign reflection vector to direction vector
        velocity.set(2*normal.x*dot - incidence.x, 2*normal.y*dot - incidence.y, 0);
        velocity.mult(speed);

        // draw base top normal at collision point
        stroke(255, 128, 0);
        line(position.x, position.y, position.x-normal.x*100, position.y-normal.y*100);
        
        base1.y = random(height-100, height);
        base2.y = random(height-100, height);
        createGround();
      }
    }
  }
}

class BallLauncher {
  PVector origin;
  
  BallLauncher(PVector position) {
    origin = position.copy();
    balls = new ArrayList<Ball>();
  }
  
  void addBall() { 
    balls.add(new Ball(origin));
  }
  
  void run() {
    for (int i=balls.size()-1; i>=0; i--) {
      Ball b = balls.get(i);
      if (b.offScreen) {
        balls.remove(i);
      } else {
        b.run();
      }
    }
  }
}

class Ball {
  PVector location;
  PVector velocity;
  PVector gravity;
  boolean offScreen = false;
  color rand_col;
  
  Ball(PVector loc) {
    location = loc.copy();
    velocity = new PVector(0,2.1);
    gravity = new PVector(0,0.2);    
    rand_col = color(random(255),random(255),random(255));
  }
  
  void run() { 
    update();
    display();
  }
  
  void display() {
    stroke(255);
    strokeWeight(2);
    fill(rand_col);
    ellipse(location.x,location.y,38,38);
  }
  
  void update() {
    // Add velocity to the location.
    location.add(velocity);
    // Add gravity to velocity
    velocity.add(gravity);
    

    // Remove the ball if it's off the screen
    if ((location.x > width+38) || (location.x < 0)) {
      offScreen = true;
    }
  }
}


// Calculate variables for the ground
void createGround() {
  // calculate length of base top
  baseLength = PVector.dist(base1, base2);

  // fill base top coordinate array
  coords = new PVector[ceil(baseLength)];
  for (int i=0; i<coords.length; i++) {
    coords[i] = new PVector();
    coords[i].x = base1.x + ((base2.x-base1.x)/baseLength)*i;
    coords[i].y = base1.y + ((base2.y-base1.y)/baseLength)*i;
  }
}
