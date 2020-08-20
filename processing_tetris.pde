Board board;

final Tetrimino[] MINO_LIST = {
  new Tetrimino(
    "S",
    // green
    0xff70d48b,
    new boolean[][] {
     {false,true,true},
     {true,true,false},
    }
  ),
  new Tetrimino(
    "Z",
    // red
    0xfff56d47,
    new boolean[][] {
      {true,true,false},
      {false,true,true},
    }
  ),
  new Tetrimino(
    "O",
    // yellow
    0xfffff98a,
    new boolean[][] {
      {true,true},
      {true,true},
    }
  ),
  new Tetrimino(
    "L",
    // orange
    0xffd49966,
    new boolean[][] {
      {false,false,true},
      {true,true,true},
    }
  ),
  new Tetrimino(
    "J",
    // blue
    0xff667cd4,
    new boolean[][] {
      {true,false,false},
      {true,true,true},
    }
  ),
  new Tetrimino(
    "I",
    // skyblue
    0xff73cbd9,
    new boolean[][] {
      {true,true,true,true}
    }
  ),
  new Tetrimino(
    "T",
    // purple
    0xffa134eb,
    new boolean[][] {
      {false,true,false},
      {true,true,true},
    }
  ),
};

Tetrimino forDebugSlowlyPickMino(String key) {
  for (int i = 0; i < MINO_LIST.length; i++) {
    if (MINO_LIST[i].name == key) return MINO_LIST[i].clone();
  }
  throw new Error("NO MINO");
}

void setup() {
  size(500, 1000);
  board = new Board(0,0,300,1000);

  board.add(forDebugSlowlyPickMino("S"), 0);
  board.add(forDebugSlowlyPickMino("Z"), 0);
  board.add(forDebugSlowlyPickMino("L"), 0);
  board.add(forDebugSlowlyPickMino("O"), 0);
  board.add(forDebugSlowlyPickMino("L"), 0);
  board.add(forDebugSlowlyPickMino("J"), 0);
  board.add(forDebugSlowlyPickMino("I"), 0);
  board.add(forDebugSlowlyPickMino("T"), 0);
  board.add(forDebugSlowlyPickMino("T").rotateLeft(), 2);

  board.draw(0xffededed);
}
