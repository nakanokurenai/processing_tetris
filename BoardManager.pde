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

  private Tetrimino holdMino;
  private boolean holdUsed;

  private int score;

  private boolean isGameOver;
  BoardManager(int autoDropTimingTick, Board board) {
    this.autoDropTickCounter = 0;
    this.autoDropTimingTick = autoDropTimingTick;

    this.nextManager = new TetriminoNextManager();
    this.board = board;
    this.popNextMino();
  }

  /* expose state */
  int getScore() { return this.score; }
  boolean isGameOver() { return this.isGameOver; }
  // nullable
  Tetrimino getHoldMino() { return this.holdMino; }
  // guarantee 3-length array
  Tetrimino[] getNextMinos() { return this.nextManager.getNextList(); }

  /* tick */
  void tick() {
    if (this.isGameOver) return;

    autoDropTickCounter++;

    if (autoDropTickCounter % autoDropTimingTick == 0) {
      this.autoDropTickCounter = 0;
      this.autoDropCurrentMino();
    }
  }

  private void popNextMino() {
    Tetrimino nextMino = this.nextManager.pop();
    if (!this.board.changeCurrent(nextMino, 0, 0)) {
      this.onBoardFull();
      return;
    };
    this.currentMino = nextMino;
    this.currentMinoX = 0;
    this.currentMinoY = 0;
  }
  private void confirmCurrentMino() {
    this.board.add(this.currentMino, this.currentMinoX, this.currentMinoY);
    int lines_count = this.board.removeCompletedLines();
    score += SCORE_PER_TOTAL_OF_DISAPPEARED_LINE[lines_count];
    println("[confirmCurrentMino] score = " + score);
    this.popNextMino();
    this.autoDropTickCounter = 0;
    this.holdUsed = false;
  }
  private void restoreCurrent() {
    this.board.changeCurrent(this.currentMino, this.currentMinoY, this.currentMinoX);
  }
  private boolean tryChangeCurrent(Tetrimino nextMino, int boardY, int boardX) {
    if (!this.board.changeCurrent(nextMino, boardY, boardX)) {
      this.restoreCurrent();
      return false;
    }
    this.currentMino = nextMino;
    this.currentMinoX = boardX;
    this.currentMinoY = boardY;
    return true;
  }
  private void tryMove(int dy, int dx) {
    tryChangeCurrent(this.currentMino, this.currentMinoY + dy, this.currentMinoX + dx);
  }

  // event handlers
  private void autoDropCurrentMino() {
    // drop current mino
    if (!this.board.changeCurrent(this.currentMino, this.currentMinoY+1, this.currentMinoX)) {
      // FIXME: this block expects that board flushed currentMino already. it's implementation detail in Board which should be hidden.
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
    if (this.isGameOver) return;
    this.board.flushCurrent();
    this.confirmCurrentMino();
  }
  void moveLeft() {
    if (this.isGameOver) return;
    this.tryMove(0, -1);
  }
  void moveRight() {
    if (this.isGameOver) return;
    this.tryMove(0, 1);
  }
  void moveDown() {
    if (this.isGameOver) return;
    this.tryMove(1, 0);
    this.autoDropTickCounter = 0;
  }
  void rotateLeft() {
    if (this.isGameOver) return;
    Tetrimino nextMino = this.currentMino.clone().rotateLeft();
    tryChangeCurrent(nextMino, this.currentMinoY, this.currentMinoX);
  }
  void rotateRight() {
    if (this.isGameOver) return;
    Tetrimino nextMino = this.currentMino.clone().rotateRight();
    tryChangeCurrent(nextMino, this.currentMinoY, this.currentMinoX);
  }
  boolean swapHoldMino() {
    if (this.isGameOver) return false;
    println("[swapHoldMino] try to swap");
    if (this.holdUsed) {
      println("[swapHoldMino] already swapped...");
      return false;
    }

    Tetrimino fromMino = this.currentMino;
    Tetrimino toMino = this.holdMino != null ? this.holdMino : this.nextManager.getNext();
    boolean isNextMinoUsed = this.holdMino == null;

    if (!tryChangeCurrent(toMino, this.currentMinoY, this.currentMinoX)) {
      // holded mino is maybe wider than current mino
      int sizeBigger = max(0, toMino.getWidth() - fromMino.getWidth());
      if (!tryChangeCurrent(toMino, this.currentMinoY, this.currentMinoX - sizeBigger)) {
        return false;
      }
    }
    this.holdUsed = true;
    if (isNextMinoUsed) this.nextManager.pop();
    this.holdMino = fromMino;
    return true;
  }
}
