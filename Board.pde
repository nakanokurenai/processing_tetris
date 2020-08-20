class Board {
  // top=0,left=0
  // [boardY][boardX]
  private Tetrimino[][] board;
  private Tetrimino currentGhost;
  private int x;
  private int y;
  private int width;
  private int height;
  private int blockSize;
  Board(int x, int y, int maxWidth, int maxHeight) {
    // generally tetris implemented as 20x10 board
    board = new Tetrimino[20][10];

    this.x = x;
    this.y = y;
    this.blockSize = min(maxHeight / this.board.length, maxWidth / this.board[0].length);
    this.height = this.blockSize * this.board.length;
    this.width = this.blockSize * this.board[0].length;
  }
  void changeGhost() {
    
  }
  void flushGhost() {
    
  }
  void add(Tetrimino mino, int boardX) {
    int yColision = this.whenColideBottom(mino, boardX);
    int minoHeight = mino.getHeight();
    int minoWidth = mino.getWidth();
    println("[add] yColision=" + yColision + ", mino=" + mino.name + ", minoHeight=" + minoHeight + ", minoWidth=" + minoWidth);
    for (int minoY = 0; minoY < minoHeight; minoY++) {
      for (int minoX = 0; minoX < minoWidth; minoX++) {
        if (!mino.form[minoY][minoX]) continue;
        int y = yColision - ((minoHeight-1) - minoY);
        int x = boardX + minoX;
        println("[add] fill y=" + y + ", x=" + x);
        this.board[y][x] = mino;
      }
    }
  }
  // return bottom boardY
  int whenColideBottom(Tetrimino mino, int boardX) {
    for (int bottomBoardY = this.board.length-1; bottomBoardY > mino.form.length-1; bottomBoardY--) {
      println("[whenColideBottom] check colide on " + bottomBoardY);
      if (!minoColide(mino, bottomBoardY - mino.form.length +1, boardX)) {
        return bottomBoardY;
      }
    }
    throw new Error("[whenColideBottom] No space left");
  }
  // boardY: top, boardX: left
  private boolean minoColide(Tetrimino mino, int boardY, int boardX) {
    for (int minoY = 0; minoY < mino.form.length; minoY++) {
      for (int minoX = 0; minoX < mino.form[0].length; minoX++) {
        if (!mino.form[minoY][minoX]) continue;
        if (this.board[boardY+minoY][boardX+minoX] != null) return true;
      }
    }
    return false;
  }

  // must clear canvas before call
  void draw(color boardColor) {
    noStroke();
    fill(boardColor);
    rect(this.x, this.y, this.width, this.height);
    for (int boardY = 0; boardY < this.board.length; boardY++) {
      for (int boardX = 0; boardX < this.board[0].length; boardX++) {
        if (this.board[boardY][boardX] == null) continue;
        fill(this.board[boardY][boardX].blockColor & 0x33ffffff);
        rect(this.x + this.blockSize * boardX, this.y + this.blockSize * boardY, this.blockSize, this.blockSize);
      }
    }
  }
  // [debug]
  void drawText() {
    println("[board] drawText");
    for (int i = 0; i < this.board.length; i++) {
      for (int j = 0; j < this.board[0].length; j++) {
        print(((this.board[i][j] != null) ? "x" : "_") + " ");
      }
      println();
    }
  }
}
