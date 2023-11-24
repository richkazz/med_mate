class Result<T extends Object> {
  Result({this.data, required this.isSuccessful, required this.errorMessage});

  final T? data;
  final bool isSuccessful;
  final String? errorMessage;
}

class ResultService {
  Result<T> successful<T extends Object>(T data) {
    return Result<T>(data: data, isSuccessful: true, errorMessage: null);
  }

  Result<T> error<T extends Object>(String errorMessage) {
    return Result<T>(isSuccessful: false, errorMessage: errorMessage);
  }
}
