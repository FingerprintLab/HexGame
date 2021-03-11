import java.util.Vector;

boolean started;
int radius = 20;
color player1 = #66ff66, player2 = #ff9933;
Hole holes[];
Vector<Connection> conn1, conn2;
boolean player = true;
float t = 0.0;

void setup() {
  size(680,380);
  background(#303030);
  conn1 = new Vector<Connection>();
  conn2 = new Vector<Connection>();
  started = false;
  field();
}

void draw() {
  background(#303030);
  field();
  push();
  for (int i = 0; i < holes.length; i++) {
    PVector pos = holes[i].getPos();
    if ((mouseX >= (pos.x-radius/2) && mouseX <= pos.x+radius/2) && (mouseY >= pos.y-radius/2 && mouseY <= pos.y+radius/2) && !holes[i].isOccupied()) {
      noFill();
      strokeWeight(2);
      stroke(player? player1 : player2);
      circle(pos.x, pos.y, radius);
      
      if (mousePressed) {
        holes[i].Occupy(player);
        placeColor(pos);
        makeConnections(holes[i]);
      }
    }
  }
  pop();
  t+=0.04;
  //player1 += byte(2*sin(t));
  //player2 += byte(2*cos(t));
  showConnections();
  checkPath();
}

void field() {
  float offset = 0;
  
  if (!started) {
    holes = new Hole[121];
    
    push();
    noStroke();
    fill(#505050);
    for (int i = 0; i < 11; i++) {
      for (int j = 0; j < 11; j++) {
        circle(j*2*radius + 2*radius + offset, i*1.5*radius + 2*radius, radius);
        Hole h = new Hole(new PVector(j*2*radius + 2*radius + offset, i*1.5*radius + 2*radius));
        holes[i*11+j] = h;
      }
      offset += radius;
    }
    started = true;
  }
  else {
    push();
    noStroke();
    for (int i = 0; i < holes.length; i++) {
      if (holes[i].isOccupied())
        fill(holes[i].getPlayer() ? player1 : player2);
      else
        fill(#505050);
      circle(holes[i].getPos().x, holes[i].getPos().y, radius);
    }
  }
  
  strokeWeight(3);
  stroke(player1);
  line(2*radius,radius,22*radius,radius);
  line(12*radius,height-radius,32*radius,height-radius);
  stroke(player2);
  line(radius,2*radius,11*radius,17.5*radius);
  line(23.3*radius,2*radius,33.3*radius,height-2*radius);
  pop();
}

void placeColor(PVector pos) {
  push();
  if (player) {
    fill(player1);
    circle(pos.x, pos.y, radius);
  }
  else {
    fill(player2);
    circle(pos.x, pos.y, radius);
  }
  player = !player;
  pop();
}

void makeConnections(Hole h) {
  for (int i = 0; i < holes.length; i++) {
    if (holes[i].isOccupied() && holes[i].getPlayer() == h.getPlayer()) {
      PVector pos = holes[i].getPos();
      if ((pos.x == h.getPos().x - radius && (pos.y == h.getPos().y - 1.5*radius || pos.y == h.getPos().y + 1.5*radius)) ||
          (pos.x == h.getPos().x + radius && (pos.y == h.getPos().y - 1.5*radius || pos.y == h.getPos().y + 1.5*radius)) ||
          (pos.x == h.getPos().x - 2*radius && pos.y == h.getPos().y) ||
          (pos.x == h.getPos().x + 2*radius && pos.y == h.getPos().y)) {
        if (h.getPlayer())
          conn1.add(new Connection(holes[i], h));
        else
          conn2.add(new Connection(holes[i], h));
      }
    }
  }
}

void checkPath() {
  Vector<Vector<Hole>> path1 = new Vector<Vector<Hole>>();
  if (conn1.size() > 9) {
    for (int i = 0; i < conn1.size(); i++) {
      ;
    }
  }
}

void showConnections() {
  push();
  strokeWeight(2);
  stroke(player1);
  for (int i = 0; i < conn1.size(); i++) {
    line(conn1.get(i).hole1.getPos().x, conn1.get(i).hole1.getPos().y, conn1.get(i).hole2.getPos().x, conn1.get(i).hole2.getPos().y);
  }
  stroke(player2);
  for (int i = 0; i < conn2.size(); i++) {
    line(conn2.get(i).hole1.getPos().x, conn2.get(i).hole1.getPos().y, conn2.get(i).hole2.getPos().x, conn2.get(i).hole2.getPos().y);
  }
  pop();
}
