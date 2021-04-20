class Result<T> {
  Result._();

  factory Result.init() = InitResult<T>;
  factory Result.loading() = LoadingResult<T>;
  factory Result.loadMore(T data) = LoadMoreResult<T>;
  factory Result.success(T data) = SuccessResult<T>;
  factory Result.error(String errorMsg) = ErrorResult<T>;

  T getSuccessData() {
    if (this is SuccessResult) {
      return (this as SuccessResult<T>).data;
    } else if (this is LoadMoreResult) {
      return (this as LoadMoreResult<T>).data;
    }
    return null;
  }

  String getErrorMessage() {
    if (this is ErrorResult) {
      return (this as ErrorResult<T>).errorMsg;
    }
    return null;
  }
}

class InitResult<T> extends Result<T> {
  InitResult() : super._();
}

class LoadingResult<T> extends Result<T> {
  LoadingResult() : super._();
}

class LoadMoreResult<T> extends Result<T> {
  final T data;
  LoadMoreResult(this.data) : super._();
}

class SuccessResult<T> extends Result<T> {
  final T data;
  SuccessResult(this.data) : super._();
}

class ErrorResult<T> extends Result<T> {
  final String errorMsg;
  ErrorResult(this.errorMsg) : super._();
}
