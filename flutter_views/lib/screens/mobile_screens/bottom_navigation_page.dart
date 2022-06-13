import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/action_screens/list_page.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_page.dart';

import '../../models/view_abstract.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState<T extends ViewAbstract>
    extends State<NavigationPage> {
  int _currentIndex = 0;

  _buildTextAndSearchBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getTextLabel(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              IconButton(
                  icon: const Icon(Icons.search),
                  color: Colors.black26,
                  onPressed: () {}),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: getView(),
        )
      ],
    );
  }

  Widget getView() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        PostsPage(),
        //Text("TEST $_currentIndex"),
        Text("TEST $_currentIndex"),
        Text("TEST $_currentIndex")
      ],
    );
  }

  String getTextLabel() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Profile';
      case 2:
        return 'Settings';
      default:
        return 'Home';
    }
  }

  _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const Text('Home');
      case 1:
        return const Text('Profile');
      case 2:
        return const Text('Settings');
      default:
        return const Text('Home');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: _buildTextAndSearchBody(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: ('Search')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: ('Profile')),
          ]));
}
