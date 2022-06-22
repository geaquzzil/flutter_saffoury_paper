import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_controler.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class BaseSharedHeader extends StatelessWidget {
  const BaseSharedHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!SizeConfig.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<DrawerMenuController>().controlMenu,
          ),
        if (!SizeConfig.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!SizeConfig.isMobile(context))
          Spacer(flex: SizeConfig.isDesktop(context) ? 2 : 1),
        Expanded(child: SearchField()),
        HeaderActions(),
      ],
    );
  }
}

class HeaderActions extends StatelessWidget {
  List<Widget> actions = [
    IconBadge(onTap: () {}, icon: Icon(Icons.home), itemCount: 2,),
    IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
    IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
  ];
  HeaderActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeConfig.isMobile(context)
        ? const ProfileCard()
        : Row(
            children: [ProfileCard()]..addAll(actions),
          );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle),
          if (!SizeConfig.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Angelina Jolie"),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Icon(Icons.account_balance)),
        ),
      ),
    );
  }
}
