import 'package:flutter/cupertino.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master.dart';


@Deprecated("")
class ListActionsProvider with ChangeNotifier {
  final GlobalKey<ListApiMasterState> _listStateKey =
      GlobalKey<ListApiMasterState>();
  GlobalKey<ListApiMasterState> get getListStateKey => _listStateKey;

  void toggleSelectMood() {
    notifyListeners();
  }

  void notifySelectedItem() {
    notifyListeners();
  }
}
