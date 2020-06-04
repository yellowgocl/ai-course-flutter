import 'dart:async';

/**
 * 倒计时工具
 */
class CountdownUtil {
  DateTime _begin;
  Timer _timer;
  Duration _duration;
  Duration _remainingTime;
  bool isPaused = false;
  StreamController<Duration> _controller;
  Duration _refresh;
  int _everyTick, counter = 0;
  StreamSubscription<Duration> _subscription;
  Function _onData;
  Function _onDone;
  Function _onError;

  Stream<Duration> get stream => _controller.stream;

  StreamSubscription<Duration> get subscription{
    if (_subscription == null) {
      _subscription = stream.listen(null);
    }
    return _subscription;
  }

  CountdownUtil(Duration duration, {Duration refresh: const Duration(milliseconds: 10), int everyTick: 1, onData, onDone, onError}) {
    _refresh = refresh;
    _everyTick = everyTick;
    _duration = duration;
    _onData = onData;
    _onDone = onDone;
    _onError = onError;
    _controller = StreamController<Duration>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel
    );
    subscription.onData((Duration d) {
      // print((d));
      this?._onData(d);
    });
    subscription.onDone(() {
      this?._onDone();
    });
  }

  dispose() {
    if (!_controller.isClosed) {
      subscription.cancel();
      _timer?.cancel();
      _timer = null;
      _controller?.close();
      _subscription = null;
      _controller = null;
    }
  }

  start() {
    _begin = DateTime.now();
    _timer = Timer.periodic(_refresh, _tick);
  }

  stop() {
    _timer.cancel();
    _onDone();
  }

  pause() {
    subscription.pause();
  }

  resume() {
    subscription.resume();
  }

  _onListen() {
    isPaused = false;
  }

  _onPause() {
    isPaused = true;
    _timer.cancel();
    _timer = null;
    print('countdown pause!');
  }

  _onResume() {
    _begin = DateTime.now();
    _duration = _remainingTime;
    isPaused = false;
    _timer = Timer.periodic(_refresh, _tick);
    print('countdown resume!');
  }

  _onCancel() {
    if (!isPaused) {
      _timer?.cancel();
      _timer = null;
    }
    print('countdown cancel!');
  }

  void _tick(Timer timer) {
    counter++;
    Duration alreadyConsumed = DateTime.now().difference(_begin);
    _remainingTime = _duration - alreadyConsumed;
    if (_remainingTime.isNegative) {
      timer.cancel();
      timer = null;
      this?._onDone();
      // _controller.close();
    } else {
      if (counter % _everyTick == 0) {
        _controller.add(this._remainingTime);
        counter = 0;
      }
    }
  }
}