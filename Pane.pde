class Pane {
  // render mino on 4x4 block
  private void drawTetrimino(Tetrimino mino, int x, int y) {
    drawTetrimino(mino, x, y, BLOCK_SIZE);
  }
  private void drawTetrimino(Tetrimino mino, int x, int y, int blockSize) {
    if (mino == null) return;
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
}
