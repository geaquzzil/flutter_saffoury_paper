import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_view_controller/bloc/post_bloc.dart';
import 'package:flutter_view_controller/providers/view_abstract_provider.dart';
import 'package:flutter_view_controller/screens/list_bloc/bottom_loader.dart';
import 'package:provider/provider.dart';

class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => _onScroll());
    Provider.of<DrawerViewAbstractProvider>(context, listen: false)
        .addListener(() {
          
      print("ViewAbstractProvider CHANGED");
      context
          .read<PostBloc>()
          .clearList(context.read<DrawerViewAbstractProvider>().getObject);
    });
    //    = Provider.of<ViewAbstractProvider>(context, listen = false);
    //object = context.watch<ViewAbstractProvider>().getObject;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, ViewAbstractState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            if (state.posts.isEmpty) {
              return const Center(
                  child: Text('failed to fetchis emppty posts'));
            } else {
              return const Center(
                  child: Text('failed to fetch not empyy posts'));
            }
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: ListView.builder(
                controller: _scrollController,

                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.posts.length
                      ? BottomLoader()
                      : state.posts[index].getCardView(context);
                },
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,

                // physics: const PageScrollPhysics(),
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
