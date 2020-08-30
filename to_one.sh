#!/bin/sh

FILES=$(cat <<EOF
processing_tetris.pde
MINO_LIST.pde
Tetrimino.pde
TetriminoNextManager.pde
Board.pde
BoardManager.pde
InputManager.pde
Throttler.pde
Pane.pde
LeftPane.pde
RightPane.pde
EOF
)

for file in $FILES; do
  echo "/*"
  echo " * cat $file"
  echo " */"
  echo
  cat $file
  echo
done
