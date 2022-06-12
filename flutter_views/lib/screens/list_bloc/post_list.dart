import 'package:flutter/material.dart';
import 'package:flutter_view_controller/bloc/post_bloc.dart';
import 'package:flutter_view_controller/screens/list_bloc/bottom_loader.dart';
import 'package:flutter_view_controller/screens/list_bloc/post_detail.dart';

class PostList extends StatelessWidget {
  const PostList({
    Key? key,
    required this.scrollController,
    required this.state,
  }) : super(key: key);

  final ScrollController scrollController;
  final PostLoaded state;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount:
          state.hasReachedMax ? state.posts.length : state.posts.length + 1,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index >= state.posts.length) return const BottomLoader();

        return ListTile(
          leading: Text(state.posts[index].id.toString()),
          title: Text(
            state.posts[index].title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            state.posts[index].body,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetail(post: state.posts[index]),
              ),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        thickness: 1,
      ),
    );
  }
}
