import 'package:text_splitter/text_splitter.dart';

void main() {
  String replace(String s) {
    return '// Removed: $s';
  }

  // Let's assume that the locations for the fragments were obtained from a
  // parser (from tokens).

  // Suppose we need to remove some directives and annotations and merge two files
  // into one ffile.

  // main.dart
  print('--- main.dart ---');
  print(_main_dart);
  final mainFragments = <_Fragment>[];
  mainFragments.add(_Fragment(0, 15, 'part \'foo.dart\';', replace));
  mainFragments.add(_Fragment(30, 33, '@Foo', replace));
  final mainChunks = [Chunk(0, _main_dart)];
  final mainSplitter = TextSplitter();
  final mainError = mainSplitter.split(mainChunks, mainFragments);
  if (mainError != null) {
    _errpr(mainError);
  }

  final mainText = mainChunks
      .map((e) => e.fragment == null ? e.text : e.fragment!.asString())
      .join();

  // foo.dart
  print('--- foo.dart ---');
  print(_foo_dart);
  final fooFragments = <_Fragment>[];
  fooFragments.add(_Fragment(0, 20, 'part of \'main.dart\';', replace));
  final fooChunks = [Chunk(0, _foo_dart)];
  final fooSplitter = TextSplitter();
  final fooError = fooSplitter.split(fooChunks, fooFragments);
  if (fooError != null) {
    _errpr(fooError);
  }

  final fooText = fooChunks
      .map((e) => e.fragment == null ? e.text : e.fragment!.asString())
      .join();

  final newMainText = [mainText, '// File: foo.dart', fooText].join('\n');
  print('--- main.dart ---');
  print(newMainText);
}

Never _errpr(TextSplitterError error) {
  final fragment = error.fragment;
  final start = fragment.start;
  final end = fragment.end;
  late String message;
  switch (error.kind) {
    case TextSplitterErrorKind.intersection:
      message = 'Fragment intersection ($start, $end)';
      break;
    case TextSplitterErrorKind.outOfTExt:
      message = 'Fragment ($start, $end) out of text';
      break;
  }

  throw message;
}

const _foo_dart = '''
part of
 'main.dart';

int y = 0;

class Bar {
  int x;
}
''';

const _main_dart = '''
part 'foo.dart';

int x = 0;

@Foo
class Baz {
  int x;
}
''';

class _Fragment extends Fragment {
  final String code;

  String Function(String) replace;

  _Fragment(int start, int end, this.code, this.replace) : super(start, end);

  @override
  String asString() => replace(code);
}
