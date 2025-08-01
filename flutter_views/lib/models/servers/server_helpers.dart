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
  static List<String> getBasePath() {
    return ["SaffouryPaper2", "public", "index.php", "api", "v1"];
  }

  static String getBaseUrl() {
    if (!kIsWeb) {
      // return 'http://localhost/SaffouryPaper2/index.php';
      return 'localhost';
    }
    if (kIsWeb && kDebugMode) {
      // return 'http://localhost/SaffouryPaper2/index.php';
      return "localhost";
    } else {
      // return 'http://localhost/SaffouryPaper2/index.php';
      return 'localhost';
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
    'Accept': '*/*',
    'Content-Type': 'application/json',

    "Access-Control-Allow-Origin":
        "*", // Required for CORS support to work/ Required for CORS support to work
    "Access-Control-Allow-Credentials":
        'true', // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale,Platform",
    "Access-Control-Allow-Methods": "GET, POST, PUT,DELETE"
  };
}

class OnResponseCallback {
  final void Function(dynamic response)? onServerResponse;
  final void Function()? onServerNoMoreItems;
  final void Function(dynamic o)? onFlutterClientFailure;
  final void Function(String message)? onServerFailureResponse;
  final void Function()? onEmailOrPassword;
  final void Function()? onBlocked;
  final void Function(bool isValid)? onAuthRequired;
  final void Function()? onNoPermission;
  OnResponseCallback(
      {this.onServerNoMoreItems,
      this.onFlutterClientFailure,
      this.onServerResponse,
      this.onServerFailureResponse,
      this.onBlocked,
      this.onAuthRequired,
      this.onNoPermission,
      this.onEmailOrPassword});
}
