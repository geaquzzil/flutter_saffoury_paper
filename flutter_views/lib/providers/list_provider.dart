import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';

class ListProvider with ChangeNotifier {
  // All movies (that will be displayed on the Home screen)
  final List<ViewAbstract> objects = [];

  // Retrieve all movies
  List<ViewAbstract> get getObjects => objects;

  // Adding a movie to the favorites list
  void addToList(ViewAbstract movie) {
    objects.add(movie);
    notifyListeners();
  }

  // Removing a movie from the favorites list
  void removeFromList(ViewAbstract movie) {
    objects.remove(movie);
    notifyListeners();
  }
}
