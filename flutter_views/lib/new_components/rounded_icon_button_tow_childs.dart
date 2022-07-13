import 'package:flutter/material.dart';

class RoundedIconButtonTowChilds extends StatelessWidget {
  Widget largChild;
  IconData smallIcon;
  RoundedIconButtonTowChilds({
    Key? key,
    required this.largChild,
    required this.smallIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // CircleAvatar(
          //   child: Icon(largChild),
          // ),
          largChild,
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 20,
              width: 20,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  primary: Colors.black87,
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: Icon(smallIcon),
              ),
            ),
          )
        ],
      ),
    );
  }
}
