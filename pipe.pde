class Pipe {
  float top = random(height/6, height/2);
  float bottom = height - top - height/4;
  float x = width;
  float w = 40;
  static final int speed = 3;
  boolean highlight = false;
  boolean isHit = false;

  boolean hits(Bird bird) {
    if (bird.y - 16 < this.top|| bird.y + 16 > height - this.bottom) {
      if (bird.x + 16 > this.x && bird.x + 16 < this.x + this.w
     || bird.x - 16 > this.x && bird.x - 16 < this.x + this.w) {
        this.highlight = true;
        return true;
      }
    } 
    this.highlight = false;
    return false;
  }

  void show() {
    if (this.highlight) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    rect(this.x, 0, this.w, this.top);
    rect(this.x, height - this.bottom, this.w, this.bottom);
  }

  void update() {
    this.x -= this.speed;
  }

  boolean offscreen() {
    if (this.x < -this.w) {
      return true;
    } else {
      return false;
    }
  }
}
