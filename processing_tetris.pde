Board board;
BoardManager boardManager;
InputManager inputManager;
LeftPane leftPane;
RightPane rightPane;

// board must be 300x600 -> block must be 30x30
static int BLOCK_SIZE = 30;
static int PADDING = 8;
static int FONT_SIZE = 24;

void setup() {
  // (leftPain 120 + left-right PADDING * 2) + PADDING*2 + (board 300) + PADDING*2 + (rightPain 120 + left-right PADDING) + (left-right margin 50) * 2 = 704
  size(704, 700);
  textSize(FONT_SIZE);

  board = new Board();
  boardManager = new BoardManager(60, board);
  inputManager = new InputManager(boardManager, 10);
  leftPane = new LeftPane(boardManager);
  rightPane = new RightPane(boardManager);
  noStroke();
}

static color BACKGROUND_COLOR = 0xffededed;
void draw() {
  background(0xff);
  inputManager.touch();
  inputManager.tick();
  boardManager.tick();
  leftPane.draw(50, 50, BACKGROUND_COLOR);
  board.draw(50+leftPane.width+PADDING*2,50,BACKGROUND_COLOR);
  rightPane.draw(50+leftPane.width+PADDING*2+board.width+PADDING*2, 50, BACKGROUND_COLOR);
  if (boardManager.isGameOver()) {
    // overlay "GAME OVER" text on the board
    fill(0x66000000);
    rect(50+leftPane.width+PADDING*2,50,board.width,board.height);
    fill(0xffffffff);
    textAlign(CENTER, CENTER);
    text("GAME OVER",
      (50+leftPane.width+PADDING*2) + board.width/2,
      50 + board.height/2);
  }
}
