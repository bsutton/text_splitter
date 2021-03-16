part of '../text_splitter.dart';

class TextSplitter {
  TextSplitterError? split(List<Chunk> chunks, List<Fragment> fragments) {
    fragments = fragments.toList();
    fragments.sort((x, y) => x.start.compareTo(y.start));
    Fragment? prev;
    for (final fragment in fragments) {
      if (prev != null && fragment.start == prev.end) {
        return TextSplitterError(
            fragment: fragment, kind: TextSplitterErrorKind.intersection);
      }

      prev = fragment;
    }

    var lastChunkIndex = 0;
    for (final fragment in fragments) {
      var inserted = false;
      for (var i = lastChunkIndex; i < chunks.length; i++) {
        final chunk = chunks[i];
        if (fragment.start >= chunk.start && fragment.end <= chunk.end) {
          if (chunk.fragment != null) {
            return TextSplitterError(
                fragment: fragment, kind: TextSplitterErrorKind.intersection);
          }

          if (chunk.start == chunk.end) {
            final single = Chunk(chunk.start, '', fragment);
            chunks.insert(i, single);
          } else {
            final fs = fragment.start;
            final fe = fragment.end;
            final offset = chunk.start;
            final first = Chunk(offset, chunk.text.substring(0, fs - offset));
            final middle = Chunk(fs,
                chunk.text.substring(fs - offset, fe - offset + 1), fragment);
            final last = Chunk(fe + 1, chunk.text.substring(fe - offset + 1));
            final list = <Chunk>[];
            if (first.text.isNotEmpty) {
              list.add(first);
            }

            list.add(middle);
            if (last.text.isNotEmpty) {
              list.add(last);
            }

            chunks.removeAt(i);
            chunks.insertAll(i, list);
          }

          inserted = true;
          lastChunkIndex = i;
          break;
        }
      }

      if (!inserted) {
        return TextSplitterError(
            fragment: fragment, kind: TextSplitterErrorKind.outOfTExt);
      }
    }

    return null;
  }
}
