import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';
import '../models/post_state.dart';
import 'edit_post_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PostsProvider>().loadPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Posts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<PostsProvider>(
        builder: (context, postsProvider, child) {
          final state = postsProvider.state;

          if (state.status == PostStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == PostStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error ?? 'Unknown error occurred',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      postsProvider.loadPosts();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final posts = postsProvider.posts;

          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No posts yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Create your first post by tapping the + button',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditPostScreen(post: post),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Theme.of(context).colorScheme.secondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPostScreen(post: post),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        color: Color(0xFFE74C3C),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Color(0xFFE74C3C),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    postsProvider.deletePost(post.id);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: const Text('Post deleted'),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          post.content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Created on ${post.createdAt.day}/${post.createdAt.month}/${post.createdAt.year}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditPostScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text(
          'New Post',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
