import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

// Our design contains Neumorphism design and i made a extention for it
// We can apply it on any  widget

// extension Texts on Text {
//   Text primery(BuildContext context) {
//     this.style = Theme.of(context)
//         .textTheme
//         .bodyLarge!
//         .copyWith(color: Theme.of(context).colorScheme.secondary);
//   }
// }

Widget getPrimaryText(BuildContext context, String text, {withPadding = true}) {
  Widget t = Text(
    text,
    style: Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(color: Theme.of(context).colorScheme.secondary),
  );
  if (withPadding) {
    return t.padding();
  }
  return t;
}

extension OnPressed on Widget {
  Widget padding() {
    return Padding(padding: const EdgeInsets.all(kDefaultPadding), child: this);
  }

  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                )),
                onPressed: () {
                  onPressed();
                },
                child: Container()),
          )
        ],
      );
}

extension Neumorphism on Widget {
  addNeumorphism({
    double borderRadius = 10.0,
    Offset offset = const Offset(5, 5),
    double blurRadius = 10,
    Color topShadowColor = Colors.white60,
    Color bottomShadowColor = const Color(0x26234395),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            offset: offset,
            blurRadius: blurRadius,
            color: bottomShadowColor,
          ),
          BoxShadow(
            offset: Offset(-offset.dx, -offset.dx),
            blurRadius: blurRadius,
            color: topShadowColor,
          ),
        ],
      ),
      child: this,
    );
  }
}
