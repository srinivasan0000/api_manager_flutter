import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;
  Function? _lastAction;
  bool _isScheduled = false;
  DateTime? _startTime;
  static Timer? _staticTimer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void call(Function() action) {
    _lastAction = action;
    _timer?.cancel();
    _startTime = DateTime.now();
    _timer = Timer(delay, () {
      _isScheduled = false;
      action();
    });
    _isScheduled = true;
  }

  void cancel() {
    _timer?.cancel();
    _isScheduled = false;
    _startTime = null;
  }

  bool get isScheduled => _isScheduled;

  void executeNow() {
    _timer?.cancel();
    _lastAction?.call();
    _isScheduled = false;
    _startTime = null;
  }

  void reset() {
    _timer?.cancel();
    if (_lastAction != null && _isScheduled) {
      _startTime = DateTime.now();
      _timer = Timer(delay, () {
        _isScheduled = false;
        _lastAction!();
      });
    } else {
      _isScheduled = false;
      _startTime = null;
    }
  }

  Duration? get remainingTime {
    if (_timer?.isActive == true && _startTime != null) {
      final elapsed = DateTime.now().difference(_startTime!);
      return (elapsed < delay) ? delay - elapsed : Duration.zero;
    }
    return null;
  }

  Stream<Duration?> getRemainingTimeStream() async* {
    while (_timer?.isActive == true) {
      yield remainingTime;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    yield null;
  }

  Stream<bool> get isScheduledStream async* {
    yield isScheduled;
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield isScheduled;
    }
  }

  static Future<T> debounce<T>(
    Future<T> Function() function, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    Completer<T> completer = Completer<T>();

    _staticTimer?.cancel();
    _staticTimer = Timer(duration, () async {
      try {
        final result = await function();
        completer.complete(result);
      } catch (error) {
        completer.completeError(error);
      }
    });

    return completer.future;
  }
}
