public class Hole {
  private boolean occupied;
  private boolean player;
  private PVector pos;
  private String id;
  
  public Hole(PVector p, String id) {
    this.occupied = false;
    //this.player = false;
    this.pos = p;
    this.id = id;
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
  public String getId() {
    return this.id;
  }
}
