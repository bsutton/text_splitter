part of '../text_splitter.dart';

class Chunk {
  int start;

  Fragment? fragment;

  String text;

  Chunk(this.start, this.text, [this.fragment]);

  int get end {
    return start + text.length;
  }

  @override
  String toString() {
    return '$start-$end: $text';
  }
}
