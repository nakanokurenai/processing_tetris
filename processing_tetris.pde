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
    0,
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

void setup() {
  size(500, 1000);
  board = new Board(0,0,300,1000);
  Tetrimino tMino = new Tetrimino("T", 0xffa134eb, new boolean[][] {
    {false,true,false},
    {true,true,true},
  }).rotateLeft().rotateRight();
  Tetrimino tMinoRight = tMino.clone().rotateRight();

  board.add(tMino, 0);
  board.add(tMino, 2);
  board.add(tMinoRight, 5);

  board.draw(0xffededed);
}
