class Throttler {
  int currentTick;
  int perTick;
  boolean prevTouched;
  boolean touched;
  Throttler(int perTick) {
    currentTick = 0;
    this.perTick = perTick;
  }
  void tick() {
    this.currentTick++;
    this.prevTouched = touched;
    this.touched = false;
    if (this.prevTouched == false) {
      this.currentTick = 0;
    }
  }
  void touch() {
    this.touched = true;
  }
  boolean shouldProcess() {
    return this.currentTick % perTick == 0 && this.touched == true;
  }
}
