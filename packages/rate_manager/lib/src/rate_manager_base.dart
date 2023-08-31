import 'dart:async';

import 'package:mutex/mutex.dart';

import 'rate_limit.dart';
import 'rate_measure.dart';
import 'rate_adjuster.dart';

class RateManger {
  final m = Mutex();
  List<RateLimit> limits;
  List<RateAdjuster> adjustments = [];
  int secondaryCallTimeoutSeconds;
  int secondaryCallLoopDelayMilliseconds;
  int additionalMillisecondsDelay;

  RateManger(
    this.limits, {
    this.secondaryCallTimeoutSeconds = 60,
    this.secondaryCallLoopDelayMilliseconds = 100,
    this.additionalMillisecondsDelay = 1,
  });

  void _addNewAdjustments() {
    adjustments.addAll(limits.map(
        (e) => RateAdjuster(e, RateMeasure(), additionalMillisecondsDelay)));
  }

  void _addCallToAdjustments() {
    for (var element in adjustments) {
      element.addRequest();
    }
  }

  List<RateAdjuster> _getReadyAdjustments() {
    return adjustments.where((e) => e.isReady).toList();
  }

  List<RateAdjuster> _getReservedAdjustments() {
    return adjustments.where((e) => e.isReserved).toList();
  }

  void _removeStoppedAdjustments() {
    adjustments.removeWhere((e) => e.isExpired);
  }

  Future<void> _adjustRate() async {
    List<RateAdjuster> adjustmentsToPerform = _getReadyAdjustments();
    for (RateAdjuster adjuster in adjustmentsToPerform) {
      await adjuster.adjustRate();
    }
  }

  Future<dynamic> _call(Function f) async {
    await _adjustRate();
    var ret = await f();
    _addCallToAdjustments();
    _removeStoppedAdjustments();
    _addNewAdjustments();
    return ret;
  }

  Future<dynamic> primaryCall(Function f) async {
    late dynamic ret;
    await m.protect(() async {
      ret = await _call(f);
    });
    return ret;
  }

  Future<dynamic> secondaryCall(Function f) async {
    late dynamic ret;
    bool doContinue = true;
    while (doContinue) {
      await m.protect(() async {
        _removeStoppedAdjustments();
        List<RateAdjuster> reservedAdjustments = _getReservedAdjustments();
        if (reservedAdjustments.isEmpty) {
          ret = await _call(f);
          doContinue = false;
        }
      });
      await Future.delayed(
          Duration(milliseconds: secondaryCallLoopDelayMilliseconds));
    }

    return ret;
  }
}
