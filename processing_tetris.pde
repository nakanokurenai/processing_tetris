Board board;
BoardManager boardManager;
InputManager inputManager;

void setup() {
  size(500, 1000);
  board = new Board(0,0,300,1000);
  boardManager = new BoardManager(60, board);
  inputManager = new InputManager(boardManager, 10);
  noStroke();
}

void draw() {
  clear();
  inputManager.touch();
  inputManager.tick();
  boardManager.tick();
  board.draw(0xffededed);
}
