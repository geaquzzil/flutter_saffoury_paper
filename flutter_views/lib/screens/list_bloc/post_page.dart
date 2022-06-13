import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_view_controller/bloc/post_bloc.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_list.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatelessWidget {
  ViewAbstract object;
  PostsPage({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocProvider(
        create: (_) => PostBloc(httpClient: http.Client(), viewAbstract: object)
          ..add(PostFetched()),
        child: PostsList(object: object),
      ),
    );
  }
}
