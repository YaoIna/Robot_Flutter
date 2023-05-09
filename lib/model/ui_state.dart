abstract class UiState {}

class Initial extends UiState {}

class Loading extends UiState {}

class Success<T> extends UiState {
  final T data;

  Success(this.data);
}

class UiError extends UiState {
  final String message;

  UiError(this.message);
}
