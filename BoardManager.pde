class BoardManager {
  private int tickCounter;
  private TetriminoNextManager nextManager;
  final int waitCount;
  private Tetrimino currentMino;
  private int currentMinoX;
  private int currentMinoY;
  private Board board;

  private boolean isGameOver;
  BoardManager(int waitCount, Board board) {
    this.tickCounter = 0;
    this.waitCount = waitCount;
    this.nextManager = new TetriminoNextManager();
    this.board = board;
    this.popNextMino();
  }
 
  void popNextMino() {
    Tetrimino nextMino = this.nextManager.pop();
    if (!this.board.changeGhost(this.currentMino, 0, 0)) {
      this.onBoardFull();
    };
    this.currentMino = nextMino;
    this.currentMinoX = 0;
    this.currentMinoY = 0;
  }

  void tick() {
    if (this.isGameOver) return;
    tickCounter++;
    if (tickCounter > waitCount) {
      tickCounter = 0;
      this.onTickCounterReset();
      this.board.drawText();
    }
  }

  private void onTickCounterReset() {
    // drop current mino
    if (!this.board.changeGhost(this.currentMino, this.currentMinoY+1, this.currentMinoX)) {
      // if can't drop, confirm it
      this.onCurrentMinoConfirmed();
    };
    this.currentMinoY++;
  }
  private void onCurrentMinoConfirmed() {
    this.board.add(this.currentMino, this.currentMinoX);
    this.popNextMino();
  }
  private void onBoardFull() {
    // game over
    this.isGameOver = true;
  }

  // controls
  void hardDrop() {
    tickCounter = 0;
  }
  void moveLeft() {
    
  }
  void moveRight() {
    
  }
  void moveDown() {
    this.tickCounter = 0;
  }
  void rotateLeft() {
    
  }
  void rotateRight() {
    
  }
  private void doTSpin() {
    
  }
}
