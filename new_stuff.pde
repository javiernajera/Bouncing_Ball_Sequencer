/*
FILE: new_stuff
AUTHORS: Karl Sarier and Javier Najera
ASSIGNMENT: PQ4
DESCRIPTION: On running this file, a window is generated
               where the user can click anywhere on the screen 
               to drop a ball of a randomly selected color. Whenever
               a ball bounces off of the floor, the floor changes
               its angle, resulting in unpredictable movement from the balls.
KNOWN BUGS: When the new floor is larger than the previous floor, the ball will
              sometimes glitch through the bottom of the screen. In other cases,
              the ball gets stuck on the floor, and glitches across the screen.
*/

// Position of left hand side of floor
PVector base1;
// Position of right hand side of floor
PVector base2;

// Length of floor
float baseLength;
// An array of subpoints along the floor path
PVector[] coords;

// keep track 
boolean addBall;
BallLauncher happyBalls;

// variables for each ball
PVector position;
PVector velocity;
float speed = 9;

// current balls on screen
ArrayList<Ball> balls;

void setup() {
  size(640, 640);
  
  // set the dropping point at the top-middle of the screen
  happyBalls = new BallLauncher(new PVector(width/2,0));
  addBall = true;
  
  fill(128);
  
  // default ground
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


  // respond to mouse clicks
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
  
  // for each ball on the screen, locally save their velocity and position
  for (int i=0; i< balls.size(); i++) {
    Ball b = balls.get(i);
    velocity = b.velocity;
    position = b.location;
    PVector incidence = PVector.mult(velocity, -1);
    incidence.normalize();

    // for every point on the base, check to see if the current ball intersects
    for (int j=0;j<coords.length; j++) { 
      
      // check distance between the current circle and base top coordinates
      if (PVector.dist(position, coords[j]) < 38) {

        // calculate dot product of incident vector and base top normal 
        float dot = incidence.dot(normal);

        // calculate reflection vector, then assign to direction vector
        // assign reflection vector to direction vector
        velocity.set(2*normal.x*dot - incidence.x, 2*normal.y*dot - incidence.y, 0);
        velocity.mult(speed);

        // draw base top normal at collision point
        stroke(255, 128, 0);
        line(position.x, position.y, position.x-normal.x*100, position.y-normal.y*100);
        
        // make a new base
        base1.y = random(height-100, height);
        base2.y = random(height-100, height);
        createGround();
      }
    }
  }
}


// a class to keep track of all the balls
class BallLauncher {
  
  PVector origin;
  
  BallLauncher(PVector position) {
    origin = position.copy();
    balls = new ArrayList<Ball>();
  }
  
  void addBall() { 
    balls.add(new Ball(origin));
  }
  
  // check if a ball went off either side
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

// stores information about each ball
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
    
    // Add velocity and gravity to the ball
    location.add(velocity);
    velocity.add(gravity);
    
    // Remove the ball if it's off the screen
    if ((location.x > width+38) || (location.x < 0)) {
      offScreen = true;
    } 
  }
}

// get base top coordinates
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
