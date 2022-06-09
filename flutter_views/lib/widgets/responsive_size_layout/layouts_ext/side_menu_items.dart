import 'package:flutter/material.dart';
import 'counter_badge.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_view_controller/constants.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    Key? key,
    required this.isActive,
    this.isHover = false,
    this.itemCount,
    this.showBorder = true,
    required this.iconSrc,
    required this.title,
    required this.press,
  }) : super(key: key);

  final bool isActive, isHover, showBorder;
  final int? itemCount;
  final String iconSrc, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: GestureDetector(
        onTap: press,
        child: Row(
          children: [
            (isActive || isHover)
                ? SvgPicture.asset(
                    "Icons/Angle_right.svg",
                    width: 15,
                  )
                : const SizedBox(width: 15),
            const SizedBox(width: kDefaultPadding / 4),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 15, right: 5),
                decoration: showBorder
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFDFE2EF)),
                        ),
                      )
                    : null,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      iconSrc,
                      height: 20,
                      color: (isActive || isHover) ? kPrimaryColor : kGrayColor,
                    ),
                    const SizedBox(width: kDefaultPadding * 0.75),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color:
                                (isActive || isHover) ? kTextColor : kGrayColor,
                          ),
                    ),
                    const Spacer(),
                    if (itemCount != null) CounterBadge(count: itemCount)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
