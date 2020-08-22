static int BOARD_HIDDEN_ROWS = 2;

class Board {
  // top=0,left=0
  // [boardY][boardX]
  private Tetrimino[][] board;
  private Tetrimino current;
  private Tetrimino currentGhost;
  private int width;
  private int height;
  private int blockSize;
  private boolean locked;
  Board(int maxWidth, int maxHeight) {
    // generally tetris implemented as visible 20x10 board,
    // but there are also invisibly +2 line.
    board = new Tetrimino[22][10];

    this.blockSize = min(maxHeight / (this.board.length-2), maxWidth / this.board[0].length);
    this.height = this.blockSize * (this.board.length - BOARD_HIDDEN_ROWS);
    this.width = this.blockSize * this.board[0].length;
    println("[Board] Initialized with blockSize=" + blockSize + ", height=" + height + ", width=" + width);
  }

  // callee should re-assign old-ghost if needed / failed
  boolean changeCurrent(Tetrimino next, int boardY, int boardX) {
    if (locked) return false;
    
    this.flushCurrent();

    Tetrimino ghost = next.clone();
    ghost.blockColor = ghost.blockColor & 0x70ffffff;
    if (!this.add(ghost, boardX, boardY)) return false;
    this.currentGhost = ghost;
    this.forceAdd(next, boardY, boardX);
    this.current = next;
    return true;
  }
  void flushCurrent() {
    if (locked) return;

    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[0].length; j++) {
        if (board[i][j] != this.currentGhost && board[i][j] != this.current) continue;
        board[i][j] = null;
      }
    }
    this.current = null;
    this.currentGhost = null;
  }

  // returns removed count of line
  int removeCompletedLines() {
    if (locked) return 0;

    println("[removeCompletedLines]");
    // may occur dead-locking
    this.locked = true;
    int cnt = 0;
    int[] yMove = new int[this.board.length];
    outside: for (int i = this.board.length-1; i >= 0; i--) {
      for (int j = 0; j < this.board[0].length; j++) {
        if (board[i][j] == null) continue outside;
      }
      println("[removeConpletedLine] y=" + i + " will removed");
      cnt++;
      for (int k = 0; k < i; k++) {
        yMove[k] = yMove[k]+1;
      }
    }

    // apply
    for (int i = this.board.length-1; i >= 0; i--) {
      if (yMove[i] == 0) continue;
      println("[removeCompletedLines] Move y=" + i + " to y=" + (i + yMove[i]));
      for (int j = 0; j < this.board[0].length; j++) {
        this.board[i + yMove[i]][j] = this.board[i][j];
      }
    }
    for (int i = 0; i < cnt; i++) {
      this.board[i] = new Tetrimino[this.board[0].length];
    }

    this.locked = false;
    return cnt;
  }

  boolean add(Tetrimino mino, int boardX) {
    return this.add(mino, boardX, 0);
  }
  boolean add(Tetrimino mino, int boardX, int minBoardY) {
    if (locked) return false;

    println("[add] mino=" + mino.name + ", x=" + boardX + ", minY=" + minBoardY);
    if (0 > boardX || boardX + (mino.form[0].length-1) >= this.board[0].length) {
      println("[add] x outside from board");
      return false;
    }

    int boardY = this.placableY(mino, boardX, minBoardY);
    if (minBoardY > boardY) {
      println("[add] no space left to add mino=" + mino.name + " under y=" + minBoardY);
      return false;
    }

    this.forceAdd(mino, boardY, boardX);
    return true;
  }

  private int placableY(Tetrimino mino, int boardX, int after) {
    println("[placableY] mino=" + mino.name + ", boardX=" + boardX + ", after=" + after);
    for (int boardY = after; boardY < (this.board.length) - (mino.getHeight()-1); boardY++) {
      if (minoColide(mino, boardY, boardX)) {
        return boardY-1;
      }
    }
    // (this.board.length-1) - (mino.getHeight()-1) == this.board.length - mino.getHeight()
    return this.board.length - mino.getHeight();
  }
  // boardY: top, boardX: left
  private boolean minoColide(Tetrimino mino, int boardY, int boardX) {
    int minoYMax = mino.form.length;
    int minoXMax = mino.form[0].length;
    for (int minoY = 0; minoY < minoYMax; minoY++) {
      for (int minoX = 0; minoX < minoXMax; minoX++) {
        if (!mino.form[minoY][minoX]) continue;
        if (this.board[boardY+minoY][boardX+minoX] != null) return true;
      }
    }
    return false;
  }

  private void forceAdd(Tetrimino mino, int boardY, int boardX) {
    int minoHeight = mino.getHeight();
    int minoWidth = mino.getWidth();
    println("[forceAdd] mino=" + mino.name + ", minoHeight=" + minoHeight + ", minoWidth=" + minoWidth + ", boardY=" + boardY + ", boardX=" + boardX);
    for (int minoY = 0; minoY < minoHeight; minoY++) {
      for (int minoX = 0; minoX < minoWidth; minoX++) {
        if (!mino.form[minoY][minoX]) continue;
        int y = boardY + minoY;
        int x = boardX + minoX;
        this.board[y][x] = mino;
      }
    }
  }

  // must clear canvas before call
  void draw(int x, int y, color boardColor) {
    fill(boardColor);
    rect(x, y, this.width, this.height);
    for (int boardY = BOARD_HIDDEN_ROWS; boardY < this.board.length; boardY++) {
      for (int boardX = 0; boardX < this.board[0].length; boardX++) {
        if (this.board[boardY][boardX] == null) continue;
        fill(this.board[boardY][boardX].blockColor);
        rect(x + this.blockSize * boardX, y + this.blockSize * (boardY - BOARD_HIDDEN_ROWS), this.blockSize, this.blockSize);
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
