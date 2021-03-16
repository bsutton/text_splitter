part of '../text_splitter.dart';

class TextSplitterError {
  Fragment fragment;

  TextSplitterErrorKind kind;

  TextSplitterError({required this.fragment, required this.kind});
}

enum TextSplitterErrorKind { intersection, outOfTExt }
