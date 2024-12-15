import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post_model.dart';

class EditPostScreen extends StatefulWidget {
  final Post? post;

  const EditPostScreen({super.key, this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;
  bool _showLoadingState = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _savePost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      setState(() {
        _errorText = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _showLoadingState = false;
    });

    final postsProvider = Provider.of<PostsProvider>(context, listen: false);

    try {
      if (widget.post != null) {
        // Update existing post
        final updatedPost = Post(
          id: widget.post!.id,
          title: title,
          content: content,
          createdAt: widget.post!.createdAt,
        );
        await postsProvider.updatePost(updatedPost);
      } else {
        await postsProvider.addPost(title, content);
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (e.toString().contains('ERROR_TEXT_ONLY')) {
            _errorText = 'Une erreur est survenue lors de la création du post';
            _showLoadingState = false;
          } else if (e.toString().contains('SHOW_LOADING_STATE')) {
            _showLoadingState = true;
            _errorText = null;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post == null ? 'New Post' : 'Edit Post',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter post title',
                errorText: _errorText,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter post content',
                alignLabelWithHint: true,
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            if (_showLoadingState) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Pas de connexion internet',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _savePost,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePost,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          widget.post == null ? 'Create Post' : 'Update Post',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
