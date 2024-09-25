import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/menu_item.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:intl/intl.dart';

const Color compexDrawerCanvasColor = Color(0xffe3e9f7);
const Color complexDrawerBlack = Color(0xff11111d);
const Color complexDrawerBlueGrey = Color(0xff1d1b31);

class Txt extends StatefulWidget {
  final FontStyle? style;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final bool useoverflow;
  final bool upperCaseFirst;
  final bool quoted;
  final bool useFiler;
  final bool underline;
  final bool fullUpperCase;
  final dynamic text;
  final String? family;
  final bool toRupees;
  final bool toTimeAgo;
  final String? prefix;
  final bool strikeThrough;

  const Txt({
    super.key,
    this.style,
    this.fontWeight,
    this.maxLines,
    this.fontSize,
    this.color,
    this.textAlign,
    this.useoverflow = false,
    this.upperCaseFirst = false,
    this.quoted = false,
    this.useFiler = false,
    this.underline = false,
    this.fullUpperCase = false,
    required this.text,
    this.family,
    this.prefix,
    this.toRupees = false,
    this.toTimeAgo = false,
    this.strikeThrough = false,
  });

  @override
  _TxtState createState() => _TxtState();
}

///Returns the [DateTime] values in a human readable format
String timeAgo(
  dynamic input, {
  String? prefix,
}) {
  DateTime? finalDateTime;

  if (input is DateTime) finalDateTime = input;
  if (input is int) finalDateTime = DateTime.fromMillisecondsSinceEpoch(input);

  ///If the input is not valid, then just return ''
  if (finalDateTime == null) return '';

  final Duration difference = DateTime.now().difference(finalDateTime);
  bool isPast = finalDateTime.millisecondsSinceEpoch <=
      DateTime.now().millisecondsSinceEpoch;
  String ago;

  if (difference.inDays > 8) {
    ago = finalDateTime.toString().substring(0, 10);
  } else if ((difference.inDays / 7).floor() >= 1) {
    ago = isPast ? '1 week ago' : '1 week';
  } else if (difference.inDays >= 2) {
    ago =
        isPast ? '${difference.inDays} days ago' : '${difference.inDays} days';
  } else if (difference.inDays >= 1) {
    ago = isPast ? 'Yesterday' : 'Tomorrow';
  } else if (difference.inHours >= 2) {
    ago = '${difference.inHours} hours ${isPast ? 'ago' : ''}';
  } else if (difference.inHours >= 1) {
    ago = '1 hour ${isPast ? 'ago' : ''}';
  } else if (difference.inMinutes >= 2) {
    ago = '${difference.inMinutes} minutes ${isPast ? 'ago' : ''}';
  } else if (difference.inMinutes >= 1) {
    ago = '1 minute ${isPast ? 'ago' : ''}';
  } else if (difference.inSeconds >= 3) {
    ago = '${difference.inSeconds} seconds ${isPast ? 'ago' : ''}';
  } else {
    ago = isPast ? 'Just now' : 'now';
  }
  return prefix == null ? ago : '$prefix $ago';
}

class _TxtState extends State<Txt> {
  String finalText = "";

