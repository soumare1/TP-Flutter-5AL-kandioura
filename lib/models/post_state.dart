enum PostStatus {
  initial,
  loading,
  success,
  error,
}

class PostState {
  final PostStatus status;
  final String? error;
  final bool isEmpty;

  const PostState({
    this.status = PostStatus.initial,
    this.error,
    this.isEmpty = false,
  });

  // Initial state when the app starts
  factory PostState.initial() => const PostState();

  // Loading state when fetching data
  factory PostState.loading() => const PostState(
        status: PostStatus.loading,
      );

  // Success state with data
  factory PostState.success({required bool isEmpty}) => PostState(
        status: PostStatus.success,
        isEmpty: isEmpty,
      );

  // Error state when something goes wrong
  factory PostState.error(String message) => PostState(
        status: PostStatus.error,
        error: message,
      );

  // Helper method to check if state is loading
  bool get isLoading => status == PostStatus.loading;

  // Helper method to check if state is success
  bool get isSuccess => status == PostStatus.success;

  // Helper method to check if state is error
  bool get isError => status == PostStatus.error;

  // Helper method to check if state is empty
  bool get isEmptySuccess => isSuccess && isEmpty;

  // Create a copy of the current state with some updated fields
  PostState copyWith({
    PostStatus? status,
    String? error,
    bool? isEmpty,
  }) {
    return PostState(
      status: status ?? this.status,
      error: error ?? this.error,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  String toString() {
    return 'PostState(status: $status, error: $error, isEmpty: $isEmpty)';
  }
}
