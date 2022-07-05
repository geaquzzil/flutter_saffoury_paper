import 'package:flutter/material.dart';

class TextBold extends StatelessWidget {
  final String text;
  final String regex;
  static const _separator = " ";

  const TextBold({Key? key, required this.text, this.regex = r'\d+'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parts = splitJoin();

    return Text.rich(TextSpan(
        children: parts
            .map((e) => TextSpan(
                text: e.text,
                style: (e.isBold)
                    ? const TextStyle(fontFamily: 'bold', fontSize: 20)
                    : const TextStyle(fontFamily: 'light', fontSize: 16)))
            .toList()));
  }

  // Splits text using separator, tag ones to be bold using regex
  // and rejoin equal parts back when possible
  List<TextPart> splitJoin() {
    final tmp = <TextPart>[];

    final parts = text.split(_separator);

    // Bold it
    for (final p in parts) {
      tmp.add(TextPart(p + _separator, p.contains(RegExp(regex))));
    }

    final result = <TextPart>[tmp[0]];
    // Fold it
    if (tmp.length > 1) {
      int resultIdx = 0;
      for (int i = 1; i < tmp.length; i++) {
        if (tmp[i - 1].isBold != tmp[i].isBold) {
          result.add(tmp[i]);
          resultIdx++;
        } else {
          result[resultIdx].text = result[resultIdx].text + tmp[i].text;
        }
      }
    }

    return result;
  }
}

class TextPart {
  String text;
  bool isBold;

  TextPart(this.text, this.isBold);
}
