class RightPane extends Pane {
  int width;
  private BoardManager boardManager;
  private color backgroundColor;
  RightPane(BoardManager bm) {
    this.boardManager = bm;
    this.width = BLOCK_SIZE * 4 + PADDING * 2;
  }
  void draw(int x, int y, color backgroundColor) {
    textAlign(LEFT, TOP);
    int currentY = y;
    this.backgroundColor = backgroundColor;

    // next
    fill(0);
    Tetrimino[] nextList = this.boardManager.getNextMinos();
    text("NEXT", x, currentY);
    currentY += FONT_SIZE + PADDING;

    currentY += drawScaledTetriMino(nextList[0], x, currentY, BLOCK_SIZE);
    currentY += PADDING;
    currentY += drawScaledTetriMino(nextList[1], x, currentY, int(BLOCK_SIZE*0.8));
    currentY += PADDING;
    currentY += drawScaledTetriMino(nextList[2], x, currentY, int(BLOCK_SIZE*0.6));
  }
  int drawScaledTetriMino(Tetrimino mino, int x, int y, int blockSize) {
    fill(backgroundColor);
    rect(x, y, blockSize*4 + PADDING*2, blockSize*4 + PADDING*2);
    super.drawTetrimino(mino, x + PADDING, y + PADDING, blockSize);
    return blockSize*4 + PADDING*2;
  }
}
