part of '../text_splitter.dart';

abstract class Fragment {
  int end;

  int start;

  Fragment(this.start, this.end) {
    RangeError.checkValueInInterval(start, 0, end, 'start');
  }

  String asString();

  @override
  String toString() {
    return '($start-$end)';
  }
}
