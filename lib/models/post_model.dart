import 'package:flutter/foundation.dart';
import '../data/posts_data_source.dart';
import 'post_state.dart';

class Post {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}

class PostsProvider extends ChangeNotifier {
  final PostsDataSource _dataSource;
  List<Post> _posts = [];
  PostState _state = PostState.initial();

  PostsProvider(this._dataSource);

  List<Post> get posts => _posts;
  PostState get state => _state;

  Future<void> loadPosts() async {
    try {
      _state = PostState.loading();
      notifyListeners();

      _posts = await _dataSource.getPosts();
      _state = PostState.success(isEmpty: _posts.isEmpty);
      notifyListeners();
    } catch (e) {
      _state = PostState.error('Failed to load posts: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> addPost(String title, String content) async {
    try {
      _state = PostState.loading();
      notifyListeners();

      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
      );

      await _dataSource.createPost(post);
      _posts = await _dataSource.getPosts();
      _state = PostState.success(isEmpty: _posts.isEmpty);
      notifyListeners();
    } catch (e) {
      _state = PostState.error('Failed to create post: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> updatePost(Post post) async {
    try {
      _state = PostState.loading();
      notifyListeners();

      await _dataSource.updatePost(post);
      _posts = await _dataSource.getPosts();
      _state = PostState.success(isEmpty: _posts.isEmpty);
      notifyListeners();
    } catch (e) {
      _state = PostState.error('Failed to update post: ${e.toString()}');
      notifyListeners();
    }
  }

  Future<void> deletePost(String id) async {
    try {
      _state = PostState.loading();
      notifyListeners();

      await _dataSource.deletePost(id);
      _posts = await _dataSource.getPosts();
      _state = PostState.success(isEmpty: _posts.isEmpty);
      notifyListeners();
    } catch (e) {
      _state = PostState.error('Failed to delete post: ${e.toString()}');
      notifyListeners();
    }
  }
}
