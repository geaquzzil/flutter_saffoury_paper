import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/overlay_page.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class BaseAppSharedHeader extends StatelessWidget {
  const BaseAppSharedHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!SizeConfig.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context
                .read<DrawerMenuControllerProvider>()
                .controlStartDrawerMenu,
          ),
        if (!SizeConfig.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!SizeConfig.isMobile(context))
          Spacer(flex: SizeConfig.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
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
        debugPrint("$size.width");
        return Positioned(
          width: 56,
          height: 56,
          top: size.height - 72,
          left: size.width - 72,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () => debugPrint('ON TAP OVERLAY!'),
              child: Container(
                decoration: const BoxDecoration(
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
          title: const Text('Rewind and remember'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You will never be satisfied.'),
                Text('You’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: const <Widget>[
            // FlatButton(
            //   child: const Text('Regret'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
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

    IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
    IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
  ];
  HeaderActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeConfig.isMobile(context)
        ? const ProfileCard()
        : Row(children: [
            const ProfileCard(),
            OverlayWidget(
              overlay: const Text("THis is a test"),
              child: const Icon(Icons.home),
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
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
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
          const Icon(Icons.account_circle),
          if (!SizeConfig.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Angelina Jolie"),
            ),
          const Icon(Icons.keyboard_arrow_down),
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
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Icon(Icons.account_balance)),
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
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: (mostraTendina) ? MediaQuery.of(context).size.height : 0.0,
            child: Opacity(
                opacity: widget.opacita,
                child: Container(
                    color: Colors.black,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.opacita = 0.0;
                          widget.altezza = 0.0;
                          mostraTendina = false;
                        });
                      },
                    )))),
        AnimatedContainer(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -5), spreadRadius: 0.0, blurRadius: 20)
            ],
          ),
          duration: const Duration(milliseconds: 200),
          width: MediaQuery.of(context).size.width,
          height: altezza,
          child: widget.notifiche,
        )
      ],
    );
  }
}
