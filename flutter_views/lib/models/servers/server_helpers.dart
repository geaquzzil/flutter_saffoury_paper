// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

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
  list_reduce_size,
  custom_widget,
  file_import,
  file_export
}

class URLS {
  static String getBaseUrl() {
    if (!kIsWeb) {
      // return 'http://localhost/SaffouryPaper2/index.php';
      return 'localhost/SaffouryPaper2/publicindex.php/api/v1/';
    }
    if (kIsWeb && kDebugMode) {
      // return 'http://localhost/SaffouryPaper2/index.php';
      return 'localhost/SaffouryPaper2/publicindex.php/api/v1/';
    } else {
      // return 'http://localhost/SaffouryPaper2/index.php';
      return 'localhost/SaffouryPaper2/publicindex.php/api/v1/';
    }
  }

  @Deprecated("")
  static String getBaseUrlPrint() {
    if (!kIsWeb) {
      return 'https://saffoury.com/api2/print/index.php';
    }
    if (kIsWeb && kDebugMode) {
      return 'https://saffoury.com/api2/print/index.php';
    } else {
      return 'https://saffoury.com/api2/print/index.php';
    }
  }

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
  final void Function(dynamic response)? onServerResponse;
  final void Function()? onServerNoMoreItems;
  final void Function(dynamic o)? onClientFailure;
  final void Function(String message)? onServerFailureResponse;
  final void Function()? onEmailOrPassword;
  final void Function()? onBlocked;
  OnResponseCallback(
      {required this.onServerNoMoreItems,
      required this.onClientFailure,
      required this.onServerResponse,
      required this.onServerFailureResponse,
      required this.onBlocked,
      required this.onEmailOrPassword});
}
