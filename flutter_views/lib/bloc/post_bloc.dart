import 'dart:async';
import 'dart:convert' as convert;
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_view_controller/models/servers/server_helpers.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, ViewAbstractState> {
  int page = 0;
  final http.Client httpClient;
  ViewAbstract viewAbstract;
  PostBloc({required this.httpClient, required this.viewAbstract})
      : super(ViewAbstractState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }
  void clearList(ViewAbstract viewAbstract) {
    this.viewAbstract = viewAbstract;

    page = 0;
    this.viewAbstract.setPageIndex = 0;
    state.posts.clear();
    state.status = PostStatus.initial;
    add(PostFetched());
  }

  Future<void> _onPostFetched(
      PostFetched event, Emitter<ViewAbstractState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      page++;
      viewAbstract.setPageIndex = page;
      final posts = await _fetchPosts();
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<T>> _fetchPosts<T extends ViewAbstract>(
      [int startIndex = 0]) async {
    var response = await viewAbstract.getRespones(
        onResponse: null, serverActions: ServerActions.list);

    if (response == null) throw Exception('error fetching posts');
    if (response.statusCode == 200) {
      Iterable l = convert.jsonDecode(response.body);
      return List<T>.from(
          l.map((model) => viewAbstract.fromJsonViewAbstract(model)));
    } else if (response.statusCode == 401) {
      return throw Exception('error fetching posts');
    } else {
      return throw Exception('error fetching posts');
    }

    // final response = await httpClient.get(
    //   Uri.https(
    //     URLS.BASE_URL,
    //     '/index.php',
    //     <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
    //   ),
    // );
    // if (response.statusCode == 200) {
    //   final body = json.decode(response.body) as List;
    //   return body.map((dynamic json) {
    //     return Post(
    //       id: json['id'] as int,
    //       title: json['title'] as String,
    //       body: json['body'] as String,
    //     );
    //   }).toList();
    // }
    // throw Exception('error fetching posts');
  }
}