  /// finalText = strings.english;
  @override
  Widget build(BuildContext context) {
//Any
    finalText = widget.text.toString();
//String
    if (widget.text is String) finalText = widget.text ?? "Error";
//Numbers
    if ((widget.text is double || widget.text is int)) {
      if (widget.toRupees) {
        finalText = NumberFormat.simpleCurrency()
            .format(widget.text)
            .replaceAll('\$', '₹')
            .replaceAll(".00", "");
      }
      if (widget.toTimeAgo) {
        finalText = timeAgo(widget.text, prefix: widget.prefix);
      }
      if (widget.toRupees == false && widget.toTimeAgo == false) {
        finalText = widget.text.toString();
      }
    }

    if (widget.upperCaseFirst && finalText.length > 1) {
      finalText =
          "${finalText[0].toUpperCase()}${finalText.substring(1, finalText.length).toLowerCase()}";
    }
    if (widget.fullUpperCase) finalText = finalText.toUpperCase();
    if (widget.useFiler) {
      finalText = finalText
          .replaceAll("*", "")
          .replaceAll("_", "")
          .replaceAll("-", "")
          .replaceAll("#", "")
          .replaceAll("\n", "")
          .replaceAll("!", "")
          .replaceAll('[', '')
          .replaceAll(']', '');
    }
    if (widget.quoted) finalText = "❝$finalText❞";

    return Text((finalText).toString(),
        overflow: widget.useoverflow ? TextOverflow.ellipsis : null,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        textScaleFactor: 1,
        style: TextStyle(
          decoration: widget.underline
              ? TextDecoration.underline
              : (widget.strikeThrough ? TextDecoration.lineThrough : null),
          color: widget.color,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontStyle: widget.style,
          fontFamily: widget.family,
        ));
  }
}

class CDM {
  //complex drawer menu
  final IconData icon;
  final String title;
  final List<String> submenus;

  CDM(this.icon, this.title, this.submenus);
}

class ComplexDrawerPage extends StatefulWidget {
  const ComplexDrawerPage({super.key});

  @override
  _ComplexDrawerPageState createState() => _ComplexDrawerPageState();
}
// static const Color compexDrawerScaffoldColor = Color(0xfe3e9f7);

class _ComplexDrawerPageState extends State<ComplexDrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: body(),
      drawer: const ComplexDrawer(),
      drawerScrimColor: Colors.transparent,
      backgroundColor: compexDrawerCanvasColor,
    );
  }

  AppBar appBar() {
    return AppBar(
      iconTheme: IconTheme.of(context).copyWith(
        color: complexDrawerBlack,
      ),
      title: const Txt(
        text: "Complex Drawer",
        color: complexDrawerBlack,
      ),
      backgroundColor: compexDrawerCanvasColor,
    );
  }

  Widget body() {
    return Center(
      child: Container(
        foregroundDecoration: const BoxDecoration(
          color: complexDrawerBlack,
          backgroundBlendMode: BlendMode.saturation,
        ),
        child: const FlutterLogo(
          size: 150,
        ),
      ),
    );
  }
}

class ComplexDrawer extends StatefulWidget {
  const ComplexDrawer({super.key});

  @override
  _ComplexDrawerState createState() => _ComplexDrawerState();
}

