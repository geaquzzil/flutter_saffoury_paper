part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

class ViewAbstractState extends Equatable {
  ViewAbstractState({
    this.status = PostStatus.initial,
    this.posts = const <ViewAbstract>[],
    this.hasReachedMax = false,
  });

  PostStatus status;
  final List<ViewAbstract> posts;
  final bool hasReachedMax;

  ViewAbstractState copyWith({
    PostStatus? status,
    List<ViewAbstract>? posts,
    bool? hasReachedMax,
  }) {
    return ViewAbstractState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
