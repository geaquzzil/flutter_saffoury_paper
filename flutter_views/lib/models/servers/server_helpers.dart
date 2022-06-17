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
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials":
        'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS"
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
