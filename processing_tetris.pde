Board board;
BoardManager boardManager;
InputManager inputManager;
int blockSize;

static int BLOCK_SIZE = 30;
static int PADDING = 8;
// this is copy; original painWidth calculated in BoardManager
static int EXPECTED_PANE_WIDTH = BLOCK_SIZE * 4 + PADDING * 2;

void setup() {
  // (leftPain 120 + left-right PADDING * 2) + PADDING*2 + (board 300) + PADDING*2 + (rightPain 120 + left-right PADDING) + (left-right margin 50) * 2 = 704
  size(704, 700);
  PFont font = loadFont("NotoSans-Medium-24.vlw");
  int fontSize = 24;
  textFont(font, fontSize);

  // board must be 300x600 -> block must be 30x30
  blockSize = min(600 / 20, 300 / 10);

  board = new Board();
  boardManager = new BoardManager(60, board, fontSize);
  inputManager = new InputManager(boardManager, 10);
  noStroke();
}

void draw() {
  background(0xff);
  inputManager.touch();
  inputManager.tick();
  boardManager.tick();
  board.draw(50+EXPECTED_PANE_WIDTH+PADDING*2,50,0xffededed);
  boardManager.draw(50, 50, 0xffededed);
}
