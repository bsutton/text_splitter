import 'package:test/test.dart';
import 'package:text_splitter/text_splitter.dart';

void main() {
  test('Insert non empty fragment into empty text', () {
    final text = '';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(0, 0, '_text_'));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('_text_', _chunks2text(chunks));
  });

  test('Insert empty fragment into empty text', () {
    final text = '';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(0, 0, ''));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('', _chunks2text(chunks));
  });

  test('Insert fragments into mildle text', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(1, 3, '_123_'));
    fragments.add(_TextFragment(11, 13, '_123_'));
    fragments.add(_TextFragment(21, 23, '_123_'));
    fragments.add(_TextFragment(31, 33, '_123_'));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('0_123_4567890_123_4567890_123_4567890_123_456789',
        _chunks2text(chunks));
  });

  test('Insert fragments at the start of text', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(0, 2, '_012_'));
    fragments.add(_TextFragment(10, 12, '_012_'));
    fragments.add(_TextFragment(20, 22, '_012_'));
    fragments.add(_TextFragment(30, 32, '_012_'));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('_012_3456789_012_3456789_012_3456789_012_3456789',
        _chunks2text(chunks));
  });

  test('Insert fragments at the start of text', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(7, 9, '_789_'));
    fragments.add(_TextFragment(17, 19, '_789_'));
    fragments.add(_TextFragment(27, 29, '_789_'));
    fragments.add(_TextFragment(37, 39, '_789_'));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('0123456_789_0123456_789_0123456_789_0123456_789_',
        _chunks2text(chunks));
  });

  test('Insert fragments as the whole text', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(
        _TextFragment(0, 39, '_0123456789012345678901234567890123456789_'));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('_0123456789012345678901234567890123456789_', _chunks2text(chunks));
  });

  test('Insert empty fragments #1', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(0, 9, ''));
    fragments.add(_TextFragment(10, 19, ''));
    fragments.add(_TextFragment(20, 29, ''));
    fragments.add(_TextFragment(30, 39, ''));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('', _chunks2text(chunks));
  });

  test('Insert empty fragments #2', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(1, 3, ''));
    fragments.add(_TextFragment(11, 13, ''));
    fragments.add(_TextFragment(21, 23, ''));
    fragments.add(_TextFragment(31, 33, ''));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('0456789045678904567890456789', _chunks2text(chunks));
  });

  test('Fragments following each other', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(0, 9, '1'));
    fragments.add(_TextFragment(10, 19, '2'));
    fragments.add(_TextFragment(20, 29, '3'));
    fragments.add(_TextFragment(30, 39, '4'));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error, null);
    expect('1234', _chunks2text(chunks));
  });

  test('Insert fragment out of the text', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(38, 41, ''));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error == null, false);
    expect(error!.kind, TextSplitterErrorKind.outOfTExt);
  });

  test('Use intersected fragments', () {
    final text = '0123456789012345678901234567890123456789';
    final fragments = <_TextFragment>[];
    fragments.add(_TextFragment(38, 41, ''));
    final chunks = [Chunk(0, text)];
    final splitter = TextSplitter();
    final error = splitter.split(chunks, fragments);
    expect(error == null, false);
    expect(error!.kind, TextSplitterErrorKind.outOfTExt);
  });
}

String _chunks2text(List<Chunk> chunks) {
  return chunks
      .map((e) => e.fragment == null ? e.text : e.fragment!.asString())
      .join();
}

class _TextFragment extends Fragment {
  final String text;

  _TextFragment(int start, int end, this.text) : super(start, end);

  @override
  String asString() => text;
}
