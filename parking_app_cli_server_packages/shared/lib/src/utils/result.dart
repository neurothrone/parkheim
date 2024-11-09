sealed class Result<T, E> {
  const Result();

  factory Result.success({required T value}) => Success(data: value);

  factory Result.failure({required E error}) => Failure(error: error);

  R when<R>({
    required R Function(T data) success,
    required R Function(E error) failure,
  }) {
    if (this is Success<T, E>) {
      return success((this as Success<T, E>).data);
    } else if (this is Failure<T, E>) {
      return failure((this as Failure<T, E>).error);
    }

    throw StateError("Unhandled Result state");
  }

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
