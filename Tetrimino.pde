/*
[[true, true, true, true]] = I Tetrimino
[[true, true],
 [true, true]] = O Tetrimino
*/

class Tetrimino {
  // DON'T EDIT FROM OUTSIDE
  boolean[][] form;
  String name;
  color blockColor;
  Tetrimino(String name, color blockColor, boolean[][] form) {
    if (!this.validateForm(form)) {
      throw new Error("form is invalid");
    }
    this.name = name;
    this.form = form;
    this.blockColor = blockColor;
  }
  Tetrimino clone() {
    boolean[][] clonedForm = new boolean[this.form.length][this.form[0].length];
    for (int i = 0; i < this.form.length; i++) {
       arrayCopy(this.form[i], clonedForm[i]);
    }
    return new Tetrimino(this.name, this.blockColor, clonedForm);
  }

  boolean validateForm(boolean[][] form) {
    // TODO
    return true;
  }

  // chainable methods
  Tetrimino rotateLeft() {
    int iMax = this.form.length;
    int jMax = this.form[0].length;
    println("[rot] iMax=", iMax, "jMax=", jMax);
    boolean[][] newForm = new boolean[jMax][iMax];
    for (int i = 0; i < iMax; i++) {
      for (int j = 0; j < jMax; j++) {
        println("[rot] y=" + i + ", x=" + j + " -> y=" + j + ", x=" + ((iMax-1)-i));
        newForm[(jMax-1)-j][i] = this.form[i][j];
      }
    }
    this.form = newForm;
    this.name += "-L";
    return this;
  }
  Tetrimino rotateRight() {
    int iMax = this.form.length;
    int jMax = this.form[0].length;
    println("[rot] iMax=", iMax, "jMax=", jMax);
    boolean[][] newForm = new boolean[jMax][iMax];
    for (int i = 0; i < iMax; i++) {
      for (int j = 0; j < jMax; j++) {
        println("[rot] y=" + i + ", x=" + j + " -> y=" + j + ", x=" + ((iMax-1)-i));
        newForm[j][(iMax-1)-i] = this.form[i][j];
      }
    }
    this.form = newForm;
    this.name += "-R";
    return this;
  }

  // helpers
  int getWidth() {
    return this.form[0].length;
  }
  int getHeight() {
    return this.form.length;
  }

  
  // [debug]
  void drawText() {
    println("[mino] drawText: " + this.name);
    for (int i = 0; i < this.form.length; i++) {
      for (int j = 0; j < this.form[0].length; j++) {
        print((this.form[i][j] ? "x" : "_") + " ");
      }
      println();
    }
  }
}
