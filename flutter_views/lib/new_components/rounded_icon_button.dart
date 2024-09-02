import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';

class RoundedIconButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;
  final double size;
  const RoundedIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).devicePixelRatio;
    debugPrint("d ==> $d");
    return ElevatedButton.icon(
      iconAlignment: IconAlignment.end,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: const Text(""),
    );
    // return ElevatedButton(
    //   onPressed: onTap,
    //   child: Icon(
    //     icon,
    //     // size: 20,
    //   ),
    //   style:ElevatedButton.styleFrom()

    //    ButtonStyle(
    //     shape: WidgetStateProperty.all(const CircleBorder()),

    //     // shadowColor: Theme.of(context).colorScheme.,
    //     // padding: MaterialStateProperty.all(EdgeInsets.all(20)),
    //     // backgroundColor: Theme.of(context).colorScheme.surfaceContainer
    //     // MaterialStateProperty.all(Colors.blue), // <-- Button color
    //     // overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
    //     //   if (states.contains(MaterialState.pressed))
    //     //     return Colors.red; // <-- Splash color
    //     // }),
    //   ),
    // );
    return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: size * d,
            height: size * d,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: kWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ));
  }
}
