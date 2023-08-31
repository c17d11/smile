import 'dart:async';

import 'rate_limit.dart';
import 'rate_measure.dart';

class RateAdjuster {
  RateLimit limit;
  RateMeasure measure;
  late Duration additionalDelay;

  RateAdjuster(this.limit, this.measure, additionalMillisecondsDelay) {
    additionalDelay = Duration(milliseconds: additionalMillisecondsDelay);
  }

  void addRequest() {
    measure.requests++;
  }

  Duration getRateAdjustment() {
    Duration rateAdjustment = limit.duration - measure.sw.elapsed;
    return rateAdjustment;
  }

  bool get isExpired => getRateAdjustment().isNegative;
  bool get isReady => measure.requests == limit.calls - 1;
  bool get isReserved => measure.requests >= limit.calls - limit.reservedCalls;

  Future<void> adjustRate() async {
    Duration rateAdjustment = getRateAdjustment();
    Duration d = rateAdjustment + additionalDelay;
    await Future.delayed(d);
  }
}
