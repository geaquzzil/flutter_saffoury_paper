import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:skeletons/skeletons.dart';

class ListHorizontalItemShimmer extends StatelessWidget {
  int lines;
  ListHorizontalItemShimmer({super.key,this.lines=2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: SkeletonItem(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(14),
                  // maxHeight: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ),
            SkeletonParagraph(
              style: SkeletonParagraphStyle(
                  lines: lines,
                  spacing: 6,
                  lineStyle: SkeletonLineStyle(
                    randomLength: true,
                    height: 10,
                    borderRadius: BorderRadius.circular(8),
                    // minLength: MediaQuery.of(context).size.width / 6,
                    // maxLength: MediaQuery.of(context).size.width / 3,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
