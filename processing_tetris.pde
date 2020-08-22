Board board;
BoardManager boardManager;
InputManager inputManager;

void setup() {
  size(650, 700);
  board = new Board(300,600);
  boardManager = new BoardManager(60, board);
  inputManager = new InputManager(boardManager, 10);
  noStroke();
}

void draw() {
  background(0xff);
  inputManager.touch();
  inputManager.tick();
  boardManager.tick();
  board.draw(50,50,0xffededed);
  boardManager.draw(400, 50, 0xffededed);
}
