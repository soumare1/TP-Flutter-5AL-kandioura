import '../models/post_model.dart';

abstract class PostsDataSource {
  Future<List<Post>> getPosts();
  Future<Post> createPost(Post post);
  Future<Post> updatePost(Post post);
  Future<void> deletePost(String id);
}
