import 'dart:convert';

import 'package:flutter_view_controller/bloc/model/post.dart';
import 'package:http/http.dart' as http;

class PostApi {
  static const String _domain = "jsonplaceholder.typicode.com";
  static const String _path = "/posts";

  static Future<List<Post>> fetchPost(int start, int limit) async {
    final response = await http.get(
      Uri.https(
        _domain,
        _path,
        {"_start": "$start", "_limit": "$limit"},
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch post");
    }

    final json = jsonDecode(response.body) as List;
    return json.map<Post>((post) => Post.fromJson(post)).toList();
  }
}
