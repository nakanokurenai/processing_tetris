class InputManager {
  BoardManager boardManager;

  private Throttler moveLeftThrottler;
  private Throttler moveRightThrottler;
  private Throttler moveDownThrottler;
  private Throttler hardDropThrottler;
  private Throttler rotateLeftThrottler;
  private Throttler rotateRightThrottler;
  private Throttler swapHoldThrottler;

  InputManager(BoardManager bm, int inputProcessTimingTick) {
    this.boardManager = bm;

    this.moveLeftThrottler = new Throttler(inputProcessTimingTick);
    this.moveRightThrottler = new Throttler(inputProcessTimingTick);
    this.moveDownThrottler = new Throttler(inputProcessTimingTick);
    this.hardDropThrottler = new Throttler(inputProcessTimingTick * 2);
    this.rotateLeftThrottler = new Throttler(inputProcessTimingTick);
    this.rotateRightThrottler = new Throttler(inputProcessTimingTick);
    this.swapHoldThrottler = new Throttler(inputProcessTimingTick);
  }

  void touch() {
    if (keyPressed == true && key == CODED) {
      switch (keyCode) {
        case UP: {
          hardDropThrottler.touch();
          break;
        }
        case DOWN: {
          moveDownThrottler.touch();
          break;
        }
        case LEFT: {
          moveLeftThrottler.touch();
          break;
        }
        case RIGHT: {
          moveRightThrottler.touch();
          break;
        }
        case SHIFT: {
          swapHoldThrottler.touch();
          break;
        }
      }
    } else if (keyPressed == true) {
      switch (key) {
        case 'Z':
        case 'z': {
          rotateLeftThrottler.touch();
          break;
        }
        case 'X':
        case 'x': {
          rotateRightThrottler.touch();
          break;
        }
      }
    }
  }

  void tick() {
    if (this.moveLeftThrottler.shouldProcess()) this.boardManager.moveLeft();
    if (this.moveRightThrottler.shouldProcess()) this.boardManager.moveRight();
    if (this.moveDownThrottler.shouldProcess()) this.boardManager.moveDown();
    if (this.hardDropThrottler.shouldProcess()) this.boardManager.hardDrop();
    if (this.rotateLeftThrottler.shouldProcess()) this.boardManager.rotateLeft();
    if (this.rotateRightThrottler.shouldProcess()) this.boardManager.rotateRight();
    if (this.swapHoldThrottler.shouldProcess()) this.boardManager.swapHoldMino();

    this.moveLeftThrottler.tick();
    this.moveRightThrottler.tick();
    this.moveDownThrottler.tick();
    this.hardDropThrottler.tick();
    this.rotateLeftThrottler.tick();
    this.rotateRightThrottler.tick();
    this.swapHoldThrottler.tick();
  }
}
