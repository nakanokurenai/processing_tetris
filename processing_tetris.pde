Board board;
BoardManager boardManager;

void setup() {
  size(500, 1000);
  board = new Board(0,0,300,1000);
  boardManager = new BoardManager(60, 10, board);
}

void draw() {
  clear();
  if (keyPressed == true && key == CODED) {
    switch (keyCode) {
      case UP: {
        boardManager.hardDrop();
        break;
      }
      case DOWN: {
        boardManager.moveDown();
        break;
      }
      case LEFT: {
        boardManager.moveLeft();
        break;
      }
      case RIGHT: {
        boardManager.moveRight();
        break;
      }
    }
  }
  boardManager.tick();
  board.draw(0xffededed);
}
