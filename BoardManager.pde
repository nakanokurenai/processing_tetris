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

  private int fontSize;

  private boolean isGameOver;
  BoardManager(int autoDropTimingTick, Board board, int fontSize) {
    this.fontSize = fontSize;

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
      this.autoDropCurrentMino();
    }
  }

  // event handlers
  private void autoDropCurrentMino() {
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

  // draw state
  void draw(int x, int y, color backgroundColor) {
    // TODO: split pane view to another file
    int currentX = x;
    int currentY = y;
    int paneWidth = BLOCK_SIZE * 4 + PADDING * 2;
    textAlign(LEFT, TOP);

    /* Left pain (100px) */
    // HOLD
    fill(0);
    text("HOLD", currentX, currentY);
    currentY += this.fontSize + PADDING;
    fill(backgroundColor);
    rect(currentX, currentY, paneWidth, paneWidth);
    if (this.holdMino != null) drawTetrimino(this.holdMino, currentX + PADDING, currentY + PADDING);
    currentY += paneWidth;

    currentY += PADDING * 2;

    // score
    fill(0);
    text("SCORE", currentX, currentY);
    currentY += this.fontSize + PADDING;
    fill(backgroundColor);
    rect(currentX, currentY, paneWidth, this.fontSize + PADDING*2);
    fill(0);
    text("" + this.score, currentX + PADDING, currentY + PADDING);
    currentY += this.fontSize + PADDING*2;

    /* Right pain */
    textAlign(LEFT, TOP);
    currentX += paneWidth + PADDING*2 + this.board.width + PADDING*2;
    currentY = y;

    // next
    fill(0);
    Tetrimino[] nextList = this.nextManager.getNextList();
    text("NEXT", currentX, currentY);
    currentY += this.fontSize + PADDING;
    fill(backgroundColor);
    rect(currentX, currentY, paneWidth, paneWidth);
    drawTetrimino(nextList[0], currentX + PADDING, currentY + PADDING);
    currentY += paneWidth;
    // next 1 (x0.7)
    currentY += PADDING;
    fill(backgroundColor);
    rect(currentX, currentY, BLOCK_SIZE*4*0.7 + PADDING*2, BLOCK_SIZE*4*0.7 + PADDING*2);
    drawTetrimino(nextList[1], currentX + PADDING, currentY + PADDING, int(BLOCK_SIZE * 0.7));
    currentY += BLOCK_SIZE*4*0.7 + PADDING*2;
    // next 2 (x0.6)
    currentY += PADDING;
    fill(backgroundColor);
    rect(currentX, currentY, BLOCK_SIZE*4*0.6 + PADDING*2, BLOCK_SIZE*4*0.6 + PADDING*2);
    drawTetrimino(nextList[2], currentX + PADDING, currentY + PADDING, int(BLOCK_SIZE * 0.6));
    currentY += BLOCK_SIZE*4*0.6;

    // hold
    if (this.holdMino == null) return;
  }
  // render mino on 4x4 block
  private void drawTetrimino(Tetrimino mino, int x, int y) {
    drawTetrimino(mino, x, y, BLOCK_SIZE);
  }
  private void drawTetrimino(Tetrimino mino, int x, int y, int blockSize) {
    float centeredY = y + (4 - mino.form.length) * blockSize / 2;
    float centeredX = x + (4 - mino.form[0].length) * blockSize / 2;
    fill(mino.blockColor);
    for (int i = 0; i < mino.form.length; i++) {
      for (int j = 0; j < mino.form[0].length; j++) {
        if (!mino.form[i][j]) continue;
        rect(centeredX + blockSize*j, centeredY + blockSize*i, blockSize, blockSize);
      }
    }
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
  boolean swapHoldMino() {
    println("[swapHoldMino] try to swap");
    if (this.holdUsed) {
      println("[swapHoldMino] already swapped...");
      return false;
    }
    if (holdMino == null) {
      println("[swapHoldMino] pop next mino");
      holdMino = this.nextManager.pop();
    }
    Tetrimino nextMino = holdMino;
    this.holdUsed = true;
    tryChangeCurrent(nextMino, this.currentMinoY, this.currentMinoX);
    this.holdMino = this.currentMino;
    this.currentMino = nextMino;
    return true;
  }
}
