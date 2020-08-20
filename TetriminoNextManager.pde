class TetriminoNextManager {
  private IntList choices;
  private IntList nextList;

  TetriminoNextManager() {
    this.resetChoices();
    nextList = new IntList();
    // look ahead
    this.select();
    this.select();
  }

  Tetrimino pop() {
    this.select();
    return MINO_LIST[this.nextList.remove(0)].clone();
  }
  Tetrimino[] getNextList() {
    Tetrimino[] nextList = {};
    for (int i = 0; i < this.nextList.size(); i++) {
      append(nextList, MINO_LIST[this.nextList.get(i)].clone());
    }
    return nextList;
  }
  void select() {
    if (choices.size() == 0) this.resetChoices();

    int chooseIndex = choices.remove(int(random(0, choices.size())));
    nextList.append(chooseIndex);
  }
  void resetChoices() {
    choices = new IntList();
    for (int i = 0; i < MINO_LIST.length; i++) {
      choices.append(i);
    }
  }
}
