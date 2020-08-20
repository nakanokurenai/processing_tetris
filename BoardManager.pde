// [no line, single, double, tetris]
final int[] SCORE_PER_TOTAL_OF_DISAPPEARED_LINE = { 0, 40, 100, 300, 1200 };
final String[] NAME_PER_TOTAL_OF_DISAPPEARED_LINE = { null, "SINGLE", "DOUBLE", "TRIPLE", "TETRIS" };

class BoardManager {
  private int autoDropTickCounter;
  private int autoDropTimingTick;

  private Board board;
  private TetriminoNextManager nextManager;

  private Tetrimino currentMino;
  private int currentMinoX;
  private int currentMinoY;

  private Throttler moveLeftThrottler;
  private Throttler moveRightThrottler;
  private Throttler moveDownThrottler;
  private Throttler hardDropThrottler;
  private Throttler rotateLeftThrottler;
  private Throttler rotateRightThrottler;

  private boolean isGameOver;
  BoardManager(int autoDropTimingTick, int inputProcessTimingTick, Board board) {
    this.autoDropTickCounter = 0;
    this.autoDropTimingTick = autoDropTimingTick;

    this.moveLeftThrottler = new Throttler(inputProcessTimingTick);
    this.moveRightThrottler = new Throttler(inputProcessTimingTick);
    this.moveDownThrottler = new Throttler(inputProcessTimingTick);
    this.hardDropThrottler = new Throttler(inputProcessTimingTick * 2);
    this.rotateLeftThrottler = new Throttler(inputProcessTimingTick);
    this.rotateRightThrottler = new Throttler(inputProcessTimingTick);

    this.nextManager = new TetriminoNextManager();
    this.board = board;
    this.popNextMino();
  }
 
  private void popNextMino() {
    Tetrimino nextMino = this.nextManager.pop();
    if (!this.board.changeGhost(nextMino, 0, 0)) {
      this.onBoardFull();
    };
    this.currentMino = nextMino;
    this.currentMinoX = 0;
    this.currentMinoY = 0;
  }
  private void confirmCurrentMino() {
    this.board.add(this.currentMino, this.currentMinoX, this.currentMinoY);
    this.popNextMino();
    autoDropTickCounter = 0;
  }
  private void restoreGhost() {
    this.board.changeGhost(this.currentMino, this.currentMinoY, this.currentMinoX);
  }
  private boolean tryChangeGhost(Tetrimino nextMino, int boardY, int boardX) {
    if (!this.board.changeGhost(nextMino, boardY, boardX)) {
      this.restoreGhost();
      return false;
    }
    return true;
  }
  private void tryMove(int dy, int dx) {
    if (!tryChangeGhost(this.currentMino, this.currentMinoY + dy, this.currentMinoX + dx)) return;
    this.currentMinoY += dy;
    this.currentMinoX += dx;
  }
  private void doTSpin() {
    // TODO
  }

  void tick() {
    if (this.isGameOver) return;

    autoDropTickCounter++;

    if (autoDropTickCounter % autoDropTimingTick == 0) {
      this.autoDropTickCounter = 0;
      this.onDropCurrentMino();
    }

    // tick throttler
    if (this.moveLeftThrottler.shouldProcess()) this.tryMove(0, -1);
    if (this.moveRightThrottler.shouldProcess()) this.tryMove(0, 1);
    if (this.moveDownThrottler.shouldProcess()) this.tryMove(1, 0);
    if (this.hardDropThrottler.shouldProcess()) {
      this.board.flushGhost();
      this.confirmCurrentMino();
    }
    if (this.rotateLeftThrottler.shouldProcess()) {
      Tetrimino nextMino = this.currentMino.clone().rotateLeft();
      if (!tryChangeGhost(nextMino, this.currentMinoY, this.currentMinoX)) return;
      this.currentMino = nextMino;
    }
    if (this.rotateRightThrottler.shouldProcess()) {
      Tetrimino nextMino = this.currentMino.clone().rotateRight();
      if (!tryChangeGhost(nextMino, this.currentMinoY, this.currentMinoX)) return;
      this.currentMino = nextMino;
    }

    this.moveLeftThrottler.tick();
    this.moveRightThrottler.tick();
    this.moveDownThrottler.tick();
    this.hardDropThrottler.tick();
    this.rotateLeftThrottler.tick();
    this.rotateRightThrottler.tick();
  }

  // event handlers
  private void onDropCurrentMino() {
    // drop current mino
    if (!this.board.changeGhost(this.currentMino, this.currentMinoY+1, this.currentMinoX)) {
      // if can't drop, confirm it
      this.confirmCurrentMino();
    };
    this.currentMinoY++;

    this.board.drawText();
  }
  private void onBoardFull() {
    // game over
    this.isGameOver = true;
  }

  // controls
  void hardDrop() {
    this.hardDropThrottler.touch();
  }
  void moveLeft() {
    this.moveLeftThrottler.touch();
  }
  void moveRight() {
    this.moveRightThrottler.touch();
  }
  void moveDown() {
    this.moveDownThrottler.touch();
  }
  void rotateLeft() {
    this.rotateLeftThrottler.touch();
  }
  void rotateRight() {
    this.rotateRightThrottler.touch();
  }
}
