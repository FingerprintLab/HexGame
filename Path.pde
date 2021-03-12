public class Path {
  public Vector<Hole> pieces;
  
  public Path() {
    this.pieces = new Vector<Hole>();
    return;
  }
  public Path(Path p) {
    this.pieces = new Vector<Hole>();
    for (int i = 0; i < p.pieces.size(); i++) {
      this.pieces.add(p.pieces.get(i));
    }
  }   
}
