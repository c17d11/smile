import 'package:rate_manager/rate_manager.dart';

Future<void> exampleOneRateLimit({int delay = 1}) async {
  RateLimit limit = RateLimit(3, 0, const Duration(seconds: 1));

  final rateManger = RateManger([limit], additionalMillisecondsDelay: delay);

  print('''
----------------------------------------------------------
Example 1: One rate limit (3 calls / 1 sec)

RateManager delays function calls.
The last function call should not be executed before 1 sec
passed since the first function call.
  ''');
  Stopwatch stopwatch = Stopwatch();
  await Future.wait([
    rateManger.primaryCall(() {
      print('First function call done:  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    rateManger.primaryCall(
        () => print('Second function call done: ${stopwatch.elapsed}')),
    rateManger.primaryCall(
        () => print('Third function call done:  ${stopwatch.elapsed}')),
  ]);
  stopwatch.stop();
  print('''
----------------------------------------------------------\n
  ''');
}

Future<void> exampleTwoRateLimits() async {
  RateLimit limit1 = RateLimit(3, 0, const Duration(seconds: 1));
  RateLimit limit2 = RateLimit(4, 0, const Duration(seconds: 2));

  final rateManger = RateManger([limit1, limit2]);
  print('''
----------------------------------------------------------
Example 2: Two rate limits (3 calls / 1 sec) and (4 calls / 2 sec)

First 3 calls will take atleast 1 sec and the forth should not be
done before 2 sec has passed.
  ''');
  Stopwatch stopwatch = Stopwatch();

  await rateManger.primaryCall(() {
    print('First function call done:  ${stopwatch.elapsed}');
    stopwatch.start();
  });
  await rateManger.primaryCall(() {
    print('Second function call done: ${stopwatch.elapsed}');
  });
  await rateManger.primaryCall(() {
    print('Third function call done:  ${stopwatch.elapsed}');
  });
  await rateManger.primaryCall(() {
    print('Forth function call done:  ${stopwatch.elapsed}');
  });
  stopwatch.stop();
  print('''
----------------------------------------------------------\n
  ''');
}

Future<void> exampleThreeSecondary() async {
  RateLimit limit = RateLimit(3, 1, const Duration(seconds: 1));

  var rateManger = RateManger([limit]);

  Stopwatch stopwatch = Stopwatch()..start();

  print('''
----------------------------------------------------------
Example 3: One rate limit (3 calls and 1 reserved / 1 sec)

Using 'secondaryCall' will ensure there is always room for 1 call with
'primaryCall'.

The 'primaryCall' is priortized.
  ''');
  await Future.wait([
    rateManger.secondaryCall(() {
      print('First function call done (secondary):  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    rateManger.secondaryCall(() {
      print('Second function call done (secondary):  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    rateManger.secondaryCall(() {
      print('Third function call done (secondary):  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    rateManger.primaryCall(() {
      print('Forth function call done (primary):  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    rateManger.primaryCall(() {
      print('Fifth function call done (primary):  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    rateManger.secondaryCall(() {
      print('Sixth function call done (secondary):  ${stopwatch.elapsed}');
      stopwatch.start();
    }),
    Future.delayed(
        const Duration(milliseconds: 100),
        () => rateManger.primaryCall(() {
              print(
                  'Seventh function call done (primary):  ${stopwatch.elapsed}');
              stopwatch.start();
            })),
  ]);
  print('''
----------------------------------------------------------\n
  ''');
}

Future<void> exampleFourLimitation() async {
  print('''
----------------------------------------------------------
Example 4: Limitation. If a group of function calls is done after
another then the delay is sometimes too short.

I can not figure it out why. The delay should be long enough but
the elapsed time is still shorter than the delay.

Maybe Dart does some caching or maybe some async functions gets executed
a bit too early and get the wrong time.

For now it seems enough to add like 1 ms additional delay.

Below some examples run without the additional delay.
  ''');
  print('''
----------------------------------------------------------\n
  ''');
  await exampleOneRateLimit(delay: 0);
  await exampleOneRateLimit(delay: 0);
  await exampleOneRateLimit(delay: 0);
  await exampleOneRateLimit(delay: 0);
  await exampleOneRateLimit(delay: 0);
}

void main() async {
  await exampleOneRateLimit();
  await exampleTwoRateLimits();
  await exampleThreeSecondary();
  await exampleFourLimitation();
}
