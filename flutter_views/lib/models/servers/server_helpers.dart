enum ServerActions {
  print,
  notification,
  list,
  view,
  add,
  edit,
  delete_action,
  file,
  search,
  search_by_field,
  search_viewabstract_by_field,
  call,
}

class URLS {
  static const String BASE_URL =
      'https://saffoury.com/SaffouryPaper2/index.php';
  static const String BASE_URL_PRINT =
      'https://saffoury.com/SaffouryPaper2/print/index.php';
  static const Map<String, String> requsetHeaders2 = {
    'Accept': 'application/json',
    'Accept-Encoding': 'gzip',
    'Content-Type': 'application/json',
    'Access-Control-Allow-Headers':
        'Origin, Content-Type, Cookie, X-CSRF-TOKEN, Accept, Authorization, X-XSRF-TOKEN, Access-Control-Allow-Origin',
    'Access-Control-Expose-Headers': "" 'Authorization, authenticated',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,POST,OPTIONS,DELETE,PUT',
    'Access-Control-Allow-Credentials': 'true',
  };
  static const Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Accept-Encoding': 'gzip',
    "Access-Control-Allow-Origin":
        "*", // Required for CORS support to work/ Required for CORS support to work
    "Access-Control-Allow-Credentials":
        'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,Platform",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS, HEAD"
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
