import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBold extends StatelessWidget {
  String text;
  String regex;
  static const _separator = " ";

  TextBold({super.key, required this.text, required this.regex}) {
    regex = regex;
    text = text;
    // regex = "($regex)"; // + regex + r"+$";
  }

  @override
  Widget build(BuildContext context) {
    final parts = splitJoin();
    debugPrint("TextBold $regex parts => $parts");

    // return Html(data: text.replaceAll(regex, "<b>$regex</b>"));

    return RichText(
      text: TextSpan(
        text: text.replaceAll(regex, ""),
        style: Theme.of(context).textTheme.bodySmall,
        // style: TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(text: regex, style: Theme.of(context).textTheme.bodySmall
              // recognizer: _longPressRecognizer,
              ),
          // TextSpan(text: 'secret?'),
        ],
      ),
    );
    return Text.rich(TextSpan(
        children: parts
            .map((e) => TextSpan(
                text: e.text,
                style: (e.isBold)
                    ? GoogleFonts.mulish(
                        fontSize: 10, fontWeight: FontWeight.w800)
                    : GoogleFonts.mulish(
                        fontSize: 8, fontWeight: FontWeight.w400)))
            .toList()));
  }

  // Splits text using separator, tag ones to be bold using regex
  // and rejoin equal parts back when possible
  List<TextPart> splitJoin() {
    final tmp = <TextPart>[];

    final parts = text.split(_separator);

    RegExp e = RegExp(regex);

    // List<RegExpMatch> matches=e.allMatches(text);

    Iterable<Match> matches = e.allMatches(text);
    for (final Match m in matches) {
      String match = m[0]!;
      debugPrint("TextBold $match match");
    }
    // Bold it
    for (final p in parts) {
      tmp.add(TextPart(
          p + _separator, p.contains(RegExp(regex, caseSensitive: false))));
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
