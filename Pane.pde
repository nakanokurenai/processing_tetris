class Pane {
  // render mino on 4x4 block
  private void drawTetrimino(Tetrimino mino, int x, int y) {
    drawTetrimino(mino, x, y, BLOCK_SIZE);
  }
  private void drawTetrimino(Tetrimino mino, int x, int y, int blockSize) {
    if (mino == null) return;
    float centeredY = y + (4 - mino.getHeight()) * blockSize / 2;
    float centeredX = x + (4 - mino.getWidth()) * blockSize / 2;
    fill(mino.blockColor);
    for (int i = 0; i < mino.getHeight(); i++) {
      for (int j = 0; j < mino.getWidth(); j++) {
        if (!mino.form[i][j]) continue;
        rect(centeredX + blockSize*j, centeredY + blockSize*i, blockSize, blockSize);
      }
    }
  }
}
