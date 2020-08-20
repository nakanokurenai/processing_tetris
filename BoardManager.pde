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

  private boolean isGameOver;
  BoardManager(int autoDropTimingTick, Board board) {
    this.autoDropTickCounter = 0;
    this.autoDropTimingTick = autoDropTimingTick;

    this.nextManager = new TetriminoNextManager();
    this.board = board;
    this.popNextMino();
  }
 
  private void popNextMino() {
    Tetrimino nextMino = this.nextManager.pop();
    if (!this.board.changeCurrent(nextMino, 0, 0)) {
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
  private void restoreCurrent() {
    this.board.changeCurrent(this.currentMino, this.currentMinoY, this.currentMinoX);
  }
  private boolean tryChangeCurrent(Tetrimino nextMino, int boardY, int boardX) {
    if (!this.board.changeCurrent(nextMino, boardY, boardX)) {
      this.restoreCurrent();
      return false;
    }
    return true;
  }
  private void tryMove(int dy, int dx) {
    if (!tryChangeCurrent(this.currentMino, this.currentMinoY + dy, this.currentMinoX + dx)) return;
    this.currentMinoY += dy;
    this.currentMinoX += dx;
  }

  void tick() {
    if (this.isGameOver) return;

    autoDropTickCounter++;

    if (autoDropTickCounter % autoDropTimingTick == 0) {
      this.autoDropTickCounter = 0;
      this.onDropCurrentMino();
    }
  }

  // event handlers
  private void onDropCurrentMino() {
    // drop current mino
    if (!this.board.changeCurrent(this.currentMino, this.currentMinoY+1, this.currentMinoX)) {
      // FIXME: this block expects that board flushed currentMino already
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
    this.board.flushCurrent();
    this.confirmCurrentMino();
  }
  void moveLeft() {
    this.tryMove(0, -1);
  }
  void moveRight() {
    this.tryMove(0, 1);
  }
  void moveDown() {
    this.tryMove(1, 0);
    this.autoDropTickCounter = 0;
  }
  void rotateLeft() {
    Tetrimino nextMino = this.currentMino.clone().rotateLeft();
    if (!tryChangeCurrent(nextMino, this.currentMinoY, this.currentMinoX)) return;
    this.currentMino = nextMino;
  }
  void rotateRight() {
    Tetrimino nextMino = this.currentMino.clone().rotateRight();
    if (!tryChangeCurrent(nextMino, this.currentMinoY, this.currentMinoX)) return;
    this.currentMino = nextMino;
  }
}
