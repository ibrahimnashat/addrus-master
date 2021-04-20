import 'package:rxdart/rxdart.dart';

abstract class BaseBloc<T> {
  final fetcher = PublishSubject<T>();

  Stream<T> get mainStream => fetcher.stream;

  void emit(T data) {
    fetcher.sink.add(data);
  }

  dispose() {
    fetcher.close();
  }
}
