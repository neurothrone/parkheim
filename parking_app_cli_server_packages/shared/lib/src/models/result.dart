sealed class Result<T, E> {
  const Result();

  factory Result.success({required T value}) => Success(data: value);

  factory Result.failure({required E reason}) => Failure(error: reason);
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

typedef ResultValue = int;

void main(List<String> arguments) {
  final r = Result<ResultValue, String>.success(value: 17);
  final f = Result<ResultValue, String>.failure(reason: "Can't do this");

  switch (r) {
    case Success(data: var data):
      print("Success, value '${data}'");
    case Failure():
      print("Failure, reason '${r.error}'");
  }

  print(switch (f) {
    Success(data: var d) => "Success, value '${d}'",
    Failure(error: var r) => "Failure, reason '${r}'",
  });
}

enum ActionStatus {
  success,
  notFound,
  validationFailed,
  databaseError,
  unknownError,
}
