import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/constants.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.0,
              child: TextField(
                style: const TextStyle(
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: const TextStyle(
                    color: kTextLightColor,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: kWhite,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  suffixIcon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    color: kPrimaryColor,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: kDefaultPadding / 2,
          ),
          RoundedIconButton(
            onTap: () {},
            icon: 'assets/icons/filter.svg',
          )
        ],
      ),
    );
  }
}
