sealed class Result<T, E> {
  const Result();

  factory Result.success({required T value}) => Success(data: value);

  factory Result.failure({required E error}) => Failure(error: error);

  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) =>
      switch (this) {
        Success<T, E> successState => success(successState.data),
        Failure<T, E> failureState => failure(failureState.error),
      };

  T getOrElse(T defaultValue) {
    return when(
      success: (value) => value,
      failure: (_) => defaultValue,
    );
  }
}

class Success<T, E> extends Result<T, E> {
  const Success({
    required this.data,
  });

  final T data;
}

class Failure<T, E> extends Result<T, E> {
  const Failure({
    required this.error,
  });

  final E error;
}
