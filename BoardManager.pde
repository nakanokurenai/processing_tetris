// [no line, single, double, tetris]
final int[] SCORE_PER_TOTAL_OF_DISAPPEARED_LINE = { 0, 40, 100, 300, 1200 };
final String[] NAME_PER_TOTAL_OF_DISAPPEARED_LINE = { null, "SINGLE", "DOUBLE", "TRIPLE", "TETRIS" };

class BoardManager {
  private int tickCounter;

  final int dropTickTiming;
  final int inputProcessTiming;
  int inputDX; int inputDY; 

  private Board board;
  private TetriminoNextManager nextManager;

  private Tetrimino currentMino;
  private int currentMinoX;
  private int currentMinoY;

  private boolean isGameOver;
  BoardManager(int dropTickTiming, int inputProcessTiming, Board board) {
    this.tickCounter = 0;
    this.dropTickTiming = dropTickTiming;
    this.inputProcessTiming = inputProcessTiming;
    this.inputDX = 0;
    this.inputDY = 0;
    this.nextManager = new TetriminoNextManager();
    this.board = board;
    this.popNextMino();
  }
 
  private void popNextMino() {
    Tetrimino nextMino = this.nextManager.pop();
    if (!this.board.changeGhost(nextMino, 0, 0)) {
      this.onBoardFull();
    };
    this.currentMino = nextMino;
    this.currentMinoX = 0;
    this.currentMinoY = 0;
  }
  private void confirmCurrentMino() {
    this.board.add(this.currentMino, this.currentMinoX, this.currentMinoY);
    this.popNextMino();
    tickCounter = 0;
  }
  private void restoreGhost() {
    this.board.changeGhost(this.currentMino, this.currentMinoY, this.currentMinoX);
  }

  void tick() {
    if (this.isGameOver) return;

    tickCounter++;
    int matched = 0;

    if (tickCounter % inputProcessTiming == 0) {
      matched++;
      this.onProceeeInput();
    }
    if (tickCounter % dropTickTiming == 0) {
      matched++;
      this.onDropCurrentMino();
    }

    if (matched == 2) this.tickCounter = 0;
  }

  // event handlers
  private void onDropCurrentMino() {
    // drop current mino
    if (!this.board.changeGhost(this.currentMino, this.currentMinoY+1, this.currentMinoX)) {
      // if can't drop, confirm it
      this.confirmCurrentMino();
    };
    this.currentMinoY++;

    this.board.drawText();
  }
  private void onProceeeInput() {
    if (this.inputDY == 0 && this.inputDX == 0) {
      return;
    }

    if (this.inputDY == -1) {
      // hard drop
      this.board.flushGhost();
      this.confirmCurrentMino();
      this.inputDY = 0;
      this.inputDX = 0;
      return;
    }

    if (!this.board.changeGhost(this.currentMino, this.currentMinoY + this.inputDY, this.currentMinoX + this.inputDX)) {
      this.restoreGhost();
      return;
    }
    this.currentMinoY += this.inputDY;
    this.currentMinoX += this.inputDX;
    this.inputDY = 0;
    this.inputDX = 0;
  }
  private void onBoardFull() {
    // game over
    this.isGameOver = true;
  }

  // controls
  void hardDrop() {
    this.inputDY = -1;
    this.inputDX = 0;
  }
  void moveLeft() {
    this.inputDY = 0;
    this.inputDX = -1;
  }
  void moveRight() {
    this.inputDY = 0;
    this.inputDX = 1;
  }
  void moveDown() {
    this.inputDY = 1;
    this.inputDX = 0;
  }
  void rotateLeft() {
    if (this.isGameOver) return;
    
  }
  void rotateRight() {
    if (this.isGameOver) return;
    
  }
  private void doTSpin() {
    
  }
}
