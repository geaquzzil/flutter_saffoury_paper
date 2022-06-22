import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_view_controller/components/rounded_icon_button.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_controler.dart';
import 'package:flutter_view_controller/screens/overlay_page.dart';
import 'package:flutter_view_controller/screens/shopping_cart_page.dart';
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
  void _insertOverlay(BuildContext context) {
    return Overlay.of(context)?.insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        print(size.width);
        return Positioned(
          width: 56,
          height: 56,
          top: size.height - 72,
          left: size.width - 72,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => print('ON TAP OVERLAY!'),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.redAccent),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _neverSatisfied(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You will never be satisfied.'),
                Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> actions = [
    // MenuTendina(
    //   altezza: 0,
    //   opacita: .1,
    //   child: Text("SDSDS"),
    //   notifiche: IconBadge(
    //     onTap: () {},
    //     icon: Icon(Icons.home),
    //     itemCount: 2,
    //   ),
    // ),

    IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
    IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
  ];
  HeaderActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeConfig.isMobile(context)
        ? const ProfileCard()
        : Row(children: [
            ProfileCard(),
            OverlayWidget(
              overlay: Text("THis is a test"),
              child: Icon(Icons.home),
            ),
          ]
            // ..addAll(actions),
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

class MenuTendina extends StatefulWidget {
  double opacita;
  double altezza;
  Widget child;
  Widget notifiche;

  MenuTendina(
      {Key? key,
      required this.child,
      required this.notifiche,
      required this.opacita,
      required this.altezza})
      : super(key: key);

  @override
  _MenuTendinaState createState() => _MenuTendinaState();
}

class _MenuTendinaState extends State<MenuTendina> {
  double opacita = 50;
  double altezza = 50;
  bool mostraTendina = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Container(
            width: MediaQuery.of(context).size.width,
            height:
                (this.mostraTendina) ? MediaQuery.of(context).size.height : 0.0,
            child: Opacity(
                opacity: widget.opacita,
                child: Container(
                    color: Colors.black,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.opacita = 0.0;
                          widget.altezza = 0.0;
                          this.mostraTendina = false;
                        });
                      },
                    )))),
        AnimatedContainer(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -5), spreadRadius: 0.0, blurRadius: 20)
            ],
          ),
          duration: Duration(milliseconds: 200),
          width: MediaQuery.of(context).size.width,
          height: this.altezza,
          child: widget.notifiche,
        )
      ],
    );
  }
}
