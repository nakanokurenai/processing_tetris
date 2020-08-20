// [no line, single, double, tetris]
final int[] SCORE_PER_TOTAL_OF_DISAPPEARED_LINE = { 0, 40, 100, 300, 1200 };
final String[] NAME_PER_TOTAL_OF_DISAPPEARED_LINE = { null, "SINGLE", "DOUBLE", "TRIPLE", "TETRIS" };

Tetrimino forDebugSlowlyPickMino(String key) {
  for (int i = 0; i < MINO_LIST.length; i++) {
    if (MINO_LIST[i].name == key) return MINO_LIST[i].clone();
  }
  throw new Error("NO MINO");
}
Tetrimino dPick(String k) {
  return forDebugSlowlyPickMino(k);
}

Board board;
BoardManager boardManager;

void setup() {
  size(500, 1000);
  board = new Board(0,0,300,1000);

  board.add(dPick("T"), 2);
  board.add(dPick("S"), 0);
  board.add(dPick("I").rotateLeft(), 0);
  board.add(dPick("T"), 6);
  board.add(dPick("T").rotateLeft(), 8);
  board.add(dPick("I"), 1);

  board.add(dPick("T").rotateRight().rotateRight(), 4);
  Tetrimino spinT = dPick("T").rotateRight().rotateRight();
  spinT.blockColor = 0xff000000;
  board.add(spinT, 4, 18+2);

  boardManager = new BoardManager(1, board);
}

void draw() {
  clear();
  boardManager.tick();
  board.draw(0xffededed);
}
