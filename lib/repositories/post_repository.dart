import '../models/post.dart';

/// Abstraksi repository untuk mengelola data Post.
abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
}