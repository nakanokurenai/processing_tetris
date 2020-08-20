// [no line, single, double, tetris]
final int[] SCORE_PER_TOTAL_OF_DISAPPEARED_LINE = { 0, 40, 100, 300, 1200 };
final String[] NAME_PER_TOTAL_OF_DISAPPEARED_LINE = { null, "SINGLE", "DOUBLE", "TRIPLE", "TETRIS" };

Board board;
BoardManager boardManager;

void setup() {
  size(500, 1000);
  board = new Board(0,0,300,1000);
  boardManager = new BoardManager(30, board);
}

void draw() {
  clear();
  boardManager.tick();
  board.draw(0xffededed);
}
