import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_view_controller/bloc/post_bloc.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_list.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PostsPage extends StatelessWidget {
  ViewAbstract viewAbstract;
  PostsPage({Key? key, required this.viewAbstract}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final viewAbstractProvider =
    //     Provider.of<ViewAbstractProvider>(context, listen: false);

    return BlocProvider(
      create: (_) => PostBloc(
          httpClient: http.Client(),
          viewAbstract: viewAbstract)
        ..add(PostFetched()),
      child: const PostsList(),
    );
  }
}
