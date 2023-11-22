import 'dart:async';

import 'package:flutter/material.dart';

enum AppCountDownStatus {
  start,
  end,
  pause,
  restart,
  resume,
  stop;
}

class AppCountDownController extends ChangeNotifier {
  ValueChanged<AppCountDownStatus>? _onValueChanged;

  AppCountDownController(this._onValueChanged);
  late Timer _timer;
  int _durationInSeconds = 0;
  int _remainingTimeInSeconds = 0;
  bool _isRunning = false;

  int get remainingTimeInSeconds => _remainingTimeInSeconds;

  bool get isRunning => _isRunning;

  void start(int durationInSeconds) {
    _durationInSeconds = durationInSeconds;
    _remainingTimeInSeconds = durationInSeconds;
    _isRunning = true;

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remainingTimeInSeconds > 0) {
        _remainingTimeInSeconds--;
        notifyListeners();
      } else {
        stop();
      }
    });
    _onValueChanged?.call(AppCountDownStatus.start);
  }

  void stop() {
    _timer.cancel();
    _remainingTimeInSeconds = _durationInSeconds;
    _isRunning = false;
    notifyListeners();
    _onValueChanged?.call(AppCountDownStatus.stop);
  }

  void pause() {
    _timer.cancel();
    _isRunning = false;
    notifyListeners();
    _onValueChanged?.call(AppCountDownStatus.pause);
  }

  void resume() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remainingTimeInSeconds > 0) {
        _remainingTimeInSeconds--;
        notifyListeners();
      } else {
        stop();
      }
    });
    _isRunning = true;
    notifyListeners();
    _onValueChanged?.call(AppCountDownStatus.resume);
  }

  void restart() {
    _timer.cancel();
    _remainingTimeInSeconds = _durationInSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingTimeInSeconds > 0) {
        _remainingTimeInSeconds--;
        notifyListeners();
      } else {
        stop();
      }
    });
    _isRunning = true;
    notifyListeners();
    _onValueChanged?.call(AppCountDownStatus.restart);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class CountDownTimer extends StatelessWidget {
  const CountDownTimer(
      {super.key, required this.controller, required this.textStyle});
  final AppCountDownController controller;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          int remainingTimeInSeconds = controller.remainingTimeInSeconds;
          return Text(
            remainingTimeInSeconds.toString(),
            style: textStyle,
          );
        },
      ),
    );
  }
}
