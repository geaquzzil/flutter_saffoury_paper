enum ServerActions {
  print,
  notification,
  list,
  view,
  add,
  edit,
  delete_action,
  file
}

class URLS {
  static const String BASE_URL =
      'https://saffoury.com/SaffouryPaper2/index.php';

  static const Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Accept-Encoding': 'gzip',
  };
}

class OnResponseCallback {
  final void Function() onServerNoMoreItems;
  final void Function(dynamic o) onServerFailure;
  final void Function(dynamic o) onServerFailureResponse;
  OnResponseCallback(
      {required this.onServerNoMoreItems,
      required this.onServerFailure,
      required this.onServerFailureResponse});
}
