import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ListHorizontalItemShimmer extends StatelessWidget {
  int lines;
  ListHorizontalItemShimmer({super.key, this.lines = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: SkeletonItem(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  borderRadius: BorderRadius.circular(20.0),
                  width: double.infinity,
                  randomWidth: false,
                  // padding:
                  // borderRadius: BorderRadius.circular(14),
                  // maxHeight: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ),
            if (lines != 0)
              SkeletonParagraph(
                style: SkeletonParagraphStyle(
                    lines: lines,
                    spacing: 6,
                    lineStyle: SkeletonLineStyle(
                      randomLength: true,
                      height: 8,
                      borderRadius: BorderRadius.circular(8),
                      // minLength: MediaQuery.of(context).size.width / 6,
                      // maxLength: MediaQuery.of(context).size.width / 3,
                    )),
              )
          ],
        )),
      ),
    );
  }
}
