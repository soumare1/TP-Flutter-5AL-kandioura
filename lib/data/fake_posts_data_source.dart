import '../models/post_model.dart';
import 'posts_data_source.dart';
import 'dart:math';

class FakePostsDataSource implements PostsDataSource {
  final List<Post> _posts = [
    Post(
      id: '1',
      title: 'Post 1',
      content: 'Description of Post 1',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Post(
      id: '2',
      title: 'Post 2',
      content: 'Description of Post 2',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Post(
      id: '3',
      title: 'Post 3',
      content: 'Description of Post 3',
      createdAt: DateTime.now(),
    ),
  ];

  // Counter to track attempt number for each post
  int _attemptCounter = 0;

  @override
  Future<List<Post>> getPosts() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_posts);
  }

  @override
  Future<Post> createPost(Post post) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Cycle through 3 states
    switch (_attemptCounter % 3) {
      case 0:
        // First attempt: Show error text
        _attemptCounter++;
        throw Exception('ERROR_TEXT_ONLY');
      case 1:
        // Second attempt: Show loading with retry
        _attemptCounter++;
        throw Exception('SHOW_LOADING_STATE');
      case 2:
        // Third attempt: Success with toast
        _attemptCounter++;
        _posts.add(post);
        return post;
      default:
        _posts.add(post);
        return post;
    }
  }

  @override
  Future<Post> updatePost(Post post) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      _posts[index] = post;
      return post;
    }
    throw Exception('Post not found');
  }

  @override
  Future<void> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _posts.removeWhere((post) => post.id == id);
  }
}
