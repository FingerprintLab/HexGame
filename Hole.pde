public class Hole {
  private boolean occupied;
  private boolean player;
  private PVector pos;
  public Hole(PVector p) {
    this.occupied = false;
    this.player = false;
    this.pos = p;
  }
  public void Occupy(boolean player) {
    this.occupied = true;
    this.player = player;
  }
  public boolean isOccupied() {
    return this.occupied;
  }
  public PVector getPos() {
    return this.pos;
  }
  public boolean getPlayer() {
    return this.player;
  }
}
