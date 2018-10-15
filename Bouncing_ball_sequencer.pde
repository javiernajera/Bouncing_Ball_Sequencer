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
  size(640, 640);
  happyBalls = new BallLauncher(new PVector(0, 0));
  freq = 50;
  count = 50;
}

void draw() {
  background(0);                               //this sets the screen to black for every frame


  if (mousePressed == true && !clicked) {      //if mouse is pressed record the coordinates
    x1 = mouseX;
    y1 = mouseY;
    clicked = true;
    released = false;
  }

  if (mousePressed == false && !released) {    //when it is released record those coordinates
    x2 = mouseX;
    y2 = mouseY;
    clicked = false;
    released = true;
    surfaces.addLine(x1, y1, x2, y2);        //add line to surfaces arraylist
  }
  stroke(255);
  surfaces.printLines();                    //function reprints the surfaces

  if (count == freq) {
    happyBalls.addBall();
    count = 0;
  }
  happyBalls.run();
  count++;

  if (frameCount % 60 == 0) {
    println("fps: " + frameRate);
  }
}


class BallLauncher {
  ArrayList<Ball> balls;
  PVector origin; 

  BallLauncher(PVector position) {
    origin = position.copy();
    balls = new ArrayList<Ball>();
  }

  void addBall() {
    balls.add(new Ball(origin));
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
  ArrayList<Surface> ourLines = new ArrayList<Surface>();    // Data Structure that collects lines that are being drawn

  Lines() {
  }

  void printLines() {                            // prints all surface objects stored in the arraylist
    Surface l;
    if (ourLines.size() > 0) {
      for (int i = 0; i < ourLines.size(); i++) {
        stroke(255);
        l = ourLines.get(i);
        line(l.startX, l.startY, l.endX, l.endY);
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
  int startX;
  int startY;
  int endX;
  int endY;

  Surface(int x1, int y1, int x2, int y2) {          // the coordinates of the line
    startX = x1;
    startY = y1;
    endX = x2;
    endY = y2;
  }
}

class Ball {
  PVector location;  // Location of shape
  PVector velocity;  // Velocity of shape  
  PVector gravity;  
  boolean offScreen = false;

  Ball(PVector loc) {
    location = loc.copy();
    velocity = new PVector(1.6, 2.1);
    gravity = new PVector(0, 0.2);
  }

  void run() {
    update();
    display();
  }

  void display() {
    // Display circle at location vector
    stroke(255);
    strokeWeight(2);
    fill(127);
    ellipse(location.x, location.y, 38, 38);
  }  

  void update() {
    // Add velocity to the location.
    location.add(velocity);
    // Add gravity to velocity
    velocity.add(gravity);

    float right_y_check;
    float left_y_check;
    float top_y_check;
    float bot_y_check;
    // bounce off custom lines
    for (int i = 0; i<surfaces.getSize(); i++) {
      float x1 = surfaces.getLine(i).startX;
      float y1 = surfaces.getLine(i).startY;
      float x2 = surfaces.getLine(i).endX;
      float y2 = surfaces.getLine(i).endY;

      float m_val = (y2-y1)/(x2-x1);
      float b_val = y1 - m_val*x1;

      float cir_rightX = location.x + 38;
      float cir_rightY = location.y;
      float cir_leftX = location.x - 38;
      float cir_leftY = location.y;
      float cir_topX = location.x;
      float cir_topY = location.y + 38;
      float cir_botX = location.x;
      float cir_botY = location.y - 38;

      right_y_check = cir_rightX * m_val + b_val;
      left_y_check = cir_leftX * m_val + b_val;
      top_y_check = cir_topX * m_val + b_val;
      bot_y_check = cir_botX * m_val + b_val;
      
      float right_y_dist = abs(right_y_check - cir_rightY);
      float left_y_dist = abs(left_y_check - cir_leftY);
      float top_y_dist = abs(top_y_check - cir_topY);
      float bot_y_dist = abs(bot_y_check - cir_botY);
      
      int 
      if ((abs(right_y_check - cir_rightY) <= 2)) {
        if (((cir_rightX <= x1) && (cir_rightX >= x2)) || ((cir_rightX <= x2) && (cir_rightX >= x1))) {
          // right intersect
          println("right intersect!");
          float angle = atan2(right_y_check, cir_rightX);
          float targetX = location.x + cos(angle)*38;
          float targetY = location.y + sin(angle)*38;
          float ax = (targetX - cir_rightX)*.05;
          float ay = (targetY - right_y_check)*.05;
          velocity.x *= -1*(ax+.05);
          velocity.y *= -1*(ay+.05);
        }
      }
      
      
      if ((abs(left_y_check - cir_leftY) <= 2)) {
        if (((cir_leftX <= x1) && (cir_leftX >= x2)) || ((cir_leftX <= x2) && (cir_leftX >= x1))) {
          // left intersect
          println("left intersect!");
          float angle = atan2(left_y_check, cir_leftX);
          float targetX = location.x + cos(angle)*38;
          float targetY = location.y + sin(angle)*38;
          float ax = (targetX - cir_leftX)*.05;
          float ay = (targetY - left_y_check)*.05;
          velocity.x *= -1*(ax+.05);
          velocity.y *= -1*(ay+.05);
        }
      }
      
      if ((abs(top_y_check - cir_topY) <= 2)) {
        if (((cir_topX <= x1) && (cir_topX >= x2)) || ((cir_topX <= x2) && (cir_topX >= x1))) {
          // top intersect
          println("top intersect!");
          float angle = atan2(top_y_check, cir_topX);
          float targetX = location.x + cos(angle)*38;
          float targetY = location.y + sin(angle)*38;
          float ax = (targetX - cir_topX)*.05;
          float ay = (targetY - top_y_check)*.05;
          velocity.x *= -1*(ax+.05);
          velocity.y *= -1*(ay+.05);
        }
      }
      
      if ((abs(bot_y_check - cir_botY) <= 2)) {
        if (((cir_botX <= x1) && (cir_botX >= x2)) || ((cir_botX <= x2) && (cir_botX >= x1))) {
          // bottom intersect
          println("bottom intersect!");
          float angle = atan2(bot_y_check, cir_botX);
          float targetX = location.x + cos(angle)*38;
          float targetY = location.y + sin(angle)*38;
          float ax = (targetX - cir_botX)*.05;
          float ay = (targetY - bot_y_check)*.05;
          velocity.x *= -1*(ax+.05);
          velocity.y *= -1*(ay+.05);
        }
      }
      
    }

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