class _ComplexDrawerState extends State<ComplexDrawer> {
  int selectedIndex = -1; //dont set it to 0

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      color: Colors.transparent,
      child: row(),
    );
  }

  Widget row() {
    return Row(children: [
      isExpanded ? blackIconTiles() : blackIconMenu(),
      invisibleSubMenus(),
    ]);
  }

  Widget blackIconTiles() {
    return Container(
      width: 200,
      color: Colors.transparent,
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (BuildContext context, int index) {
                //  if(index==0) return controlTile();

                CDM cdm = cdms[index];
                bool selected = selectedIndex == index;
                return ExpansionTile(
                    onExpansionChanged: (z) {
                      setState(() {
                        selectedIndex = z ? index : -1;
                      });
                    },
                    leading: Icon(cdm.icon, color: Colors.white),
                    title: Txt(
                      text: cdm.title,
                      color: Colors.white,
                    ),
                    trailing: cdm.submenus.isEmpty
                        ? null
                        : Icon(
                            selected
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                    children: cdm.submenus.map((subMenu) {
                      return sMenuButton(subMenu, false);
                    }).toList());
              },
            ),
          ),
          accountTile(),
        ],
      ),
    );
  }

  Widget controlTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListTile(
        leading: const FlutterLogo(),
        title: const Txt(
          text: "FlutterShip",
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }

  Widget blackIconMenu() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 100,
      color: complexDrawerBlack,
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
                itemCount: cdms.length,
                itemBuilder: (contex, index) {
                  GlobalKey key = GlobalKey();
                  // if(index==0) return controlButton();
                  return InkWell(
                    onTap: () {
                      showPopupMenu(context, key,
                          alignment: Alignment.centerRight,
                          list: [
                            const PopupMenuItem<MenuItemBuild>(
                                child: ListTile(
                              title: Text("test"),
                              leading: Icon(Icons.add),
                            )),
                            const PopupMenuItem<MenuItemBuild>(
                                child: ListTile(
                              title: Text("t"),
                              leading: Icon(Icons.edit),
                            ))
                          ]);
                      // setState(() {
                      //   selectedIndex = index;
                      // });
                    },
                    child: Container(
                      key: key,
                      height: 45,
                      alignment: Alignment.center,
                      child: Icon(cdms[index].icon, color: Colors.white),
                    ),
                  );
                }),
          ),
          accountButton(),
        ],
      ),
    );
  }

  Widget invisibleSubMenus() {
    // List<CDM> _cmds = cdms..removeAt(0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 0 : 125,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(height: 95),
          Expanded(
            child: ListView.builder(
                itemCount: cdms.length,
                itemBuilder: (context, index) {
                  CDM cmd = cdms[index];
                  // if(index==0) return Container(height:95);
                  //controll button has 45 h + 20 top + 30 bottom = 95

                  bool selected = selectedIndex == index;
                  bool isValidSubMenu = selected && cmd.submenus.isNotEmpty;
                  return subMenuWidget(
                      [cmd.title, ...cmd.submenus], isValidSubMenu);
                }),
          ),
        ],
      ),
    );
  }

  Widget controlButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: const FlutterLogo(
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget subMenuWidget(List<String> submenus, bool isValidSubMenu) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: isValidSubMenu ? submenus.length.toDouble() * 37.5 : 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: isValidSubMenu ? complexDrawerBlueGrey : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          )),
      child: ListView.builder(
          padding: const EdgeInsets.all(6),
          itemCount: isValidSubMenu ? submenus.length : 0,
          itemBuilder: (context, index) {
            String subMenu = submenus[index];
            return sMenuButton(subMenu, index == 0);
          }),
    );
  }

  Widget sMenuButton(String subMenu, bool isTitle) {
    return InkWell(
      onTap: () {
        //handle the function
        //if index==0? donothing: doyourlogic here
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Txt(
          text: subMenu,
          fontSize: isTitle ? 17 : 14,
          color: isTitle ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget accountButton({bool usePadding = true}) {
    return Padding(
      padding: EdgeInsets.all(usePadding ? 8 : 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.white70,
          // image: DecorationImage(
          //   image: NetworkImage(avatar2),
          //   fit: BoxFit.cover,
          // ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget accountTile() {
    return Container(
      color: complexDrawerBlueGrey,
      child: ListTile(
        leading: accountButton(usePadding: false),
        title: const Txt(
          text: "Prem Shanhi",
          color: Colors.white,
        ),
        subtitle: const Txt(
          text: "Web Designer",
          color: Colors.white70,
        ),
      ),
    );
  }

  static List<CDM> cdms = [
    // CDM(Icons.grid_view, "Control", []),

    CDM(Icons.grid_view, "Dashboard", []),
    CDM(Icons.subscriptions, "Category",
        ["HTML & CSS", "Javascript", "PHP & MySQL"]),
    CDM(Icons.markunread_mailbox, "Posts", ["Add", "Edit", "Delete"]),
    CDM(Icons.pie_chart, "Analytics", []),
    CDM(Icons.trending_up, "Chart", []),

    CDM(Icons.power, "Plugins",
        ["Ad Blocker", "Everything Https", "Dark Mode"]),
    CDM(Icons.explore, "Explore", []),
    CDM(Icons.settings, "Setting", []),
  ];

  void expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}
