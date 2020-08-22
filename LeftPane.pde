class LeftPane extends Pane {
  int width;
  private BoardManager boardManager;
  LeftPane(BoardManager bm) {
    this.boardManager = bm;
    this.width = BLOCK_SIZE * 4 + PADDING * 2;
  }
  void draw(int x, int y, color backgroundColor) {
    textAlign(LEFT, TOP);
    int currentY = y;

    fill(0);
    text("HOLD", x, currentY);
    currentY += FONT_SIZE + PADDING;
    fill(backgroundColor);
    rect(x, currentY, this.width, this.width);
    super.drawTetrimino(this.boardManager.getHoldMino(), x + PADDING, currentY + PADDING);
    currentY += this.width;

    currentY += PADDING * 2;

    // score
    fill(0);
    text("SCORE", x, currentY);
    currentY += FONT_SIZE + PADDING;
    fill(backgroundColor);
    rect(x, currentY, this.width, FONT_SIZE + PADDING*2);
    fill(0);
    text("" + this.boardManager.getScore(), x + PADDING, currentY + PADDING);
  }
}
