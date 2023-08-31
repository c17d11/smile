import 'dart:async';
import 'package:rate_manager/rate_manager.dart';
import 'package:test/test.dart';

void main() {
  group('Single rate limit', () {
    late RateManger manager;
    setUp(() {
      manager = RateManger(
        [
          RateLimit(3, 2, const Duration(seconds: 1)),
        ],
        secondaryCallTimeoutSeconds: 1,
      );
    });

    test('Corrent value', () async {
      expect(await manager.primaryCall(() => 'yo'), equals('yo'));
      expect(await manager.secondaryCall(() => "yo"), equals('yo'));
    });

    test('Correct delay', () async {
      late Duration d;
      Stopwatch stopwatch = Stopwatch()..start();
      final f1 = manager.primaryCall(() {});
      final f2 = manager.primaryCall(() {});
      final f3 = manager.primaryCall(() {});
      await Future.wait([f1, f2, f3]).then((value) => d = stopwatch.elapsed);
      expect(d, greaterThan(const Duration(seconds: 1)));
    });

    test('Correct delay between all', () async {
      late Duration d1, d2, d3, d4, d5, d6;
      Stopwatch stopwatch = Stopwatch()..start();
      final f1 = manager.primaryCall(() => d1 = stopwatch.elapsed);
      final f2 = manager.primaryCall(() => d2 = stopwatch.elapsed);
      final f3 = manager.primaryCall(() => d3 = stopwatch.elapsed);
      final f4 = manager.primaryCall(() => d4 = stopwatch.elapsed);
      final f5 = manager.primaryCall(() => d5 = stopwatch.elapsed);
      final f6 = manager.primaryCall(() => d6 = stopwatch.elapsed);
      await Future.wait([f1, f2, f3, f4, f5, f6]);

      expect(d3, greaterThan(const Duration(seconds: 1)));
      expect(d4 - d1, greaterThan(const Duration(seconds: 1)));
      expect(d5 - d2, greaterThan(const Duration(seconds: 1)));
      expect(d6 - d3, greaterThan(const Duration(seconds: 1)));
    });

    test('Correct delay only secondary', () async {
      late Duration d1, d2, d3;
      Stopwatch stopwatch = Stopwatch()..start();
      final f1 = manager.secondaryCall(() => d1 = stopwatch.elapsed);
      final f2 = manager.secondaryCall(() => d2 = stopwatch.elapsed);
      final f3 = manager.secondaryCall(() => d3 = stopwatch.elapsed);
      await Future.wait([f1, f2, f3]);

      expect(d2 - d1, greaterThan(const Duration(seconds: 1)));
      expect(d3 - d2, greaterThan(const Duration(seconds: 1)));
    });

    test('Correct order', () async {
      late Duration d1, d2, d3;
      Stopwatch stopwatch = Stopwatch()..start();
      final f1 = manager.primaryCall(() => d1 = stopwatch.elapsed);
      final f2 = manager.secondaryCall(() => d2 = stopwatch.elapsed);
      final f3 = manager.primaryCall(() => d3 = stopwatch.elapsed);
      await Future.wait([f1, f2, f3]);
      expect(d1, lessThan(d3));
      expect(d3, lessThan(d2));
    });
  });

  group('Double rate limit', () {
    late RateManger manager;
    setUp(() {
      manager = RateManger(
        [
          RateLimit(3, 1, const Duration(seconds: 1)),
          RateLimit(5, 2, const Duration(seconds: 2)),
        ],
        secondaryCallTimeoutSeconds: 1,
      );
    });

    test('Correct delay between all', () async {
      late Duration d1, d2, d3, d4, d5, d6;
      Stopwatch stopwatch = Stopwatch()..start();
      final f1 = manager.primaryCall(() => d1 = stopwatch.elapsed);
      final f2 = manager.primaryCall(() => d2 = stopwatch.elapsed);
      final f3 = manager.primaryCall(() => d3 = stopwatch.elapsed);
      final f4 = manager.primaryCall(() => d4 = stopwatch.elapsed);
      final f5 = manager.primaryCall(() => d5 = stopwatch.elapsed);
      final f6 = manager.primaryCall(() => d6 = stopwatch.elapsed);
      await Future.wait([f1, f2, f3, f4, f5, f6]);

      expect(d3, greaterThan(const Duration(seconds: 1)));
      expect(d4 - d1, greaterThan(const Duration(seconds: 1)));
      expect(d5 - d2, greaterThan(const Duration(seconds: 1)));
      expect(d6 - d3, greaterThan(const Duration(seconds: 1)));

      expect(d5, greaterThan(const Duration(seconds: 2)));
      expect(d6 - d1, greaterThan(const Duration(seconds: 2)));
    });

    test('Correct order secondary last', () async {
      late Duration d1, d2, d3, d4, d5, d6;
      Stopwatch stopwatch = Stopwatch()..start();
      final f1 = manager.secondaryCall(() => d1 = stopwatch.elapsed);
      final f2 = manager.primaryCall(() => d2 = stopwatch.elapsed);
      final f3 = manager.secondaryCall(() => d3 = stopwatch.elapsed);
      final f4 = manager.primaryCall(() => d4 = stopwatch.elapsed);
      final f5 = manager.secondaryCall(() => d5 = stopwatch.elapsed);
      final f6 = manager.primaryCall(() => d6 = stopwatch.elapsed);
      await Future.wait([f1, f2, f3, f4, f5, f6]);

      // Since these calls are fast, there will always be 2 calls within
      // the last second. And since at least 1 call is reseverd, no
      // secondary calls can be done unless the number of calls the last
      // second decreases. I.e. those secondary calls are pushed to last.
      expect(d1, lessThan(d2));
      expect(d2, lessThan(d4));
      expect(d4, lessThan(d6));
      expect(d6, lessThan(d3));

      // The order these is uncertain. It depends on the timing of the delay
      // in the loop.
      expect(d3, greaterThan(d6));
      expect(d5, greaterThan(d6));
    });

    test('Correct order secondary between', () async {
      late Duration d1, d2, d3, d4, d5, d6;
      Stopwatch stopwatch = Stopwatch()..start();
      await manager.secondaryCall(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        d1 = stopwatch.elapsed;
      });
      await manager.primaryCall(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        d2 = stopwatch.elapsed;
      });
      await manager.secondaryCall(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        d3 = stopwatch.elapsed;
      });
      await manager.primaryCall(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        d4 = stopwatch.elapsed;
      });
      await manager.secondaryCall(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        d5 = stopwatch.elapsed;
      });
      await manager.primaryCall(() async {
        await Future.delayed(const Duration(milliseconds: 500));
        d6 = stopwatch.elapsed;
      });

      // There will only be one request within the last second.
      // I.e. the secondary calls won't have to wait.
      expect(d1, lessThan(d2));
      expect(d2, lessThan(d3));
      expect(d3, lessThan(d4));
      expect(d4, lessThan(d5));
      expect(d5, lessThan(d6));
    });
  });
}
