ぷろせっしんぐ てとりす
===
<img src=./docs/play-b85cac5.gif width=500 />

LICENSE
---
- This project licensed under [CC0](./docs/CC0-1.0.txt) unless otherwise specified.
- [NotoSans Medium](./data/NotoSans-Medium-24.vlw) licensed under [SIL OFL](./docs/OFL-1.1.txt).

参考文献
---
- [テトリスのルール](https://www.nintendo.co.jp/ds/atrj/rule/index.html)
    + Nintendo Tetris DS のルール説明
    + Tスピンなどの特殊ルールは乗ってないので、始めに見た程度
    + 参考にした
      * ミノの色
- テトリスのかけら
  - 有志の Wiki
  - [テトリミノについて(旧)](https://w.atwiki.jp/tetriskakera/pages/17.html)
    + ミノの呼称
    + ミノの出現法則
  - [出現位置と負け判定(旧)](https://w.atwiki.jp/tetriskakera/pages/19.html)
    + 22段目を実装しておらず判定に悩み、そんなものがあったっけ? と思って検索して辿りついた
    + 21 ~ 22 段目を実装
      * 但し実装上は隠された22段目を0としている (左上が0,0)
