import java.util.*;

boolean started;
int radius = 20;
int boardDim = 11;
color player1 = #66ff66, player2 = #ff9933;
Hole holes[];
Vector<Connection> conn1, conn2;
Vector<Path> paths1, paths2;
boolean player = true;
float t = 0.0;

String[] letter = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"}; 

void setup() {
  size(680,380);
  background(#303030);
  conn1 = new Vector<Connection>();
  conn2 = new Vector<Connection>();
  paths1 = new Vector<Path>();
  paths2 = new Vector<Path>();
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
  // for every hole
  for (int i = 0; i < holes.length; i++) {
    // check if it's occupied by a piece of the same player
    if (holes[i].isOccupied() && holes[i].getPlayer() == h.getPlayer()) {
      PVector pos = holes[i].getPos();
      // check if it's near the newly inserted piece
      if ((pos.x == h.getPos().x - radius && (pos.y == h.getPos().y - 1.5*radius || pos.y == h.getPos().y + 1.5*radius)) ||
          (pos.x == h.getPos().x + radius && (pos.y == h.getPos().y - 1.5*radius || pos.y == h.getPos().y + 1.5*radius)) ||
          (pos.x == h.getPos().x - 2*radius && pos.y == h.getPos().y) ||
          (pos.x == h.getPos().x + 2*radius && pos.y == h.getPos().y)) {
        if (h.getPlayer()) {
          conn1.add(new Connection(holes[i], h));
          checkPath();
          //println("Conn1 " + conn1.size() + " Paths1 " + paths1.size());
          for (int a = 0; a < paths1.size(); a++) {
            println("PATH " + a + ":");
            for (int b = 0; b < paths1.get(a).pieces.size(); b++) {
              print(paths1.get(a).pieces.get(b).getId() + "->");
            }
            println();
          }
          println();
        }
        else
          conn2.add(new Connection(holes[i], h));
      }
    }
  }
  paths1 = new Vector<Path>();
}

void checkPath() {
  for (int i = 0; i < conn1.size(); i++) {
    Hole h1 = conn1.get(i).hole1;
    Hole h2 = conn1.get(i).hole2;
    println("hole1: " + h1.getId() + ", hole2: " + h2.getId());
    if (paths1.size() == 0) {
      Path p = new Path();
      p.pieces.add(h1);
      p.pieces.add(h2);
      paths1.add(p);
      return;
    }
    
    boolean ok1 = true, ok2 = true;
    for (int j = 0; j < paths1.size(); j++) {
      //print("path" + j + ": ");
      for (int k = 0; k < paths1.get(j).pieces.size(); k++) {
        //print(paths1.get(j).pieces.get(k).getId() + " ");
        //print("-" + paths1.get(j).pieces.get(k).getId() + "_");
        if (paths1.get(j).pieces.get(k).getId() == h1.getId()) ok1 = false;
        else if (paths1.get(j).pieces.get(k).getId() == h2.getId()) ok2 = false;
      }
      println();
      if (ok1 && !ok2)
        paths1.get(j).pieces.add(h1);
      else if (!ok1 && ok2)
        paths1.get(j).pieces.add(h2);
      else if (ok1 && ok2) {
        Path p = new Path();
        p.pieces.add(h1);
        p.pieces.add(h2);
        paths1.add(p);
      }
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

void field() {
  float offset = 0;
  
  if (!started) {
    holes = new Hole[boardDim*boardDim];
    
    push();
    noStroke();
    fill(#505050);
    for (int i = 0; i < boardDim; i++) {
      for (int j = 0; j < boardDim; j++) {
        circle(j*2*radius + 2*radius + offset, i*1.5*radius + 2*radius, radius);
        Hole h = new Hole(new PVector(j*2*radius + 2*radius + offset, i*1.5*radius + 2*radius), letter[i]+String.valueOf(j));
        holes[i*boardDim+j] = h;
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
